const { map, test, propSatisfies, pipe } = require("ramda");
const { tryP, parallel, of } = require("fluture");
const asn1 = require("asn1.js");
const jws = require("jws");
const url = require("url");
const urlBase64 = require("urlsafe-base64");

const subscriptions = require("../db/subscriptions.js");
const logger = require("./logger.js");
const { validateSubscription } = require("./helpers.js");
const sendNotification = require("./sendPushNotification.js");

const {
  MY_EMAIL,
  VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY
} = require("../config.js");

// Error -> Boolean
const isRegistrationError = propSatisfies(test(/NotRegistered/), "message");

// String -> Future Err Res
const removeSubscription = endpoint => {
  logger("PUSH_UNSUB", endpoint);
  return subscriptions.delete(endpoint);
};

// Object -> Future Err Res
const addSubscription = newSub =>
  validateSubscription(newSub).chain(sub =>
    subscriptions.set(sub.endpoint, JSON.stringify(sub))
  );

/* eslint-disable fp/no-this */
const ECPrivateKeyASN = asn1.define("ECPrivateKey", function() {
  return this.seq().obj(
    this.key("version").int(),
    this.key("privateKey").octstr(),
    this.key("parameters")
      .explicit(0)
      .objid()
      .optional(),
    this.key("publicKey")
      .explicit(1)
      .bitstr()
      .optional()
  );
});
/* eslint-enable fp/no-this */

// (String, String, String) -> String
const createWebPushJwt = (subscriptionEndpoint, subject, privateKey) => {
  const { protocol, host } = url.parse(subscriptionEndpoint);

  // 24HRS from now in seconds.
  // https://self-issued.info/docs/draft-ietf-oauth-json-web-token.html#expDef
  const DEFAULT_EXPIRATION = Math.floor(Date.now() / 1000) + 86400;

  const jwtHeader = {
    typ: "JWT",
    alg: "ES256"
  };

  const jwtPayload = {
    aud: `${protocol}//${host}`,
    exp: DEFAULT_EXPIRATION,
    sub: subject
  };

  const jwtPrivateKey = ECPrivateKeyASN.encode(
    {
      version: 1,
      privateKey: urlBase64.decode(privateKey),
      parameters: [1, 2, 840, 10045, 3, 1, 7] // prime256v1
    },
    "pem",
    { label: "EC PRIVATE KEY" }
  );

  return jws.sign({
    header: jwtHeader,
    payload: jwtPayload,
    privateKey: jwtPrivateKey
  });
};

// (String, String) -> Future Err Res
const send = (title, body) =>
  subscriptions.all
    .map(
      map(
        pipe(JSON.parse, sub =>
          // Can't encase as needs 4 arguments.
          tryP(() =>
            sendNotification(
              sub,
              JSON.stringify({ title, body }),
              createWebPushJwt(
                sub.endpoint,
                `mailto:${MY_EMAIL}`,
                VAPID_PRIVATE_KEY
              ),
              VAPID_PUBLIC_KEY
            )
          ).chainRej(
            err =>
              // Intercept (but log) errors,
              // and delete subscription if registration is invalid.
              isRegistrationError(err)
                ? removeSubscription(sub.endpoint)
                : of(logger("PUSH_ERROR", err.message))
          )
        )
      )
    )
    .chain(parallel(20));

module.exports = {
  addSubscription,
  removeSubscription,
  send
};

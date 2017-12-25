const crypto = require("crypto");
const urlBase64 = require("urlsafe-base64");
const fetch = require("node-fetch");
const ece = require("http_ece");

// 2419200s === 4 weeks
const DEFAULT_TTL = 2419200;

const webPushError = (statusCode, headers, body, endpoint) =>
  new Error(
    "Received unexpected response code:\n" +
      `Status Code: ${statusCode}\n` +
      `Headers: ${JSON.stringify(headers)}\n` +
      `Body: ${body}\n` +
      `Endpoint: ${endpoint}`
  );

module.exports =
  // (Object, String, String, String) -> Promise Err Object
  (subscription, payload, jwt, vapidPublicKey) => {
    const bufferPayload = Buffer.from(payload);

    const localCurve = crypto.createECDH("prime256v1");
    const localPublicKey = localCurve.generateKeys();

    const salt = urlBase64.encode(crypto.randomBytes(16));

    const cipherText = ece.encrypt(bufferPayload, {
      version: "aesgcm",
      privateKey: localCurve,
      dh: subscription.keys.p256dh,
      authSecret: subscription.keys.auth,
      salt: salt
    });

    return fetch(subscription.endpoint, {
      method: "POST",
      body: cipherText,
      headers: {
        TTL: DEFAULT_TTL,
        Authorization: `WebPush ${jwt}`,
        Encryption: `salt=${salt}`,
        "Content-Length": cipherText.length,
        "Content-Type": "application/octet-stream",
        "Content-Encoding": "aesgcm",
        "Crypto-Key": `dh=${urlBase64.encode(
          localPublicKey
        )};p256ecdsa=${vapidPublicKey}`
      }
    }).then(res =>
      res.text().then(
        text =>
          res.status === 201
            ? Promise.resolve({
                statusCode: res.status,
                body: text,
                headers: res.headers
              })
            : Promise.reject(
                webPushError(
                  res.status,
                  res.headers,
                  text,
                  subscription.endpoint
                )
              )
      )
    );
  };

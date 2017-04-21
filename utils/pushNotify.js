'use strict'

const { map, test, propSatisfies } = require('ramda')
const { Future, parallel, node, of } = require('fluture')
const wp = require('web-push')
const joi = require('joi')

const redis = require(`${ROOT}/db/redis.js`)

const { MY_EMAIL, VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY } = require(`${ROOT}/config.js`)

// Object -> Future Err Object
const validateSubscription = sub =>
  node(
    done =>
      joi.validate(
        sub,
        joi.object().keys({
          endpoint: joi.string(),
          keys: joi.object().keys({
            p256dh: joi.string(),
            auth: joi.string()
          }).requiredKeys('p256dh', 'auth')
        }).requiredKeys('endpoint', 'keys'),
        done
      )
  )

const isRegistrationError = propSatisfies(test(/NotRegistered/), 'message')

const vapidAuth = {
  vapidDetails: {
    subject: `mailto:${MY_EMAIL}`,
    publicKey: VAPID_PUBLIC_KEY,
    privateKey: VAPID_PRIVATE_KEY
  }
}

// String -> Future Err Res
const removeSubscription =
  endpoint =>
    redis.delete(endpoint)

// Object -> Future Err Res
const addSubscription = newSub =>
  validateSubscription(newSub)
  .chain(
    sub =>
      redis.set(
        sub.endpoint,
        JSON.stringify(sub)
      )
  )

// String -> String -> Future Err Res
const send = (title = 'HEY', body = '') =>
  redis.all
  .map(map(JSON.parse))
  .map(map(
    sub =>
      // Can't use fromPromise due to web-push design.
      Future( (rej, res) =>
        void wp.sendNotification(
          sub,
          JSON.stringify({ title, body }),
          vapidAuth
        )
        .then( res, rej )
      )
      .chainRej(
        err =>
          // Intercept (but log) errors,
          // and delete subscription if registration is invalid.
          isRegistrationError(err)
            ? removeSubscription(sub.endpoint)
            : of(console.log(err))
      )
  ))
  .chain( parallel( 20 ) )

module.exports = {
  addSubscription,
  removeSubscription,
  send
}

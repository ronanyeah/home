'use strict'

const { map, test, propSatisfies } = require('ramda')
const { Future, parallel, of } = require('fluture')
const wp = require('web-push')

const subscriptions = require(`${ROOT}/db/subscriptions.js`)
const logger = require(`${ROOT}/utils/logger.js`)
const { validateSubscription } = require(`${ROOT}/server/helpers.js`)

const { MY_EMAIL, VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY } = require(`${ROOT}/config.js`)

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
    subscriptions.delete(endpoint)

// Object -> Future Err Res
const addSubscription = newSub =>
  validateSubscription(newSub)
  .chain(
    sub =>
      subscriptions.set(
        sub.endpoint,
        JSON.stringify(sub)
      )
  )

// String -> String -> Future Err Res
const send = (title = 'HEY', body = '') =>
  subscriptions.all
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
            : of(logger('PUSH_ERROR', err))
      )
  ))
  .chain( parallel( 20 ) )

module.exports = {
  addSubscription,
  removeSubscription,
  send
}

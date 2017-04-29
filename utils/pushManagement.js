'use strict'

const { map, test, propSatisfies, pipe } = require('ramda')
const { fromPromise3, parallel, of } = require('fluture')

const subscriptions = require(`${ROOT}/db/subscriptions.js`)
const logger = require(`${ROOT}/utils/logger.js`)
const { validateSubscription } = require(`${ROOT}/server/helpers.js`)
const sendNotification = fromPromise3(require(`${ROOT}/utils/sendPushNotification.js`))

const { MY_EMAIL, VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY } = require(`${ROOT}/config.js`)

const vapidDetails = {
  subject: `mailto:${MY_EMAIL}`,
  publicKey: VAPID_PUBLIC_KEY,
  privateKey: VAPID_PRIVATE_KEY
}

// Error -> Boolean
const isRegistrationError = propSatisfies(test(/NotRegistered/), 'message')

// String -> Future Err Res
const removeSubscription =
  endpoint => {
    logger('PUSH_UNSUB', endpoint)
    return subscriptions.delete(endpoint)
  }

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

// (String, String) -> Future Err Res
const send = (title, body) =>
  subscriptions.all
  .map(map(
    pipe(
      JSON.parse,
      sub =>
        sendNotification(
          sub,
          JSON.stringify({ title, body }),
          vapidDetails
        )
        .chainRej(
          err =>
            // Intercept (but log) errors,
            // and delete subscription if registration is invalid.
            isRegistrationError(err)
              ? removeSubscription(sub.endpoint)
              : of(logger('PUSH_ERROR', err.message))
        )
    )
  ))
  .chain( parallel( 20 ) )

module.exports = {
  addSubscription,
  removeSubscription,
  send
}

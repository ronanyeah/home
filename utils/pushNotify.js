'use strict'

const { map } = require('ramda')
const { Future, parallel, node, of, reject } = require('fluture')
const wp = require('web-push')
const joi = require('joi')

const db = require(`${ROOT}/db/sqlite.js`)

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

const formatSubscription =
  ({ endpoint, p256dh, auth }) =>
    ({
       endpoint,
       keys: {
         p256dh,
         auth
       }
    })

const ALREADY_SUBSCRIBED_ERROR =
  'SQLITE_CONSTRAINT: UNIQUE constraint failed: subscriptions.endpoint'

module.exports = ( myEmail, vapidPublicKey, vapidPrivateKey ) => {

  const vapidAuth = {
    vapidDetails: {
      subject: `mailto:${myEmail}`,
      publicKey: vapidPublicKey,
      privateKey: vapidPrivateKey
    }
  }

  // String -> Future Err Res
  const removeSubscription = endpoint =>
    db.run(
      'DELETE FROM subscriptions WHERE endpoint = ?',
      endpoint
    )

  // Object -> Future Err Res
  const addSubscription = newSub =>
    validateSubscription(newSub)
    .chain(
      sub =>
        db.run(
          'INSERT INTO subscriptions VALUES (?, ?, ?)',
          [ sub.endpoint, sub.keys.p256dh, sub.keys.auth ]
        )
        .chainRej(
          err =>
            err.message === ALREADY_SUBSCRIBED_ERROR
              ? of('OK')
              : reject(err)
        )
    )

  // String -> String -> Future Err Res
  const send = (title = 'HEY', body = '') =>
    db.all('SELECT * FROM subscriptions')
    .map(map(formatSubscription))
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
          err => (
            removeSubscription(sub.endpoint)
            .chain(
              _ =>
                Future.reject(err)
            )
          )
        )
    ))
    .chain( parallel( 20 ) )

  return {
    addSubscription,
    removeSubscription,
    send
  }
}

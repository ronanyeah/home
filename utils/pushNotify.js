'use strict'

const { readFileSync, existsSync, writeFileSync } = require('fs')
const { map, append, reject, propEq } = require('ramda')
const { both, Future, parallel, of, node } = require('fluture')
const { json } = require('rotools')
const wp = require('web-push')
const joi = require('joi')

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

module.exports = ( subscriptionsPath, vapidKeysPath ) => {

  existsSync(subscriptionsPath)
    ? false
    : writeFileSync(
        subscriptionsPath,
        '[]'
      )

  existsSync(vapidKeysPath)
    ? false
    : writeFileSync(
        vapidKeysPath,
        // Generate new keys.
        JSON.stringify( wp.generateVAPIDKeys() )
      )

  const vapidKeys = JSON.parse( readFileSync(vapidKeysPath) )

  const vapidAuth = {
    vapidDetails: {
      subject: 'mailto:hey@ronanmccabe.me',
      publicKey: vapidKeys.publicKey,
      privateKey: vapidKeys.privateKey
    }
  }

  // String -> Future Err Res
  const removeSubscription = endpoint =>
    json.read(subscriptionsPath)
    .map(
      reject(
        propEq('endpoint', endpoint)
      )
    )
    .chain(
      json.write(subscriptionsPath)
    )

  // Object -> Future Err Res
  const addSubscription = newSub =>
    both(
      validateSubscription(newSub),
      json.read(subscriptionsPath)
    )
    .chain(
      ([ validSub, subscriptions ]) =>
          subscriptions.find(
            propEq('endpoint', validSub.endpoint)
          )
            ? of('already subscribed')
            : json.write(
                subscriptionsPath,
                append(validSub, subscriptions)
              )
    )

  // String -> String -> Future Err Res
  const send = (title = 'HEY', body = '') =>
    json.read(subscriptionsPath)
    .map(
      map(
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
              removeSubscription(sub.endpoint),
              Future.reject(err)
            )
          )
      )
    )
    .chain( parallel( Infinity ) )

  return {
    addSubscription,
    removeSubscription,
    send
  }
}

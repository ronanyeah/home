'use strict'

const { readFileSync, existsSync, writeFileSync } = require('fs')
const { map, append, reject } = require('ramda')
const { generateVAPIDKeys, sendNotification } = require('web-push')
const { Future, parallel, of } = require('fluture')
const { json } = require('rotools')

module.exports = ( subscriptionsPath, vapidKeysPath ) => {

  existsSync(subscriptionsPath)
    ? 0
    : writeFileSync(
        subscriptionsPath,
        '[]'
      )

  existsSync(vapidKeysPath)
    ? 0
    : writeFileSync(
        vapidKeysPath,
        // Generate new keys.
        JSON.stringify( generateVAPIDKeys() )
      )

  const vapidKeys = JSON.parse( readFileSync(vapidKeysPath) )

  const vapidAuth = {
    vapidDetails: {
      subject: 'mailto:hey@ronanmccabe.me',
      publicKey: vapidKeys.publicKey,
      privateKey: vapidKeys.privateKey
    }
  }

  // String -> Object -> Future Err Res
  const removeSubscription = endpoint =>
    json.read(subscriptionsPath)
    .map(
      reject(
        subscription =>
          subscription.endpoint === endpoint
      )
    )
    .chain(
      subs =>
        json.write(subscriptionsPath, subs)
    )

  // String -> Object -> Future Err Res
  const addSubscription = newSub =>
    json.read(subscriptionsPath)
    .chain(
      subscriptions =>
        subscriptions.find(
          subscription =>
            subscription.endpoint === newSub.endpoint
        )
          ? of('already subscribed')
          : json.write(
              subscriptionsPath,
              append(newSub, subscriptions)
            )
    )

  const send = (title = 'HEY', body = '') =>
    json.read(subscriptionsPath)
    .map(
      map(
        sub =>
          Future( (rej, res) =>
            void sendNotification(
              sub,
              JSON.stringify({ title, body }),
              vapidAuth
            )
            .then( res, rej )
          )
      )
    )
    .chain( parallel( Infinity ) )
    .fork( console.log, console.log )
      //forEach(
        //subscription =>
          //sendNotification(
            //subscription,
            //JSON.stringify({ title, body }),
            //vapidAuth
          //)
          //.catch(
            //err => {
              //console.log(err.message)
              //return err.statusCode === 410 // 410 means invalid subscription.
                //? removeSubscription(subscriptionsPath, subscription.endpoint)
                //: 0
            //}
          //)
      //)
    //)

  return {
    addSubscription,
    removeSubscription,
    send
  }
}

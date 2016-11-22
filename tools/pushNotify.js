'use strict'

const fs = require('fs')
const R  = require('ramda')
const wp = require('web-push')

const subscriptionsPath = `${global.ROOT}/private/push_subscriptions.json`
const vapidKeysPath     = `${global.ROOT}/private/vapid_keys.json`

fs.existsSync(subscriptionsPath)
  ? null
  : fs.writeFileSync(
      subscriptionsPath,
      '[]'
    )

fs.existsSync(vapidKeysPath)
  ? null
  : fs.writeFileSync(
      vapidKeysPath,
      JSON.stringify( wp.generateVAPIDKeys() )
    )

const vapidKeys = require(vapidKeysPath)

const readJson = path =>
  JSON.parse( fs.readFileSync(path, 'utf8') )

const removeSubscription = endpoint =>
  fs.writeFileSync(
    subscriptionsPath,
    JSON.stringify(
      readJson(subscriptionsPath)
      .filter(
        subscription =>
          subscription.endpoint !== endpoint
      )
    )
  )

const addSubscription = newSub => {
  const subscriptions = readJson(subscriptionsPath)

  return subscriptions.find(
    subscription =>
      subscription.endpoint === newSub.endpoint
  )
    ? null
    : fs.writeFileSync(
        subscriptionsPath,
        JSON.stringify( R.append(newSub, subscriptions) )
      )
}

const push = (title = 'HEY', body = '') =>
  readJson(subscriptionsPath)
  .forEach(
    subscription =>
      wp.sendNotification(
        subscription,
        JSON.stringify({ title, body }),
        {
          vapidDetails: {
            subject: 'mailto:hey@ronanmccabe.me',
            publicKey: vapidKeys.publicKey,
            privateKey: vapidKeys.privateKey
          }
        }
      )
      .catch(
        err => {
          console.log(err.message)
          return err.statusCode === 410 // 410 means invalid subscription.
            ? removeSubscription(subscription.endpoint)
            : null
        }
      )
  )

module.exports = {
  addSubscription,
  removeSubscription,
  push
}

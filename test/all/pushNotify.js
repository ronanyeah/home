'use strict'

const { propEq, find } = require('ramda')
const { unlinkSync } = require('fs')
const test = require('tape')
const nock = require('nock')
const { json } = require('rotools')

const fixture = {
  endpoint: 'https://fcm.googleapis.com/fcm/send/c1slhPnRmPI:APA91bEfPk0HCB81375oPF7znPfwu2tsP2oqQaoItRK_9dVjTPoeWqf25yqd8HypHUbLb2ihRcSxvzY95QOztwMGwjv4hpaWGXKEgFfq36UiloxwDIOxidCM0eaXYPZGaxVWH_qCEfw6',
  keys: {
    p256dh: 'BKnCOXRjCRi_IqBW85LThKIQSxWOB2RgvtU6BQMjWqSLxAo5kx2J7NACJE5pT_0TozR3EWFdAtJgvbI1H8v9m50=',
    auth: '855R1TZOdb_n0oamMH4fOg=='
  }
}

const subscriptionsPath = `${ROOT}/test/scrap/push_subscriptions.json`
const vapidKeysPath = `${ROOT}/test/scrap/vapid_keys.json`

// [Subscription] -> Boolean
const fixtureIsSubscribed =
  find(propEq('endpoint', fixture.endpoint))

const push = require(`${ROOT}/utils/pushNotify.js`)(
  subscriptionsPath,
  vapidKeysPath
)

nock('https://fcm.googleapis.com')
.post(RegExp(fixture.auth))
.reply( 201 )

test('pushNotify', t => (
  t.plan(3),

  push.addSubscription(fixture)
  .chain(
    () =>
      json.read(subscriptionsPath)
      .map(
        subs =>
          t.ok(fixtureIsSubscribed(subs), 'subscription has been added')
      )
  )
  .chain(
    () =>
      push.send('title', 'body')
      .map( () => t.pass('push send ok') )
  )
  .chain(
    () =>
      push.removeSubscription(fixture.endpoint)
  )
  .chain(
    () =>
      json.read(subscriptionsPath)
      .map(
        subs =>
          t.notOk(fixtureIsSubscribed(subs), 'subscription has been removed')
      )
  )
  .fork(
    t.fail,
    () => (
      unlinkSync(subscriptionsPath),
      unlinkSync(vapidKeysPath)
    )
  )
) )

'use strict'

const { propEq, find } = require('ramda')
const { unlinkSync } = require('fs')
const test = require('tape')

const { json } = require('rotools')

const stub = { endpoint: 'FOO' }
const subscriptionsPath = `${ROOT}/test/scrap/push_subscriptions.json`
const vapidKeysPath = `${ROOT}/test/scrap/vapid_keys.json`

// [Subscription] -> Boolean
const stubIsSubscribed =
  find(propEq('endpoint', stub.endpoint))

const push = require(`${ROOT}/utils/pushNotify.js`)(
  subscriptionsPath,
  vapidKeysPath
)

test('subscriptions', t => (
  t.plan(2),
  push.addSubscription(stub)
  .chain(
    () => json.read(subscriptionsPath)
  )
  .map(
    subs =>
      t.ok(stubIsSubscribed(subs), 'subscription has been added')
  )
  .chain(
    () =>
      push.removeSubscription(stub.endpoint)
  )
  .chain(
    () => json.read(subscriptionsPath)
  )
  .map(
    subs =>
      t.ok(!stubIsSubscribed(subs), 'subscription has been removed')
  )
  .fork(
    t.fail,
    () => (
      unlinkSync(subscriptionsPath),
      unlinkSync(vapidKeysPath)
    )
  )
) )

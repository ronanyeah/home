'use strict'

const test = require('tape')
const shot = require('shot')

const { getContentType, bodyReader, validateSubscription } = require(`${ROOT}/server/helpers.js`)

const BODY_PAYLOAD = 'TEST_PAYLOAD'

const VALID_SUBSCRIPTION = {
  endpoint: 'https://fcm.googleapis.com/fcm/send/c1slhPnRmPI:APA91bEfPk0HCB81375oPF7znPfwu2tsP2oqQaoItRK_9dVjTPoeWqf25yqd8HypHUbLb2ihRcSxvzY95QOztwMGwjv4hpaWGXKEgFfq36UiloxwDIOxidCM0eaXYPZGaxVWH_qCEfw6',
  keys: {
    p256dh: 'BKnCOXRjCRi_IqBW85LThKIQSxWOB2RgvtU6BQMjWqSLxAo5kx2J7NACJE5pT_0TozR3EWFdAtJgvbI1H8v9m50=',
    auth: '855R1TZOdb_n0oamMH4fOg=='
  }
}

test('misc', t => (
  t.plan(5),

  t.equals(
    getContentType('/folder/index.js'),
    'application/javascript',
    'content type'
  ),

  t.equals(
    getContentType('/.vimrc'),
    'text/plain',
    'default content type'
  ),

  validateSubscription(VALID_SUBSCRIPTION)
  .fork(
    t.fail,
    sub =>
      t.deepEqual(sub, VALID_SUBSCRIPTION, 'sub validation ok')
  ),

  validateSubscription({ not: 'ok' })
  .fork(
    err =>
      t.ok(err, 'sub validation fail ok'),
    t.fail
  ),

  shot.inject(
    (req, res) =>
      bodyReader(req)
      .fork(
        t.fail,
        data =>
          t.equals(String(data), BODY_PAYLOAD, 'body parser')
      ),
    {
      url: '/foo',
      payload: BODY_PAYLOAD
    }
  )
) )

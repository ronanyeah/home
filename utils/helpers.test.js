'use strict'

// eslint-disable-next-line fp/no-mutation
global.ROOT = process.env.ROOT

const shot = require('shot')

const { range, urlBase64ToIntArray, getContentType, bodyReader, validateSubscription } = require(`${ROOT}/utils/helpers.js`)

const BODY_PAYLOAD = 'TEST_PAYLOAD'

const fail = x => expect(x).toBeUndefined()

const VALID_SUBSCRIPTION = {
  endpoint: 'https://fcm.googleapis.com/fcm/send/c1slhPnRmPI:APA91bEfPk0HCB81375oPF7znPfwu2tsP2oqQaoItRK_9dVjTPoeWqf25yqd8HypHUbLb2ihRcSxvzY95QOztwMGwjv4hpaWGXKEgFfq36UiloxwDIOxidCM0eaXYPZGaxVWH_qCEfw6',
  keys: {
    p256dh: 'BKnCOXRjCRi_IqBW85LThKIQSxWOB2RgvtU6BQMjWqSLxAo5kx2J7NACJE5pT_0TozR3EWFdAtJgvbI1H8v9m50=',
    auth: '855R1TZOdb_n0oamMH4fOg=='
  }
}

const vapidPublicKey = 'BHaFjARni1eMQdZvF64iSj1O5_NptJmhxEXF7Zux7P_q6gyVoSSZDez2pG8LrlBZB3v8Rg1Kcgsjfqbb9i9hn8k'

const vapidIntArray = [4, 118, 133, 140, 4, 103, 139, 87, 140, 65, 214, 111, 23, 174, 34, 74, 61, 78, 231, 243, 105, 180, 153, 161, 196, 69, 197, 237, 155, 177, 236, 255, 234, 234, 12, 149, 161, 36, 153, 13, 236, 246, 164, 111, 11, 174, 80, 89, 7, 123, 252, 70, 13, 74, 114, 11, 35, 126, 166, 219, 246, 47, 97, 159, 201]

describe('helpers', () =>

  test('getContentType .js', () =>
    expect(getContentType('/folder/index.js'))
    .toBe('application/javascript')
  ),

  test('getContentType default', () =>
    expect(getContentType('/folder/.vimrc'))
    .toBe('text/plain')
  ),

  test('sub validation ok', () =>
    validateSubscription(VALID_SUBSCRIPTION)
    .promise()
    .then(
      sub =>
        expect(sub).toEqual(VALID_SUBSCRIPTION)
    )
    .catch(fail)
  ),

  test('sub validation fail', () =>
    validateSubscription({ not: 'ok' })
    .promise()
    .then(fail)
    .catch( err => expect(err).toBeTruthy() )
  ),

  test('range', () => expect(range(3)).toEqual([0, 1, 2])),

  test('urlBase64ToIntArray', () =>
    expect(urlBase64ToIntArray(vapidPublicKey)).toEqual(vapidIntArray)
  ),

  test('body parse', () =>
    shot.inject(
      (req, _res) =>
        bodyReader(req)
        .promise()
        .then(
          data =>
            expect(String(data)).toBe(BODY_PAYLOAD)
        )
        .catch(fail),
      {
        url: '/foo',
        payload: BODY_PAYLOAD
      }
    )
  )
)

'use strict'

const { of } = require('fluture')
const { json } = require('rotools')

const { MY_EMAIL, VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY } = require(`${ROOT}/config.js`)
const { sendFile } = require(`${ROOT}/server/helpers.js`)
const push = require(`${ROOT}/utils/pushNotify.js`)(
  MY_EMAIL,
  VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY
)

module.exports = {

  '/':
    () =>
      sendFile(`${ROOT}/public/main/index.html`),

  '/push':
    () =>
      push.send('TEST PUSH', Date())
      .map(
        _ =>
          ({
            statusCode: 200
          })
      ),

  '/pwa':
    () =>
      sendFile(`${ROOT}/public/pwa/index.html`),

  '/toys':
    () =>
      sendFile(`${ROOT}/public/toys/index.html`),

  '/cv':
    () =>
      sendFile(`${ROOT}/public/cv.html`),

  '/ping':
    () =>
      of({
        payload: JSON.stringify({ alive: true }),
        contentType: 'application/json',
        statusCode: 200
      }),

  '/config':
    () =>
      json.read(`${ROOT}/private/vapid_keys.json`)
      .map(
        keys =>
          ({
            payload: JSON.stringify({ applicationServerKey: keys.publicKey }),
            contentType: 'application/json',
            statusCode: 200
          })
      ),

  '/fourOhFour':
    () =>
      of({
        payload: '<p style="font-size: 10vh; text-align: center;">404!</p>',
        contentType: 'text/html',
        statusCode: 404
      })

}

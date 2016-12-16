'use strict'

const { of } = require('fluture')
const { json } = require('rotools')
const { prop } = require('ramda')

const { sendFile } = require(`${ROOT}/server/helpers.js`)
const push = require(`${ROOT}/utils/pushNotify.js`)(
  `${ROOT}/private/push_subscriptions.json`,
  `${ROOT}/private/vapid_keys.json`
)

module.exports = {

  '/':
    () =>
      sendFile(`${ROOT}/client/public/main/index.html`),

  '/push':
    () =>
      push.send('TEST PUSH', Date())
      .map(
        () =>
          ({
              statusCode: 200
          })
      ),

  '/pencils':
    () =>
      sendFile(`${ROOT}/client/public/pencils/index.html`),

  '/pwa':
    () =>
      sendFile(`${ROOT}/client/public/pwa/index.html`),

  '/cv':
    () =>
      sendFile(`${ROOT}/client/public/cv.html`),

  '/cloud':
    () =>
      sendFile(`${ROOT}/client/public/word-cloud/index.html`),

  '/reveal':
    () =>
      sendFile(`${ROOT}/client/public/web-crypto/index.html`),

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
      .map( prop('publicKey') )
      .map(
        publicKey =>
          ({
            payload: JSON.stringify({ applicationServerKey: publicKey }),
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

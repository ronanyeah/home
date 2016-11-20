'use strict'

const co = require('co')

const { sendFile } = require(`${global.ROOT}/server/helpers.js`)
const sendPush = require(`${global.ROOT}/tools/pushNotify.js`)

// Synchronous handlers must be promisified.
module.exports = {

  '/':
    sendFile(`${global.ROOT}/client/public/main/index.html`),

  '/push':
    co.wrap(function* (req, res) {
      sendPush('TEST PUSH', Date())

      res.writeHead(200)
      return res.end()
    }),

  '/pencils':
    sendFile(`${global.ROOT}/client/public/pencils/index.html`),

  '/pwa':
    sendFile(`${global.ROOT}/client/public/pwa/index.html`),

  '/cv':
    sendFile(`${global.ROOT}/client/public/cv.html`),

  '/cloud':
    sendFile(`${global.ROOT}/client/public/word-cloud/index.html`),

  '/reveal':
    sendFile(`${global.ROOT}/client/public/web-crypto/index.html`),

  '/ping':
    co.wrap(function* (req, res) {
      res.writeHead(200, { 'Content-Type': 'application/json' })
      return res.end( JSON.stringify({ alive: true }) )
    }),

  '/config':
    co.wrap(function* (req, res) {
      const vapid = require(`${global.ROOT}/private/vapid_keys.json`)
      res.writeHead(200, { 'Content-Type': 'application/json' })
      return res.end( JSON.stringify({ applicationServerKey: vapid.publicKey }) )
    }),

  '/fourOhFour':
    co.wrap(function* (req, res) {
      res.writeHead(404, { 'Content-Type': 'text/html' })
      return res.end('<p style="font-size: 10vh; text-align: center;">404!</p>')
    })

}

'use strict'

const co = require('co')
const { sendFile } = require('./helpers.js')

// Synchronous handlers must be promisified.
module.exports = {

  '/':
    sendFile(`${global.ROOT}/client/public/main/index.html`),

  '/pencils':
    sendFile(`${global.ROOT}/client/public/pencils/index.html`),

  '/cloud':
    sendFile(`${global.ROOT}/client/public/word-cloud/index.html`),

  '/reveal':
    sendFile(`${global.ROOT}/client/public/web-crypto/index.html`),

  '/ping':
    co.wrap(function* (req, res) {
      res.writeHead(200, { 'Content-Type': 'application/json' })
      return res.end( JSON.stringify({ alive: true }) )
    }),

  '/fourOhFour':
    co.wrap(function* (req, res) {
      res.writeHead(404, { 'Content-Type': 'text/html' })
      return res.end('<p style="font-size: 10vh; text-align: center;">404!</p>')
    })

}

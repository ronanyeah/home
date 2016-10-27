'use strict'

const { promisify, sendFile } = require('./helpers.js')

// Synchronous handlers must be promisified.
module.exports = {

  '/': sendFile('/index.html'),

  '/pencils': sendFile('/pencils.html'),

  '/ping':
    promisify(
      (req, res) => {
        res.writeHead(200, { 'Content-Type': 'application/json' })
        return res.end(JSON.stringify({ alive: true }))
      }
    ),

  '/fourOhFour':
    promisify(
      (req, res) => {
        res.writeHead(404, { 'Content-Type': 'text/html' })
        return res.end('<p style="font-size: 10vh; text-align: center;">404!</p>')
      }
    )

}

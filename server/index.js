'use strict'

if (process.env.NODE_ENV === 'production') {
  require('newrelic')
}

if (process.env.NODE_ENV === 'development') {
  require('dotenv').config()
}

const http = require('http')
const https = require('https')
const { resolve } = require('path')
const { parse } = require('url')
const { red, green, blue, yellow } = require('chalk')

// SET PROJECT ROOT
global.ROOT = resolve(`${__dirname}/..`) // eslint-disable-line fp/no-mutation

// CONFIG
const { HTTPS, PORT } = require(`${ROOT}/config.js`)

const router = require(`${ROOT}/server/router.js`)
const logger = require(`${ROOT}/utils/logger.js`)

const server =
  HTTPS
    ? https.createServer(HTTPS)
    : http.createServer()

server
.listen(PORT)
.on(
  'listening',
  () =>
    logger(
      'SERVER_START',
      `${ red( HTTPS ? 'https' : 'http' ) } ${ blue('server listening on port') } ${ green(PORT) }\n`
    )
)
.on(
  'request',
  (req, res) => (
    console.log(yellow(req.method), green(req.url)),

    [
      // Synchronous middleware.
    ]
    .forEach(
      mw =>
        mw( req, res )
    ),

    router( req.method, parse(req.url).pathname )( req, res )
    .fork(
      err => (
        logger('REQUEST_ERROR', err),
        res.writeHead(500, { 'Content-Type': 'text/html' }),
        res.end('<p style="font-size: 10vh; text-align: center;">Server Error!</p>')
      ),

      ({ payload, contentType, statusCode }) => (
        res.writeHead(
          statusCode,
          payload
            ? {
                'Content-Type': contentType,
                'Content-Length': payload.length
              }
            : {}
        ),
        res.end(payload)
      )
    )
  )
)

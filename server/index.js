'use strict'

const http = require('http')
const https = require('https')
const { resolve } = require('path')
const { parse } = require('url')
const { green, blue, yellow } = require('colors')

global.ROOT = resolve(`${__dirname}/..`) // eslint-disable-line fp/no-mutation

const errorLogger = require(`${ROOT}/utils/errorLogger.js`)
const dnsCheck = require(`${ROOT}/utils/dnsCheck.js`)
const router = require(`${ROOT}/server/router.js`)

// CONFIG
const { HTTPS, PORT, IP_SYNC } = require(`${ROOT}/server/config.js`)

IP_SYNC
  ? setInterval(
      () =>
        // Synchronise public IP address changes w/ Cloudflare.
        dnsCheck
        .fork(errorLogger, console.log),
      300000
    )
  : false

const server =
  HTTPS
    ? https.createServer(HTTPS)
    : http.createServer()

server
.listen(PORT)
.on(
  'listening',
  () =>
    console.log(
      `\n${ blue('server listening on port') } ${ green(PORT) }\n`
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
        errorLogger(err),
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

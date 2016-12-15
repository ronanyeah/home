'use strict'

const http = require('http')
const https = require('https')
const { resolve } = require('path')
const { parse } = require('url')
const { reject } = require('ramda')
const { readFileSync, existsSync } = require('fs')
const { green, blue, yellow } = require('colors')

global.ROOT = resolve(`${__dirname}/..`)

// Ensures support files exist.
;(
  missingFiles =>
    missingFiles.length
      ? (
          console.log(`\nFiles missing!\n${missingFiles.join('\n')}\n`),
          process.exit()
        )
      : 0
)
(
  reject(
    existsSync,
    [
      `${ROOT}/private/mailConfig.json`,
      `${ROOT}/private/cloudflareConfig.json`,
      `${ROOT}/private/server.key`,
      `${ROOT}/private/server.crt`
    ]
  )
)

const errorLogger = require(`${ROOT}/utils/errorLogger.js`)
const dnsCheck = require(`${ROOT}/utils/dnsCheck.js`)
const router = require(`${ROOT}/server/router.js`)
const server =
  process.env.NODE_ENV === 'development'
    ? http.createServer()
    : https.createServer(
        {
          key: readFileSync(`${ROOT}/private/server.key`, 'utf8'),
          cert: readFileSync(`${ROOT}/private/server.crt`, 'utf8')
        }
      )

// Keep an eye on IP address changes.
process.env.NODE_ENV === 'development'
  ? 0
  : setInterval(
      () =>
        dnsCheck
        .fork(errorLogger, console.log),
        300000
    )

server
.listen(
  process.env.PORT || 443
)
.on(
  'listening',
  () =>
    console.log(
      `\n${ blue('server listening on port') } ${ green(server.address().port) }\n`
    )
)
.on( 'request',
  (req, res) => (
    console.log(yellow(req.method), green(req.url)),

    [
      // Synchronous Middleware
    ]
    .forEach(
      mw =>
        mw( req, res )
    ),

    router( req.method, parse(req.url).pathname )( req, res )
    .fork(
      err => (
        errorLogger(err),
        res.writeHead(500),
        res.end()
      ),

      ({ payload, contentType, statusCode }) => (
        res.writeHead(
          statusCode,
          payload
            ? {
                'Content-Type': contentType
              }
            : undefined
        ),
        res.end(payload)
      )
    )
  )
)

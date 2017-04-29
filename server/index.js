'use strict'

if (process.env.NODE_ENV === 'production') {
  require('newrelic')
}

const http = require('http')
const { parse } = require('url')
const { red, green, blue, yellow } = require('chalk')

// CONFIG
const { PORT } = require('./config.js')

const router = require('./router.js')
const logger = require('./utils/logger.js')

http.createServer()
.listen(PORT)
.on(
  'listening',
  () =>
    logger(
      'SERVER_START',
      `${ red('http') } ${ blue('server listening on port') } ${ green(PORT) }\n`
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
        logger('REQUEST_ERROR', `${err.message} / ${req.url}`),
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

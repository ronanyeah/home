'use strict'

const http  = require('http')
const https = require('https')
const fs    = require('fs')
const path  = require('path')

global.ROOT = path.resolve(`${__dirname}/../`)

// Check that support files exist.
require(`${global.ROOT}/tools/checkForSupportFiles`)(
  [
    `${global.ROOT}/private/mailConfig.json`,
    `${global.ROOT}/private/cloudflareConfig.json`,
    `${global.ROOT}/private/pvt.pem`,
    `${global.ROOT}/private/cert.pem`
  ]
)

const router = require(`${global.ROOT}/server/router.js`)
const server =
    process.env.NODE_ENV === 'development'
      ? http.createServer()
      : https.createServer(
          {
            key: fs.readFileSync(`${global.ROOT}/private/pvt.pem`, 'utf8'),
            cert: fs.readFileSync(`${global.ROOT}/private/cert.pem`, 'utf8')
          }
        )

server
.listen(
  process.env.PORT || 443
)
.on(
  'listening',
  _ =>
    console.log(
      `\n${
         process.env.NODE_ENV === 'development' ? 'http' : 'https'
       } server listening on port ${ server.address().port }`
    )
)
.on( 'request', router )

// START UTILITY SCRIPTS
fs.readdirSync(`${global.ROOT}/scripts/`)
.forEach(
  file =>
    // Run every five minutes.
    setInterval(require(`${global.ROOT}/scripts/${file}`), 300000)
)

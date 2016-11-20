'use strict'

const fs    = require('fs')
const path  = require('path')

global.ROOT = path.resolve(`${__dirname}/../`)

require(`${global.ROOT}/tools/checkForSupportFiles`)(
  [
    `${global.ROOT}/private/mailConfig.json`,
    `${global.ROOT}/private/cloudflareConfig.json`,
    `${global.ROOT}/private/pvt.pem`,
    `${global.ROOT}/private/cert.pem`
  ]
)

const { http, https } = require(`${global.ROOT}/server/server.js`)

const server =
  process.env.NODE_ENV === 'development'
    ? http
    : https(
        fs.readFileSync(`${global.ROOT}/private/pvt.pem`),
        fs.readFileSync(`${global.ROOT}/private/cert.pem`)
      )

const port = process.env.PORT || 443

server.listen(
  port,
  _ => {
    console.log(
      `${
         process.env.NODE_ENV === 'development' ? 'http' : 'https'
       } server listening on port ${port}`
    )

    return fs.readdirSync(`${global.ROOT}/scripts/`)
    .forEach(
      file =>
        // Run every five minutes.
        setInterval(require(`${global.ROOT}/scripts/${file}`), 300000)
    )
  }
)

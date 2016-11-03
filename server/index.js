'use strict'

const https = require('https')
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

const router = require(`${global.ROOT}/server/router.js`)

const port = process.env.PORT || 443

https.createServer(
  {
    key: fs.readFileSync(`${global.ROOT}/private/pvt.pem`),
    cert: fs.readFileSync(`${global.ROOT}/private/cert.pem`)
  },
  (req, res) =>
    router( req.method )( req.url )( req, res )
    .catch( err => { // all errors are to be caught here
      console.log(err)
      res.writeHead(500, { 'Content-Type': 'text/plain' })
      res.end( 'Oops!' )
    })
)
.listen(
  port,
  _ => {
    console.log(`https server listening on port ${port}`)

    fs.readdirSync(`${global.ROOT}/scripts/`)
    .forEach(
      file =>
        setInterval(require(`${global.ROOT}/scripts/${file}`), 300000)
    )   // Run every five minutes.
  }
)

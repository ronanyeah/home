'use strict'

const https = require('https')
const fs    = require('fs')

const { ipAddressCheckIn } = require(`${__dirname}/cloudflare.js`)
const routing              = require(`${__dirname}/routing.js`)

const port = process.env.PORT || 443

// check for log file and
// create if necessary
try {
  fs.lstatSync(`${__dirname}/ipLog.json`)
} catch (err) {
  fs.writeFileSync(
    `${__dirname}/ipLog.json`, JSON.stringify({ ip: '0.0.0.0' })
  )
}

// ensure config files and https certs exist
[
  `${__dirname}/mailConfig.json`,
  `${__dirname}/cloudflareConfig.json`,
  `${__dirname}/pvt.pem`,
  `${__dirname}/cert.pem`
]
.forEach(
  file => {
    try {
      fs.lstatSync(file)
    } catch (err) {
      console.log(`'${file}' is missing!`)
      process.exit()
    }
  }
)

https.createServer(
  {
    key: fs.readFileSync(`${__dirname}/pvt.pem`),
    cert: fs.readFileSync(`${__dirname}/cert.pem`)
  },
  (req, res) =>
    routing( req.url )( req, res )
    .catch( err => { // all errors are to be caught here
      console.log(err)
      res.writeHead(500, { 'Content-Type': 'text/html' })
      res.end( 'Oops!' )
    } )
)
.listen(
  port,
  _ => {
    console.log(`https server listening on port ${port}`)
    // Check every five minutes.
    setInterval(ipAddressCheckIn, 300000)
  }
)

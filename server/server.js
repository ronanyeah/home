'use strict'

const http  = require('http')
const https = require('https')
const url   = require('url')

const publicFolder = `${global.ROOT}/client/public`

const assets = require(`${global.ROOT}/tools/assetIndexer.js`)(publicFolder)

const { sendFile } = require(`${global.ROOT}/server/helpers.js`)
const { error } = require(`${global.ROOT}/server/handlers/index.js`)

const router = require(`${global.ROOT}/server/router.js`)

const handler = (req, res) =>
  req.method === 'GET' && assets.includes(url.parse(req.url).pathname)
    ? sendFile(publicFolder + req.url)(req, res)
      .catch( err => error(err)(req, res) )
    : router( req.method, url.parse(req.url).pathname )(req, res)
      .catch( err => error(err)(req, res) )

module.exports = {
  http:
    http.createServer(handler),
  https:
    (privateKey, cert) =>
      https.createServer(
        {
          key: privateKey,
          cert: cert
        },
        handler
      )
}

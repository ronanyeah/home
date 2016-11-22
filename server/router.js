'use strict'

const R = require('ramda')
const url   = require('url')
const publicFolder = `${global.ROOT}/client/public`

const handlers = require(`${global.ROOT}/server/handlers/index.js`)
const assets = require(`${global.ROOT}/tools/assetIndexer.js`)(publicFolder)
const { sendFile } = require(`${global.ROOT}/server/helpers.js`)
const { error } = require(`${global.ROOT}/server/handlers/index.js`)

module.exports =
  (req, res) =>
    req.method === 'GET' && assets.includes( url.parse(req.url).pathname )
      ? sendFile(publicFolder + req.url)(req, res)
        .catch( err => error(err)(req, res) )
      : (
          R.path(
            [ req.method, url.parse(req.url).pathname ],
            handlers
          ) || handlers['GET']['/fourOhFour']
        )(req, res)
        .catch( err => error(err)(req, res) )

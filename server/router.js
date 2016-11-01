'use strict'

const publicFolder = `${global.ROOT}/client/public`

const handlers = require(`${global.ROOT}/server/handlers.js`)
const views    = Object.keys( handlers )
const assets   = require(`${global.ROOT}/tools/assetIndexer.js`)(publicFolder)

const { sendFile } = require('./helpers.js')

const methods = {
  GET:
    path =>
      views.includes(path) // resolve view paths
        ? handlers[path]
        : assets.includes(path) // resolve asset paths
            ? sendFile(publicFolder + path)
            : handlers['/fourOhFour']
}

// The Router:
module.exports =
  method =>
    methods[method] ||
    ( _ => handlers['/fourOhFour'] )

'use strict'

const R        = require('ramda')
const bluebird = require('bluebird')
const fs       = bluebird.promisifyAll( require('fs') )

const assetFolder = `${__dirname}/../client/public`

const availableAssets = fs.readdirSync(assetFolder)

const views        = require('./handlers.js')
const { sendFile } = require('./helpers.js')

// The Router:
// Accepts a path and must return a handler that takes (req, res).
module.exports =
  path =>
    R.contains( // resolve view paths
      path,
      R.keys(views)
    )
      ? views[path]
      : R.contains( // resolve asset paths
          R.drop(1, path), // remove leading slash
          availableAssets
        )
          ? sendFile(path)
          : views['/fourOhFour']

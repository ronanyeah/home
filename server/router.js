'use strict'

const { pathOr } = require('ramda')
const { fileMapper } = require('rotools')

const handlers = require('./handlers/index.js')
const { sendFile } = require('./utils/helpers.js')
const { PUBLIC_FOLDER } = require('./config.js')

const assetPaths = fileMapper(PUBLIC_FOLDER)

// String -> String -> Future Err Function
module.exports =
  (method, pathname) =>
    method === 'GET' && assetPaths.includes( PUBLIC_FOLDER + pathname )
      ? () => sendFile( PUBLIC_FOLDER + pathname )
      : pathOr(
          handlers['GET']['/fourOhFour'],
          [ method, pathname ],
          handlers
        )

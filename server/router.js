'use strict'

const { pathOr } = require('ramda')
const { fileMapper } = require('rotools')

const handlers = require(`${ROOT}/server/handlers/index.js`)
const { sendFile } = require(`${ROOT}/server/helpers.js`)

const publicFolder = `${ROOT}/public`

const assetPaths = fileMapper(publicFolder)

// String -> String -> Future Err Function
module.exports =
  (method, pathname) =>
    method === 'GET' && assetPaths.includes( publicFolder + pathname )
      ? () => sendFile( publicFolder + pathname )
      : pathOr(
          handlers['GET']['/fourOhFour'],
          [ method, pathname ],
          handlers
        )

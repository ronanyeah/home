'use strict'

const { path, map, drop } = require('ramda')
const { fileMapper }      = require('rotools')

const handlers = require(`${ROOT}/server/handlers/index.js`)
const { sendFile } = require(`${ROOT}/server/helpers.js`)

const publicFolder = `${ROOT}/client/public`
const assetPaths =
  map(
    drop(publicFolder.length),
    fileMapper(publicFolder)
  )

// String -> String -> Future Err Function
module.exports =
  (method, pathname) =>
    method === 'GET' && assetPaths.includes( pathname )
      ? () => sendFile( publicFolder + pathname )
      : path(
          [ method, pathname ],
          handlers
        ) || handlers['GET']['/fourOhFour']

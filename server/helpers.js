'use strict'

const { node } = require('fluture')
const { fromMaybe, get, pipe } = require('sanctuary')
const { parse } = require('path')
const { __, invoker } = require('ramda')
const { readFile } = require('fs')
const hl = require('highland')

// Accepts an asset path and returns a 'Content-Type'.
// String -> String
const getContentType =
  pipe([
    parse,
    get(String, 'ext'),
    invoker(
      1,
      'chain'
    )(
      get(
        String,
        __,
        {
          '.js': 'application/javascript',
          '.json': 'application/json',
          '.html': 'text/html',
          '.css': 'text/css',
          '.ico': 'image/x-icon',
          '.png': 'image/png',
          '.jpg': 'image/jpg'
        }
      )
    ),
    fromMaybe('text/plain')
  ])

// Request -> Future Err Body
const bodyReader = req =>
  node( done => hl(req).toCallback(done) )

// String -> Future Err Response
const sendFile =
  path =>
    node(
      done =>
        readFile( path, done )
    )
    .map(
      content =>
        ({
          payload: content,
          contentType: getContentType(path),
          statusCode: 200
        })
    )

module.exports = {
  getContentType,
  sendFile,
  bodyReader
}

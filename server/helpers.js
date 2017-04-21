'use strict'

const { node } = require('fluture')
const { parse } = require('path')
const { __, prop, propOr, pipe } = require('ramda')
const { readFile } = require('fs')
const hl = require('highland')
const joi = require('joi')

// Accepts an asset path and returns a 'Content-Type'.
// String -> String
const getContentType =
  pipe(
    parse,
    prop('ext'),
    propOr(
      'text/plain',
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
  )

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

// a -> Future Err a
const validateSubscription = sub =>
  node(
    done =>
      joi.validate(
        sub,
        joi.object().keys({
          endpoint: joi.string(),
          keys: joi.object().keys({
            p256dh: joi.string(),
            auth: joi.string()
          }).requiredKeys('p256dh', 'auth')
        }).requiredKeys('endpoint', 'keys'),
        done
      )
  )

module.exports = {
  validateSubscription,
  getContentType,
  sendFile,
  bodyReader
}

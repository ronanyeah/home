'use strict'

const R = require('ramda')

const handlers = require(`${global.ROOT}/server/handlers/index.js`)

// The Router:
module.exports =
  (method, path) =>
    R.path([method, path], handlers) || handlers['GET']['/fourOhFour']

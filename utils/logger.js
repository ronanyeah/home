'use strict'

const Logentries = require('le_node')

const logger =
  process.env.NODE_ENV === 'production'
    ? new Logentries({
        token: process.env.LOGENTRIES_TOKEN
      })
    : console.log

module.exports = logger

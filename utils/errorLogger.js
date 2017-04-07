'use strict'

const { appendFile } = require('fs')

const { ERROR_LOG } = require(`${ROOT}/config.js`)

module.exports = err => (
  console.log(err),
  appendFile(
    ERROR_LOG,
    `${Date()}\n${err.message}\n\n`
  )
)

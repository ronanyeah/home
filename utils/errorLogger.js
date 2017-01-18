'use strict'

const { appendFile } = require('fs')

module.exports = err => (
  console.log(err),
  appendFile(
    `${__dirname}/error_log.txt`,
    `${Date()}\n${err.message}\n\n`
  )
)

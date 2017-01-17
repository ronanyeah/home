'use strict'

const { homedir } = require('os')
const { appendFile } = require('fs')

const logfile = `${homedir()}/storage/code/home_errorLog.txt`

module.exports = err => (
  console.log(err),
  appendFile(logfile, `${Date()}\n${err.message}\n\n`)
)

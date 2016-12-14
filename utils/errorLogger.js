'use strict'

const logfile = `${ROOT}/errorLog.txt`
const { appendFile } = require('fs')

module.exports = err =>
  appendFile(logfile, `${err.message}\n\n`)

'use strict'

const logfile = `${ROOT}/errorLog.txt`
const { appendFile } = require('fs')

module.exports = err => (
  console.log(err),
  appendFile(logfile, `${err.message}\n\n`)
)

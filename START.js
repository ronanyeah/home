'use strict'

const { exec } = require('rotools')

const errorLogger = require(`${__dirname}/utils/errorLogger.js`)

exec('HTTPS=true IP_SYNC=true pm2 start ./server/index.js')
.fork(
  errorLogger,
  console.log
)


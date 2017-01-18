'use strict'

const { exec } = require('rotools')

const errorLogger = require(`${__dirname}/utils/errorLogger.js`)

exec(`HTTPS=true IP_SYNC=true ${__dirname}/node_modules/.bin/pm2 start ${__dirname}/server/index.js`)
.fork(
  errorLogger,
  console.log
)


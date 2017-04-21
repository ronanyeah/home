'use strict'

const { readdirSync } = require('fs-extra')
const { resolve } = require('path')

require('dotenv').config()

global.ROOT = resolve(`${__dirname}/..`)

const client = require(`${ROOT}/db/redis.js`)

readdirSync(`${ROOT}/test/all`)
.forEach(
  file =>
    require(`${ROOT}/test/all/${file}`)
)

// Stops redis client from hanging tests.
// TODO: Mock redis import.
client.quit()

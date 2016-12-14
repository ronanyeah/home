'use strict'

const { ensureDirSync, readdirSync } = require('fs-extra')
const { resolve } = require('path')

global.ROOT = resolve(`${__dirname}/..`)

ensureDirSync(`${ROOT}/test/scrap`)

readdirSync(`${ROOT}/test/all`)
.forEach(
  file =>
    require(`${ROOT}/test/all/${file}`)
)

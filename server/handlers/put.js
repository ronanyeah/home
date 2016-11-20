'use strict'

const co       = require('co')
const R        = require('ramda')
const bluebird = require('bluebird')
const fs       = bluebird.promisifyAll( require('fs') )

const { bodyReader } = require(`${global.ROOT}/server/helpers.js`)
const { addSubscription } = require(`${global.ROOT}/tools/pushNotify.js`)

module.exports = {

  '/subscribe':
    co.wrap(function* (req, res) {
      addSubscription( JSON.parse( yield bodyReader(req) ) )

      res.writeHead(200)
      return res.end()
    })

}

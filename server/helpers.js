'use strict'

const R        = require('ramda')
const co       = require('co')
const bluebird = require('bluebird')
const fs       = bluebird.promisifyAll( require('fs') )

// Accepts an asset path and returns a 'Content-Type'.
const getContentType =
  R.pipe(
    R.split('.'),
    R.last,
    R.prop(
      R.__,
      {
        js: 'application/javascript',
        json: 'application/json',
        html: 'text/html',
        css: 'text/css',
        ico: 'image/x-icon',
        png: 'image/png',
        jpg: 'image/jpg'
      }
    )
  )

const sendFile =
  path =>
    co.wrap(function* (req, res) {
      const data = yield fs.readFileAsync(path)
      const contentType = getContentType(path)
      res.writeHead(200, { 'Content-Type': contentType })
      return contentType.substring(0, 4) === 'text'
        ? res.end( data.toString() )
        : res.end( data, 'binary' )
    })

module.exports = {
  getContentType,
  sendFile
}

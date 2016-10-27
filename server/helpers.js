'use strict'

const R        = require('ramda')
const bluebird = require('bluebird')
const fs       = bluebird.promisifyAll( require('fs') )

const assetFolder = `${__dirname}/../client/public`

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

// Promisifies any synchronous requests so I can catch all errors at the root of the app.
const promisify =
  fn =>
    (req, res) =>
      new Promise( (resolve, reject) => {
        try {
          fn(req, res)
        } catch (err) {
          reject(Error(`${req.url}: ${err.message}`))
        }

        resolve('OK')
      } )

const sendFile =
  path =>
    (req, res) =>
      fs.readFileAsync(`${assetFolder}${path}`)
      .then( data => {
        const contentType = getContentType(path)
        res.writeHead(200, { 'Content-Type': contentType })
        return contentType.substring(0, 4) === 'text'
          ? res.end( data.toString() )
          : res.end( data, 'binary' )
      } )

module.exports = {
  getContentType,
  sendFile,
  promisify
}

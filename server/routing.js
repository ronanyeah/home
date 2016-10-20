'use strict'

const R        = require('ramda')
const bluebird = require('bluebird')
const fs       = bluebird.promisifyAll( require('fs') )

const assetFolder = `${__dirname}/../public`

const availableAssets = fs.readdirSync(assetFolder)

// Accepts an asset path and returns a 'Content-Type'.
const contentType =
  R.pipe(
    R.split('.'),
    R.last,
    R.prop(
      R.__,
      {
        js: 'application/javascript',
        json: 'application/json',
        html: 'text/html',
        ico: 'image/x-icon',
        png: 'image/png'
      }
    )
  )

// Promisifies any synchronous requests so I can catch all errors at the root of the app.
const promisify = fn => (req, res) => new Promise( (resolve, reject) => {
  try {
    fn(req, res)
  } catch (err) {
    reject(Error(`${req.url}: ${err.message}`))
  }

  resolve('OK')
} )

const sendFile = path =>
  (req, res) =>
    fs.readFileAsync(`${assetFolder}${path}`)
    .then( data => {
      const mime = contentType(path)
      res.writeHead(200, { 'Content-Type': mime })
      mime === 'image/x-icon' || mime === 'image/png'
        ? res.end(data, 'binary')
        : res.end(data.toString())
    } )

const views = {
  '/': sendFile('/index.html'),
  '/ping':
    promisify( (req, res) => {
      res.writeHead(200, { 'Content-Type': 'application/json' })
      res.end(JSON.stringify({ alive: true }))
    } )
}

// The Router:
// Accepts a path and must return a handler that takes (req, res).
// Synchronous handlers must be promisified.
module.exports = path =>
  views[path] // resolve view paths
    ? views[path]
    : R.contains( // resolve asset paths
        R.drop(1, path), // remove leading slash
        availableAssets
      )
        ? sendFile(path)
        : promisify( (req, res) => {
            res.writeHead(404, { 'Content-Type': 'text/html' })
            res.end('<p style="font-size: 10vh; text-align: center;">404!</p>')
          } )

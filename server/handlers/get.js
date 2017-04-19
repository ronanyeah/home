'use strict'

const { of, reject } = require('fluture')
const { json } = require('rotools')
const { pipe, flip, path } = require('ramda')
const { parse } = require('url')

const { sendFile } = require(`${ROOT}/server/helpers.js`)
const redis = require(`${ROOT}/db/redis.js`)

const { VAPID_PUBLIC_KEY } = require(`${ROOT}/config.js`)

module.exports = {

  '/':
    () =>
      sendFile(`${ROOT}/public/main/index.html`),

  '/pwa':
    () =>
      sendFile(`${ROOT}/public/pwa/index.html`),

  '/toys':
    () =>
      sendFile(`${ROOT}/public/toys/index.html`),

  '/subscription':
    (req, res) =>
      pipe(
        url => parse(url, true),
        path(['query', 'endpoint']),
        value =>
          value
            ? redis.get(
                decodeURIComponent(value)
              )
              .map(
                data =>
                  data
                    ? {
                        payload: JSON.stringify(data),
                        contentType: 'application/json',
                        statusCode: 200
                      }
                    : { statusCode: 404 }
              )
            : of({ statusCode: 404 })
      )
      (req.url),

  '/ping':
    () =>
      of({
        payload: JSON.stringify({ alive: true }),
        contentType: 'application/json',
        statusCode: 200
      }),

  '/config':
    () =>
      of({
        payload: JSON.stringify({ applicationServerKey: VAPID_PUBLIC_KEY }),
        contentType: 'application/json',
        statusCode: 200
      }),

  '/fourOhFour':
    () =>
      of({
        payload: '<p style="font-size: 10vh; text-align: center;">404!</p>',
        contentType: 'text/html',
        statusCode: 404
      })

}

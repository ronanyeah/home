'use strict'

const { of } = require('fluture')
const { pipe, path } = require('ramda')
const { parse } = require('url')

const { sendFile, urlBase64ToIntArray } = require('../utils/helpers.js')
const subscriptions = require('../db/subscriptions.js')

const { VAPID_PUBLIC_KEY, PUBLIC_FOLDER } = require('../config.js')

module.exports = {

  '/':
    (_req, _res) =>
      sendFile(`${PUBLIC_FOLDER}/main/index.html`),

  '/pwa':
    (_req, _res) =>
      sendFile(`${PUBLIC_FOLDER}/pwa/index.html`),

  '/subscription':
    ({ url }, _res) =>
      pipe(
        url => parse(url, true),
        path(['query', 'endpoint']),
        value =>
          value
            ? subscriptions.get(
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
      )(
        url
      ),

  '/ping':
    (_req, _res) =>
      of({
        payload: JSON.stringify({ alive: true }),
        contentType: 'application/json',
        statusCode: 200
      }),

  '/config':
    (_req, _res) =>
      of({
        payload: JSON.stringify(urlBase64ToIntArray(VAPID_PUBLIC_KEY)),
        contentType: 'application/json',
        statusCode: 200
      }),

  '/fourOhFour':
    (_req, _res) =>
      of({
        payload: '<p style="font-size: 10vh; text-align: center;">404!</p>',
        contentType: 'text/html',
        statusCode: 404
      })

}

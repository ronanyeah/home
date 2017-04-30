'use strict'

const { encase, of } = require('fluture')

const { urlBase64ToIntArray, bodyReader, json } = require('../utils/helpers.js')
const { send } = require('../utils/pushManagement.js')
const { addSubscription } = require('../utils/pushManagement.js')
const subscriptions = require('../db/subscriptions.js')

const { VAPID_PUBLIC_KEY } = require('../config.js')

const pushKey = urlBase64ToIntArray(VAPID_PUBLIC_KEY)

module.exports = {

  '/validate':
    (req, _res) =>
      bodyReader(req)
      .chain(encase(JSON.parse))
      .chain(
        ({key, subscription = {}}) =>
          subscriptions.get(subscription.endpoint)
          .map(
            data =>
              json({
                valid:
                  String(pushKey) === String(key) &&
                    data === JSON.stringify(subscription)
              })
          )
      ),

  '/subscribe':
    (req, _res) =>
      bodyReader(req)
      .chain(encase(JSON.parse))
      .chain(addSubscription)
      .map(
        _ =>
          json({ status: 'Subscribed!' })
      ),

  '/push':
    (req, _res) =>
      bodyReader(req)
      .chain(encase(JSON.parse))
      .chain(
        ({ password, text = '' }) =>
          password === process.env.PUSH_PASSWORD
            ? send('Hey!', text)
              .map(
                _ =>
                  json({ status: 'Pushed!' })
              )
            : of({ statusCode: 401 })
      )

}

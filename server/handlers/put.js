'use strict'

const { encase, of } = require('fluture')

const { bodyReader } = require(`${ROOT}/server/helpers.js`)
const { removeSubscription, addSubscription } = require(`${ROOT}/utils/pushNotify.js`)

module.exports = {

  '/subscribe':
    (req, res) =>
      bodyReader(req)
      .chain(encase(JSON.parse))
      .chain(addSubscription)
      .map(
        _ => ({
          statusCode: 200
        })
      ),

  '/unsubscribe':
    (req, res) =>
      bodyReader(req)
      .chain(encase(JSON.parse))
      .chain(
        ({ subscriptionEndpoint }) =>
          subscriptionEndpoint
            ? removeSubscription(subscriptionEndpoint)
            : of()
      )
      .map(
        _ => ({
          statusCode: 200
        })
      )

}

'use strict'

const { bodyReader } = require(`${ROOT}/server/helpers.js`)
const push = require(`${ROOT}/utils/pushNotify.js`)(
  `${ROOT}/private/push_subscriptions.json`,
  `${ROOT}/private/vapid_keys.json`
)

module.exports = {

  '/subscribe':
    (req, res) =>
      bodyReader(req)
      .map(JSON.parse)
      .chain(push.addSubscription)
      .map(
        () => ({
          statusCode: 200
        })
      )

}

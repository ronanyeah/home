const { encase, of } = require("fluture");

const { bodyReader } = require("../utils/helpers.js");
const { removeSubscription } = require("../utils/pushManagement.js");

module.exports = {
  "/unsubscribe": (req, _res) =>
    bodyReader(req)
      .chain(encase(JSON.parse))
      .chain(
        ({ subscriptionEndpoint }) =>
          subscriptionEndpoint ? removeSubscription(subscriptionEndpoint) : of()
      )
      .map(_ => ({
        statusCode: 200
      }))
};

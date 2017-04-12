'use strict'

module.exports = {
  GET: require(`${ROOT}/server/handlers/get.js`),
  POST: require(`${ROOT}/server/handlers/post.js`),
  PUT: require(`${ROOT}/server/handlers/put.js`)
}

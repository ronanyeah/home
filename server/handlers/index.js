'use strict'

module.exports = {
  error:
    err =>
      (req, res) => {
        console.log(err.message)
        res.writeHead(500)
        return res.end()
      },
  GET: require(`${global.ROOT}/server/handlers/get.js`),
  PUT: require(`${global.ROOT}/server/handlers/put.js`)
}

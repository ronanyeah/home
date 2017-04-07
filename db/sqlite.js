'use strict'

const { node } = require('fluture')
const sqlite3 = require('sqlite3')

const { SQLITE_FILE } = require(`${ROOT}/config.js`)

const db = new sqlite3.Database(SQLITE_FILE)

module.exports = {
  run:
    (query, params = []) =>
      node(
        done =>
          db.run(query, params, done)
      ),
  all:
    (query, params = []) =>
      node(
        done =>
          db.all(query, params, done)
      )
}

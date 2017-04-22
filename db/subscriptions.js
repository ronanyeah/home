'use strict'

const { node, of } = require('fluture')

const client = require(`${ROOT}/db/redis.js`)

module.exports = {
  get:
    // String -> Future Err String
    key =>
      node(
        done =>
          client.get(key, done)
      ),
  set:
    // (String, a) -> Future Err _
    (key, value) =>
      node(
        done =>
          client.set(key, value, done)
      ),
  delete:
    // String -> Future Err _
    key =>
      node(
        done =>
          client.del(key, done)
      ),
  all:
    // Future Err [String]
    node(
      done =>
        client.keys('*', done)
    )
    .chain(
      keys =>
        keys.length
          ? node(
              done =>
                client.mget(keys, done)
            )
          : of([])
    )
}

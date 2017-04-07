'use strict'

const redis = require('redis')
const { node, of } = require('fluture')

const client = redis.createClient()

module.exports = {
  set:
    (key, value) =>
      node(
        done =>
          client.set(key, value, done)
      ),
  delete:
    key =>
      node(
        done =>
          client.del(key, done)
      ),
  all:
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

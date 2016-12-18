'use strict'

const test = require('tape')
const request = require('supertest')

const { getContentType, bodyReader } = require(`${ROOT}/server/helpers.js`)

test('misc', t => (
  t.plan(2),

  t.equals(
    getContentType('/folder/index.js'),
    'application/javascript',
    'content type'
  ),

  request(
    (req, res) => (
      res.end(),
      bodyReader(req)
      .map(JSON.parse)
      .fork(
        t.fail,
        json =>
          t.equals(json.yeah, 'ok', 'body parser')
      )
    )
  )
  .post('/')
  .send({ yeah: 'ok' })
  .end( _ => _ )

) )

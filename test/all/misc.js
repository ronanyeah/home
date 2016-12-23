'use strict'

const test = require('tape')
const shot = require('shot')

const { getContentType, bodyReader } = require(`${ROOT}/server/helpers.js`)

test('misc', t => (
  t.plan(2),

  t.equals(
    getContentType('/folder/index.js'),
    'application/javascript',
    'content type'
  ),

  shot.inject(
    (req, res) =>
      bodyReader(req)
      .fork(
        t.fail,
        data =>
          res.end(data)
      ),
    {
      url: '/',
      payload: 'TEST_PAYLOAD'
    },
    res =>
      t.equals(res.payload, 'TEST_PAYLOAD', 'body parser')
  )

) )

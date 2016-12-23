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
          t.equals(String(data), 'TEST_PAYLOAD', 'body parser')
      ),
    {
      url: '/',
      payload: 'TEST_PAYLOAD'
    }
  )
) )

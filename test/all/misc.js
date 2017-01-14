'use strict'

const test = require('tape')
const shot = require('shot')

const { getContentType, bodyReader } = require(`${ROOT}/server/helpers.js`)

const payload = 'TEST_PAYLOAD'

test('misc', t => (
  t.plan(3),

  t.equals(
    getContentType('/folder/index.js'),
    'application/javascript',
    'content type'
  ),

  t.equals(
    getContentType('/.vimrc'),
    'text/plain',
    'default content type'
  ),

  shot.inject(
    (req, res) =>
      bodyReader(req)
      .fork(
        t.fail,
        data =>
          t.equals(String(data), payload, 'body parser')
      ),
    {
      url: '/foo',
      payload
    }
  )
) )

'use strict'

const test = require('tape')

const { getContentType } = require(`${ROOT}/server/helpers.js`)

test('misc', t => (
  t.plan(1),

  t.equals(
    getContentType('/folder/index.js'),
    'application/javascript',
    'content type'
  )
) )

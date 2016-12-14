'use strict'

const test = require('tape')

const router = require(`${ROOT}/server/router.js`)

test('router', t => (
  t.plan(3),

  t.equals(typeof router('GET', '/'), 'function', '"/" gets a handler'),

  t.equals(typeof router('GET', '/favicon.ico'), 'function', '"/favicon.ico" gets a handler'),

  t.equals(typeof router('GET', '/not_a_route'), 'function', '404 gets returned')
) )


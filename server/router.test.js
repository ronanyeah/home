'use strict'

// eslint-disable-next-line fp/no-mutation
global.ROOT = process.env.ROOT

require('dotenv').config()

jest.mock('redis', () => ({ createClient: _ => _ }))

const router = require(`${ROOT}/server/router.js`)

test('router', () =>
  expect(typeof router('GET', '/')).toBe('function'),
  expect(typeof router('GET', '/favicon.ico')).toBe('function'),
  expect(typeof router('GET', '/not_a_route')).toBe('function')
)

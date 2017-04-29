'use strict'

// eslint-disable-next-line fp/no-mutation
global.ROOT = process.env.ROOT

require('dotenv').config()

const redis = require(`${ROOT}/db/redis.js`)
const router = require(`${ROOT}/server/router.js`)

afterAll( () => redis.quit() )

test('router', () =>
  expect(typeof router('GET', '/')).toBe('function'),
  expect(typeof router('GET', '/favicon.ico')).toBe('function'),
  expect(typeof router('GET', '/not_a_route')).toBe('function')
)

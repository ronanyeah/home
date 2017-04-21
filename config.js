'use strict'

const { readFileSync } = require('fs')
const { resolve } = require('path')

if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config()
}

if (
  !process.env.VAPID_PUBLIC_KEY ||
  !process.env.VAPID_PRIVATE_KEY ||
  !process.env.PUSH_PASSWORD
) {
  // Keys are from require('web-push').generateVAPIDKeys().
  // Password can be anything.
  throw Error('Missing environment variable!')
}

module.exports = {
  MY_EMAIL: 'hey@ronanmccabe.me',
  VAPID_PUBLIC_KEY: process.env.VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY: process.env.VAPID_PRIVATE_KEY,
  PUSH_PASSWORD: process.env.PUSH_PASSWORD,
  PORT:
    process.env.PORT ||
    (
      process.env.HTTPS
        ? 443
        : 3000
    ),
  HTTPS:
    process.env.HTTPS
      ? {
          key: readFileSync('./private/server.key', 'utf8'),
          cert: readFileSync('./private/server.crt', 'utf8')
        }
      : false
}

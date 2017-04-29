'use strict'

if (process.env.NODE_ENV === 'development') {
  require('dotenv').config()
}

if (
  !process.env.VAPID_PUBLIC_KEY ||
  !process.env.VAPID_PRIVATE_KEY ||
  !process.env.PUSH_PASSWORD
) {
  // Keys are from require('web-push').generateVAPIDKeys().
  // Password can be anything.
  throw Error('Push environment variable missing!')
}

module.exports = {
  MY_EMAIL: 'hey@ronanmccabe.me',
  VAPID_PUBLIC_KEY: process.env.VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY: process.env.VAPID_PRIVATE_KEY,
  PUSH_PASSWORD: process.env.PUSH_PASSWORD,
  REDIS_URL: process.env.REDIS_URL, // If undefined redis will use local connection.
  PORT: process.env.PORT || 3000
}

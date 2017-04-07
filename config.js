'use strict'

const { readFileSync, writeFileSync, existsSync } = require('fs')
const { ensureDirSync } = require('fs-extra')
const { resolve } = require('path')
const { unless } = require('ramda')
const wp = require('web-push')

const PUSH_SUBSCRIPTIONS_PATH = resolve('./private/push_subscriptions.json')
const VAPID_KEYS_PATH = resolve('./private/vapid_keys.json')

// Ensure private folder.
ensureDirSync('./private')

// Ensure push keys.
unless(
  existsSync,
  path =>
    writeFileSync(
      path,
      // Generate new keys.
      JSON.stringify( wp.generateVAPIDKeys() )
    ),
  VAPID_KEYS_PATH
)

// Ensure push subscriptions file.
unless(
  existsSync,
  path =>
    writeFileSync(
      path,
      '[]'
    ),
  PUSH_SUBSCRIPTIONS_PATH
)

const vapidKeys = JSON.parse(readFileSync(VAPID_KEYS_PATH))

module.exports = {
  MY_EMAIL: 'hey@ronanmccabe.me',
  VAPID_PUBLIC_KEY: vapidKeys.publicKey,
  VAPID_PRIVATE_KEY: vapidKeys.privateKey,
  PUSH_SUBSCRIPTIONS_PATH,
  PORT:
    process.env.HTTPS
      ? 443
      : 3000,
  HTTPS:
    process.env.HTTPS
      ? {
          key: readFileSync('./private/server.key', 'utf8'),
          cert: readFileSync('./private/server.crt', 'utf8')
        }
      : false
}

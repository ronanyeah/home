'use strict'

const { readFileSync, writeFileSync, existsSync } = require('fs')
const { ensureDirSync, ensureFileSync } = require('fs-extra')
const { resolve } = require('path')
const { unless } = require('ramda')
const wp = require('web-push')

const VAPID_KEYS_PATH = resolve('./private/vapid_keys.json')
const SQLITE_FILE = resolve('./private/db.sqlite3')
const ERROR_LOG = resolve('./error_log.txt')

// Ensure private folder.
ensureDirSync('./private')

// Ensure sqlite file.
ensureFileSync(SQLITE_FILE)

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

const vapidKeys = JSON.parse(readFileSync(VAPID_KEYS_PATH))

module.exports = {
  MY_EMAIL: 'hey@ronanmccabe.me',
  VAPID_PUBLIC_KEY: vapidKeys.publicKey,
  VAPID_PRIVATE_KEY: vapidKeys.privateKey,
  SQLITE_FILE,
  ERROR_LOG,
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

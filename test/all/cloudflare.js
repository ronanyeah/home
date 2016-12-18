'use strict'

const test = require('tape')
const nock = require('nock')
const { parallel } = require('fluture')

const {
  zoneId, authKey,
  emailAddress, dnsRecordIds
} = require(`${ROOT}/private/cloudflareConfig.json`)

const cfDns = require(`${ROOT}/utils/cloudflare.js`)(emailAddress, authKey)

dnsRecordIds.forEach(
  id =>
    nock('https://api.cloudflare.com')
    .get(RegExp(id))
    .reply(
      200,
      {
        result: {
          yeah: 'ok'
        }
      }
    )
)

nock('https://api.cloudflare.com')
.get(/BAD_ID/)
.reply(
  200,
  {
    result: null,
    errors: [
      { message: 'oops' }
    ]
  }
)

test('cloudflare', t => (
  t.plan(2),

  parallel(
    10,
    dnsRecordIds.map(
      id =>
        cfDns.querySettings(zoneId, id)
    )
  )
  .fork( t.fail, res => t.equals(res.length, dnsRecordIds.length, 'settings returned') ),

  cfDns.querySettings(zoneId, 'BAD_ID')
  .fork( err => t.ok(err, 'error handled'), t.fail )
) )

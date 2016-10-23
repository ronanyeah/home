'use strict'

const test = require('tape')

const mailer = require('../server/mailer.js')

const { emailAddress } = require('../server/cloudflareConfig.json')

test('testing mail send...', t => {
  t.plan(1)

  mailer(
    emailAddress,
    'TEST',
    'TEST',
    `TEST - ${ Date() }`
  )
  .then( data => t.equals( '250', data.response.substring(0, 3) ) )
  .catch( _ => console.log('broken test') )
})

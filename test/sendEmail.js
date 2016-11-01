'use strict'

const test = require('tape')

const { senderEmail, password } = require(`${__dirname}/../private/mailConfig.json`)

const mailer =
  require(`${__dirname}/../tools/emailer.js`)(senderEmail, password)

test('testing mail send...', t => {
  t.plan(1)

  mailer(
    senderEmail, // Send to myself.
    'TEST',
    'TEST',
    `TEST - ${ Date() }`
  )
  .then( data => t.equals( '250', data.response.substring(0, 3) ) )
  .catch( _ => console.log('broken test') )
})

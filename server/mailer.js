'use strict'

const bluebird   = require('bluebird')
const nodemailer = require('nodemailer')

const config = require(`${__dirname}/mailConfig.json`)
// {
  // recipientEmail: String,
  // - the address to send the email to

  // senderEmail: String,
  // - the gmail address the email is being 'sent' from

  // password: String,
  // - can be found here:
  // https://security.google.com/settings/security/apppasswords
// }

const mailTransporter = bluebird.promisifyAll(
  // https://nodemailer.com/2-0-0-beta/setup-smtp/
  nodemailer.createTransport(
    `smtps://${
      encodeURIComponent(config.senderEmail)
    }:${ config.password }@smtp.gmail.com`
  )
)

module.exports = content =>
  mailTransporter.sendMailAsync({
    from: `"IP Update" <${ config.senderEmail }>`,
    to: config.recipientEmail,
    subject: 'IP Update',
    content
  })

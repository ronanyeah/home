'use strict'

const bluebird   = require('bluebird')
const nodemailer = require('nodemailer')

// Pass this config in instead.
const config = require(`${global.ROOT}/private/mailConfig.json`)
// {
  // senderEmail: String,
  // - the gmail address the email is being 'sent' from

  // password: String,
  // - google password, or app password if you have 2FA enabled
  // https://support.google.com/accounts/answer/185833
// }

const mailTransporter = bluebird.promisifyAll(
  // https://nodemailer.com/2-0-0-beta/setup-smtp/
  nodemailer.createTransport(
    `smtps://${
      encodeURIComponent(config.senderEmail)
    }:${ config.password }@smtp.gmail.com`
  )
)

/**
 * Sends an email.
 * @param {string} recipient email address of recipient
 * @param {string} fromLabel name to show in the inbox
 * @param {string} subject subject line
 * @param {string} content email text
 * @returns {Promise<Object>} response object
 */
module.exports = (recipient, fromLabel, subject, content) =>
  mailTransporter.sendMailAsync({
    from: `"${ fromLabel }" <${ config.senderEmail }>`,
    to: recipient,
    subject: subject,
    text: content
  })

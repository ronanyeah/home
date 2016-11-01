'use strict'

const bluebird   = require('bluebird')
const nodemailer = require('nodemailer')

module.exports = (senderEmail, password) => {
  // senderEmail: String,
  // - the gmail address the email is being 'sent' from

  // password: String,
  // - google password, or app password if you have 2FA enabled
  // https://support.google.com/accounts/answer/185833

  const mailTransporter = bluebird.promisifyAll(
    // https://nodemailer.com/2-0-0-beta/setup-smtp/
    nodemailer.createTransport(
      `smtps://${
        encodeURIComponent(senderEmail)
      }:${ password }@smtp.gmail.com`
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
  return (recipient, fromLabel, subject, content) =>
    mailTransporter.sendMailAsync({
      from: `"${ fromLabel }" <${ senderEmail }>`,
      to: recipient,
      subject: subject,
      text: content
    })
}

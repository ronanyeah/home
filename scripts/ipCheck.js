'use strict'

const co       = require('co')
const bluebird = require('bluebird')
const fs       = bluebird.promisifyAll( require('fs') )

// CONFIG
const ipLogPath = `${global.ROOT}/ipLog.json`
const {
  senderEmail,
  password
} = require(`${global.ROOT}/private/mailConfig.json`)
const {
  zoneId, authKey,
  emailAddress, dnsRecordIds
} = require(`${global.ROOT}/private/cloudflareConfig.json`)
// zoneId: String,
// - id of the cloudflare website instance

// authKey: String,
// - api key

// emailAddress: String,
// - cloudflare email

// dnsRecordIds: Array<String>
// - the DNS records that need to have their ip addresses updated.
// your DNS records can be found at:
// https://api.cloudflare.com/client/v4 +
// /zones/<YOUR-ZONE-ID>/dns_records

// SUPPORT FUNCTIONS
const sendEmail = require(`${global.ROOT}/tools/emailer.js`)(senderEmail, password)
const { push } = require(`${global.ROOT}/tools/pushNotify.js`)
const { updateDnsRecordIp, getCurrentIp } = require(`${global.ROOT}/tools/cloudflare.js`)

module.exports = _ =>
  co(function* () {

    const currentIp = yield getCurrentIp()

    yield dnsRecordIds.map(
      id => updateDnsRecordIp(
        currentIp, id, zoneId, emailAddress, authKey
      )
    )

    const oldIp =
      fs.existsSync(ipLogPath)
        ? yield fs.readFileAsync(ipLogPath)
          .then( txt => JSON.parse( txt ) )
          .then( data => data.ip )
        : null

    return currentIp === oldIp
      ? 'no change'
      : (
          push('NEW IP', currentIp),
          sendEmail(
            emailAddress,
            'Rasperry Pi',
            'IP Update',
            `${ currentIp } - ${ Date() }`
          ),
          fs.writeFileAsync(
            ipLogPath,
            JSON.stringify({ ip: currentIp })
          )
        )
  })
  .catch( err => push('ipCheck Error', err.message) )

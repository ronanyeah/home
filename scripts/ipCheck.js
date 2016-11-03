'use strict'

const co       = require('co')
const bluebird = require('bluebird')
const fs       = bluebird.promisifyAll( require('fs') )

const { senderEmail, password } = require(`${global.ROOT}/private/mailConfig.json`)

const sendEmail =
  require(`${global.ROOT}/tools/emailer.js`)(senderEmail, password)

const cfConfig = require(`${global.ROOT}/private/cloudflareConfig.json`)
// {
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
// }

const { updateDnsRecordIp, getCurrentIp } = require(`${global.ROOT}/tools/cloudflare.js`)

module.exports = _ =>
  co(function* () {

    const ipLogPath = `${global.ROOT}/ipLog.json`

    const currentIp = yield getCurrentIp()

    yield cfConfig.dnsRecordIds.map(
      id => updateDnsRecordIp(
        currentIp, id, cfConfig.zoneId, cfConfig.emailAddress, cfConfig.authKey
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
      : yield [
          sendEmail(
            cfConfig.emailAddress,
            'Rasperry Pi',
            'IP Update',
            `${ currentIp } - ${ Date() }`
          ),
          fs.writeFileAsync(
            ipLogPath,
            JSON.stringify({ ip: currentIp })
          )
        ]
  })
  .then( console.log )
  .catch( console.log )

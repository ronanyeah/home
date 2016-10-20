'use strict'

const bluebird = require('bluebird')
const co       = require('co')
const fetch    = require('node-fetch')
const fs       = bluebird.promisifyAll( require('fs') )

const sendNotificationEmail = require(`${__dirname}/mailer.js`)

const config = require(`${__dirname}/cloudflareConfig.json`)
// {
  // zoneId: String,
  // - id of the cloudflare website instance

  // authKey: String,
  // - api key

  // authEmail: 'ronan_mccabe@hotmail.com',
  // - cloudflare email

  // dnsRecordIds: Array<String>
  // - the DNS records that need to have their ip addresses updated.
  // your DNS records can be found at:
  // https://api.cloudflare.com/client/v4 +
  // /zones/<YOUR-ZONE-ID>/dns_records
// }

const veryBadIpValidation = ip =>
  ip === ip.split('.').map( x => String(Number(x)) ).join('.')

const getCurrentIp = _ =>
  fetch('https://api.ipify.org?format=json')
  .then(
    res => res.status === 200
      ? res.json()
      : Promise.reject(Error('Failed to query IP address.'))
  )
  .then(
    body => veryBadIpValidation( body.ip )
      ? body.ip
      : Promise.reject(Error('Invalid IP address returned.'))
  )

// Checks the current ip address the DNS record is pointing to,
// compares it to my current ip, and updates if necessary.
const updateDnsRecordIp = (currentIp, dnsId, zoneId, authEmail, authKey) =>
  co(function*() {

    const headers = {
      'Content-Type': 'application/json',
      'X-Auth-Key': authKey,
      'X-Auth-Email': authEmail
    }

    const url =
      'https://api.cloudflare.com/client/v4' +
      `/zones/${zoneId}` +
      `/dns_records/${dnsId}`

    const currentSettings = yield fetch(
      url,
      {
        headers
      }
    )
    .then(
      res => res.status === 200
        ? res.json()
        : Promise.reject(Error(
            'Failed to retrieve current settings on a DNS record.'
          ))
    )
    .then( body => body.result )

    return currentSettings.content === currentIp
      ? 'OK'
      : fetch(
          url,
          {
            method: 'PUT',
            body: JSON.stringify(
              Object.assign(
                {},
                currentSettings,
                { content: currentIp }
              )
            ),
            headers
          }
        )
        .then(
          res => res.status === 200
            ? res.json()
            : Promise.reject(Error('Failed to update a DNS record.'))
        )
        .then( body => JSON.stringify(body, 0, 2) )
  })

const ipAddressCheckIn = _ =>
  co(function*() {

    const oldIp =
      yield fs.readFileAsync(`${__dirname}/ipLog.json`)
      .then( txt => JSON.parse( txt ) )
      .then( data => data.ip )

    const currentIp = yield getCurrentIp()

    yield config.dnsRecordIds.map(
      id => updateDnsRecordIp(
        currentIp, id, config.zoneId, config.authEmail, config.authKey
      )
    )

    return currentIp === oldIp || process.env.TEST
      ? 'no change'
      : yield [
          sendNotificationEmail(
            `${ currentIp } - ${ Date() }`
          ),
          fs.writeFileAsync(
            `${__dirname}/ipLog.json`,
            JSON.stringify({ ip: currentIp })
          )
        ]
  })
  .then( console.log )
  .catch( err =>
    console.log(err.stack) )
ipAddressCheckIn()
module.exports = {
  ipAddressCheckIn,
  updateDnsRecordIp,
  getCurrentIp
}

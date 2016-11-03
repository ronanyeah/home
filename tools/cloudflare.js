'use strict'

const co    = require('co')
const fetch = require('node-fetch')

const veryBadIpValidation = ip =>
  ip === ip.split('.').map( x => String(Number(x)) ).join('.')

const getCurrentIp = _ =>
  fetch('https://api.ipify.org?format=json')
  .then(
    res => res.status === 200
      ? res.json()
      : Promise.reject(Error(
          'Failed to query IP address.' +
          `\n${res.status}: '${res.statusText}'`
        ))
  )
  .then(
    body => veryBadIpValidation( body.ip )
      ? body.ip
      : Promise.reject(Error('Invalid IP address returned.'))
  )

// Checks the current ip address the DNS record is pointing to,
// compares it to my current ip, and updates if necessary.
const updateDnsRecordIp = (currentIp, dnsId, zoneId, authEmail, authKey) =>
  co(function* () {

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
            'Failed to retrieve current settings on a DNS record.' +
            `\n${res.status}: '${res.statusText}'`
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
            : Promise.reject(Error(
                'Failed to update a DNS record.' +
                `\n${res.status}: '${res.statusText}'`
              ))
        )
        .then( body => JSON.stringify(body, 0, 2) )
  })

module.exports = {
  updateDnsRecordIp,
  getCurrentIp
}

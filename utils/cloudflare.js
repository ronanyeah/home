'use strict'

const { prop, curry } = require('ramda')
const { futch } = require('rotools')
const { reject, fromPromise } = require('fluture')

// String * 4 -> { Function }
module.exports = curry( (authEmail, authKey) => {
  // authEmail: String,
  // - cloudflare email

  // authKey: String,
  // - api key

  // zoneId: String,
  // - id of the cloudflare website instance

  // dnsId: String
  // - the DNS records that need to have their ip addresses updated.
  // your DNS records can be found at:
  // https://api.cloudflare.com/client/v4 +
  // /zones/<YOUR-ZONE-ID>/dns_records

  const headers = {
    'Content-Type': 'application/json',
    'X-Auth-Key': authKey,
    'X-Auth-Email': authEmail
  }

  // String -> String -> Object -> Future Err Res
  const updateSettings = (zoneId, dnsId, settings) =>
    futch(
      'https://api.cloudflare.com/client/v4' +
      `/zones/${zoneId}` +
      `/dns_records/${dnsId}`,
      {
        method: 'PUT',
        body: JSON.stringify(settings),
        headers
      }
    )
    .chain(
      res =>
        res.status === 200
          ? fromPromise( () => res.json(), 0 )
          : reject(Error(
              'Failed to update settings a DNS record.\n' +
              `${res.status}: ${res.statusText}`
            ))
    )
    .map( prop('result') )

  // String -> String -> Future Err Res
  const querySettings = (zoneId, dnsId) =>
    futch(
      'https://api.cloudflare.com/client/v4' +
      `/zones/${zoneId}` +
      `/dns_records/${dnsId}`,
      {
        headers
      }
    )
    .chain(
      res =>
        res.status === 200
          ? fromPromise( () => res.json(), 0 )
          : reject(Error(
              'Failed to retrieve settings on a DNS record.\n' +
              `${res.status}: ${res.statusText}`
            ))
    )
    .map( prop('result') )

  return {
    querySettings,
    updateSettings
  }

})

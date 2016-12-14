'use strict'

const { curry } = require('ramda')
const { futch } = require('rotools')
const { of, reject } = require('fluture')

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
      },
      'json'
    )
    .chain(
      res =>
        res.result
          ? of(res.result)
          : reject(res.errors)
    )

  // String -> String -> Future Err Res
  const querySettings = (zoneId, dnsId) =>
    futch(
      'https://api.cloudflare.com/client/v4' +
      `/zones/${zoneId}` +
      `/dns_records/${dnsId}`,
      {
        headers
      },
      'json'
    )
    .chain(
      res =>
        res.result
          ? of(res.result)
          : reject(res.errors)
    )

  return {
    querySettings,
    updateSettings
  }

})

'use strict'

const { pipe, map, concat, join } = require('ramda')
const { futchJson } = require('rotools')
const { of, reject } = require('fluture')

// [Object] -> String
const formatCloudflareErrors =
  pipe(
    map(
      err =>
        JSON.stringify(err, null, 2)
    ),
    join(',\n'),
    concat('Cloudflare errors:\n')
  )

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

// String -> String -> Function
module.exports = (authEmail, authKey) => {

  const headers = {
    'Content-Type': 'application/json',
    'X-Auth-Key': authKey,
    'X-Auth-Email': authEmail
  }

  // String -> String -> Object -> Future Err Res
  const updateSettings = (zoneId, dnsId, settings) =>
    futchJson(
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
        res.result
          ? of(res.result)
          : reject(Error(formatCloudflareErrors(res.errors)))
    )

  // String -> String -> Future Err Res
  const querySettings = (zoneId, dnsId) =>
    futchJson(
      'https://api.cloudflare.com/client/v4' +
      `/zones/${zoneId}` +
      `/dns_records/${dnsId}`,
      {
        headers
      }
    )
    .chain(
      res =>
        res.result
          ? of(res.result)
          : reject(Error(formatCloudflareErrors(res.errors)))
    )

  return {
    querySettings,
    updateSettings
  }

}

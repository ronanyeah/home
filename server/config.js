'use strict'

const { readFileSync } = require('fs')

module.exports = {
  IP_SYNC: process.env.IP_SYNC,
  PORT:
    process.env.HTTPS
      ? 443
      : 3000,
  HTTPS:
    process.env.HTTPS
      ? {
          key: readFileSync(`${ROOT}/private/server.key`, 'utf8'),
          cert: readFileSync(`${ROOT}/private/server.crt`, 'utf8')
        }
      : false,
  CLOUDFLARE:
    require(`${ROOT}/private/cloudflareConfig.json`)
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
}

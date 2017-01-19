'use strict'

const { propEq, assoc }  = require('ramda')
const { of, parallel } = require('fluture')
const { getCurrentIp } = require('rotools')

const { CLOUDFLARE } = require(`${ROOT}/server/config.js`)

const cf = require(`${ROOT}/utils/cloudflare.js`)(
  CLOUDFLARE.emailAddress,
  CLOUDFLARE.authKey
)

// Checks the IP addresses the cloudflare DNS records are pointing at,
// compares them to the current server IP, and updates if necessary.
module.exports =
  getCurrentIp
  .chain(
    currentIp =>
      parallel(
        Infinity,
        CLOUDFLARE.dnsRecordIds.map(
          dnsId =>
            cf.querySettings(CLOUDFLARE.zoneId, dnsId)
            .chain(
              settings =>
                propEq('content', currentIp, settings) // 'content' is the currently set IP.
                  ? of('no change')
                  : cf.updateSettings(
                      CLOUDFLARE.zoneId,
                      dnsId,
                      assoc(
                        'content',
                        currentIp,
                        settings
                      )
                    )
            )
        )
      )
  )

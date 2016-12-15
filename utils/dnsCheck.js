'use strict'

const { prop, assoc, equals }  = require('ramda')
const { of, parallel } = require('fluture')
const { getCurrentIp } = require('rotools')

const {
  zoneId, authKey,
  emailAddress, dnsRecordIds
} = require(`${ROOT}/private/cloudflareConfig.json`)
const cf = require(`${ROOT}/utils/cloudflare.js`)( emailAddress, authKey )

// Checks the IP addresses the cloudflare DNS records are pointing at,
// compares them to the current server IP, and updates if necessary.
module.exports =
  getCurrentIp
  .chain(
    currentIp =>
      parallel(
        Infinity,

        dnsRecordIds.map(
          dnsId =>
            cf.querySettings(zoneId, dnsId)
            .chain(
              settings =>
                equals( currentIp, prop('content', settings) ) // 'content' is the currently set IP.
                  ? of('no change')
                  : cf.updateSettings(
                      zoneId,
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

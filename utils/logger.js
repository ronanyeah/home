'use strict'

const newRelic = require('newrelic')

const cLog = (tag, payload) =>
  console.log(`${tag}\n${payload}`)

const nrLog = (tag, payload) =>
  newRelic.recordCustomEvent(
    tag,
    {
      data: payload
    }
  )

module.exports =
  process.env.NODE_ENV === 'production'
    ? nrLog
    : cLog

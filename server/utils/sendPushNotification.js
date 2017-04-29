'use strict'

const url = require('url')
const crypto = require('crypto')
const urlBase64 = require('urlsafe-base64')
const fetch = require('node-fetch')
const ece = require('http_ece')
const asn1 = require('asn1.js')
const jws = require('jws')

// Default TTL is four weeks.
const DEFAULT_TTL = 2419200

const webPushError = (statusCode, headers, body, endpoint) =>
  new Error(
    'Received unexpected response code:\n' +
    `Status Code: ${statusCode}\n` +
    `Headers: ${JSON.stringify(headers)}\n` +
    `Body: ${body}\n` +
    `Endpoint: ${endpoint}`
  )

/* eslint-disable fp/no-this */
const ECPrivateKeyASN = asn1.define('ECPrivateKey', function () {
  return this.seq().obj(
    this.key('version').int(),
    this.key('privateKey').octstr(),
    this.key('parameters').explicit(0).objid()
      .optional(),
    this.key('publicKey').explicit(1).bitstr()
      .optional()
  )
})
/* eslint-enable fp/no-this */

// (String, String, String) -> String
const createWebPushJwt = (audience, subject, privateKey) => {
  // 24HRS from now in seconds.
  // https://self-issued.info/docs/draft-ietf-oauth-json-web-token.html#expDef
  const DEFAULT_EXPIRATION = Math.floor(Date.now() / 1000) + 86400

  const jwtHeader = {
    typ: 'JWT',
    alg: 'ES256'
  }

  const jwtPayload = {
    aud: audience,
    exp: DEFAULT_EXPIRATION,
    sub: subject
  }

  const jwtPrivateKey =
    ECPrivateKeyASN.encode(
      {
        version: 1,
        privateKey: urlBase64.decode(privateKey),
        parameters: [1, 2, 840, 10045, 3, 1, 7] // prime256v1
      },
      'pem',
      { label: 'EC PRIVATE KEY' }
    )

  return jws.sign({
    header: jwtHeader,
    payload: jwtPayload,
    privateKey: jwtPrivateKey
  })
}

module.exports =
  // (Object, String, Object) -> Promise Err Object
  (subscription, payload, vapidDetails) => {

    const { protocol, host } = url.parse(subscription.endpoint)

    const bufferPayload = Buffer.from(payload)

    const localCurve = crypto.createECDH('prime256v1')
    const localPublicKey = localCurve.generateKeys()

    const salt = urlBase64.encode(crypto.randomBytes(16))

    const cipherText = ece.encrypt(bufferPayload, {
      keyid: 'foo',
      keymap: {
        foo: localCurve
      },
      keylabels: {
        foo: 'P-256'
      },
      dh: subscription.keys.p256dh,
      authSecret: subscription.keys.auth,
      padSize: 2,
      salt
    })

    const jwt = createWebPushJwt(
      `${protocol}//${host}`,
      vapidDetails.subject,
      vapidDetails.privateKey
    )

    return fetch(
      subscription.endpoint,
      {
        method: 'POST',
        body: cipherText,
        headers: {
          TTL: DEFAULT_TTL,
          Authorization: `WebPush ${jwt}`,
          Encryption: `salt=${salt}`,
          'Content-Length': cipherText.length,
          'Content-Type': 'application/octet-stream',
          'Content-Encoding': 'aesgcm',
          'Crypto-Key':
            `dh=${urlBase64.encode(localPublicKey)};p256ecdsa=${vapidDetails.publicKey}`
        }
      }
    )
    .then(
      res =>
        res.text()
        .then(
          text =>
            res.status === 201
              ? Promise.resolve({
                  statusCode: res.status,
                  body: text,
                  headers: res.headers
                })
              : Promise.reject(webPushError(
                  res.status, res.headers, text, subscription.endpoint
                ))
        )
    )
  }

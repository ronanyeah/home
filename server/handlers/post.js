'use strict'

const { encase, of } = require('fluture')

const { bodyReader } = require('../utils/helpers.js')
const { send } = require('../utils/pushManagement.js')

module.exports = {

  '/push':
    (req, _res) =>
      bodyReader(req)
      .chain(encase(JSON.parse))
      .chain(
        ({ password, text = '' }) =>
          password === process.env.PUSH_PASSWORD
            ? send('Hey!', text)
              .map(
                _ =>
                  ({
                    statusCode: 200
                  })
              )
            : of({ statusCode: 401 })
      )

}

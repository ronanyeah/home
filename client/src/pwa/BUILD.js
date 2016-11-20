'use strict'

const webpack = require('webpack')
const R       = require('ramda')

const webpackCommon = require(`${__dirname}/../webpackCommon.js`)

const errHandler = (err, stats) =>
  err
    ? console.log(err)
    : webpackErrHandler(stats.toJson())

const webpackErrHandler = stats =>
  console.log(
    stats.errors.length
      ? stats.errors
      : stats.warnings.length
         ? stats.warnings
         : 'OK!'
  )

const compiler = webpack(
  Object.assign(
    {
      entry: `${__dirname}/src.js`,
      output: {
        path: `${__dirname}/../../public/pwa/`,
        filename: 'bundle.js'
      }
    },
    webpackCommon
  ),
  errHandler
)

process.env.WATCH
  ? compiler.watch({ // watch options:
      aggregateTimeout: 300, // wait so long for more changes
      poll: true // use polling instead of native watchers
    }, errHandler )
  : compiler.run( errHandler )

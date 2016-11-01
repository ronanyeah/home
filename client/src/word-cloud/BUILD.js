'use strict'

const webpack = require('webpack')

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
  {
    entry: `${__dirname}/src.js`,
    output: {
      path: `${__dirname}/../../public/word-cloud/`,
      filename: 'bundle.js'
    },
    debug: true,
    module: {
      loaders: [
        {
          test: /\.js?$/,
          exclude: /node_modules/,
          loader: 'babel'
        }
      ]
    },
    plugins: [
      new webpack.optimize.UglifyJsPlugin({
        compress: {
          warnings: false
        },
        output: {
          comments: false
        }
      })
    ]
  },
  errHandler
)

process.env.WATCH
  ? compiler.watch({ // watch options:
      aggregateTimeout: 300, // wait so long for more changes
      poll: true // use polling instead of native watchers
    }, errHandler )
  : compiler.run( errHandler )

module.exports = {
  entry: './client/src/js/index.js',
  output: {
    filename: './client/public/bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.css$/,
        loader: 'style-loader!css-loader!postcss-loader'
      }
    ]
  },
  postcss: _ =>
    [ require('autoprefixer'), require('precss') ]
}

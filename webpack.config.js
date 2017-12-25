const webpack = require("webpack");
const { resolve } = require("path");

const outputPath = resolve("./public/pwa/");

const PROD = process.env.NODE_ENV === "production";

module.exports = {
  entry: "./client/pwa/index.js",
  output: {
    path: outputPath,
    filename: "bundle.js"
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "elm-webpack-loader",
          options: {
            cwd: __dirname,
            debug: !PROD,
            warn: !PROD
          }
        }
      }
    ]
  },
  plugins: PROD ? [new webpack.optimize.UglifyJsPlugin()] : []
};

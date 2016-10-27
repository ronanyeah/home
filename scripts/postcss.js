'use strict'

const postcss = require('postcss')
const fs = require('fs')

const css = fs.readFileSync(`${__dirname}/../client/src/css/index.css`)

postcss(
  [
    require('autoprefixer'),
    require('precss'),
    require('cssnano'),
    require('postcss-import')
  ]
)
.process(
  css,
  {
    from: `${__dirname}/../client/src/css/index.css`
  }
)
.then( result => {
  fs.writeFileSync(`${__dirname}/../client/public/index.css`, result.css)
  if ( result.map ) fs.writeFileSync('app.css.map', result.map)
})

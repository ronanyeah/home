'use strict'

const fs = require('fs')

// Flattens a nested array recursively.
const flatten = arr =>
  arr.filter( Array.isArray ).length
    ? flatten( Array.prototype.concat( ...arr ) )
    : arr

// Walks through directories and files, nesting arrays to represent
// folder nesting.
const walk = root =>
  fs.readdirSync(root)
  .map(
    file =>
      fs.statSync(`${root}/${file}`).isDirectory()
        ? walk(`${root}/${file}`)
        : `${root}/${file}`
  )

// Takes a folder path and returns the paths
// to any files underneath that folder.
const index = path =>
  flatten( walk(path) )
  .map( str => str.substring(path.length) )

module.exports = index

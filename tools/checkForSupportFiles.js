'use strict'

const fs = require('fs')

module.exports = files => {

  const missingFiles = files.filter(
    file => {
      try {
        fs.statSync(file)
      } catch (err) {
        return true
      }
      return false
    }
  )

  if (missingFiles.length) {
    console.log(`Files missing!\n${missingFiles.join('\n')}`)
    return process.exit()
  }

}

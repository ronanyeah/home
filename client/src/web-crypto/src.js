import 'babel-polyfill'

import R from 'ramda'

;(async function () {

  const lorem =
    await fetch(
      'https://baconipsum.com/api/?type=meat-and-filler'
    )
    .then(
      res =>
        res.status === 200
          ? res.json()
          : Promise.reject(Error(`Failed to GET lorem, status code: ${res.status}'`))
    )
    .then( body => body.join(' ') )

  const delay = ms =>
    new Promise( (resolve, reject) => setTimeout( _ => resolve(), ms ) )

  // string => array
  const convertStringToArrayBufferView = str =>
    new Uint8Array(str.length).map(
      (x, index) => str.charCodeAt(index)
    )

  const setText = txt =>
    document.querySelector('.text').innerHTML = txt

  // typedArray => string
  const convertArrayBufferViewToString = buffer =>
    buffer.reduce(
      (acc, val) => acc + String.fromCharCode(val),
      ''
    )

  // docs are wrong for decrypt 'AES-CBC', domstring not enough, these also have to be passed to it
  // confirm this
  // also try AES-CTR
  const vals = crypto.getRandomValues( new Uint8Array(16) )

  // arrayBuffer => string
  const arrayBufferToText = buffer =>
    convertArrayBufferViewToString( new Uint8Array(buffer) )

  const key = await crypto.subtle.generateKey(
    { name: 'AES-CBC', length: 256 },
    // { name: 'AES-CTR', length: 256 },
    true,
    ['encrypt', 'decrypt']
  )

  const encryptedText = await encrypt(key, lorem)

  async function encrypt (key, string) {
    const plaintextBuffer = convertStringToArrayBufferView(string)
    return await crypto.subtle.encrypt(
      { name: 'AES-CBC', iv: vals },
      // { name: 'AES-CTR', counter: new Uint8Array(16), length: 128 },
      key,
      plaintextBuffer
    )
    .then( arrayBufferToText )
  }

  async function decrypt (key, string) {
    const encryptedBuffer = convertStringToArrayBufferView(string)
    return await crypto.subtle.decrypt(
      { name: 'AES-CBC', iv: vals },
      // { name: 'AES-CTR', counter: new Int8Array(16), length: 0 },
      key,
      encryptedBuffer // ArrayBuffer
      // or an ArrayBufferView
      // new Uint8Array( encryptedText )
    )
    .then( arrayBufferToText )
  }

  const splitIntoTwenty = val =>
    R.splitEvery(Math.ceil(val.length / 20), val)

  const getRandomIndexes = (n, range, res = []) =>
    res.length === n
      ? res
      : getRandomIndexes(
          n,
          range,
          R.uniq( R.append(Math.floor( Math.random() * range ), res) )
        )

  const bold = R.pipe(R.concat('<strong>'), R.concat(R.__, '</strong>'))

  // Should this be a generator?
  ;(async function reveal (enc, dec, order) {
    setText( enc.join('') )
    await delay(200)

    return order.length
      ? reveal(
          R.update(order[0], bold( dec[order[0]] ), enc),
          dec,
          R.drop(1, order)
        )
      : null
  })(
    splitIntoTwenty(encryptedText),
    splitIntoTwenty(lorem),
    getRandomIndexes(20, 20)
  )

})()
.catch( console.log )

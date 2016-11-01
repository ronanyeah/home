import 'babel-polyfill'

import R from 'ramda'
import wordcloud from 'wordcloud'

// This accepts a chat history from whatsapp and
// returns an array of cleaned up words.
const parse = R.pipe(
  R.split('\n'),
  R.map(R.split('m - ')),
  R.map(R.prop(1)),
  R.reject(R.test(/<.*>/)),
  R.filter(R.identity),
  R.map(R.split(': ')),
  R.map(R.prop(1)),
  R.filter(R.identity),
  R.map(R.split(' ')),
  R.flatten,
  R.map(R.toLower),
  R.reject( x => x.substring(0, 4) === 'http' ),
  R.map(R.replace(/\W/g, '')),
  R.reject( x => String(Number(x)) === x ),
  R.filter( x => x.length > 2 )
)

const read = file =>
  new Promise( (resolve, reject) => {
    const fr = new FileReader()
    fr.onload = e => resolve(e.target.result)
    return fr.readAsText(file)
  } )

window.fileChange = async function (file) {
  const text = await read(file)

  try {
    const wrds = parse(text)

    // This is beautiful but hangs the browser.
    // const countWords = R.reduce((acc, val) =>
    //   R.assoc(val, (acc[val] || 0) + 1, acc), {})

    const result = {}

    const addToResult = val =>
      result[val] = (result[val] || 0) + 1

    R.forEach(R.forEach(addToResult), R.splitEvery(10000, wrds))

    const cvs = document.createElement('canvas')

    cvs.height = 200
    cvs.width = 200

    cvs.addEventListener(
      'wordcloudstop',
      _ =>
        document.getElementById('img').src = cvs.toDataURL()
    )

    wordcloud(cvs, { list: R.toPairs(result) } )

  } catch (err) {
    console.log(err)
  }

}

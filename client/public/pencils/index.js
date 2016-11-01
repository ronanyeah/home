'use strict'

let last = -1

const toArr = arrayLikeObject => Array.prototype.slice.call(arrayLikeObject)

Array.apply(null, Array(30))
.forEach( (x, i) =>
  document.body.innerHTML +=
    `
    <div class="row ${i + 1}">
      <img src="/pencils/pencil-left.png" class="left" />
      <img src="/pencils/pencil-right.png" class="right" />
    </div>
    `
)

toArr(
  document.getElementsByClassName('row')
)
.map( elem => elem.addEventListener( 'mousemove', move ) || elem )
.map( elem => elem.addEventListener( 'touchmove', move ) || elem )
.map( elem => elem.addEventListener( 'mouseup', up ) || elem )

const isShifted = elem => elem && toArr(elem.classList).includes('shift')

const removeClass = (classToRemove, elem) =>
  elem.className = toArr( elem.classList ).filter( x => x !== classToRemove ).join(' ')

function move (e) {
  const touch = e.touches

  const x = touch
    ? touch[0].pageX
    : e.pageX

  const y = touch
    ? touch[0].pageY
    : e.pageY

  const pointElem = document.elementFromPoint(x, y)
  if (!pointElem) return

  const currElem = pointElem.closest('.row')
  if (!currElem) return

  const curr = Number( currElem.classList[1] )
  const lastElem = document.getElementsByClassName(last)[0]

  if ( curr === ( last - 1 ) && !isShifted(lastElem)) {
    removeClass('shift', currElem)
  } else if ( curr === ( last + 1 ) && ( curr === 2 || isShifted(document.getElementsByClassName(curr - 2)[0]) ) ) {
    lastElem.className += ' shift'
  }

  last = curr

}

function up(e) {
  last = -1
}

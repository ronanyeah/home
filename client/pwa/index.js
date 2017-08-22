if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/sw.js')
  .then(console.log)
  .catch(alert)
}

var Elm = require('./Tux.elm')
var storedState = localStorage.getItem('tux-model')
var startingState =
  storedState
    ? JSON.parse(storedState)
    : {}

var app = Elm.Tux.fullscreen(startingState)

// PUSH SUBSCRIBE
app.ports.pushSubscribe.subscribe(function (key) {
  return navigator.serviceWorker.ready
    .then(function (reg) {
      return reg.pushManager.subscribe(
        {
          userVisibleOnly: true,
          applicationServerKey: new Uint8Array(key)
        }
      )
    })
    .then(function (subscription) {
      return app.ports.pushSubscription.send(subscription.toJSON())
    })
    .catch(alert)
})

// PUSH UNSUBSCRIBE
app.ports.pushUnsubscribe.subscribe(function () {
  return navigator.serviceWorker.ready
    .then(function (reg) {
      return reg.pushManager.getSubscription()
    })
    .then(function (subscription) {
      return subscription.unsubscribe()
    })
    .then(function () {
      return app.ports.pushSubscription.send(null)
    })
    .catch(alert)
})

// SAVE STATE
app.ports.setStorage.subscribe(function (state) {
  return localStorage.setItem('tux-model', JSON.stringify(state))
})

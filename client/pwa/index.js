if (navigator.serviceWorker && !navigator.serviceWorker.controller) {
  navigator.serviceWorker.register('/sw.js')
  .catch(alert)
}

const Elm = require('./Tux.elm')
const storedState = localStorage.getItem('tux-model')
const startingState =
  storedState
    ? JSON.parse(storedState)
    : null

const app = Elm.Tux.fullscreen(startingState)

app.ports.pushUnsubscribe.subscribe(
  _ =>
    navigator.serviceWorker.ready
    .then(
      reg =>
        reg.pushManager.getSubscription()
    )
    .then(
      subscription =>
        subscription.unsubscribe()
        .then( _ => app.ports.pushSubscription.send(null) )
    )
    .catch(alert)
)

app.ports.pushSubscribe.subscribe(
  key =>
    navigator.serviceWorker.ready
    .then(
      reg =>
        reg.pushManager.subscribe(
          {
            userVisibleOnly: true,
            applicationServerKey: new Uint8Array(key)
          }
        )
    )
    .then(
      subscription =>
        app.ports.pushSubscription.send(subscription.toJSON())
    )
    .catch(alert)
)

app.ports.setStorage.subscribe(
  state =>
    localStorage.setItem('tux-model', JSON.stringify(state))
)

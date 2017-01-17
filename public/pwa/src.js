'use strict'

window.testPush = () =>
  fetch('/push')
  .catch(alert)

window.unsubscribe = () =>
  navigator.serviceWorker.ready
  .then(
    reg =>
      reg.pushManager.getSubscription()
      .then(
        subscription =>
            subscription
              ? subscription.unsubscribe()
              : false
      )
  )
  .catch(alert)

window.check = () =>
  navigator.serviceWorker.ready
  .then(
    reg =>
      reg.pushManager.getSubscription()
      .then(
        subscription =>
          alert(
            subscription
              ? subscription.endpoint
              : 'No subscription!'
          )
      )
  )
  .catch(alert)

window.subscribe = () =>
  navigator.serviceWorker.ready
  .then(
    reg =>
      fetch('/config')
      .then(
        res =>
          res.status === 200
            ? res.json()
            : Promise.reject(Error('config request error'))
      )
      .then(
        body =>
          reg.pushManager.subscribe(
            {
              userVisibleOnly: true,
              applicationServerKey: urlBase64ToUint8Array(body.applicationServerKey)
            }
          )
          .then(
            subscription =>
              fetch(
                '/subscribe',
                {
                  method: 'PUT',
                  headers: {
                    'Content-Type': 'application/json'
                  },
                  body: JSON.stringify(subscription)
                }
              )
          )
        )
  )
  .catch(alert)

// From: https://github.com/web-push-libs/web-push
function urlBase64ToUint8Array (base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4)
  const rawData =
    window.atob(
      (base64String + padding)
      .replace(/\-/g, '+')
      .replace(/_/g, '/')
    )

  return new Uint8Array(rawData.length)
    .map(
      (_, index) =>
        rawData.charCodeAt(index)
  )
}

window.onload = () =>
  navigator.serviceWorker.controller
    ? null
    : navigator.serviceWorker.register('/sw.js')
      .then(console.log)
      .catch(console.log)

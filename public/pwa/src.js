'use strict'

window.push = () => {
  const password = localStorage.getItem('password')
  const text = prompt('enter text')

  return password && text
    ? fetch(
        '/push',
        {
          method: 'POST',
          body: JSON.stringify({
            password,
            text
          })
        }
      )
      .catch(alert)
    : alert('FAIL')
}

const removeSubscription = subscription =>
  fetch(
    '/unsubscribe',
    {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        subscriptionEndpoint: subscription.endpoint
      })
    }
  )
  .then(
    res =>
      res.status === 200
        ? subscription.unsubscribe()
        : Promise.reject(Error('unsubscription error, status: ' + res.status))
  )

window.unsubscribe = () =>
  navigator.serviceWorker.ready
  .then(
    reg =>
      reg.pushManager.getSubscription()
  )
  .then(
    subscription =>
      subscription
        ? removeSubscription(subscription)
        : Promise.reject(Error('Not subscribed!'))
  )
  .then(
    _ =>
      alert('Unsubscription successful!')
  )
  .catch(alert)

window.check = () =>
  navigator.serviceWorker.ready
  .then(
    reg =>
      reg.pushManager.getSubscription()
  )
  .then(
    subscription =>
      subscription
        ? fetch('/subscription?endpoint=' + encodeURIComponent(subscription.endpoint))
          .then(
            res =>
              res.status === 200
                ? alert(subscription.endpoint.substring(0, 60) + '... is active.')
                : Promise.reject(Error('subscription fetch error, status: ' + res.status))
          )
        : alert('No subscription!')
  )
  .catch(alert)

window.setPassword = () =>
  localStorage.setItem('password', prompt('enter password'))

window.subscribe = () =>
  navigator.serviceWorker.ready
  .then(
    reg =>
      reg.pushManager.getSubscription()
      .then(
        subscription =>
          subscription
            ? Promise.reject(Error('Already subscribed!'))
            : fetch('/config')
              .then(
                res =>
                  res.status === 200
                    ? res.json()
                    : Promise.reject(Error('config request error, status: ' + res.status))
              )
              .then(
                body =>
                  reg.pushManager.subscribe(
                    {
                      userVisibleOnly: true,
                      applicationServerKey: urlBase64ToUint8Array(body.applicationServerKey)
                    }
                  )
                )
      )
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
  .then(
    res =>
      res.status === 200
        ? alert('Subscription successful!')
        : Promise.reject(Error('config request error, status: ' + res.status))
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

window.onload = () => {
  if (navigator.serviceWorker && !navigator.serviceWorker.controller) {
    navigator.serviceWorker.register('/sw.js')
    .then(console.log)
    .catch(console.log)
  }
}

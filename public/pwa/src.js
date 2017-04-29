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
      .then(
        res =>
          res.status === 200
            ? Promise.resolve()
            : Promise.reject(Error('push error, status: ' + res.status))
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
                // Data is an Int Array generated from the VAPID public key.
                // https://github.com/web-push-libs/web-push
                data =>
                  reg.pushManager.subscribe(
                    {
                      userVisibleOnly: true,
                      applicationServerKey: new Uint8Array(data)
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

window.onload = () => {
  if (navigator.serviceWorker && !navigator.serviceWorker.controller) {
    return navigator.serviceWorker.register('/sw.js')
    .then(console.log)
    .catch(console.log)
  }
}

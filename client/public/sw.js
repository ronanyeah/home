self.addEventListener(
  'install',
  e =>
    e.waitUntil(
      caches.open('pwa-cache')
      .then(
        cache =>
          cache.addAll([
            '/pwa/tux.png',
            '/pwa/index.html',
            '/pwa/src.js'
          ])
      )
    )
)

self.addEventListener(
  'push',
  e =>
    e.waitUntil(
      self.registration.showNotification(
        e.data.json().title,
        {
          body: e.data.json().body,
          icon: '/pwa/tux.png',
          vibrate: [400, 200],
          tag: 'no_idea_what_this_is'
        }
      )
    )
)

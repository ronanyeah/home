const cacheName = 'tux-cache-9'

self.addEventListener(
  'install',
  e =>
    e.waitUntil(
      caches.open(cacheName)
      .then(
        cache =>
          cache.addAll([
            '/tachyons.min.css',
            '/pwa',
            '/pwa/tux.png',
            '/pwa/index.html',
            '/pwa/bundle.js',
            '/manifest.json'
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

self.addEventListener(
  'notificationclick',
  event =>
    event.notification.close()
)

self.addEventListener(
  'activate',
  e => (
    e.waitUntil(
      caches.keys()
      .then(
        cacheKeys =>
          Promise.all(
            cacheKeys
            .filter(
              key =>
                key !== cacheName
            )
            .map(
              key =>
                caches.delete(key)
            )
          )
      )
    ),
    self.clients.claim()
  )
)

self.addEventListener(
  'fetch',
  e =>
    e.respondWith(
      fetch(e.request)
      .catch(
        _err =>
          caches.match(e.request)
      )
    )
)

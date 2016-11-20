self.addEventListener(
  'push',
  e =>
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

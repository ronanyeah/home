var handlers = require('./handlers.js');

module.exports = [
  {
    method: 'GET',
    path: '/',
    handler: handlers.home
  },
  
  { //route for all css, images and js files
    method: 'GET',
    path: '/static/{path*}',
    handler:  {
      directory: {
        path: './'
      }
    }
  }
];
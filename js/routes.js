// var handlers = require('./handlers.js')();

module.exports = [
  {
    method: 'GET',
    path: '/',
    handler: function(request, reply) {
      reply.view("index.html");
    }
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
function handlers() {
  "use strict";
  return {

    home: function(request, reply) {
      reply.view("index.html");
    }

  };
}

module.exports = handlers;
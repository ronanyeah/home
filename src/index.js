const { Elm } = require("./Main.elm");

Elm.Main.init({
  node: document.getElementById("app"),
  flags: { screen: { height: window.innerHeight, width: window.innerWidth } },
});

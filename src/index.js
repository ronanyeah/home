import "@fontsource-variable/archivo";
import "@fontsource-variable/montserrat";
import "@fontsource/ibm-plex-mono";

require("./index.css");

const { Elm } = require("./Main.elm");

Elm.Main.init({
  node: document.getElementById("app"),
  flags: { screen: { height: window.innerHeight, width: window.innerWidth } },
});

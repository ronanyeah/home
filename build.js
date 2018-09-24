const { JSDOM } = require("jsdom");
const { writeFileSync } = require("fs");
const { GA_TOKEN } = process.env;

const markup = `
<!DOCTYPE html>
<html>
  <head>
    <title>rónán mccabe</title>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#95AFBA">
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
  </head>
  <body>
    <div id="app"></div>
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
      ga('create', '${GA_TOKEN}', 'auto');
      ga('send', 'pageview');
    </script>
  </body>
</html>
`;

const dom = new JSDOM(markup);

global.document = dom.window.document;

const { Elm } = require("./index.js");

Elm.Main.init({ node: document.getElementById("app") });

writeFileSync("./public/index.html", dom.serialize());

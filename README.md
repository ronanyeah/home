# [home](https://ronanmccabe.me/)

designed to be hosted over https from a raspberry pi.

dns is being managed by [cloudflare](https://www.cloudflare.com/).

to compensate for changes in its public ip, the server will query
its ip address every 5 minutes and update the cloudflare settings if necessary.

slowly becoming an [elm](http://elm-lang.org/) project.

##### _to run:_
1. `$ npm run dev`
2. visit `localhost:3000`

##### _progressive web app development instructions for multiple devices:_
1. `$ npm run dev`
2. `$ ngrok http 3000`
3. visit the https url provided
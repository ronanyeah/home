const {
  VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY,
  PUSH_PASSWORD,
  MY_EMAIL,
  REDIS_URL
} = process.env;

if (!VAPID_PUBLIC_KEY || !VAPID_PRIVATE_KEY || !PUSH_PASSWORD || !MY_EMAIL) {
  // Keys are from require('web-push').generateVAPIDKeys().
  // Password can be anything.
  throw Error("Push environment variable missing!");
}

const { resolve } = require("path");

module.exports = {
  MY_EMAIL,
  VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY,
  PUSH_PASSWORD,
  REDIS_URL: process.env.REDIS_URL, // If undefined redis will use local connection.
  PORT: process.env.PORT || 3000,
  PUBLIC_FOLDER: resolve(`${__dirname}/../public`)
};

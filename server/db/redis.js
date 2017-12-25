const redis = require("redis");

const { REDIS_URL } = require("../config.js");

module.exports = redis.createClient(REDIS_URL);

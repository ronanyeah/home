// Stop New Relic being required outside production.
const nrLogger = () => {
  const newRelic = require("newrelic");
  return (tag, payload) =>
    newRelic.recordCustomEvent(tag, {
      data: payload
    });
};

module.exports =
  process.env.NODE_ENV === "production"
    ? nrLogger()
    : (tag, payload) => console.log(`${tag}\n${payload}`);

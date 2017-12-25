jest.mock("redis", () => ({ createClient: _ => _ }));

const router = require("./router.js");

test(
  "router",
  () => expect(typeof router("GET", "/")).toBe("function"),
  expect(typeof router("GET", "/favicon.ico")).toBe("function"),
  expect(typeof router("GET", "/not_a_route")).toBe("function")
);

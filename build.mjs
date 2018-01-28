import lib from "elm-static-html-lib";
import fs from "fs";
import util from "util";

const { GA_TOKEN } = process.env;

(async () => {
  const template = await util.promisify(fs.readFile)(
    "./src/index.html",
    "UTF8"
  );

  // process.cwd() is not ideal but can't get __dirname in an .mjs file.
  const html = await lib.elmStaticHtml(process.cwd(), "Main.view", {
    newLines: false,
    indent: 0
  });

  await util.promisify(fs.writeFile)(
    "./public/index.html",
    template.replace("CONTENT_HERE", html).replace("GA_TOKEN", GA_TOKEN)
  );
})().catch(console.error);

// SVG -> PNG через Playwright: node tools/diagrams/shot.mjs docs/x.svg preview/x.png
// Нужен пакет playwright (npm i -D playwright && npx playwright install chromium).
// Свой Chromium можно указать через CHROMIUM_PATH.
import { chromium } from 'playwright';
import fs from 'fs';
const [,, svgFile, pngFile] = process.argv;
const opts = { headless: true };
if (process.env.CHROMIUM_PATH) opts.executablePath = process.env.CHROMIUM_PATH;
const b = await chromium.launch(opts);
const p = await b.newPage({ viewport: { width: 1600, height: 1200 }, deviceScaleFactor: 2 });
await p.setContent(`<html><body style="margin:0;background:#fff">${fs.readFileSync(svgFile, 'utf8')}</body></html>`);
await (await p.$('svg')).screenshot({ path: pngFile });
await b.close();

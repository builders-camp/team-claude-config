// Renders a filled-in copy of assets/template.html to a 1200x630 PNG (2x = 2400x1260 actual pixels).
// Usage: node render.js <path-to-filled-html> <path-to-output-png>
const { chromium } = require('playwright');
const path = require('path');

(async () => {
  const [, , htmlPath, outPath] = process.argv;
  if (!htmlPath || !outPath) {
    console.error('Usage: node render.js <path-to-filled-html> <path-to-output-png>');
    process.exit(1);
  }

  let browser;
  try {
    browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium' });
  } catch (e) {
    browser = await chromium.launch();
  }

  const page = await browser.newPage({ viewport: { width: 1200, height: 630 }, deviceScaleFactor: 2 });
  await page.goto('file://' + path.resolve(htmlPath), { waitUntil: 'networkidle' });
  await page.waitForTimeout(300); // let the web font finish swapping in
  await page.screenshot({ path: path.resolve(outPath) });
  await browser.close();
  console.log('Wrote ' + outPath);
})();

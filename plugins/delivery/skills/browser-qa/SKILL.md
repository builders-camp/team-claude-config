---
name: browser-qa
description: Read-only Playwright check of a deploy PREVIEW (never production) with host allowlist, GET-only route guard and PASS/FAIL/SKIPPED evidence. Used by @qa browser verification mode.
disable-model-invocation: false
allowed-tools: Read, Glob, Grep, Bash, Write
argument-hint: "[preview URL or flows to check]"
---

# /delivery:browser-qa

Fail-open: any error means `SKIPPED` with a reason. Never blocks a merge.

## Inputs

From the project CLAUDE.md "Browser QA" section and env vars:
- `PREVIEW_URL`, or the pattern to derive it (for example a Vercel preview URL)
- `PRODUCTION_HOSTS` (comma-separated; a match means refuse)
- Bypass env var name for deployment protection (optional). Sent as an extra HTTP header, never printed.
- Test-login env var names (optional). Logged-in checks run only if all are set.
- Pages to visit, with an expected text per page

## Procedure

1. If the project already has e2e tests, prefer running them against the preview.
2. Resolve the preview URL. Missing, underivable or production host: print `SKIPPED: no preview URL` and stop.
3. Use Chromium at `$PLAYWRIGHT_BROWSERS_PATH`. Never run `playwright install`.
4. Run the script below. Write artifacts to a temp dir only. Never commit them.
5. Report one `PASS` | `FAIL` | `SKIPPED` per flow with URL, screenshot path and observed text. Never print credentials, the bypass secret or member data.

## Script

Adapt the CONFIG block, then run with `node` from a scratch dir.

```js
const { chromium } = require('playwright');
const fs = require('fs');
const os = require('os');
const path = require('path');

// CONFIG: fill from the project CLAUDE.md "Browser QA" section
const BYPASS_HEADER = 'x-vercel-protection-bypass'; // header name; adapt per project
const BYPASS_ENV = process.env.BYPASS_ENV_NAME;     // name of the env var holding the secret
const LOGIN = { // env var names from the project; omit to skip logged-in checks
  urlPath: process.env.LOGIN_PATH,                  // e.g. /login
  emailEnv: 'TEST_EMAIL_ENV_NAME', passEnv: 'TEST_PASSWORD_ENV_NAME',
  emailSel: 'input[type=email]', passSel: 'input[type=password]', submitSel: 'button[type=submit]',
};
const VISITS = [ // { path, expect, auth }
  { path: '/', expect: 'REPLACE_WITH_EXPECTED_TEXT', auth: false },
];

const out = [];
const log = (status, flow, extra = {}) => { out.push({ status, flow, ...extra }); console.log(status, flow, JSON.stringify(extra)); };

(async () => {
  const raw = process.env.PREVIEW_URL;
  const prodHosts = (process.env.PRODUCTION_HOSTS || '').split(',').map(s => s.trim().toLowerCase()).filter(Boolean);
  let base;
  try { base = new URL(raw); } catch { console.log('SKIPPED: no preview URL'); return; }
  const host = base.hostname.toLowerCase();
  if (base.protocol !== 'https:' || prodHosts.length === 0 || prodHosts.some(h => host === h || host.endsWith('.' + h))) {
    console.log('SKIPPED: no preview URL'); return; // allowlist enforced in code; never falls back to production
  }

  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'browser-qa-'));
  const bypass = BYPASS_ENV && process.env[BYPASS_ENV];
  const creds = LOGIN.urlPath && process.env[LOGIN.emailEnv] && process.env[LOGIN.passEnv];
  let browser;
  try {
    browser = await chromium.launch(); // uses $PLAYWRIGHT_BROWSERS_PATH
    const ctx = await browser.newContext(bypass ? { extraHTTPHeaders: { [BYPASS_HEADER]: bypass } } : {});
    const page = await ctx.newPage();
    let loggingIn = false;
    await page.route('**/*', r => {
      const m = r.request().method();
      if (['GET', 'HEAD'].includes(m) || (loggingIn && m === 'POST')) return r.continue();
      return r.abort(); // read-only; POST allowed only during the login step
    });

    if (creds) {
      try {
        await page.goto(new URL(LOGIN.urlPath, base).href);
        loggingIn = true;
        await page.fill(LOGIN.emailSel, process.env[LOGIN.emailEnv]);
        await page.fill(LOGIN.passSel, process.env[LOGIN.passEnv]);
        await page.click(LOGIN.submitSel);
        await page.waitForLoadState('networkidle');
        loggingIn = false;
      } catch (e) { loggingIn = false; log('SKIPPED', 'login', { reason: 'login failed: ' + e.message.split('\n')[0] }); }
    }

    for (const v of VISITS) {
      const url = new URL(v.path, base).href;
      if (v.auth && !creds) { log('SKIPPED', v.path, { url, reason: 'test-account env vars not set' }); continue; }
      try {
        const resp = await page.goto(url, { waitUntil: 'networkidle' });
        const shot = path.join(dir, v.path.replace(/\W+/g, '_') + '.png');
        await page.screenshot({ path: shot, fullPage: true });
        const text = (await page.innerText('body')).replace(/\s+/g, ' ').slice(0, 200);
        const ok = resp && resp.ok() && text.includes(v.expect);
        log(ok ? 'PASS' : 'FAIL', v.path, { url, status: resp && resp.status(), screenshot: shot, observed: v.auth ? '[redacted]' : text });
      } catch (e) { log('SKIPPED', v.path, { url, reason: e.message.split('\n')[0] }); }
    }
  } catch (e) {
    console.log('SKIPPED: ' + e.message.split('\n')[0]);
  } finally {
    if (browser) await browser.close();
  }
})();
```

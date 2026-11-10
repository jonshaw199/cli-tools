#!/usr/bin/env node
// proof-shot — take a "proof" screenshot that points at the thing you're proving:
// load a URL, draw a red box around a selector, scroll it into view, and capture.
// An unboxed screenshot says "here's a page"; this says "here's the proof".
//
// Usage:  proof-shot <url> <css-selector> <out.png> [--width 1280] [--height 800]
// Needs:  npm i playwright   (and `npx playwright install chromium` once)

import { chromium } from 'playwright';

const [url, selector, out] = process.argv.slice(2);
if (!url || !selector || !out) {
  console.error('usage: proof-shot <url> <css-selector> <out.png> [--width N] [--height N]');
  process.exit(1);
}
const arg = (k, d) => {
  const i = process.argv.indexOf(k);
  return i !== -1 ? Number(process.argv[i + 1]) : d;
};
const width = arg('--width', 1280);
const height = arg('--height', 800);

const browser = await chromium.launch();
try {
  const page = await browser.newPage({ viewport: { width, height } });
  await page.goto(url, { waitUntil: 'domcontentloaded' });
  const el = page.locator(selector).first();
  await el.scrollIntoViewIfNeeded();
  await el.evaluate((node) => {
    node.style.outline = '4px solid #e00000';
    node.style.outlineOffset = '3px';
    node.style.borderRadius = '4px';
  });
  await page.screenshot({ path: out });
  console.log(`wrote ${out} (boxed: ${selector})`);
} finally {
  await browser.close();
}

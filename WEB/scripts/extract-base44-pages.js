#!/usr/bin/env node
/**
 * WEB-OPS-03 — Base44 Extraction Layer
 * Method 3: Rendered DOM extraction via Playwright
 * Integrity level: rendered_capture
 *
 * Usage:
 *   node extract-base44-pages.js [--timestamp YYYY-MM-DD_HHMMSS]
 *
 * Config is passed via the CONFIG block below or via env vars:
 *   BASE44_PREVIEW_BASE, BASE44_PREVIEW_TOKEN, BASE44_APP_ID
 */

const { chromium } = require('playwright');
const TurndownService = require('turndown');
const fs = require('fs');
const path = require('path');

// ─── CONFIG ──────────────────────────────────────────────────────────────────

const APP_ID         = process.env.BASE44_APP_ID      || '68b96d175d7634c75c234194';
const PREVIEW_BASE   = process.env.BASE44_PREVIEW_BASE || 'https://preview-sandbox--68b96d175d7634c75c234194.base44.app';
const PREVIEW_TOKEN  = process.env.BASE44_PREVIEW_TOKEN || 'AucgjSzm_ZgG1KaY6nROuvQ8XnTtgHsU1L5EbtECe_M';
const ORIGIN_STREAM  = process.env.BASE44_ORIGIN_STREAM || 'WEB-EXP-01';
const SNAPSHOT_ROOT  = process.env.BASE44_SNAPSHOT_ROOT ||
  path.join(process.env.HOME, 'Projects/krayu-mirror/WEB/base44-snapshot');

const ROUTES = (process.env.BASE44_ROUTES || [
  '/execution-blindness-examples',
  '/why-dashboards-fail-programs',
  '/early-warning-signals-program-failure',
].join(',')).split(',').map(r => r.trim());

// Generate timestamp or accept from CLI args
let timestamp = null;
const tsArg = process.argv.indexOf('--timestamp');
if (tsArg !== -1 && process.argv[tsArg + 1]) {
  timestamp = process.argv[tsArg + 1];
} else {
  const now = new Date();
  const pad = n => String(n).padStart(2, '0');
  timestamp = `${now.getFullYear()}-${pad(now.getMonth()+1)}-${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;
}

const SNAPSHOT_DIR = path.join(SNAPSHOT_ROOT, timestamp);

// ─── SELECTORS ───────────────────────────────────────────────────────────────

// Ordered list of content container candidates — try each until non-empty content found
const CONTENT_SELECTORS = [
  'main',
  '[role="main"]',
  '.content',
  '.page-content',
  '.page',
  '#content',
  '#main',
  'article',
  '.prose',
  '.body',
  '.container > div',
  'body',
];

// Elements to remove before extraction (nav chrome, footer, etc.)
const REMOVE_SELECTORS = [
  'nav',
  'header',
  'footer',
  '[role="navigation"]',
  '[role="banner"]',
  '[role="contentinfo"]',
  '.nav',
  '.navbar',
  '.sidebar',
  '.footer',
  '.header',
  '.menu',
  'script',
  'style',
  'noscript',
];

// ─── TURNDOWN CONFIG ─────────────────────────────────────────────────────────

const td = new TurndownService({
  headingStyle: 'atx',
  hr: '---',
  bulletListMarker: '-',
  codeBlockStyle: 'fenced',
  fence: '```',
  emDelimiter: '_',
  strongDelimiter: '**',
  linkStyle: 'inlined',
});

// Preserve tables
td.addRule('table', {
  filter: ['table'],
  replacement: function(content, node) {
    // Use the default table conversion — get rows
    const rows = Array.from(node.querySelectorAll('tr'));
    if (!rows.length) return content;

    const toRow = (cells, sep = '|') => sep + cells.map(c => ' ' + (c.textContent.trim() || ' ') + ' ').join(sep) + sep;
    const headerCells = Array.from(rows[0].querySelectorAll('th, td'));
    const header = toRow(headerCells);
    const divider = '|' + headerCells.map(() => ' --- ').join('|') + '|';
    const body = rows.slice(1).map(row => toRow(Array.from(row.querySelectorAll('td')))).join('\n');
    return '\n\n' + [header, divider, body].filter(Boolean).join('\n') + '\n\n';
  }
});

// ─── HELPERS ─────────────────────────────────────────────────────────────────

function routeToFilename(route) {
  return route.replace(/^\//, '').replace(/\//g, '-') + '.md';
}

function buildFrontmatter(title, route, sourceUrl, ts) {
  return `---
title: "${title}"
route: "${route}"
source: "${sourceUrl}"
capture_timestamp: "${ts.replace('_', ' ').replace(/(\d{2})(\d{2})(\d{2})$/, '$1:$2:$3')}"
capture_type: "base44-page-capture"
capture_integrity: "rendered_capture"
origin_stream: "${ORIGIN_STREAM}"
upstream_surface: "Base44"
status: "captured"
---`;
}

function formatTimestampForFrontmatter(ts) {
  // YYYY-MM-DD_HHMMSS → YYYY-MM-DD HH:MM:SS
  const [date, time] = ts.split('_');
  const hh = time.slice(0,2), mm = time.slice(2,4), ss = time.slice(4,6);
  return `${date} ${hh}:${mm}:${ss}`;
}

// ─── MAIN EXTRACTION ─────────────────────────────────────────────────────────

async function extractPage(page, route) {
  const url = `${PREVIEW_BASE}${route}?_preview_token=${PREVIEW_TOKEN}`;
  const result = {
    route,
    url,
    title: null,
    markdown: null,
    contentSelector: null,
    status: 'FAIL',
    error: null,
  };

  try {
    await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });

    // Extra wait for React hydration
    await page.waitForTimeout(2000);

    // Try to get page title
    result.title = await page.title().then(t => t.split(' — ')[0].trim()).catch(() => route.replace(/^\//, '').replace(/-/g, ' '));

    // Remove chrome elements from DOM
    for (const sel of REMOVE_SELECTORS) {
      await page.evaluate((s) => {
        document.querySelectorAll(s).forEach(el => el.remove());
      }, sel);
    }

    // Find content container
    let contentHtml = null;
    for (const sel of CONTENT_SELECTORS) {
      try {
        const html = await page.evaluate((s) => {
          const el = document.querySelector(s);
          return el ? el.innerHTML : null;
        }, sel);
        if (html && html.trim().length > 200) {
          contentHtml = html;
          result.contentSelector = sel;
          break;
        }
      } catch (_) {
        continue;
      }
    }

    if (!contentHtml) {
      result.error = 'No content container found with sufficient content';
      return result;
    }

    // Convert HTML → Markdown
    result.markdown = td.turndown(contentHtml).trim();

    if (!result.markdown || result.markdown.length < 50) {
      result.error = 'Markdown conversion produced empty or near-empty output';
      return result;
    }

    result.status = 'PASS';
  } catch (err) {
    result.error = err.message;
  }

  return result;
}

async function run() {
  console.log(`WEB-OPS-03 — Base44 Extraction Layer`);
  console.log(`Timestamp:  ${timestamp}`);
  console.log(`Snapshot:   ${SNAPSHOT_DIR}`);
  console.log(`Routes:     ${ROUTES.join(', ')}`);
  console.log('');

  fs.mkdirSync(SNAPSHOT_DIR, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  });

  const captureTs = formatTimestampForFrontmatter(timestamp);
  const results = [];

  for (const route of ROUTES) {
    console.log(`Extracting: ${route}`);
    const page = await context.newPage();
    const result = await extractPage(page, route);
    await page.close();
    results.push(result);

    if (result.status === 'PASS') {
      const frontmatter = buildFrontmatter(result.title, route, result.url, timestamp);
      const fileContent = `${frontmatter}\n\n# ${result.title}\n\n${result.markdown}\n`;
      const filename = routeToFilename(route);
      const filePath = path.join(SNAPSHOT_DIR, filename);
      fs.writeFileSync(filePath, fileContent, 'utf8');
      console.log(`  ✓ Written: ${filename} (selector: ${result.contentSelector})`);
    } else {
      console.log(`  ✗ FAILED: ${result.error}`);
    }
  }

  await browser.close();

  // Write capture manifest
  const manifestLines = [
    `# Capture Manifest — WEB-OPS-03`,
    ``,
    `## 1. Capture Timestamp`,
    captureTs,
    ``,
    `## 2. Originating Execution Stream`,
    ORIGIN_STREAM,
    ``,
    `## 3. App Identifier`,
    `- App ID: ${APP_ID}`,
    `- Preview base: ${PREVIEW_BASE}`,
    ``,
    `## 4. Routes Captured`,
    ...ROUTES.map(r => `- ${r}`),
    ``,
    `## 5. Files Written`,
    ...results.filter(r => r.status === 'PASS').map(r => `- ${routeToFilename(r.route)}`),
    `- capture_manifest.md`,
    ``,
    `## 6. Extraction Method`,
    `Method 3 — Rendered DOM extraction via Playwright (Chromium headless)`,
    `Integrity level: rendered_capture`,
    ``,
    `## 7. Route-by-Route Capture Status`,
    ...results.map(r => [
      `### ${r.route}`,
      `- Method: rendered_dom_extraction`,
      `- Integrity: ${r.status === 'PASS' ? 'rendered_capture' : 'FAIL'}`,
      `- Status: ${r.status}`,
      `- Content selector: ${r.contentSelector || 'N/A'}`,
      `- Source URL: ${r.url}`,
      ...(r.error ? [`- Error: ${r.error}`] : []),
    ].join('\n')),
    ``,
    `## 8. Preview vs Published`,
    `PREVIEW-ONLY — pages exist on Base44 preview surface. Not yet published on krayu.be.`,
    ``,
    `## 9. Fallback Used`,
    results.some(r => r.status === 'FAIL') ? `YES — ${results.filter(r=>r.status==='FAIL').length} route(s) failed rendered extraction` : `NO — all routes extracted via rendered_capture`,
    ``,
    `## 10. Promotion Decision`,
    `Default: archive only. Promotion to latest requires explicit decision.`,
    ``,
    `---`,
    ``,
    `*Capture governed under WEB-OPS-03 — Base44 Extraction Layer | ${captureTs}*`,
  ];

  fs.writeFileSync(path.join(SNAPSHOT_DIR, 'capture_manifest.md'), manifestLines.join('\n'), 'utf8');
  console.log(`\nManifest written.`);

  // Summary
  const passed = results.filter(r => r.status === 'PASS').length;
  const failed = results.filter(r => r.status === 'FAIL').length;
  console.log(`\nResult: ${passed} PASS / ${failed} FAIL`);
  console.log(`Snapshot: ${SNAPSHOT_DIR}`);

  if (failed > 0) {
    process.exit(1);
  }
}

run().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});

# Contract: Eleventy Build

Program: Krayu — Program Intelligence Discipline
Contract type: Operational / Build System Governance
Governs: Eleventy (11ty) build process for krayu-mirror

---

## Build Inputs

The Eleventy build reads from:

| Input | Path | Role |
|-------|------|------|
| Page source files | `pages/*.md` | Primary content source |
| Layout templates | `_includes/` | Page shell, base layout |
| Data files | `_data/` | Shared site data, navigation definitions |
| Static assets | `static/` | CSS, images, fonts |
| CSS | `css/` | Stylesheets |
| Eleventy config | `.eleventy.js` | Build configuration |

The build must NOT read from:
- `WEB/base44-snapshot/` directly
- `WEB/base44-snapshot/latest/` directly
- Any timestamped snapshot folder

The compile stage (`build-mirror-from-snapshot.sh`) transforms snapshot content into `pages/`. The Eleventy build then reads from `pages/`. These are separate stages.

---

## Build Command

### Local

```bash
cd ~/Projects/krayu-mirror
npx @11ty/eleventy
```

For production build:
```bash
cd ~/Projects/krayu-mirror
npx @11ty/eleventy --output=_site
```

For development server:
```bash
cd ~/Projects/krayu-mirror
npx @11ty/eleventy --serve
```

### CI (GitHub Actions)

The workflow `.github/workflows/webops-build.yml` runs:

```yaml
- run: npm ci
- run: npx @11ty/eleventy --output=_site
```

Workflow input `run_eleventy: true` (default) enables the Eleventy step.
Workflow input `run_eleventy: false` runs compile only (validation artifacts still written).

Trigger: `workflow_dispatch` (manual) or `push` to `main` on paths: `pages/**`, `WEB/scripts/**`, `_includes/**`, `_data/**`, `.eleventy.js`.

---

## Required Dependencies

| Dependency | Version | Role | Install |
|------------|---------|------|---------|
| Node.js | ≥ 18 | Runtime for Eleventy and extraction scripts | `nvm install 20` or system package |
| `@11ty/eleventy` | ^3.1.2 | Static site generator | `npm ci` (from package.json) |
| `playwright` | ^1.58.2 | Base44 page extraction (WEB-OPS-03) | `npm ci` + `npx playwright install chromium` |
| `turndown` | ^7.2.2 | HTML→Markdown conversion in extractor | `npm ci` |

For Eleventy build only (no extraction needed): `npm ci` is sufficient.
For extraction (WEB-OPS-03): additionally run `npx playwright install chromium --with-deps`.

---

## Output Directory

Built site: `~/Projects/krayu-mirror/_site/`

The `_site/` directory:
- Must not be committed to the repository
- Is regenerated on every build
- Is the artifact delivered to the edge (Cloudflare, CDN, or static host)

---

## Layout / Includes Ownership

| File | Role | Modification Rule |
|------|------|------------------|
| `_includes/base.njk` | Primary page layout | Modify only for structural changes — never for content |
| `_includes/*.njk` | Partial layouts | Modify only with documented reason |

Layouts must not contain page-specific content. They are structural shells.

If a layout change is required, it must be:
1. Documented as a separate commit
2. Not bundled with a content push cycle
3. Tested against all existing pages before release

---

## Permalink Rules

Eleventy derives permalinks from:
- The `route` field in page frontmatter (if present)
- Or the file path under `pages/`

Rules:
- No two pages may have the same permalink
- Permalinks must match the `canonical` field in frontmatter exactly (minus the domain)
- `additive_expansion` pages must not be given permalinks that conflict with canonical core routes

---

## Build Validation Checks

Before the build output is considered valid, the operator must verify:

1. `npx @11ty/eleventy` exits with code 0
2. All pages in `pages/` are present in `_site/`
3. No 404 routes introduced by the build
4. `_site/sitemap.xml` exists and contains all live routes
5. `_site/robots.txt` exists and contains `Sitemap:` reference
6. No broken internal links in compiled HTML (use a link checker if available)
7. Layout template renders correctly for additive expansion pages

---

## Build Failure Conditions

The Eleventy build exits non-zero and must not be deployed when any of:

| Condition | Root cause | Resolution |
|-----------|-----------|------------|
| Malformed frontmatter YAML in `pages/*.md` | Bad compile output | Fix frontmatter in the offending `pages/` file |
| Template rendering error in `_includes/` | Layout bug | Fix layout; test against all pages before re-run |
| Missing `_data/` or `_includes/` file | Missing dependency | Restore from git |
| Nunjucks syntax error | Layout or data file issue | Read Eleventy stderr for filename and line |
| `_site/` not created | Eleventy failed silently | Check exit code explicitly — `npx @11ty/eleventy; echo $?` |
| Permalink collision (two pages with same route) | Duplicate canonical | Identify duplicate in `pages/` frontmatter |

## Build Failure Handling

If the build exits non-zero:

1. Do not deploy `_site/`
2. Inspect Eleventy error output for the failing template or data
3. Do not modify `pages/` content to "fix" a build error without understanding the root cause
4. Restore from prior `pages/` state if a compile step introduced a malformed file
5. In CI: check the `mirror-validation-N` artifact for `compile_manifest.md` and `hard_validator_report.md` to distinguish a compile failure from an Eleventy failure

---

*Contract authority: WEB-OPS build governance | Krayu Program Intelligence Discipline | 2026-03-30*

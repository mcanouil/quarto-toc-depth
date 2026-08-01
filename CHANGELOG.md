# Changelog

## Unreleased

### Documentation

- docs: Add a documentation website under `docs/`, built on the `atelier` project type and published to <https://m.canouil.dev/quarto-toc-depth/>.
- docs: Record the interaction with Quarto's own `toc-depth`, which is applied first, so a heading attribute can narrow the contents but not widen them beyond that limit.
- docs: Trim `README.md` to a landing page pointing at the website, and `example.qmd` to a short starting point to copy.
- docs: Add the Pages workflow, which renders `docs/` on pull requests and deploys it from the release tag.
- docs: Add the Quarto Extensions Updates workflow, scanning `docs` for the website's own dependencies.

## 0.6.0 (2026-05-31)

### Bug Fixes

- fix: Reset module-level cascade state in the `Meta` pass so batch renders no longer leak state between documents.
- fix: Clamp negative `toc-depth` values to `0` and emit a warning instead of silently producing inverted cascade behaviour.
- fix: Warn on non-numeric `toc-depth` attributes and on non-numeric `extensions.toc-depth.default` values instead of accepting them silently.

### Documentation

- docs: Document the `toc-depth=0` dual effect (`unlisted` and `unnumbered`).
- docs: Document the cascade-override rule with a worked example where a child re-opens the TOC for its sub-tree.
- docs: Add a cross-format support statement covering HTML, LaTeX/PDF, DOCX, and Typst.
- docs: Document input validation (negative and non-numeric values).

### Refactoring

- refactor: Add shared `logging.lua` module and route warnings through `quarto.log.warning` with the `[toc-depth]` prefix.

## 0.5.0 (2026-05-24)

### New Features

- feat: Add `extensions.toc-depth.default` option to set a document-wide default depth applied to headers without an explicit `toc-depth` attribute.

## 0.4.0 (2026-03-23)

### Refactoring

- refactor: Replace monolithic `utils.lua` with focused modules (`string.lua`, `logging.lua`, `metadata.lua`, `pandoc-helpers.lua`, `html.lua`, `paths.lua`, `colour.lua`).

## 0.3.1 (2026-02-21)

### New Features

- feat: Rename element-attributes to attributes in schema (#11).

## 0.3.0 (2026-02-21)

### New Features

- feat: Add extension-provided code snippets (#9).
- feat: Add _schema.yml for configuration validation and IDE support (#6).

## 0.2.1 (2026-02-11)

### Bug Fixes

- fix: Update copyright year.
- fix: Use british english spelling.

## 0.2.0 (2025-10-25)

### Refactoring

- refactor: Use module and enhance extension (#3).

## 0.1.0 (2025-08-13)

### New Features

- feat: Toc-depth filter.

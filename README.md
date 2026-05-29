# TOC Depth Extension For Quarto

A Quarto extension that provides fine-grained control over table of contents depth at the header level.

## Installation

```bash
quarto add mcanouil/quarto-toc-depth@0.5.0
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Format support

The filter applies the Pandoc `unlisted` and `unnumbered` classes to headers, which is the standard mechanism used by Quarto to control TOC inclusion and numbering.
Supported output formats are those whose TOC honours those classes:

- HTML (including revealjs).
- LaTeX/PDF.
- DOCX (numbering only; TOC inclusion depends on the Word template).
- Typst (via Quarto's Typst writer).

The classes do not affect formats without a generated TOC (e.g. plain markdown, PPTX).

## Usage

Add the filter to your document's YAML header:

```yaml
filters:
  - toc-depth
```

Then control TOC depth for specific sections using the `toc-depth` attribute on headers: `{toc-depth=N}`.

> [!NOTE]
> The TOC depth is relative to the section where it is defined.

```markdown
# Section A {toc-depth=0}

This section and its subsections will not appear in the TOC.

## Subsection A1

This will be hidden from TOC.

# Section B {toc-depth=1}

This section will appear in the TOC, but its direct children will be hidden.

## Subsection B1

This will NOT appear in TOC (depth = 2).

### Subsection B1.1

This will NOT appear in TOC (depth = 3).

# Section C {toc-depth=2}

This section will appear in the TOC, along with its direct children.

## Subsection C1

This will appear in TOC (depth = 2).

### Subsection C1.1

This will NOT appear in TOC (depth = 3).

# Section D

This section uses the default TOC behaviour.
```

### `toc-depth=0`: hide the header and its sub-headings

Setting `toc-depth=0` on a header has two effects:

- The header itself is hidden from the TOC (Pandoc `unlisted` class).
- The header is also marked as `unnumbered`, so it will not receive a section number.

All sub-headings inherit the cascade and are likewise hidden and unnumbered, unless a child overrides the cascade with its own `toc-depth` attribute.

### Cascade override: a child can change the depth for its sub-tree

A child header with an explicit `toc-depth` attribute takes over the cascade for itself and its sub-headings, replacing the depth inherited from its ancestor.

```markdown
# Parent {toc-depth=1}

`Parent` appears in the TOC, but its direct children are hidden.

## Child A

Hidden, inherited from `Parent`.

## Child B {toc-depth=3}

`Child B` overrides the cascade with a wider depth.

### Grandchild B1

Appears in the TOC because of the override on `Child B`.

#### Great-grandchild B1.1

Appears in the TOC because the override caps the visible depth at `3`.
```

A child override can also tighten the cascade (e.g. set `toc-depth=0` on a child to hide a single sub-tree under a parent with `toc-depth=2`).

### Document-level default depth

You can set a document-wide default depth so you do not have to annotate every header.
Configure the integer option `extensions.toc-depth.default` in `_quarto.yml`, `_metadata.yml`, or the document front matter.

```yaml
filters:
  - toc-depth
extensions:
  toc-depth:
    default: 1
```

The default is applied to every header that does not carry an explicit `toc-depth` attribute.
An explicit per-header `toc-depth` attribute always overrides the document default.

```markdown
# Section A

This section appears in the TOC, but its direct children are hidden (default = 1).

## Subsection A1

This is hidden from the TOC because of the document default.

# Section B {toc-depth=2}

This section overrides the default, so its direct children appear in the TOC.

## Subsection B1

This appears in the TOC because of the explicit override.
```

### Input validation

`toc-depth` must be a non-negative integer.
Negative or non-numeric values are reported as warnings during rendering:

- Negative values are clamped to `0` (header and sub-headings hidden from TOC).
- Non-numeric values are ignored and the header falls back to the document default or normal Quarto behaviour.

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Output of `example.qmd`:

- [HTML](https://m.canouil.dev/quarto-toc-depth/)

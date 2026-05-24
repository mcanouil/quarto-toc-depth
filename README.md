# TOC Depth Extension For Quarto

A Quarto extension that provides fine-grained control over table of contents depth at the header level.

## Installation

```bash
quarto add mcanouil/quarto-toc-depth@0.4.0
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

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

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Output of `example.qmd`:

- [HTML](https://m.canouil.dev/quarto-toc-depth/)

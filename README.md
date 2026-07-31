# TOC Depth Extension For Quarto

`toc-depth` is a Quarto extension that provides fine-grained control over table of contents depth at the header level.

Quarto's own `toc-depth` is one number for the whole document; this makes it per heading.

## Installation

```bash
quarto add mcanouil/quarto-toc-depth@0.6.0
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Documentation

The full documentation lives at <https://m.canouil.dev/quarto-toc-depth/>: the attribute, the document default, how the cascade and its overrides work, the interaction with Quarto's own `toc-depth`, and per-format support.

[`example.qmd`](example.qmd) is a short, standalone starting point you can copy.

## Licence

[MIT](https://github.com/mcanouil/quarto-toc-depth?tab=MIT-1-ov-file#readme).

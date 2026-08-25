--- @module "toc-depth"
--- @license MIT
--- @copyright 2026 Mickaël Canouil
--- @author Mickaël Canouil

--- Load modules
local pdoc = require(quarto.utils.resolve_path('_modules/pandoc-helpers.lua'):gsub('%.lua$', ''))
local logging = require(quarto.utils.resolve_path('_modules/logging.lua'):gsub('%.lua$', ''))

--- Extension name used as a prefix in log messages
local EXTENSION_NAME = 'toc-depth'

--- @type boolean Flag indicating if we're currently processing children of a header with toc-depth
local is_parent = false

--- @type number|nil The level of the header that has the toc-depth attribute
local reference_level = nil

--- @type number The current toc-depth value being applied
local current_toc_depth = 1

--- @type number|nil The document-wide default toc-depth applied to headers without an explicit attribute
local default_toc_depth = nil


--- Reset module-level cascade state.
--- Quarto can render multiple documents in one process; without an explicit reset
--- the cascade flags from a previous document would leak into the next render.
local function reset_state()
  is_parent = false
  reference_level = nil
  current_toc_depth = 1
  default_toc_depth = nil
end

--- Add a class to the class list if it doesn't already exist
--- @param classes table List of CSS classes
--- @param name string The class name to add
local function add_class(classes, name)
  pdoc.add_class(classes, name)
end

--- Validate a toc-depth value, clamping negatives to 0 with a warning.
--- @param value number|nil The toc-depth value to validate
--- @param source string Description of where the value came from (for the warning)
--- @return number|nil The validated value, or nil if value was nil
local function validate_toc_depth(value, source)
  if value == nil then
    return nil
  end
  if value < 0 then
    logging.log_warning(
      EXTENSION_NAME,
      string.format(
        "Negative toc-depth value %d from %s; clamping to 0 (header and sub-headings hidden from TOC).",
        value,
        source
      )
    )
    return 0
  end
  return value
end

--- Extract the toc-depth value from element attributes
--- @param attributes table|nil Element attributes table
--- @return number|nil The toc-depth value if found and valid, nil otherwise
local function get_toc_depth_from_attributes(attributes)
  if attributes and attributes['toc-depth'] then
    local raw = tonumber(attributes['toc-depth'])
    if raw == nil then
      logging.log_warning(
        EXTENSION_NAME,
        string.format(
          "Non-numeric toc-depth attribute %q; ignoring.",
          tostring(attributes['toc-depth'])
        )
      )
      return nil
    end
    return validate_toc_depth(raw, 'header attribute')
  end
  return nil
end

--- Read the document-wide default toc-depth from metadata and reset per-document state
--- @param meta table Document metadata table
--- @return table The unchanged document metadata table
--- @description Resets module-level cascade state so a fresh render does not inherit
--- state from a previous document in the same Quarto process, then reads the integer
--- option extensions.toc-depth.default and stores it as the fallback toc-depth for
--- headers without an explicit toc-depth attribute. Negative values are clamped to 0
--- with a warning.
local function get_toc_depth_meta(meta)
  reset_state()
  if meta['extensions'] and meta['extensions']['toc-depth'] and meta['extensions']['toc-depth']['default'] then
    local raw = tonumber(pandoc.utils.stringify(meta['extensions']['toc-depth']['default']))
    if raw == nil then
      logging.log_warning(
        EXTENSION_NAME,
        'Non-numeric extensions.toc-depth.default; ignoring.'
      )
    else
      default_toc_depth = validate_toc_depth(raw, 'extensions.toc-depth.default')
    end
  end
  return meta
end

--- Process a header element to apply toc-depth filtering
--- @param elem table Pandoc Header element with properties: level, attributes, classes
--- @return table|nil The modified header element or nil if no changes needed
--- @description This function handles two scenarios:
--- 1. If the header has a toc-depth attribute, it becomes a "parent" and sets the reference
--- 2. If we're processing children of a parent header, it applies the toc-depth rules
--- An explicit toc-depth attribute always overrides the document-wide default.
--- When toc-depth is 0, the header is hidden from the TOC and unnumbered.
local function process_header(elem)
  local toc_depth = get_toc_depth_from_attributes(elem.attributes)

  if is_parent and not toc_depth and elem.level <= reference_level then
    is_parent = false
    reference_level = nil
  end

  if not toc_depth and not is_parent then
    toc_depth = default_toc_depth
  end

  if toc_depth then
    is_parent = true
    reference_level = elem.level
    current_toc_depth = toc_depth
    if current_toc_depth == 0 then
      add_class(elem.classes, 'unlisted')
      add_class(elem.classes, 'unnumbered')
    end
    return elem
  end

  if is_parent then
    if elem.level > reference_level then
      local relative_depth = elem.level - reference_level
      if relative_depth >= current_toc_depth then
        add_class(elem.classes, 'unlisted')
        add_class(elem.classes, 'unnumbered')
      end
      return elem
    end
  end

  return nil
end

--- Pandoc filter configuration
--- @return table Filter configuration with Meta and Header walker functions
--- @description Returns a Pandoc filter that resets per-document state and reads the
--- document-wide default depth, then processes Header elements to apply custom toc-depth
--- behaviour based on the toc-depth attribute, falling back to the document default when
--- no attribute is set.
return {
  { Meta = get_toc_depth_meta },
  { Header = process_header }
}

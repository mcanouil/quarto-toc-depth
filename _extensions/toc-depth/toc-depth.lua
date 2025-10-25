--[[
# MIT License
#
# Copyright (c) 2025 Mickaël Canouil
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
]]

--- @file toc-depth.lua
--- @brief Quarto filter to control table of contents depth on a per-section basis
--- @description This filter allows you to set a custom toc-depth for specific sections
--- in a Quarto document. Headers marked with the toc-depth attribute will only show
--- nested headers up to the specified depth in the table of contents.

--- Load utils module
local utils = require(quarto.utils.resolve_path('_modules/utils.lua'):gsub('%.lua$', ''))

--- @type boolean Flag indicating if we're currently processing children of a header with toc-depth
local is_parent = false

--- @type number|nil The level of the header that has the toc-depth attribute
local reference_level = nil

--- @type number The current toc-depth value being applied
local current_toc_depth = 1


--- Add a class to the class list if it doesn't already exist
--- @param classes table List of CSS classes
--- @param name string The class name to add
local function add_class(classes, name)
  utils.add_class(classes, name)
end

--- Extract the toc-depth value from element attributes
--- @param attributes table|nil Element attributes table
--- @return number|nil The toc-depth value if found and valid, nil otherwise
local function get_toc_depth_from_attributes(attributes)
  if attributes and attributes['toc-depth'] then
    return tonumber(attributes['toc-depth'])
  end
  return nil
end

--- Process a header element to apply toc-depth filtering
--- @param elem table Pandoc Header element with properties: level, attributes, classes
--- @return table|nil The modified header element or nil if no changes needed
--- @description This function handles two scenarios:
--- 1. If the header has a toc-depth attribute, it becomes a "parent" and sets the reference
--- 2. If we're processing children of a parent header, it applies the toc-depth rules
local function process_header(elem)
  local toc_depth = get_toc_depth_from_attributes(elem.attributes)

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
    if elem.level <= reference_level then
      is_parent = false
      reference_level = nil
      return elem
    end

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
--- @return table Filter configuration with Header walker function
--- @description Returns a Pandoc filter that processes Header elements to apply
--- custom toc-depth behaviour based on the toc-depth attribute
return {
  { Header = process_header }
}

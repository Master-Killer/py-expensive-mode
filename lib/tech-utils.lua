-- fix_tech: fully override selected properties of an existing technology.
-- Taken from md-py-tweaks by MdStudio5 (itself yoinked from pypostprocessing).

local function merge(table, value)
    for k, v in pairs(value) do
        if type(v) == "table" and k ~= "prerequisites" and k ~= "ingredients" then
            table[k] = table[k] or {}
            merge(table[k], v)
        else
            table[k] = v
        end
    end
end

function _G.fix_tech(tech_name, properties)
    local existing = data.raw.technology[tech_name]
    if not existing then
        log('WARNING: could not find technology with name "' .. tech_name .. '"')
        return
    end
    merge(existing, properties)
end

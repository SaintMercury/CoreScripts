---@class SaintReviveScriptConfig
---@field health number
---@field fatigue number|'preserve'
---@field magicka number|'preserve'
local ScriptConfig = {
    bleedoutTime = 9999,
    recordRefId = "saintrevivemarker",
    model = "o/contain_corpse20.nif",
    objectType = "miscellaneous", -- tied to above value
    health = 0.1, -- set to 0 - 1 for percentage, other
    fatigue = 0.0,
    magicka = "preserve",
}

return ScriptConfig

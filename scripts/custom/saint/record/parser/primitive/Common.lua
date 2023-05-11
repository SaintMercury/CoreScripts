local bit = require('bit')
---Returns true when integer has flag
---@param num integer
---@param mask integer
local function HasFlag(num, mask)
    return bit.band(num, mask) == mask
end

return HasFlag

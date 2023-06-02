local Size    = require('custom.saint.record.parser.primitive.Size')
local Types   = require('custom.saint.record.parser.primitive.Types')
local HasFlag = require('custom.saint.record.parser.primitive.Common')

---@class RecordFlags
---@field deleted boolean
---@field persistent boolean
---@field disabled boolean
---@field blocked boolean

---Convert Flags Integer to table
---@param flagNum integer
---@return RecordFlags
local function flagsToObj(flagNum)
    return {
        deleted = HasFlag(flagNum, 0x0020),
        persistent = HasFlag(flagNum, 0x0400),
        disabled = HasFlag(flagNum, 0x0800),
        blocked = HasFlag(flagNum, 0x2000),
    }
end

---@class Record
---@field name RECORD_TYPE
---@field size integer
---@field unused number
---@field flags RecordFlags
---@field rawFlags number
---@field data string

---@param binaryReader BinaryStringReader
---@return Record
return function(binaryReader)
    local recordName = binaryReader:Read(Size.INTEGER)
    local recordDataSize = binaryReader:Read(Size.INTEGER, Types.UINT32) ---@type integer
    local recordUnused = binaryReader:Read(Size.INTEGER, Types.UINT32)
    local recordFlags = binaryReader:Read(Size.INTEGER, Types.UINT32)
    local recordData = binaryReader:Read(recordDataSize)
    return {
        name = recordName,
        size = recordDataSize,
        unused = recordUnused,
        flags = flagsToObj(recordFlags),
        rawFlags = recordFlags,
        data = recordData,
    }
end

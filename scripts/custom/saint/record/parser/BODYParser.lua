local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

local function FlagsToObj(flagNum)
    return {
        female   = HasFlag(flagNum, 0x1),
        playable = HasFlag(flagNum, 0x2),
    }
end

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseMODL = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseFNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseBYDT = function(binaryReader)
    local result = {
        part = binaryReader:Read(Size.BYTE, Types.UINT8),
        vampire = binaryReader:Read(Size.BYTE, Types.UINT8),
        rawFlags = binaryReader:Read(Size.BYTE, Types.UINT8),
        partType = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

local funcMap = {
    ['NAME'] = ParseNAME,
    ['MODL'] = ParseMODL,
    ['FNAM'] = ParseFNAM,
    ['BYDT'] = ParseBYDT,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    assert(binaryReader:Peak(Size.INTEGER) == 'BODY')
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

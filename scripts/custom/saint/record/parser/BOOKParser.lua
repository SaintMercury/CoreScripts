local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

local function FlagsToObj(flagNum)
    return {
        scroll = HasFlag(flagNum, 0x1),
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
local ParseBKDT = function(binaryReader)
    local result = {
        weight = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        value = binaryReader:Read(Size.INTEGER, Types.UINT32),
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
        skillId = binaryReader:Read(Size.INTEGER, Types.INT32),
        enchantmentPoints = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local ParseSCRI = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseITEX = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseTEXT = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseENAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.MODL] = ParseMODL,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.BKDT] = ParseBKDT,
    [FieldName.SCRI] = ParseSCRI,
    [FieldName.ITEX] = ParseITEX,
    [FieldName.TEXT] = ParseTEXT,
    [FieldName.ENAM] = ParseENAM,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

local function FlagsToObj(flagNum)
    return {
        autoCalc = HasFlag(flagNum, 0x1)
    }
end

---@param binaryReader BinaryStringReader
local function ParseNAME(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseENDT(binaryReader)
    local result = {
        type = binaryReader:Read(Size.INTEGER, Types.UINT32),
        enchantmentCost = binaryReader:Read(Size.INTEGER, Types.UINT32),
        charge = binaryReader:Read(Size.INTEGER, Types.UINT32),
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseENAM(binaryReader)
    return {
        effectIndex = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        skill = binaryReader:Read(Size.BYTE, Types.INT8),
        attribute = binaryReader:Read(Size.BYTE, Types.INT8),
        range = binaryReader:Read(Size.INTEGER, Types.UINT32),
        area = binaryReader:Read(Size.INTEGER, Types.UINT32),
        duration = binaryReader:Read(Size.INTEGER, Types.UINT32),
        magnitudeMin = binaryReader:Read(Size.INTEGER, Types.UINT32),
        magnitudeMax = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.ENDT] = ParseENDT,
    [FieldName.ENAM] = ParseENAM,
}

local compositeGroup = {
}

local arrayType = {
    [FieldName.ENAM] = FieldName.ENAM,
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

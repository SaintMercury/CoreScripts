local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseFNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseDATA = function(binaryReader)
    return {
        volume = binaryReader:Read(Size.BYTE, Types.UINT8),
        minRange = binaryReader:Read(Size.BYTE, Types.UINT8),
        maxRange = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.DATA] = ParseDATA,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

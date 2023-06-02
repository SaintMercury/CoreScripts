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
    return binaryReader:Read(Size.BYTE)
end

---@param binaryReader BinaryStringReader
local ParseFLTV = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.FLTV] = ParseFLTV,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseFLTV = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseINTV = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.INT32)
end

---@param binaryReader BinaryStringReader
local ParseSTRV = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.FLTV] = ParseFLTV,
    [FieldName.INTV] = ParseINTV,
    [FieldName.STRV] = ParseSTRV,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

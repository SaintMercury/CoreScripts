local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')

---@param binaryReader BinaryStringReader
local ParseDATA = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.DATA] = ParseDATA,
    [FieldName.NAME] = ParseNAME,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

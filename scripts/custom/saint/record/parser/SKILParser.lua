local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
local ParseINDX = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseSKDT = function(binaryReader)
    return {
        attribute = binaryReader:Read(Size.INTEGER, Types.UINT32),
        specialization = binaryReader:Read(Size.INTEGER, Types.UINT32),
        useValues = {
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
        }
    }
end

---@param binaryReader BinaryStringReader
local ParseDESC = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.INDX] = ParseINDX,
    [FieldName.SKDT] = ParseSKDT,
    [FieldName.DESC] = ParseDESC,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseDATA = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseNNAM = function(binaryReader)
    return binaryReader:Read(Size.BYTE, Types.UINT8)
end

---@param binaryReader BinaryStringReader
local ParseINDX = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseCNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseINTV = function(binaryReader)
    return binaryReader:Read(Size.HALFWORD, Types.UINT16)
end

---@param binaryReader BinaryStringReader
local ParseCompositeCreatures = function(binaryReader, context)
    local followFields = {
        [FieldName.CNAM] = ParseCNAM,
        [FieldName.INTV] = ParseINTV,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.DATA] = ParseDATA,
    [FieldName.NNAM] = ParseNNAM,
    [FieldName.INDX] = ParseINDX,
}

local compositeGroup = {
    [FieldName.CNAM] = ParseCompositeCreatures,
}

local arrayType = {
    [FieldName.CNAM] = 'Creatures',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

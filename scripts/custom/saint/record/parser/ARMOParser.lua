local BaseRecordParser   = require('custom.saint.record.parser.BaseRecordParser')
local BaseFieldsParser   = require('custom.saint.record.parser.BaseFieldsParser')
local FieldName          = require('custom.saint.record.parser.primitive.FieldName')
local Size               = require('custom.saint.record.parser.primitive.Size')
local Types              = require('custom.saint.record.parser.primitive.Types')

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
local ParseSCRI = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseAODT = function(binaryReader)
    return {
        type = binaryReader:Read(Size.INTEGER, Types.UINT32),
        weight = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        value = binaryReader:Read(Size.INTEGER, Types.UINT32),
        health = binaryReader:Read(Size.INTEGER, Types.UINT32),
        enchantmentPoints = binaryReader:Read(Size.INTEGER, Types.UINT32),
        armorRating = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
end

---@param binaryReader BinaryStringReader
local ParseITEX = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseINDX = function(binaryReader)
    ---Saint Note: This could be an improper type, due to some strange language on UESP
    return binaryReader:Read(binaryReader.length, Types.INT8)
end

---@param binaryReader BinaryStringReader
local ParseENAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseBNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCompositeBipedObject = function(binaryReader, context)
    local followFields = {
        [FieldName.INDX] = ParseINDX,
        [FieldName.BNAM] = ParseBNAM,
        [FieldName.CNAM] = ParseCNAM,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.MODL] = ParseMODL,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.SCRI] = ParseSCRI,
    [FieldName.AODT] = ParseAODT,
    [FieldName.ITEX] = ParseITEX,
    [FieldName.ENAM] = ParseENAM,
}

local compositeGroup = {
    [FieldName.INDX] = ParseCompositeBipedObject,
}

local arrayType = {
    [FieldName.INDX] = 'BIPED',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

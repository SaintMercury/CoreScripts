local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

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
local ParseCNDT = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseFLAG = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseNPCO = function(binaryReader)
    return {
        objectCount = binaryReader:Read(Size.INTEGER, Types.INT32),
        objectName = binaryReader:Read(32),
    }
end

---@param binaryReader BinaryStringReader
local ParseSCRI = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.MODL] = ParseMODL,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.CNDT] = ParseCNDT,
    [FieldName.FLAG] = ParseFLAG,
    [FieldName.NPCO] = ParseNPCO,
    [FieldName.SCRI] = ParseSCRI,
}

local compositeGroup = {
}

local arrayType = {
    [FieldName.NPCO] = FieldName.NPCO,
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

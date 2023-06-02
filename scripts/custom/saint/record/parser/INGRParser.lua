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
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseFNAM = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseIRDT = function(binaryReader)
    return {
        weight = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        value = binaryReader:Read(Size.INTEGER, Types.UINT32),
        effects = {
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
        },
        skills = {
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
        },
        attributes = {
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
        }
    }
end

---@param binaryReader BinaryStringReader
local ParseSCRI = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseITEX = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.MODL] = ParseMODL,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.IRDT] = ParseIRDT,
    [FieldName.SCRI] = ParseSCRI,
    [FieldName.ITEX] = ParseITEX,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

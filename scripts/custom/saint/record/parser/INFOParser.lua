local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
local ParseINAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParsePNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseNNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseDATA = function(binaryReader)
    return {
        dialogueType = binaryReader:Read(Size.BYTE, Types.UINT8),
        unusedBlock = {
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
        },
        dispositionOrJournalIndex = binaryReader:Read(Size.INTEGER, Types.UINT32),
        rank = binaryReader:Read(Size.BYTE, Types.UINT8),
        gender = binaryReader:Read(Size.BYTE, Types.INT8),
        pcRank = binaryReader:Read(Size.BYTE, Types.UINT8),
        unused = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
end

---@param binaryReader BinaryStringReader
local ParseONAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseRNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseFNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseANAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseDNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseSNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseSCVR = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseINTV = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseFLTV = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseBNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseQSTN = function(binaryReader)
    return binaryReader:Read(Size.BYTE, Types.BOOLEAN)
end

---@param binaryReader BinaryStringReader
local ParseQSTF = function(binaryReader)
    return binaryReader:Read(Size.BYTE, Types.BOOLEAN)
end

---@param binaryReader BinaryStringReader
local ParseQSTR = function(binaryReader)
    return binaryReader:Read(Size.BYTE, Types.BOOLEAN)
end

---@param binaryReader BinaryStringReader
local ParseCompositeFuncVarList = function(binaryReader, context)
    local followFields = {
        [FieldName.SCVR] = ParseSCVR,
        [FieldName.INTV] = ParseINTV,
        [FieldName.FLTV] = ParseFLTV,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

local funcMap = {
    [FieldName.INAM] = ParseINAM,
    [FieldName.PNAM] = ParsePNAM,
    [FieldName.NNAM] = ParseNNAM,
    [FieldName.DATA] = ParseDATA,
    [FieldName.ONAM] = ParseONAM,
    [FieldName.RNAM] = ParseRNAM,
    [FieldName.CNAM] = ParseCNAM,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.ANAM] = ParseANAM,
    [FieldName.DNAM] = ParseDNAM,
    [FieldName.SNAM] = ParseSNAM,
    [FieldName.NAME] = ParseNAME,
    [FieldName.BNAM] = ParseBNAM,
    [FieldName.QSTN] = ParseQSTN,
    [FieldName.QSTF] = ParseQSTF,
    [FieldName.QSTR] = ParseQSTR,
}

local compositeGroup = {
    [FieldName.SCVR] = ParseCompositeFuncVarList,
}

local arrayType = {
    [FieldName.SCVR] = 'FunctionVariableList',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

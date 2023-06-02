local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

local function FlagsToObj(flagNum)
    return {
        master = HasFlag(flagNum, 0x1),
    }
end

---@param binaryReader BinaryStringReader
local function ParseHEDR(binaryReader)
    local result = {
        version = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
        author = binaryReader:Read(32),
        description = binaryReader:Read(256),
        recordCount = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseMAST(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseDATA(binaryReader)
    return binaryReader:Read(Size.LONG, Types.UINT64)
end

---@param binaryReader BinaryStringReader
local ParseCompositeMasterFileList = function(binaryReader, context)
    local followFields = {
        [FieldName.MAST] = ParseMAST,
        [FieldName.DATA] = ParseDATA,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

local funcMap = {
    [FieldName.HEDR] = ParseHEDR,
}

local compositeGroup = {
    [FieldName.MAST] = ParseCompositeMasterFileList,
}

local arrayType = {
    [FieldName.MAST] = 'MasterFiles',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

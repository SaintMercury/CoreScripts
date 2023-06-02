local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

local function FlagsToObj(flagNum)
    return {
        hidden = HasFlag(flagNum, 0x1)
    }
end

---@param binaryReader BinaryStringReader
local function ParseNAME(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseFNAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseRNAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseFADT(binaryReader)
    local result = {
        attributes = {
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
        },
        rankData = {
            attributeModifiers = {
                binaryReader:Read(Size.INTEGER, Types.UINT32),
                binaryReader:Read(Size.INTEGER, Types.UINT32),
            },
            primarySkillModifier = binaryReader:Read(Size.INTEGER, Types.UINT32),
            favoredSkillModifier = binaryReader:Read(Size.INTEGER, Types.UINT32),
            factionReactionModifier = binaryReader:Read(Size.INTEGER, Types.UINT32),
        },
        skills = {
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
            binaryReader:Read(Size.INTEGER, Types.INT32),
        },
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseANAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseINTV(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.INT32)
end

---@param binaryReader BinaryStringReader
local function ParseCompositeName(binaryReader, context)
    local followFields = {
        [FieldName.ANAM] = ParseANAM,
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
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.RNAM] = ParseRNAM,
    [FieldName.FADT] = ParseFADT,
}

local compositeGroup = {
    [FieldName.ANAM] = ParseCompositeName,
}

local arrayType = {
    [FieldName.RNAM] = FieldName.RNAM,
    [FieldName.ANAM] = 'FactionDetails',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

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
        ['ANAM'] = ParseANAM,
        ['INTV'] = ParseINTV,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

local funcMap = {
    ['NAME'] = ParseNAME,
    ['FNAM'] = ParseFNAM,
    ['RNAM'] = ParseRNAM,
    ['FADT'] = ParseFADT,
}

local compositeGroup = {
    ['ANAM'] = ParseCompositeName,
}

local arrayType = {
    ['RNAM'] = 'RNAM',
    ['ANAM'] = 'FactionName'
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    assert(binaryReader:Peak(Size.INTEGER) == 'FACT')
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

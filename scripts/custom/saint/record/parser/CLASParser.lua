local BaseRecordParser   = require('custom.saint.record.parser.BaseRecordParser')
local HasFlag            = require('custom.saint.record.parser.primitive.Common')
local FieldName          = require('custom.saint.record.parser.primitive.FieldName')
local Types              = require('custom.saint.record.parser.primitive.Types')
local Size               = require('custom.saint.record.parser.primitive.Size')

local function FlagsToObj(flagNum)
    return {
        playable = HasFlag(flagNum, 0x1)
    }
end

local function AutoCalcFlagsToObj(flagNum)
    return {
        weapon      = HasFlag(flagNum, 0x00001),
        armor       = HasFlag(flagNum, 0x00002),
        clothing    = HasFlag(flagNum, 0x00004),
        books       = HasFlag(flagNum, 0x00008),
        ingredient  = HasFlag(flagNum, 0x00010),
        picks       = HasFlag(flagNum, 0x00020),
        probes      = HasFlag(flagNum, 0x00040),
        lights      = HasFlag(flagNum, 0x00080),
        apparatus   = HasFlag(flagNum, 0x00100),
        repaitItems = HasFlag(flagNum, 0x00200),
        misc        = HasFlag(flagNum, 0x00400),
        spells      = HasFlag(flagNum, 0x00800),
        magicItems  = HasFlag(flagNum, 0x01000),
        potions     = HasFlag(flagNum, 0x02000),
        training    = HasFlag(flagNum, 0x04000),
        spellmaking = HasFlag(flagNum, 0x08000),
        enchanting  = HasFlag(flagNum, 0x10000),
        repair      = HasFlag(flagNum, 0x20000),
    }
end

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseFNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCLDT = function(binaryReader)
    local result = {
        primaryAttributes = {
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
        },
        specialization = binaryReader:Read(Size.INTEGER, Types.UINT32),
        majorSkills = {
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
        },
        minorSkills = {
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
        },
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
        rawAutoCalcFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    result.autoCalcFlags = AutoCalcFlagsToObj(result.rawAutoCalcFlags)
    return result
end

---@param binaryReader BinaryStringReader
local ParseDESC = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.CLDT] = ParseCLDT,
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

local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

local function FlagsToObj(flagNum)
    return {
        playable = HasFlag(flagNum, 0x1),
        beast = HasFlag(flagNum, 0x2),
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
local function ParseRADT(binaryReader)
    local result = {
        skillbonues = (function()
            local list = {}
            for i = 0, 7 - 1, 1 do
                list[i] = {
                    skillId = binaryReader:Read(Size.INTEGER, Types.INT32),
                    bonus = binaryReader:Read(Size.INTEGER, Types.UINT32),
                }
            end
            return list
        end)(),
        attributes = (function()
            local list = {}
            for i = 0, 8 - 1, 1 do
                list[i] = {
                    binaryReader:Read(Size.INTEGER, Types.UINT32),
                    binaryReader:Read(Size.INTEGER, Types.UINT32),
                }
            end
            return list
        end)(),
        height = {
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
        },
        weight = {
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
            binaryReader:Read(Size.INTEGER, Types.FLOAT),
        },
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseNPCS(binaryReader)
    return binaryReader:Read(32)
end

---@param binaryReader BinaryStringReader
local function ParseDESC(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.RADT] = ParseRADT,
    [FieldName.NPCS] = ParseNPCS,
    [FieldName.DESC] = ParseDESC,
}

local compositeGroup = {
}

local arrayType = {
    [FieldName.NPCS] = FieldName.NPCS,
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

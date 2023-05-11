local Types            = require('custom.saint.record.parser.primitive.Types')
local Size             = require('custom.saint.record.parser.primitive.Size')
local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local ParseField       = require('custom.saint.record.parser.primitive.ParseField')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

local function FlagsToObj(flagNum)
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
local function ParseNAME(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseMODL(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseCNAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseFNAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseSCRI(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseNPDT(binaryReader)
    return {
        type = binaryReader:Read(Size.INTEGER, Types.UINT32),
        level = binaryReader:Read(Size.INTEGER, Types.UINT32),
        attributes = {
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
            binaryReader:Read(Size.INTEGER, Types.UINT32),
        },
        health = binaryReader:Read(Size.INTEGER, Types.UINT32),
        spellPts = binaryReader:Read(Size.INTEGER, Types.UINT32),
        fatigue = binaryReader:Read(Size.INTEGER, Types.UINT32),
        soul = binaryReader:Read(Size.INTEGER, Types.UINT32),
        combat = binaryReader:Read(Size.INTEGER, Types.UINT32),
        magic = binaryReader:Read(Size.INTEGER, Types.UINT32),
        stealth = binaryReader:Read(Size.INTEGER, Types.UINT32),
        attackMin1 = binaryReader:Read(Size.INTEGER, Types.UINT32),
        attackMax1 = binaryReader:Read(Size.INTEGER, Types.UINT32),
        attackMin2 = binaryReader:Read(Size.INTEGER, Types.UINT32),
        attackMax2 = binaryReader:Read(Size.INTEGER, Types.UINT32),
        attackMin3 = binaryReader:Read(Size.INTEGER, Types.UINT32),
        attackMax3 = binaryReader:Read(Size.INTEGER, Types.UINT32),
        gold = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
end

---@param binaryReader BinaryStringReader
local function ParseFLAG(binaryReader)
    local rawFlag = binaryReader:Read(Size.INTEGER, Types.UINT32)
    return {
        biped           = HasFlag(rawFlag, 0x0001),
        respawn         = HasFlag(rawFlag, 0x0002),
        weaponAndShiled = HasFlag(rawFlag, 0x0004),
        none            = HasFlag(rawFlag, 0x0080),
        swims           = HasFlag(rawFlag, 0x0010),
        flies           = HasFlag(rawFlag, 0x0020),
        walks           = HasFlag(rawFlag, 0x0040),
        defaultFlags    = HasFlag(rawFlag, 0x0048), -- SAINT NOTE: Typo?
        essential       = HasFlag(rawFlag, 0x0080),
        bloodType1      = HasFlag(rawFlag, 0x0400),
        bloodType2      = HasFlag(rawFlag, 0x0800),
        bloodType3      = HasFlag(rawFlag, 0x0C00),
        bloodType4      = HasFlag(rawFlag, 0x1000),
        bloodType5      = HasFlag(rawFlag, 0x1400),
        bloodType6      = HasFlag(rawFlag, 0x1800),
        bloodType7      = HasFlag(rawFlag, 0x1C00),
    }
end

---@param binaryReader BinaryStringReader
local function ParseXSCL(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local function ParseNPCO(binaryReader)
    return {
        objectCount = binaryReader:Read(Size.INTEGER, Types.INT32),
        objectName = binaryReader:Read(32),
    }
end

---@param binaryReader BinaryStringReader
local function ParseNPCS(binaryReader)
    return binaryReader:Read(32)
end

---@param binaryReader  BinaryStringReader
local function ParseAIDT(binaryReader)
    local result = {
        hello = binaryReader:Read(Size.BYTE, Types.UINT8),
        unknown1 = binaryReader:Read(Size.BYTE, Types.UINT8),
        fight = binaryReader:Read(Size.BYTE, Types.UINT8),
        flee = binaryReader:Read(Size.BYTE, Types.UINT8),
        alarm = binaryReader:Read(Size.BYTE, Types.UINT8),
        unknown2 = binaryReader:Read(Size.BYTE, Types.UINT8),
        unknown3 = binaryReader:Read(Size.BYTE, Types.UINT8),
        unknown4 = binaryReader:Read(Size.BYTE, Types.UINT8),
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseDODT(binaryReader)
    return {
        posX = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        posY = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        posZ = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        rotX = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        rotY = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        rotZ = binaryReader:Read(Size.INTEGER, Types.FLOAT),
    }
end

---@param binaryReader BinaryStringReader
local function ParseDNAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCompositeDestination = function(binaryReader, context)
    local followFields = {
        ['DODT'] = ParseDODT,
        ['DNAM'] = ParseDNAM,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

---@param binaryReader BinaryStringReader
local ParseAI_A = function(binaryReader)
    return {
        name = binaryReader:Read(32),
        unknown = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
end

---@param binaryReader BinaryStringReader
local ParseCNDT = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseAI_EF = function(binaryReader)
    return {
        x = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        y = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        z = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        duration = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        id = binaryReader:Read(32),
        unknown = binaryReader:Read(Size.BYTE, Types.UINT8),
        unused = binaryReader:Read(Size.BYTE, Types.UINT8),
        cndt = (function()
            if binaryReader:Peak(Size.BYTE) == 'CNDT' then
                local field = ParseField(binaryReader)
                return ParseCNDT(field.data)
            end
            return nil
        end)()
    }
end

---@param binaryReader BinaryStringReader
local ParseAI_T = function(binaryReader)
    return {
        x = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        y = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        z = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        unknown = binaryReader:Read(Size.BYTE, Types.UINT8),
        unused = {
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
        }
    }
end

---@param binaryReader BinaryStringReader
local ParseAI_W = function(binaryReader)
    return {
        distance = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        duration = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        timeOfDay = binaryReader:Read(Size.BYTE, Types.UINT8),
        idles = {
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
            binaryReader:Read(Size.BYTE, Types.UINT8),
        },
        unknown = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
end

local funcMap = {
    ['NAME'] = ParseNAME,
    ['MODL'] = ParseMODL,
    ['CNAM'] = ParseCNAM,
    ['FNAM'] = ParseFNAM,
    ['SCRI'] = ParseSCRI,
    ['NPDT'] = ParseNPDT,
    ['FLAG'] = ParseFLAG,
    ['XSCL'] = ParseXSCL,
    ['NPCO'] = ParseNPCO,
    ['NPCS'] = ParseNPCS,
    ['AIDT'] = ParseAIDT,
    ['AI_A'] = ParseAI_A,
    ['AI_E'] = ParseAI_EF,
    ['AI_F'] = ParseAI_EF,
    ['AI_T'] = ParseAI_T,
    ['AI_W'] = ParseAI_W,
}

local compositeGroup = {
    ['DODT'] = ParseCompositeDestination,
}

local arrayType = {
    ['NPCO'] = 'NPCO',
    ['NPCS'] = 'NPCS',
    ['DODT'] = 'Destinations',
    ['AI_A'] = 'AI',
    ['AI_E'] = 'AI',
    ['AI_F'] = 'AI',
    ['AI_T'] = 'AI',
    ['AI_W'] = 'AI',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    assert(binaryReader:Peak(Size.INTEGER) == 'CREA')
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

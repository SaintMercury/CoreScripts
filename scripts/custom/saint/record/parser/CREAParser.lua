local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Types            = require('custom.saint.record.parser.primitive.Types')
local Size             = require('custom.saint.record.parser.primitive.Size')

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
        [FieldName.DODT] = ParseDODT,
        [FieldName.DNAM] = ParseDNAM,
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
local function ParseCNDT_E(binaryReader, context)
    context['CNDT_E'] = binaryReader:Read(binaryReader.length)
    local ai_ef = context['AI_E'] or nil
    if ai_ef then
        ai_ef.cndt = context['CNDT_E']
    end
    return context['CNDT_E']
end

---@param binaryReader BinaryStringReader
local function ParseCNDT_F(binaryReader, context)
    context['CNDT_F'] = binaryReader:Read(binaryReader.length)
    local ai_ef = context['AI_F'] or nil
    if ai_ef then
        ai_ef.cndt = context['CNDT_F']
    end
    return context['CNDT_F']
end

---@param binaryReader BinaryStringReader
local function ParseAI_E(binaryReader, context)
    local cndt = context['CNDT_E'] or nil
    context['AI_E'] = {
        x = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        y = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        z = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        duration = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        id = binaryReader:Read(32),
        unknown = binaryReader:Read(Size.BYTE, Types.UINT8),
        unused = binaryReader:Read(Size.BYTE, Types.UINT8),
        cndt = cndt
    }
    return context['AI_E']
end

---@param binaryReader BinaryStringReader
local function ParseAI_F(binaryReader, context)
    local cndt = context['CNDT_F'] or nil
    context['AI_F'] = {
        x = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        y = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        z = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        duration = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        id = binaryReader:Read(32),
        unknown = binaryReader:Read(Size.BYTE, Types.UINT8),
        unused = binaryReader:Read(Size.BYTE, Types.UINT8),
        cndt = cndt
    }
    return context['AI_F']
end

---@param binaryReader BinaryStringReader
local function ParseAI_EComposite(binaryReader, context)
    local followFields = {
        [FieldName.AI_E] = ParseAI_E,
        [FieldName.CNDT] = ParseCNDT_E,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

---@param binaryReader BinaryStringReader
local function ParseAI_FComposite(binaryReader, context)
    local followFields = {
        [FieldName.AI_F] = ParseAI_F,
        [FieldName.CNDT] = ParseCNDT_F,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
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
    [FieldName.NAME] = ParseNAME,
    [FieldName.MODL] = ParseMODL,
    [FieldName.CNAM] = ParseCNAM,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.SCRI] = ParseSCRI,
    [FieldName.NPDT] = ParseNPDT,
    [FieldName.FLAG] = ParseFLAG,
    [FieldName.XSCL] = ParseXSCL,
    [FieldName.NPCO] = ParseNPCO,
    [FieldName.NPCS] = ParseNPCS,
    [FieldName.AIDT] = ParseAIDT,

    --- Saint Note: Initially thought these were a composite, but it doesn't seem to be the case
    [FieldName.AI_A] = ParseAI_A,
    [FieldName.AI_T] = ParseAI_T,
    [FieldName.AI_W] = ParseAI_W,
    --- Saint Note: These actually are composite types
    -- [FieldName.AI_E] = ParseAI_EF,
    -- [FieldName.AI_F] = ParseAI_EF,
}

local compositeGroup = {
    [FieldName.DODT] = ParseCompositeDestination,
    [FieldName.AI_E] = ParseAI_EComposite,
    [FieldName.AI_F] = ParseAI_FComposite,
}

local arrayType = {
    [FieldName.NPCO] = FieldName.NPCO,
    [FieldName.NPCS] = FieldName.NPCS,
    [FieldName.DODT] = 'Destinations',
    [FieldName.AI_A] = 'AI',
    [FieldName.AI_E] = 'AI',
    [FieldName.AI_F] = 'AI',
    [FieldName.AI_T] = 'AI',
    [FieldName.AI_W] = 'AI',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

local function FlagsToObj(flagNum)
    return {
        targetsSkill = HasFlag(flagNum, 0x00001),
        targetsAttribute = HasFlag(flagNum, 0x00002),
        noDuration = HasFlag(flagNum, 0x00004),
        noMagnitude = HasFlag(flagNum, 0x00008),
        harmful = HasFlag(flagNum, 0x00010),
        continuousVfx = HasFlag(flagNum, 0x00020),
        canCastOnSelf = HasFlag(flagNum, 0x00040),
        canCastOnTouch = HasFlag(flagNum, 0x00080),
        canCastOnTarget = HasFlag(flagNum, 0x00100),
        spellmaking = HasFlag(flagNum, 0x00200),
        enchanting = HasFlag(flagNum, 0x00400),
        negativeLighting = HasFlag(flagNum, 0x00800),
        appliedOnce = HasFlag(flagNum, 0x01000),
        stealth = HasFlag(flagNum, 0x02000),
        cannotRecast = HasFlag(flagNum, 0x04000),
        illegalDaedra = HasFlag(flagNum, 0x08000),
        unreflectable = HasFlag(flagNum, 0x10000),
        linkedToCaster = HasFlag(flagNum, 0x20000),
    }
end

---@param binaryReader BinaryStringReader
local function ParseINDX(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local function ParseMEDT(binaryReader)
    local result = {
        school = binaryReader:Read(Size.INTEGER, Types.UINT32),
        baseCost = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
        red = binaryReader:Read(Size.INTEGER, Types.UINT32),
        green = binaryReader:Read(Size.INTEGER, Types.UINT32),
        blue = binaryReader:Read(Size.INTEGER, Types.UINT32),
        speedX = binaryReader:Read(Size.INTEGER, Types.UINT32),
        sizeX = binaryReader:Read(Size.INTEGER, Types.UINT32),
        sizeCap = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseITEX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseITEX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParsePTEX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseBSND(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseCSND(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseHSND(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseASND(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseCVFX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseBVFX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseHVFX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseAVFX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseDESC(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.INDX] = ParseINDX,
    [FieldName.MEDT] = ParseMEDT,
    [FieldName.ITEX] = ParseITEX,
    [FieldName.PTEX] = ParsePTEX,
    [FieldName.BSND] = ParseBSND,
    [FieldName.CSND] = ParseCSND,
    [FieldName.HSND] = ParseHSND,
    [FieldName.ASND] = ParseASND,
    [FieldName.BVFX] = ParseBVFX,
    [FieldName.CVFX] = ParseCVFX,
    [FieldName.HVFX] = ParseHVFX,
    [FieldName.AVFX] = ParseAVFX,
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

local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

local function FlagsToObj(flagNum)
    return {
        dynamic = HasFlag(flagNum, 0x0001),
        canCarry = HasFlag(flagNum, 0x0002),
        negative = HasFlag(flagNum, 0x0004),
        flicker = HasFlag(flagNum, 0x0008),
        fire = HasFlag(flagNum, 0x0010),
        offByDefault = HasFlag(flagNum, 0x0020),
        flickerSlow = HasFlag(flagNum, 0x0040),
        pulse = HasFlag(flagNum, 0x0080),
        pulseSlow = HasFlag(flagNum, 0x0100),
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
local function ParseFNAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseITEX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseLHDT(binaryReader)
    local result = {
        weight = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        value = binaryReader:Read(Size.INTEGER, Types.UINT32),
        time = binaryReader:Read(Size.INTEGER, Types.INT32),
        radius = binaryReader:Read(Size.INTEGER, Types.UINT32),
        color = {
            r = binaryReader:Read(Size.BYTE, Types.UINT8),
            g = binaryReader:Read(Size.BYTE, Types.UINT8),
            b = binaryReader:Read(Size.BYTE, Types.UINT8),
            a = binaryReader:Read(Size.BYTE, Types.UINT8),
        },
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseSNAM(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseSCRI(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.MODL] = ParseMODL,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.ITEX] = ParseITEX,
    [FieldName.LHDT] = ParseLHDT,
    [FieldName.SNAM] = ParseSNAM,
    [FieldName.SCRI] = ParseSCRI,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

local function FlagsToObj(flagNum)
    return {
        ignoreNormalWeaponResistance = HasFlag(flagNum, 0x1),
        silver = HasFlag(flagNum, 0x2),
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
local function ParseWPDT(binaryReader)
    local result = {
        weight            = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        value             = binaryReader:Read(Size.INTEGER, Types.UINT32),
        type              = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        health            = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        speed             = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        reach             = binaryReader:Read(Size.INTEGER, Types.FLOAT),
        enchantmentPoints = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        chopMin           = binaryReader:Read(Size.BYTE, Types.UINT8),
        chopMax           = binaryReader:Read(Size.BYTE, Types.UINT8),
        slashMin          = binaryReader:Read(Size.BYTE, Types.UINT8),
        slashMax          = binaryReader:Read(Size.BYTE, Types.UINT8),
        thrustMin         = binaryReader:Read(Size.BYTE, Types.UINT8),
        thrustMax         = binaryReader:Read(Size.BYTE, Types.UINT8),
        rawFlags          = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local function ParseITEX(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local function ParseENAM(binaryReader)
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

local funcMap        = {
    ['NAME'] = ParseNAME,
    ['MODL'] = ParseMODL,
    ['FNAM'] = ParseFNAM,
    ['WPDT'] = ParseWPDT,
    ['ITEX'] = ParseITEX,
    ['ENAM'] = ParseENAM,
    ['SCRI'] = ParseSCRI,
}

local compositeGroup = {
}

local arrayType      = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    assert(binaryReader:Peak(Size.INTEGER) == 'WEAP')
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

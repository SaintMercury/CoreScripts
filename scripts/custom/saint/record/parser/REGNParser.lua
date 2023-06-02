local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseFNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseWEAT = function(binaryReader)
    if binaryReader.length == 8 then
        return {
            clear = binaryReader:Read(Size.BYTE, Types.UINT8),
            cloudy = binaryReader:Read(Size.BYTE, Types.UINT8),
            foggy = binaryReader:Read(Size.BYTE, Types.UINT8),
            overcast = binaryReader:Read(Size.BYTE, Types.UINT8),
            rain = binaryReader:Read(Size.BYTE, Types.UINT8),
            thunder = binaryReader:Read(Size.BYTE, Types.UINT8),
            ash = binaryReader:Read(Size.BYTE, Types.UINT8),
            blight = binaryReader:Read(Size.BYTE, Types.UINT8),
        }
    elseif binaryReader.length == 10 then
        return {
            clear = binaryReader:Read(Size.BYTE, Types.UINT8),
            cloudy = binaryReader:Read(Size.BYTE, Types.UINT8),
            foggy = binaryReader:Read(Size.BYTE, Types.UINT8),
            overcast = binaryReader:Read(Size.BYTE, Types.UINT8),
            rain = binaryReader:Read(Size.BYTE, Types.UINT8),
            thunder = binaryReader:Read(Size.BYTE, Types.UINT8),
            ash = binaryReader:Read(Size.BYTE, Types.UINT8),
            blight = binaryReader:Read(Size.BYTE, Types.UINT8),
            snow = binaryReader:Read(Size.BYTE, Types.UINT8),
            blizzard = binaryReader:Read(Size.BYTE, Types.UINT8),
        }
    else
        error('IDK what WEAT type this is')
    end
end

---@param binaryReader BinaryStringReader
local ParseBNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCNAM = function(binaryReader)
    return {
        r = binaryReader:Read(Size.BYTE, Types.UINT8),
        g = binaryReader:Read(Size.BYTE, Types.UINT8),
        b = binaryReader:Read(Size.BYTE, Types.UINT8),
        a = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
end

local ParseSNAM = function(binaryReader)
    return {
        soundName = binaryReader:Read(32),
        chance = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
end

local funcMap = {
    [FieldName.NAME] = ParseNAME,
    [FieldName.FNAM] = ParseFNAM,
    [FieldName.WEAT] = ParseWEAT,
    [FieldName.BNAM] = ParseBNAM,
    [FieldName.CNAM] = ParseCNAM,
    [FieldName.SNAM] = ParseSNAM,
}

local compositeGroup = {
}

local arrayType = {
    [FieldName.SNAM] = FieldName.SNAM,
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

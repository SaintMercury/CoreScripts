local Types            = require('custom.saint.record.parser.primitive.Types')
local Size             = require('custom.saint.record.parser.primitive.Size')
local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local BaseFieldsParser = require('custom.saint.record.parser.BaseFieldsParser')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

local function FlagsToObj(flagNum)
    return {
        interior           = HasFlag(flagNum, 0x01),
        hasWater           = HasFlag(flagNum, 0x02),
        illegalRest        = HasFlag(flagNum, 0x04),
        behaveLikeExterior = HasFlag(flagNum, 0x80),
    }
end

---@param binaryReader BinaryStringReader
local ParseNAME = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseDATA = function(binaryReader)
    local result = {
        rawFlags = binaryReader:Read(Size.INTEGER, Types.UINT32),
        gridX = binaryReader:Read(Size.INTEGER, Types.INT32),
        gridY = binaryReader:Read(Size.INTEGER, Types.INT32),
    }
    result.flags = FlagsToObj(result.rawFlags)
    return result
end

---@param binaryReader BinaryStringReader
local ParseRGNN = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseNAM5 = function(binaryReader)
    return {
        r = binaryReader:Read(Size.BYTE, Types.UINT8),
        g = binaryReader:Read(Size.BYTE, Types.UINT8),
        b = binaryReader:Read(Size.BYTE, Types.UINT8),
        a = binaryReader:Read(Size.BYTE, Types.UINT8),
    }
end

---@param binaryReader BinaryStringReader
local ParseWHGT = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseAMBI = function(binaryReader)
    return {
        ambientColor = {
            r = binaryReader:Read(Size.BYTE, Types.UINT8),
            g = binaryReader:Read(Size.BYTE, Types.UINT8),
            b = binaryReader:Read(Size.BYTE, Types.UINT8),
            a = binaryReader:Read(Size.BYTE, Types.UINT8),
        },
        sunlightColor = {
            r = binaryReader:Read(Size.BYTE, Types.UINT8),
            g = binaryReader:Read(Size.BYTE, Types.UINT8),
            b = binaryReader:Read(Size.BYTE, Types.UINT8),
            a = binaryReader:Read(Size.BYTE, Types.UINT8),
        },
        fogColor = {
            r = binaryReader:Read(Size.BYTE, Types.UINT8),
            g = binaryReader:Read(Size.BYTE, Types.UINT8),
            b = binaryReader:Read(Size.BYTE, Types.UINT8),
            a = binaryReader:Read(Size.BYTE, Types.UINT8),
        },
        fogDensity = binaryReader:Read(Size.INTEGER, Types.FLOAT),
    }
end

---@param binaryReader BinaryStringReader
local ParseNAM0 = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseMVRF = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseCNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCNDT = function(binaryReader)
    return {
        gridX = binaryReader:Read(Size.INTEGER, Types.INT32),
        gridY = binaryReader:Read(Size.INTEGER, Types.INT32),
    }
end

---@param binaryReader BinaryStringReader
local ParseCompositeMovedReference = function(binaryReader, context)
    local followFields = {
        ['MVRF'] = ParseMVRF,
        ['CNAM'] = ParseCNAM,
        ['CNDT'] = ParseCNDT,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

---@param binaryReader BinaryStringReader
local ParseUNAM = function(binaryReader)
    return binaryReader:Read(Size.BYTE, Types.UINT8)
end

---@param binaryReader BinaryStringReader
local ParseXSCL = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseXSOL = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseXCHG = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseINTV = function(binaryReader)
    ---Saint Note: Could be either a uint32 or a float :(
    return binaryReader:Read(Size.INTEGER, Types.FLOAT)
end

---@param binaryReader BinaryStringReader
local ParseNAM9 = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseFLTV = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseKNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseTNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseZNAM = function(binaryReader)
    return binaryReader:Read(Size.BYTE, Types.UINT8)
end

---@param binaryReader BinaryStringReader
local ParseDODT = function(binaryReader)
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
local ParseANAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseBNAM = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseINDX = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseCompositeFaction = function(binaryReader, context)
    local followFields = {
        ['CNAM'] = ParseCNAM,
        ['INDX'] = ParseINDX,
    }
    local followComposities = {
    }
    local followArrays = {
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

---@param binaryReader BinaryStringReader
local ParseDNAM = function(binaryReader)
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
local ParseFRMR = function(binaryReader)
    return binaryReader:Read(Size.INTEGER, Types.UINT32)
end

---@param binaryReader BinaryStringReader
local ParseCompositeFormReference = function(binaryReader, context)
    local followFields = {
        ['FRMR'] = ParseFRMR,
        ['NAME'] = ParseNAME,
        ['UNAM'] = ParseUNAM,
        ['XSCL'] = ParseXSCL,
        ['XSOL'] = ParseXSOL,
        ['XCHG'] = ParseXCHG,
        ['INTV'] = ParseINTV,
        ['ANAM'] = ParseANAM,
        ['BNAM'] = ParseBNAM,
        ['NAM9'] = ParseNAM9,
        ['FLTV'] = ParseFLTV,
        ['KNAM'] = ParseKNAM,
        ['TNAM'] = ParseTNAM,
        ['ZNAM'] = ParseZNAM,
        ['DATA'] = ParseDODT,
    }
    local followComposities = {
        ['CNAM'] = ParseCompositeFaction,
        ['DODT'] = ParseCompositeDestination,
    }
    local followArrays = {
        ['DODT'] = 'Destinations',
    }
    return BaseFieldsParser(binaryReader, followFields, followComposities, followArrays, context)
end

local funcMap = {
    ['NAME'] = ParseNAME,
    ['DATA'] = ParseDATA,
    ['RGNN'] = ParseRGNN,
    ['NAM5'] = ParseNAM5,
    ['WHGT'] = ParseWHGT,
    ['AMBI'] = ParseAMBI,
    ['NAM0'] = ParseNAM0,
}

local compositeGroup = {
    ['MVRF'] = ParseCompositeMovedReference,
    ['FRMR'] = ParseCompositeFormReference,
}

local arrayType = {
    ['MVRF'] = 'MovedReferences',
    ['FRMR'] = 'FormReferences',
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    assert(binaryReader:Peak(Size.INTEGER) == 'CELL')
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

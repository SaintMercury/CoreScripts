local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local FieldName        = require('custom.saint.record.parser.primitive.FieldName')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
local ParseSCHD = function(binaryReader, context)
    local data = {
        name = binaryReader:Read(32),
        numShorts = binaryReader:Read(Size.INTEGER, Types.UINT32),
        numLongs = binaryReader:Read(Size.INTEGER, Types.UINT32),
        numFloats = binaryReader:Read(Size.INTEGER, Types.UINT32),
        scriptDataSize = binaryReader:Read(Size.INTEGER, Types.UINT32),
        localVarSize = binaryReader:Read(Size.INTEGER, Types.UINT32),
    }
    context['Variable Count'] = data.numShorts + data.numLongs + data.numFloats
    context['Script Size'] = data.scriptDataSize
    return data
end

---@param binaryReader BinaryStringReader
local ParseSCVR = function(binaryReader, context)
    local unparsedContent = binaryReader:Read(binaryReader.length)
    local count = context['Variable Count']
    local content = unparsedContent:split('%z')
    assert(count == #content, 'Unexpected amount of variables!')
    return content
end

---Interprets as a string, since we don't care
---@param binaryReader BinaryStringReader
local ParseSCDT = function(binaryReader, context)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
local ParseSCTX = function(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

local funcMap = {
    [FieldName.SCHD] = ParseSCHD,
    [FieldName.SCVR] = ParseSCVR,
    [FieldName.SCDT] = ParseSCDT,
    [FieldName.SCTX] = ParseSCTX,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

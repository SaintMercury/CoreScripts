local BaseRecordParser = require('custom.saint.record.parser.BaseRecordParser')
local Size             = require('custom.saint.record.parser.primitive.Size')
local Types            = require('custom.saint.record.parser.primitive.Types')
local HasFlag          = require('custom.saint.record.parser.primitive.Common')

local function PathGridDataFlagsToObject(flagNum)
    return {
        autoGenerated = HasFlag(flagNum, 0x01),
    }
end

local function PathPointFlagsToObj(flagNum)
    return {
        granularity_128 = HasFlag(flagNum, 0x80),
        granularity_256 = HasFlag(flagNum, 0x100),
        granularity_512 = HasFlag(flagNum, 0x200),
        granularity_1024 = HasFlag(flagNum, 0x400),
        granularity_2048 = HasFlag(flagNum, 0x800),
        granularity_4096 = HasFlag(flagNum, 0x1000),
    }
end

---@param binaryReader BinaryStringReader
---@param context table
local function ParseDATA(binaryReader, context)
    local data = {
        gridX = binaryReader:Read(Size.INTEGER, Types.INT32),
        gridY = binaryReader:Read(Size.INTEGER, Types.INT32),
        rawFlags = binaryReader:Read(Size.HALFWORD, Types.UINT16),
        pointCount = binaryReader:Read(Size.HALFWORD, Types.UINT16),
    }
    data.flags = PathGridDataFlagsToObject(data.rawFlags)

    -- Build the context
    context['Path Point Count'] = data.pointCount

    return data
end

---@param binaryReader BinaryStringReader
local function ParseNAME(binaryReader)
    return binaryReader:Read(binaryReader.length)
end

---@param binaryReader BinaryStringReader
---@param context table
local function ParsePGRP(binaryReader, context)
    local pointCount = context['Path Point Count']
    assert(pointCount ~= nil, 'Context not properly built! Cannot parse PGRP field')
    local connectionCount = 0
    local points = {}
    for i = 0, pointCount - 1, 1 do
        local pathPoint = {
            x = binaryReader:Read(Size.INTEGER, Types.INT32),
            y = binaryReader:Read(Size.INTEGER, Types.INT32),
            z = binaryReader:Read(Size.INTEGER, Types.INT32),
            rawFlags = binaryReader:Read(Size.BYTE, Types.UINT8),
            connectionCount = binaryReader:Read(Size.BYTE, Types.UINT8),
            unknown = binaryReader:Read(Size.HALFWORD, Types.INT16),
        }
        pathPoint.flags = PathPointFlagsToObj(pathPoint.rawFlags)
        connectionCount = connectionCount + pathPoint.connectionCount
        points[i] = pathPoint
    end
    context['Connections Count'] = connectionCount
    return points
end

---@param binaryReader BinaryStringReader
---@param context table
local function ParsePGRC(binaryReader, context)
    local connectionCount = context['Connections Count']
    assert(connectionCount ~= nil, 'Context not properly built! Cannot parse PGRC field')
    local connections = {}
    for i = 0, connectionCount - 1, 1 do
        connections[i] = binaryReader:Read(Size.INTEGER, Types.UINT32)
    end
    return connections
end

local funcMap = {
    ['DATA'] = ParseDATA,
    ['NAME'] = ParseNAME,
    ['PGRP'] = ParsePGRP,
    ['PGRC'] = ParsePGRC,
}

local compositeGroup = {
}

local arrayType = {
}

---@param binaryReader BinaryStringReader
return function(binaryReader)
    assert(binaryReader:Peak(Size.INTEGER) == 'PGRD')
    return BaseRecordParser(binaryReader, funcMap, compositeGroup, arrayType)
end

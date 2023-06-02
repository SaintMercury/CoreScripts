local Size       = require('custom.saint.record.parser.primitive.Size')
local Types      = require('custom.saint.record.parser.primitive.Types')

---@param binaryReader BinaryStringReader
return function (binaryReader)
    binaryReader:Read(Size.INTEGER, Types.UINT32)
end
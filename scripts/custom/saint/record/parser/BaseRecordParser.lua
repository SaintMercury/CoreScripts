local BinaryStringReader = require('custom.saint.io.main')
local BaseFieldsParser   = require('custom.saint.record.parser.BaseFieldsParser')
local ParseRecord        = require('custom.saint.record.parser.primitive.ParseRecord')

---@param binaryReader BinaryStringReader
---@param funcMap FuncMap
---@param compositeType CompositeType
---@param arrayType ArrayType
---@param context table|nil
return function(binaryReader, funcMap, compositeType, arrayType, context)
    context = context or {}
    local record = ParseRecord(binaryReader)
    local fieldsParser = BinaryStringReader(record.data)
    local fields = BaseFieldsParser(fieldsParser, funcMap, compositeType, arrayType, context)
    return {
        record = record,
        fields = fields,
    }
end
local BinaryStringReader = require('custom.saint.io.main')
local DELEFieldParser    = require('custom.saint.record.parser.primitive.DELEFieldParser')
local ParseField         = require('custom.saint.record.parser.primitive.ParseField')
local Size               = require('custom.saint.record.parser.primitive.Size')

---@param binaryReader BinaryStringReader
---@param funcMap FuncMap
---@param compositeType CompositeType
---@param arrayType ArrayType
---@param context table
return function(binaryReader, funcMap, compositeType, arrayType, context)
    local fields = {}
    while binaryReader:HasData() do
        local fieldName = binaryReader:Peak(Size.INTEGER)
        local singularFunc = funcMap[fieldName]
        local compositeFunc = compositeType[fieldName]
        local arrayFieldName = arrayType[fieldName]
        local data ---@type table

        -- IDK bout this, but this should PROBABLY be true
        if fields[fieldName] ~= nil and not arrayFieldName then
            -- probably should be a break condition
            -- error('Attempting to write to an already written field!')
            -- We are looking into something that is either ANOTHER record
            -- or another array item
            ---Saint Note: This feels like a hack
            break
        end

        ---Saint Note: Move 'DELE' to somewhere else
        ---Saint Note: This delete likely doesn't work properly
        if fieldName == 'DELE' then
            local field = ParseField(binaryReader)
            data = DELEFieldParser(BinaryStringReader(field.data))
        elseif compositeFunc then
            ---Saint Note: wth?
            data = compositeFunc(binaryReader, context)
        elseif singularFunc then
            local field = ParseField(binaryReader)
            data = singularFunc(BinaryStringReader(field.data), context)
        else
            -- We are looking into something that is either ANOTHER record
            -- or another array item
            ---Saint Note: This feels like a hack
            break
        end

        if arrayFieldName then
            local array = fields[arrayFieldName] or {}
            table.insert(array, data)
            fields[arrayFieldName] = array
        elseif compositeFunc then
            -- if the field is composite but not an array
            for key, value in pairs(data) do
                assert(fields[key] == nil)
                fields[key] = value
            end
        else
            fields[fieldName] = data
        end
    end
    return fields
end
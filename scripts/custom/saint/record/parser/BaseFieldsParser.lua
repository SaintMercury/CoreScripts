local BinaryStringReader = require('custom.saint.io.main')
local DELEFieldParser    = require('custom.saint.record.parser.primitive.DELEFieldParser')
local ParseField         = require('custom.saint.record.parser.primitive.ParseField')
local Size               = require('custom.saint.record.parser.primitive.Size')

---@param binaryReader BinaryStringReader
---@param funcMap FuncMap
---@param compositeType CompositeType
---@param arrayType ArrayType
---@param context table
---@return table<FIELD_NAME, any>
return function(binaryReader, funcMap, compositeType, arrayType, context)
    local fields = {}
    while binaryReader:HasData() do
        local fieldName = binaryReader:Peak(Size.INTEGER) ---@type string
        local singularFunc = funcMap[fieldName]
        local compositeFunc = compositeType[fieldName]
        local arrayFieldName = arrayType[fieldName]
        local data ---@type table

        -- next array item case
        if fields[fieldName] ~= nil and not arrayFieldName then
            -- We are looking into another item of the array

            -- upon further investigation, this is necessary in the current implementation
            -- when a record is like:
            --
            -- anam
            -- intv
            -- anam
            -- intv
            --
            -- and we are parsing the anam/intv pair as a composite
            -- we have no way of knowing the size of the pair/object, or even in most
            -- cases the count, therefore, once we've parsed everything necessary, we
            -- stop and know we are done
            --
            -- discovered when parsing FACT w/ ANAM

            break
        end

        -- outside of composite case
        if fields[fieldName] == nil and not (singularFunc or compositeFunc) then
            -- We are looking into a field OUTSIDE of the array/composite
            break
        end

        ---Saint Note: Move 'DELE' to somewhere else
        ---Saint Note: DELE can't be moved unless/until there is a common place
        ---Saint Note: to put in a default place for all of the XXXXParser

        -- parsing
        if fieldName == 'DELE' then
            local field = ParseField(binaryReader)
            DELEFieldParser(BinaryStringReader(field.data))
            fields['DELE'] = true
        elseif compositeFunc then
            data = compositeFunc(binaryReader, context)
        elseif singularFunc then
            local field = ParseField(binaryReader)
            data = singularFunc(BinaryStringReader(field.data), context)
        end

        -- collection
        if arrayFieldName then
            local array = fields[arrayFieldName] or {}
            table.insert(array, data)
            fields[arrayFieldName] = array
        elseif compositeFunc then
            -- if the field is composite but not an array
            for key, value in pairs(data) do
                fields[key] = value
            end
        else
            fields[fieldName] = data
        end
    end
    return fields
end
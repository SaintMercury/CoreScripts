local classy = require('classy')
local ffi = require('ffi')

---@class BinaryStringReader
---@overload fun(binaryData: string): BinaryStringReader
local BinaryStringReader = classy('BinaryStringReader')

---@private
---@param binaryData string
function BinaryStringReader:__init(binaryData)
    ---@private
    self.binaryString = binaryData
    ---@public
    self.length = #binaryData
    ---@private
    self.index = 1
end

---@param byteCount integer
---@param type string
---@return number
---@overload fun(self: BinaryStringReader, byteCount: integer): string
function BinaryStringReader:Read(byteCount, type)
    local result = self:_read(byteCount, true)
    if type then
        return ffi.cast(type .. '*', result)[0]
    end
    return result
end

---@param byteCount integer
---@return string|nil
function BinaryStringReader:Peak(byteCount)
    if self:HasData() then
        return self:_read(byteCount, false)
    end
    return nil
end

---@private
---@param byteCount integer
---@param increment boolean
---@return string
function BinaryStringReader:_read(byteCount, increment)
    local offset = byteCount - 1 -- sub is inclusive and 1 based indexing sucks
    local start = self.index
    local finish = start + offset
    if finish > self.length then
        error('Attempting to read beyond length')
    end
    local data = string.sub(self.binaryString, start, finish)
    if increment then
        self.index = start + byteCount
    end
    return data
end

---@param byteCount integer
function BinaryStringReader:Unread(byteCount)
    self.index = self.index - byteCount
    if self.index < 1 then error('Attempting to unread to a negative index') end
end

function BinaryStringReader:HasData()
    return self.index <= self.length
end

return BinaryStringReader

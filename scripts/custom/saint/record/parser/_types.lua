---@alias ParseFunc fun(binaryReader: BinaryStringReader, context: table|nil): table<string, any>
---@alias FuncMap table<string, ParseFunc>
---@alias CompositeType table<string, ParseFunc>
---@alias ArrayType table<string, string>
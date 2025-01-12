local Database = require("database")
local BaseWorld = require("world.base")

---@class SqlWorld : BaseWorld
---@overload fun(): SqlWorld
local World = class("World", BaseWorld)

function World:__init()
    BaseWorld.__init(self)

    if self.hasEntry == nil then

        local test = Database:GetSingleValue("world_general", "currentMpNum", "")

        if test ~= nil then
            self.hasEntry = true
        else
            self.hasEntry = false
        end
    end
end

function World:CreateEntry()
    self:SaveToDrive()
    self.hasEntry = true
end

function World:SaveToDrive()
    Database:SaveWorld(self.data)
end

function World:LoadFromDrive()
    self.data = Database:LoadWorld(self.data)
end

return World

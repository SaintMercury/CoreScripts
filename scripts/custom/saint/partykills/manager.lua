local customEventHooks = require('customEventHooks')
local logicHandler     = require('logicHandler')
local SaintLogger      = require('custom.saint.common.logger.main')

local logger = SaintLogger:GetLogger('SaintPartyKills')

customEventHooks.registerHandler("OnActorDeath", function(eventStatus, pid)
    if not eventStatus.validCustomHandlers then return eventStatus end

    local player = Players[pid]
    local allies = player.data.alliedPlayers

    tes3mp.ReadReceivedWorldstate()

    for index = 0, tes3mp.GetActorListSize() - 1 do
        local refId = tes3mp.GetActorRefId(index)
        local killer = tes3mp.GetActorKillerName(index)
        local killerPid = tes3mp.GetActorKillerPid(index)
        local deathState = tes3mp.GetActorDeathState(index)
        print('***********************************************')
        print(deathState)
        print(killer)
        print(killerPid)
        print(refId)
        print('***********************************************')
    end

    for _, allyName in pairs(allies) do
        local allyPlayer = logicHandler.GetPlayerByName(allyName)
        if allyPlayer ~= nil and allyPlayer:IsLoggedIn() then
            logger:Verbose("Updating player '" .. allyName .. " with new kill(s)")
            allyPlayer:SaveKills()
            allyPlayer:LoadKills()
        end
    end

    return eventStatus
end)

customEventHooks.registerHandler("OnServerPostInit", function(es)
    logger:Info("Starting SaintPartyKills...")
    return es
end)

return {}

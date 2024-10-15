ESX = exports.es_extended.getSharedObject()

RegisterNetEvent('mks:elevator:sendplayer', function(target, floor)
    local src = source
    if GetPlayerName(target) then
        local targetPlayer = GetPlayerPed(target)
        TriggerClientEvent('mks:elevator:selectfloor', target, floor, src)
    else
        print('Gracz o ID ' .. target .. ' nie jest online.')
    end
end)
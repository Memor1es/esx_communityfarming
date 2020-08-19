ESX                			 = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_communityfarming:harvest')
AddEventHandler('esx_communityfarming:harvest', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addInventoryItem("wheat", 1)
end)

RegisterServerEvent('esx_communityfarming:sell')
AddEventHandler('esx_communityfarming:sell', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    local numberOfWheat = xPlayer.getInventoryItem('wheat').count

    if numberOfWheat > 0 then
        xPlayer.removeInventoryItem('wheat', numberOfWheat)
    end

    xPlayer.addAccountMoney('bank', Config.wheatSell.price * numberOfWheat)
end)
RegisterServerEvent("ice_metakeys")
AddEventHandler("ice_metakeys", function(src, plate, kocsiNev)
        local xPlayer = ESX.GetPlayerFromId(source)
        local src = source
        local item = 'carkeys'
        local result =
            exports.ghmattimysql:scalarSync("SELECT `owner` from `owned_vehicles` WHERE `plate` = @plate", {["@plate"] = plate})

        local metadata = {
            type = 'Čisté klíče od auta',
            description = 'Použij /carkey pro vytvoření klíče pro tvé auto'
        }
        if result then
            if ESX.GetConfig().Multichar == true then
                local result2 = xPlayer.identifier
                if result == result2 then
                    local hasItem = xPlayer.getInventoryItem(item, metadata)
                    if hasItem.count > 0 then
                        sendToDiscord(GetPlayerName(src)..'\n'..ConfigSV.Language["WH_RegistredKey"]..'\n'..plate)
                        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "inform", text = ConfigSV.Language["keyisready"]})
                        xPlayer.removeInventoryItem(item, 1, metadata)
                        local metadata = {}
                        metadata.type = kocsiNev
                        metadata.description = plate
                        xPlayer.addInventoryItem(item, 1, metadata)
                    else
                        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = ConfigSV.Language["nodefaultkey"]})
                    end
                else
                    sendToDiscord(GetPlayerName(src)..'\n'..ConfigSV.Language["WH_NotOwned"])
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = ConfigSV.Language["notyourvehicle"]})
                end
            else
                local result2 = GetPlayerIdentifier(xPlayer.source)
                if "license:" .. result == result2 then
                    local hasItem = xPlayer.getInventoryItem(item, metadata)
                    if hasItem.count > 0 then
                        sendToDiscord(GetPlayerName(src)..'\n'..ConfigSV.Language["WH_RegistredKey"]..'\n'..plate)
                        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "inform", text = ConfigSV.Language["keyisready"]})
                        xPlayer.removeInventoryItem(item, 1, metadata)
                        local metadata = {}
                        metadata.type = kocsiNev
                        metadata.description = plate
                        xPlayer.addInventoryItem(item, 1, metadata)
                    else
                        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = ConfigSV.Language["nodefaultkey"]})
                    end
                else
                    sendToDiscord(GetPlayerName(src)..'\n'..ConfigSV.Language["WH_NotOwned"])
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = ConfigSV.Language["notyourvehicle"]})
                end
            end
        else
            TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "inform", text = ConfigSV.Language["needlook"]})
        end
    end)


function sendToDiscord(msg)
    PerformHttpRequest(ConfigSV.Webhook, function(a,b,c)end, "POST", json.encode({embeds={{title=ConfigSV.WebhookName,description=msg:gsub("%^%d",""),color=15844367,}}}), {["Content-Type"]="application/json"})
end
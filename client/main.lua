-- From point A to B -- Use GetOffsetFromEntityInWorldCoords for distance
function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function StartWorkaroundTask()
	if isRunningWorkaround then
		return
	end

	local timer = 0
	local playerPed = PlayerPedId()
	isRunningWorkaround = true

	while timer < 100 do
		Citizen.Wait(0)
		timer = timer + 1

		local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
		local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)

		if DoesEntityExist(targetVehicle) then
			local lockStatus = GetVehicleDoorLockStatus(targetVehicle)

			if lockStatus == 4 then
				ClearPedTasks(playerPed)
			end
		end
	end

	isRunningWorkaround = false
end

function startLock(targetVehicle, itemType, itemDesc)
	local plate = GetVehicleNumberPlateText(targetVehicle)
	local model = GetEntityModel(targetVehicle)
	local kocsiNev = GetDisplayNameFromVehicleModel(model)
	if itemType == kocsiNev and itemDesc == plate then
		TriggerEvent('ice_metakeys:lockVehicle', targetVehicle, plate, model, kocsiNev)
	else
	end
end

RegisterNetEvent('ice_metakeys:OpenCloseCar')
AddEventHandler('ice_metakeys:OpenCloseCar', function(item, wait, cb)
		cb(true)
		SetTimeout(wait, function()
			if not cancelled then
				local playerPed = PlayerPedId()
				if IsPedInAnyVehicle(playerPed, true) then
					targetVehicle = GetVehiclePedIsIn(playerPed, false)
					startLock(targetVehicle, item.metadata.type, item.metadata.description)
				else
					local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
					local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
					local targetVehicle = getVehicleInDirection(coordA, coordB)
					if targetVehicle ~= 0 then
						startLock(targetVehicle, item.metadata.type, item.metadata.description)
					else
						exports['mythic_notify']:SendAlert('error', Config.Language["turn"])
					end
				end
			end
	end)
end)

RegisterNetEvent('ice_metakeys:lockVehicle')
AddEventHandler('ice_metakeys:lockVehicle', function(targetVehicle, plate, model, kocsiNev)
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		StartWorkaroundTask()
	end)

	local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end

	local lockStatus = GetVehicleDoorLockStatus(targetVehicle)
	if IsPedInAnyVehicle(playerPed, true) then
		if lockStatus == 1 then
			SetVehicleDoorShut(targetVehicle, 0, false)
			SetVehicleDoorShut(targetVehicle, 1, false)
			SetVehicleDoorShut(targetVehicle, 2, false)
			SetVehicleDoorShut(targetVehicle, 3, false)
			SetVehicleDoorsLocked(targetVehicle, 4)
			SetVehicleDoorsLockedForAllPlayers(targetVehicle, true)
			PlaySoundFromEntity(-1, "Remote_Control_Close", targetVehicle, "PI_Menu_Sounds", 1, 0)
			exports['mythic_notify']:SendAlert('error', Config.Language["vehlocked"])
		elseif lockStatus == 4 then
			SetVehicleDoorsLocked(targetVehicle, 1)
			SetVehicleDoorsLockedForAllPlayers(targetVehicle, false)
			PlaySoundFromEntity(-1, "Remote_Control_Open", targetVehicle, "PI_Menu_Sounds", 1, 0)
			exports['mythic_notify']:SendAlert('success', Config.Language["vehunlocked"])
		end
	else
	if lockStatus == 1 then
		SetVehicleDoorShut(targetVehicle, 0, false)
		SetVehicleDoorShut(targetVehicle, 1, false)
		SetVehicleDoorShut(targetVehicle, 2, false)
		SetVehicleDoorShut(targetVehicle, 3, false)
		SetVehicleDoorsLocked(targetVehicle, 2)
		SetVehicleDoorsLockedForAllPlayers(targetVehicle, true)
		PlaySoundFromEntity(-1, "Remote_Control_Close", targetVehicle, "PI_Menu_Sounds", 1, 0)
		exports['mythic_notify']:SendAlert('error', Config.Language["vehlocked"])
	elseif lockStatus == 2 then
		SetVehicleDoorsLocked(targetVehicle, 1)

		SetVehicleDoorsLockedForAllPlayers(targetVehicle, false)
		PlaySoundFromEntity(-1, "Remote_Control_Open", targetVehicle, "PI_Menu_Sounds", 1, 0)
		exports['mythic_notify']:SendAlert('success', Config.Language["vehunlocked"])
	end
end
end)

RegisterCommand('carkey', function(source, args, rawCommand)
		local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
		local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
		local plate = GetVehicleNumberPlateText(targetVehicle)
		local model = GetEntityModel(targetVehicle)
		local kocsiNev = GetDisplayNameFromVehicleModel(model)
    TriggerServerEvent('ice_metakeys', source, plate, kocsiNev)
end, false)

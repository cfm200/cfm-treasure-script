local QBCore = exports['qb-core']:GetCoreObject()

math.randomseed(GetGameTimer()) -- make randomness more random lol
local playerId = PlayerPedId()
local isHuntActive = false -- flag for checking if hunt is active
local location = Config.Locations[math.random(1, #Config.Locations)] -- sets the variable location to a random index of the Config.Locations table

CreateThread(function()
    while true do
      Wait(500)
      for k = 1, #Config.Peds, 1 do
        value = Config.Peds[k]
        local playerCoords = GetEntityCoords(playerId)
        local playerDistance = #(playerCoords - value.coords)

        if playerDistance < Config.Distance and not value.isRendered then
          local ped = SpawnPed(value.model, value.coords, value.heading)
          value.ped = ped
          value.isRendered = true
        end

        if playerDistance >= Config.Distance and value.isRendered then
          if Config.Fade then
            for i = 255, 0, -51 do
              Wait(50)
              SetEntityAlpha(value.ped, i, false)
            end
          end
          DeletePed(ped)
          value.ped = nil
          value.isRendered = false
        end
      end
    end
  end)

function SpawnPed(model, coords, heading)
  RequestModel(GetHashKey(model))
  while not HasModelLoaded(GetHashKey(model)) do
    Wait(1)
  end

   ped = CreatePed(0, GetHashKey(value.model), coords, heading, false, true)

   SetEntityAlpha(ped, 0, false)

  if Config.Invincible then
    SetEntityInvincible(ped)
  end

  if Config.Frozen then
    FreezeEntityPosition(ped, true)
  end

  if Config.Stoic then
    SetBlockingOfNonTemporaryEvents(ped, true)
  end

  if Config.Fade then
		for i = 0, 255, 51 do
			Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end

  return ped
end

local function HuntMessage(text, textype, length)
  QBCore.Functions.Notify(text, textype, length)
end

-- displays a notification to the player
local function ShowNotification(text)
  BeginTextCommandDisplayHelp("STRING")
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayHelp(0, false, true, 3000)
end

-- displays a marker at certain coords 
local function DisplayMarker()
  DrawMarker(
	29,
	location.coords.x --[[ number ]], 
	location.coords.y --[[ number ]], 
	location.coords.z --[[ number ]], 
	0.5 --[[ number ]], 
	0.5 --[[ number ]], 
	0.0 --[[ number ]], 
	0.5 --[[ number ]], 
	0.5 --[[ number ]], 
	0.5 --[[ number ]], 
	0.5 --[[ number ]], 
	0.5 --[[ number ]], 
	0.5 --[[ number ]], 
	1 --[[ integer ]], 
	255 --[[ integer ]], 
	44 --[[ integer ]], 
	200 --[[ integer ]], 
	true --[[ boolean ]], 
	false --[[ boolean ]], 
	false --[[ integer ]], 
	false --[[ boolean ]]
)
end

-- compares target coord to player coord
local function CheckDistance(loc)
  CreateThread(function() -- need to continously check player coord so thread is used
    while true do

      local playerCoords = GetEntityCoords(playerId) -- gets player coords
      local distance = #(playerCoords - loc.coords) -- calculates distance between target coord and player coords

      if distance < 8.0 then
        DisplayMarker() -- displays marker if player is less than 8 units from target coord

        if distance < 2.0 then
          ShowNotification('Press ~INPUT_PICKUP~ to Search') -- shows notification to press E when the players gets even closer to target
          
          if IsControlJustPressed(0, 38) then -- checks if E (38) is pressed
            if not IsPedInAnyVehicle(playerId, true) then -- checks if player is not in a vehicle

              if lib.progressBar({
                duration = 10000,
                label = "Searching for Treasure",
                useWhileDead = false,
                canCancel = true,
                anim = {
                  scenario = 'WORLD_HUMAN_GARDENER_PLANT'
                }
              }) then
                -- move this because player can still get loot if they cancel
                TriggerServerEvent("giveItem", playerId)
                HuntMessage("You found treasure!", "success", 5000)
              else
                HuntMessage("You Have Stopped Searching!", "error", 5000)
              end

              isHuntActive = false -- sets flag back to false (player is no longer treasure hunting)
              break -- escapes while loop
            else
              ShowNotification('You must exit the vehicle to search!')
              Wait(3000) -- displays above message for 3 seconds
            end
          end
        end
      end
      Wait(0) -- protects against infintie loop
    end
  end)
end

-- sets a random waypoint based on Config.Locations
local function RandomLocation()
  location = Config.Locations[math.random(1, #Config.Locations)]
  if location ~= nil then
      SetNewWaypoint(location.coords)
      isHuntActive = true
      CheckDistance(location)
  end
end


RegisterNetEvent('cfm-treasure:client:randomLocation', function()
  if isHuntActive == false then
    RandomLocation()
    HuntMessage("Treasure Hunt Started", "success", 5000)
  else
    HuntMessage("A Treasure Hunt is Active!", "error", 5000)
    print('A Treasure Hunt is Active!')
  end
end)
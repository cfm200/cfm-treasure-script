--local QBCore = exports['qb-core']:GetCoreObject()

math.randomseed(GetGameTimer()) -- make randomness more random lol
local playerId = PlayerPedId()
local isHuntActive = false -- flag for checking if hunt is active
local location = Config.Locations[math.random(1, #Config.Locations)] -- sets the variable location to a random index of the Config.Locations table

local function SearchProgressBar()

  TaskStartScenarioInPlace(playerId, "CODE_HUMAN_MEDIC_KNEEL", 0, false)
  TaskStartScenarioInPlace(playerId, "WORLD_HUMAN_GARDENER_PLANT", 0, false)

  lib.progressBar({
    duration = 5000,
    label = 'Searching for Treasure',
    useWhileDead = false,
    canCancel = true,
    disable = {
      car = true,
      move = true,
      combat = true
    }
  })

  ClearPedTasksImmediately(playerId)

end

local function HuntStartMessage()
  lib.notify({
    title = 'Treasure Hunt Activated!',
    description = "A Waypoint has been set!",
    type = 'success',
    duration = 3000
  })
end

local function HuntErrorMessage()
    lib.notify({
      title = 'A Treasure Hunt is Active!',
      description = "Find it!",
      type = 'error',
      duration = 3000
    })
  end

local function TreasureFoundMessage()
  lib.notify({
    title = 'Treasure Found!',
    description = "I wonder what you'll find next?",
    type = 'success',
    duration = 3000
  })
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
              SearchProgressBar()
              TreasureFoundMessage()
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
    HuntStartMessage()
  else
    HuntErrorMessage()
    print('A Treasure Hunt is Active!')
  end
end)
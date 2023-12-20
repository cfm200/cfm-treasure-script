local QBCore = exports['qb-core']:GetCoreObject()

-- RegisterNetEvent("giveItem", function()
--   local src= source
--   local Player = QBCore.Functions.GetPlayer(src)
--   local randomItem = Config.Loot[math.random(#Config.Loot)]

--   Player.Functions.AddItem(randomItem, math.random(1, 10))

--   TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randomItem], "add")
-- end)

RegisterNetEvent("giveItem", function()
  local src= source
  local Player = QBCore.Functions.GetPlayer(src)
  --local randomItem = Config.Loot[math.random(#Config.Loot)]

  Player.Functions.AddItem("treasuremap", math.random(1, 10))

  --TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["treasuremap"], "add")
end)
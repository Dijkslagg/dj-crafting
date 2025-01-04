local QBCore = exports['qb-core']:GetCoreObject()
local currentProps = {}
local craftingOpen = false
local currentTableId = nil

local function DeleteProps()
    for _, prop in pairs(currentProps) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    currentProps = {}
end

local function SpawnCraftingTables()
    DeleteProps()
    
    for tableId, tableData in pairs(Config.CraftingTables) do
        local groundZ = 0
        local success, z = GetGroundZFor_3dCoord(tableData.coords.x, tableData.coords.y, tableData.coords.z, true)
        if success then
            groundZ = z
        end
        
        local prop = CreateObject(GetHashKey(tableData.model), tableData.coords.x, tableData.coords.y, groundZ, false, false, false)
        SetEntityHeading(prop, tableData.coords.w)
        FreezeEntityPosition(prop, true)
        currentProps[tableId] = prop
        
        exports['qb-target']:AddTargetEntity(prop, {
            options = {
                {
                    type = "client",
                    event = "dj-test:client:OpenCraftingMenu",
                    icon = "fas fa-box",
                    label = "Open Crafting Table",
                    tableId = tableId
                }
            },
            distance = 2.0
        })
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Wait(1000)
    SpawnCraftingTables()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if LocalPlayer.state.isLoggedIn then
            SpawnCraftingTables()
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteProps()
    end
end)

RegisterNetEvent('dj-test:client:OpenCraftingMenu')
AddEventHandler('dj-test:client:OpenCraftingMenu', function(data)
    if not craftingOpen then
        local tableData = Config.CraftingTables[data.tableId]
        if not tableData then return end
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vector3(tableData.coords.x, tableData.coords.y, tableData.coords.z))
        if distance > 3.0 then return end
        
        craftingOpen = true
        currentTableId = data.tableId
        SetNuiFocus(true, true)
        
        local tableData = Config.CraftingTables[data.tableId]
        local inventory = {}
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        if PlayerData and PlayerData.items then
            for _, item in pairs(PlayerData.items) do
                if item then
                    inventory[item.name] = item.amount
                end
            end
        end
        
        QBCore.Functions.TriggerCallback('dj-test:server:GetCraftingLevel', function(level, xp, progression)
            SendNUIMessage({
                action = "openCrafting",
                recipes = tableData.recipes,
                categories = tableData.categories,
                tableName = tableData.name,
                playerLevel = level,
                playerXp = xp,
                inventory = inventory,
                useProgression = tableData.useProgression,
                progression = progression,
                tableId = currentTableId
            })
        end, currentTableId)
    end
end)

RegisterNUICallback('closeCrafting', function(_, cb)
    craftingOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('startCrafting', function(data, cb)
    TriggerServerEvent('dj-test:server:StartCrafting', data.recipe, data.amount, currentTableId)
    cb('ok')
end)

RegisterNUICallback('showNotification', function(data, cb)
    exports.ox_lib:notify({
        title = 'Crafting',
        description = data.message,
        type = data.type
    })
    cb('ok')
end)

RegisterNetEvent('dj-test:client:StartCrafting')
AddEventHandler('dj-test:client:StartCrafting', function(success, message)
    if success then
        local inventory = {}
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        if PlayerData and PlayerData.items then
            for _, item in pairs(PlayerData.items) do
                if item then
                    inventory[item.name] = item.amount
                end
            end
        end
        
        SendNUIMessage({
            action = "updateInventory",
            inventory = inventory
        })
    end
    
    exports.ox_lib:notify({
        title = 'Crafting',
        description = message,
        type = success and 'success' or 'error'
    })
end)
RegisterNetEvent('dj-test:client:LevelUp')
AddEventHandler('dj-test:client:LevelUp', function(newLevel)
    exports.ox_lib:notify({
        title = 'Level Up!',
        description = 'You reached level ' .. newLevel,
        type = 'success'
    })
end)

RegisterNetEvent('dj-test:client:UpdateXP')
AddEventHandler('dj-test:client:UpdateXP', function(newLevel, newXP, tableId)
    if currentTableId == tableId then
        SendNUIMessage({
            action = "updateXP",
            level = newLevel,
            xp = newXP,
            tableId = tableId,
            xpConfig = Config.CraftingTables[tableId].progression 
        })
    end
end)
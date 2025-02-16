local QBCore = exports['qb-core']:GetCoreObject()

local craftingCooldowns = {}

CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `player_crafting` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `citizenid` varchar(50) NOT NULL,
            `table_id` int(11) NOT NULL,
            `level` int(11) NOT NULL DEFAULT 1,
            `xp` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            UNIQUE KEY `citizen_table` (`citizenid`, `table_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

local function CalculateXPForNextLevel(level, tableConfig)
    if not tableConfig.useProgression then return 0 end
    return tableConfig.progression.baseXP * math.pow(tableConfig.progression.multiplier, level - 1)
end

local function CheckLevelUp(source, citizenid, currentXP, currentLevel, tableId)
    local tableConfig = Config.CraftingTables[tableId]
    if not tableConfig.useProgression then return currentLevel, currentXP end

    local xpForNextLevel = CalculateXPForNextLevel(currentLevel, tableConfig)
    
    while currentXP >= xpForNextLevel do
        currentXP = currentXP - xpForNextLevel
        currentLevel = currentLevel + 1
        
        MySQL.query('UPDATE player_crafting SET level = ?, xp = ? WHERE citizenid = ? AND table_id = ?', {
            currentLevel,
            currentXP,
            citizenid,
            tableId
        })
        
        TriggerClientEvent('dj-test:client:LevelUp', source, currentLevel, tableId)
        xpForNextLevel = CalculateXPForNextLevel(currentLevel, tableConfig)
    end
    
    return currentLevel, currentXP
end

QBCore.Functions.CreateCallback('dj-test:server:GetCraftingLevel', function(source, cb, tableId)
    local Player = QBCore.Functions.GetPlayer(source)
    local tableConfig = Config.CraftingTables[tableId]
    
    if not tableConfig.useProgression then
        cb(1, 0, { baseXP = 100, multiplier = 1.0 })
        return
    end
    
    MySQL.query('SELECT level, xp FROM player_crafting WHERE citizenid = ? AND table_id = ?', {
        Player.PlayerData.citizenid,
        tableId
    }, function(result)
        if not result then 
            print("^1Database error in GetCraftingLevel^7")
            cb(1, 0, tableConfig.progression)
            return 
        end
        if result[1] then
            cb(result[1].level, result[1].xp, tableConfig.progression)
        else
            MySQL.insert('INSERT INTO player_crafting (citizenid, table_id, level, xp) VALUES (?, ?, 1, 0)', {
                Player.PlayerData.citizenid,
                tableId
            })
            cb(1, 0, tableConfig.progression)
        end
    end)
end)

RegisterNetEvent('dj-test:server:StartCrafting')
AddEventHandler('dj-test:server:StartCrafting', function(recipe, amount, tableId)
    if type(recipe) ~= "table" or 
       type(amount) ~= "number" or 
       type(tableId) ~= "number" then 
        return 
    end
    
    local tableConfig = Config.CraftingTables[tableId]
    if not tableConfig then return end
    
    local isValidRecipe = false
    local serverRecipe = nil
    for _, configRecipe in pairs(tableConfig.recipes) do
        if recipe.name == configRecipe.name then
            isValidRecipe = true
            serverRecipe = configRecipe
            break
        end
    end
    if not isValidRecipe then return end
    
    recipe = serverRecipe

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local lastCraft = craftingCooldowns[src] or 0
    if (os.time() - lastCraft) < 1 then 
        return
    end
    craftingCooldowns[src] = os.time()
    
    local tableConfig = Config.CraftingTables[tableId]
    if not tableConfig then return end
    
    local isValidRecipe = false
    for _, configRecipe in pairs(tableConfig.recipes) do
        if recipe.name == configRecipe.name then
            isValidRecipe = true
            recipe = configRecipe 
            break
        end
    end
    if not isValidRecipe then return end
    
    amount = tonumber(amount)
    if not amount or amount < 1 or amount > 100 then return end 
    
    local hasItems = true
    for _, material in pairs(recipe.materials) do
        if not Player.Functions.HasItem(material.item, material.amount * amount) then
            hasItems = false
            break
        end
    end
    
    if hasItems then
        for _, material in pairs(recipe.materials) do
            Player.Functions.RemoveItem(material.item, material.amount * amount)
        end
        
        local totalDuration = recipe.duration * amount
        
        SetTimeout(totalDuration * 1000, function()
            Player.Functions.AddItem(recipe.result.item, recipe.result.amount * amount)
            
            if tableConfig.useProgression then
                local result = MySQL.query.await('SELECT level, xp FROM player_crafting WHERE citizenid = ? AND table_id = ?', {
                    Player.PlayerData.citizenid,
                    tableId
                })
                
                if result[1] then
                    local currentLevel = result[1].level
                    local currentXP = result[1].xp + (recipe.xpGained * amount)
                    
                    local newLevel, newXP = CheckLevelUp(src, Player.PlayerData.citizenid, currentXP, currentLevel, tableId)
                    
                    MySQL.update('UPDATE player_crafting SET level = ?, xp = ? WHERE citizenid = ? AND table_id = ?', {
                        newLevel,
                        newXP,
                        Player.PlayerData.citizenid,
                        tableId
                    })
                    
                    TriggerClientEvent('dj-test:client:UpdateXP', src, newLevel, newXP, tableId)
                end
            end
            
            TriggerClientEvent('dj-test:client:StartCrafting', src, true, 'Crafting complete!')
        end)
    else
        TriggerClientEvent('dj-test:client:StartCrafting', src, false, 'Missing required materials!')
    end
end)

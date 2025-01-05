Config = {}

Config.CraftingTables = {
    {
        -- Enabled progression example
        model = "gr_prop_gr_bench_01b",
        name = "Progression Weapon Workbench",
        coords = vector4(-81.1, -818.98, 326.18, 180.00),
        categories = {"weapons", "tools", "healing"},
        useProgression = true, 
        progression = {
            baseXP = 100,
            multiplier = 1.3 -- Multiply the baseXP by this number for each level
        },
        recipes = {
            {
                name = "Pistol",
                category = "weapons",
                levelRequired = 5, 
                duration = 5,
                xpGained = 25,  
                materials = {
                    {item = "steel", amount = 5},
                    {item = "rubber", amount = 2}
                },
                result = {
                    item = "weapon_pistol",
                    amount = 1
                }
            },
            {
                name = "Knife",
                category = "weapons",
                levelRequired = 1, 
                duration = 7,
                xpGained = 56,  
                materials = {
                    {item = "steel", amount = 250},
                    {item = "rubber", amount = 50}
                },
                result = {
                    item = "weapon_knife",
                    amount = 1
                }
            }
        }
    },
    {
        -- Disabled progression example
        model = "gr_prop_gr_bench_01b",
        name = "Basic Workbench",
        coords = vector4(-73.6, -815.77, 326.18, 180.00),
        categories = {"tools", "healing"},
        useProgression = false, 
        recipes = {
            {
                name = "Bandage",
                category = "healing",
                duration = 3,
                materials = {
                    {item = "steel", amount = 2}
                },
                result = {
                    item = "bandage",
                    amount = 1
                }
            },
            {
                name = "Lockpick",
                category = "tools",
                duration = 5,
                materials = {
                    {item = "steel", amount = 3}
                },
                result = {
                    item = "lockpick",
                    amount = 1
                }
            }
        }
    }
}
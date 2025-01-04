Config = {}

Config.CraftingTables = {
    {
        -- Enabled progression example
        model = "gr_prop_gr_bench_01b",
        name = "Weapon Workbewewench",
        coords = vector4(-75.22, -821.36, 326.17, 87.51),
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
                levelRequired = 10, 
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
                name = "Bandage",
                category = "healing",
                levelRequired = 1,
                duration = 3,
                xpGained = 10,
                materials = {
                    {item = "steel", amount = 5},
                    {item = "rubber", amount = 2}
                },
                result = {
                    item = "bandage",
                    amount = 1
                }
            },
            {
                name = "Pistol Ammo",
                category = "weapons",
                levelRequired = 7,
                duration = 3,
                xpGained = 7,
                materials = {
                    {item = "bandage", amount = 5},
                    {item = "steel", amount = 2},
                    {item = "ironoxide", amount = 2},
                    {item = "Aluminum", amount = 2}
                },
                result = {
                    item = "pistol_ammo",
                    amount = 1
                }
            },
            {
                name = "Pistol Ammo",
                category = "weapons",
                levelRequired = 11,
                duration = 3,
                xpGained = 7,
                materials = {
                    {item = "bandage", amount = 5},
                    {item = "steel", amount = 2},
                    {item = "ironoxide", amount = 2},
                    {item = "Aluminum", amount = 2}
                },
                result = {
                    item = "pistol_ammo",
                    amount = 1
                }
            }
        }
    },
    -- 
    {
        -- Enabled progression example
        -- EE
        model = "gr_prop_gr_bench_01b",
        name = "Weapon Workbewewench",
        coords = vector4(-81.1, -818.98, 326.18, 33.24),
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
                levelRequired = 10, 
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
            }
        }
    },
    -- 
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
            }
        }
    }
}
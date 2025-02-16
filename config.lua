Config = {}

Config.CraftingTables = {
    {
        -- Enabled progression example
        model = "gr_prop_gr_bench_01b",
        name = "Progression Weapon Workbench",
        coords = vector4(1466.28, 1125.77, 114.33, 180),
        categories = {"weapons", "tools", "healing"},
        useProgression = true, 
        progression = {
            baseXP = 100,
            multiplier = 1.3 -- Multiply the baseXP by this number for each level
        },
        recipes = {
            {
                name = "Pistol",
                imageName = "weed_ogkush",
                category = "weapons",
                levelRequired = 5, 
                duration = 5,
                xpGained = 25,  
                materials = {
                    {item = "steel", amount = 5, imageName = "steel"},
                    {item = "rubber", amount = 2, imageName = "rubber"}
                },
                result = {
                    item = "weapon_pistol",
                    amount = 1
                }
            },
            {
                name = "Knife",
                imageName = "weed_ogkush",
                category = "weapons",
                levelRequired = 1, 
                duration = 7,
                xpGained = 56,  
                materials = {
                    {item = "steel", amount = 250, imageName = "rubber"},
                    {item = "rubber", amount = 50, imageName = "rubber"}
                },
                result = {
                    item = "weapon_knife",
                    amount = 1
                }
            }
        }
    },
    {
        -- Enabled progression example
        model = "freeze_it-scripts_weed_table",
        name = "Progression Weed Workbench",
        coords = vector4(3823.1506, 4442.1997, 2.8064, 275.4687),
        categories = {"weed","joint", "tools"},
        useProgression = true, 
        progression = {
            baseXP = 100,
            multiplier = 1.3 -- Multiply the baseXP by this number for each level
        },
        recipes = {
            {
                name = "weed_ogkush",
                imageName = "watering_can",
                category = "weed",
                levelRequired = 0, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_og", amount = 1, imageName = "weed_og"},
                    {item = "empty_weed_bag", amount = 3, imageName = "empty_weed_bag"}
                },
                result = {
                    item = "weed_ogkush",
                    amount = 3
                }
            },
            {
                name = "weed_lemonhaze",
                imageName = "watering_can",
                category = "weed",
                levelRequired = 500, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_lemonhaze", amount = 1, imageName = "weed_lemonhaze"},
                    {item = "empty_weed_bag", amount = 3, imageName = "empty_weed_bag"}
                },
                result = {
                    item = "weed_amnesia",
                    amount = 3
                }
            },
            {
                name = "weed_purple_haze",
                imageName = "watering_can",
                category = "weed",
                levelRequired = 1000, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_purple_haze", amount = 1, imageName = "weed_purple_haze"},
                    {item = "empty_weed_bag", amount = 3, imageName = "empty_weed_bag"}
                },
                result = {
                    item = "weed_purplehaze",
                    amount = 3
                }
            },
            {
                name = "weed_white_widow",
                imageName = "watering_can",
                category = "weed",
                levelRequired = 2000, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_white_widow", amount = 1, imageName = "weed_white_widow"},
                    {item = "empty_weed_bag", amount = 3, imageName = "empty_weed_bag"}
                },
                result = {
                    item = "weed_whitewidow",
                    amount = 3
                }
            },
            {
                name = "joint_ogkush",
                imageName = "watering_can",
                category = "joint",
                levelRequired = 0, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_ogkush", amount = 1, imageName = "weed_ogkush"},
                    {item = "rolling_paper", amount = 2, imageName = "rolling_paper"}
                },
                result = {
                    item = "joint",
                    amount = 2
                }
            },
            {
                name = "joint_lemonhaze",
                imageName = "watering_can",
                category = "joint",
                levelRequired = 0, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_amnesia", amount = 1, imageName = "weed_amnesia"},
                    {item = "rolling_paper", amount = 4, imageName = "rolling_paper"}
                },
                result = {
                    item = "joint",
                    amount = 4
                }
            },
            {
                name = "joint_purple_haze",
                imageName = "watering_can",
                category = "joint",
                levelRequired = 0, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_purplehaze", amount = 1, imageName = "weed_purplehaze"},
                    {item = "rolling_paper", amount = 6, imageName = "rolling_paper"}
                },
                result = {
                    item = "joint",
                    amount = 6
                }
            },
            {
                name = "joint_white_widow",
                imageName = "watering_can",
                category = "joint",
                levelRequired = 0, 
                duration = 5,
                xpGained = 5,  
                materials = {
                    {item = "weed_whitewidow", amount = 1, imageName = "weed_whitewidow"},
                    {item = "rolling_paper", amount = 1, imageName = "rolling_paper"}
                },
                result = {
                    item = "joint",
                    amount = 10
                }
            },
            {
                name = "empty_weed_bag",
                imageName = "watering_can",
                category = "tools",
                levelRequired = 0, 
                duration = 1,
                xpGained = 0,  
                materials = {
                    {item = "plastic", amount = 1, imageName = "plastic"}
                },
                result = {
                    item = "empty_weed_bag",
                    amount = 10
                }
            },
            {
                name = "rolling_paper",
                imageName = "watering_can",
                category = "tools",
                levelRequired = 0, 
                duration = 1,
                xpGained = 0,  
                materials = {
                    {item = "paper", amount = 1, imageName = "paper"}
                },
                result = {
                    item = "rolling_paper",
                    amount = 10
                }
            },
            {
                name = "paper",
                imageName = "watering_can",
                category = "tools",
                levelRequired = 0, 
                duration = 1,
                xpGained = 0,  
                materials = {
                    {item = "logs", amount = 1, imageName = "logs"}
                },
                result = {
                    item = "paper",
                    amount = 2
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
                imageName = "weed_ogkush",
                category = "healing",
                duration = 3,
                materials = {
                    {item = "steel", amount = 2, imageName = "steel"}
                },
                result = {
                    item = "bandage",
                    amount = 1
                }
            },
            {
                name = "Lockpick",
                imageName = "weed_ogkush",
                category = "tools",
                duration = 5,
                materials = {
                    {item = "steel", amount = 3, imageName = "steel"}
                },
                result = {
                    item = "lockpick",
                    amount = 1
                }
            }
        }
    }
}

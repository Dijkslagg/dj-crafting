# DJ Crafting Script

A comprehensive crafting system for FiveM QBCore servers with a progression system, user-friendly UI, and server-side validation.

## TODO

- Support more frameworks
- Player placeable crafting tables (with and without progression)
- Lock crafting table to job/gang
- Add crafting messages in [config.lua](config.lua)
- Custom/unlockable blueprints
- Custom logo intergration in UI

### Planned fixes:
- Add the amount you are crafting to UI
- fix images not showing up when image filename isnt the same as the item name :/

## UI

Check the showcase video [here](https://youtu.be/x01Dd6-VZME)

## Features

- 🛠️ Crafting system with categorized recipes
- 📈 Progressive leveling system with XP and levels
- 🖥️ Clean and modern crafting menu UI
- 🔒 Server-side validation for secure crafting
- 📊 XP bar and level display in the crafting menu
- 🔄 Configurable crafting tables and recipes

## Dependencies

- QBCore Framework
- ox_lib
- oxmysql

## Installation

1. Import the provided SQL file from [sql/crafting.sql](sql/crafting.sql)
2. Add the resource to your server's resource folder
3. Add `ensure dj-crafting` to your `server.cfg`
4. Configure the script in [config.lua](config.lua)
5. Restart your server

## Configuration
```lua
Config = {}

Config.CraftingTables = {
    {
        -- Enabled progression example
        model = "gr_prop_gr_bench_01b",
        name = "Weapon Workbench",
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
            }
        }
    }
}
```

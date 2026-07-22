-- config.lua
Config = {}

-- Menu UI Position: 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'
Config.MenuPosition = 'top-left'

-- Command configuration
Config.EnableCommand = true
Config.Command = 'tuner'          -- /tuner (also aliases /tune, /customs)
Config.AllowAnywhere = true       -- Set to true to allow /tuner anywhere, or false for shop locations only

-- Camera Settings
Config.EnableDynamicCamera = true  -- Smoothly orbits/focuses on the part being tuned (engine, wheels, spoiler, etc.)

-- Pricing & Payment Settings
Config.FreeTuning = true          -- Set to true for free tuning, or false to charge money
Config.DefaultModPrice = 500      -- Price per modification if FreeTuning = false

-- Preset Saving Integration
Config.SaveToDatabase = true       -- Automatically save presets to database if available
Config.SaveToVehicleState = true   -- Update FiveM vehicle statebags & spz-vehicles if active

-- Tuner Shop Locations (Garages)
Config.Shops = {
    {
        name = "Los Santos Customs (Bennys)",
        coords = vector3(-211.5, -1324.0, 30.9),
        heading = 140.0,
        radius = 5.0
    },
    {
        name = "Harmony Customs",
        coords = vector3(1175.0, 2640.0, 37.7),
        heading = 0.0,
        radius = 5.0
    },
    {
        name = "Paleto Bay Customs",
        coords = vector3(110.0, 6626.0, 31.8),
        heading = 45.0,
        radius = 5.0
    }
}

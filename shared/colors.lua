-- shared/colors.lua
SPZ_Tuners = SPZ_Tuners or {}

-- Predefined GTA V Vehicle Primary/Secondary Color Palette
SPZ_Tuners.Colors = {
    { label = "Metallic Black", index = 0 },
    { label = "Metallic Graphite", index = 1 },
    { label = "Metallic Black Steel", index = 2 },
    { label = "Metallic Dark Silver", index = 3 },
    { label = "Metallic Silver", index = 4 },
    { label = "Metallic Blue Silver", index = 5 },
    { label = "Metallic Steel Gray", index = 6 },
    { label = "Metallic Shadow Silver", index = 7 },
    { label = "Metallic Stone Silver", index = 8 },
    { label = "Metallic Midnight Silver", index = 9 },
    { label = "Metallic Gun Metal", index = 10 },
    { label = "Metallic Red", index = 27 },
    { label = "Metallic Torino Red", index = 28 },
    { label = "Metallic Formula Red", index = 29 },
    { label = "Metallic Blaze Red", index = 30 },
    { label = "Metallic Grace Red", index = 31 },
    { label = "Metallic Garnet Red", index = 32 },
    { label = "Metallic Sunset Red", index = 33 },
    { label = "Metallic Cabernet Red", index = 34 },
    { label = "Metallic Candy Red", index = 35 },
    { label = "Metallic Dark Blue", index = 61 },
    { label = "Metallic Saxon Blue", index = 62 },
    { label = "Metallic Blue", index = 63 },
    { label = "Metallic Mariner Blue", index = 64 },
    { label = "Metallic Harbor Blue", index = 65 },
    { label = "Metallic Diamond Blue", index = 67 },
    { label = "Metallic Surf Blue", index = 68 },
    { label = "Metallic Nautical Blue", index = 69 },
    { label = "Metallic Racing Blue", index = 73 },
    { label = "Metallic Lime Green", index = 55 },
    { label = "Metallic Green", index = 50 },
    { label = "Metallic Olive Green", index = 51 },
    { label = "Metallic Yellow", index = 88 },
    { label = "Metallic Race Yellow", index = 89 },
    { label = "Metallic Gold", index = 99 },
    { label = "Metallic Orange", index = 41 },
    { label = "Metallic Bright Orange", index = 138 },
    { label = "Matte Black", index = 12 },
    { label = "Matte Gray", index = 13 },
    { label = "Matte Light Gray", index = 14 },
    { label = "Matte White", index = 131 },
    { label = "Matte Red", index = 39 },
    { label = "Matte Dark Red", index = 40 },
    { label = "Matte Orange", index = 42 },
    { label = "Matte Yellow", index = 89 },
    { label = "Matte Lime Green", index = 55 },
    { label = "Matte Midnight Blue", index = 82 },
    { label = "Matte Blue", index = 83 },
    { label = "Matte Purple", index = 148 },
    { label = "Chrome", index = 120 },
    { label = "Brushed Steel", index = 117 },
    { label = "Brushed Black Steel", index = 118 },
    { label = "Brushed Aluminum", index = 119 },
    { label = "Pure Gold", index = 158 },
    { label = "Brushed Gold", index = 159 },

}

-- Xenon Headlight Colors (GTA V Xenon Light Index: 0 to 12)
SPZ_Tuners.XenonColors = {
    { label = "Default White", index = -1 },
    { label = "White", index = 0 },
    { label = "Blue", index = 1 },
    { label = "Electric Blue", index = 2 },
    { label = "Mint Green", index = 3 },
    { label = "Lime Green", index = 4 },
    { label = "Yellow", index = 5 },
    { label = "Golden Shower", index = 6 },
    { label = "Orange", index = 7 },
    { label = "Red", index = 8 },
    { label = "Pony Pink", index = 9 },
    { label = "Hot Pink", index = 10 },
    { label = "Purple", index = 11 },
    { label = "Blacklight", index = 12 },
}

-- Predefined Neon Colors RGB
SPZ_Tuners.NeonColors = {
    { label = "White", rgb = { 255, 255, 255 } },
    { label = "Blue", rgb = { 2, 21, 255 } },
    { label = "Electric Blue", rgb = { 3, 83, 255 } },
    { label = "Mint Green", rgb = { 0, 255, 140 } },
    { label = "Lime Green", rgb = { 15, 255, 0 } },
    { label = "Yellow", rgb = { 255, 255, 0 } },
    { label = "Golden Orange", rgb = { 255, 150, 0 } },
    { label = "Orange", rgb = { 255, 62, 0 } },
    { label = "Red", rgb = { 255, 1, 1 } },
    { label = "Pony Pink", rgb = { 255, 50, 100 } },
    { label = "Hot Pink", rgb = { 255, 5, 190 } },
    { label = "Purple", rgb = { 35, 1, 255 } },
    { label = "Blacklight", rgb = { 15, 3, 255 } },
}

-- Window Tints
SPZ_Tuners.WindowTints = {
    { label = "Stock / None", index = 0 },
    { label = "Pure Black", index = 1 },
    { label = "Dark Smoke", index = 2 },
    { label = "Light Smoke", index = 3 },
    { label = "Limo", index = 4 },
    { label = "Green Tint", index = 5 },
}

-- License Plate Styles
SPZ_Tuners.PlateStyles = {
    { label = "Blue on White 1", index = 0 },
    { label = "Yellow on Black", index = 1 },
    { label = "Yellow on Blue", index = 2 },
    { label = "Blue on White 2", index = 3 },
    { label = "Blue on White 3", index = 4 },
    { label = "Yankton Special", index = 5 },
}

-- Wheel Category Types
SPZ_Tuners.WheelTypes = {
    { label = "Sport", type = 0 },
    { label = "Muscle", type = 1 },
    { label = "Lowrider", type = 2 },
    { label = "SUV", type = 3 },
    { label = "Offroad", type = 4 },
    { label = "Tuner", type = 5 },
    { label = "Bike Wheels", type = 6 },
    { label = "High End", type = 7 },
    { label = "Benny's Original", type = 8 },
    { label = "Benny's Bespoke", type = 9 },
}

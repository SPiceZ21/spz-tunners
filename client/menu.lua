-- client/menu.lua
SPZ_Tuners = SPZ_Tuners or {}

local CurrentVehicle = 0
local SavedVehicleState = nil
local CurrentPreviewState = {}

-- Mod Type Names & Descriptions
local MOD_SLOT_NAMES = {
    [0]  = { label = "Spoiler", focus = "spoiler" },
    [1]  = { label = "Front Bumper", focus = "front" },
    [2]  = { label = "Rear Bumper", focus = "rear" },
    [3]  = { label = "Side Skirt", focus = "left" },
    [4]  = { label = "Exhaust", focus = "rear" },
    [5]  = { label = "Roll Cage / Frame", focus = "inside" },
    [6]  = { label = "Grille", focus = "front" },
    [7]  = { label = "Bonnet / Hood", focus = "engine" },
    [8]  = { label = "Fender / Left Wing", focus = "left" },
    [9]  = { label = "Right Fender", focus = "right" },
    [10] = { label = "Roof", focus = "roof" },
    [11] = { label = "Engine Upgrade", focus = "engine" },
    [12] = { label = "Brakes", focus = "wheels" },
    [13] = { label = "Transmission", focus = "engine" },
    [14] = { label = "Horn", focus = "front" },
    [15] = { label = "Suspension", focus = "wheels" },
    [16] = { label = "Armor", focus = "full" },
    [18] = { label = "Turbo Tuning", focus = "engine" },
    [22] = { label = "Xenon Lights", focus = "front" },
    [25] = { label = "Plate Holder", focus = "rear" },
    [26] = { label = "Vanity Plate", focus = "front" },
    [27] = { label = "Trim Design", focus = "inside" },
    [28] = { label = "Ornaments", focus = "inside" },
    [29] = { label = "Dashboard Design", focus = "inside" },
    [30] = { label = "Dials", focus = "inside" },
    [31] = { label = "Door Speakers", focus = "inside" },
    [32] = { label = "Seats", focus = "inside" },
    [33] = { label = "Steering Wheel", focus = "inside" },
    [34] = { label = "Gear Lever", focus = "inside" },
    [35] = { label = "Plaques", focus = "inside" },
    [36] = { label = "Speakers", focus = "inside" },
    [37] = { label = "Trunk", focus = "rear" },
    [38] = { label = "Hydraulics", focus = "wheels" },
    [39] = { label = "Engine Block", focus = "engine" },
    [40] = { label = "Air Filter", focus = "engine" },
    [41] = { label = "Struts", focus = "engine" },
    [42] = { label = "Arch Cover", focus = "wheels" },
    [43] = { label = "Aerials", focus = "roof" },
    [44] = { label = "Trim Option 2", focus = "inside" },
    [45] = { label = "Fuel Tank", focus = "rear" },
    [48] = { label = "Livery / Decals", focus = "full" },
}

-- Capture Vehicle Snapshot for Rollback
function SPZ_Tuners.SnapshotVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return nil end

    SetVehicleModKit(vehicle, 0)
    local p1, p2       = GetVehicleColours(vehicle)
    local pearl, wheel = GetVehicleExtraColours(vehicle)
    local r1, g1, b1   = GetVehicleCustomPrimaryColour(vehicle)
    local r2, g2, b2   = GetVehicleCustomSecondaryColour(vehicle)
    local nr, ng, nb   = GetVehicleNeonLightsColour(vehicle)

    local mods = {}
    for slot = 0, 49 do
        mods[slot] = GetVehicleMod(vehicle, slot)
    end

    local extras = {}
    for i = 1, 14 do
        if DoesExtraExist(vehicle, i) then
            extras[i] = IsVehicleExtraTurnedOn(vehicle, i)
        end
    end

    return {
        primary = p1,
        secondary = p2,
        pearlescent = pearl,
        wheelColor = wheel,
        customPrimary = GetIsVehiclePrimaryColourCustom(vehicle) and { r1, g1, b1 } or nil,
        customSecondary = GetIsVehicleSecondaryColourCustom(vehicle) and { r2, g2, b2 } or nil,
        livery = GetVehicleLivery(vehicle),
        wheelType = GetVehicleWheelType(vehicle),
        plateText = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        xenonColor = GetVehicleXenonLightsColor(vehicle),
        turbo = IsToggleModOn(vehicle, 18),
        xenonEnabled = IsToggleModOn(vehicle, 22),
        neonEnabled = {
            left  = IsVehicleNeonLightEnabled(vehicle, 0),
            right = IsVehicleNeonLightEnabled(vehicle, 1),
            front = IsVehicleNeonLightEnabled(vehicle, 2),
            back  = IsVehicleNeonLightEnabled(vehicle, 3),
        },
        neonColor = { nr, ng, nb },
        mods = mods,
        extras = extras
    }
end

-- Restore Vehicle State
function SPZ_Tuners.RestoreVehicle(vehicle, state)
    if not DoesEntityExist(vehicle) or not state then return end

    SetVehicleModKit(vehicle, 0)
    SetVehicleColours(vehicle, state.primary, state.secondary)
    SetVehicleExtraColours(vehicle, state.pearlescent, state.wheelColor)

    if state.customPrimary then
        SetVehicleCustomPrimaryColour(vehicle, state.customPrimary[1], state.customPrimary[2], state.customPrimary[3])
    end
    if state.customSecondary then
        SetVehicleCustomSecondaryColour(vehicle, state.customSecondary[1], state.customSecondary[2], state.customSecondary[3])
    end

    if state.livery and state.livery >= 0 then
        SetVehicleLivery(vehicle, state.livery)
    end

    SetVehicleWheelType(vehicle, state.wheelType)
    SetVehicleNumberPlateText(vehicle, state.plateText)
    SetVehicleNumberPlateTextIndex(vehicle, state.plateIndex)
    SetVehicleWindowTint(vehicle, state.windowTint)

    ToggleVehicleMod(vehicle, 18, state.turbo)
    ToggleVehicleMod(vehicle, 22, state.xenonEnabled)
    if state.xenonColor and state.xenonColor >= 0 then
        SetVehicleXenonLightsColor(vehicle, state.xenonColor)
    end

    for i = 0, 3 do
        SetVehicleNeonLightEnabled(vehicle, i, state.neonEnabled[i == 0 and "left" or i == 1 and "right" or i == 2 and "front" or "back"])
    end
    SetVehicleNeonLightsColour(vehicle, state.neonColor[1], state.neonColor[2], state.neonColor[3])

    for slot, modIdx in pairs(state.mods) do
        SetVehicleMod(vehicle, tonumber(slot), modIdx, false)
    end

    for extraId, enabled in pairs(state.extras) do
        SetVehicleExtra(vehicle, extraId, enabled and 0 or 1)
    end
end

-- Get Mod Label Name
local function GetModLabel(vehicle, modType, modIndex)
    if modIndex == -1 then return "Stock / None" end
    local name = GetModTextLabel(vehicle, modType, modIndex)
    if name and name ~= "" then
        local text = GetLabelText(name)
        if text and text ~= "NULL" then return text end
    end
    return string.format("Custom Option #%d", modIndex + 1)
end

-- ── Open Main Tuner Keyboard Menu ──────────────────────────────────────────────
function SPZ_Tuners.OpenTunerMenu(vehicle)
    if not DoesEntityExist(vehicle) then return end

    CurrentVehicle = vehicle
    SetVehicleModKit(vehicle, 0)
    SavedVehicleState = SPZ_Tuners.SnapshotVehicle(vehicle)

    EnableTunerCam(vehicle, "full")

    -- Show keyboard helper text UI
    lib.showTextUI("[↑/↓] Navigate  |  [←/→] Preview Option  |  [ENTER] Apply  |  [BACKSPACE] Back", {
        position = "top-center",
        icon = "wrench",
        style = {
            borderRadius = 4,
            backgroundColor = "#1E293B",
            color = "#F8FAFC"
        }
    })

    lib.registerMenu({
        id = 'spz_tuner_main',
        title = '🔧 Performance & Customs',
        position = Config.MenuPosition or 'top-left',
        onClose = function()
            lib.hideTextUI()
            DisableTunerCam()
            -- Confirm save on exit if modifications were applied
            if Config.SaveToVehicleState then
                TriggerServerEvent("SPZ:tuner:saveVehicle", VehToNet(CurrentVehicle), SPZ_Tuners.SnapshotVehicle(CurrentVehicle))
            end
        end,
        options = {
            { label = '⚡ Performance Upgrades', description = 'Engine, Brakes, Transmission, Turbo, Suspension' },
            { label = '🏎️ Body Kits & Cosmetics', description = 'Spoilers, Bumpers, Hoods, Skirts, Exhausts' },
            { label = '💺 Interior & Cabin', description = 'Dashboard, Seats, Steering Wheels, Roll Cage' },
            { label = '🎨 Paints & Colors', description = 'Primary, Secondary, Pearlescent, Custom Colors' },
            { label = '🛞 Wheels & Tires', description = 'Rims Categories, Tires, Smoke' },
            { label = '💡 Lighting & Neons', description = 'Xenon Lights & Color, Underglow Neons' },
            { label = '🚘 Window Tint & Plates', description = 'Window Tint & Custom License Plate' },
            { label = '✨ Extras & Liveries', description = 'Vehicle Decals & Toggleable Extras' }
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then SPZ_Tuners.OpenPerformanceMenu() end
        if selected == 2 then SPZ_Tuners.OpenBodyKitMenu() end
        if selected == 3 then SPZ_Tuners.OpenInteriorMenu() end
        if selected == 4 then SPZ_Tuners.OpenPaintsMenu() end
        if selected == 5 then SPZ_Tuners.OpenWheelsMenu() end
        if selected == 6 then SPZ_Tuners.OpenLightingMenu() end
        if selected == 7 then SPZ_Tuners.OpenPlateWindowMenu() end
        if selected == 8 then SPZ_Tuners.OpenExtrasMenu() end
    end)

    lib.showMenu('spz_tuner_main')
end

-- ── 1. Performance Submenu ────────────────────────────────────────────────────
function SPZ_Tuners.OpenPerformanceMenu()
    EnableTunerCam(CurrentVehicle, "engine")
    local veh = CurrentVehicle

    local perfSlots = { 11, 12, 13, 15, 16 }
    local options = {}

    for _, slot in ipairs(perfSlots) do
        local count = GetNumVehicleMods(veh, slot)
        if count > 0 then
            local current = GetVehicleMod(veh, slot)
            local values = { "Stock" }
            for i = 0, count - 1 do
                table.insert(values, string.format("Level %d", i + 1))
            end
            table.insert(options, {
                label = MOD_SLOT_NAMES[slot].label,
                values = values,
                defaultIndex = current + 2,
                args = { slot = slot }
            })
        end
    end

    -- Turbo Toggle
    local turboState = IsToggleModOn(veh, 18)
    table.insert(options, {
        label = "Turbocharger",
        values = { "Disabled", "Installed (Turbo)" },
        defaultIndex = turboState and 2 or 1,
        args = { slot = 18, isToggle = true }
    })

    lib.registerMenu({
        id = 'spz_tuner_perf',
        title = '⚡ Performance Upgrades',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSideScroll = function(selected, scrollIndex, args)
            if args.isToggle then
                ToggleVehicleMod(veh, 18, scrollIndex == 2)
            else
                SetVehicleMod(veh, args.slot, scrollIndex - 2, false)
            end
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if args.isToggle then
            ToggleVehicleMod(veh, 18, scrollIndex == 2)
        else
            SetVehicleMod(veh, args.slot, scrollIndex - 2, false)
        end
        lib.notify({ title = 'Tuning Applied', description = 'Performance upgrade fitted.', type = 'success' })
    end)

    lib.showMenu('spz_tuner_perf')
end

-- ── 2. Body Kits & Cosmetics Submenu ──────────────────────────────────────────
function SPZ_Tuners.OpenBodyKitMenu()
    EnableTunerCam(CurrentVehicle, "full")
    local veh = CurrentVehicle

    local bodySlots = { 0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 25, 26, 37, 39, 40, 41, 42, 43, 45 }
    local options = {}

    for _, slot in ipairs(bodySlots) do
        local count = GetNumVehicleMods(veh, slot)
        if count > 0 then
            local current = GetVehicleMod(veh, slot)
            local values = {}
            for i = -1, count - 1 do
                table.insert(values, GetModLabel(veh, slot, i))
            end
            table.insert(options, {
                label = MOD_SLOT_NAMES[slot].label,
                values = values,
                defaultIndex = current + 2,
                args = { slot = slot, focus = MOD_SLOT_NAMES[slot].focus }
            })
        end
    end

    if #options == 0 then
        lib.notify({ title = 'Body Kits', description = 'No cosmetic body parts available for this vehicle.', type = 'error' })
        return
    end

    lib.registerMenu({
        id = 'spz_tuner_body',
        title = '🏎️ Body Kits & Cosmetics',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSelected = function(selected, secondary, args)
            if args and args.focus then EnableTunerCam(veh, args.focus) end
        end,
        onSideScroll = function(selected, scrollIndex, args)
            SetVehicleMod(veh, args.slot, scrollIndex - 2, false)
        end,
        options = options
    }, function(selected, scrollIndex, args)
        SetVehicleMod(veh, args.slot, scrollIndex - 2, false)
        lib.notify({ title = 'Tuning Applied', description = (MOD_SLOT_NAMES[args.slot].label .. ' updated.'), type = 'success' })
    end)

    lib.showMenu('spz_tuner_body')
end

-- ── 3. Interior Submenu ───────────────────────────────────────────────────────
function SPZ_Tuners.OpenInteriorMenu()
    EnableTunerCam(CurrentVehicle, "inside")
    local veh = CurrentVehicle

    local interiorSlots = { 5, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 44 }
    local options = {}

    for _, slot in ipairs(interiorSlots) do
        local count = GetNumVehicleMods(veh, slot)
        if count > 0 then
            local current = GetVehicleMod(veh, slot)
            local values = {}
            for i = -1, count - 1 do
                table.insert(values, GetModLabel(veh, slot, i))
            end
            table.insert(options, {
                label = MOD_SLOT_NAMES[slot].label,
                values = values,
                defaultIndex = current + 2,
                args = { slot = slot }
            })
        end
    end

    if #options == 0 then
        lib.notify({ title = 'Interior', description = 'No custom interior options available for this vehicle.', type = 'error' })
        return
    end

    lib.registerMenu({
        id = 'spz_tuner_interior',
        title = '💺 Interior & Cabin',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSideScroll = function(selected, scrollIndex, args)
            SetVehicleMod(veh, args.slot, scrollIndex - 2, false)
        end,
        options = options
    }, function(selected, scrollIndex, args)
        SetVehicleMod(veh, args.slot, scrollIndex - 2, false)
        lib.notify({ title = 'Interior Fitted', description = 'Interior option updated.', type = 'success' })
    end)

    lib.showMenu('spz_tuner_interior')
end

-- ── 4. Paints Submenu ─────────────────────────────────────────────────────────
function SPZ_Tuners.OpenPaintsMenu()
    EnableTunerCam(CurrentVehicle, "full")
    local veh = CurrentVehicle

    local colorNames = {}
    for _, item in ipairs(SPZ_Tuners.Colors) do
        table.insert(colorNames, item.label)
    end

    local curP1, curP2 = GetVehicleColours(veh)
    local curPearl, curWheel = GetVehicleExtraColours(veh)

    lib.registerMenu({
        id = 'spz_tuner_paints',
        title = '🎨 Paints & Colors',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSideScroll = function(selected, scrollIndex, args)
            local targetColor = SPZ_Tuners.Colors[scrollIndex].index
            local p1, p2 = GetVehicleColours(veh)
            local pearl, wheel = GetVehicleExtraColours(veh)

            if args.type == 'primary' then
                SetVehicleColours(veh, targetColor, p2)
            elseif args.type == 'secondary' then
                SetVehicleColours(veh, p1, targetColor)
            elseif args.type == 'pearl' then
                SetVehicleExtraColours(veh, targetColor, wheel)
            elseif args.type == 'wheelColor' then
                SetVehicleExtraColours(veh, pearl, targetColor)
            end
        end,
        options = {
            { label = 'Primary Color', values = colorNames, defaultIndex = 1, args = { type = 'primary' } },
            { label = 'Secondary Color', values = colorNames, defaultIndex = 1, args = { type = 'secondary' } },
            { label = 'Pearlescent Finish', values = colorNames, defaultIndex = 1, args = { type = 'pearl' } },
            { label = 'Wheel Rim Color', values = colorNames, defaultIndex = 1, args = { type = 'wheelColor' } },
        }
    }, function(selected, scrollIndex, args)
        lib.notify({ title = 'Paint Applied', description = 'Vehicle paint finish updated.', type = 'success' })
    end)

    lib.showMenu('spz_tuner_paints')
end

-- ── 5. Wheels & Tires Submenu ─────────────────────────────────────────────────
function SPZ_Tuners.OpenWheelsMenu()
    EnableTunerCam(CurrentVehicle, "wheels")
    local veh = CurrentVehicle

    local wheelTypeNames = {}
    for _, w in ipairs(SPZ_Tuners.WheelTypes) do
        table.insert(wheelTypeNames, w.label)
    end

    local curWheelType = GetVehicleWheelType(veh)

    lib.registerMenu({
        id = 'spz_tuner_wheels_cat',
        title = '🛞 Wheels & Tires',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSideScroll = function(selected, scrollIndex, args)
            if args.type == 'category' then
                local wType = SPZ_Tuners.WheelTypes[scrollIndex].type
                SetVehicleWheelType(veh, wType)
                SetVehicleMod(veh, 23, 0, false)
            end
        end,
        options = {
            { label = 'Wheel Category', values = wheelTypeNames, defaultIndex = (curWheelType + 1), args = { type = 'category' } },
            { label = 'Select Wheel Model', description = 'Browse wheels in selected category' },
            { label = 'Custom Tires', values = { "Standard Tires", "Custom Tires (Atomic/Design)" }, defaultIndex = IsVehicleModCustom(veh, 23) and 2 or 1, args = { type = 'customTires' } }
        }
    }, function(selected, scrollIndex, args)
        if selected == 2 then
            SPZ_Tuners.OpenWheelModelsMenu()
        elseif selected == 3 then
            local isCustom = (scrollIndex == 2)
            local curMod = GetVehicleMod(veh, 23)
            SetVehicleMod(veh, 23, curMod, isCustom)
            lib.notify({ title = 'Tires Updated', description = isCustom and 'Custom tires applied.' or 'Standard tires equipped.', type = 'success' })
        end
    end)

    lib.showMenu('spz_tuner_wheels_cat')
end

function SPZ_Tuners.OpenWheelModelsMenu()
    local veh = CurrentVehicle
    local count = GetNumVehicleMods(veh, 23)
    if count == 0 then
        lib.notify({ title = 'Wheels', description = 'No wheel models available for this category.', type = 'error' })
        return
    end

    local current = GetVehicleMod(veh, 23)
    local values = {}
    for i = -1, count - 1 do
        table.insert(values, GetModLabel(veh, 23, i))
    end

    lib.registerMenu({
        id = 'spz_tuner_wheel_models',
        title = '🛞 Select Rim Model',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_wheels_cat') end,
        onSideScroll = function(selected, scrollIndex, args)
            local isCustom = IsVehicleModCustom(veh, 23)
            SetVehicleMod(veh, 23, scrollIndex - 2, isCustom)
        end,
        options = {
            { label = 'Rim Style', values = values, defaultIndex = current + 2 }
        }
    }, function(selected, scrollIndex, args)
        local isCustom = IsVehicleModCustom(veh, 23)
        SetVehicleMod(veh, 23, scrollIndex - 2, isCustom)
        lib.notify({ title = 'Wheels Applied', description = 'Wheel rim model updated.', type = 'success' })
    end)

    lib.showMenu('spz_tuner_wheel_models')
end

-- ── 6. Lighting & Neons Submenu ───────────────────────────────────────────────
function SPZ_Tuners.OpenLightingMenu()
    EnableTunerCam(CurrentVehicle, "front")
    local veh = CurrentVehicle

    local xenonColorNames = {}
    for _, x in ipairs(SPZ_Tuners.XenonColors) do
        table.insert(xenonColorNames, x.label)
    end

    local neonColorNames = {}
    for _, n in ipairs(SPZ_Tuners.NeonColors) do
        table.insert(neonColorNames, n.label)
    end

    local xenonOn = IsToggleModOn(veh, 22)

    lib.registerMenu({
        id = 'spz_tuner_lighting',
        title = '💡 Lighting & Neons',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSideScroll = function(selected, scrollIndex, args)
            if args.type == 'xenon' then
                ToggleVehicleMod(veh, 22, scrollIndex == 2)
            elseif args.type == 'xenonColor' then
                local xColor = SPZ_Tuners.XenonColors[scrollIndex].index
                SetVehicleXenonLightsColor(veh, xColor)
            elseif args.type == 'neonLayout' then
                local on = (scrollIndex > 1)
                for i = 0, 3 do SetVehicleNeonLightEnabled(veh, i, on) end
            elseif args.type == 'neonColor' then
                local rgb = SPZ_Tuners.NeonColors[scrollIndex].rgb
                SetVehicleNeonLightsColour(veh, rgb[1], rgb[2], rgb[3])
            end
        end,
        options = {
            { label = 'Xenon Headlights', values = { "Stock White", "Xenon Lights" }, defaultIndex = xenonOn and 2 or 1, args = { type = 'xenon' } },
            { label = 'Xenon Headlight Color', values = xenonColorNames, defaultIndex = 1, args = { type = 'xenonColor' } },
            { label = 'Underglow Neon Kit', values = { "Off", "All Sides Enabled" }, defaultIndex = 1, args = { type = 'neonLayout' } },
            { label = 'Neon Underglow Color', values = neonColorNames, defaultIndex = 1, args = { type = 'neonColor' } },
        }
    }, function(selected, scrollIndex, args)
        lib.notify({ title = 'Lighting Updated', description = 'Vehicle lighting setup applied.', type = 'success' })
    end)

    lib.showMenu('spz_tuner_lighting')
end

-- ── 7. Window Tint & Plates Submenu ───────────────────────────────────────────
function SPZ_Tuners.OpenPlateWindowMenu()
    EnableTunerCam(CurrentVehicle, "rear")
    local veh = CurrentVehicle

    local tintNames = {}
    for _, t in ipairs(SPZ_Tuners.WindowTints) do
        table.insert(tintNames, t.label)
    end

    local plateStyleNames = {}
    for _, p in ipairs(SPZ_Tuners.PlateStyles) do
        table.insert(plateStyleNames, p.label)
    end

    local curTint = GetVehicleWindowTint(veh)
    local curPlateStyle = GetVehicleNumberPlateTextIndex(veh)

    lib.registerMenu({
        id = 'spz_tuner_plate_window',
        title = '🚘 Window Tint & Plates',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSideScroll = function(selected, scrollIndex, args)
            if args.type == 'tint' then
                SetVehicleWindowTint(veh, SPZ_Tuners.WindowTints[scrollIndex].index)
            elseif args.type == 'plateStyle' then
                SetVehicleNumberPlateTextIndex(veh, SPZ_Tuners.PlateStyles[scrollIndex].index)
            end
        end,
        options = {
            { label = 'Window Tint Level', values = tintNames, defaultIndex = (curTint + 1), args = { type = 'tint' } },
            { label = 'License Plate Style', values = plateStyleNames, defaultIndex = (curPlateStyle + 1), args = { type = 'plateStyle' } },
            { label = 'Custom License Plate Text', description = 'Change text displayed on license plate' }
        }
    }, function(selected, scrollIndex, args)
        if selected == 3 then
            local input = lib.inputDialog('License Plate Customization', {
                { type = 'input', label = 'Custom Plate Text', placeholder = 'SPICEZ', max = 8 }
            })
            if input and input[1] then
                SetVehicleNumberPlateText(veh, string.upper(input[1]))
                lib.notify({ title = 'Plate Text Set', description = ('License plate set to ' .. string.upper(input[1])), type = 'success' })
            end
        else
            lib.notify({ title = 'Options Applied', description = 'Window tint & plate style updated.', type = 'success' })
        end
    end)

    lib.showMenu('spz_tuner_plate_window')
end

-- ── 8. Extras & Liveries Submenu ──────────────────────────────────────────────
function SPZ_Tuners.OpenExtrasMenu()
    EnableTunerCam(CurrentVehicle, "full")
    local veh = CurrentVehicle

    local options = {}

    -- Livery
    local countLivery = GetNumVehicleMods(veh, 48)
    if countLivery > 0 then
        local currentL = GetVehicleMod(veh, 48)
        local valuesL = {}
        for i = -1, countLivery - 1 do
            table.insert(valuesL, GetModLabel(veh, 48, i))
        end
        table.insert(options, {
            label = "Vehicle Decals / Livery",
            values = valuesL,
            defaultIndex = currentL + 2,
            args = { isLivery = true }
        })
    end

    -- Extras 1-14
    for i = 1, 14 do
        if DoesExtraExist(veh, i) then
            local isOn = IsVehicleExtraTurnedOn(veh, i)
            table.insert(options, {
                label = string.format("Vehicle Extra #%d", i),
                values = { "Disabled", "Enabled" },
                defaultIndex = isOn and 2 or 1,
                args = { extraId = i }
            })
        end
    end

    if #options == 0 then
        lib.notify({ title = 'Extras & Liveries', description = 'No extras or liveries available for this model.', type = 'error' })
        return
    end

    lib.registerMenu({
        id = 'spz_tuner_extras',
        title = '✨ Extras & Liveries',
        position = Config.MenuPosition or 'top-left',
        onClose = function() lib.showMenu('spz_tuner_main') end,
        onSideScroll = function(selected, scrollIndex, args)
            if args.isLivery then
                SetVehicleMod(veh, 48, scrollIndex - 2, false)
            elseif args.extraId then
                SetVehicleExtra(veh, args.extraId, (scrollIndex == 2) and 0 or 1)
            end
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if args.isLivery then
            SetVehicleMod(veh, 48, scrollIndex - 2, false)
        elseif args.extraId then
            SetVehicleExtra(veh, args.extraId, (scrollIndex == 2) and 0 or 1)
        end
        lib.notify({ title = 'Extra Applied', description = 'Vehicle extra / livery updated.', type = 'success' })
    end)

    lib.showMenu('spz_tuner_extras')
end

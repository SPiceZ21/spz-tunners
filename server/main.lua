-- server/main.lua

-- Receive vehicle tuning preset save event from client
RegisterNetEvent("SPZ:tuner:saveVehicle", function(netId, preset)
    local src = source
    if not netId or not preset then return end

    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(vehicle) then return end

    -- Store preset into entity statebag so any player streaming the vehicle receives the state
    Entity(vehicle).state:set("tunerPreset", preset, true)

    -- If spz-vehicles is active, save custom preset for player profile
    if GetResourceState("spz-vehicles") == "started" then
        pcall(function()
            local profile = exports["spz-identity"]:GetProfile(src)
            if profile and profile.id then
                local model = Entity(vehicle).state.modelName or GetEntityModel(vehicle)
                exports["spz-vehicles"]:SaveCustomization(profile.id, model, preset)
            end
        end)
    end
end)

-- Server Export to save tuning preset
exports("SaveTunerPreset", function(source, netId, preset)
    if not netId or not preset then return false end
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        Entity(vehicle).state:set("tunerPreset", preset, true)
        return true
    end
    return false
end)

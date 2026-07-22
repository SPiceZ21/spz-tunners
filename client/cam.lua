-- client/cam.lua
local cam = nil
local activeFocus = nil
local currentVeh = nil
local isCamActive = false

-- Focus Offsets for different tuning targets (relative to vehicle bounding box / coords)
local CAM_OFFSETS = {
    front = { pos = vector3(0.0, 3.8, 0.6), look = vector3(0.0, 1.2, 0.0) },
    rear  = { pos = vector3(0.0, -3.8, 0.6), look = vector3(0.0, -1.2, 0.0) },
    left  = { pos = vector3(-3.2, 0.0, 0.5), look = vector3(0.0, 0.0, 0.0) },
    right = { pos = vector3(3.2, 0.0, 0.5), look = vector3(0.0, 0.0, 0.0) },
    engine= { pos = vector3(0.0, 2.2, 1.4), look = vector3(0.0, 1.0, 0.2) },
    wheels= { pos = vector3(-2.2, 1.2, 0.1), look = vector3(0.0, 1.2, -0.2) },
    spoiler={ pos = vector3(0.0, -2.8, 1.4), look = vector3(0.0, -1.8, 0.4) },
    roof  = { pos = vector3(0.0, -0.5, 2.8), look = vector3(0.0, 0.0, 0.5) },
    inside= { pos = vector3(-0.3, 0.0, 0.6), look = vector3(0.3, 0.6, 0.2) },
    full  = { pos = vector3(-3.8, 3.8, 1.6), look = vector3(0.0, 0.0, 0.0) },
}

-- Orbit Cam Variables
local orbitAngleX = 0.0
local orbitAngleY = 0.3
local orbitRadius = 4.5

local function StartCamOrbitLoop()
    CreateThread(function()
        while isCamActive and cam and DoesEntityExist(currentVeh) do
            -- Right Mouse Button (RMB / INPUT_AIM = 25) for free rotation
            if IsDisabledControlPressed(0, 25) or IsControlPressed(0, 25) then
                DisableControlAction(0, 1, true) -- Look Left/Right
                DisableControlAction(0, 2, true) -- Look Up/Down

                local mouseX = GetDisabledControlNormal(0, 1)
                local mouseY = GetDisabledControlNormal(0, 2)

                orbitAngleX = orbitAngleX - (mouseX * 5.0)
                orbitAngleY = math.max(-0.2, math.min(1.2, orbitAngleY + (mouseY * 5.0)))

                local vPos = GetEntityCoords(currentVeh)
                local camX = vPos.x + orbitRadius * math.cos(orbitAngleY) * math.sin(orbitAngleX)
                local camY = vPos.y + orbitRadius * math.cos(orbitAngleY) * math.cos(orbitAngleX)
                local camZ = vPos.z + orbitRadius * math.sin(orbitAngleY)

                SetCamCoord(cam, camX, camY, camZ)
                PointCamAtCoord(cam, vPos.x, vPos.y, vPos.z + 0.4)
            end
            Wait(0)
        end
    end)
end

function EnableTunerCam(vehicle, targetFocus)
    if not Config.EnableDynamicCamera then return end
    if not DoesEntityExist(vehicle) then return end

    currentVeh = vehicle
    local focusConfig = CAM_OFFSETS[targetFocus] or CAM_OFFSETS.full
    local vPos = GetEntityCoords(vehicle)

    local worldPos  = GetOffsetFromEntityInWorldCoords(vehicle, focusConfig.pos.x, focusConfig.pos.y, focusConfig.pos.z)
    local worldLook = GetOffsetFromEntityInWorldCoords(vehicle, focusConfig.look.x, focusConfig.look.y, focusConfig.look.z)

    -- Calculate initial polar angles from targetFocus offset
    local relX = focusConfig.pos.x
    local relY = focusConfig.pos.y
    local relZ = focusConfig.pos.z
    orbitRadius = #(focusConfig.pos)
    orbitAngleX = math.atan(relX, relY)
    orbitAngleY = math.asin(relZ / orbitRadius)

    if not cam then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, worldPos.x, worldPos.y, worldPos.z)
        PointCamAtCoord(cam, worldLook.x, worldLook.y, worldLook.z)
        SetCamFov(cam, 50.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 800, true, true)

        isCamActive = true
        StartCamOrbitLoop()
    else
        SetCamCoord(cam, worldPos.x, worldPos.y, worldPos.z)
        PointCamAtCoord(cam, worldLook.x, worldLook.y, worldLook.z)
    end

    activeFocus = targetFocus
end

function DisableTunerCam()
    isCamActive = false
    if cam then
        RenderScriptCams(false, true, 800, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        cam = nil
    end
    activeFocus = nil
    currentVeh = nil
end

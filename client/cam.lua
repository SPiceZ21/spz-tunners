-- client/cam.lua
local cam = nil
local activeFocus = nil

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

function EnableTunerCam(vehicle, targetFocus)
    if not Config.EnableDynamicCamera then return end
    if not DoesEntityExist(vehicle) then return end

    local focusConfig = CAM_OFFSETS[targetFocus] or CAM_OFFSETS.full
    local vPos = GetEntityCoords(vehicle)

    local worldPos  = GetOffsetFromEntityInWorldCoords(vehicle, focusConfig.pos.x, focusConfig.pos.y, focusConfig.pos.z)
    local worldLook = GetOffsetFromEntityInWorldCoords(vehicle, focusConfig.look.x, focusConfig.look.y, focusConfig.look.z)

    if not cam then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, worldPos.x, worldPos.y, worldPos.z)
        PointCamAtCoord(cam, worldLook.x, worldLook.y, worldLook.z)
        SetCamFov(cam, 50.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 800, true, true)
    else
        SetCamCoord(cam, worldPos.x, worldPos.y, worldPos.z)
        PointCamAtCoord(cam, worldLook.x, worldLook.y, worldLook.z)
    end

    activeFocus = targetFocus
end

function DisableTunerCam()
    if cam then
        RenderScriptCams(false, true, 800, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        cam = nil
    end
    activeFocus = nil
end

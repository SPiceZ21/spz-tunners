-- client/cam.lua
-- Tuner camera — behaves like qbx_customs' drag cam.
--
--   * One camera for the whole tuner session. It opens with the main menu and
--     closes with it; moving between submenus does not reframe it.
--   * The cursor is on screen. Hold left mouse and drag to orbit the car.
--   * Scroll zooms (2.5 – 10 m), Space opens / shuts every door, V toggles
--     first-person view.
--   * While the tuner is open the car cannot be driven: throttle, brake,
--     steering and the radio are disabled.
--
-- Angles are world-space degrees around the car: yaw around Z, pitch 0 – 89
-- above the ground plane (90 would flip the camera, below 0 goes underground).

local cam         = nil
local currentVeh  = nil
local isCamActive = false
local firstPerson = false
local scaleform   = nil

local yaw, pitch = 0.0, 0.0
local radius     = 5.0

local SENSITIVITY = 8.0
local RADIUS_MIN, RADIUS_MAX, ZOOM_STEP = 2.5, 10.0, 0.5

local function place()
    local c = GetEntityCoords(currentVeh)
    local ry, rp = math.rad(yaw), math.rad(pitch)
    SetCamCoord(cam,
        c.x + math.cos(ry) * math.cos(rp) * radius,
        c.y + math.sin(ry) * math.cos(rp) * radius,
        c.z + math.sin(rp) * radius)
    PointCamAtCoord(cam, c.x, c.y, c.z + 0.5)
end

local function toggleDoors()
    for door = 0, GetNumberOfVehicleDoors(currentVeh) do
        if GetVehicleDoorAngleRatio(currentVeh, door) > 0.0 then
            SetVehicleDoorShut(currentVeh, door, false)
        else
            SetVehicleDoorOpen(currentVeh, door, false, false)
        end
    end
end

-- ── Instructional buttons ────────────────────────────────────────────────────

local function button(slot, control, text)
    BeginScaleformMovieMethod(scaleform, 'SET_DATA_SLOT')
    ScaleformMovieMethodAddParamInt(slot)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, control, true))
    BeginTextCommandScaleformString('STRING')
    AddTextComponentSubstringKeyboardDisplay(text)
    EndTextCommandScaleformString()
    EndScaleformMovieMethod()
end

local function drawButtons()
    CreateThread(function()
        scaleform = RequestScaleformMovie('instructional_buttons')
        while not HasScaleformMovieLoaded(scaleform) do Wait(0) end

        BeginScaleformMovieMethod(scaleform, 'CLEAR_ALL')
        EndScaleformMovieMethod()
        button(1, 14, 'Zoom out')
        button(2, 15, 'Zoom in')
        button(3, 22, 'Toggle doors')
        button(4, 0, 'Change view')
        BeginScaleformMovieMethod(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(scaleform, 'SET_BACKGROUND_COLOUR')
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(80)
        EndScaleformMovieMethod()

        while isCamActive do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        scaleform = nil
    end)
end

-- ── Input ────────────────────────────────────────────────────────────────────

-- On foot / combat inputs that would fire while you click around the car.
local PLAYER_CONTROLS = { 21, 24, 25, 30, 31, 36, 47, 58, 69, 75, 140, 141, 142, 143, 257, 263, 264 }
-- Mouse look + weapon wheel + pause-alternate (the cursor owns the mouse).
local CAM_CONTROLS    = { 1, 2, 3, 4, 5, 6, 12, 13, 200 }
-- The car stays put: throttle, brake, radio, steering.
local DRIVE_CONTROLS  = { 71, 72, 81, 82, 83, 84, 85, 106 }

local function disableAll(list)
    for _, c in ipairs(list) do DisableControlAction(0, c, true) end
end

local function dragLoop()
    CreateThread(function()
        while isCamActive do
            local dx = GetDisabledControlNormal(0, 1) * SENSITIVITY
            local dy = GetDisabledControlNormal(0, 2) * SENSITIVITY
            yaw   = yaw - dx
            pitch = math.max(0.0, math.min(89.0, pitch + dy))
            place()

            if IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 24) then
                SetMouseCursorSprite(3)
                return
            end
            Wait(0)
        end
    end)
end

local function inputLoop()
    CreateThread(function()
        while isCamActive do
            DisableControlAction(0, 0, true)   -- V: handled below
            disableAll(PLAYER_CONTROLS)
            disableAll(DRIVE_CONTROLS)

            if not firstPerson then
                SetMouseCursorActiveThisFrame()
                disableAll(CAM_CONTROLS)
                if IsDisabledControlJustPressed(0, 24) or IsControlJustPressed(0, 24) then
                    SetMouseCursorSprite(4)
                    dragLoop()
                end
            end

            if IsDisabledControlJustReleased(0, 14) or IsControlJustReleased(0, 14) then
                if radius + ZOOM_STEP <= RADIUS_MAX then radius = radius + ZOOM_STEP; place() end
            elseif IsDisabledControlJustReleased(0, 15) or IsControlJustReleased(0, 15) then
                if radius - ZOOM_STEP >= RADIUS_MIN then radius = radius - ZOOM_STEP; place() end
            end

            if IsControlJustPressed(0, 22) then toggleDoors() end

            if IsDisabledControlJustPressed(0, 0) then
                firstPerson = not firstPerson
                if firstPerson then
                    SetCamViewModeForContext(1, 4)
                    RenderScriptCams(false, true, 0, true, false)
                else
                    RenderScriptCams(true, true, 0, true, false)
                end
            end

            Wait(0)
        end
    end)
end

-- ── API (used by client/menu.lua) ────────────────────────────────────────────

--- Starts the session camera the first time; later calls (submenus) keep the
--- camera where the player left it, as qbx_customs does. `targetFocus` is
--- accepted for compatibility and ignored.
function EnableTunerCam(vehicle, targetFocus)
    if not Config.EnableDynamicCamera then return end
    if isCamActive or not DoesEntityExist(vehicle) then return end

    currentVeh  = vehicle
    yaw, pitch  = 0.0, 0.0
    radius      = 5.0
    firstPerson = false

    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    RenderScriptCams(true, true, 0, true, false)
    isCamActive = true

    place()          -- otherwise the cam sits on the player until the first drag
    drawButtons()
    inputLoop()
end

function DisableTunerCam()
    if not isCamActive then return end
    isCamActive = false
    RenderScriptCams(false, true, 0, true, false)
    if cam then DestroyCam(cam, true) end
    cam = nil
    SetCamViewModeForContext(1, 1)
    currentVeh = nil
end

-- Safety watchdog: whatever closes the menu (ESC, or an Enter/select that slips
-- past the reopen), if NO tuner menu is open the camera must come down — this is
-- what stops you getting stuck in the tuner camera.
CreateThread(function()
    local misses = 0
    while true do
        Wait(400)
        if isCamActive then
            local m = lib and lib.getOpenMenu and lib.getOpenMenu()
            local tunerOpen = type(m) == 'string' and m:sub(1, 10) == 'spz_tuner_'
            if tunerOpen then
                misses = 0
            else
                misses = misses + 1              -- ~0.8s grace for menu-to-menu hops
                if misses >= 2 then DisableTunerCam(); misses = 0 end
            end
        else
            misses = 0
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then DisableTunerCam() end
end)

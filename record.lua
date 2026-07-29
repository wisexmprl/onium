--// =========================================================
--// GENERATED FULL FIX BY GPT - AUTO MAP CLEAN SPEED PATCH
--// File ini dibuat dari script yang kamu upload.
--// Fokus fix: SAVE tetap hapus kedut, tapi speed normal map/coil dikunci otomatis.
--// =========================================================

--// =========================================================
--// ONIUM Recorder / BittWise Recorder
--// Delta + Xeno Mobile Friendly
--// FULL BITWISE SUPPORT + RAW MOMENTUM + ANTI KEDUT + SAFE ROLLBACK + CP MARKER
--// PATCH: AUTO MAP CLEAN + ANTI KEDUT + NORMAL SPEED LOCK + MERGE ANTI SPEED SPIKE
--// =========================================================

--// Anti duplicate
local ENV = _G
pcall(function()
    if getgenv then
        ENV = getgenv()
    end
end)

if ENV.__ONIUM_RECORDER_CLEANUP then
    pcall(ENV.__ONIUM_RECORDER_CLEANUP)
end

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Config
local FOLDER_NAME = "ONIUM_RECORDER"
local CUSTOM_LOGO_ASSET = "rbxassetid://130280202431400"
local USE_NATURAL_MAP_JUMP = true
local USE_MAP_WALKSPEED_ON_PLAYBACK = true
local USE_MAP_HIPHEIGHT_ON_PLAYBACK = true
local SAMPLE_INTERVAL = 0.004 -- RAW recorder: sample rapat, times tetap waktu asli

--// =========================================================
--// AUTO MAP CLEAN SPEED FIX 2026-05-09
--// SAVE tetap menghapus kedut seperti versi lama, tetapi speed lari normal
--// dikunci otomatis mengikuti map/coil yang sedang dipakai.
--// Contoh: kalau map speed normal 51, frame belok/mundur yang turun jadi 30
--// akan dinaikkan kembali ke 51 tanpa hardcode angka 51.
--// =========================================================
local EXPORT_RAW_EXACT_MODE = true
local RAW_EXACT_KEEP_WALKSPEED = true
local RAW_EXACT_SAVE_WITHOUT_HEAVY_CLEANER = false
local RAW_EXACT_DISABLE_PREVIEW_SPEED_MULTIPLIER = true
local RAW_EXACT_MIN_DT = 0.001

local AUTO_MAP_CLEAN_SPEED_MODE = true
local AUTO_MAP_LOCK_RUN_SPEED = true
local AUTO_MAP_SPEED_MIN_SAMPLES = 6
local AUTO_MAP_SPEED_DROP_TOLERANCE = 0.94
local AUTO_MAP_SPEED_SPIKE_CAP_MULT = 1.10
local AUTO_MAP_SPEED_MIN_MOVEDIR = 0.045
local AUTO_MAP_SPEED_USE_TIMING_FIX = true
local AUTO_MAP_SPEED_MIN_DT = 0.0065
local AUTO_MAP_SPEED_MAX_DT = 0.140 -- PATCH MERGE SPEED: boleh longgar agar dt tidak terlalu rapat lalu speed spike

--// PATCH LIGHT RECORD:
--// Record tetap akurat, tapi tidak lagi kerja berat setiap heartbeat.
--// 1) UI overlay di-update berkala, bukan 2x tiap frame.
--// 2) Ground raycast/cache tidak dipanggil setiap frame.
--// 3) Frame record dibatasi agar HP/Delta/Xeno tidak berat saat REC.
local RECORD_LIGHT_MODE = true
local RECORD_MIN_SAMPLE_DT = 0.0085      -- kira-kira max 117 fps; 60 fps tetap aman
local RECORD_AIR_SAMPLE_DT = 0.0045      -- saat jump/freefall boleh lebih rapat; mobile Delta butuh ambil tiap heartbeat
local RECORD_UI_UPDATE_INTERVAL = 0.10
local RECORD_GROUND_CACHE_INTERVAL = 0.055
local RECORD_TOOL_CACHE_INTERVAL = 0.15

--// PATCH MOBILE DELTA JUMP 2026-05-14:
--// Android + Delta sering FPS/tick lebih renggang dari PC Xeno.
--// Fix ini TIDAK lagi memaksa Running menjadi Jumping/Freefall hanya dari velocity Y.
--// Tujuan: record Delta tetap rapi seperti Xeno, tetapi lari di gundukan/jalan tidak rata
--// tetap dibaca Running, bukan lompat/terjun palsu.
local MOBILE_DELTA_JUMP_SAFE_MODE = true
local MOBILE_DELTA_AIR_MIN_DT = 0.010
local MOBILE_DELTA_AIR_MAX_DT = 0.045
local MOBILE_DELTA_GROUND_MIN_DT = 0.0085
local MOBILE_DELTA_GROUND_MAX_DT = 0.030
local MOBILE_DELTA_NORMAL_MAX_DT = 0.055
local MOBILE_DELTA_KEEP_RAW_DT_RATIO = 0.85
local MOBILE_DELTA_JUMP_Y_TRIGGER = 7.5
local MOBILE_DELTA_FALL_Y_TRIGGER = -5.5
local MOBILE_DELTA_REQUIRE_AIRBORNE_FOR_VELOCITY = true
local MOBILE_DELTA_VELOCITY_CONFIRM_FRAMES = 2

--// Playback speed mode dibuat sama seperti ONIUM Race:
--// angka speed = stud/s, bukan multiplier x.
local MIN_PLAYBACK_SPEED = 8
local MAX_PLAYBACK_SPEED = 500000
local DEFAULT_PLAYBACK_SPEED = 16

--// FORMAT JSON KHUSUS BITWISE
--// Samakan dengan JSON normal kedua.
local BITWISE_JSON_WALKSPEED = 45
local BITWISE_CLIMB_Y_SPEED = 31.5
local BITWISE_AIR_Y_SPEED = 50.7
local BITWISE_AIR_MIN_HSPEED = 45
local BITWISE_JSON_HIPHEIGHT = 5.331189155578613

--// Filter record agar avatar diam tidak masuk JSON
local MIN_RECORD_DISTANCE = 0.09
local MIN_VERTICAL_DISTANCE = 0.6
local MIN_MOVE_DIRECTION = 0.02
local MIN_HORIZONTAL_VELOCITY = 0.15

--// Filter merge agar idle frame dibuang
local CLEAN_DISTANCE_THRESHOLD = 0.07
local CLEAN_VERTICAL_THRESHOLD = 0.10

--// Smooth playback / merge anti-blink
local MAX_PLAYBACK_WAIT = 0.18
local PLAYBACK_MIN_DURATION = 0.004
local PLAYBACK_STEP_DISTANCE = 0.85
local PLAYBACK_MIN_STEP_DISTANCE = 0.04
local PLAYBACK_HOLD_FINAL_TIME = 0

--// FIX PLAY AFTER FINISH:
--// Kalau avatar masih berdiri di posisi FINISH lalu PLAY lagi, langsung balik ke START.
--// Kalau avatar sudah jauh dari FINISH, smart resume tetap mulai dari titik path terdekat.
local PLAY_AGAIN_FINISH_RESET_DISTANCE = 18
local PLAY_AGAIN_FINISH_TIME_WINDOW = 0.12

--// FIX LOOP SPEED:
--// Pengaman agar mode loop/toggle loop dari versi UI lain tidak membuat velocity dobel/kenceng.
local LOOP_SPEED_SAFE_CAP_MULTIPLIER = 1.12

--// Speed sync limiter:
--// Export JSON akan retime berdasarkan jarak / speed set, supaya saat di-load di ONIUM Race
--// speedometer tidak tembus jauh di atas angka yang kamu set.
local SPEED_TIMING_MIN_DT = 0.006
local SPEED_TIMING_MAX_DT = 0.18
local SPEED_HARD_CAP_MULTIPLIER = 1.03

--// Jangan tarik karakter untuk jarak jauh.
--// Kalau jarak antar frame/antar file terlalu jauh, playback akan cut/teleport sekali, bukan ditarik bolak-balik.
local PLAYBACK_MAX_SMOOTH_DISTANCE = 10
local BRIDGE_STEP_DISTANCE = 0.85
local MERGE_SKIP_JOIN_DISTANCE = 0.35
local MERGE_MAX_BRIDGE_DISTANCE = 10
local MAX_BRIDGE_FRAMES = 80

--// Ground / object detector untuk rollback ke object terakhir yang diinjak
local GROUND_RAY_DISTANCE = 9
local ROLLBACK_OBJECT_HARD_LIMIT = 800

--// Rollback
local ROLLBACK_SECONDS = 2.5
local ROLLBACK_MAX_FRAMES = math.max(5, math.floor(ROLLBACK_SECONDS / SAMPLE_INTERVAL))

--// UI Vars
local ScreenGui
local MainFrame
local MiniLogo
local RecordOverlay
local ToastLabel

local searchBox
local saveNameBox
local speedBox
local listFrame
local listLayout
local timerLabel
local overlayStatusLabel
local frameCountLabel
local cpMarkerToggleBtn

--// Data State
local checkpoints = {}
local nextOrder = 1

--// TITIK PETUNJUK SAMBUNGAN CP
local seamDotFolder = nil
local MERGE_DOT_ENABLED = true
local MERGE_DOT_COUNT = 12
local MERGE_DOT_SIZE = 0.46
local MERGE_DOT_HEIGHT = 0.35

--// TANDA PER CP + SAMBUNGAN MERGE
--// Default OFF supaya saat SAVE tidak freeze/render berat.
local CP_MARKER_ENABLED = false
local CP_MARKER_SELECTED_NAME = nil -- nil = semua CP, string = hanya 1 checkpoint
local CP_MARKER_CULLER_TOKEN = 0
local CP_MARKER_DOT_COUNT = 6
local CP_MARKER_SIZE = 0.42
local CP_MARKER_HEIGHT = 1.25
local CP_MARKER_MAX_PER_CP = 8
--// Marker CP jangan ganggu layar: hanya kelihatan kalau dekat.
CP_MARKER_LABEL_MAX_DISTANCE = 45
CP_MARKER_VISIBLE_DISTANCE = 70
CP_MARKER_CULL_INTERVAL = 0.35

local recordFrames = {}
local temporaryRecord = {}

local isRecording = false
local isRollbacking = false
local rollbackCancel = false
local rollbackToken = 0
local isPlaying = false
local playToken = 0

--// Speed sync seperti ONIUM Race
--// currentPlaybackSpeed = speed yang kamu set dari speedometer / manual.
--// syncBaseSpeed = speed dasar yang akan ditulis ke JSON sebagai ws.
--// ONIUM Race menghitung: speedMultiplier = currentPlaybackSpeed / recordedBaseSpeed.
--// Jadi kalau di ONIUM Race kamu Set Speed dari speedometer dengan angka yang sama,
--// replay akan jalan normal/sinkron.
local currentPlaybackSpeed = DEFAULT_PLAYBACK_SPEED
local syncBaseSpeed = DEFAULT_PLAYBACK_SPEED

local recordConnection = nil
local allConnections = {}

--// Record cursor position supaya setelah rollback record lanjut smooth
local lastRecordSavedPos = nil
local recordStartClock = 0

--// FIX COIL SPEED:
--// Jangan biarkan rollback / stop record menurunkan speed coil.
--// Kita simpan speed humanoid sebelum record dan speed tertinggi saat tool/coil dipakai.
local preRecordWalkSpeed = nil
local lastKnownToolWalkSpeed = nil
local lastKnownEquippedTool = ""

--// FIX MAP SPEED AFTER PREVIEW/PLAY STOP:
--// Setiap map bisa punya WalkSpeed berbeda.
--// Jadi speed asli map disimpan SEBELUM preview/playback, lalu dipakai lagi saat stop/finish.
--// Jangan memakai currentPlaybackSpeed/syncBaseSpeed sebagai speed normal map.
local prePlaybackMapWalkSpeed = nil
local prePlaybackHadTool = false

function hasEquippedToolSafe(char)
    char = char or LocalPlayer.Character
    if not char then
        return false
    end

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            lastKnownEquippedTool = obj.Name
            return true
        end
    end

    return false
end

function captureMapSpeedBeforePlayback()
    local char, hum = getCharacter()
    if not hum then
        return
    end

    --// Ambil speed asli sebelum playback mengubah Humanoid.WalkSpeed.
    prePlaybackMapWalkSpeed = tonumber(hum.WalkSpeed) or DEFAULT_PLAYBACK_SPEED
    prePlaybackHadTool = hasEquippedToolSafe(char)
end

--// Forward
local refreshList
local playCheckpoint
local stopPlayback
local startRecording
local stopRecording
local rollbackRecording
local saveTemporaryRecord
local importLoad
local deleteAllCheckpoints
local mergeCheckpoints

--// =========================================================
--// Utility
--// =========================================================

function addConnection(c)
    if c then
        table.insert(allConnections, c)
    end
    return c
end

function cleanup()
    pcall(function()
        if recordConnection then
            recordConnection:Disconnect()
            recordConnection = nil
        end
    end)

    for _, c in ipairs(allConnections) do
        pcall(function()
            c:Disconnect()
        end)
    end

    playToken = playToken + 1
    isPlaying = false
    isRecording = false
    isRollbacking = false

    --// Hapus titik sambungan kalau script diexecute ulang / diclose
    pcall(function()
        if seamDotFolder then
            seamDotFolder:Destroy()
            seamDotFolder = nil
        end

        local old = workspace:FindFirstChild("ONIUM_MERGE_DOTS")
        if old then
            old:Destroy()
        end

        local oldCp = workspace:FindFirstChild("ONIUM_CP_MARKERS")
        if oldCp then
            oldCp:Destroy()
        end
    end)

    pcall(function()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end)
end

ENV.__ONIUM_RECORDER_CLEANUP = cleanup

function roundNumber(n, dec)
    dec = dec or 3
    local mult = 10 ^ dec
    return math.floor((tonumber(n) or 0) * mult + 0.5) / mult
end

function parseSpeedValue(raw, fallback)
    raw = tostring(raw or fallback or DEFAULT_PLAYBACK_SPEED)
    raw = raw:gsub(",", ".")
    raw = raw:gsub("[^%d%.%-]", "")

    local spd = tonumber(raw) or tonumber(fallback) or DEFAULT_PLAYBACK_SPEED
    spd = math.clamp(spd, MIN_PLAYBACK_SPEED, MAX_PLAYBACK_SPEED)

    return roundNumber(spd, 1)
end

function setSyncBaseSpeed(value, updateBox)
    local spd = parseSpeedValue(value, syncBaseSpeed or currentPlaybackSpeed or DEFAULT_PLAYBACK_SPEED)

    currentPlaybackSpeed = spd
    syncBaseSpeed = spd

    if updateBox and speedBox then
        speedBox.Text = tostring(spd)
    end

    return spd
end

function readSpeedBoxToSync()
    if speedBox then
        return setSyncBaseSpeed(speedBox.Text, false)
    end

    return setSyncBaseSpeed(syncBaseSpeed or currentPlaybackSpeed or DEFAULT_PLAYBACK_SPEED, false)
end

function getExportSyncSpeed()
    return parseSpeedValue(syncBaseSpeed or currentPlaybackSpeed or DEFAULT_PLAYBACK_SPEED, DEFAULT_PLAYBACK_SPEED)
end

function trimText(s)
    s = tostring(s or "")
    s = s:gsub("^%s+", "")
    s = s:gsub("%s+$", "")
    return s
end

function cleanFileName(s)
    s = trimText(s)
    s = s:gsub("[^%w_%-]", "_")
    if s == "" then
        s = "checkpoint"
    end
    return s
end

function vecToTable(v)
    -- RAW precision: jangan bulatkan 4 digit, karena city/position contoh JSON punya detail banyak.
    return {
        x = roundNumber(v.X, 9),
        y = roundNumber(v.Y, 9),
        z = roundNumber(v.Z, 9)
    }
end

function tableToVec(t)
    if type(t) ~= "table" then
        return Vector3.new(0, 0, 0)
    end

    return Vector3.new(
        tonumber(t.x) or 0,
        tonumber(t.y) or 0,
        tonumber(t.z) or 0
    )
end

function horizontalDistance(a, b)
    return Vector3.new(a.X - b.X, 0, a.Z - b.Z).Magnitude
end

function deepCopy(t)
    if type(t) ~= "table" then
        return t
    end

    local copy = {}
    for k, v in pairs(t) do
        copy[k] = deepCopy(v)
    end
    return copy
end

function getCharacter()
    local char = LocalPlayer.Character
    if not char then
        char = LocalPlayer.CharacterAdded:Wait()
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not hum then
        hum = char:WaitForChild("Humanoid", 5)
    end

    if not hrp then
        hrp = char:WaitForChild("HumanoidRootPart", 5)
    end

    return char, hum, hrp
end

function restoreCharacterControl(speedOverride)
    local char, hum, hrp = getCharacter()

    --// PRIORITAS RESTORE SPEED:
    --// 1) speedOverride kalau memang dikirim manual.
    --// 2) speed asli map yang disimpan sebelum preview/playback.
    --// 3) speed sebelum record.
    --// 4) WalkSpeed sekarang / default.
    local targetSpeed = tonumber(speedOverride)
        or tonumber(prePlaybackMapWalkSpeed)
        or tonumber(preRecordWalkSpeed)
        or tonumber(hum and hum.WalkSpeed)
        or DEFAULT_PLAYBACK_SPEED

    local toolNow = hasEquippedToolSafe(char)

    --// Kalau sedang pakai coil/tool, jangan turunkan speed tool.
    --// Kalau tidak pakai tool, PAKSA balik ke speed map asli, bukan speed playback.
    if toolNow then
        if tonumber(hum and hum.WalkSpeed) then
            targetSpeed = math.max(targetSpeed, tonumber(hum.WalkSpeed))
        end

        if tonumber(lastKnownToolWalkSpeed) then
            targetSpeed = math.max(targetSpeed, tonumber(lastKnownToolWalkSpeed))
        end
    else
        targetSpeed = tonumber(speedOverride)
            or tonumber(prePlaybackMapWalkSpeed)
            or tonumber(preRecordWalkSpeed)
            or DEFAULT_PLAYBACK_SPEED
    end

    targetSpeed = math.clamp(targetSpeed, MIN_PLAYBACK_SPEED, MAX_PLAYBACK_SPEED)

    local function applyRestore()
        char, hum, hrp = getCharacter()
        local stillTool = hasEquippedToolSafe(char)

        if hum then
            pcall(function()
                hum.AutoRotate = true
                hum.PlatformStand = false
                hum.Sit = false

                if stillTool then
                    --// Tool/coil: hanya naikkan kalau speed turun.
                    if (tonumber(hum.WalkSpeed) or 0) < targetSpeed - 0.1 then
                        hum.WalkSpeed = targetSpeed
                    end
                else
                    --// Non-tool: kembalikan tepat ke speed map asli.
                    hum.WalkSpeed = targetSpeed
                end

                hum:Move(Vector3.new(0, 0, 0), true)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end

        if hrp then
            pcall(function()
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end)
        end
    end

    applyRestore()

    --// Beberapa map/game script menulis WalkSpeed ulang 1-3 frame setelah stop.
    --// Restore diulang sebentar agar tidak nyangkut ke speed preview/playback.
    task.delay(0.05, applyRestore)
    task.delay(0.15, applyRestore)

    if toolNow then
        task.delay(0.35, applyRestore)
    end
end
function getEquippedToolName(char)
    char = char or LocalPlayer.Character
    if not char then
        return ""
    end

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            return obj.Name
        end
    end

    return ""
end

function getHumanoidStateName(hum)
    local state = "Unknown"

    pcall(function()
        state = tostring(hum:GetState())
        state = state:gsub("Enum.HumanoidStateType.", "")
    end)

    return state
end

function isAirState(state)
    state = tostring(state or "")
    return state == "Jumping"
        or state == "Freefall"
        or state == "FallingDown"
        or state == "Climbing"
        or state == "Swimming"
end

function isMobileTouchDeviceSafe()
    local ok, result = pcall(function()
        local UIS = game:GetService("UserInputService")
        return UIS.TouchEnabled and not UIS.KeyboardEnabled
    end)
    return ok and result == true
end

function getHumanoidFloorMaterialNameSafe(hum)
    local ok, mat = pcall(function()
        return hum and hum.FloorMaterial
    end)

    if ok and mat then
        return tostring(mat):gsub("Enum.Material.", "")
    end

    return "Unknown"
end

function isGroundFloorMaterialName(name)
    name = tostring(name or "")
    name = name:gsub("Enum.Material.", "")
    return name ~= "" and name ~= "Air" and name ~= "Unknown" and name ~= "nil"
end

function isHumanoidGroundedSafe(hum)
    return isGroundFloorMaterialName(getHumanoidFloorMaterialNameSafe(hum))
end

function mobileDeltaFrameHasGroundData(fr)
    if type(fr) ~= "table" or type(fr.ground) ~= "table" then
        return false
    end

    local g = fr.ground
    local key = tostring(g.path or g.name or "")
    return key ~= ""
end

function mobileDeltaFrameHasGroundContact(fr)
    if type(fr) ~= "table" then
        return false
    end

    if fr.grounded == true or fr.isGrounded == true then
        return true
    end

    if isGroundFloorMaterialName(fr.floorMaterial or fr.floor or fr.floorMat) then
        return true
    end

    -- Untuk JSON lama yang belum punya floorMaterial/grounded, ground dipakai hanya sebagai
    -- pelindung agar Running di jalan miring/gundukan tidak dipaksa jadi Freefall.
    local st = tostring(fr.states or fr.state or "")
    if mobileDeltaFrameHasGroundData(fr)
        and (st == "" or st == "Running" or st == "Landed" or st == "Walking" or st == "Standing" or st == "None" or st == "Unknown")
    then
        return true
    end

    return false
end

function mobileDeltaVelocityConfirmedAir(frames, index, yv)
    if type(frames) ~= "table" then
        return false
    end

    local need = math.max(1, tonumber(MOBILE_DELTA_VELOCITY_CONFIRM_FRAMES) or 2)
    local upward = (tonumber(yv) or 0) >= (MOBILE_DELTA_JUMP_Y_TRIGGER or 7.5)
    local downward = (tonumber(yv) or 0) <= (MOBILE_DELTA_FALL_Y_TRIGGER or -5.5)

    if not upward and not downward then
        return false
    end

    local count = 0
    for j = math.max(1, index - 1), math.min(#frames, index + 1) do
        local fr = frames[j]
        if type(fr) == "table" and not mobileDeltaFrameHasGroundContact(fr) then
            local vy = tableToVec(fr.city).Y
            if upward and vy >= (MOBILE_DELTA_JUMP_Y_TRIGGER or 7.5) then
                count = count + 1
            elseif downward and vy <= (MOBILE_DELTA_FALL_Y_TRIGGER or -5.5) then
                count = count + 1
            end
        end
    end

    return count >= need
end

function frameIsMobileDeltaSafe(fr)
    if type(fr) ~= "table" then
        return false
    end

    return fr.mobileRecord == true
        or fr.isMobileRecord == true
        or tostring(fr.inputDevice or "") == "MobileDelta"
        or tostring(fr.executorDevice or "") == "DeltaAndroid"
end

function framesLookMobileDeltaSafe(frames)
    if type(frames) ~= "table" or #frames <= 0 then
        return false
    end

    local mobileTagged = 0
    local noShift = 0
    local total = 0
    local dtSum = 0
    local dtCount = 0
    local lastT = nil

    for _, fr in ipairs(frames) do
        if type(fr) == "table" then
            total = total + 1
            if frameIsMobileDeltaSafe(fr) then
                mobileTagged = mobileTagged + 1
            end
            if fr.noShiftLock == true or tostring(fr.rotationMode or "") == "AutoRotate" then
                noShift = noShift + 1
            end

            local t = tonumber(fr.times) or tonumber(fr.t)
            if t and lastT then
                local dt = t - lastT
                if dt > 0 and dt < 0.25 then
                    dtSum = dtSum + dt
                    dtCount = dtCount + 1
                end
            end
            if t then
                lastT = t
            end
        end
    end

    if total <= 0 then
        return false
    end

    if mobileTagged >= math.max(1, math.floor(total * 0.10)) then
        return true
    end

    -- Fallback untuk record lama: mobile Delta biasanya AutoRotate/noShiftLock
    -- dan jarak timestamp lebih renggang daripada PC Xeno.
    local avgDt = dtCount > 0 and (dtSum / dtCount) or 0
    return noShift >= math.max(5, math.floor(total * 0.72)) and avgDt >= 0.018
end

function mobileDeltaFixAirStateByVelocity(frames)
    if not MOBILE_DELTA_JUMP_SAFE_MODE or not framesLookMobileDeltaSafe(frames) then
        return frames or {}
    end

    local out = deepCopy(frames or {})
    for i, fr in ipairs(out) do
        if type(fr) == "table" then
            local st = tostring(fr.states or fr.state or "")
            local yv = tableToVec(fr.city).Y
            local grounded = mobileDeltaFrameHasGroundContact(fr)

            if st ~= "Climbing" and st ~= "Swimming" then
                if grounded then
                    -- FIX UTAMA: lari di gundukan/jalan tidak rata bisa punya velocity Y,
                    -- tapi selama masih grounded jangan ditulis sebagai Jumping/Freefall.
                    if st == "Jumping" or st == "Freefall" or st == "FallingDown" or fr.jump == true then
                        fr.states = "Running"
                        fr.jump = false
                    end
                else
                    -- Delta support tetap ada, tapi hanya untuk frame yang benar-benar tidak menapak
                    -- dan velocity terkonfirmasi minimal beberapa frame, bukan 1 spike gundukan.
                    local explicitAir = st == "Jumping" or st == "Freefall" or st == "FallingDown"
                    local velocityAir = mobileDeltaVelocityConfirmedAir(out, i, yv)

                    if explicitAir or velocityAir then
                        if yv >= (MOBILE_DELTA_JUMP_Y_TRIGGER or 7.5) then
                            fr.states = "Jumping"
                            fr.jump = true
                        elseif yv <= (MOBILE_DELTA_FALL_Y_TRIGGER or -5.5) then
                            fr.states = "Freefall"
                            fr.jump = false
                        elseif explicitAir then
                            if st == "FallingDown" then
                                fr.states = "Freefall"
                            end
                        end
                    end
                end
            end
        end
    end

    return out
end

function getSafeFullName(inst)
    local ok, result = pcall(function()
        return inst:GetFullName()
    end)

    if ok and result then
        return tostring(result)
    end

    return tostring(inst and inst.Name or "Unknown")
end

function normalizeGroundInfo(g)
    if type(g) ~= "table" then
        return nil
    end

    return {
        name = tostring(g.name or ""),
        class = tostring(g.class or ""),
        path = tostring(g.path or g.name or ""),
        position = {
            x = tonumber(g.position and g.position.x) or 0,
            y = tonumber(g.position and g.position.y) or 0,
            z = tonumber(g.position and g.position.z) or 0
        },
        hitPosition = {
            x = tonumber(g.hitPosition and g.hitPosition.x) or 0,
            y = tonumber(g.hitPosition and g.hitPosition.y) or 0,
            z = tonumber(g.hitPosition and g.hitPosition.z) or 0
        }
    }
end

function getGroundInfo(hrp)
    if not hrp then
        return nil
    end

    local char = LocalPlayer.Character
    local params = RaycastParams.new()

    pcall(function()
        params.FilterType = Enum.RaycastFilterType.Blacklist
    end)

    pcall(function()
        params.FilterDescendantsInstances = char and { char } or {}
    end)

    pcall(function()
        params.IgnoreWater = true
    end)

    local ok, result = pcall(function()
        return workspace:Raycast(
            hrp.Position,
            Vector3.new(0, -GROUND_RAY_DISTANCE, 0),
            params
        )
    end)

    if not ok or not result or not result.Instance then
        return nil
    end

    local inst = result.Instance
    local instPos = Vector3.new(0, 0, 0)

    pcall(function()
        instPos = inst.Position
    end)

    return {
        name = tostring(inst.Name),
        class = tostring(inst.ClassName),
        path = getSafeFullName(inst),
        position = vecToTable(instPos),
        hitPosition = vecToTable(result.Position)
    }
end

function groundKeyFromFrame(fr)
    if type(fr) ~= "table" or type(fr.ground) ~= "table" then
        return nil
    end

    local key = tostring(fr.ground.path or fr.ground.name or "")
    if key == "" then
        return nil
    end

    return key
end

--// =========================================================
--// ROLLBACK TARGET: BALIK KE POSISI SEBELUM LOMPAT
--// Cari frame terakhir yang masih grounded sebelum Jumping/Freefall
--// =========================================================

--// =========================================================
--// ROLLBACK TARGET: BALIK KE POSISI SEBELUM LOMPAT
--// Contoh: dari tangga A lompat ke tangga B gagal/jatuh,
--// pencet ROLL -> balik ke posisi terakhir sebelum kaki lepas dari tangga A.
--// =========================================================

local ROLLBACK_BEFORE_JUMP_BACKSTEP = 2 -- mundur 2 frame biar benar-benar sebelum lompat

function getFrameYVelocity(fr)
    if type(fr) ~= "table" then
        return 0
    end

    local city = tableToVec(fr.city)
    return city.Y or 0
end

function isRollbackAirFrame(fr)
    if type(fr) ~= "table" then
        return false
    end

    local st = tostring(fr.states or fr.state or "")
    local yVel = getFrameYVelocity(fr)
    local hasGround = groundKeyFromFrame(fr) ~= nil

    --// State udara jelas
    if fr.jump == true
        or st == "Jumping"
        or st == "Freefall"
        or st == "FallingDown"
    then
        return true
    end

    --// Kalau tidak ada ground dan velocity Y bergerak, anggap udara
    if not hasGround and math.abs(yVel) > 1.5 then
        return true
    end

    return false
end

function isRollbackGroundFrame(fr)
    if type(fr) ~= "table" then
        return false
    end

    if isRollbackAirFrame(fr) then
        return false
    end

    local st = tostring(fr.states or fr.state or "")

    --// Jangan pilih climbing/swimming sebagai titik sebelum lompat biasa
    if st == "Climbing" or st == "Swimming" then
        return false
    end

    if groundKeyFromFrame(fr) ~= nil then
        return true
    end

    if st == "Running" or st == "Landed" then
        return true
    end

    return false
end

function findRollbackBeforeJumpIndex()
    local n = #recordFrames
    if n <= 2 then
        return nil, nil
    end

    --// 1) Cari area udara terakhir dari belakang.
    --// Ini berarti kalau sudah jatuh/mendarat setelah gagal lompat,
    --// tetap balik ke lompatan terakhir, bukan ke tempat jatuh.
    local lastAirIndex = nil
    for i = n, 1, -1 do
        if isRollbackAirFrame(recordFrames[i]) then
            lastAirIndex = i
            break
        end
    end

    if not lastAirIndex then
        return nil, nil
    end

    --// 2) Cari awal area udara itu.
    local airStart = lastAirIndex
    while airStart > 1 and isRollbackAirFrame(recordFrames[airStart - 1]) do
        airStart = airStart - 1
    end

    --// 3) Cari frame ground terakhir sebelum udara.
    local groundIndex = nil
    for i = airStart - 1, 1, -1 do
        if isRollbackGroundFrame(recordFrames[i]) then
            groundIndex = i
            break
        end
    end

    if not groundIndex then
        return nil, nil
    end

    --// 4) Mundur sedikit supaya benar-benar sebelum loncat,
    --// bukan pas frame kaki hampir lepas.
    local safeIndex = math.max(1, groundIndex - ROLLBACK_BEFORE_JUMP_BACKSTEP)

    --// Cari lagi frame ground terdekat dari safeIndex.
    for i = safeIndex, groundIndex do
        if isRollbackGroundFrame(recordFrames[i]) then
            return i, "sebelum_lompat"
        end
    end

    return groundIndex, "sebelum_lompat"
end

function formatTime(t)
    t = tonumber(t) or 0
    local minutes = math.floor(t / 60)
    local seconds = t - (minutes * 60)
    return string.format("%02d:%05.2f", minutes, seconds)
end

function notify(title, text, sec)
    title = tostring(title or "ONIUM")
    text = tostring(text or "")
    sec = sec or 2

    warn("[ONIUM Recorder] " .. title .. " - " .. text)

    if not ToastLabel then
        return
    end

    ToastLabel.Text = title .. " | " .. text
    ToastLabel.Visible = true

    task.delay(sec, function()
        if ToastLabel and ToastLabel.Text == title .. " | " .. text then
            ToastLabel.Visible = false
        end
    end)
end

--// =========================================================
--// TITIK PATH KHUSUS SAMBUNGAN MERGE CP
--// =========================================================

--// =========================================================
--// TITIK PATH KHUSUS SAMBUNGAN MERGE CP
--// =========================================================

function clearMergeDots()
    pcall(function()
        if seamDotFolder then
            seamDotFolder:Destroy()
            seamDotFolder = nil
        end

        local old = workspace:FindFirstChild("ONIUM_MERGE_DOTS")
        if old then
            old:Destroy()
        end
    end)
end

function getMergeDotFolder()
    if seamDotFolder and seamDotFolder.Parent then
        return seamDotFolder
    end

    local old = workspace:FindFirstChild("ONIUM_MERGE_DOTS")
    if old then
        old:Destroy()
    end

    seamDotFolder = Instance.new("Folder")
    seamDotFolder.Name = "ONIUM_MERGE_DOTS"
    seamDotFolder.Parent = workspace

    return seamDotFolder
end

function groundPositionForDot(pos)
    local origin = pos + Vector3.new(0, 8, 0)
    local direction = Vector3.new(0, -60, 0)

    local params = RaycastParams.new()
    pcall(function()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {}
        params.IgnoreWater = true
    end)

    local ok, result = pcall(function()
        return workspace:Raycast(origin, direction, params)
    end)

    if ok and result and result.Position then
        return result.Position + Vector3.new(0, MERGE_DOT_HEIGHT, 0)
    end

    return pos + Vector3.new(0, MERGE_DOT_HEIGHT, 0)
end

function makeBillboardLabel(parent, text, color)
    local bill = Instance.new("BillboardGui")
    bill.Name = "ONIUM_Label"
    bill.Size = UDim2.fromOffset(105, 26)
    bill.StudsOffset = Vector3.new(0, 1.7, 0)
    bill.AlwaysOnTop = false
    bill.MaxDistance = CP_MARKER_LABEL_MAX_DISTANCE
    bill.Parent = parent

    local bg = Instance.new("Frame")
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    bg.BackgroundTransparency = 0.15
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Parent = bill
    pcall(function()
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = bg
        local st = Instance.new("UIStroke")
        st.Color = color or Color3.fromRGB(255, 230, 60)
        st.Thickness = 1
        st.Transparency = 0.1
        st.Parent = bg
    end)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Text = tostring(text or "CP")
    lbl.TextColor3 = color or Color3.fromRGB(255, 230, 60)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextStrokeTransparency = 0.25
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.fromOffset(4, 0)
    lbl.Parent = bg

    return bill
end

function createMarkerPart(folder, name, pos, color, size, shape)
    local p = Instance.new("Part")
    p.Name = tostring(name or "ONIUM_MARK")
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.Material = Enum.Material.Neon
    p.Color = color or Color3.fromRGB(255, 230, 60)
    p.Size = size or Vector3.new(CP_MARKER_SIZE, CP_MARKER_SIZE, CP_MARKER_SIZE)
    p.Shape = shape or Enum.PartType.Ball
    p.CFrame = CFrame.new(pos)
    pcall(function() p:SetAttribute("BaseTransparency", p.Transparency) end)
    p.Parent = folder
    pcall(function()
        p.CanQuery = false
    end)
    return p
end

function createMergeDotPath(joinNumber, cpName, previousPos, joinPos)
    if not MERGE_DOT_ENABLED then
        return
    end

    if typeof(previousPos) ~= "Vector3" then
        previousPos = tableToVec(previousPos)
    end

    if typeof(joinPos) ~= "Vector3" then
        joinPos = tableToVec(joinPos)
    end

    if previousPos.Magnitude <= 0 or joinPos.Magnitude <= 0 then
        return
    end

    local folder = getMergeDotFolder()
    local dist = (joinPos - previousPos).Magnitude

    local dotCount = MERGE_DOT_COUNT
    if dist < 1 then
        dotCount = 2
    elseif dist > 30 then
        dotCount = 18
    end

    local firstDot = nil
    local lastDot = nil

    for n = 1, dotCount do
        local alpha = n / dotCount
        local rawPos = previousPos:Lerp(joinPos, alpha)
        local dotPos = groundPositionForDot(rawPos)
        local sizeMul = (n == 1 or n == dotCount) and 1.35 or 1

        local dot = createMarkerPart(
            folder,
            "JOIN_DOT_CP_" .. tostring(joinNumber) .. "_" .. tostring(n),
            dotPos,
            Color3.fromRGB(255, 230, 60),
            Vector3.new(MERGE_DOT_SIZE * sizeMul, MERGE_DOT_SIZE * sizeMul, MERGE_DOT_SIZE * sizeMul),
            Enum.PartType.Ball
        )

        if not firstDot then
            firstDot = dot
        end
        lastDot = dot
    end

    if lastDot then
        makeBillboardLabel(
            lastDot,
            "SAMBUNG CP " .. tostring(joinNumber) .. "\n" .. tostring(cpName or "checkpoint"),
            Color3.fromRGB(255, 230, 60)
        )
    end

    if firstDot and lastDot and firstDot ~= lastDot then
        pcall(function()
            local a0 = Instance.new("Attachment")
            a0.Name = "ONIUM_BEAM_A"
            a0.Parent = firstDot
            local a1 = Instance.new("Attachment")
            a1.Name = "ONIUM_BEAM_B"
            a1.Parent = lastDot
            local beam = Instance.new("Beam")
            beam.Name = "ONIUM_JOIN_BEAM"
            beam.Attachment0 = a0
            beam.Attachment1 = a1
            beam.Width0 = 0.12
            beam.Width1 = 0.12
            beam.FaceCamera = true
            beam.LightEmission = 1
            beam.Transparency = NumberSequence.new(0.2)
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 230, 60))
            beam.Parent = firstDot
        end)
    end
end

function clearCheckpointMarkers()
    --// Stop culler lama supaya tidak ada task render jalan terus.
    CP_MARKER_CULLER_TOKEN = CP_MARKER_CULLER_TOKEN + 1

    pcall(function()
        local old = workspace:FindFirstChild("ONIUM_CP_MARKERS")
        if old then
            old:Destroy()
        end
    end)
end

function getCheckpointMarkerFolder()
    local old = workspace:FindFirstChild("ONIUM_CP_MARKERS")
    if old then
        return old
    end

    local folder = Instance.new("Folder")
    folder.Name = "ONIUM_CP_MARKERS"
    folder.Parent = workspace
    return folder
end

function getFramePosSafe(fr)
    if type(fr) ~= "table" then
        return nil
    end
    local pos = tableToVec(fr.position)
    if pos.Magnitude <= 0 then
        return nil
    end
    return pos
end

function startCheckpointMarkerDistanceCuller(folder)
    if not folder then
        return
    end

    --// Hanya 1 culler aktif. Kalau marker direfresh/clear, task lama otomatis berhenti.
    CP_MARKER_CULLER_TOKEN = CP_MARKER_CULLER_TOKEN + 1
    local myToken = CP_MARKER_CULLER_TOKEN

    task.spawn(function()
        local tokenFolder = folder
        while myToken == CP_MARKER_CULLER_TOKEN and tokenFolder and tokenFolder.Parent do
            local _, _, hrp = getCharacter()
            if hrp then
                local myPos = hrp.Position
                for _, obj in ipairs(tokenFolder:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local visible = (obj.Position - myPos).Magnitude <= CP_MARKER_VISIBLE_DISTANCE
                        obj.Transparency = visible and (tonumber(obj:GetAttribute("BaseTransparency")) or 0) or 1
                    elseif obj:IsA("Beam") then
                        local a0 = obj.Attachment0
                        local a1 = obj.Attachment1
                        local p0 = a0 and a0.WorldPosition
                        local p1 = a1 and a1.WorldPosition
                        local visible = false
                        if p0 and p1 then
                            local mid = (p0 + p1) * 0.5
                            visible = (p0 - myPos).Magnitude <= CP_MARKER_VISIBLE_DISTANCE
                                or (p1 - myPos).Magnitude <= CP_MARKER_VISIBLE_DISTANCE
                                or (mid - myPos).Magnitude <= CP_MARKER_VISIBLE_DISTANCE
                        end
                        obj.Enabled = visible
                    end
                end
            end
            task.wait(CP_MARKER_CULL_INTERVAL)
        end
    end)
end

function createCheckpointMarker(cp, cpIndex)
    if not CP_MARKER_ENABLED or not cp or type(cp.frames) ~= "table" or #cp.frames <= 0 then
        return
    end

    local folder = getCheckpointMarkerFolder()
    local frames = cp.frames
    local cpName = tostring(cp.name or ("checkpoint_" .. tostring(cpIndex)))
    local startPos = getFramePosSafe(frames[1])
    local endPos = getFramePosSafe(frames[#frames])

    if not startPos or not endPos then
        return
    end

    local startGround = groundPositionForDot(startPos) + Vector3.new(0, CP_MARKER_HEIGHT, 0)
    local endGround = groundPositionForDot(endPos) + Vector3.new(0, CP_MARKER_HEIGHT, 0)

    local startPart = createMarkerPart(
        folder,
        "CP_" .. tostring(cpIndex) .. "_START",
        startGround,
        Color3.fromRGB(70, 255, 130),
        Vector3.new(CP_MARKER_SIZE, CP_MARKER_SIZE, CP_MARKER_SIZE),
        Enum.PartType.Ball
    )
    makeBillboardLabel(startPart, "CP " .. tostring(cpIndex) .. " START\n" .. cpName, Color3.fromRGB(70, 255, 130))

    local endPart = createMarkerPart(
        folder,
        "CP_" .. tostring(cpIndex) .. "_END",
        endGround,
        Color3.fromRGB(255, 95, 95),
        Vector3.new(CP_MARKER_SIZE, CP_MARKER_SIZE, CP_MARKER_SIZE),
        Enum.PartType.Ball
    )
    makeBillboardLabel(endPart, "CP " .. tostring(cpIndex) .. " END", Color3.fromRGB(255, 95, 95))

    local count = math.min(CP_MARKER_MAX_PER_CP, math.max(2, CP_MARKER_DOT_COUNT))
    for n = 1, count do
        local idx = math.floor(1 + ((#frames - 1) * (n - 1) / math.max(count - 1, 1)))
        local pos = getFramePosSafe(frames[idx])
        if pos then
            local dotPos = groundPositionForDot(pos) + Vector3.new(0, 0.2, 0)
            local dot = createMarkerPart(
                folder,
                "CP_" .. tostring(cpIndex) .. "_PATH_" .. tostring(n),
                dotPos,
                Color3.fromRGB(80, 170, 255),
                Vector3.new(CP_MARKER_SIZE * 0.62, CP_MARKER_SIZE * 0.62, CP_MARKER_SIZE * 0.62),
                Enum.PartType.Ball
            )
            if n == math.ceil(count / 2) then
                makeBillboardLabel(dot, "PATH CP " .. tostring(cpIndex), Color3.fromRGB(80, 170, 255))
            end
        end
    end
end

function refreshCheckpointMarkers()
    clearCheckpointMarkers()

    if not CP_MARKER_ENABLED then
        return
    end

    local selectedName = CP_MARKER_SELECTED_NAME and tostring(CP_MARKER_SELECTED_NAME) or nil
    local normal = {}

    for _, cp in ipairs(checkpoints or {}) do
        if cp and not cp.isMerged and type(cp.frames) == "table" and #cp.frames > 0 then
            local cpName = tostring(cp.name or "")
            if not selectedName or selectedName == "" or cpName == selectedName then
                table.insert(normal, cp)
            end
        end
    end

    if #normal <= 0 then
        return
    end

    table.sort(normal, function(a, b)
        return (a.order or 9999) < (b.order or 9999)
    end)

    for i, cp in ipairs(normal) do
        createCheckpointMarker(cp, i)
        --// Jangan render semua dalam 1 frame kalau jumlah CP banyak.
        if i % 2 == 0 then
            task.wait()
        end
    end

    startCheckpointMarkerDistanceCuller(workspace:FindFirstChild("ONIUM_CP_MARKERS"))
end

function updateCpMarkerToggleButton()
    if not cpMarkerToggleBtn then
        return
    end

    if CP_MARKER_ENABLED then
        if CP_MARKER_SELECTED_NAME then
            cpMarkerToggleBtn.Text = "CP 1"
        else
            cpMarkerToggleBtn.Text = "CP ON"
        end
        cpMarkerToggleBtn.BackgroundColor3 = Color3.fromRGB(55, 120, 80)
    else
        cpMarkerToggleBtn.Text = "CP OFF"
        cpMarkerToggleBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    end
end

function setCheckpointMarkerMode(enabled, selectedName, quiet)
    CP_MARKER_ENABLED = enabled == true

    if CP_MARKER_ENABLED then
        CP_MARKER_SELECTED_NAME = selectedName and tostring(selectedName) or nil
        task.defer(refreshCheckpointMarkers)
    else
        CP_MARKER_SELECTED_NAME = nil
        clearCheckpointMarkers()
    end

    updateCpMarkerToggleButton()

    if not quiet then
        if CP_MARKER_ENABLED then
            if CP_MARKER_SELECTED_NAME then
                notify("CP Marker", "ON hanya: " .. tostring(CP_MARKER_SELECTED_NAME), 2)
            else
                notify("CP Marker", "ON semua checkpoint", 2)
            end
        else
            notify("CP Marker", "OFF. Save jadi lebih ringan.", 2)
        end
    end
end

function toggleCheckpointMarkersAll()
    if CP_MARKER_ENABLED and not CP_MARKER_SELECTED_NAME then
        setCheckpointMarkerMode(false, nil, false)
    else
        setCheckpointMarkerMode(true, nil, false)
    end
end

function toggleSingleCheckpointMarker(cp)
    local name = tostring(cp and cp.name or "")
    if name == "" then
        return
    end

    if CP_MARKER_ENABLED and CP_MARKER_SELECTED_NAME == name then
        setCheckpointMarkerMode(false, nil, false)
    else
        setCheckpointMarkerMode(true, name, false)
    end
end

function countMergeDots()
    local folder = workspace:FindFirstChild("ONIUM_MERGE_DOTS")
    local count = 0

    if folder then
        for _, obj in ipairs(folder:GetChildren()) do
            if tostring(obj.Name):find("JOIN_DOT_CP_") then
                count = count + 1
            end
        end
    end

    return count
end

function smoothStep(a)
    a = math.clamp(a, 0, 1)
    return a * a * (3 - 2 * a)
end

function lerpAngle(a, b, t)
    local delta = b - a
    delta = math.atan(math.sin(delta), math.cos(delta))
    return a + delta * t
end
--// =========================================================
--// FIX NO SHIFT LOCK PLAYBACK
--// Kalau record tanpa shift lock, playback jangan paksa AutoRotate=false
--// =========================================================

function detectNoShiftLockRecord(hum, hrp)
    --// MOBILE-SAFE detection.
    --// Di mobile, MoveDirection selalu sejajar LookVector (thumbstick relatif kamera),
    --// jadi dot product TIDAK bisa dipakai -> dulu sering false-positive "no shift lock"
    --// yang menyebabkan bug jump/teleport saat Save -> Record lagi.
    if not hum or not hrp then
        return false
    end

    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer

    local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled and not UIS.KeyboardEnabled

    if isMobile then
        --// Cek apakah map memaksa shift lock / lock kamera.
        local mapLocks = false
        pcall(function()
            if lp and lp.DevEnableMouseLock then mapLocks = true end
            if hum.CameraOffset and hum.CameraOffset.Magnitude > 0.5 then mapLocks = true end
        end)
        --// Default mobile tanpa lock = autoRotate (no shift lock).
        --// Map yang lock kamera = anggap shift lock (return false).
        return not mapLocks
    end

    --// PC path: pakai logic lama (dot product).
    local moveDir = hum.MoveDirection
    if moveDir.Magnitude < 0.05 then
        return false
    end

    local look = hrp.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    local flatMove = Vector3.new(moveDir.X, 0, moveDir.Z)

    if flatLook.Magnitude < 0.05 or flatMove.Magnitude < 0.05 then
        return false
    end

    local dot = flatLook.Unit:Dot(flatMove.Unit)
    return dot > 0.72
end

function isNoShiftLockFrame(fr)
    if type(fr) ~= "table" then
        return false
    end

    return fr.noShiftLock == true
        or fr.rotationMode == "AutoRotate"
end

function framesUseNoShiftLock(frames)
    local total = 0
    local yes = 0

    for _, fr in ipairs(frames or {}) do
        if type(fr) == "table" then
            total = total + 1
            if isNoShiftLockFrame(fr) then
                yes = yes + 1
            end
        end
    end

    if total <= 0 then
        return false
    end

    return yes >= math.max(1, math.floor(total * 0.45))
end
--// =========================================================
--// FIX SHIFT LOCK ROTATION / ANTI FLIP
--// Jangan paksa badan muter ikut arah jalan saat merge.
--// Cocok untuk record shift lock: loncat kiri/kanan tapi badan tetap lurus.
--// =========================================================

local SHIFT_LOCK_ROTATION_FIX = true
local ROTATION_FLIP_LIMIT = math.rad(28)

function getAngleDelta(a, b)
    local d = (tonumber(b) or 0) - (tonumber(a) or 0)
    return math.atan(math.sin(d), math.cos(d))
end

function keepShiftLockRotation(previousFrame, newFrame)
    local prevYaw = tonumber(previousFrame and previousFrame.rotation)
    local newYaw = tonumber(newFrame and newFrame.rotation)

    if not SHIFT_LOCK_ROTATION_FIX then
        return newYaw or prevYaw or 0
    end

    if prevYaw and newYaw then
        local diff = math.abs(getAngleDelta(prevYaw, newYaw))

        -- Kalau tiba-tiba muter besar, anggap itu flip palsu dari merge.
        if diff > ROTATION_FLIP_LIMIT then
            return prevYaw
        end

        return newYaw
    end

    return newYaw or prevYaw or 0
end

--// =========================================================
--// Safe File API
--// =========================================================

function safeFunc(fn)
    return type(fn) == "function"
end

function ensureFolder()
    if safeFunc(isfolder) and safeFunc(makefolder) then
        local ok, exists = pcall(function()
            return isfolder(FOLDER_NAME)
        end)

        if ok and not exists then
            pcall(function()
                makefolder(FOLDER_NAME)
            end)
        elseif not ok then
            pcall(function()
                makefolder(FOLDER_NAME)
            end)
        end
    elseif safeFunc(makefolder) then
        pcall(funct... (205 KB left)

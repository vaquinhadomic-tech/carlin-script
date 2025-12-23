--====================================================
-- CARLIN HUB | Murder Mystery
--====================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--====================================================
-- WINDOW + KEY SYSTEM (BOTÃO VERDE GET KEY)
--====================================================
local Window = Rayfield:CreateWindow({
    Name = "Murder Mystery",
    LoadingTitle = "CARLIN HUB",
    LoadingSubtitle = "By CARLIN",
    ConfigurationSaving = {Enabled = false},
    Draggable = true,

    KeySystem = true,
    KeySettings = {
        Title = "CARLIN HUB",
        Subtitle = "By CARLIN",
        Note = "Clique em Get Key para continuar",
        FileName = "carlin_mm2_key_v2",
        SaveKey = true,

        GrabKeyFromSite = true,
        KeyLink = "https://link-hub.net/2522978/BpUM7NTn9gxm",

        -- 🔐 KEYS
        Key = {
            "Uhdkaklwa",
            "waoadlaw",
            "waodlmka",
            "waljnsakld",
            "wandlkas",
            "waionamrg",
            "piaefnmk",
            "carlinhub"
        }
    }
})

--====================================================
-- SERVICES
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local function Char()
    return LP.Character or LP.CharacterAdded:Wait()
end

--====================================================
-- FLAGS
--====================================================
local flyOn, noclipOn, tpClickOn = false, false, false
local ringOn, flingOn, orbitOn = false, false, false
local ringRadius = 10
local orbitTarget = nil

--====================================================
-- TABS
--====================================================
local MovementTab = Window:CreateTab("MOVEMENT", 4483362458)
local TrollTab = Window:CreateTab("TROLL", 4483362458)

--====================================================
-- MOVEMENT : FLY
--====================================================
local flyBV, flyBG

local function startFly()
    local hrp = Char():WaitForChild("HumanoidRootPart")
    flyBV = Instance.new("BodyVelocity", hrp)
    flyBG = Instance.new("BodyGyro", hrp)
    flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
    flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
end

local function stopFly()
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
end

MovementTab:CreateToggle({
    Name = "Fly",
    Callback = function(v)
        flyOn = v
        if v then startFly() else stopFly() end
    end
})

--====================================================
-- MOVEMENT : NOCLIP
--====================================================
MovementTab:CreateToggle({
    Name = "Noclip",
    Callback = function(v) noclipOn = v end
})

--====================================================
-- MOVEMENT : TP CLICK
--====================================================
MovementTab:CreateToggle({
    Name = "TP Click",
    Callback = function(v) tpClickOn = v end
})

Mouse.Button1Down:Connect(function()
    if tpClickOn and Mouse.Hit then
        Char():WaitForChild("HumanoidRootPart").CFrame = Mouse.Hit + Vector3.new(0,3,0)
    end
end)

--====================================================
-- TROLL : RING PARTS
--====================================================
TrollTab:CreateToggle({
    Name = "Ring Parts",
    Callback = function(v) ringOn = v end
})

TrollTab:CreateSlider({
    Name = "Ring Radius",
    Range = {5,30},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(v) ringRadius = v end
})

--====================================================
-- TROLL : FLING
--====================================================
TrollTab:CreateToggle({
    Name = "Fling (Auto Noclip)",
    Callback = function(v)
        flingOn = v
        noclipOn = v
    end
})

--====================================================
-- TROLL : ORBIT
--====================================================
local playerNames = {}
for _,p in pairs(Players:GetPlayers()) do
    table.insert(playerNames, p.Name)
end

TrollTab:CreateDropdown({
    Name = "Orbit Player",
    Options = playerNames,
    Callback = function(v)
        orbitTarget = Players:FindFirstChild(v)
    end
})

TrollTab:CreateToggle({
    Name = "Orbit (Speed 5 / Distance 5)",
    Callback = function(v) orbitOn = v end
})

--====================================================
-- MAIN LOOP
--====================================================
RunService.Heartbeat:Connect(function()
    local char = Char()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Fly
    if flyOn and flyBV and flyBG then
        flyBG.CFrame = workspace.CurrentCamera.CFrame
        flyBV.Velocity = char.Humanoid.MoveDirection * 60
    end

    -- Noclip
    if noclipOn then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    -- Ring Parts
    if ringOn then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored then
                v.CFrame = hrp.CFrame * CFrame.Angles(0, tick(), 0) * CFrame.new(ringRadius,0,0)
            end
        end
    end

    -- Fling
    if flingOn then
        hrp.AssemblyAngularVelocity = Vector3.new(0,9999,0)
    end

    -- Orbit
    if orbitOn and orbitTarget and orbitTarget.Character then
        local tHRP = orbitTarget.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            hrp.CFrame = tHRP.CFrame * CFrame.Angles(0, tick()*5, 0) * CFrame.new(5,0,0)
        end
    end
end)

Rayfield:Notify({
    Title = "CARLIN HUB",
    Content = "Script carregado com sucesso!",
    Duration = 4
})

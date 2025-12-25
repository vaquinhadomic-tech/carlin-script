--====================================================
-- CARLIN HUB | Murder Mystery 2
-- By CARLIN
--====================================================

pcall(function()

--====================================================
-- RAYFIELD
--====================================================
local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source"
))()

--====================================================
-- WINDOW + KEY SYSTEM
--====================================================
local Window = Rayfield:CreateWindow({
    Name = "Murder Mystery",
    LoadingTitle = "CARLIN HUB",
    LoadingSubtitle = "By CARLIN",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "CARLIN HUB",
        Subtitle = "Insira a Key",
        Note = "Clique em Get Key",
        FileName = "carlinhub_mm2",
        SaveKey = true,
        GrabKeyFromSite = true,
        KeyLink = "https://link-hub.net/2522978/BpUM7NTn9gxm",
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
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

local function Char()
    return LP.Character or LP.CharacterAdded:Wait()
end

--====================================================
-- MOVEMENT VARS
--====================================================
local infiniteJump = false

--====================================================
-- INFINITE JUMP
--====================================================
UIS.JumpRequest:Connect(function()
    if infiniteJump then
        local humanoid = Char():FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--====================================================
-- ROLE FUNCTIONS
--====================================================
local function hasKnife(p)
    return (p.Backpack and p.Backpack:FindFirstChild("Knife"))
        or (p.Character and p.Character:FindFirstChild("Knife"))
end

local function hasGun(p)
    return (p.Backpack and p.Backpack:FindFirstChild("Gun"))
        or (p.Character and p.Character:FindFirstChild("Gun"))
end

local function getRole(p)
    if hasKnife(p) then return "Murder" end
    if hasGun(p) then return "Sheriff" end
    return "Innocent"
end

local function getMurder()
    for _,p in pairs(Players:GetPlayers()) do
        if getRole(p) == "Murder" then return p end
    end
end

local function getSheriff()
    for _,p in pairs(Players:GetPlayers()) do
        if getRole(p) == "Sheriff" then return p end
    end
end

local function getGunDrop()
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name == "Gun" and v:FindFirstChild("Handle") then
            return v
        end
    end
end

--====================================================
-- ESP / CHAMS
--====================================================
local espPlayers = false
local espGun = false

local function clearESP(obj)
    local h = obj:FindFirstChild("CARLIN_ESP")
    if h then h:Destroy() end
end

local function applyESP(obj, color)
    if not obj or obj:FindFirstChild("CARLIN_ESP") then return end
    local h = Instance.new("Highlight")
    h.Name = "CARLIN_ESP"
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.35
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
end

--====================================================
-- TABS
--====================================================
local MoveTab    = Window:CreateTab("MOVEMENT", 4483362458)
local TrollTab   = Window:CreateTab("TROLL", 4483362458)
local InfoTab    = Window:CreateTab("CHAMS & INFO", 4483362458)
local MurderTab  = Window:CreateTab("MURDER", 4483362458)
local SheriffTab = Window:CreateTab("SHERIFF", 4483362458)
local InnocTab   = Window:CreateTab("INOCENTE", 4483362458)

--====================================================
-- MOVEMENT OPTIONS
--====================================================
MoveTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        infiniteJump = v
    end
})

--====================================================
-- INFO LABELS
--====================================================
local murderLabel  = InfoTab:CreateParagraph({Title="Murder:", Content="..."})
local sheriffLabel = InfoTab:CreateParagraph({Title="Sheriff:", Content="..."})
local gunLabel     = InfoTab:CreateParagraph({Title="Gun Drop:", Content="Não"})

--====================================================
-- CHAMS OPTIONS
--====================================================
InfoTab:CreateToggle({
    Name = "Chams Players",
    Callback = function(v) espPlayers = v end
})

InfoTab:CreateToggle({
    Name = "Chams Gun Drop",
    Callback = function(v) espGun = v end
})

--====================================================
-- MURDER OPTIONS
--====================================================
local murderKillAll = false
local murderKillGun = false

MurderTab:CreateToggle({
    Name = "Kill All",
    Callback = function(v) murderKillAll = v end
})

MurderTab:CreateToggle({
    Name = "Kill Sheriff / Hero",
    Callback = function(v) murderKillGun = v end
})

--====================================================
-- SHERIFF OPTIONS
--====================================================
local aimbotMurder = false
local runMurder = false

SheriffTab:CreateButton({
    Name = "Shoot Murder",
    Callback = function()
        if getRole(LP) ~= "Sheriff" then return end
        local m = getMurder()
        if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
            local gun = LP.Backpack:FindFirstChild("Gun") or Char():FindFirstChild("Gun")
            if gun then gun.Parent = Char() end
            Char().HumanoidRootPart.CFrame =
                CFrame.new(Char().HumanoidRootPart.Position, m.Character.HumanoidRootPart.Position)
            VIM:SendMouseButtonEvent(0,0,0,true,game,0)
            VIM:SendMouseButtonEvent(0,0,0,false,game,0)
        end
    end
})

SheriffTab:CreateToggle({
    Name = "Aimbot Murder",
    Callback = function(v) aimbotMurder = v end
})

SheriffTab:CreateToggle({
    Name = "Run from Murder",
    Callback = function(v) runMurder = v end
})

--====================================================
-- INOCENTE OPTIONS
--====================================================
local secondChance = false

InnocTab:CreateButton({
    Name = "Kill All (Fling)",
    Callback = function()
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character and p ~= LP then
                p.Character:BreakJoints()
            end
        end
    end
})

InnocTab:CreateButton({
    Name = "Kill Murder",
    Callback = function()
        local m = getMurder()
        if m and m.Character then
            m.Character:BreakJoints()
        end
    end
})

InnocTab:CreateToggle({
    Name = "Second Chance",
    Callback = function(v) secondChance = v end
})

--====================================================
-- MAIN LOOP
--====================================================
RunService.Heartbeat:Connect(function()
    local m = getMurder()
    local s = getSheriff()

    murderLabel:Set({Content = m and m.Name or "Desconhecido"})
    sheriffLabel:Set({Content = s and s.Name or "Nenhum"})
    gunLabel:Set({Content = getGunDrop() and "Sim" or "Não"})

    for _,p in pairs(Players:GetPlayers()) do
        if p.Character then
            clearESP(p.Character)
            if espPlayers then
                local r = getRole(p)
                if r == "Murder" then
                    applyESP(p.Character, Color3.fromRGB(255,0,0))
                elseif r == "Sheriff" then
                    applyESP(p.Character, Color3.fromRGB(0,170,255))
                else
                    applyESP(p.Character, Color3.fromRGB(0,255,0))
                end
            end
        end
    end

    local gun = getGunDrop()
    if gun and espGun then
        applyESP(gun, Color3.fromRGB(255,255,0))
    end

    if getRole(LP) == "Murder" then
        local char = Char()
        local knife = LP.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
        if knife then knife.Parent = char end

        if murderKillAll then
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame =
                        p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
                    task.wait(0.15)
                end
            end
        end

        if murderKillGun and s and s.Character then
            char.HumanoidRootPart.CFrame =
                s.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
        end
    end
end)

Rayfield:Notify({
    Title = "CARLIN HUB",
    Content = "Script carregado com sucesso!",
    Duration = 5
})

end)

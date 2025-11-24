local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local StarterGui = game:GetService("StarterGui")

local GREEN = Color3.fromRGB(0,255,0)

local character
if Player.Character then
    character = Player.Character
else
    character = Player.CharacterAdded:Wait()
end
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local originalSpeed = humanoid.WalkSpeed
local spawnCFrame = root.CFrame

local toggleStates = {
    ["Hitbox Bat"] = false,
    ["ESP Players"] = false,
    ["Instant Prompt"] = false,
    ["Noclip"] = false,
    ["Infinite Jump"] = false,
    ["Auto Steal"] = false,
    ["Insta-Interact"] = false,
    ["Auto Kick"] = false,
    ["Auto Sell"] = false,
    ["ESP Latamrot"] = true
}

local playerBaseNumber = nil
local stealingInProgress = false
local stealAllActive = false
local originalHoldDurations = {}
local originalCollisions = {}
local espEnabled = false
local highlights = {}
local noclipConn
local hitboxEnabled = false
local OriginalSizes = {}
local OriginalTransparencies = {}
local OriginalCanCollide = {}
local HITBOX_SIZE = 50
local infiniteJumpEnabled = false
local autoStealConn
local instaStealConn
local hitboxConnection

local latamrotPriority = {
    ["Niño Del Tianguis"] = 24,
    ["Westcol"] = 23,
    ["EL CHAVO BOSS"] = 22,
    ["Los bros combinasion"] = 21,
    ["CapitanPerusini"] = 20,
    ["SusFachero"] = 19,
    ["SusFacheroRojo"] = 18,
    ["Chancla"] = 17,
    ["SusFacheroAzul"] = 16,
    ["ComoTaMuchacho"] = 15,
    ["RaniniSapolsini"] = 14,
    ["Chacarroncini"] = 13,
    ["Pitersini"] = 12,
    ["AgentePe"] = 11,
    ["Peka"] = 10,
    ["oi oi oi"] = 9,
    ["PalominiPecausini"] = 8,
    ["PerroChillini"] = 7,
    ["Gustambo"] = 6,
    ["Hollman"] = 5,
    ["Lopes"] = 4,
    ["Knacklesini"] = 3,
    ["Apple"] = 2,
    ["Chamini"] = 1
}

_G.TurtleXFerData = {
    Players = Players,
    Player = Player,
    PlayerGui = PlayerGui,
    UIS = UIS,
    RunService = RunService,
    ProximityPromptService = ProximityPromptService,
    StarterGui = StarterGui,
    GREEN = GREEN,
    character = character,
    humanoid = humanoid,
    root = root,
    originalSpeed = originalSpeed,
    spawnCFrame = spawnCFrame,
    toggleStates = toggleStates,
    playerBaseNumber = playerBaseNumber,
    stealingInProgress = stealingInProgress,
    stealAllActive = stealAllActive,
    originalHoldDurations = originalHoldDurations,
    originalCollisions = originalCollisions,
    espEnabled = espEnabled,
    highlights = highlights,
    noclipConn = noclipConn,
    hitboxEnabled = hitboxEnabled,
    OriginalSizes = OriginalSizes,
    OriginalTransparencies = OriginalTransparencies,
    OriginalCanCollide = OriginalCanCollide,
    HITBOX_SIZE = HITBOX_SIZE,
    infiniteJumpEnabled = infiniteJumpEnabled,
    autoStealConn = autoStealConn,
    instaStealConn = instaStealConn,
    hitboxConnection = hitboxConnection,
    latamrotPriority = latamrotPriority
}

local function clearChildren(parent)
    for _,c in ipairs(parent:GetChildren()) do
        if not (c:IsA("UIListLayout") or c:IsA("UIPadding") or c:IsA("UICorner")) then
            c:Destroy()
        end
    end
end

local function applyHitbox()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if _G.TurtleXFerData.hitboxEnabled then
                hrp.Size = Vector3.new(25,25,25)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Bright red")
                hrp.Material = Enum.Material.SmoothPlastic
            else
                hrp.Size = Vector3.new(2,2,1)
                hrp.Transparency = 0
                hrp.BrickColor = BrickColor.new("Medium stone grey")
                hrp.Material = Enum.Material.Plastic
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if _G.TurtleXFerData.hitboxEnabled then
            applyHitbox()
        end
    end)
end)

local function removeESP()
    for char, hl in pairs(_G.TurtleXFerData.highlights) do
        if hl and hl.Parent then
            hl:Destroy()
        end
    end
    _G.TurtleXFerData.highlights = {}
end

local function createESPForCharacter(char)
    if not _G.TurtleXFerData.espEnabled then return end
    if _G.TurtleXFerData.highlights[char] then return end

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.FillColor = Color3.fromRGB(255,0,0)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 1
    hl.Parent = char
    _G.TurtleXFerData.highlights[char] = hl
end

local function applyESP()
    removeESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            createESPForCharacter(plr.Character)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if _G.TurtleXFerData.espEnabled then
            createESPForCharacter(plr.Character)
        end
    end)
end)

local function setInstantPrompts(enable)
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if not _G.TurtleXFerData.originalHoldDurations[obj] then
                _G.TurtleXFerData.originalHoldDurations[obj] = obj.HoldDuration
            end
            obj.HoldDuration = enable and 0 or _G.TurtleXFerData.originalHoldDurations[obj]
        end
    end
end

game.Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") and toggleStates["Instant Prompt"] then
        if not _G.TurtleXFerData.originalHoldDurations[obj] then
            _G.TurtleXFerData.originalHoldDurations[obj] = obj.HoldDuration
        end
        obj.HoldDuration = 0
    end
end)

_G.TurtleXFerData.clearChildren = clearChildren
_G.TurtleXFerData.applyHitbox = applyHitbox
_G.TurtleXFerData.removeESP = removeESP
_G.TurtleXFerData.createESPForCharacter = createESPForCharacter
_G.TurtleXFerData.applyESP = applyESP
_G.TurtleXFerData.setInstantPrompts = setInstantPrompts
local data = _G.TurtleXFerData
local Players = data.Players
local Player = data.Player

local function getPlayerBaseNumber()
    if data.playerBaseNumber then return data.playerBaseNumber end
    
    local bases = workspace:FindFirstChild("Base")
    if not bases then return nil end
    
    for i = 1, 20 do
        local base = bases:FindFirstChild("Base" .. i)
        if base then
            local banner = base:FindFirstChild("Banner")
            if banner then
                local nameObj = banner:FindFirstChild("Name_")
                if nameObj then
                    local surfaceGui = nameObj:FindFirstChild("SurfaceGui")
                    if surfaceGui then
                        local textLabel = surfaceGui:FindFirstChild("TextLabel")
                        if textLabel and (textLabel.Text == Player.Name or textLabel.Text == Player.DisplayName) then
                            data.playerBaseNumber = i
                            return i
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

local function findBestLatamrot()
    local bestLatamrot = nil
    local highestPriority = 0
    
    local bases = workspace:FindFirstChild("Base")
    if not bases then return nil end
    
    local myBase = getPlayerBaseNumber()
    
    for i = 1, 20 do
        if i ~= myBase then
            local base = bases:FindFirstChild("Base" .. i)
            if base then
                local characters = base:FindFirstChild("Characters")
                if characters then
                    for _, obj in ipairs(characters:GetChildren()) do
                        if obj:IsA("Model") and data.latamrotPriority[obj.Name] then
                            if data.latamrotPriority[obj.Name] > highestPriority then
                                highestPriority = data.latamrotPriority[obj.Name]
                                bestLatamrot = obj
                            end
                        end
                    end
                end
            end
        end
    end
    
    return bestLatamrot
end

local function findAllLatamrots()
    local latamrots = {}
    
    local bases = workspace:FindFirstChild("Base")
    if not bases then return latamrots end
    
    local myBase = getPlayerBaseNumber()
    
    for i = 1, 20 do
        if i ~= myBase then
            local base = bases:FindFirstChild("Base" .. i)
            if base then
                local characters = base:FindFirstChild("Characters")
                if characters then
                    for _, obj in ipairs(characters:GetChildren()) do
                        if obj:IsA("Model") and data.latamrotPriority[obj.Name] then
                            table.insert(latamrots, {
                                model = obj,
                                priority = data.latamrotPriority[obj.Name],
                                name = obj.Name
                            })
                        end
                    end
                end
            end
        end
    end
    
    table.sort(latamrots, function(a, b)
        return a.priority > b.priority
    end)
    
    return latamrots
end

local function findProximityPrompt(latamrot)
    if not latamrot then return nil end
    
    local hrp = latamrot:FindFirstChild("HumanoidRootPart")
    if hrp then
        local prompt = hrp:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            return prompt
        end
    end
    
    for _, part in ipairs(latamrot:GetDescendants()) do
        if part:IsA("ProximityPrompt") then
            return part
        end
    end
    
    return nil
end

local function removeLatamrotESP()
    local bases = workspace:FindFirstChild("Base")
    if not bases then return end
    
    for i = 1, 20 do
        local base = bases:FindFirstChild("Base" .. i)
        if base then
            local characters = base:FindFirstChild("Characters")
            if characters then
                for _, obj in ipairs(characters:GetChildren()) do
                    if obj:IsA("Model") then
                        for _, part in ipairs(obj:GetDescendants()) do
                            if part:IsA("BasePart") then
                                local esp = part:FindFirstChild("DZ_LATAMROT_ESP")
                                local label = part:FindFirstChild("DZ_LATAMROT_LABEL")
                                if esp then esp:Destroy() end
                                if label then label:Destroy() end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function updateLatamrotESP()
    if not data.toggleStates["ESP Latamrot"] then return end
    
    removeLatamrotESP()
    
    local bestLatamrot = findBestLatamrot()
    if bestLatamrot then
        local primaryPart = bestLatamrot.PrimaryPart or bestLatamrot:FindFirstChildWhichIsA("BasePart")
        if primaryPart then
            local highlight = Instance.new("Highlight")
            highlight.Name = "DZ_LATAMROT_ESP"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            highlight.FillTransparency = 0.2
            highlight.OutlineTransparency = 0
            highlight.Parent = primaryPart
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "DZ_LATAMROT_LABEL"
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.new(0, 200, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 4, 0)
            billboard.Adornee = primaryPart
            billboard.Parent = primaryPart

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "MEJOR: " .. bestLatamrot.Name
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.TextStrokeTransparency = 0
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.Parent = billboard
        end
    end
end

local function sellLatamrotsInBase()
    local myBase = getPlayerBaseNumber()
    if not myBase then return end
    
    local bases = workspace:FindFirstChild("Base")
    if not bases then return end
    
    local base = bases:FindFirstChild("Base" .. myBase)
    if not base then return end
    
    local characters = base:FindFirstChild("Characters")
    if not characters then return end
    
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, obj in ipairs(characters:GetChildren()) do
        if obj:IsA("Model") and data.latamrotPriority[obj.Name] then
            local prompt = findProximityPrompt(obj)
            if prompt then
                local targetPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.1)
                    
                    prompt.MaxActivationDistance = 100
                    prompt.RequiresLineOfSight = false
                    prompt.HoldDuration = 0
                    task.wait(0.05)
                    
                    prompt:InputHoldBegin()
                    task.wait(0.05)
                    prompt:InputHoldEnd()
                    task.wait(0.1)
                end
            end
        end
    end
    
    if data.spawnCFrame then
        hrp.CFrame = data.spawnCFrame
    end
end

_G.TurtleXFerData.getPlayerBaseNumber = getPlayerBaseNumber
_G.TurtleXFerData.findBestLatamrot = findBestLatamrot
_G.TurtleXFerData.findAllLatamrots = findAllLatamrots
_G.TurtleXFerData.findProximityPrompt = findProximityPrompt
_G.TurtleXFerData.removeLatamrotESP = removeLatamrotESP
_G.TurtleXFerData.updateLatamrotESP = updateLatamrotESP
_G.TurtleXFerData.sellLatamrotsInBase = sellLatamrotsInBase
local data = _G.TurtleXFerData
local Players = data.Players
local Player = data.Player
local PlayerGui = data.PlayerGui
local UIS = data.UIS
local RunService = data.RunService
local ProximityPromptService = data.ProximityPromptService
local GREEN = data.GREEN
local toggleStates = data.toggleStates
local latamrotPriority = data.latamrotPriority

local gui = Instance.new("ScreenGui")
gui.Name = "TurtleHubMain"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = PlayerGui

local abrirBtn = Instance.new("TextButton")
abrirBtn.Name = "OpenButton"
abrirBtn.Size = UDim2.new(0, 60, 0, 60)
abrirBtn.Position = UDim2.new(0, 20, 0.5, -30)
abrirBtn.BackgroundColor3 = Color3.fromRGB(20,20,25)
abrirBtn.BorderSizePixel = 0
abrirBtn.ZIndex = 100
abrirBtn.Text = "T"
abrirBtn.Font = Enum.Font.GothamBold
abrirBtn.TextScaled = true
abrirBtn.TextColor3 = Color3.fromRGB(240,240,250)
abrirBtn.Parent = gui

local abrirCorner = Instance.new("UICorner", abrirBtn)
abrirCorner.CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Color = GREEN
stroke.Thickness = 2
stroke.Transparency = 0.1
stroke.Parent = abrirBtn

local menuFrame = Instance.new("Frame")
menuFrame.Name = "MainMenu"
menuFrame.Size = UDim2.new(0, 420, 0, 500)
menuFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
menuFrame.BackgroundColor3 = Color3.fromRGB(18,18,20)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.ZIndex = 50
menuFrame.Parent = gui
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0,12)

local outerStroke = Instance.new("UIStroke")
outerStroke.Color = GREEN
outerStroke.Thickness = 3
outerStroke.Transparency = 0.1
outerStroke.Parent = menuFrame

local inner = Instance.new("Frame")
inner.Name = "Inner"
inner.Size = UDim2.new(1, -12, 1, -12)
inner.Position = UDim2.new(0,6,0,6)
inner.BackgroundColor3 = Color3.fromRGB(28,28,33)
inner.BorderSizePixel = 0
inner.ZIndex = 51
inner.Parent = menuFrame
Instance.new("UICorner", inner).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel")
title.Text = "TurtleHub x xFer Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220,220,230)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 10)
title.Size = UDim2.new(0.8, 0, 0, 28)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 52
title.Parent = inner

local subt = Instance.new("TextLabel")
subt.Text = "Collab Edition"
subt.Font = Enum.Font.Gotham
subt.TextSize = 12
subt.TextColor3 = Color3.fromRGB(140,140,150)
subt.BackgroundTransparency = 1
subt.Position = UDim2.new(0, 10, 0, 36)
subt.Size = UDim2.new(0.7, 0, 0, 18)
subt.TextXAlignment = Enum.TextXAlignment.Left
subt.ZIndex = 52
subt.Parent = inner

local tabs = Instance.new("Frame")
tabs.Name = "TabsHolder"
tabs.Size = UDim2.new(0.95,0,0,36)
tabs.Position = UDim2.new(0.5,0,0,60)
tabs.AnchorPoint = Vector2.new(0.5,0)
tabs.BackgroundTransparency = 1
tabs.ZIndex = 52
tabs.Parent = inner

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0,8)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabs

local function createTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,120,1,0)
    b.BackgroundColor3 = Color3.fromRGB(38,38,44)
    b.AutoButtonColor = false
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(220,220,230)
    b.ZIndex = 53
    b.Parent = tabs
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(25,25,30)
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = b
    return b
end

local tabMain = createTab("Main")
local tabSteal = createTab("Steal")
local tabCombat = createTab("Combat")

local contentHolder = Instance.new("Frame")
contentHolder.Name = "ContentHolder"
contentHolder.Size = UDim2.new(1, -12, 1, -110)
contentHolder.Position = UDim2.new(0,6,0,100)
contentHolder.BackgroundTransparency = 1
contentHolder.ZIndex = 51
contentHolder.Parent = inner

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Name = "ContentScroll"
contentScroll.Parent = contentHolder
contentScroll.Size = UDim2.new(1,0,1,0)
contentScroll.CanvasSize = UDim2.new(0,0,0,0)
contentScroll.ScrollBarThickness = 8
contentScroll.BackgroundTransparency = 1
contentScroll.Active = true
contentScroll.ScrollBarImageTransparency = 0.4
contentScroll.ZIndex = 52

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentScroll
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0,8)

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0,0,0, contentLayout.AbsoluteContentSize.Y + 16)
end)

local function createFloatingButton(parent, text, color, position)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 130, 0, 40)
    btn.Position = position
    btn.Visible = false
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 100
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2
    stroke.Color = GREEN
    
    return btn
end

local SpeedFloat = createFloatingButton(gui, "Speed: OFF", Color3.fromRGB(60, 60, 60), UDim2.new(1, -145, 0, 15))
local TpBaseFloat = createFloatingButton(gui, "🏠 TP Base", Color3.fromRGB(0, 100, 200), UDim2.new(1, -145, 0, 65))
local TpForwardFloat = createFloatingButton(gui, "➡️ TP Adelante", Color3.fromRGB(100, 0, 200), UDim2.new(1, -145, 0, 115))
local StealBestFloat = createFloatingButton(gui, "💎 Steal Best", Color3.fromRGB(200, 50, 50), UDim2.new(1, -145, 0, 165))
local StealAllFloat = createFloatingButton(gui, "🔥 Steal All: OFF", Color3.fromRGB(150, 50, 150), UDim2.new(1, -145, 0, 215))

_G.TurtleXFerData.gui = gui
_G.TurtleXFerData.abrirBtn = abrirBtn
_G.TurtleXFerData.menuFrame = menuFrame
_G.TurtleXFerData.contentScroll = contentScroll
_G.TurtleXFerData.tabs = tabs
_G.TurtleXFerData.tabMain = tabMain
_G.TurtleXFerData.tabSteal = tabSteal
_G.TurtleXFerData.tabCombat = tabCombat
_G.TurtleXFerData.SpeedFloat = SpeedFloat
_G.TurtleXFerData.TpBaseFloat = TpBaseFloat
_G.TurtleXFerData.TpForwardFloat = TpForwardFloat
_G.TurtleXFerData.StealBestFloat = StealBestFloat
_G.TurtleXFerData.StealAllFloat = StealAllFloat

local function makeOptionRow(text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -12, 0, 46)
    row.BackgroundColor3 = Color3.fromRGB(26,26,30)
    row.BorderSizePixel = 0
    row.ZIndex = 52
    row.Parent = contentScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = row
    lbl.Text = text
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextColor3 = Color3.fromRGB(210,210,220)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 53

    local toggle = Instance.new("TextButton")
    toggle.Parent = row
    toggle.Size = UDim2.new(0, 70, 0, 28)
    toggle.Position = UDim2.new(1, -80, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(40,40,45)
    toggle.Font = Enum.Font.Gotham
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(200,200,200)
    toggle.TextSize = 14
    toggle.ZIndex = 53
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,6)

    if toggleStates[text] then
        toggle.Text = "ON"
        toggle.BackgroundColor3 = GREEN
        toggle.TextColor3 = Color3.fromRGB(20,20,20)
    end

    toggle.MouseButton1Click:Connect(function()
        toggleStates[text] = not toggleStates[text]
        local on = toggleStates[text]
        toggle.Text = on and "ON" or "OFF"
        toggle.BackgroundColor3 = on and GREEN or Color3.fromRGB(40,40,45)
        toggle.TextColor3 = on and Color3.fromRGB(20,20,20) or Color3.fromRGB(200,200,200)

        if text == "Hitbox Bat" then
            _G.TurtleXFerData.hitboxEnabled = on
            if _G.TurtleXFerData.hitboxConnection then
                _G.TurtleXFerData.hitboxConnection:Disconnect()
                _G.TurtleXFerData.hitboxConnection = nil
            end
            
            if _G.TurtleXFerData.hitboxEnabled then
                data.applyHitbox()
                
                _G.TurtleXFerData.hitboxConnection = RunService.Heartbeat:Connect(function()
                    if _G.TurtleXFerData.hitboxEnabled then
                        for _, targetPlayer in pairs(Players:GetPlayers()) do
                            if targetPlayer ~= Player and targetPlayer.Character then
                                data.applyHitbox()
                            end
                        end
                    end
                end)
            else
                for _, targetPlayer in pairs(Players:GetPlayers()) do
                    if targetPlayer ~= Player and targetPlayer.Character then
                        data.applyHitbox()
                    end
                end
            end
        elseif text == "ESP Players" then
            _G.TurtleXFerData.espEnabled = on
            if _G.TurtleXFerData.espEnabled then
                data.applyESP()
            else
                data.removeESP()
            end
        elseif text == "Instant Prompt" then
            data.setInstantPrompts(on)
        elseif text == "Noclip" then
            if _G.TurtleXFerData.noclipConn then _G.TurtleXFerData.noclipConn:Disconnect() _G.TurtleXFerData.noclipConn = nil end
            
            if on then
                if data.character then
                    _G.TurtleXFerData.originalCollisions = {}
                    for _, part in pairs(data.character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            _G.TurtleXFerData.originalCollisions[part] = part.CanCollide 
                            part.CanCollide = false
                        end
                    end
                end
                
                _G.TurtleXFerData.noclipConn = RunService.Stepped:Connect(function()
                    if data.character then
                        for _, part in pairs(data.character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if data.character then
                    for part, originalState in pairs(_G.TurtleXFerData.originalCollisions) do
                        if part and part.Parent then
                            part.CanCollide = originalState 
                        end
                    end
                    
                    local partsToRestore = data.character:GetChildren()
                    for _, part in ipairs(partsToRestore) do
                        if part:IsA("BasePart") then
                            if part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = true
                            end
                        end
                    end
                end
                _G.TurtleXFerData.originalCollisions = {} 
            end
        elseif text == "Infinite Jump" then
            _G.TurtleXFerData.infiniteJumpEnabled = on
        elseif text == "Auto Steal" then
            if _G.TurtleXFerData.autoStealConn then _G.TurtleXFerData.autoStealConn:Disconnect() _G.TurtleXFerData.autoStealConn = nil end

            if on then
                _G.TurtleXFerData.autoStealConn = ProximityPromptService.PromptTriggered:Connect(function(prompt, p)
                    if p == Player then
                        _G.TurtleXFerData.root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                        
                        if _G.TurtleXFerData.root and _G.TurtleXFerData.spawnCFrame then
                            _G.TurtleXFerData.root.CFrame = _G.TurtleXFerData.spawnCFrame
                            
                            if toggleStates["Auto Kick"] then
                                local latamrotName = "Objeto"
                                local parent = prompt.Parent
                                while parent do
                                    if latamrotPriority[parent.Name] then
                                        latamrotName = parent.Name
                                        break
                                    end
                                    parent = parent.Parent
                                end
                                
                                task.spawn(function()
                                    task.wait(0.7)
                                    Player:Kick("Has robado con éxito: " .. latamrotName)
                                end)
                            end
                        end
                    end
                end)
            end
        elseif text == "Insta-Interact" then
            if _G.TurtleXFerData.instaStealConn then _G.TurtleXFerData.instaStealConn:Disconnect() _G.TurtleXFerData.instaStealConn = nil end

            if on then
                _G.TurtleXFerData.instaStealConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                    if not _G.TurtleXFerData.originalHoldDurations[prompt] then
                        _G.TurtleXFerData.originalHoldDurations[prompt] = prompt.HoldDuration
                    end
                    prompt.HoldDuration = 0 
                end)
            else
                for prompt, duration in pairs(_G.TurtleXFerData.originalHoldDurations) do
                    if prompt and prompt.Parent then
                        prompt.HoldDuration = duration
                    end
                end
                _G.TurtleXFerData.originalHoldDurations = {}
            end
        elseif text == "ESP Latamrot" then
            if on then
                task.spawn(function()
                    if _G.TurtleXFerData.updateLatamrotESP then
                        _G.TurtleXFerData.updateLatamrotESP()
                    end
                end)
            else
                if _G.TurtleXFerData.removeLatamrotESP then
                    _G.TurtleXFerData.removeLatamrotESP()
                end
            end
        end
    end)

    return row
end

local function makeTextBoxRow(text, defaultValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -12, 0, 46)
    row.BackgroundColor3 = Color3.fromRGB(26,26,30)
    row.BorderSizePixel = 0
    row.ZIndex = 52
    row.Parent = contentScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = row
    lbl.Text = text
    lbl.Size = UDim2.new(0.5, -10, 1, 0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextColor3 = Color3.fromRGB(210,210,220)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 53

    local box = Instance.new("TextBox")
    box.Parent = row
    box.Size = UDim2.new(0.4, 0, 0, 28)
    box.Position = UDim2.new(0.58, 0, 0.5, -14)
    box.BackgroundColor3 = Color3.fromRGB(35,35,40)
    box.Font = Enum.Font.Gotham
    box.Text = defaultValue
    box.TextColor3 = Color3.fromRGB(200,200,200)
    box.TextSize = 14
    box.ZIndex = 53
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

    return row, box
end

local function makeToggleButtonRow(text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -12, 0, 46)
    row.BackgroundColor3 = Color3.fromRGB(26,26,30)
    row.BorderSizePixel = 0
    row.ZIndex = 52
    row.Parent = contentScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local btn = Instance.new("TextButton")
    btn.Parent = row
    btn.Size = UDim2.new(1, -20, 1, -12)
    btn.Position = UDim2.new(0,10,0,6)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.TextSize = 14
    btn.ZIndex = 53
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    return row, btn
end

_G.TurtleXFerData.makeOptionRow = makeOptionRow
_G.TurtleXFerData.makeTextBoxRow = makeTextBoxRow
_G.TurtleXFerData.makeToggleButtonRow = makeToggleButtonRow
local data = _G.TurtleXFerData
local Players = data.Players
local Player = data.Player
local UIS = data.UIS
local RunService = data.RunService
local StarterGui = data.StarterGui
local toggleStates = data.toggleStates
local abrirBtn = data.abrirBtn
local menuFrame = data.menuFrame
local contentScroll = data.contentScroll
local tabs = data.tabs
local tabMain = data.tabMain
local tabSteal = data.tabSteal
local tabCombat = data.tabCombat
local SpeedFloat = data.SpeedFloat
local TpBaseFloat = data.TpBaseFloat
local TpForwardFloat = data.TpForwardFloat
local StealBestFloat = data.StealBestFloat
local StealAllFloat = data.StealAllFloat
local makeOptionRow = data.makeOptionRow
local makeTextBoxRow = data.makeTextBoxRow
local makeToggleButtonRow = data.makeToggleButtonRow
local clearChildren = data.clearChildren

local speedValue = data.originalSpeed
local tpForwardValue = 10

local function populateTab(tabName)
    clearChildren(contentScroll)

    if tabName == "Main" then
        makeOptionRow("ESP Players")
        makeOptionRow("Noclip")
        makeOptionRow("Infinite Jump")
        
        local speedRow, speedBox = makeTextBoxRow("Speed Value", tostring(data.originalSpeed))
        speedBox.FocusLost:Connect(function()
            local num = tonumber(speedBox.Text)
            if num and num >= 16 then
                speedValue = num
            end
        end)
        
        local showSpeedRow, showSpeedBtn = makeToggleButtonRow("👁️ Mostrar Speed")
        showSpeedBtn.MouseButton1Click:Connect(function()
            SpeedFloat.Visible = not SpeedFloat.Visible
            showSpeedBtn.Text = SpeedFloat.Visible and "👁️ Ocultar Speed" or "👁️ Mostrar Speed"
        end)
        
        local showTpBaseRow, showTpBaseBtn = makeToggleButtonRow("👁️ Mostrar TP Base")
        showTpBaseBtn.MouseButton1Click:Connect(function()
            TpBaseFloat.Visible = not TpBaseFloat.Visible
            showTpBaseBtn.Text = TpBaseFloat.Visible and "👁️ Ocultar TP Base" or "👁️ Mostrar TP Base"
        end)
        
        local tpForwardRow, tpForwardBox = makeTextBoxRow("TP Forward Studs", "10")
        tpForwardBox.FocusLost:Connect(function()
            local num = tonumber(tpForwardBox.Text)
            if num then
                tpForwardValue = num
            end
        end)
        
        local showTpForwardRow, showTpForwardBtn = makeToggleButtonRow("👁️ Mostrar TP Adelante")
        showTpForwardBtn.MouseButton1Click:Connect(function()
            TpForwardFloat.Visible = not TpForwardFloat.Visible
            showTpForwardBtn.Text = TpForwardFloat.Visible and "👁️ Ocultar TP Adelante" or "👁️ Mostrar TP Adelante"
        end)
        
    elseif tabName == "Steal" then
        makeOptionRow("Instant Prompt")
        makeOptionRow("Auto Steal")
        makeOptionRow("Insta-Interact")
        makeOptionRow("Auto Kick")
        makeOptionRow("Auto Sell")
        makeOptionRow("ESP Latamrot")
        
        local showBestRow, showBestBtn = makeToggleButtonRow("👁️ Mostrar Steal Best")
        showBestBtn.MouseButton1Click:Connect(function()
            StealBestFloat.Visible = not StealBestFloat.Visible
            showBestBtn.Text = StealBestFloat.Visible and "👁️ Ocultar Steal Best" or "👁️ Mostrar Steal Best"
        end)
        
        local showAllRow, showAllBtn = makeToggleButtonRow("👁️ Mostrar Steal All")
        showAllBtn.MouseButton1Click:Connect(function()
            StealAllFloat.Visible = not StealAllFloat.Visible
            showAllBtn.Text = StealAllFloat.Visible and "👁️ Ocultar Steal All" or "👁️ Mostrar Steal All"
        end)
        
    elseif tabName == "Combat" then
        makeOptionRow("Hitbox Bat")
    end
end

populateTab("Main")

local function setActiveTab(activeBtn)
    for _,btn in ipairs(tabs:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = (btn == activeBtn) and Color3.fromRGB(48,48,52) or Color3.fromRGB(38,38,44)
        end
    end
end

setActiveTab(tabMain)
tabMain.MouseButton1Click:Connect(function()
    setActiveTab(tabMain)
    populateTab("Main")
end)
tabSteal.MouseButton1Click:Connect(function()
    setActiveTab(tabSteal)
    populateTab("Steal")
end)
tabCombat.MouseButton1Click:Connect(function()
    setActiveTab(tabCombat)
    populateTab("Combat")
end)

abrirBtn.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

SpeedFloat.MouseButton1Click:Connect(function()
    local speedEnabled = SpeedFloat.Text:match("ON")
    
    if not speedEnabled then
        data.humanoid.WalkSpeed = speedValue
        SpeedFloat.Text = "Speed: ON ("..speedValue..")"
        SpeedFloat.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
    else
        data.humanoid.WalkSpeed = data.originalSpeed
        SpeedFloat.Text = "Speed: OFF"
        SpeedFloat.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

TpBaseFloat.MouseButton1Click:Connect(function()
    if data.root then
        data.root.CFrame = data.spawnCFrame
    end
end)

TpForwardFloat.MouseButton1Click:Connect(function()
    if data.root then
        local lookVector = data.root.CFrame.LookVector
        data.root.CFrame = data.root.CFrame + lookVector * tpForwardValue
    end
end)

StealBestFloat.MouseButton1Click:Connect(function()
    if data.stealingInProgress then return end
    _G.TurtleXFerData.stealingInProgress = true
    
    StealBestFloat.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    StealBestFloat.Text = "Robando..."
    
    task.spawn(function()
        local bestLatamrot = _G.TurtleXFerData.findBestLatamrot()
        if not bestLatamrot then
            StealBestFloat.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            StealBestFloat.Text = "💎 Steal Best"
            _G.TurtleXFerData.stealingInProgress = false
            return
        end
        
        local targetPart = bestLatamrot:FindFirstChild("HumanoidRootPart") or bestLatamrot.PrimaryPart or bestLatamrot:FindFirstChildWhichIsA("BasePart")
        if not targetPart then
            StealBestFloat.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            StealBestFloat.Text = "💎 Steal Best"
            _G.TurtleXFerData.stealingInProgress = false
            return
        end
        
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            StealBestFloat.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            StealBestFloat.Text = "💎 Steal Best"
            _G.TurtleXFerData.stealingInProgress = false
            return
        end
        
        hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.2)
        
        local prompt = _G.TurtleXFerData.findProximityPrompt(bestLatamrot)
        if prompt then
            prompt.MaxActivationDistance = 100
            prompt.RequiresLineOfSight = false
            prompt.HoldDuration = 0
            task.wait(0.05)
            
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
            
            task.wait(0.15)
            
            if hrp and data.spawnCFrame then
                hrp.CFrame = data.spawnCFrame
            end
        end
        
        StealBestFloat.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StealBestFloat.Text = "💎 Steal Best"
        _G.TurtleXFerData.stealingInProgress = false
    end)
end)

StealAllFloat.MouseButton1Click:Connect(function()
    _G.TurtleXFerData.stealAllActive = not _G.TurtleXFerData.stealAllActive
    
    if _G.TurtleXFerData.stealAllActive then
        StealAllFloat.Text = "🔥 Steal All: ON"
        StealAllFloat.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        
        task.spawn(function()
            local stolen = 0
            
            while _G.TurtleXFerData.stealAllActive do
                local latamrots = _G.TurtleXFerData.findAllLatamrots()
                
                if #latamrots == 0 then
                    task.wait(1)
                else
                    for _, latamrotData in ipairs(latamrots) do
                        if not _G.TurtleXFerData.stealAllActive then break end
                        
                        local latamrot = latamrotData.model
                        if latamrot and latamrot.Parent then
                            local targetPart = latamrot:FindFirstChild("HumanoidRootPart") or latamrot.PrimaryPart or latamrot:FindFirstChildWhichIsA("BasePart")
                            if targetPart then
                                local char = Player.Character
                                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                
                                if hrp then
                                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                                    task.wait(0.2)
                                    
                                    local prompt = _G.TurtleXFerData.findProximityPrompt(latamrot)
                                    if prompt then
                                        prompt.MaxActivationDistance = 100
                                        prompt.RequiresLineOfSight = false
                                        prompt.HoldDuration = 0
                                        task.wait(0.05)
                                        
                                        prompt:InputHoldBegin()
                                        task.wait(0.05)
                                        prompt:InputHoldEnd()
                                        
                                        task.wait(0.15)
                                        
                                        if data.spawnCFrame then
                                            hrp.CFrame = data.spawnCFrame
                                            task.wait(0.2)
                                        end
                                        
                                        stolen = stolen + 1
                                        
                                        if stolen % 10 == 0 and toggleStates["Auto Sell"] then
                                            _G.TurtleXFerData.sellLatamrotsInBase()
                                            task.wait(0.5)
                                        end
                                    end
                                end
                            end
                        end
                        
                        task.wait(0.2)
                    end
                    
                    task.wait(0.5)
                end
            end
            
            local char = Player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and data.spawnCFrame then
                hrp.CFrame = data.spawnCFrame
            end
        end)
    else
        StealAllFloat.Text = "🔥 Steal All: OFF"
        StealAllFloat.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
    end
end)

local function makeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = UIS:GetMouseLocation()
            startPos = frame.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = UIS:GetMouseLocation() - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(abrirBtn)
makeDraggable(menuFrame)

UIS.JumpRequest:Connect(function()
    local chr = Player.Character
    local hum = chr and chr:FindFirstChildOfClass("Humanoid")
    if hum and _G.TurtleXFerData.infiniteJumpEnabled then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Player.CharacterAdded:Connect(function(char)
    _G.TurtleXFerData.character = char
    _G.TurtleXFerData.humanoid = char:WaitForChild("Humanoid")
    _G.TurtleXFerData.root = char:WaitForChild("HumanoidRootPart")
    
    wait(0.1)
    _G.TurtleXFerData.spawnCFrame = _G.TurtleXFerData.root.CFrame
    _G.TurtleXFerData.originalSpeed = _G.TurtleXFerData.humanoid.WalkSpeed
end)

RunService.Heartbeat:Connect(function()
    if SpeedFloat.Text:match("ON") and data.humanoid then
        if data.humanoid.WalkSpeed ~= speedValue then
            data.humanoid.WalkSpeed = speedValue
        end
    end
end)

local lastESPUpdate = tick()
workspace.DescendantAdded:Connect(function(descendant)
    if tick() - lastESPUpdate > 1 then
        lastESPUpdate = tick()
        task.spawn(function()
            task.wait(0.5)
            if _G.TurtleXFerData.updateLatamrotESP then
                _G.TurtleXFerData.updateLatamrotESP()
            end
        end)
    end
end)

workspace.DescendantRemoving:Connect(function(descendant)
    if tick() - lastESPUpdate > 1 then
        lastESPUpdate = tick()
        task.spawn(function()
            task.wait(0.1)
            if _G.TurtleXFerData.updateLatamrotESP then
                _G.TurtleXFerData.updateLatamrotESP()
            end
        end)
    end
end)

StarterGui:SetCore("SendNotification",{
    Title = "TurtleHub x xFer",
    Text = "Reiniciando para establecer base...",
    Duration = 3
})

wait(0.3)
data.humanoid.Health = 0

task.spawn(function()
    task.wait(3)
    if _G.TurtleXFerData.getPlayerBaseNumber then
        _G.TurtleXFerData.getPlayerBaseNumber()
    end
    task.wait(1)
    if _G.TurtleXFerData.updateLatamrotESP then
        _G.TurtleXFerData.updateLatamrotESP()
    end
end)

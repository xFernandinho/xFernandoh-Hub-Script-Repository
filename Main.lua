local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local GameScripts = {
    {
        name = "Blox Fruit Aimbot xFernandoh",
        game = "Blox Fruit",
        placeId = 2753915549,
        url = "https://pastebin.com/raw/X1zz3JDx",
        color = Color3.fromRGB(255, 85, 0),
        image = "https://www.roblox.com/games/2753915549/RED-EVENT-Blox-Fruits"
    },
    {
        name = "Instant Steal No Despertar Brainrot",
        game = "No despertar al Brainrot",
        placeId = 118915549367482,
        url = "https://pastebin.com/raw/g6zRKk3q",
        color = Color3.fromRGB(0, 170, 255),
        image = "https://www.roblox.com/games/118915549367482/No-Despertar-al-Brainrot"
    },
    {
        name = "Steal a Brainrot Script",
        game = "Steal a Brainrot",
        placeId = 109983668079237,
        url = "https://pastebin.com/8pNkHekA",
        color = Color3.fromRGB(255, 0, 128),
        image = "https://www.roblox.com/es/games/109983668079237/Steal-a-Brainrot"
    },
    {
        name = "Sin Script Aún",
        game = "Sin Script Aún",
        placeId = 11111111,
        url = "https://pastefy.link/arsenal_script",
        color = Color3.fromRGB(255, 216, 0),
        image = ""
    },
    {
        name = "Sin Script Aún",
        game = "Sin Script Aún",
        placeId = 11111111,
        url = "https://pastefy.link/jailbreak_script",
        color = Color3.fromRGB(0, 255, 140),
        image = ""
    },
    {
        name = "Sin Script Aún",
        game = "Sin Script Aún",
        placeId = 11111111,
        url = "https://pastefy.link/adoptme_script",
        color = Color3.fromRGB(255, 100, 200),
        image = ""
    }
}

function showNotification(message)
    StarterGui:SetCore("SendNotification", {
        Title = "Script Selector",
        Text = message,
        Duration = 5,
        Icon = "rbxassetid://4483345998"
    })
end

function executeScript(scriptData)
    print("Ejecutando script: " .. scriptData.name)
    print("URL: " .. scriptData.url)
    if scriptData.name ~= "Sin Script Aún" then
        local success, err = pcall(function()
            loadstring(game:HttpGet(scriptData.url))()
        end)
        if not success then
            warn("Error al ejecutar script:", err)
            showNotification("❌ Error al ejecutar el script: " .. scriptData.name)
            return false
        end
    end
    wait(1)
    return true
end

function smoothTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptSelectorGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "☰"
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 10
toggleButton.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

local toggleShadow = Instance.new("ImageLabel")
toggleShadow.Size = UDim2.new(1, 10, 1, 10)
toggleShadow.Position = UDim2.new(0, -5, 0, -5)
toggleShadow.BackgroundTransparency = 1
toggleShadow.Image = "rbxassetid://5554236805"
toggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
toggleShadow.ImageTransparency = 0.8
toggleShadow.ScaleType = Enum.ScaleType.Slice
toggleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
toggleShadow.ZIndex = 9
toggleShadow.Parent = toggleButton

local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(0, 50, 0, 30)
lockButton.Position = UDim2.new(0, 20, 0, 75)
lockButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockButton.Text = "🔓"
lockButton.TextSize = 16
lockButton.Font = Enum.Font.GothamBold
lockButton.BorderSizePixel = 0
lockButton.ZIndex = 10
lockButton.Parent = ScreenGui

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 6)
lockCorner.Parent = lockButton

local lockShadow = Instance.new("ImageLabel")
lockShadow.Size = UDim2.new(1, 10, 1, 10)
lockShadow.Position = UDim2.new(0, -5, 0, -5)
lockShadow.BackgroundTransparency = 1
lockShadow.Image = "rbxassetid://5554236805"
lockShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
lockShadow.ImageTransparency = 0.8
lockShadow.ScaleType = Enum.ScaleType.Slice
lockShadow.SliceCenter = Rect.new(10, 10, 118, 118)
lockShadow.ZIndex = 9
lockShadow.Parent = lockButton

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainShadow = Instance.new("ImageLabel")
mainShadow.Size = UDim2.new(1, 20, 1, 20)
mainShadow.Position = UDim2.new(0, -10, 0, -10)
mainShadow.BackgroundTransparency = 1
mainShadow.Image = "rbxassetid://5554236805"
mainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
mainShadow.ImageTransparency = 0.8
mainShadow.ScaleType = Enum.ScaleType.Slice
mainShadow.SliceCenter = Rect.new(10, 10, 118, 118)
mainShadow.ZIndex = -1
mainShadow.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SCRIPT SELECTOR xFernandoh"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
closeButton.Text = "×"
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local scriptsContainer = Instance.new("ScrollingFrame")
scriptsContainer.Size = UDim2.new(1, -20, 1, -70)
scriptsContainer.Position = UDim2.new(0, 10, 0, 60)
scriptsContainer.BackgroundTransparency = 1
scriptsContainer.BorderSizePixel = 0
scriptsContainer.ScrollBarThickness = 4
scriptsContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
scriptsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
scriptsContainer.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = scriptsContainer

local guiVisible = false
local isAnimating = false
local isLocked = false
local dragInput, dragStart, startPos

function toggleGUI(visible)
    if isAnimating then return end
    isAnimating = true
    
    if visible then
        mainFrame.Visible = true
        smoothTween(mainFrame, {Size = UDim2.new(0, 450, 0, 500)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        smoothTween(mainFrame, {Position = UDim2.new(0.5, -225, 0.5, -250)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        smoothTween(mainFrame, {BackgroundTransparency = 0}, 0.3)
    else
        smoothTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        smoothTween(mainFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        smoothTween(mainFrame, {BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        mainFrame.Visible = false
    end
    
    wait(0.4)
    isAnimating = false
    guiVisible = visible
end

function createScriptButton(scriptData)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 70)
    button.BackgroundColor3 = scriptData.color
    button.Text = ""
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Parent = scriptsContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local hoverEffect = Instance.new("Frame")
    hoverEffect.Size = UDim2.new(1, 0, 1, 0)
    hoverEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hoverEffect.BackgroundTransparency = 0.9
    hoverEffect.BorderSizePixel = 0
    hoverEffect.ZIndex = 2
    hoverEffect.Visible = false
    hoverEffect.Parent = button
    
    local hoverCorner = Instance.new("UICorner")
    hoverCorner.CornerRadius = UDim.new(0, 8)
    hoverCorner.Parent = hoverEffect
    
    button.MouseEnter:Connect(function()
        hoverEffect.Visible = true
        smoothTween(button, {Size = UDim2.new(1, 5, 0, 75)}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        hoverEffect.Visible = false
        smoothTween(button, {Size = UDim2.new(1, 0, 0, 70)}, 0.2)
    end)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -20)
    content.Position = UDim2.new(0, 10, 0, 10)
    content.BackgroundTransparency = 1
    content.Parent = button
    
    local scriptName = Instance.new("TextLabel")
    scriptName.Size = UDim2.new(1, 0, 0.5, 0)
    scriptName.BackgroundTransparency = 1
    scriptName.Text = scriptData.name
    scriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptName.TextSize = 16
    scriptName.Font = Enum.Font.GothamBold
    scriptName.TextXAlignment = Enum.TextXAlignment.Left
    scriptName.Parent = content
    
    local gameName = Instance.new("TextLabel")
    gameName.Size = UDim2.new(1, 0, 0.5, 0)
    gameName.Position = UDim2.new(0, 0, 0.5, 0)
    gameName.BackgroundTransparency = 1
    gameName.Text = scriptData.game
    gameName.TextColor3 = Color3.fromRGB(220, 220, 220)
    gameName.TextSize = 14
    gameName.Font = Enum.Font.Gotham
    gameName.TextXAlignment = Enum.TextXAlignment.Left
    gameName.Parent = content
    
    if scriptData.image ~= "" then
        local imageContainer = Instance.new("Frame")
        imageContainer.Size = UDim2.new(0, 50, 0, 50)
        imageContainer.Position = UDim2.new(1, -60, 0.5, -25)
        imageContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        imageContainer.BorderSizePixel = 0
        imageContainer.Parent = content
        
        local imageCorner = Instance.new("UICorner")
        imageCorner.CornerRadius = UDim.new(0, 8)
        imageCorner.Parent = imageContainer
        
        local image = Instance.new("ImageLabel")
        image.Size = UDim2.new(1, -4, 1, -4)
        image.Position = UDim2.new(0, 2, 0, 2)
        image.Image = scriptData.image
        image.BackgroundTransparency = 1
        image.Parent = imageContainer
    end
    
    button.MouseButton1Click:Connect(function()
        smoothTween(button, {BackgroundTransparency = 0.5}, 0.1)
        smoothTween(button, {BackgroundTransparency = 0}, 0.3)
        
        showNotification("Cargando script: " .. scriptData.name)
        local success = executeScript(scriptData)
        if success then
            showNotification("✓ Script " .. scriptData.name .. " ejecutado correctamente")
        else
            showNotification("❌ Error al ejecutar el script: " .. scriptData.name)
        end
    end)
    
    return button
end

for _, scriptData in ipairs(GameScripts) do
    createScriptButton(scriptData)
end

local function updateInput(input)
    if not isLocked then
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
        toggleButton.Position = newPosition
        lockButton.Position = UDim2.new(0, newPosition.X.Offset, 0, newPosition.Y.Offset + 55)
    end
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not dragStart then
            dragStart = input.Position
            startPos = toggleButton.Position
        end
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragStart then
        updateInput(input)
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragStart then
            local dragTime = os.clock()
            local isDrag = (os.clock() - dragTime > 0.1)
            
            if not isDrag then
                smoothTween(toggleButton, {Size = UDim2.new(0, 45, 0, 45)}, 0.1)
                smoothTween(toggleButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.2)
                toggleGUI(not guiVisible)
            end
            
            dragStart = nil
            dragInput = nil
        end
    end
end)

lockButton.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    if isLocked then
        lockButton.Text = "🔒"
        showNotification("Botón bloqueado")
    else
        lockButton.Text = "🔓"
        showNotification("Botón desbloqueado")
    end
end)

closeButton.MouseButton1Click:Connect(function()
    toggleGUI(false)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Escape and guiVisible then
        toggleGUI(false)
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        toggleGUI(not guiVisible)
    end
end)

mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundTransparency = 1

showNotification("Presiona RightShift para abrir/cerrar el menu")

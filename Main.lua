local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Player = Players.LocalPlayer

local GameScripts = {
    {
        name = "Blox Fruit Aimbot xFernandoh",
        game = "Blox Fruit",
        placeld = 2753915549,
        url = "loadstring(game:HttpGet("https://pastebin.com/raw/X1zz3JDx"))()",
        color = Color3.fromRGB(255, 85, 0)
    },
    {
        name = "Instant Steal No Despertar Brainrot",
        game = "No despiertes al Brainrot",
        placeld = 118915549367482,
        url = "loadstring(game:HttpGet("https://pastebin.com/raw/g6zRKk3q"))()",
        color = Color3.fromRGB(0, 170, 255)
    },
    {
        name = "Sin Script Aún",
        game = "Sin Script Aún",
        placeld = 11223344556,
        url = "https://pastefy.link/otro_mas",
        color = Color3.fromRGB(255, 0, 128)
    },
    {
        name = "Sin Script Aún",
        game = "Sin Script Aún",
        placeld = 44556677889,
        url = "https://pastefy.link/arsenal_script",
        color = Color3.fromRGB(255, 216, 0)
    },
    {
        name = "Sin Script Aún",
        game = "Sin Script Aún",
        placeld = 606849621,
        url = "https://pastefy.link/jailbreak_script",
        color = Color3.fromRGB(0, 255, 140)
    },
    {
        name = "Sin Script Aún",
        game = "Sin Script Aún",
        placeld = 7722306047,
        url = "https://pastefy.link/adoptme_script",
        color = Color3.fromRGB(255, 100, 200)
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptSelectorGUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function createRoundedFrame(parent, size, position, color, transparency, cornerRadius)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = frame
    
    frame.Parent = parent
    return frame
end

function createButton(parent, size, position, text, textColor, backgroundColor, cornerRadius)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = backgroundColor
    button.Text = text
    button.TextColor3 = textColor
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = button
    
    button.Parent = parent
    return button
end

function createTextLabel(parent, size, position, text, textColor, transparency, textSize, font)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor
    label.TextScaled = textSize == nil
    if textSize then
        label.TextSize = textSize
    end
    label.Font = font
    label.TextStrokeTransparency = 0.8
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Parent = parent
    return label
end

local toggleButton = createButton(ScreenGui, UDim2.new(0, 50, 0, 50), UDim2.new(0, 20, 0, 20), "☰", Color3.new(1, 1, 1), Color3.fromRGB(40, 40, 40), 12)

local mainFrame = createRoundedFrame(ScreenGui, UDim2.new(0, 450, 0, 500), UDim2.new(0.5, -225, 0.5, -250), Color3.fromRGB(30, 30, 35), 0.05, 14)
mainFrame.Visible = false

local header = createRoundedFrame(mainFrame, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0), Color3.fromRGB(25, 25, 30), 0, 14)
createTextLabel(header, UDim2.new(1, -60, 1, 0), UDim2.new(0, 10, 0, 0), "SELECTOR DE SCRIPTS", Color3.fromRGB(220, 220, 220), 1, 18, Enum.Font.GothamBold)

local closeButton = createButton(header, UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0.5, -15), "X", Color3.new(1, 1, 1), Color3.fromRGB(200, 50, 50), 8)

local scrollFrame = createRoundedFrame(mainFrame, UDim2.new(1, -20, 1, -70), UDim2.new(0, 10, 0, 60), Color3.fromRGB(35, 35, 40), 0, 10)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = scrollFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = scrollingFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingLeft = UDim.new(0, 10)
uiPadding.PaddingRight = UDim.new(0, 10)
uiPadding.Parent = scrollingFrame

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
    wait(1)
    return true
end

for i, scriptData in ipairs(GameScripts) do
    local scriptButton = createButton(scrollingFrame, UDim2.new(1, -20, 0, 70), UDim2.new(0, 0, 0, 0), "", Color3.new(1, 1, 1), scriptData.color, 8)
    
    local nameLabel = createTextLabel(scriptButton, UDim2.new(1, -10, 0, 30), UDim2.new(0, 10, 0, 5), scriptData.name, Color3.fromRGB(255, 255, 255), 1, 16, Enum.Font.GothamBold)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local gameLabel = createTextLabel(scriptButton, UDim2.new(1, -10, 0, 20), UDim2.new(0, 10, 0, 35), "Juego: " .. scriptData.game, Color3.fromRGB(220, 220, 220), 1, 14, Enum.Font.GothamBold)
    gameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local placeLabel = createTextLabel(scriptButton, UDim2.new(1, -10, 0, 20), UDim2.new(0, 10, 0, 55), "ID: " .. scriptData.placeld, Color3.fromRGB(200, 200, 200), 1, 12, Enum.Font.GothamBold)
    placeLabel.TextXAlignment = Enum.TextXAlignment.Left

    scriptButton.MouseButton1Click:Connect(function()
        toggleMenu()
        
        showNotification("Cargando script: " .. scriptData.name)
        
        task.wait(1)
        
        local success = executeScript(scriptData)
        
        if success then
            showNotification("✓ Script " .. scriptData.name .. " ejecutado correctamente")
            
            task.wait(2)
            
            if ScreenGui then
                ScreenGui:Destroy()
                print("Selector de scripts cerrado después de ejecución exitosa")
            end
        else
            showNotification("❌ Error al ejecutar el script: " .. scriptData.name)
        end
    end)
end

scrollingFrame.ClipsDescendants = true
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
end)

local isOpen = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function toggleMenu()
    isOpen = not isOpen
    
    if isOpen then
        mainFrame.Visible = true
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 500)})
        tween:Play()
    else
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 500)})
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
        tween:Play()
    end
end

toggleButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

closeButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

local function setupButtonHover(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = defaultColor})
        tween:Play()
    end)
end

setupButtonHover(toggleButton, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 65))
setupButtonHover(closeButton, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))

for _, child in ipairs(scrollingFrame:GetChildren()) do
    if child:IsA("TextButton") then
        local defaultColor = child.BackgroundColor3
        local hoverColor = Color3.new(
            math.min(defaultColor.R * 1.2, 1),
            math.min(defaultColor.G * 1.2, 1),
            math.min(defaultColor.B * 1.2, 1)
        )
        
        setupButtonHover(child, defaultColor, hoverColor)
    end
end

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

showNotification("Selector de Scripts Cargado! Presiona ☰ para abrir")
print("Selector de Scripts Cargado!")
print("Presiona el botón ☰ para abrir/cerrar el menú")

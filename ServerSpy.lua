local WebhookURL = "https://discord.com/api/webhooks/1527727034053431356/QFn10JEErsuG7MCy9_qW3HOoKqaY76xeKbbbkFO0iEaUI28BTnCK49GVbALiURwOoHUI"
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
local errorMessage = ""
local function SendWebhook(payload)
    if not httpRequest then
        errorMessage = "HTTP request no disponible"
        return false
    end
    local ok, resp = pcall(function()
        return httpRequest({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
    if not ok then
        errorMessage = "Error al enviar: " .. tostring(resp)
    else
        errorMessage = ""
    end
    return ok, resp
end
local function GetPlayerCount()
    return #Players:GetPlayers(), Players.MaxPlayers
end
local playerName = LocalPlayer.Name
local displayName = LocalPlayer.DisplayName
local gameName = "Desconocido"
pcall(function()
    gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)
local function SendStatusEmbed()
    local current, max = GetPlayerCount()
    local isFull = current >= max
    local payload = {
        embeds = {{
            title = gameName,
            color = isFull and 15158332 or 3066993,
            fields = {
                {name = "Job ID", value = "``" .. game.JobId .. "``", inline = false},
                {name = "Jugador", value = playerName .. " (" .. displayName .. ")", inline = true},
                {name = "Jugadores", value = current .. "/" .. max, inline = true},
                {name = "Estado", value = isFull and "🔴 Lleno" or "🟢 Con cupos", inline = true}
            },
            footer = {text = "JobId: " .. game.JobId}
        }}
    }
    SendWebhook(payload)
    return current, max, isFull
end
local function SendSlotAlert()
    local current, max = GetPlayerCount()
    if current >= max then return end
    local jobIdFormatted = "``" .. game.JobId .. "``"
    SendWebhook({content = "@everyone 🟢 Se liberó un cupo (" .. current .. "/" .. max .. ") en **" .. gameName .. "**\nJob ID: " .. jobIdFormatted})
end
local slotAlertCooldown = false
local function CheckSlotAlert()
    local current, max = GetPlayerCount()
    local isFree = current < max
    if isFree and not slotAlertCooldown then
        slotAlertCooldown = true
        SendSlotAlert()
    elseif not isFree then
        slotAlertCooldown = false
    end
end
local function SendManualJobId()
    SendWebhook({content = "Job ID manual: ``" .. game.JobId .. "``"})
end
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WebhookMonitor"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 180, 0, 130)
    Frame.Position = UDim2.new(0, 20, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 22, 24)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Frame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(80, 200, 130)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.4
    UIStroke.Parent = Frame
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -8, 0, 24)
    TextBox.Position = UDim2.new(0, 4, 0, 4)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 33, 35)
    TextBox.PlaceholderText = "Mensaje..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(220, 255, 235)
    TextBox.TextSize = 11
    TextBox.Font = Enum.Font.Gotham
    TextBox.ClearTextOnFocus = false
    TextBox.BorderSizePixel = 0
    TextBox.Parent = Frame
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 4)
    TextBoxCorner.Parent = TextBox
    local SendMsgBtn = Instance.new("TextButton")
    SendMsgBtn.Size = UDim2.new(0.45, -6, 0, 20)
    SendMsgBtn.Position = UDim2.new(0, 4, 0, 32)
    SendMsgBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
    SendMsgBtn.Text = "Enviar"
    SendMsgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SendMsgBtn.TextSize = 11
    SendMsgBtn.Font = Enum.Font.GothamBold
    SendMsgBtn.BorderSizePixel = 0
    SendMsgBtn.Parent = Frame
    local SendMsgCorner = Instance.new("UICorner")
    SendMsgCorner.CornerRadius = UDim.new(0, 4)
    SendMsgCorner.Parent = SendMsgBtn
    local SendJobBtn = Instance.new("TextButton")
    SendJobBtn.Size = UDim2.new(0.45, -6, 0, 20)
    SendJobBtn.Position = UDim2.new(0.55, 2, 0, 32)
    SendJobBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 160)
    SendJobBtn.Text = "Job ID"
    SendJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SendJobBtn.TextSize = 11
    SendJobBtn.Font = Enum.Font.GothamBold
    SendJobBtn.BorderSizePixel = 0
    SendJobBtn.Parent = Frame
    local SendJobCorner = Instance.new("UICorner")
    SendJobCorner.CornerRadius = UDim.new(0, 4)
    SendJobCorner.Parent = SendJobBtn
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -8, 0, 16)
    StatusLabel.Position = UDim2.new(0, 4, 0, 56)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Monitor activo"
    StatusLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
    StatusLabel.TextSize = 10
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Frame
    local ErrorLabel = Instance.new("TextLabel")
    ErrorLabel.Size = UDim2.new(1, -8, 0, 30)
    ErrorLabel.Position = UDim2.new(0, 4, 0, 74)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Text = ""
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    ErrorLabel.TextSize = 9
    ErrorLabel.Font = Enum.Font.Gotham
    ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left
    ErrorLabel.TextWrapped = true
    ErrorLabel.Parent = Frame
    SendMsgBtn.MouseButton1Click:Connect(function()
        local msg = TextBox.Text
        if msg ~= "" then
            SendWebhook({content = msg})
            TextBox.Text = ""
        end
    end)
    SendJobBtn.MouseButton1Click:Connect(SendManualJobId)
    local function UpdateStatus()
        local current, max, isFull = SendStatusEmbed()
        StatusLabel.Text = "Jugadores: " .. current .. "/" .. max .. (isFull and " 🔴 Lleno" or " 🟢 Cupos")
    end
    local function UpdateError()
        ErrorLabel.Text = errorMessage
    end
    task.spawn(function()
        while true do
            UpdateError()
            task.wait(2)
        end
    end)
    Players.PlayerAdded:Connect(function()
        UpdateStatus()
        CheckSlotAlert()
    end)
    Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            SendWebhook({content = "👋 El jugador " .. playerName .. " (" .. displayName .. ") ha salido de la partida."})
        end
        UpdateStatus()
        CheckSlotAlert()
    end)
    game:BindToClose(function()
        SendWebhook({content = "👋 El jugador " .. playerName .. " (" .. displayName .. ") ha salido de la partida (BindToClose)."})
    end)
    UpdateStatus()
    CheckSlotAlert()
    local dragging, dragInput, dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
task.wait(1)
CreateGUI()

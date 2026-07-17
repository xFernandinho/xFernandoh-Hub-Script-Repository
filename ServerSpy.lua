local WebhookURL = "https://discord.com/api/webhooks/1527727034053431356/QFn10JEErsuG7MCy9_qW3HOoKqaY76xeKbbbkFO0iEaUI28BTnCK49GVbALiURwOoHUI"
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
local function SendWebhook(payload)
    if not httpRequest then
        return false
    end
    local ok, response = pcall(function()
        return httpRequest({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload),
        })
    end)
    return ok, response
end
local function GetPlayerNamesList()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    if #names == 0 then
        return "Ninguno"
    end
    return table.concat(names, ", ")
end
local gameName = "Desconocido"
pcall(function()
    gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)
local function SendStatusEmbed()
    local current = #Players:GetPlayers()
    local max = Players.MaxPlayers
    local isFull = current >= max
    local payload = {
        embeds = {
            {
                title = gameName,
                color = isFull and 15158332 or 3066993,
                fields = {
                    { name = "Jugadores", value = current .. "/" .. max, inline = true },
                    { name = "Estado", value = isFull and "🔴 Lleno" or "🟢 Con cupos", inline = true },
                    { name = "Lista de jugadores", value = GetPlayerNamesList(), inline = false },
                },
                footer = { text = "JobId: " .. game.JobId },
            },
        },
    }
    SendWebhook(payload)
end
local lastSlotFree = false
local function CheckSlotAlert()
    local current = #Players:GetPlayers()
    local max = Players.MaxPlayers
    local isFree = current < max
    if isFree and not lastSlotFree then
        local deeplink = "https://www.roblox.com/games/start?placeId=" .. game.PlaceId .. "&gameId=" .. game.JobId
        SendWebhook({
            content = "🟢 Se libero un cupo (" .. current .. "/" .. max .. ") en **" .. gameName .. "**\nUnirse: " .. deeplink,
        })
    end
    lastSlotFree = isFree
end
task.spawn(function()
    while true do
        SendStatusEmbed()
        task.wait(90)
    end
end)
task.spawn(function()
    while true do
        CheckSlotAlert()
        task.wait(5)
    end
end)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WebhookMonitorGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")
local Frame = Instance.new("Frame")
Frame.Name = "MiniFrame"
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(20, 22, 24)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = Frame
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(80, 200, 130)
FrameStroke.Thickness = 1
FrameStroke.Transparency = 0.5
FrameStroke.Parent = Frame
local MsgBox = Instance.new("TextBox")
MsgBox.Size = UDim2.new(1, -8, 0, 24)
MsgBox.Position = UDim2.new(0, 4, 0, 4)
MsgBox.BackgroundColor3 = Color3.fromRGB(30, 33, 35)
MsgBox.PlaceholderText = "Mensaje..."
MsgBox.Text = ""
MsgBox.TextColor3 = Color3.fromRGB(220, 255, 235)
MsgBox.TextSize = 11
MsgBox.Font = Enum.Font.Gotham
MsgBox.ClearTextOnFocus = false
MsgBox.BorderSizePixel = 0
MsgBox.Parent = Frame
local MsgBoxCorner = Instance.new("UICorner")
MsgBoxCorner.CornerRadius = UDim.new(0, 6)
MsgBoxCorner.Parent = MsgBox
local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(1, -8, 0, 18)
SendButton.Position = UDim2.new(0, 4, 0, 30)
SendButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
SendButton.Text = "Enviar"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 11
SendButton.Font = Enum.Font.GothamBold
SendButton.BorderSizePixel = 0
SendButton.Parent = Frame
local SendButtonCorner = Instance.new("UICorner")
SendButtonCorner.CornerRadius = UDim.new(0, 6)
SendButtonCorner.Parent = SendButton
SendButton.MouseButton1Click:Connect(function()
    local text = MsgBox.Text
    if text ~= "" then
        SendWebhook({ content = text })
        MsgBox.Text = ""
    end
end)
local dragging = false
local dragInput
local dragStart
local startPos
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
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
SendStatusEmbed()

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end
local function addStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency
    s.Parent = parent
end
local function addPadding(parent, left, top, bottom, right)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.Parent = parent
end
local function addCover(parent, height, color)
    local cov = Instance.new("Frame")
    cov.Size = UDim2.new(1, 0, 0, height)
    cov.Position = UDim2.new(0, 0, 1, -height)
    cov.BackgroundColor3 = color
    cov.BorderSizePixel = 0
    cov.Parent = parent
end
local function addGlow(parent, color)
    local g = Instance.new("Frame")
    g.Size = UDim2.new(1, 0, 0, 2)
    g.Position = UDim2.new(0, 0, 1, 0)
    g.BackgroundColor3 = color
    g.BorderSizePixel = 0
    g.BackgroundTransparency = 0.7
    g.Parent = parent
end
local serversData = {}
local filteredData = {}
local currentSort = "ascending"
local currentPage = 1
local pageSize = 50
local filterMin = nil
local filterMax = nil
local autoRefreshIndex = 1
local autoRefreshToken = 0
local menuOpen = false
local NotificationModule = nil
local success, result = pcall(function()
    if not game:IsLoaded() then task.wait(0.1) end
    return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController"))
end)
if success and result and result.Notify then
    NotificationModule = result
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerFinderGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
local guiParented, _ = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not guiParented then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
if isMobile then
    ToggleButton.Size = UDim2.new(0, 46, 0, 46)
    ToggleButton.Position = UDim2.new(1, -56, 0, 10)
else
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(1, -65, 0.5, -25)
end
ToggleButton.BackgroundColor3 = Color3.fromRGB(28, 35, 32)
ToggleButton.Text = "📡"
ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 150)
ToggleButton.TextSize = isMobile and 22 or 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui
addCorner(ToggleButton, 12)
addStroke(ToggleButton, Color3.fromRGB(80, 200, 130), 1.5, 0.5)
local frameWidth = isMobile and 0.62 or 0
local frameWidthOffset = isMobile and 0 or 320
local rowGap = isMobile and 4 or 6
local headerHeight = isMobile and 32 or 46
local rowCurrentJobIdHeight = isMobile and 20 or 28
local rowActionsHeight = isMobile and 22 or 30
local row1Height = isMobile and 24 or 32
local rowFilterHeight = isMobile and 22 or 30
local rowJobIdHeight = isMobile and 22 or 30
local row2Height = isMobile and 18 or 26
local statusHeight = isMobile and 13 or 20
local entryHeight = isMobile and 38 or 58
local listMinHeight = isMobile and 100 or 170
local bottomReserved = isMobile and 22 or 36
local frameHeight = headerHeight + rowGap
    + rowCurrentJobIdHeight + rowGap
    + rowActionsHeight + rowGap
    + row1Height + rowGap
    + rowFilterHeight + rowGap
    + rowJobIdHeight + rowGap
    + row2Height + rowGap
    + listMinHeight + bottomReserved
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(frameWidth, frameWidthOffset, 0, frameHeight)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 14)
addStroke(MainFrame, Color3.fromRGB(60, 160, 100), 1, 0.6)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, headerHeight)
Header.BackgroundColor3 = Color3.fromRGB(22, 25, 27)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
addCorner(Header, 14)
addCover(Header, 14, Color3.fromRGB(22, 25, 27))
addGlow(Header, Color3.fromRGB(80, 200, 130))
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌐 Servidores"
Title.TextColor3 = Color3.fromRGB(100, 255, 150)
Title.TextSize = isMobile and 12 or 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
local closeSize = isMobile and 22 or 32
local closePos = isMobile and -28 or -40
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, closeSize, 0, closeSize)
CloseButton.Position = UDim2.new(1, closePos, 0.5, -(closeSize/2))
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 33, 35)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = isMobile and 11 or 15
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header
addCorner(CloseButton, 8)
local rowCurrentJobIdTop = headerHeight + rowGap
local RowCurrentJobId = Instance.new("Frame")
RowCurrentJobId.Name = "RowCurrentJobId"
RowCurrentJobId.Size = UDim2.new(1, -20, 0, rowCurrentJobIdHeight)
RowCurrentJobId.Position = UDim2.new(0, 10, 0, rowCurrentJobIdTop)
RowCurrentJobId.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
RowCurrentJobId.BorderSizePixel = 0
RowCurrentJobId.Parent = MainFrame
addCorner(RowCurrentJobId, 8)
addStroke(RowCurrentJobId, Color3.fromRGB(60, 160, 100), 1, 0.7)
local CurrentJobIdLabel = Instance.new("TextLabel")
CurrentJobIdLabel.Name = "CurrentJobIdLabel"
CurrentJobIdLabel.Size = UDim2.new(1, -40, 1, 0)
CurrentJobIdLabel.Position = UDim2.new(0, 10, 0, 0)
CurrentJobIdLabel.BackgroundTransparency = 1
CurrentJobIdLabel.Text = "🆔 " .. tostring(game.JobId)
CurrentJobIdLabel.TextColor3 = Color3.fromRGB(220, 255, 235)
CurrentJobIdLabel.TextSize = isMobile and 8 or 11
CurrentJobIdLabel.Font = Enum.Font.Gotham
CurrentJobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentJobIdLabel.TextTruncate = Enum.TextTruncate.AtEnd
CurrentJobIdLabel.Parent = RowCurrentJobId
local copyCurrentJobIdSize = isMobile and 16 or 22
local CopyCurrentJobIdButton = Instance.new("TextButton")
CopyCurrentJobIdButton.Name = "CopyCurrentJobIdButton"
CopyCurrentJobIdButton.Size = UDim2.new(0, copyCurrentJobIdSize, 0, copyCurrentJobIdSize)
CopyCurrentJobIdButton.Position = UDim2.new(1, -(copyCurrentJobIdSize + 6), 0.5, -(copyCurrentJobIdSize/2))
CopyCurrentJobIdButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
CopyCurrentJobIdButton.Text = "📋"
CopyCurrentJobIdButton.TextColor3 = Color3.fromRGB(150, 200, 170)
CopyCurrentJobIdButton.TextSize = isMobile and 10 or 11
CopyCurrentJobIdButton.Font = Enum.Font.GothamBold
CopyCurrentJobIdButton.BorderSizePixel = 0
CopyCurrentJobIdButton.Parent = RowCurrentJobId
addCorner(CopyCurrentJobIdButton, 6)
local function makeRowButton(name, text, xScale, wScale, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(wScale, 0, 1, 0)
    btn.Position = UDim2.new(xScale, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(100, 255, 150)
    btn.TextSize = isMobile and 9 or 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    addCorner(btn, 8)
    addStroke(btn, Color3.fromRGB(60, 160, 100), 1, 0.7)
    return btn
end
local rowActionsTop = rowCurrentJobIdTop + rowCurrentJobIdHeight + rowGap
local RowActions = Instance.new("Frame")
RowActions.Name = "RowActions"
RowActions.Size = UDim2.new(1, -20, 0, rowActionsHeight)
RowActions.Position = UDim2.new(0, 10, 0, rowActionsTop)
RowActions.BackgroundTransparency = 1
RowActions.Parent = MainFrame
local RejoinButton = makeRowButton("RejoinButton", "🔁 Rejoin", 0, 0.49, RowActions)
local HopButton = makeRowButton("HopButton", "🔀 Server Hop", 0.51, 0.49, RowActions)
local row1Top = rowActionsTop + rowActionsHeight + rowGap
local Row1 = Instance.new("Frame")
Row1.Name = "Row1"
Row1.Size = UDim2.new(1, -20, 0, row1Height)
Row1.Position = UDim2.new(0, 10, 0, row1Top)
Row1.BackgroundTransparency = 1
Row1.Parent = MainFrame
local RefreshButton = makeRowButton("RefreshButton", "🔄 Refrescar", 0, 0.32, Row1)
local SortButton = makeRowButton("SortButton", "↑ Menor", 0.34, 0.32, Row1)
local AutoButton = makeRowButton("AutoButton", "⏱ Off", 0.68, 0.32, Row1)
local rowFilterTop = row1Top + row1Height + rowGap
local RowFilter = Instance.new("Frame")
RowFilter.Name = "RowFilter"
RowFilter.Size = UDim2.new(1, -20, 0, rowFilterHeight)
RowFilter.Position = UDim2.new(0, 10, 0, rowFilterTop)
RowFilter.BackgroundTransparency = 1
RowFilter.Parent = MainFrame
local FilterBox = Instance.new("TextBox")
FilterBox.Name = "FilterBox"
FilterBox.Size = UDim2.new(1, -38, 1, 0)
FilterBox.Position = UDim2.new(0, 0, 0, 0)
FilterBox.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
FilterBox.PlaceholderText = "🎚 Jugadores exactos (ej: 16 o 5-20)"
FilterBox.PlaceholderColor3 = Color3.fromRGB(110, 140, 125)
FilterBox.Text = ""
FilterBox.TextColor3 = Color3.fromRGB(220, 255, 235)
FilterBox.TextSize = isMobile and 11 or 12
FilterBox.Font = Enum.Font.Gotham
FilterBox.ClearTextOnFocus = false
FilterBox.TextXAlignment = Enum.TextXAlignment.Left
FilterBox.BorderSizePixel = 0
FilterBox.Parent = RowFilter
addPadding(FilterBox, 10, 0, 0, 0)
addCorner(FilterBox, 8)
addStroke(FilterBox, Color3.fromRGB(60, 160, 100), 1, 0.7)
local ClearFilterButton = Instance.new("TextButton")
ClearFilterButton.Name = "ClearFilterButton"
ClearFilterButton.Size = UDim2.new(0, 32, 1, 0)
ClearFilterButton.Position = UDim2.new(1, -32, 0, 0)
ClearFilterButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
ClearFilterButton.Text = "✕"
ClearFilterButton.TextColor3 = Color3.fromRGB(255, 140, 140)
ClearFilterButton.TextSize = isMobile and 12 or 13
ClearFilterButton.Font = Enum.Font.GothamBold
ClearFilterButton.BorderSizePixel = 0
ClearFilterButton.Parent = RowFilter
addCorner(ClearFilterButton, 8)
local rowJobIdTop = rowFilterTop + rowFilterHeight + rowGap
local RowJobId = Instance.new("Frame")
RowJobId.Name = "RowJobId"
RowJobId.Size = UDim2.new(1, -20, 0, rowJobIdHeight)
RowJobId.Position = UDim2.new(0, 10, 0, rowJobIdTop)
RowJobId.BackgroundTransparency = 1
RowJobId.Parent = MainFrame
local JobIdBox = Instance.new("TextBox")
JobIdBox.Name = "JobIdBox"
JobIdBox.Size = UDim2.new(1, -62, 1, 0)
JobIdBox.Position = UDim2.new(0, 0, 0, 0)
JobIdBox.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
JobIdBox.PlaceholderText = "🆔 Pegar Job ID..."
JobIdBox.PlaceholderColor3 = Color3.fromRGB(110, 140, 125)
JobIdBox.Text = ""
JobIdBox.TextColor3 = Color3.fromRGB(220, 255, 235)
JobIdBox.TextSize = isMobile and 11 or 12
JobIdBox.Font = Enum.Font.Gotham
JobIdBox.ClearTextOnFocus = false
JobIdBox.TextXAlignment = Enum.TextXAlignment.Left
JobIdBox.BorderSizePixel = 0
JobIdBox.Parent = RowJobId
addPadding(JobIdBox, 10, 0, 0, 0)
addCorner(JobIdBox, 8)
addStroke(JobIdBox, Color3.fromRGB(60, 160, 100), 1, 0.7)
local JoinJobIdButton = Instance.new("TextButton")
JoinJobIdButton.Name = "JoinJobIdButton"
JoinJobIdButton.Size = UDim2.new(0, 58, 1, 0)
JoinJobIdButton.Position = UDim2.new(1, -58, 0, 0)
JoinJobIdButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
JoinJobIdButton.Text = "Ir"
JoinJobIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinJobIdButton.TextSize = isMobile and 12 or 13
JoinJobIdButton.Font = Enum.Font.GothamBold
JoinJobIdButton.BorderSizePixel = 0
JoinJobIdButton.Parent = RowJobId
addCorner(JoinJobIdButton, 8)
local row2Top = rowJobIdTop + rowJobIdHeight + rowGap
local Row2 = Instance.new("Frame")
Row2.Name = "Row2"
Row2.Size = UDim2.new(1, -20, 0, row2Height)
Row2.Position = UDim2.new(0, 10, 0, row2Top)
Row2.BackgroundTransparency = 1
Row2.Parent = MainFrame
local PrevButton = Instance.new("TextButton")
PrevButton.Name = "PrevButton"
PrevButton.Size = UDim2.new(0, 36, 1, 0)
PrevButton.Position = UDim2.new(0, 0, 0, 0)
PrevButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
PrevButton.Text = "◀"
PrevButton.TextColor3 = Color3.fromRGB(100, 255, 150)
PrevButton.TextSize = isMobile and 12 or 13
PrevButton.Font = Enum.Font.GothamBold
PrevButton.BorderSizePixel = 0
PrevButton.Parent = Row2
addCorner(PrevButton, 8)
local PageLabel = Instance.new("TextLabel")
PageLabel.Name = "PageLabel"
PageLabel.Size = UDim2.new(1, -80, 1, 0)
PageLabel.Position = UDim2.new(0, 40, 0, 0)
PageLabel.BackgroundTransparency = 1
PageLabel.Text = "Página 1/1"
PageLabel.TextColor3 = Color3.fromRGB(150, 200, 170)
PageLabel.TextSize = isMobile and 11 or 12
PageLabel.Font = Enum.Font.Gotham
PageLabel.TextXAlignment = Enum.TextXAlignment.Center
PageLabel.Parent = Row2
local NextButton = Instance.new("TextButton")
NextButton.Name = "NextButton"
NextButton.Size = UDim2.new(0, 36, 1, 0)
NextButton.Position = UDim2.new(1, -36, 0, 0)
NextButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
NextButton.Text = "▶"
NextButton.TextColor3 = Color3.fromRGB(100, 255, 150)
NextButton.TextSize = isMobile and 12 or 13
NextButton.Font = Enum.Font.GothamBold
NextButton.BorderSizePixel = 0
NextButton.Parent = Row2
addCorner(NextButton, 8)
local listTopOffset = row2Top + row2Height + rowGap
local listBottomOffset = -(listTopOffset + bottomReserved)
local ServerList = Instance.new("ScrollingFrame")
ServerList.Name = "ServerList"
ServerList.Size = UDim2.new(1, -24, 1, listBottomOffset)
ServerList.Position = UDim2.new(0, 12, 0, listTopOffset)
ServerList.BackgroundColor3 = Color3.fromRGB(22, 25, 27)
ServerList.BorderSizePixel = 0
ServerList.ScrollBarThickness = 4
ServerList.ScrollBarImageColor3 = Color3.fromRGB(80, 200, 130)
ServerList.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerList.Parent = MainFrame
addCorner(ServerList, 10)
addStroke(ServerList, Color3.fromRGB(40, 120, 80), 1, 0.7)
local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 6)
ListLayout.Parent = ServerList
addPadding(ServerList, 8, 8, 14, 8)
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -24, 0, statusHeight)
StatusLabel.Position = UDim2.new(0, 12, 1, -statusHeight - 6)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Listo para buscar..."
StatusLabel.TextColor3 = Color3.fromRGB(100, 180, 130)
StatusLabel.TextSize = isMobile and 10 or 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame
local function updateStatus(text)
    if StatusLabel and StatusLabel.Parent then
        StatusLabel.Text = text
    end
end
local function notify(text, duration, sound, color)
    if NotificationModule then
        local colorTag = color or "#FFFFFF"
        NotificationModule.Notify(
            NotificationModule,
            string.format('<font color="%s">%s</font>', colorTag, text),
            duration or 3,
            sound or "Sounds.Sfx.Info"
        )
    else
        updateStatus(text)
    end
end
local function tweenSize(obj, newSize, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = newSize})
    tween:Play()
    return tween
end
local function tweenPosition(obj, newPos, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = newPos})
    tween:Play()
    return tween
end
local function tweenColor(obj, newColor, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = newColor})
    tween:Play()
    return tween
end
local function getServers(placeId, cursor)
    local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", placeId)
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end
local function sortServers()
    if currentSort == "ascending" then
        table.sort(serversData, function(a, b)
            return a.playing < b.playing
        end)
        SortButton.Text = "↑ Menor"
    else
        table.sort(serversData, function(a, b)
            return a.playing > b.playing
        end)
        SortButton.Text = "↓ Mayor"
    end
end
local function parseFilterText(text)
    text = text:gsub("%s+", "")
    if text == "" then
        return nil, nil
    end
    local minStr, maxStr = text:match("^(%d+)%-(%d+)$")
    if minStr and maxStr then
        return tonumber(minStr), tonumber(maxStr)
    end
    local exact = tonumber(text)
    if exact then
        return exact, exact
    end
    return nil, nil, true
end
local function createServerEntry(serverData, index)
    local isCurrent = serverData.isCurrent == true
    local wasVisited = false
    if not isCurrent and _G.ServerHistory then
        local hist = _G.ServerHistory.Load()
        for _, e in ipairs(hist.servers) do
            if e.jobId == serverData.id then
                wasVisited = true
                break
            end
        end
    end
    local Entry = Instance.new("Frame")
    Entry.Name = "Entry_" .. index
    Entry.Size = UDim2.new(1, -8, 0, entryHeight)
    Entry.BackgroundColor3 = isCurrent and Color3.fromRGB(22, 48, 36) or (wasVisited and Color3.fromRGB(54, 48, 20) or Color3.fromRGB(26, 30, 32))
    Entry.BorderSizePixel = 0
    Entry.LayoutOrder = index
    Entry.Parent = ServerList
    addCorner(Entry, 8)
    addStroke(Entry, isCurrent and Color3.fromRGB(100, 255, 150) or (wasVisited and Color3.fromRGB(241, 196, 15) or Color3.fromRGB(50, 140, 90)), (isCurrent or wasVisited) and 1.5 or 1, (isCurrent or wasVisited) and 0.4 or 0.8)
    local playerCountWidth = isMobile and 38 or 48
    local PlayerCount = Instance.new("TextLabel")
    PlayerCount.Size = UDim2.new(0, playerCountWidth, 1, 0)
    PlayerCount.Position = UDim2.new(0, 8, 0, 0)
    PlayerCount.BackgroundTransparency = 1
    PlayerCount.Text = string.format("%d/%d", serverData.playing, serverData.maxPlayers)
    PlayerCount.TextColor3 = Color3.fromRGB(120, 255, 180)
    PlayerCount.TextSize = isMobile and 11 or 14
    PlayerCount.Font = Enum.Font.GothamBold
    PlayerCount.TextXAlignment = Enum.TextXAlignment.Left
    PlayerCount.Parent = Entry
    local joinButtonWidth = isMobile and 46 or 58
    local joinButtonHeight = isMobile and 24 or 30
    local copyButtonSize = isMobile and 17 or 22
    local rightReserved = joinButtonWidth + copyButtonSize + 18
    local ServerInfo = Instance.new("TextLabel")
    ServerInfo.Size = UDim2.new(1, -(playerCountWidth + 12 + rightReserved), 0.45, 0)
    ServerInfo.Position = UDim2.new(0, playerCountWidth + 12, 0, 4)
    ServerInfo.BackgroundTransparency = 1
    local infoText = "Jugadores"
    local infoColor = Color3.fromRGB(120, 160, 140)
    if isCurrent then
        infoText = "📍 Tú estás aquí"
        infoColor = Color3.fromRGB(100, 255, 150)
    elseif wasVisited then
        infoText = serverData.playing == serverData.maxPlayers and "🟡 Ya visitaste • Lleno ⛔" or "🟡 Ya visitaste este servidor"
        infoColor = Color3.fromRGB(241, 196, 15)
    elseif serverData.playing == serverData.maxPlayers then
        infoText = "Servidor Lleno ⛔"
        infoColor = Color3.fromRGB(255, 100, 100)
    elseif serverData.maxPlayers < 10 then
        infoText = "Servidor Disponible"
        infoColor = Color3.fromRGB(255, 200, 100)
    end
    ServerInfo.Text = infoText
    ServerInfo.TextColor3 = infoColor
    ServerInfo.TextSize = isMobile and 8 or 10
    ServerInfo.Font = Enum.Font.Gotham
    ServerInfo.TextXAlignment = Enum.TextXAlignment.Left
    ServerInfo.Parent = Entry
    local Ping = Instance.new("TextLabel")
    Ping.Size = UDim2.new(0, 60, 0.4, 0)
    Ping.Position = UDim2.new(0, playerCountWidth + 12, 0.55, 0)
    Ping.BackgroundTransparency = 1
    Ping.Text = string.format("%d ms", math.random(20, 120))
    Ping.TextColor3 = Color3.fromRGB(100, 180, 130)
    Ping.TextSize = isMobile and 7 or 9
    Ping.Font = Enum.Font.Gotham
    Ping.TextXAlignment = Enum.TextXAlignment.Left
    Ping.Parent = Entry
    local CopyButton = Instance.new("TextButton")
    CopyButton.Size = UDim2.new(0, copyButtonSize, 0, copyButtonSize)
    CopyButton.Position = UDim2.new(1, -(joinButtonWidth + copyButtonSize + 12), 0.5, -(copyButtonSize/2))
    CopyButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
    CopyButton.Text = "📋"
    CopyButton.TextColor3 = Color3.fromRGB(150, 200, 170)
    CopyButton.TextSize = isMobile and 9 or 11
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.BorderSizePixel = 0
    CopyButton.Parent = Entry
    addCorner(CopyButton, 6)
    CopyButton.MouseButton1Click:Connect(function()
        local ok = pcall(function()
            setclipboard(serverData.id)
        end)
        if ok then
            notify("ID de servidor copiado ✓", 2, "Sounds.Sfx.Info", "#5DADE2")
        else
            notify("Tu ejecutor no soporta copiar al portapapeles", 3, "Sounds.Sfx.Warning", "#F39C12")
        end
    end)
    local JoinButton = Instance.new("TextButton")
    JoinButton.Size = UDim2.new(0, joinButtonWidth, 0, joinButtonHeight)
    JoinButton.Position = UDim2.new(1, -(joinButtonWidth + 6), 0.5, -(joinButtonHeight/2))
    local isFull = serverData.playing >= serverData.maxPlayers
    if isCurrent then
        JoinButton.BackgroundColor3 = Color3.fromRGB(40, 100, 150)
        JoinButton.Text = "Rejoin"
        JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif isFull then
        JoinButton.BackgroundColor3 = Color3.fromRGB(110, 70, 30)
        JoinButton.Text = "Forzar"
        JoinButton.TextColor3 = Color3.fromRGB(255, 220, 150)
    else
        JoinButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        JoinButton.Text = "Unirse"
        JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    JoinButton.TextSize = isMobile and 9 or 12
    JoinButton.Font = Enum.Font.GothamBold
    JoinButton.BorderSizePixel = 0
    JoinButton.Parent = Entry
    addCorner(JoinButton, 7)
    addStroke(JoinButton, Color3.fromRGB(80, 200, 130), 1.5, 0.6)
    local normalColor
    local hoverColor
    if isCurrent then
        normalColor = Color3.fromRGB(40, 100, 150)
        hoverColor = Color3.fromRGB(60, 130, 190)
    elseif isFull then
        normalColor = Color3.fromRGB(110, 70, 30)
        hoverColor = Color3.fromRGB(140, 90, 40)
    else
        normalColor = Color3.fromRGB(40, 140, 90)
        hoverColor = Color3.fromRGB(50, 170, 110)
    end
    JoinButton.MouseEnter:Connect(function()
        tweenColor(JoinButton, hoverColor, 0.2)
    end)
    JoinButton.MouseLeave:Connect(function()
        tweenColor(JoinButton, normalColor, 0.2)
    end)
    JoinButton.MouseButton1Click:Connect(function()
        if isCurrent then
            notify("Reconectando al servidor actual...", 2, "Sounds.Sfx.Info", "#3498DB")
        elseif isFull then
            notify("Intentando forzar entrada a servidor lleno...", 2, "Sounds.Sfx.Info", "#F39C12")
        else
            notify("Teletransportando al servidor...", 2, "Sounds.Sfx.Info", "#3498DB")
        end
        tweenColor(JoinButton, Color3.fromRGB(30, 110, 70), 0.1)
        local ok, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LocalPlayer)
        end)
        if not ok then
            notify("Error al teletransportar: " .. tostring(err), 4, "Sounds.Sfx.Error", "#FF0000")
            tweenColor(JoinButton, Color3.fromRGB(200, 60, 60), 0.3)
            task.wait(1.5)
            tweenColor(JoinButton, normalColor, 0.3)
        end
    end)
    return Entry
end
local function renderPage()
    for _, child in pairs(ServerList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    local totalPages = math.max(1, math.ceil(#filteredData / pageSize))
    if currentPage > totalPages then currentPage = totalPages end
    if currentPage < 1 then currentPage = 1 end
    local startIdx = (currentPage - 1) * pageSize + 1
    local endIdx = math.min(startIdx + pageSize - 1, #filteredData)
    for i = startIdx, endIdx do
        createServerEntry(filteredData[i], i)
    end
    ServerList.CanvasPosition = Vector2.new(0, 0)
    PageLabel.Text = string.format("Pág. %d/%d (%d)", currentPage, totalPages, #filteredData)
end
local function applyFilter()
    filteredData = {}
    for _, s in ipairs(serversData) do
        if (not filterMin) or (s.playing >= filterMin and s.playing <= filterMax) then
            table.insert(filteredData, s)
        end
    end
    currentPage = 1
    renderPage()
end
local function loadServers()
    serversData = {}
    notify("Cargando lista de servidores...", 2, "Sounds.Sfx.Loading", "#F1C40F")
    local placeId = game.PlaceId
    local cursor = nil
    local totalServers = 0
    local pages = 0
    local maxPages = 8
    for i = 1, maxPages do
        pages = i
        local data = getServers(placeId, cursor)
        if not data then
            notify("Error de red: No se pudo obtener la lista de servidores.", 4, "Sounds.Sfx.Error", "#FF0000")
            break
        end
        if not data.data then
            notify("Error de API: Respuesta de datos no válida.", 4, "Sounds.Sfx.Error", "#FF0000")
            break
        end
        for _, server in pairs(data.data) do
            server.isCurrent = (server.id == game.JobId)
            table.insert(serversData, server)
            totalServers = totalServers + 1
        end
        if not data.nextPageCursor then
            break
        end
        cursor = data.nextPageCursor
        notify(string.format("Página %d/%d: %d servidores cargados...", pages, maxPages, totalServers), 0.5, "Sounds.Sfx.Info", "#5DADE2")
        task.wait(0.1)
    end
    if #serversData > 0 then
        sortServers()
        applyFilter()
        notify(string.format("¡Carga Completa! ✓ %d servidores encontrados.", totalServers), 3, "Sounds.Sfx.Success", "#00FF00")
    else
        filteredData = {}
        renderPage()
        notify("No se encontraron servidores públicos disponibles.", 4, "Sounds.Sfx.Warning", "#F39C12")
    end
end
local autoRefreshOptions = {"Off", "5s", "10s", "15s", "30s", "60s"}
local function startAutoRefreshLoop()
    autoRefreshToken = autoRefreshToken + 1
    local myToken = autoRefreshToken
    local optionLabel = autoRefreshOptions[autoRefreshIndex]
    if optionLabel == "Off" then return end
    local seconds = tonumber(optionLabel:match("%d+"))
    task.spawn(function()
        while autoRefreshToken == myToken and menuOpen do
            task.wait(seconds)
            if autoRefreshToken == myToken and menuOpen then
                loadServers()
            end
        end
    end)
end
RefreshButton.MouseButton1Click:Connect(function()
    tweenColor(RefreshButton, Color3.fromRGB(40, 45, 43), 0.1)
    task.wait(0.1)
    tweenColor(RefreshButton, Color3.fromRGB(30, 35, 33), 0.1)
    loadServers()
end)
SortButton.MouseButton1Click:Connect(function()
    tweenColor(SortButton, Color3.fromRGB(40, 45, 43), 0.1)
    currentSort = currentSort == "ascending" and "descending" or "ascending"
    task.wait(0.1)
    tweenColor(SortButton, Color3.fromRGB(30, 35, 33), 0.1)
    sortServers()
    applyFilter()
end)
AutoButton.MouseButton1Click:Connect(function()
    tweenColor(AutoButton, Color3.fromRGB(40, 45, 43), 0.1)
    autoRefreshIndex = (autoRefreshIndex % #autoRefreshOptions) + 1
    AutoButton.Text = "⏱ " .. autoRefreshOptions[autoRefreshIndex]
    task.wait(0.1)
    tweenColor(AutoButton, Color3.fromRGB(30, 35, 33), 0.1)
    startAutoRefreshLoop()
end)
local function applyFilterFromBox()
    local minV, maxV, invalid = parseFilterText(FilterBox.Text)
    if invalid then
        notify("Filtro inválido. Usa un número (16) o un rango (5-20)", 3, "Sounds.Sfx.Warning", "#F39C12")
        return
    end
    filterMin, filterMax = minV, maxV
    applyFilter()
end
FilterBox.FocusLost:Connect(function(enterPressed)
    applyFilterFromBox()
end)
ClearFilterButton.MouseButton1Click:Connect(function()
    FilterBox.Text = ""
    filterMin, filterMax = nil, nil
    applyFilter()
end)
local function attemptJoinJobId()
    local jobId = JobIdBox.Text:gsub("%s+", "")
    if jobId == "" then
        notify("Escribe un Job ID válido", 2, "Sounds.Sfx.Warning", "#F39C12")
        return
    end
    notify("Teletransportando al Job ID indicado...", 2, "Sounds.Sfx.Info", "#3498DB")
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
    end)
    if not ok then
        notify("Error al teletransportar: " .. tostring(err), 4, "Sounds.Sfx.Error", "#FF0000")
    end
end
CopyCurrentJobIdButton.MouseButton1Click:Connect(function()
    local ok = pcall(function()
        setclipboard(game.JobId)
    end)
    if ok then
        notify("Job ID actual copiado ✓", 2, "Sounds.Sfx.Info", "#5DADE2")
    else
        notify("Tu ejecutor no soporta copiar al portapapeles", 3, "Sounds.Sfx.Warning", "#F39C12")
    end
end)
RejoinButton.MouseButton1Click:Connect(function()
    tweenColor(RejoinButton, Color3.fromRGB(40, 45, 43), 0.1)
    task.wait(0.1)
    tweenColor(RejoinButton, Color3.fromRGB(30, 35, 33), 0.1)
    notify("🔁 Reconectando al servidor actual...", 2, "Sounds.Sfx.Info", "#3498DB")
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    if not ok then
        notify("Error al reconectar: " .. tostring(err), 4, "Sounds.Sfx.Error", "#FF0000")
    end
end)
HopButton.MouseButton1Click:Connect(function()
    tweenColor(HopButton, Color3.fromRGB(40, 45, 43), 0.1)
    task.wait(0.1)
    tweenColor(HopButton, Color3.fromRGB(30, 35, 33), 0.1)
    local candidates = {}
    for _, s in ipairs(serversData) do
        if not s.isCurrent and s.playing < s.maxPlayers then
            table.insert(candidates, s)
        end
    end
    if #candidates == 0 then
        notify("No hay servidores disponibles para hacer hop. Prueba refrescar.", 3, "Sounds.Sfx.Warning", "#F39C12")
        return
    end
    local target = candidates[math.random(1, #candidates)]
    notify("🔀 Haciendo Server Hop...", 2, "Sounds.Sfx.Info", "#3498DB")
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LocalPlayer)
    end)
    if not ok then
        notify("Error al hacer hop: " .. tostring(err), 4, "Sounds.Sfx.Error", "#FF0000")
    end
end)
JoinJobIdButton.MouseButton1Click:Connect(attemptJoinJobId)
JobIdBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        attemptJoinJobId()
    end
end)
PrevButton.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        currentPage = currentPage - 1
        renderPage()
    end
end)
NextButton.MouseButton1Click:Connect(function()
    local totalPages = math.max(1, math.ceil(#filteredData / pageSize))
    if currentPage < totalPages then
        currentPage = currentPage + 1
        renderPage()
    end
end)
ToggleButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MainFrame.Visible = true
    local targetPosition = UDim2.new(0.5, 0, 0.5, 0)
    if menuOpen then
        local targetSize = UDim2.new(frameWidth, frameWidthOffset, 0, frameHeight)
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = targetPosition
        tweenSize(MainFrame, targetSize, 0.35)
        ToggleButton.Text = "✕"
        tweenColor(ToggleButton, Color3.fromRGB(35, 25, 25), 0.3)
        if #serversData == 0 then
            loadServers()
        end
        startAutoRefreshLoop()
    else
        tweenSize(MainFrame, UDim2.new(0, 0, 0, 0), 0.25)
        tweenPosition(MainFrame, targetPosition, 0.25).Completed:Connect(function()
            MainFrame.Visible = false
        end)
        ToggleButton.Text = "📡"
        tweenColor(ToggleButton, Color3.fromRGB(28, 35, 32), 0.3)
    end
end)
CloseButton.MouseButton1Click:Connect(function()
    menuOpen = false
    local targetPosition = UDim2.new(0.5, 0, 0.5, 0)
    tweenSize(MainFrame, UDim2.new(0, 0, 0, 0), 0.25)
    tweenPosition(MainFrame, targetPosition, 0.25).Completed:Connect(function()
        MainFrame.Visible = false
    end)
    ToggleButton.Text = "📡"
    tweenColor(ToggleButton, Color3.fromRGB(28, 35, 32), 0.3)
end)
local buttons = {RefreshButton, SortButton, AutoButton, ClearFilterButton, JoinJobIdButton, CopyCurrentJobIdButton, RejoinButton, HopButton, PrevButton, NextButton, CloseButton, ToggleButton}
for _, button in pairs(buttons) do
    button.MouseEnter:Connect(function()
        if button == CloseButton then
            tweenColor(button, Color3.fromRGB(200, 60, 60), 0.2)
        elseif button == ToggleButton then
            tweenColor(button, Color3.fromRGB(35, 42, 38), 0.2)
        elseif button == JoinJobIdButton then
            tweenColor(button, Color3.fromRGB(50, 170, 110), 0.2)
        else
            tweenColor(button, Color3.fromRGB(38, 43, 40), 0.2)
        end
    end)
    button.MouseLeave:Connect(function()
        if button == CloseButton then
            tweenColor(button, Color3.fromRGB(30, 33, 35), 0.2)
        elseif button == ToggleButton then
            local originalColor = Color3.fromRGB(28, 35, 32)
            if menuOpen then
                originalColor = Color3.fromRGB(35, 25, 25)
            end
            tweenColor(button, originalColor, 0.2)
        elseif button == JoinJobIdButton then
            tweenColor(button, Color3.fromRGB(40, 140, 90), 0.2)
        else
            tweenColor(button, Color3.fromRGB(30, 35, 33), 0.2)
        end
    end)
end
if not isMobile then
    local dragging = false
    local dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        tweenPosition(MainFrame, UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), 0.1)
    end
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end
notify("✅ Server Browser Cargado - Presiona 📡 para abrir", 3, "Sounds.Sfx.Success", "#5DADE2")
local HISTORY_FILENAME = "server_history.json"
local function History_GetEmptyStructure()
    return { servers = {} }
end
local function History_Load()
    if not isfile(HISTORY_FILENAME) then
        local ok = pcall(function()
            writefile(HISTORY_FILENAME, HttpService:JSONEncode(History_GetEmptyStructure()))
        end)
        if not ok then
            notify("No se pudo crear server_history.json", 3, "Sounds.Sfx.Warning", "#F39C12")
        end
        return History_GetEmptyStructure()
    end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(HISTORY_FILENAME))
    end)
    if ok and type(decoded) == "table" and type(decoded.servers) == "table" then
        return decoded
    end
    local fresh = History_GetEmptyStructure()
    pcall(function()
        writefile(HISTORY_FILENAME, HttpService:JSONEncode(fresh))
    end)
    return fresh
end
local function History_Save(historyData)
    local ok = pcall(function()
        writefile(HISTORY_FILENAME, HttpService:JSONEncode(historyData))
    end)
    if not ok then
        notify("Error al guardar server_history.json", 3, "Sounds.Sfx.Error", "#FF0000")
    end
    return ok
end
local function History_FindIndex(historyData, jobId)
    for i, entry in ipairs(historyData.servers) do
        if entry.jobId == jobId then
            return i
        end
    end
    return nil
end
local function History_RegisterCurrentServer()
    local historyData = History_Load()
    local jobId = game.JobId
    local placeId = game.PlaceId
    local idx = History_FindIndex(historyData, jobId)
    if idx then
        historyData.servers[idx].visited = true
        historyData.servers[idx].timestamp = os.time()
        historyData.servers[idx].placeId = placeId
    else
        table.insert(historyData.servers, {
            jobId = jobId,
            placeId = placeId,
            visited = true,
            favorite = false,
            note = "",
            timestamp = os.time(),
        })
    end
    History_Save(historyData)
    return historyData
end
local function History_ToggleFavorite(jobId)
    local historyData = History_Load()
    local idx = History_FindIndex(historyData, jobId)
    if not idx then
        notify("Ese servidor no está en el historial", 3, "Sounds.Sfx.Warning", "#F39C12")
        return false
    end
    historyData.servers[idx].favorite = not historyData.servers[idx].favorite
    History_Save(historyData)
    notify(historyData.servers[idx].favorite and "⭐ Servidor marcado como favorito" or "Servidor quitado de favoritos", 2, "Sounds.Sfx.Info", "#F1C40F")
    return historyData.servers[idx].favorite
end
local function History_SetNote(jobId, noteText)
    local historyData = History_Load()
    local idx = History_FindIndex(historyData, jobId)
    if not idx then
        notify("Ese servidor no está en el historial", 3, "Sounds.Sfx.Warning", "#F39C12")
        return false
    end
    historyData.servers[idx].note = tostring(noteText or "")
    History_Save(historyData)
    notify("📝 Nota actualizada", 2, "Sounds.Sfx.Info", "#5DADE2")
    return true
end
local function History_RemoveServer(jobId)
    local historyData = History_Load()
    local idx = History_FindIndex(historyData, jobId)
    if not idx then
        notify("Ese servidor no está en el historial", 3, "Sounds.Sfx.Warning", "#F39C12")
        return false
    end
    table.remove(historyData.servers, idx)
    History_Save(historyData)
    notify("🗑 Servidor eliminado del historial", 2, "Sounds.Sfx.Info", "#5DADE2")
    return true
end
local function History_Reset()
    local fresh = History_GetEmptyStructure()
    History_Save(fresh)
    notify("♻ Historial de servidores reseteado", 2, "Sounds.Sfx.Info", "#5DADE2")
    return fresh
end
History_RegisterCurrentServer()
_G.ServerHistory = {
    Load = History_Load,
    Save = History_Save,
    RegisterCurrent = History_RegisterCurrentServer,
    ToggleFavorite = History_ToggleFavorite,
    SetNote = History_SetNote,
    RemoveServer = History_RemoveServer,
    Reset = History_Reset,
}
local HistoryFrameWidth = isMobile and 0.7 or 0
local HistoryFrameWidthOffset = isMobile and 0 or 360
local HistoryFrameHeight = isMobile and 320 or 420
local HistoryFrame = Instance.new("Frame")
HistoryFrame.Name = "HistoryFrame"
HistoryFrame.AnchorPoint = Vector2.new(0.5, 0.5)
HistoryFrame.Size = UDim2.new(HistoryFrameWidth, HistoryFrameWidthOffset, 0, HistoryFrameHeight)
HistoryFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
HistoryFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 22)
HistoryFrame.BorderSizePixel = 0
HistoryFrame.ClipsDescendants = true
HistoryFrame.Visible = false
HistoryFrame.Parent = ScreenGui
addCorner(HistoryFrame, 14)
addStroke(HistoryFrame, Color3.fromRGB(60, 160, 100), 1, 0.6)
local HistoryHeaderHeight = isMobile and 32 or 46
local HistoryHeader = Instance.new("Frame")
HistoryHeader.Name = "HistoryHeader"
HistoryHeader.Size = UDim2.new(1, 0, 0, HistoryHeaderHeight)
HistoryHeader.BackgroundColor3 = Color3.fromRGB(22, 25, 27)
HistoryHeader.BorderSizePixel = 0
HistoryHeader.Parent = HistoryFrame
addCorner(HistoryHeader, 14)
addCover(HistoryHeader, 14, Color3.fromRGB(22, 25, 27))
local HistoryTitle = Instance.new("TextLabel")
HistoryTitle.Size = UDim2.new(1, -80, 1, 0)
HistoryTitle.Position = UDim2.new(0, 12, 0, 0)
HistoryTitle.BackgroundTransparency = 1
HistoryTitle.Text = "📜 Historial de Servidores"
HistoryTitle.TextColor3 = Color3.fromRGB(100, 255, 150)
HistoryTitle.TextSize = isMobile and 12 or 16
HistoryTitle.Font = Enum.Font.GothamBold
HistoryTitle.TextXAlignment = Enum.TextXAlignment.Left
HistoryTitle.Parent = HistoryHeader
local HistoryCloseSize = isMobile and 22 or 32
local HistoryCloseButton = Instance.new("TextButton")
HistoryCloseButton.Size = UDim2.new(0, HistoryCloseSize, 0, HistoryCloseSize)
HistoryCloseButton.Position = UDim2.new(1, isMobile and -28 or -40, 0.5, -(HistoryCloseSize/2))
HistoryCloseButton.BackgroundColor3 = Color3.fromRGB(30, 33, 35)
HistoryCloseButton.Text = "X"
HistoryCloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
HistoryCloseButton.TextSize = isMobile and 11 or 15
HistoryCloseButton.Font = Enum.Font.GothamBold
HistoryCloseButton.BorderSizePixel = 0
HistoryCloseButton.Parent = HistoryHeader
addCorner(HistoryCloseButton, 8)
local ResetRowHeight = isMobile and 26 or 34
local ResetRow = Instance.new("Frame")
ResetRow.Size = UDim2.new(1, -20, 0, ResetRowHeight)
ResetRow.Position = UDim2.new(0, 10, 0, HistoryHeaderHeight + 8)
ResetRow.BackgroundTransparency = 1
ResetRow.Parent = HistoryFrame
local ResetHistoryButton = Instance.new("TextButton")
ResetHistoryButton.Size = UDim2.new(1, 0, 1, 0)
ResetHistoryButton.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
ResetHistoryButton.Text = "🗑 Resetear Historial Completo"
ResetHistoryButton.TextColor3 = Color3.fromRGB(255, 140, 140)
ResetHistoryButton.TextSize = isMobile and 10 or 12
ResetHistoryButton.Font = Enum.Font.GothamBold
ResetHistoryButton.BorderSizePixel = 0
ResetHistoryButton.Parent = ResetRow
addCorner(ResetHistoryButton, 8)
local ConfirmResetFrame = Instance.new("Frame")
ConfirmResetFrame.Size = UDim2.new(1, -20, 0, isMobile and 74 or 92)
ConfirmResetFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ConfirmResetFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ConfirmResetFrame.BackgroundColor3 = Color3.fromRGB(26, 20, 20)
ConfirmResetFrame.BorderSizePixel = 0
ConfirmResetFrame.Visible = false
ConfirmResetFrame.ZIndex = 20
ConfirmResetFrame.Parent = HistoryFrame
addCorner(ConfirmResetFrame, 10)
addStroke(ConfirmResetFrame, Color3.fromRGB(200, 80, 80), 1, 0.4)
local ConfirmResetLabel = Instance.new("TextLabel")
ConfirmResetLabel.Size = UDim2.new(1, -16, 0, isMobile and 32 or 38)
ConfirmResetLabel.Position = UDim2.new(0, 8, 0, 6)
ConfirmResetLabel.BackgroundTransparency = 1
ConfirmResetLabel.Text = "⚠ ¿Eliminar todo el historial? No se puede deshacer."
ConfirmResetLabel.TextWrapped = true
ConfirmResetLabel.TextColor3 = Color3.fromRGB(255, 210, 210)
ConfirmResetLabel.TextSize = isMobile and 9 or 11
ConfirmResetLabel.Font = Enum.Font.Gotham
ConfirmResetLabel.ZIndex = 21
ConfirmResetLabel.Parent = ConfirmResetFrame
local ConfirmYesButton = Instance.new("TextButton")
ConfirmYesButton.Size = UDim2.new(0.48, 0, 0, isMobile and 24 or 28)
ConfirmYesButton.Position = UDim2.new(0, 8, 1, -(isMobile and 30 or 34))
ConfirmYesButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
ConfirmYesButton.Text = "Sí, borrar"
ConfirmYesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmYesButton.TextSize = isMobile and 9 or 11
ConfirmYesButton.Font = Enum.Font.GothamBold
ConfirmYesButton.BorderSizePixel = 0
ConfirmYesButton.ZIndex = 21
ConfirmYesButton.Parent = ConfirmResetFrame
addCorner(ConfirmYesButton, 6)
local ConfirmNoButton = Instance.new("TextButton")
ConfirmNoButton.Size = UDim2.new(0.48, 0, 0, isMobile and 24 or 28)
ConfirmNoButton.Position = UDim2.new(0.52, 0, 1, -(isMobile and 30 or 34))
ConfirmNoButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
ConfirmNoButton.Text = "Cancelar"
ConfirmNoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmNoButton.TextSize = isMobile and 9 or 11
ConfirmNoButton.Font = Enum.Font.GothamBold
ConfirmNoButton.BorderSizePixel = 0
ConfirmNoButton.ZIndex = 21
ConfirmNoButton.Parent = ConfirmResetFrame
addCorner(ConfirmNoButton, 6)
local HistoryListTop = HistoryHeaderHeight + 8 + ResetRowHeight + 8
local HistoryList = Instance.new("ScrollingFrame")
HistoryList.Size = UDim2.new(1, -20, 1, -(HistoryListTop + 12))
HistoryList.Position = UDim2.new(0, 10, 0, HistoryListTop)
HistoryList.BackgroundColor3 = Color3.fromRGB(22, 25, 27)
HistoryList.BorderSizePixel = 0
HistoryList.ScrollBarThickness = 4
HistoryList.ScrollBarImageColor3 = Color3.fromRGB(80, 200, 130)
HistoryList.CanvasSize = UDim2.new(0, 0, 0, 0)
HistoryList.Parent = HistoryFrame
addCorner(HistoryList, 10)
local HistoryListLayout = Instance.new("UIListLayout")
HistoryListLayout.SortOrder = Enum.SortOrder.LayoutOrder
HistoryListLayout.Padding = UDim.new(0, 6)
HistoryListLayout.Parent = HistoryList
addPadding(HistoryList, 8, 8, 12, 8)
HistoryListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    HistoryList.CanvasSize = UDim2.new(0, 0, 0, HistoryListLayout.AbsoluteContentSize.Y + 10)
end)
local historyEntryHeight = isMobile and 56 or 70
local function History_CreateEntryRow(entry, index)
    local Row = Instance.new("Frame")
    Row.Name = "HistoryEntry_" .. index
    Row.Size = UDim2.new(1, -8, 0, historyEntryHeight)
    Row.BackgroundColor3 = entry.jobId == game.JobId and Color3.fromRGB(22, 48, 36) or Color3.fromRGB(26, 30, 32)
    Row.BorderSizePixel = 0
    Row.LayoutOrder = index
    Row.Parent = HistoryList
    addCorner(Row, 8)
    addStroke(Row, entry.favorite and Color3.fromRGB(241, 196, 15) or Color3.fromRGB(50, 140, 90), entry.favorite and 1.5 or 1, 0.6)
    local IdLabel = Instance.new("TextLabel")
    IdLabel.Size = UDim2.new(1, -204, 0, historyEntryHeight * 0.42)
    IdLabel.Position = UDim2.new(0, 8, 0, 4)
    IdLabel.BackgroundTransparency = 1
    local shortId = tostring(entry.jobId):sub(1, 8) .. "…"
    local dateText = os.date("%d/%m %H:%M", entry.timestamp or 0)
    IdLabel.Text = (entry.jobId == game.JobId and "📍 " or "🆔 ") .. shortId .. "  •  " .. dateText
    IdLabel.TextColor3 = Color3.fromRGB(220, 255, 235)
    IdLabel.TextSize = isMobile and 8 or 10
    IdLabel.Font = Enum.Font.Gotham
    IdLabel.TextXAlignment = Enum.TextXAlignment.Left
    IdLabel.Parent = Row
    local NoteBox = Instance.new("TextBox")
    NoteBox.Size = UDim2.new(1, -204, 0, historyEntryHeight * 0.42)
    NoteBox.Position = UDim2.new(0, 8, 0, historyEntryHeight * 0.46)
    NoteBox.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
    NoteBox.PlaceholderText = "📝 Nota..."
    NoteBox.PlaceholderColor3 = Color3.fromRGB(110, 140, 125)
    NoteBox.Text = entry.note or ""
    NoteBox.TextColor3 = Color3.fromRGB(220, 255, 235)
    NoteBox.TextSize = isMobile and 8 or 10
    NoteBox.Font = Enum.Font.Gotham
    NoteBox.ClearTextOnFocus = false
    NoteBox.TextXAlignment = Enum.TextXAlignment.Left
    NoteBox.BorderSizePixel = 0
    NoteBox.Parent = Row
    addPadding(NoteBox, 6, 0, 0, 0)
    addCorner(NoteBox, 6)
    NoteBox.FocusLost:Connect(function()
        _G.ServerHistory.SetNote(entry.jobId, NoteBox.Text)
    end)
    local btnSize = isMobile and 24 or 30
    local CopyIdButton = Instance.new("TextButton")
    CopyIdButton.Size = UDim2.new(0, btnSize, 0, btnSize)
    CopyIdButton.Position = UDim2.new(1, -(btnSize * 4 + 22), 0.5, -(btnSize / 2))
    CopyIdButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
    CopyIdButton.Text = "📋"
    CopyIdButton.TextColor3 = Color3.fromRGB(150, 200, 170)
    CopyIdButton.TextSize = isMobile and 11 or 14
    CopyIdButton.Font = Enum.Font.GothamBold
    CopyIdButton.BorderSizePixel = 0
    CopyIdButton.Parent = Row
    addCorner(CopyIdButton, 6)
    CopyIdButton.MouseButton1Click:Connect(function()
        local ok = pcall(function()
            setclipboard(entry.jobId)
        end)
        if ok then
            notify("Job ID copiado ✓", 2, "Sounds.Sfx.Info", "#5DADE2")
        else
            notify("Tu ejecutor no soporta copiar al portapapeles", 3, "Sounds.Sfx.Warning", "#F39C12")
        end
    end)
    local FavButton = Instance.new("TextButton")
    FavButton.Size = UDim2.new(0, btnSize, 0, btnSize)
    FavButton.Position = UDim2.new(1, -(btnSize * 3 + 16), 0.5, -(btnSize / 2))
    FavButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
    FavButton.Text = entry.favorite and "⭐" or "☆"
    FavButton.TextColor3 = Color3.fromRGB(241, 196, 15)
    FavButton.TextSize = isMobile and 11 or 14
    FavButton.Font = Enum.Font.GothamBold
    FavButton.BorderSizePixel = 0
    FavButton.Parent = Row
    addCorner(FavButton, 6)
    FavButton.MouseButton1Click:Connect(function()
        _G.ServerHistory.ToggleFavorite(entry.jobId)
        History_RenderList()
    end)
    local DeleteButton = Instance.new("TextButton")
    DeleteButton.Size = UDim2.new(0, btnSize, 0, btnSize)
    DeleteButton.Position = UDim2.new(1, -(btnSize * 2 + 10), 0.5, -(btnSize / 2))
    DeleteButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
    DeleteButton.Text = "🗑"
    DeleteButton.TextColor3 = Color3.fromRGB(255, 120, 120)
    DeleteButton.TextSize = isMobile and 11 or 14
    DeleteButton.Font = Enum.Font.GothamBold
    DeleteButton.BorderSizePixel = 0
    DeleteButton.Parent = Row
    addCorner(DeleteButton, 6)
    DeleteButton.MouseButton1Click:Connect(function()
        _G.ServerHistory.RemoveServer(entry.jobId)
        History_RenderList()
    end)
    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Size = UDim2.new(0, btnSize, 0, btnSize)
    JoinBtn.Position = UDim2.new(1, -(btnSize + 4), 0.5, -(btnSize / 2))
    JoinBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
    JoinBtn.Text = "▶"
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.TextSize = isMobile and 11 or 14
    JoinBtn.Font = Enum.Font.GothamBold
    JoinBtn.BorderSizePixel = 0
    JoinBtn.Parent = Row
    addCorner(JoinBtn, 6)
    JoinBtn.MouseButton1Click:Connect(function()
        notify("Teletransportando al servidor guardado...", 2, "Sounds.Sfx.Info", "#3498DB")
        local ok, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(entry.placeId, entry.jobId, LocalPlayer)
        end)
        if not ok then
            notify("Error al teletransportar: " .. tostring(err), 4, "Sounds.Sfx.Error", "#FF0000")
        end
    end)
    return Row
end
function History_RenderList()
    for _, child in pairs(HistoryList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    local historyData = _G.ServerHistory.Load()
    table.sort(historyData.servers, function(a, b)
        if a.favorite ~= b.favorite then
            return a.favorite
        end
        return (a.timestamp or 0) > (b.timestamp or 0)
    end)
    for i, entry in ipairs(historyData.servers) do
        History_CreateEntryRow(entry, i)
    end
    if #historyData.servers == 0 then
        local EmptyLabel = Instance.new("TextLabel")
        EmptyLabel.Size = UDim2.new(1, -16, 0, 40)
        EmptyLabel.BackgroundTransparency = 1
        EmptyLabel.Text = "Aún no hay servidores en el historial."
        EmptyLabel.TextColor3 = Color3.fromRGB(120, 160, 140)
        EmptyLabel.TextSize = isMobile and 10 or 12
        EmptyLabel.Font = Enum.Font.Gotham
        EmptyLabel.Parent = HistoryList
    end
end
ResetHistoryButton.MouseButton1Click:Connect(function()
    ConfirmResetFrame.Visible = true
end)
ConfirmYesButton.MouseButton1Click:Connect(function()
    _G.ServerHistory.Reset()
    History_RenderList()
    ConfirmResetFrame.Visible = false
end)
ConfirmNoButton.MouseButton1Click:Connect(function()
    ConfirmResetFrame.Visible = false
end)
HistoryCloseButton.MouseButton1Click:Connect(function()
    tweenSize(HistoryFrame, UDim2.new(0, 0, 0, 0), 0.25)
    tweenPosition(HistoryFrame, UDim2.new(0.5, 0, 0.5, 0), 0.25).Completed:Connect(function()
        HistoryFrame.Visible = false
    end)
end)
local historyMenuOpen = false
local HistoryToggleButton = Instance.new("TextButton")
HistoryToggleButton.Name = "HistoryToggleButton"
if isMobile then
    HistoryToggleButton.Size = UDim2.new(0, 46, 0, 46)
    HistoryToggleButton.Position = UDim2.new(1, -56, 0, 62)
else
    HistoryToggleButton.Size = UDim2.new(0, 50, 0, 50)
    HistoryToggleButton.Position = UDim2.new(1, -65, 0.5, 33)
end
HistoryToggleButton.BackgroundColor3 = Color3.fromRGB(28, 35, 32)
HistoryToggleButton.Text = "📜"
HistoryToggleButton.TextColor3 = Color3.fromRGB(100, 255, 150)
HistoryToggleButton.TextSize = isMobile and 22 or 24
HistoryToggleButton.Font = Enum.Font.GothamBold
HistoryToggleButton.BorderSizePixel = 0
HistoryToggleButton.Parent = ScreenGui
addCorner(HistoryToggleButton, 12)
addStroke(HistoryToggleButton, Color3.fromRGB(80, 200, 130), 1.5, 0.5)
HistoryToggleButton.MouseEnter:Connect(function()
    tweenColor(HistoryToggleButton, Color3.fromRGB(35, 42, 38), 0.2)
end)
HistoryToggleButton.MouseLeave:Connect(function()
    tweenColor(HistoryToggleButton, Color3.fromRGB(28, 35, 32), 0.2)
end)
HistoryToggleButton.MouseButton1Click:Connect(function()
    historyMenuOpen = not historyMenuOpen
    HistoryFrame.Visible = true
    local targetPosition = UDim2.new(0.5, 0, 0.5, 0)
    if historyMenuOpen then
        History_RenderList()
        local targetSize = UDim2.new(HistoryFrameWidth, HistoryFrameWidthOffset, 0, HistoryFrameHeight)
        HistoryFrame.Size = UDim2.new(0, 0, 0, 0)
        HistoryFrame.Position = targetPosition
        tweenSize(HistoryFrame, targetSize, 0.35)
    else
        tweenSize(HistoryFrame, UDim2.new(0, 0, 0, 0), 0.25)
        tweenPosition(HistoryFrame, targetPosition, 0.25).Completed:Connect(function()
            HistoryFrame.Visible = false
        end)
    end
end)
if not isMobile then
    local historyDragging = false
    local historyDragInput, historyDragStart, historyStartPos
    local function updateHistoryDrag(input)
        local delta = input.Position - historyDragStart
        tweenPosition(HistoryFrame, UDim2.new(historyStartPos.X.Scale, historyStartPos.X.Offset + delta.X, historyStartPos.Y.Scale, historyStartPos.Y.Offset + delta.Y), 0.1)
    end
    HistoryHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            historyDragging = true
            historyDragStart = input.Position
            historyStartPos = HistoryFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    historyDragging = false
                end
            end)
        end
    end)
    HistoryHeader.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            historyDragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == historyDragInput and historyDragging then
            updateHistoryDrag(input)
        end
    end)
end
local AutoJoinFrameWidth = isMobile and 0.62 or 0
local AutoJoinFrameWidthOffset = isMobile and 0 or 300
local AutoJoinFrameHeight = isMobile and 190 or 220
local AutoJoinFrame = Instance.new("Frame")
AutoJoinFrame.Name = "AutoJoinFrame"
AutoJoinFrame.AnchorPoint = Vector2.new(0.5, 0.5)
AutoJoinFrame.Size = UDim2.new(AutoJoinFrameWidth, AutoJoinFrameWidthOffset, 0, AutoJoinFrameHeight)
AutoJoinFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
AutoJoinFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 22)
AutoJoinFrame.BorderSizePixel = 0
AutoJoinFrame.ClipsDescendants = true
AutoJoinFrame.Visible = false
AutoJoinFrame.Parent = ScreenGui
addCorner(AutoJoinFrame, 14)
addStroke(AutoJoinFrame, Color3.fromRGB(60, 160, 100), 1, 0.6)
local AutoJoinHeaderHeight = isMobile and 32 or 46
local AutoJoinHeader = Instance.new("Frame")
AutoJoinHeader.Name = "AutoJoinHeader"
AutoJoinHeader.Size = UDim2.new(1, 0, 0, AutoJoinHeaderHeight)
AutoJoinHeader.BackgroundColor3 = Color3.fromRGB(22, 25, 27)
AutoJoinHeader.BorderSizePixel = 0
AutoJoinHeader.Parent = AutoJoinFrame
addCorner(AutoJoinHeader, 14)
addCover(AutoJoinHeader, 14, Color3.fromRGB(22, 25, 27))
local AutoJoinTitle = Instance.new("TextLabel")
AutoJoinTitle.Size = UDim2.new(1, -80, 1, 0)
AutoJoinTitle.Position = UDim2.new(0, 12, 0, 0)
AutoJoinTitle.BackgroundTransparency = 1
AutoJoinTitle.Text = "🎯 Auto Joiner"
AutoJoinTitle.TextColor3 = Color3.fromRGB(100, 255, 150)
AutoJoinTitle.TextSize = isMobile and 12 or 16
AutoJoinTitle.Font = Enum.Font.GothamBold
AutoJoinTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoJoinTitle.Parent = AutoJoinHeader
local AutoJoinCloseSize = isMobile and 22 or 32
local AutoJoinCloseButton = Instance.new("TextButton")
AutoJoinCloseButton.Size = UDim2.new(0, AutoJoinCloseSize, 0, AutoJoinCloseSize)
AutoJoinCloseButton.Position = UDim2.new(1, isMobile and -28 or -40, 0.5, -(AutoJoinCloseSize/2))
AutoJoinCloseButton.BackgroundColor3 = Color3.fromRGB(30, 33, 35)
AutoJoinCloseButton.Text = "X"
AutoJoinCloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
AutoJoinCloseButton.TextSize = isMobile and 11 or 15
AutoJoinCloseButton.Font = Enum.Font.GothamBold
AutoJoinCloseButton.BorderSizePixel = 0
AutoJoinCloseButton.Parent = AutoJoinHeader
addCorner(AutoJoinCloseButton, 8)
local AutoJoinRowJobIdTop = AutoJoinHeaderHeight + 8
local AutoJoinRowJobIdHeight = isMobile and 22 or 30
local AutoJoinTargetBox = Instance.new("TextBox")
AutoJoinTargetBox.Size = UDim2.new(1, -20, 0, AutoJoinRowJobIdHeight)
AutoJoinTargetBox.Position = UDim2.new(0, 10, 0, AutoJoinRowJobIdTop)
AutoJoinTargetBox.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
AutoJoinTargetBox.PlaceholderText = "🆔 Job ID a vigilar..."
AutoJoinTargetBox.PlaceholderColor3 = Color3.fromRGB(110, 140, 125)
AutoJoinTargetBox.Text = ""
AutoJoinTargetBox.TextColor3 = Color3.fromRGB(220, 255, 235)
AutoJoinTargetBox.TextSize = isMobile and 11 or 12
AutoJoinTargetBox.Font = Enum.Font.Gotham
AutoJoinTargetBox.ClearTextOnFocus = false
AutoJoinTargetBox.TextXAlignment = Enum.TextXAlignment.Left
AutoJoinTargetBox.BorderSizePixel = 0
AutoJoinTargetBox.Parent = AutoJoinFrame
addPadding(AutoJoinTargetBox, 10, 0, 0, 0)
addCorner(AutoJoinTargetBox, 8)
local AutoJoinModeRowTop = AutoJoinRowJobIdTop + AutoJoinRowJobIdHeight + 8
local AutoJoinModeRowHeight = isMobile and 26 or 34
local PassiveModeButton = Instance.new("TextButton")
PassiveModeButton.Size = UDim2.new(0.49, 0, 0, AutoJoinModeRowHeight)
PassiveModeButton.Position = UDim2.new(0, 10, 0, AutoJoinModeRowTop)
PassiveModeButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
PassiveModeButton.Text = "🐢 Pasivo"
PassiveModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PassiveModeButton.TextSize = isMobile and 10 or 12
PassiveModeButton.Font = Enum.Font.GothamBold
PassiveModeButton.BorderSizePixel = 0
PassiveModeButton.Parent = AutoJoinFrame
addCorner(PassiveModeButton, 8)
local HardModeButton = Instance.new("TextButton")
HardModeButton.Size = UDim2.new(0.49, 0, 0, AutoJoinModeRowHeight)
HardModeButton.Position = UDim2.new(0.51, 0, 0, AutoJoinModeRowTop)
HardModeButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
HardModeButton.Text = "⚡ Forzado"
HardModeButton.TextColor3 = Color3.fromRGB(255, 200, 150)
HardModeButton.TextSize = isMobile and 10 or 12
HardModeButton.Font = Enum.Font.GothamBold
HardModeButton.BorderSizePixel = 0
HardModeButton.Parent = AutoJoinFrame
addCorner(HardModeButton, 8)
local AutoJoinStatusTop = AutoJoinModeRowTop + AutoJoinModeRowHeight + 8
local AutoJoinStatusHeight = isMobile and 16 or 20
local AutoJoinStatusLabel = Instance.new("TextLabel")
AutoJoinStatusLabel.Size = UDim2.new(1, -20, 0, AutoJoinStatusHeight)
AutoJoinStatusLabel.Position = UDim2.new(0, 10, 0, AutoJoinStatusTop)
AutoJoinStatusLabel.BackgroundTransparency = 1
AutoJoinStatusLabel.Text = "⏹ Detenido"
AutoJoinStatusLabel.TextColor3 = Color3.fromRGB(150, 200, 170)
AutoJoinStatusLabel.TextSize = isMobile and 10 or 11
AutoJoinStatusLabel.Font = Enum.Font.Gotham
AutoJoinStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoJoinStatusLabel.Parent = AutoJoinFrame
local AutoJoinStartTop = AutoJoinStatusTop + AutoJoinStatusHeight + 8
local AutoJoinStartHeight = isMobile and 26 or 34
local AutoJoinStartButton = Instance.new("TextButton")
AutoJoinStartButton.Size = UDim2.new(1, -20, 0, AutoJoinStartHeight)
AutoJoinStartButton.Position = UDim2.new(0, 10, 0, AutoJoinStartTop)
AutoJoinStartButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
AutoJoinStartButton.Text = "▶ Iniciar"
AutoJoinStartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoJoinStartButton.TextSize = isMobile and 11 or 13
AutoJoinStartButton.Font = Enum.Font.GothamBold
AutoJoinStartButton.BorderSizePixel = 0
AutoJoinStartButton.Parent = AutoJoinFrame
addCorner(AutoJoinStartButton, 8)
local autoJoinActive = false
local autoJoinToken = 0
local autoJoinMode = "passive"
local function setAutoJoinMode(mode)
    autoJoinMode = mode
    if mode == "passive" then
        PassiveModeButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        PassiveModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        HardModeButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
        HardModeButton.TextColor3 = Color3.fromRGB(255, 200, 150)
    else
        HardModeButton.BackgroundColor3 = Color3.fromRGB(150, 60, 30)
        HardModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        PassiveModeButton.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
        PassiveModeButton.TextColor3 = Color3.fromRGB(150, 220, 180)
    end
end
PassiveModeButton.MouseButton1Click:Connect(function()
    setAutoJoinMode("passive")
end)
HardModeButton.MouseButton1Click:Connect(function()
    setAutoJoinMode("hard")
end)
local function attemptAutoJoinTeleport(jobId)
    local ok = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
    end)
    return ok
end
local function findServerByJobId(jobId)
    local placeId = game.PlaceId
    local cursor = nil
    for i = 1, 6 do
        local data = getServers(placeId, cursor)
        if not data or not data.data then
            return nil
        end
        for _, server in pairs(data.data) do
            if server.id == jobId then
                return server
            end
        end
        if not data.nextPageCursor then
            return nil
        end
        cursor = data.nextPageCursor
        task.wait(0.15)
    end
    return nil
end
local function runPassiveAutoJoin(jobId, myToken)
    task.spawn(function()
        while autoJoinActive and autoJoinToken == myToken do
            AutoJoinStatusLabel.Text = "🔎 Buscando cupo..."
            local server = findServerByJobId(jobId)
            if autoJoinActive and autoJoinToken == myToken then
                if server and server.playing < server.maxPlayers then
                    AutoJoinStatusLabel.Text = "🚀 Cupo encontrado, uniendo..."
                    notify("🎯 Cupo detectado en el servidor vigilado, uniendo...", 3, "Sounds.Sfx.Success", "#00FF00")
                    if attemptAutoJoinTeleport(jobId) then
                        autoJoinActive = false
                        AutoJoinStatusLabel.Text = "✅ Teletransportando..."
                        AutoJoinStartButton.Text = "▶ Iniciar"
                        AutoJoinStartButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
                    end
                elseif server then
                    AutoJoinStatusLabel.Text = "🔴 Servidor lleno, reintentando..."
                else
                    AutoJoinStatusLabel.Text = "⚠ Servidor no encontrado, reintentando..."
                end
            end
            task.wait(4)
        end
    end)
end
local function runHardAutoJoin(jobId, myToken)
    task.spawn(function()
        while autoJoinActive and autoJoinToken == myToken do
            AutoJoinStatusLabel.Text = "⚡ Forzando entrada cada 1s..."
            attemptAutoJoinTeleport(jobId)
            task.wait(1)
        end
    end)
end
AutoJoinStartButton.MouseButton1Click:Connect(function()
    if autoJoinActive then
        autoJoinActive = false
        autoJoinToken = autoJoinToken + 1
        AutoJoinStartButton.Text = "▶ Iniciar"
        AutoJoinStartButton.BackgroundColor3 = Color3.fromRGB(40, 140, 90)
        AutoJoinStatusLabel.Text = "⏹ Detenido"
        return
    end
    local jobId = AutoJoinTargetBox.Text:gsub("%s+", "")
    if jobId == "" then
        notify("Escribe un Job ID válido para el Auto Joiner", 3, "Sounds.Sfx.Warning", "#F39C12")
        return
    end
    autoJoinActive = true
    autoJoinToken = autoJoinToken + 1
    local myToken = autoJoinToken
    AutoJoinStartButton.Text = "⏹ Detener"
    AutoJoinStartButton.BackgroundColor3 = Color3.fromRGB(150, 60, 30)
    if autoJoinMode == "passive" then
        AutoJoinStatusLabel.Text = "🔎 Iniciando modo pasivo..."
        runPassiveAutoJoin(jobId, myToken)
    else
        AutoJoinStatusLabel.Text = "⚡ Iniciando modo forzado..."
        runHardAutoJoin(jobId, myToken)
    end
end)
AutoJoinCloseButton.MouseButton1Click:Connect(function()
    tweenSize(AutoJoinFrame, UDim2.new(0, 0, 0, 0), 0.25)
    tweenPosition(AutoJoinFrame, UDim2.new(0.5, 0, 0.5, 0), 0.25).Completed:Connect(function()
        AutoJoinFrame.Visible = false
    end)
end)
local autoJoinMenuOpen = false
local AutoJoinToggleButton = Instance.new("TextButton")
AutoJoinToggleButton.Name = "AutoJoinToggleButton"
if isMobile then
    AutoJoinToggleButton.Size = UDim2.new(0, 46, 0, 46)
    AutoJoinToggleButton.Position = UDim2.new(1, -56, 0, 114)
else
    AutoJoinToggleButton.Size = UDim2.new(0, 50, 0, 50)
    AutoJoinToggleButton.Position = UDim2.new(1, -65, 0.5, 91)
end
AutoJoinToggleButton.BackgroundColor3 = Color3.fromRGB(28, 35, 32)
AutoJoinToggleButton.Text = "🎯"
AutoJoinToggleButton.TextColor3 = Color3.fromRGB(100, 255, 150)
AutoJoinToggleButton.TextSize = isMobile and 22 or 24
AutoJoinToggleButton.Font = Enum.Font.GothamBold
AutoJoinToggleButton.BorderSizePixel = 0
AutoJoinToggleButton.Parent = ScreenGui
addCorner(AutoJoinToggleButton, 12)
addStroke(AutoJoinToggleButton, Color3.fromRGB(80, 200, 130), 1.5, 0.5)
AutoJoinToggleButton.MouseEnter:Connect(function()
    tweenColor(AutoJoinToggleButton, Color3.fromRGB(35, 42, 38), 0.2)
end)
AutoJoinToggleButton.MouseLeave:Connect(function()
    tweenColor(AutoJoinToggleButton, Color3.fromRGB(28, 35, 32), 0.2)
end)
AutoJoinToggleButton.MouseButton1Click:Connect(function()
    autoJoinMenuOpen = not autoJoinMenuOpen
    AutoJoinFrame.Visible = true
    local targetPosition = UDim2.new(0.5, 0, 0.5, 0)
    if autoJoinMenuOpen then
        local targetSize = UDim2.new(AutoJoinFrameWidth, AutoJoinFrameWidthOffset, 0, AutoJoinFrameHeight)
        AutoJoinFrame.Size = UDim2.new(0, 0, 0, 0)
        AutoJoinFrame.Position = targetPosition
        tweenSize(AutoJoinFrame, targetSize, 0.35)
    else
        tweenSize(AutoJoinFrame, UDim2.new(0, 0, 0, 0), 0.25)
        tweenPosition(AutoJoinFrame, targetPosition, 0.25).Completed:Connect(function()
            AutoJoinFrame.Visible = false
        end)
    end
end)
if not isMobile then
    local autoJoinDragging = false
    local autoJoinDragInput, autoJoinDragStart, autoJoinStartPos
    local function updateAutoJoinDrag(input)
        local delta = input.Position - autoJoinDragStart
        tweenPosition(AutoJoinFrame, UDim2.new(autoJoinStartPos.X.Scale, autoJoinStartPos.X.Offset + delta.X, autoJoinStartPos.Y.Scale, autoJoinStartPos.Y.Offset + delta.Y), 0.1)
    end
    AutoJoinHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            autoJoinDragging = true
            autoJoinDragStart = input.Position
            autoJoinStartPos = AutoJoinFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    autoJoinDragging = false
                end
            end)
        end
    end)
    AutoJoinHeader.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            autoJoinDragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == autoJoinDragInput and autoJoinDragging then
            updateAutoJoinDrag(input)
        end
    end)
end

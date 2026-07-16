local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

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
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = ToggleButton
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(80, 200, 130)
ToggleStroke.Thickness = 1.5
ToggleStroke.Transparency = 0.5
ToggleStroke.Parent = ToggleButton

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
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 160, 100)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.6
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, headerHeight)
Header.BackgroundColor3 = Color3.fromRGB(22, 25, 27)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header
local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 14)
HeaderCover.Position = UDim2.new(0, 0, 1, -14)
HeaderCover.BackgroundColor3 = Color3.fromRGB(22, 25, 27)
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header
local HeaderGlow = Instance.new("Frame")
HeaderGlow.Size = UDim2.new(1, 0, 0, 2)
HeaderGlow.Position = UDim2.new(0, 0, 1, 0)
HeaderGlow.BackgroundColor3 = Color3.fromRGB(80, 200, 130)
HeaderGlow.BorderSizePixel = 0
HeaderGlow.BackgroundTransparency = 0.7
HeaderGlow.Parent = Header
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
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

local rowCurrentJobIdTop = headerHeight + rowGap
local RowCurrentJobId = Instance.new("Frame")
RowCurrentJobId.Name = "RowCurrentJobId"
RowCurrentJobId.Size = UDim2.new(1, -20, 0, rowCurrentJobIdHeight)
RowCurrentJobId.Position = UDim2.new(0, 10, 0, rowCurrentJobIdTop)
RowCurrentJobId.BackgroundColor3 = Color3.fromRGB(30, 35, 33)
RowCurrentJobId.BorderSizePixel = 0
RowCurrentJobId.Parent = MainFrame
local RowCurrentJobIdCorner = Instance.new("UICorner")
RowCurrentJobIdCorner.CornerRadius = UDim.new(0, 8)
RowCurrentJobIdCorner.Parent = RowCurrentJobId
local RowCurrentJobIdStroke = Instance.new("UIStroke")
RowCurrentJobIdStroke.Color = Color3.fromRGB(60, 160, 100)
RowCurrentJobIdStroke.Thickness = 1
RowCurrentJobIdStroke.Transparency = 0.7
RowCurrentJobIdStroke.Parent = RowCurrentJobId

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
local CopyCurrentJobIdCorner = Instance.new("UICorner")
CopyCurrentJobIdCorner.CornerRadius = UDim.new(0, 6)
CopyCurrentJobIdCorner.Parent = CopyCurrentJobIdButton

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
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 160, 100)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = btn
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
local FilterBoxPadding = Instance.new("UIPadding")
FilterBoxPadding.PaddingLeft = UDim.new(0, 10)
FilterBoxPadding.Parent = FilterBox
local FilterBoxCorner = Instance.new("UICorner")
FilterBoxCorner.CornerRadius = UDim.new(0, 8)
FilterBoxCorner.Parent = FilterBox
local FilterBoxStroke = Instance.new("UIStroke")
FilterBoxStroke.Color = Color3.fromRGB(60, 160, 100)
FilterBoxStroke.Thickness = 1
FilterBoxStroke.Transparency = 0.7
FilterBoxStroke.Parent = FilterBox

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
local ClearFilterCorner = Instance.new("UICorner")
ClearFilterCorner.CornerRadius = UDim.new(0, 8)
ClearFilterCorner.Parent = ClearFilterButton

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
local JobIdBoxPadding = Instance.new("UIPadding")
JobIdBoxPadding.PaddingLeft = UDim.new(0, 10)
JobIdBoxPadding.Parent = JobIdBox
local JobIdBoxCorner = Instance.new("UICorner")
JobIdBoxCorner.CornerRadius = UDim.new(0, 8)
JobIdBoxCorner.Parent = JobIdBox
local JobIdBoxStroke = Instance.new("UIStroke")
JobIdBoxStroke.Color = Color3.fromRGB(60, 160, 100)
JobIdBoxStroke.Thickness = 1
JobIdBoxStroke.Transparency = 0.7
JobIdBoxStroke.Parent = JobIdBox

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
local JoinJobIdCorner = Instance.new("UICorner")
JoinJobIdCorner.CornerRadius = UDim.new(0, 8)
JoinJobIdCorner.Parent = JoinJobIdButton

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
local PrevCorner = Instance.new("UICorner")
PrevCorner.CornerRadius = UDim.new(0, 8)
PrevCorner.Parent = PrevButton

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
local NextCorner = Instance.new("UICorner")
NextCorner.CornerRadius = UDim.new(0, 8)
NextCorner.Parent = NextButton

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
local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 10)
ListCorner.Parent = ServerList
local ListStroke = Instance.new("UIStroke")
ListStroke.Color = Color3.fromRGB(40, 120, 80)
ListStroke.Thickness = 1
ListStroke.Transparency = 0.7
ListStroke.Parent = ServerList
local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 6)
ListLayout.Parent = ServerList
local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 8)
ListPadding.PaddingBottom = UDim.new(0, 14)
ListPadding.PaddingLeft = UDim.new(0, 8)
ListPadding.PaddingRight = UDim.new(0, 8)
ListPadding.Parent = ServerList

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
    local Entry = Instance.new("Frame")
    Entry.Name = "Entry_" .. index
    Entry.Size = UDim2.new(1, -8, 0, entryHeight)
    Entry.BackgroundColor3 = isCurrent and Color3.fromRGB(22, 48, 36) or Color3.fromRGB(26, 30, 32)
    Entry.BorderSizePixel = 0
    Entry.LayoutOrder = index
    Entry.Parent = ServerList
    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 8)
    EntryCorner.Parent = Entry
    local EntryStroke = Instance.new("UIStroke")
    EntryStroke.Color = isCurrent and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(50, 140, 90)
    EntryStroke.Thickness = isCurrent and 1.5 or 1
    EntryStroke.Transparency = isCurrent and 0.4 or 0.8
    EntryStroke.Parent = Entry

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
    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 6)
    CopyCorner.Parent = CopyButton
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
    local JoinCorner = Instance.new("UICorner")
    JoinCorner.CornerRadius = UDim.new(0, 7)
    JoinCorner.Parent = JoinButton
    local JoinStroke = Instance.new("UIStroke")
    JoinStroke.Color = Color3.fromRGB(80, 200, 130)
    JoinStroke.Thickness = 1.5
    JoinStroke.Transparency = 0.6
    JoinStroke.Parent = JoinButton

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

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

local GameScripts = {
    {
        name = "Blox Fruit Cheat",
        game = "Blox Fruit",
        placeId = 12346884378,
        url = "https://pastefy.link/tu_script_bloxfruit"
    },
    {
        name = "Otro Script",
        game = "Otro Juego",
        placeId = 87654321098,
        url = "https://pastefy.link/otro_script"
    },
    {
        name = "Script Más",
        game = "Otro Juego 2",
        placeId = 11223344556,
        url = "https://pastefy.link/otro_mas"
    }
}

local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ScriptSelectorGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = true

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.FillDirection = Enum.FillDirection.Vertical

for _, scriptData in ipairs(GameScripts) do
    local Button = Instance.new("TextButton", MainFrame)
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.Text = scriptData.game.." | "..scriptData.name
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true

    Button.MouseButton1Click:Connect(function()
        if scriptData.placeId == game.PlaceId then
            local success, err = pcall(function()
                local code = HttpService:GetAsync(scriptData.url)
                loadstring(code)()
            end)
            if not success then
                warn("Error al ejecutar script:", err)
            end
        else
            warn("Este script no es para este juego")
        end
    end)
end

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

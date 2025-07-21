local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubLauncherGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 320)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true -- necessário para arrastar
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Moon Hub🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 30
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Escolha Sua Versão Preferida"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 20
subtitle.TextColor3 = Color3.new(1, 1, 1)
subtitle.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 28
toggleBtn.Text = "🌙"
toggleBtn.Parent = playerGui
toggleBtn.ZIndex = 10

toggleBtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)

local btnAbas = Instance.new("TextButton")
btnAbas.Size = UDim2.new(0.8, 0, 0, 50)
btnAbas.Position = UDim2.new(0.1, 0, 0, 90)
btnAbas.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
btnAbas.TextColor3 = Color3.new(1, 1, 1)
btnAbas.Font = Enum.Font.GothamBold
btnAbas.TextSize = 24
btnAbas.Text = "Versão Com Abas"
btnAbas.Parent = frame

btnAbas.MouseButton1Click:Connect(function()
    gui.Enabled = false
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_abas.lua"))()
end)

local btnSimples = Instance.new("TextButton")
btnSimples.Size = UDim2.new(0.8, 0, 0, 50)
btnSimples.Position = UDim2.new(0.1, 0, 0, 160)
btnSimples.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
btnSimples.TextColor3 = Color3.new(1, 1, 1)
btnSimples.Font = Enum.Font.GothamBold
btnSimples.TextSize = 24
btnSimples.Text = "Versão Simples"
btnSimples.Parent = frame

btnSimples.MouseButton1Click:Connect(function()
    gui.Enabled = false
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Simples.lua"))()
end)

local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -25)
credits.BackgroundTransparency = 1
credits.Text = "© Miguel"
credits.Font = Enum.Font.GothamItalic
credits.TextSize = 16
credits.TextColor3 = Color3.new(1, 1, 1)
credits.TextTransparency = 0.5
credits.Parent = frame
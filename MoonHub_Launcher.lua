-- Moon Hub Launcher 🌙 - Estilo KRNL

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubLauncherGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 300)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Moon Hub🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 30
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Escolha Sua Versão Preferida"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 20
subtitle.TextColor3 = Color3.new(1, 1, 1)
subtitle.Parent = frame

-- Botão Versão com Abas
local btnAbas = Instance.new("TextButton")
btnAbas.Size = UDim2.new(0.8, 0, 0, 50)
btnAbas.Position = UDim2.new(0.1, 0, 0, 90)
btnAbas.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
btnAbas.TextColor3 = Color3.new(1, 1, 1)
btnAbas.Font = Enum.Font.GothamBold
btnAbas.TextSize = 24
btnAbas.Text = "Versão Com Abas"
btnAbas.Parent = frame

-- Botão Versão Simples
local btnSimples = Instance.new("TextButton")
btnSimples.Size = UDim2.new(0.8, 0, 0, 50)
btnSimples.Position = UDim2.new(0.1, 0, 0, 160)
btnSimples.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
btnSimples.TextColor3 = Color3.new(1, 1, 1)
btnSimples.Font = Enum.Font.GothamBold
btnSimples.TextSize = 24
btnSimples.Text = "Versão Simples"
btnSimples.Parent = frame

-- Créditos
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

-- Função para fechar launcher ao abrir um script
local function closeLauncher()
    gui.Enabled = false
end

-- Eventos dos botões
btnAbas.MouseButton1Click:Connect(function()
    closeLauncher()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_abas.lua"))()
end)

btnSimples.MouseButton1Click:Connect(function()
    closeLauncher()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Simples.lua"))()
end)
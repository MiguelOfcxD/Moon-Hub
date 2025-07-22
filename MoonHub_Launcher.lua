-- MoonHub_Launcher.lua | Criado por Miguel

local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MoonHubLauncher"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 350, 0, 220)
main.Position = UDim2.new(0.5, -175, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local uicorner = Instance.new("UICorner", main)
uicorner.CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌙 Moon Hub - Escolha sua versão preferida"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Container de botões
local buttonContainer = Instance.new("Frame", main)
buttonContainer.Size = UDim2.new(1, -40, 0, 120)
buttonContainer.Position = UDim2.new(0, 20, 0, 60)
buttonContainer.BackgroundTransparency = 1

-- Função para criar botões
local function criarBotao(nome, cor, callback)
	local botao = Instance.new("TextButton", buttonContainer)
	botao.Size = UDim2.new(1, 0, 0, 40)
	botao.BackgroundColor3 = cor
	botao.Text = nome
	botao.TextColor3 = Color3.new(1, 1, 1)
	botao.Font = Enum.Font.Gotham
	botao.TextScaled = true
	botao.BorderSizePixel = 0
	Instance.new("UICorner", botao)
	botao.MouseButton1Click:Connect(callback)
	return botao
end

-- Botão versão COM abas
local btnAbas = criarBotao("🌌 Versão com Abas", Color3.fromRGB(60, 90, 150), function()
	main:Destroy()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_abas.lua"))()

-- Botão versão SIMPLES
local btnSimples = criarBotao("🌗 Versão Simples", Color3.fromRGB(90, 60, 130), function()
	main:Destroy()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Simples.lua"))()

-- Layout
local layout = Instance.new("UIListLayout", buttonContainer)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Créditos
local creditos = Instance.new("TextLabel", main)
creditos.Size = UDim2.new(1, 0, 0, 20)
creditos.Position = UDim2.new(0, 0, 1, -20)
creditos.BackgroundTransparency = 1
creditos.Text = "Criado por Miguel 🌙"
creditos.TextColor3 = Color3.fromRGB(150, 150, 150)
creditos.TextScaled = true
creditos.Font = Enum.Font.Gotham
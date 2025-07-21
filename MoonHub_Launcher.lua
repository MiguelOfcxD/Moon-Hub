-- Moon Hub🌙 Launcher Moderno - Estilo KRNL

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MoonHubLauncher"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 260)
main.Position = UDim2.new(0.5, -210, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "Moon Hub🌙"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- Subtítulo
local subtitle = Instance.new("TextLabel", main)
subtitle.Size = UDim2.new(1, -20, 0, 30)
subtitle.Position = UDim2.new(0, 10, 0, 50)
subtitle.Text = "Escolha sua versão preferida"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.BackgroundTransparency = 1

-- Botão: Simples
local simpleBtn = Instance.new("TextButton", main)
simpleBtn.Size = UDim2.new(0.5, -15, 0, 40)
simpleBtn.Position = UDim2.new(0, 10, 0, 100)
simpleBtn.Text = "Versão Simples"
simpleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
simpleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
simpleBtn.Font = Enum.Font.Gotham
simpleBtn.TextScaled = true
Instance.new("UICorner", simpleBtn)

-- Botão: Com Abas
local tabsBtn = Instance.new("TextButton", main)
tabsBtn.Size = UDim2.new(0.5, -15, 0, 40)
tabsBtn.Position = UDim2.new(0.5, 5, 0, 100)
tabsBtn.Text = "Versão Com Abas"
tabsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabsBtn.Font = Enum.Font.Gotham
tabsBtn.TextScaled = true
Instance.new("UICorner", tabsBtn)

-- Botão de Fechar
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "🌙"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextScaled = true
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", closeBtn)

-- Botão de Reabrir
local reopenBtn = Instance.new("TextButton", gui)
reopenBtn.Size = UDim2.new(0, 40, 0, 40)
reopenBtn.Position = UDim2.new(0, 10, 1, -50)
reopenBtn.Text = "🌙"
reopenBtn.Font = Enum.Font.Gotham
reopenBtn.TextScaled = true
reopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", reopenBtn)
reopenBtn.Visible = false

-- Ações dos Botões
simpleBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Simples.lua"))()
	gui:Destroy()
end)

tabsBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_abas.lua"))()
	gui:Destroy()
end)

closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	reopenBtn.Visible = true
end)

reopenBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	reopenBtn.Visible = false
end)
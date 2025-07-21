-- 🌙 Moon Hub Launcher - Escolha de Interface

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MoonHubLauncher"
gui.ResetOnSpawn = false

-- Janela
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BorderSizePixel = 0

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Escolha a Interface 🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

-- Botão: Com Abas
local withTabs = Instance.new("TextButton", frame)
withTabs.Size = UDim2.new(0.8, 0, 0, 40)
withTabs.Position = UDim2.new(0.1, 0, 0, 50)
withTabs.Text = "Interface com Abas"
withTabs.Font = Enum.Font.Gotham
withTabs.TextSize = 18
withTabs.TextColor3 = Color3.new(1, 1, 1)
withTabs.BackgroundColor3 = Color3.fromRGB(70, 130, 180)

-- Botão: Simples
local noTabs = Instance.new("TextButton", frame)
noTabs.Size = UDim2.new(0.8, 0, 0, 40)
noTabs.Position = UDim2.new(0.1, 0, 0, 100)
noTabs.Text = "Interface Simples"
noTabs.Font = Enum.Font.Gotham
noTabs.TextSize = 18
noTabs.TextColor3 = Color3.new(1, 1, 1)
noTabs.BackgroundColor3 = Color3.fromRGB(100, 149, 237)

-- Funções de clique
withTabs.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Abas.lua"))()
	gui:Destroy()
end)

noTabs.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Simples.lua"))()
	gui:Destroy()
end)

-- Moon Hub Launcher 🌙
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubLauncher"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moon Hub Launcher 🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Escolha sua versão preferida:"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 18
subtitle.TextColor3 = Color3.new(1, 1, 1)
subtitle.Parent = frame

-- Botão para MoonHub com abas
local btnWithTabs = Instance.new("TextButton")
btnWithTabs.Size = UDim2.new(0.8, 0, 0, 40)
btnWithTabs.Position = UDim2.new(0.1, 0, 0, 80)
btnWithTabs.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
btnWithTabs.TextColor3 = Color3.new(1, 1, 1)
btnWithTabs.Font = Enum.Font.GothamBold
btnWithTabs.TextSize = 22
btnWithTabs.Text = "Moon Hub (Com Abas)"
btnWithTabs.Parent = frame

-- Botão para MoonHub sem abas
local btnWithoutTabs = Instance.new("TextButton")
btnWithoutTabs.Size = UDim2.new(0.8, 0, 0, 40)
btnWithoutTabs.Position = UDim2.new(0.1, 0, 0, 130)
btnWithoutTabs.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
btnWithoutTabs.TextColor3 = Color3.new(1, 1, 1)
btnWithoutTabs.Font = Enum.Font.GothamBold
btnWithoutTabs.TextSize = 22
btnWithoutTabs.Text = "Moon Hub (Sem Abas)"
btnWithoutTabs.Parent = frame

-- Função para carregar script e fechar launcher
local function loadScript(url)
    spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            warn("Erro ao carregar script: ", err)
        end
    end)
    gui:Destroy()
end

btnWithTabs.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_abas.lua"))()
    gui:Destroy()
end)

btnWithoutTabs.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Simples.lua"))()
    gui:Destroy()
end)

-- Permitir mover a janela
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

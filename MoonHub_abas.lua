-- MoonHub 🌙 com Abas

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Estados Fly e Noclip
local flyAtivo = false
local noclipAtivo = false
local bodyGyro, bodyVel

-- GUI Janela
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Moon Hub 🌙 - Com Abas"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Função auxiliar para criar botões
local function newButton(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 40)
	btn.Position = UDim2.new(0.1, 0, 0, y)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Parent = frame
	return btn
end

-- Velocidade
local speed = humanoid.WalkSpeed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.6, 0, 0, 25)
speedLabel.Position = UDim2.new(0.2, 0, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.Text = "Velocidade: " .. speed
speedLabel.Parent = frame

local speedPlus = Instance.new("TextButton")
speedPlus.Size = UDim2.new(0, 30, 0, 25)
speedPlus.Position = UDim2.new(0.8, 0, 0, 40)
speedPlus.Text = "+"
speedPlus.Font = Enum.Font.GothamBold
speedPlus.TextSize = 18
speedPlus.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
speedPlus.TextColor3 = Color3.new(1, 1, 1)
speedPlus.Parent = frame

local speedMinus = speedPlus:Clone()
speedMinus.Text = "-"
speedMinus.Position = UDim2.new(0.75, 0, 0, 40)
speedMinus.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
speedMinus.Parent = frame

speedPlus.MouseButton1Click:Connect(function()
	speed += 1
	humanoid.WalkSpeed = speed
	speedLabel.Text = "Velocidade: " .. speed
end)

speedMinus.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 1)
	humanoid.WalkSpeed = speed
	speedLabel.Text = "Velocidade: " .. speed
end)

-- Pulo
local jumpPower = humanoid.JumpPower
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0.6, 0, 0, 25)
jumpLabel.Position = UDim2.new(0.2, 0, 0, 75)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 18
jumpLabel.Text = "Pulo: " .. jumpPower
jumpLabel.Parent = frame

local jumpPlus = Instance.new("TextButton")
jumpPlus.Size = UDim2.new(0, 30, 0, 25)
jumpPlus.Position = UDim2.new(0.8, 0, 0, 75)
jumpPlus.Text = "+"
jumpPlus.Font = Enum.Font.GothamBold
jumpPlus.TextSize = 18
jumpPlus.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
jumpPlus.TextColor3 = Color3.new(1, 1, 1)
jumpPlus.Parent = frame

local jumpMinus = jumpPlus:Clone()
jumpMinus.Text = "-"
jumpMinus.Position = UDim2.new(0.75, 0, 0, 75)
jumpMinus.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
jumpMinus.Parent = frame

jumpPlus.MouseButton1Click:Connect(function()
	jumpPower += 1
	humanoid.JumpPower = jumpPower
	jumpLabel.Text = "Pulo: " .. jumpPower
end)

jumpMinus.MouseButton1Click:Connect(function()
	jumpPower = math.max(0, jumpPower - 1)
	humanoid.JumpPower = jumpPower
	jumpLabel.Text = "Pulo: " .. jumpPower
end)

-- Fly
local flyBtn = newButton("Fly: OFF", 120)
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
flyBtn.MouseButton1Click:Connect(function()
	if flyAtivo then
		flyAtivo = false
		flyBtn.Text = "Fly: OFF"
		rs:UnbindFromRenderStep("FlyMovement")
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
	else
		flyAtivo = true
		flyBtn.Text = "Fly: ON"

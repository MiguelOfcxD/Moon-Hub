-- Moon Hub 🌙 - Versão Simples (Sem abas)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

-- Criar GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão Lua (abrir/fechar)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -50, 0, 20)
toggleBtn.AnchorPoint = Vector2.new(0, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://6031075938"
toggleBtn.Parent = gui

-- Janela principal estilo KRNL
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

-- Janela móvel
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
uis.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Botão fechar [X]
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Moon Hub 🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Função para criar slider de ajuste (Velocidade, Pulo)
local function createAdjuster(parent, name, yPos, defaultValue, onChange)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 0, 25)
	label.Position = UDim2.new(0.05, 0, 0, yPos)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 18
	label.Text = name .. ": " .. tostring(defaultValue)
	label.Parent = parent

	local plus = Instance.new("TextButton")
	plus.Size = UDim2.new(0, 30, 0, 25)
	plus.Position = UDim2.new(0.7, 5, 0, yPos)
	plus.Text = "+"
	plus.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
	plus.TextColor3 = Color3.new(1, 1, 1)
	plus.Font = Enum.Font.GothamBold
	plus.TextSize = 18
	plus.Parent = parent

	local minus = Instance.new("TextButton")
	minus.Size = UDim2.new(0, 30, 0, 25)
	minus.Position = UDim2.new(0.7, -35, 0, yPos)
	minus.Text = "-"
	minus.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
	minus.TextColor3 = Color3.new(1, 1, 1)
	minus.Font = Enum.Font.GothamBold
	minus.TextSize = 18
	minus.Parent = parent

	plus.MouseButton1Click:Connect(function()
		defaultValue += 1
		label.Text = name .. ": " .. tostring(defaultValue)
		onChange(defaultValue)
	end)

	minus.MouseButton1Click:Connect(function()
		defaultValue = math.max(0, defaultValue - 1)
		label.Text = name .. ": " .. tostring(defaultValue)
		onChange(defaultValue)
	end)

	return label, plus, minus
end

-- Velocidade e Pulo
local speed = 16
local jump = 50

local speedLabel = createAdjuster(frame, "Velocidade", 60, speed, function(v)
	humanoid.WalkSpeed = v
end)

local jumpLabel = createAdjuster(frame, "Pulo", 110, jump, function(v)
	humanoid.JumpPower = v
end)

-- Fly
local flyEnabled = false
local bodyGyro, bodyVelocity

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.8, 0, 0, 30)
flyBtn.Position = UDim2.new(0.1, 0, 0, 160)
flyBtn.Text = "Fly: OFF"
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 20
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Parent = frame

flyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")

	if flyEnabled then
		humanoid.PlatformStand = true
		bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.P = 10000
		bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	else
		humanoid.PlatformStand = false
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVelocity then bodyVelocity:Destroy() end
	end
end)

rs.Heartbeat:Connect(function()
	if flyEnabled and bodyGyro and bodyVelocity then
		local move = Vector3.new()
		local cam = workspace.CurrentCamera

		if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
		if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0, 1, 0) end

		if move.Magnitude > 0 then
			move = move.Unit * 50
		end

		bodyVelocity.Velocity = move
		bodyGyro.CFrame = cam.CFrame
	end
end)

-- Noclip
local noclipEnabled = false
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.8, 0, 0, 30)
noclipBtn.Position = UDim2.new(0.1, 0, 0, 210)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 20
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.Parent = frame

noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

rs.Stepped:Connect(function()
	if noclipEnabled then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- FPS Unlocker
local fpsUnlockEnabled = false
local fpsBtn = Instance.new("TextButton")
fpsBtn.Size = UDim2.new(0.8, 0, 0, 30)
fpsBtn.Position = UDim2.new(0.1, 0, 0, 260)
fpsBtn.Text = "FPS Unlocker: OFF"
fpsBtn.Font = Enum.Font.GothamBold
fpsBtn.TextSize = 20
fpsBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
fpsBtn.TextColor3 = Color3.new(1, 1, 1)
fpsBtn.Parent = frame

fpsBtn.MouseButton1Click:Connect(function()
	fpsUnlockEnabled = not fpsUnlockEnabled
	fpsBtn.Text = "FPS Unlocker: " .. (fpsUnlockEnabled and "ON" or "OFF")

	if fpsUnlockEnabled then
		pcall(function()
			setfpscap(999)
		end)
	else
		pcall(function()
			setfpscap(60)
		end)
	end
end)

-- Kill Aura com Fling
local killAuraEnabled = false
local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0.8, 0, 0, 30)
killBtn.Position = UDim2.new(0.1, 0, 0, 310)
killBtn.Text = "Kill Aura: OFF"
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 20
killBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
killBtn.TextColor3 = Color3.new(1, 1, 1)
killBtn.Parent = frame

killBtn.MouseButton1Click:Connect(function()
	killAuraEnabled = not killAuraEnabled
	killBtn.Text = "Kill Aura: " .. (killAuraEnabled and "ON" or "OFF")
end)

rs.Heartbeat:Connect(function()
	if killAuraEnabled then
		for _, p in pairs(game.Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local root = character:FindFirstChild("HumanoidRootPart")
				if root and (p.Character.HumanoidRootPart.Position - root.Position).Magnitude < 6 then
					-- Fling
					p.Character.HumanoidRootPart.Velocity = Vector3.new(999, 999, 999)
				end
			end
		end
	end
end)

-- Toggle botão abrir/fechar
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

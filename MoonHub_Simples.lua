-- MoonHub Simples 🌙

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

-- Estado funções
local flyAtivo = false
local noclipAtivo = false

-- Velocidade e Pulo
local speed = humanoid.WalkSpeed
local jumpPower = humanoid.JumpPower

-- GUI - Janela principal
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
title.Text = "Moon Hub 🌙 - Simples"
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

-- Velocidade (aumentar/diminuir)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.6, 0, 0, 25)
speedLabel.Position = UDim2.new(0.2, 0, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
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
speedPlus.TextColor3 = Color3.new(1,1,1)
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

-- Pulo (aumentar/diminuir)
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0.6, 0, 0, 25)
jumpLabel.Position = UDim2.new(0.2, 0, 0, 75)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.new(1,1,1)
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
jumpPlus.TextColor3 = Color3.new(1,1,1)
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
local bodyGyro, bodyVel
flyAtivo = false

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
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
		bodyGyro.CFrame = hrp.CFrame
		bodyGyro.Parent = hrp

		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
		bodyVel.Velocity = Vector3.new(0,0,0)
		bodyVel.Parent = hrp

		rs:BindToRenderStep("FlyMovement", Enum.RenderPriority.Input.Value, function()
			if not flyAtivo then return end
			local dir = Vector3.zero
			if uis:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
			if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

			if uis.TouchEnabled then
				-- Para controle mobile, adapte aqui se quiser
			end

			if dir.Magnitude > 0 then
				bodyVel.Velocity = dir.Unit * 50
				bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + dir.Unit)
			else
				bodyVel.Velocity = Vector3.zero
			end
		end)
	end
end)

-- Noclip
noclipAtivo = false

local noclipBtn = newButton("Noclip: OFF", 170)
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
noclipBtn.MouseButton1Click:Connect(function()
	noclipAtivo = not noclipAtivo
	noclipBtn.Text = "Noclip: " .. (noclipAtivo and "ON" or "OFF")
end)

rs.Stepped:Connect(function()
	if noclipAtivo then
		local char = player.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- FPS Unlocker (simples)
local fpsUnlocked = false
local fpsBtn = newButton("FPS Unlocker: OFF", 220)
fpsBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
fpsBtn.MouseButton1Click:Connect(function()
	fpsUnlocked = not fpsUnlocked
	fpsBtn.Text = "FPS Unlocker: " .. (fpsUnlocked and "ON" or "OFF")
	if fpsUnlocked then
		setfpscap(1000)
	else
		setfpscap(60)
	end
end)

-- Kill Aura simples
local killAura = false
local killBtn = newButton("Kill Aura: OFF", 270)
killBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
killBtn.MouseButton1Click:Connect(function()
	killAura = not killAura
	killBtn.Text = "Kill Aura: " .. (killAura and "ON" or "OFF")
end)

-- Função para fling (empurrar quem tocar)
local function fling(hit)
	local humanoid = hit.Parent:FindFirstChild("Humanoid")
	if humanoid and hit.Parent ~= player.Character then
		local hrpHit = hit.Parent:FindFirstChild("HumanoidRootPart")
		if hrpHit then
			hrpHit.Velocity = Vector3.new(math.random(-50,50),100,math.random(-50,50))
		end
	end
end

-- Conexão para kill aura
if killAura then
	character.HumanoidRootPart.Touched:Connect(fling)
end

-- Ao resetar personagem, desliga fly e noclip automaticamente
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	camera = workspace.CurrentCamera

	if flyAtivo then
		flyAtivo = false
		rs:UnbindFromRenderStep("FlyMovement")
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
		flyBtn.Text = "Fly: OFF"
	end

	if noclipAtivo then
		noclipAtivo = false
		noclipBtn.Text = "Noclip: OFF"
	end
end)

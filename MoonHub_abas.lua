local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubAbasGui"
gui.Parent = playerGui
gui.ResetOnSpawn = false

-- Janela principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 320)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -35, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.Parent = frame

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Botão abrir
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 140, 0, 30)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Text = "Abrir Moon Hub 🌙"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 18
openBtn.Visible = false
openBtn.Parent = gui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

-- Criar abas
local tabs = {}
local panels = {}

local function createTab(name, xPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 110, 0, 35)
	btn.Position = UDim2.new(0, xPos, 0, 45)
	btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Parent = frame
	return btn
end

local function createPanel()
	local pnl = Instance.new("Frame")
	pnl.Size = UDim2.new(1, -20, 1, -90)
	pnl.Position = UDim2.new(0, 10, 0, 85)
	pnl.BackgroundTransparency = 1
	pnl.Visible = false
	pnl.Parent = frame
	return pnl
end

-- Abas e seus painéis
tabs.Movimento = createTab("Movimento", 10)
tabs.Funcoes = createTab("Funções", 130)
tabs.Extras = createTab("Extras", 250)

panels.Movimento = createPanel()
panels.Funcoes = createPanel()
panels.Extras = createPanel()

-- Função para mostrar aba correta
local function showTab(tabName)
	for _, pnl in pairs(panels) do
		pnl.Visible = false
	end
	panels[tabName].Visible = true
	for _, btn in pairs(tabs) do
		btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	end
	tabs[tabName].BackgroundColor3 = Color3.fromRGB(100, 149, 237)
end

showTab("Movimento")

for name, btn in pairs(tabs) do
	btn.MouseButton1Click:Connect(function()
		showTab(name)
	end)
end

-- Movimentação: Velocidade e Pulo

local speed = 16
local jump = 50

local function addSlider(parent, labelText, y, initialValue, onChange)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -80, 0, 30)
	label.Position = UDim2.new(0, 10, 0, y)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 18
	label.Text = labelText .. ": " .. initialValue
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent

	local minus = Instance.new("TextButton")
	minus.Size = UDim2.new(0, 30, 0, 30)
	minus.Position = UDim2.new(1, -70, 0, y)
	minus.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
	minus.Text = "-"
	minus.Font = Enum.Font.GothamBold
	minus.TextSize = 20
	minus.TextColor3 = Color3.new(1, 1, 1)
	minus.Parent = parent

	local plus = Instance.new("TextButton")
	plus.Size = UDim2.new(0, 30, 0, 30)
	plus.Position = UDim2.new(1, -35, 0, y)
	plus.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
	plus.Text = "+"
	plus.Font = Enum.Font.GothamBold
	plus.TextSize = 20
	plus.TextColor3 = Color3.new(1, 1, 1)
	plus.Parent = parent

	minus.MouseButton1Click:Connect(function()
		if initialValue > 0 then
			initialValue = initialValue - 1
			label.Text = labelText .. ": " .. initialValue
			onChange(initialValue)
		end
	end)
	plus.MouseButton1Click:Connect(function()
		initialValue = initialValue + 1
		label.Text = labelText .. ": " .. initialValue
		onChange(initialValue)
	end)

	return label, plus, minus
end

local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid") or player.CharacterAdded:Wait():WaitForChild("Humanoid")

local speedLabel = addSlider(panels.Movimento, "Velocidade", 10, speed, function(v)
	if humanoid then humanoid.WalkSpeed = v end
	speed = v
end)

local jumpLabel = addSlider(panels.Movimento, "Pulo", 60, jump, function(v)
	if humanoid then humanoid.JumpPower = v end
	jump = v
end)

if humanoid then
	humanoid.WalkSpeed = speed
	humanoid.JumpPower = jump
end

-- Funções: Fly e Noclip

local flyEnabled = false
local noclipEnabled = false
local bodyGyro, bodyVelocity

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.8, 0, 0, 35)
flyBtn.Position = UDim2.new(0.1, 0, 0, 10)
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 20
flyBtn.Text = "Fly: OFF"
flyBtn.Parent = panels.Funcoes

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.8, 0, 0, 35)
noclipBtn.Position = UDim2.new(0.1, 0, 0, 60)
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 20
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Parent = panels.Funcoes

local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function toggleFly(state)
	if state then
		if not bodyGyro then
			bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
			bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		end
		if not bodyVelocity then
			bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
			bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		end
		humanoid.PlatformStand = true
	else
		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
		humanoid.PlatformStand = false
	end
end

flyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
	toggleFly(flyEnabled)
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

rs.Heartbeat:Connect(function()
	if flyEnabled and bodyGyro and bodyVelocity then
		local move = Vector3.new()
		local cam = workspace.CurrentCamera
		if uis:IsKeyDown(Enum.KeyCode.W) then
			move += cam.CFrame.LookVector
		end
		if uis:IsKeyDown(Enum.KeyCode.S) then
			move -= cam.CFrame.LookVector
		end
		if uis:IsKeyDown(Enum.KeyCode.A) then
			move -= cam.CFrame.RightVector
		end
		if uis:IsKeyDown(Enum.KeyCode.D) then
			move += cam.CFrame.RightVector
		end
		if uis:IsKeyDown(Enum.KeyCode.Space) then
			move += Vector3.new(0,1,0)
		end
		if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
			move -= Vector3.new(0,1,0)
		end
		if move.Magnitude > 0 then
			move = move.Unit * 50
		end
		bodyVelocity.Velocity = move
		bodyGyro.CFrame = cam.CFrame
	end
	if noclipEnabled then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)

-- Extras: FPS Unlocker e Kill Aura

local fpsUnlockerEnabled = false
local killAuraEnabled = false

local fpsBtn = Instance.new("TextButton")
fpsBtn.Size = UDim2.new(0.8, 0, 0, 35)
fpsBtn.Position = UDim2.new(0.1, 0, 0, 10)
fpsBtn.BackgroundColor3 = Color3.fromRGB(60, 179, 113)
fpsBtn.TextColor3 = Color3.new(1, 1, 1)
fpsBtn.Font = Enum.Font.GothamBold
fpsBtn.TextSize = 20
fpsBtn.Text = "FPS Unlocker: OFF"
fpsBtn.Parent = panels.Extras

local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0.8, 0, 0, 35)
killBtn.Position = UDim2.new(0.1, 0, 0, 60)
killBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
killBtn.TextColor3 = Color3.new(1, 1, 1)
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 20
killBtn.Text = "Kill Aura: OFF"
killBtn.Parent = panels.Extras

fpsBtn.MouseButton1Click:Connect(function()
	fpsUnlockerEnabled = not fpsUnlockerEnabled
	fpsBtn.Text = "FPS Unlocker: " .. (fpsUnlockerEnabled and "ON" or "OFF")
	if fpsUnlockerEnabled then
		setfpscap(1000) -- se a função estiver disponível
	else
		setfpscap(60)
	end
end)

local function flingPlayer(player)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local hrp = char.HumanoidRootPart
		hrp.Velocity = Vector3.new(0, 100, 0)
	end
end

local function getPlayersInRange(range)
	local playersInRange = {}
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (p.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
			if dist <= range then
				table.insert(playersInRange, p)
			end
		end
	end
	return playersInRange
end

killBtn.MouseButton1Click:Connect(function()
	killAuraEnabled = not killAuraEnabled
	killBtn.Text = "Kill Aura: " .. (killAuraEnabled and "ON" or "OFF")
end)

rs.Heartbeat:Connect(function()
	if killAuraEnabled then
		local playersAround = getPlayersInRange(10)
		for _, target in pairs(playersAround) do
			flingPlayer(target)
		end
	end
end)
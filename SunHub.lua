-- Moon Hub🌙 - GUI Completo

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Botão toggle (imagem lua)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 20)
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://6031075938" -- Lua
toggleButton.Parent = screenGui

-- Frame principal (hub)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Moon Hub🌙"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Parent = mainFrame

-- Velocidade
local speed = 16
local function updateSpeedLabel() speedLabel.Text = "Velocidade: " .. speed end

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = ""
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Parent = mainFrame

local increaseButton = Instance.new("TextButton")
increaseButton.Size = UDim2.new(0.4, 0, 0, 30)
increaseButton.Position = UDim2.new(0.55, 0, 0, 75)
increaseButton.Text = "+"
increaseButton.Font = Enum.Font.GothamBold
increaseButton.TextSize = 22
increaseButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseButton.BackgroundTransparency = 0.1
increaseButton.TextColor3 = Color3.new(1, 1, 1)
increaseButton.Parent = mainFrame

local decreaseButton = Instance.new("TextButton")
decreaseButton.Size = UDim2.new(0.4, 0, 0, 30)
decreaseButton.Position = UDim2.new(0.05, 0, 0, 75)
decreaseButton.Text = "-"
decreaseButton.Font = Enum.Font.GothamBold
decreaseButton.TextSize = 22
decreaseButton.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseButton.BackgroundTransparency = 0.1
decreaseButton.TextColor3 = Color3.new(1, 1, 1)
decreaseButton.Parent = mainFrame

-- Pulo
local jumpPower = 50
local function updateJumpLabel() jumpLabel.Text = "Pulo: " .. jumpPower end

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, -20, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, 115)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = ""
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 18
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.Parent = mainFrame

local jumpIncreaseButton = Instance.new("TextButton")
jumpIncreaseButton.Size = UDim2.new(0.4, 0, 0, 30)
jumpIncreaseButton.Position = UDim2.new(0.55, 0, 0, 150)
jumpIncreaseButton.Text = "+"
jumpIncreaseButton.Font = Enum.Font.GothamBold
jumpIncreaseButton.TextSize = 22
jumpIncreaseButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
jumpIncreaseButton.BackgroundTransparency = 0.1
jumpIncreaseButton.TextColor3 = Color3.new(1, 1, 1)
jumpIncreaseButton.Parent = mainFrame

local jumpDecreaseButton = Instance.new("TextButton")
jumpDecreaseButton.Size = UDim2.new(0.4, 0, 0, 30)
jumpDecreaseButton.Position = UDim2.new(0.05, 0, 0, 150)
jumpDecreaseButton.Text = "-"
jumpDecreaseButton.Font = Enum.Font.GothamBold
jumpDecreaseButton.TextSize = 22
jumpDecreaseButton.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
jumpDecreaseButton.BackgroundTransparency = 0.1
jumpDecreaseButton.TextColor3 = Color3.new(1, 1, 1)
jumpDecreaseButton.Parent = mainFrame

-- Fly
local flySpeed = 50
local flying = false
local bodyVelocity, bodyGyro

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 30)
flyButton.Position = UDim2.new(0.05, 0, 0, 190)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 20
flyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyButton.BackgroundTransparency = 0.1
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Parent = mainFrame

local function toggleFly()
	if flying then
		flying = false
		flyButton.Text = "Fly: OFF"
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
		humanoid.PlatformStand = false
	else
		flying = true
		flyButton.Text = "Fly: ON"
		humanoid.PlatformStand = true

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Parent = character.HumanoidRootPart

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro.CFrame = character.HumanoidRootPart.CFrame
		bodyGyro.Parent = character.HumanoidRootPart
	end
end

-- Noclip
local noclipEnabled = false

local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.9, 0, 0, 30)
noclipButton.Position = UDim2.new(0.05, 0, 0, 230)
noclipButton.Text = "Noclip: OFF"
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 20
noclipButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
noclipButton.BackgroundTransparency = 0.1
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.Parent = mainFrame

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Botão de Fly
flyButton.MouseButton1Click:Connect(toggleFly)

-- Botão Toggle Menu
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Botões Velocidade/Pulo
increaseButton.MouseButton1Click:Connect(function()
	speed += 1
	humanoid.WalkSpeed = speed
	updateSpeedLabel()
end)

decreaseButton.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 1)
	humanoid.WalkSpeed = speed
	updateSpeedLabel()
end)

jumpIncreaseButton.MouseButton1Click:Connect(function()
	jumpPower += 1
	humanoid.JumpPower = jumpPower
	updateJumpLabel()
end)

jumpDecreaseButton.MouseButton1Click:Connect(function()
	jumpPower = math.max(0, jumpPower - 1)
	humanoid.JumpPower = jumpPower
	updateJumpLabel()
end)

-- Fly móvel com analógico
RunService.Heartbeat:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			bodyVelocity.Velocity = moveDir.Unit * flySpeed
		else
			bodyVelocity.Velocity = Vector3.zero
		end
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
	end
end)

-- Inicializar valores
humanoid.WalkSpeed = speed
humanoid.JumpPower = jumpPower
updateSpeedLabel()
updateJumpLabel()

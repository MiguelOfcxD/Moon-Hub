-- Moon Hub🌙 + Fly simples

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

-- Botão toggle (imagem lua) no canto superior direito
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 20)
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://6031075938" -- imagem da lua
toggleButton.Parent = screenGui

-- Frame principal (hub) centralizado
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
mainFrame.BackgroundTransparency = 0.1
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

-- Label de velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade: 16"
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Parent = mainFrame

-- Botão aumentar velocidade
local increaseButton = Instance.new("TextButton")
increaseButton.Size = UDim2.new(0.4, 0, 0, 30)
increaseButton.Position = UDim2.new(0.55, 0, 0, 90)
increaseButton.Text = "+"
increaseButton.Font = Enum.Font.GothamBold
increaseButton.TextSize = 22
increaseButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseButton.TextColor3 = Color3.new(1, 1, 1)
increaseButton.Parent = mainFrame

-- Botão diminuir velocidade
local decreaseButton = Instance.new("TextButton")
decreaseButton.Size = UDim2.new(0.4, 0, 0, 30)
decreaseButton.Position = UDim2.new(0.05, 0, 0, 90)
decreaseButton.Text = "-"
decreaseButton.Font = Enum.Font.GothamBold
decreaseButton.TextSize = 22
decreaseButton.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseButton.TextColor3 = Color3.new(1, 1, 1)
decreaseButton.Parent = mainFrame

-- Botão fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 35)
flyButton.Position = UDim2.new(0.05, 0, 0, 140)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 20
flyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Parent = mainFrame

-- Variáveis
local speed = 16
local flying = false
local flySpeed = 50
local bodyVelocity
local bodyGyro

local function updateSpeedLabel()
	speedLabel.Text = "Velocidade: "..speed
end

humanoid.WalkSpeed = speed
updateSpeedLabel()

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
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = character.HumanoidRootPart

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro.CFrame = character.HumanoidRootPart.CFrame
		bodyGyro.Parent = character.HumanoidRootPart
	end
end

flyButton.MouseButton1Click:Connect(toggleFly)

RunService.Heartbeat:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local camCF = workspace.CurrentCamera.CFrame
		local moveDir = Vector3.new(0,0,0)

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + camCF.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - camCF.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - camCF.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + camCF.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			moveDir = moveDir + Vector3.new(0,1,0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			moveDir = moveDir - Vector3.new(0,1,0)
		end

		if moveDir.Magnitude > 0 then
			moveDir = moveDir.Unit * flySpeed
			bodyVelocity.Velocity = moveDir
		else
			bodyVelocity.Velocity = Vector3.new(0,0,0)
		end

		bodyGyro.CFrame = camCF
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

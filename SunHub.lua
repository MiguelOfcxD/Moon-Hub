-- Moon Hub🌙 com Velocidade, Pulo Alto, Fly e Noclip

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Botão toggle da lua
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 20)
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://6031075938"
toggleButton.Parent = screenGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 260)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
mainFrame.BackgroundTransparency = 0.3 -- leve transparência
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

-- Velocidade Label
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
local increaseSpeedBtn = Instance.new("TextButton")
increaseSpeedBtn.Size = UDim2.new(0.4, 0, 0, 30)
increaseSpeedBtn.Position = UDim2.new(0.55, 0, 0, 80)
increaseSpeedBtn.Text = "+"
increaseSpeedBtn.Font = Enum.Font.GothamBold
increaseSpeedBtn.TextSize = 22
increaseSpeedBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
increaseSpeedBtn.Parent = mainFrame

-- Botão diminuir velocidade
local decreaseSpeedBtn = Instance.new("TextButton")
decreaseSpeedBtn.Size = UDim2.new(0.4, 0, 0, 30)
decreaseSpeedBtn.Position = UDim2.new(0.05, 0, 0, 80)
decreaseSpeedBtn.Text = "-"
decreaseSpeedBtn.Font = Enum.Font.GothamBold
decreaseSpeedBtn.TextSize = 22
decreaseSpeedBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
decreaseSpeedBtn.Parent = mainFrame

-- Pulo alto Label
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, -20, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, 120)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Pulo Alto: 50"
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 18
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.Parent = mainFrame

-- Botão aumentar pulo
local increaseJumpBtn = Instance.new("TextButton")
increaseJumpBtn.Size = UDim2.new(0.4, 0, 0, 30)
increaseJumpBtn.Position = UDim2.new(0.55, 0, 0, 160)
increaseJumpBtn.Text = "+"
increaseJumpBtn.Font = Enum.Font.GothamBold
increaseJumpBtn.TextSize = 22
increaseJumpBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseJumpBtn.TextColor3 = Color3.new(1, 1, 1)
increaseJumpBtn.Parent = mainFrame

-- Botão diminuir pulo
local decreaseJumpBtn = Instance.new("TextButton")
decreaseJumpBtn.Size = UDim2.new(0.4, 0, 0, 30)
decreaseJumpBtn.Position = UDim2.new(0.05, 0, 0, 160)
decreaseJumpBtn.Text = "-"
decreaseJumpBtn.Font = Enum.Font.GothamBold
decreaseJumpBtn.TextSize = 22
decreaseJumpBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseJumpBtn.TextColor3 = Color3.new(1, 1, 1)
decreaseJumpBtn.Parent = mainFrame

-- Fly Button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.9, 0, 0, 35)
flyBtn.Position = UDim2.new(0.05, 0, 0, 210)
flyBtn.Text = "Fly: OFF"
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 20
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Parent = mainFrame

-- Noclip Button
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.9, 0, 0, 35)
noclipBtn.Position = UDim2.new(0.05, 0, 0, 255)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 20
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.Parent = mainFrame

-- Variáveis
local speed = 16
local jumpPower = 50
local flying = false
local flySpeed = 50
local noclip = false

local bodyVelocity
local bodyGyro

-- Atualiza labels
local function updateSpeedLabel()
	speedLabel.Text = "Velocidade: "..speed
end
local function updateJumpLabel()
	jumpLabel.Text = "Pulo Alto: "..jumpPower
end

-- Inicializa valores
humanoid.WalkSpeed = speed
humanoid.JumpPower = jumpPower
updateSpeedLabel()
updateJumpLabel()

-- Funções botão velocidade
increaseSpeedBtn.MouseButton1Click:Connect(function()
	speed = speed + 1
	humanoid.WalkSpeed = speed
	updateSpeedLabel()
end)
decreaseSpeedBtn.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 1)
	humanoid.WalkSpeed = speed
	updateSpeedLabel()
end)

-- Funções botão pulo
increaseJumpBtn.MouseButton1Click:Connect(function()
	jumpPower = jumpPower + 1
	humanoid.JumpPower = jumpPower
	updateJumpLabel()
end)
decreaseJumpBtn.MouseButton1Click:Connect(function()
	jumpPower = math.max(0, jumpPower - 1)
	humanoid.JumpPower = jumpPower
	updateJumpLabel()
end)

-- Função fly toggle
local function toggleFly()
	if flying then
		flying = false
		flyBtn.Text = "Fly: OFF"
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
		humanoid.PlatformStand = false
	else
		flying = true
		flyBtn.Text = "Fly: ON"
		humanoid.PlatformStand = true

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = rootPart

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro.CFrame = rootPart.CFrame
		bodyGyro.Parent = rootPart
	end
end
flyBtn.MouseButton1Click:Connect(toggleFly)

-- Função noclip toggle
local function toggleNoclip()
	noclip = not noclip
	if noclip then
		noclipBtn.Text = "Noclip: ON"
	else
		noclipBtn.Text = "Noclip: OFF"
	end
end
noclipBtn.MouseButton1Click:Connect(toggleNoclip)

-- Loop para noclip
RunService.Stepped:Connect(function()
	if noclip then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)

-- Controle de voo (compatível com PC e celular)
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

		-- Controle adicional para celular: analógico de movimento
		if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
			local moveVector = Vector3.new(
				UserInputService:GetGamepadState(Enum.UserInputType.Touch)[1] and UserInputService:GetGamepadState(Enum.UserInputType.Touch)[1].Position.X or 0,
				0,
				UserInputService:GetGamepadState(Enum.UserInputType.Touch)[1] and UserInputService:GetGamepadState(Enum.UserInputType.Touch)[1].Position.Y or 0
			)
			-- Ajuste simplificado, pode personalizar para seu analógico
			moveDir = moveDir + (camCF.RightVector * moveVector.X) + (camCF.LookVector * -moveVector.Z)
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

-- Toggle do frame com botão lua
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

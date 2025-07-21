-- Moon Hub🌙 v1.0 - Fly, Noclip, Speed, HighJump e GUI móvel

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Variáveis básicas
local speed = 16
local jumpPower = 50
local flying = false
local noclipEnabled = false
local flySpeed = 50

local bodyVelocity
local bodyGyro

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

-- Frame principal (janela móvel)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
mainFrame.BackgroundTransparency = 0.3 -- transparente com charme
mainFrame.Visible = false
mainFrame.Parent = screenGui
mainFrame.Active = true -- importante para Input
mainFrame.Draggable = true -- deixa o frame móvel pelo mouse (desktop)

-- Para celular/touch: fazemos drag manual
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Moon Hub🌙"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Parent = mainFrame

-- Label Velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 50)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade: "..speed
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Parent = mainFrame

-- Botão aumentar velocidade
local increaseSpeedBtn = Instance.new("TextButton")
increaseSpeedBtn.Size = UDim2.new(0.4, 0, 0, 30)
increaseSpeedBtn.Position = UDim2.new(0.55, 0, 0, 85)
increaseSpeedBtn.Text = "+"
increaseSpeedBtn.Font = Enum.Font.GothamBold
increaseSpeedBtn.TextSize = 22
increaseSpeedBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseSpeedBtn.TextColor3 = Color3.new(1,1,1)
increaseSpeedBtn.Parent = mainFrame

-- Botão diminuir velocidade
local decreaseSpeedBtn = Instance.new("TextButton")
decreaseSpeedBtn.Size = UDim2.new(0.4, 0, 0, 30)
decreaseSpeedBtn.Position = UDim2.new(0.05, 0, 0, 85)
decreaseSpeedBtn.Text = "-"
decreaseSpeedBtn.Font = Enum.Font.GothamBold
decreaseSpeedBtn.TextSize = 22
decreaseSpeedBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseSpeedBtn.TextColor3 = Color3.new(1,1,1)
decreaseSpeedBtn.Parent = mainFrame

-- Label Pulo alto
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(1, -20, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, 125)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Pulo Alto: "..jumpPower
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 18
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.Parent = mainFrame

-- Botão aumentar pulo
local increaseJumpBtn = Instance.new("TextButton")
increaseJumpBtn.Size = UDim2.new(0.4, 0, 0, 30)
increaseJumpBtn.Position = UDim2.new(0.55, 0, 0, 160)
increaseJumpBtn.Text = "+"
increaseJumpBtn.Font = Enum.Font.GothamBold
increaseJumpBtn.TextSize = 22
increaseJumpBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseJumpBtn.TextColor3 = Color3.new(1,1,1)
increaseJumpBtn.Parent = mainFrame

-- Botão diminuir pulo
local decreaseJumpBtn = Instance.new("TextButton")
decreaseJumpBtn.Size = UDim2.new(0.4, 0, 0, 30)
decreaseJumpBtn.Position = UDim2.new(0.05, 0, 0, 160)
decreaseJumpBtn.Text = "-"
decreaseJumpBtn.Font = Enum.Font.GothamBold
decreaseJumpBtn.TextSize = 22
decreaseJumpBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseJumpBtn.TextColor3 = Color3.new(1,1,1)
decreaseJumpBtn.Parent = mainFrame

-- Botão fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 40)
flyButton.Position = UDim2.new(0.05, 0, 0, 210)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 20
flyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Parent = mainFrame

-- Botão noclip
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.9, 0, 0, 40)
noclipButton.Position = UDim2.new(0.05, 0, 0, 260)
noclipButton.Text = "Noclip: OFF"
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 20
noclipButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Parent = mainFrame

-- Funções atualizar labels
local function updateSpeedLabel()
	speedLabel.Text = "Velocidade: "..speed
	humanoid.WalkSpeed = speed
end

local function updateJumpLabel()
	jumpLabel.Text = "Pulo Alto: "..jumpPower
	humanoid.JumpPower = jumpPower
end

-- Funções botões velocidade
increaseSpeedBtn.MouseButton1Click:Connect(function()
	speed = speed + 1
	updateSpeedLabel()
end)

decreaseSpeedBtn.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 1)
	updateSpeedLabel()
end)

-- Funções botões pulo alto
increaseJumpBtn.MouseButton1Click:Connect(function()
	jumpPower = jumpPower + 5
	updateJumpLabel()
end)

decreaseJumpBtn.MouseButton1Click:Connect(function()
	jumpPower = math.max(10, jumpPower - 5)
	updateJumpLabel()
end)

-- Inicializa valores
updateSpeedLabel()
updateJumpLabel()

-- Função noclip melhorado
local function setCollision(state)
	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") and part.CanCollide ~= state then
			part.CanCollide = state
		end
	end
end

local function noclipToggle()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		setCollision(false)
		noclipButton.Text = "Noclip: ON"
		noclipButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
	else
		setCollision(true)
		noclipButton.Text = "Noclip: OFF"
		noclipButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
		-- Evita ficar preso movendo pra cima
		local pos = rootPart.Position
		rootPart.CFrame = CFrame.new(pos.X, pos.Y + 5, pos.Z)
	end
end

noclipButton.MouseButton1Click:Connect(noclipToggle)

-- Função toggle fly
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
		bodyVelocity.Parent = rootPart

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro.CFrame = rootPart.CFrame
		bodyGyro.Parent = rootPart
	end
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- Controle do fly, usando humanoid.MoveDirection para funcionar em celular e PC
RunService.Heartbeat:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			bodyVelocity.Velocity = moveDir.Unit * flySpeed
		else
			bodyVelocity.Velocity = Vector3.new(0,0,0)
		end
		-- Manter o corpo alinhado com a câmera
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
	end

	-- Se noclip estiver ativo, garantir colisões desligadas (proteção extra)
	if noclipEnabled then
		setCollision(false)
	end
end)

-- Toggle principal do menu com o botão da lua
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

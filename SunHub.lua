-- Moon Hub🌙 - Hub de Velocidade com Toggle
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Criação da GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Botão de Lua (Toggle)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 20)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://6031075938"
toggleButton.Parent = screenGui

-- Frame principal (Hub)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Moon Hub🌙"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Parent = mainFrame

-- Label de Velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidade: 16"
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Parent = mainFrame

-- Botão Aumentar
local increaseButton = Instance.new("TextButton")
increaseButton.Name = "IncreaseButton"
increaseButton.Size = UDim2.new(0.4, 0, 0, 30)
increaseButton.Position = UDim2.new(0.55, 0, 0, 90)
increaseButton.Text = "+"
increaseButton.Font = Enum.Font.GothamBold
increaseButton.TextSize = 22
increaseButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseButton.TextColor3 = Color3.new(1, 1, 1)
increaseButton.Parent = mainFrame

-- Botão Diminuir
local decreaseButton = Instance.new("TextButton")
decreaseButton.Name = "DecreaseButton"
decreaseButton.Size = UDim2.new(0.4, 0, 0, 30)
decreaseButton.Position = UDim2.new(0.05, 0, 0, 90)
decreaseButton.Text = "-"
decreaseButton.Font = Enum.Font.GothamBold
decreaseButton.TextSize = 22
decreaseButton.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseButton.TextColor3 = Color3.new(1, 1, 1)
decreaseButton.Parent = mainFrame

-- Lógica do hub
local speed = 16
humanoid.WalkSpeed = speed

increaseButton.MouseButton1Click:Connect(function()
	speed += 1
	humanoid.WalkSpeed = speed
	speedLabel.Text = "Velocidade: " .. speed
end)

decreaseButton.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 1)
	humanoid.WalkSpeed = speed
	speedLabel.Text = "Velocidade: " .. speed
end)

toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Moon Hub🌙 - Mobile & PC Fly GUI

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MoonHubGui"
gui.ResetOnSpawn = false

-- Toggle Button
local toggle = Instance.new("ImageButton", gui)
toggle.Size = UDim2.new(0, 40, 0, 40)
toggle.Position = UDim2.new(1, -50, 0, 20)
toggle.BackgroundTransparency = 1
toggle.Image = "rbxassetid://6031075938"

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.Visible = false

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Moon Hub🌙"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- Velocidade
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18

local increaseSpeed = Instance.new("TextButton", frame)
increaseSpeed.Position = UDim2.new(0.55, 0, 0, 70)
increaseSpeed.Size = UDim2.new(0.4, 0, 0, 30)
increaseSpeed.Text = "+"
increaseSpeed.Font = Enum.Font.GothamBold
increaseSpeed.TextSize = 22
increaseSpeed.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseSpeed.TextColor3 = Color3.new(1, 1, 1)

local decreaseSpeed = Instance.new("TextButton", frame)
decreaseSpeed.Position = UDim2.new(0.05, 0, 0, 70)
decreaseSpeed.Size = UDim2.new(0.4, 0, 0, 30)
decreaseSpeed.Text = "-"
decreaseSpeed.Font = Enum.Font.GothamBold
decreaseSpeed.TextSize = 22
decreaseSpeed.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseSpeed.TextColor3 = Color3.new(1, 1, 1)

-- Pulo
local jumpLabel = Instance.new("TextLabel", frame)
jumpLabel.Position = UDim2.new(0, 10, 0, 110)
jumpLabel.Size = UDim2.new(1, -20, 0, 25)
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 18

local increaseJump = Instance.new("TextButton", frame)
increaseJump.Position = UDim2.new(0.55, 0, 0, 140)
increaseJump.Size = UDim2.new(0.4, 0, 0, 30)
increaseJump.Text = "+"
increaseJump.Font = Enum.Font.GothamBold
increaseJump.TextSize = 22
increaseJump.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
increaseJump.TextColor3 = Color3.new(1, 1, 1)

local decreaseJump = Instance.new("TextButton", frame)
decreaseJump.Position = UDim2.new(0.05, 0, 0, 140)
decreaseJump.Size = UDim2.new(0.4, 0, 0, 30)
decreaseJump.Text = "-"
decreaseJump.Font = Enum.Font.GothamBold
decreaseJump.TextSize = 22
decreaseJump.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
decreaseJump.TextColor3 = Color3.new(1, 1, 1)

-- Fly Button
local flyButton = Instance.new("TextButton", frame)
flyButton.Position = UDim2.new(0.1, 0, 1, -40)
flyButton.Size = UDim2.new(0.8, 0, 0, 30)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 20
flyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyButton.TextColor3 = Color3.new(1, 1, 1)

-- Variáveis
local speed = 16
local jump = 50
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro
local move = Vector3.zero

local flyButtons = {}
local directions = {
	{"↑", Vector3.new(0, 0, -1)},
	{"↓", Vector3.new(0, 0, 1)},
	{"←", Vector3.new(-1, 0, 0)},
	{"→", Vector3.new(1, 0, 0)},
	{"⬆️", Vector3.new(0, 1, 0)},
	{"⬇️", Vector3.new(0, -1, 0)},
}

for i, dir in ipairs(directions) do
	local btn = Instance.new("TextButton", gui)
	btn.Text = dir[1]
	btn.Size = UDim2.new(0, 40, 0, 40)
	btn.Position = UDim2.new(1, -60, 1, -220 + (i-1)*45)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Visible = false
	btn.TextScaled = true
	btn.Name = "FlyBtn"..i
	flyButtons[btn] = dir[2]
end

local function updateLabels()
	speedLabel.Text = "Velocidade: "..speed
	jumpLabel.Text = "Pulo: "..jump
	humanoid.WalkSpeed = speed
	humanoid.JumpPower = jump
end

updateLabels()

increaseSpeed.MouseButton1Click:Connect(function()
	speed += 1
	updateLabels()
end)
decreaseSpeed.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 1)
	updateLabels()
end)
increaseJump.MouseButton1Click:Connect(function()
	jump += 1
	updateLabels()
end)
decreaseJump.MouseButton1Click:Connect(function()
	jump = math.max(0, jump - 1)
	updateLabels()
end)

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")

	for btn in pairs(flyButtons) do
		btn.Visible = flying
	end

	if flying then
		humanoid.PlatformStand = true
		bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)

		for btn, vec in pairs(flyButtons) do
			btn.MouseButton1Down:Connect(function()
				move += vec
			end)
			btn.MouseButton1Up:Connect(function()
				move -= vec
			end)
		end
	else
		humanoid.PlatformStand = false
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
	end
end)

rs.Heartbeat:Connect(function()
	if flying and bodyVelocity and bodyGyro then
		bodyVelocity.Velocity = move.Unit * flySpeed
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
	end
end)

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

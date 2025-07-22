-- 🌙 Moon Hub por Miguel e Copilot
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Estado
local isImmortal = false
local gravityOn = false
local defaultGravity = workspace.Gravity
local isOpen = true

-- GUI principal
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MoonHub🌙"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0.5, -160, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.1
frame.Active = true

local corner = Instance.new("UICorner", frame)

-- 🌙 Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "🌙 Moon Hub"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.BackgroundTransparency = 1

-- 🌙 Lua animada
local moonIcon = Instance.new("ImageLabel", frame)
moonIcon.Size = UDim2.new(0, 30, 0, 30)
moonIcon.Position = UDim2.new(1, -40, 0, 10)
moonIcon.BackgroundTransparency = 1
moonIcon.Image = "rbxassetid://14415712565"
local moonCorner = Instance.new("UICorner", moonIcon)

local rotation = 0
RunService.RenderStepped:Connect(function()
    rotation += 1
    moonIcon.Rotation = rotation
end)

-- 🏃 Velocidade
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0.07, 0)
speedLabel.Position = UDim2.new(0, 0, 0.11, 0)
speedLabel.Text = "Velocidade: " .. humanoid.WalkSpeed
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.TextScaled = true

local function animateSpeedChange()
	local pulse = TweenService:Create(speedLabel, TweenInfo.new(0.2), {
		TextColor3 = Color3.fromRGB(0, 255, 150)
	})
	local reset = TweenService:Create(speedLabel, TweenInfo.new(0.5), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	})
	pulse:Play()
	pulse.Completed:Connect(function()
		reset:Play()
	end)
end

local function updateSpeed(amount)
	humanoid.WalkSpeed = math.clamp(humanoid.WalkSpeed + amount, 1, 100)
	speedLabel.Text = "Velocidade: " .. humanoid.WalkSpeed
	animateSpeedChange()
end

local decreaseBtn = Instance.new("TextButton", frame)
decreaseBtn.Size = UDim2.new(0.4, 0, 0.07, 0)
decreaseBtn.Position = UDim2.new(0.05, 0, 0.19, 0)
decreaseBtn.Text = "-1"
decreaseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
decreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
decreaseBtn.Font = Enum.Font.GothamBold
decreaseBtn.TextScaled = true

local increaseBtn = Instance.new("TextButton", frame)
increaseBtn.Size = UDim2.new(0.4, 0, 0.07, 0)
increaseBtn.Position = UDim2.new(0.55, 0, 0.19, 0)
increaseBtn.Text = "+1"
increaseBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
increaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
increaseBtn.Font = Enum.Font.GothamBold
increaseBtn.TextScaled = true

decreaseBtn.MouseButton1Click:Connect(function()
	updateSpeed(-1)
end)

increaseBtn.MouseButton1Click:Connect(function()
	updateSpeed(1)
end)

-- 🔄 Reset Instantâneo
local resetBtn = Instance.new("TextButton", frame)
resetBtn.Size = UDim2.new(0.9, 0, 0.07, 0)
resetBtn.Position = UDim2.new(0.05, 0, 0.28, 0)
resetBtn.Text = "🔄 Reset Instantâneo"
resetBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextScaled = true

local function animateResetClick()
	local tween1 = TweenService:Create(resetBtn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(255, 50, 100)
	})
	local tween2 = TweenService:Create(resetBtn, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(100, 100, 255)
	})
	tween1:Play()
	tween1.Completed:Connect(function()
		tween2:Play()
	end)
end

resetBtn.MouseButton1Click:Connect(function()
	character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid:BreakJoints()
		animateResetClick()
	end
end)

-- 🛡️ Protegido pela Lua 🌙
local protectionText = Instance.new("TextLabel", gui)
protectionText.Size = UDim2.new(0, 200, 0, 30)
protectionText.Position = UDim2.new(0.5, -100, 0.05, 0)
protectionText.BackgroundTransparency = 1
protectionText.Text = "🌙 Protegido pela Lua"
protectionText.Font = Enum.Font.FredokaOne
protectionText.TextColor3 = Color3.fromRGB(150, 255, 255)
protectionText.TextScaled = true
protectionText.Visible = false

-- 🛡️ Botão Imortal
local immortalBtn = Instance.new("TextButton", frame)
immortalBtn.Size = UDim2.new(0.9, 0, 0.07, 0)
immortalBtn.Position = UDim2.new(0.05, 0, 0.37, 0)
immortalBtn.Text = "🛡️ Modo Imortal: OFF"
immortalBtn.BackgroundColor3 = Color3.fromRGB(255, 160, 40)
immortalBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
immortalBtn.Font = Enum.Font.GothamBold
immortalBtn.TextScaled = true

immortalBtn.MouseButton1Click:Connect(function()
	isImmortal = not isImmortal
	if isImmortal then
		immortalBtn.Text = "🛡️ Modo Imortal: ON"
		immortalBtn.BackgroundColor3 = Color3.fromRGB(40, 255, 160)
		protectionText.Visible = true
		humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			if humanoid.Health < humanoid.MaxHealth and isImmortal then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
	else
		immortalBtn.Text = "🛡️ Modo Imortal: OFF"
		immortalBtn.BackgroundColor3 = Color3.fromRGB(255, 160, 40)
		protectionText.Visible = false
	end
end)

-- 🪐 Gravidade
local gravityBtn = Instance.new("TextButton", frame)
gravityBtn.Size = UDim2.new(0.9, 0, 0.07, 0)
gravityBtn.Position = UDim2.new(0.05, 0, 0.46, 0)
gravityBtn.Text = "🌙 Gravidade: OFF"
gravityBtn.BackgroundColor3 = Color3.fromRGB(90, 90,
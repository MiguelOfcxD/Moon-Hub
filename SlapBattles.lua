-- Moon Hub🌙 para Slap Battles - by Miguel

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")

-- Variáveis de controle
local killAura = false
local autoSlap = false
local speedHack = false
local speedValue = 50

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MoonHub🌙"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 350)
Main.Position = UDim2.new(0.5, -150, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.ClipsDescendants = true
Main.BackgroundTransparency = 0.05

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Moon Hub🌙 - Slap Battles"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Fechar
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
local corner = Instance.new("UICorner", Close)
corner.CornerRadius = UDim.new(0, 8)
Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Criador de botão
local function CreateButton(name, posY, callback)
	local Button = Instance.new("TextButton", Main)
	Button.Size = UDim2.new(0.8, 0, 0, 35)
	Button.Position = UDim2.new(0.1, 0, 0, posY)
	Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14
	Button.Text = name
	local corner = Instance.new("UICorner", Button)
	corner.CornerRadius = UDim.new(0, 6)
	Button.MouseButton1Click:Connect(callback)
	return Button
end

-- Toggle Kill Aura
CreateButton("Kill Aura (ON/OFF)", 50, function()
	killAura = not killAura
end)

-- Toggle Auto Slap
CreateButton("Auto Slap (ON/OFF)", 95, function()
	autoSlap = not autoSlap
end)

-- Toggle Speed
CreateButton("Speed Hack (ON/OFF)", 140, function()
	speedHack = not speedHack
end)

-- Reset
CreateButton("Reset Rápido", 185, function()
	LP.Character:BreakJoints()
end)

-- Teleporte para jogador
local TpBox = Instance.new("TextBox", Main)
TpBox.PlaceholderText = "Nome do Jogador"
TpBox.Size = UDim2.new(0.8, 0, 0, 30)
TpBox.Position = UDim2.new(0.1, 0, 0, 235)
TpBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TpBox.Font = Enum.Font.Gotham
TpBox.TextSize = 14
local corner2 = Instance.new("UICorner", TpBox)
corner2.CornerRadius = UDim.new(0, 6)

CreateButton("Teleportar", 275, function()
	local name = TpBox.Text
	local target = Players:FindFirstChild(name)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		HRP.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
	end
end)

-- Eventos de loop
RunService.Heartbeat:Connect(function()
	pcall(function()
		Char = LP.Character or LP.CharacterAdded:Wait()
		HRP = Char:WaitForChild("HumanoidRootPart")
		Humanoid = Char:WaitForChild("Humanoid")
	end)

	-- Speed Hack
	if speedHack then
		Humanoid.WalkSpeed = speedValue
	else
		Humanoid.WalkSpeed = 16
	end

	-- Kill Aura
	if killAura then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (HRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
				if dist < 10 then
					local attack = RS:FindFirstChild("Attack")
					if attack then
						attack:FireServer(plr.Character)
					end
				end
			end
		end
	end

	-- Auto Slap
	if autoSlap then
		local attack = RS:FindFirstChild("Attack")
		if attack then
			attack:FireServer()
		end
	end
end)
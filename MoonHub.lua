-- Moon Hub🌙 - Painel VIP Galáctico
-- Desenvolvido exclusivamente para Miguelh009991

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local MoonHub = Instance.new("ScreenGui", game.CoreGui)
MoonHub.Name = "MoonHub🌙"

local moonButton = Instance.new("ImageButton", MoonHub)
moonButton.Size = UDim2.new(0, 50, 0, 50)
moonButton.Position = UDim2.new(0.92, 0, 0.5, -25)
moonButton.BackgroundTransparency = 1
moonButton.Image = "rbxassetid://6031091000"

local panel = Instance.new("Frame", MoonHub)
panel.Size = UDim2.new(0, 400, 0, 900)
panel.Position = UDim2.new(0.5, -200, 0.5, -450)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.Visible = false
panel.BorderSizePixel = 0
panel.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Moon Hub🌙"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local closeButton = Instance.new("TextButton", panel)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "❌"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

moonButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

closeButton.MouseButton1Click:Connect(function()
	panel.Visible = false
end)

-- Comandos de Jogador
local function criarBotao(nome, pos, func)
	local btn = Instance.new("TextButton", panel)
	btn.Size = UDim2.new(0.5, -10, 0, 30)
	btn.Position = pos
	btn.Text = nome
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(func)
end

criarBotao("⚡ Velocidade", UDim2.new(0, 10, 0, 50), function()
	player.Character.Humanoid.WalkSpeed = 100
end)

criarBotao("🌀 Pulo", UDim2.new(0.5, 10, 0, 50), function()
	player.Character.Humanoid.JumpPower = 150
end)

criarBotao("🕶️ Invisível", UDim2.new(0, 10, 0, 90), function()
	for _, part in pairs(player.Character:GetDescendants()) do
		if part:IsA("BasePart") then part.Transparency = 1 end
	end
end)

criarBotao("🔄 Reset", UDim2.new(0.5, 10, 0, 90), function()
	player:Kick("Reset via Moon Hub🌙")
end)

-- Comandos de Ambiente
criarBotao("🌌 Gravidade Zero", UDim2.new(0, 10, 0, 140), function()
	game.Workspace.Gravity = 0
end)

criarBotao("🌍 Gravidade Normal", UDim2.new(0.5, 10, 0, 140), function()
	game.Workspace.Gravity = 196.2
end)

criarBotao("🌑 Escurecer", UDim2.new(0, 10, 0, 180), function()
	game.Lighting.Brightness = 0
	game.Lighting.ClockTime = 0
end)

criarBotao("☀️ Clarear", UDim2.new(0.5, 10, 0, 180), function()
	game.Lighting.Brightness = 2
	game.Lighting.ClockTime = 14
end)

-- Comandos Visuais
criarBotao("🔍 Zoom Máx", UDim2.new(0, 10, 0, 230), function()
	player.CameraMaxZoomDistance = 100
end)

criarBotao("🔎 Zoom Mín", UDim2.new(0.5, 10, 0, 230), function()
	player.CameraMaxZoomDistance = 10
end)

criarBotao("🟢 Visão Noturna", UDim2.new(0, 10, 0, 270), function()
	game.Lighting.ColorShift_Bottom = Color3.fromRGB(0, 255, 0)
	game.Lighting.ColorShift_Top = Color3.fromRGB(0, 255, 0)
end)

criarBotao("🔁 Reset Visual", UDim2.new(0.5, 10, 0, 270), function()
	game.Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	game.Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
end)

-- Comandos de Diversão
criarBotao("💥 Explosão", UDim2.new(0, 10, 0, 320), function()
	local explosion = Instance.new("Explosion")
	explosion.Position = player.Character.HumanoidRootPart.Position
	explosion.BlastRadius = 10
	explosion.BlastPressure = 500000
	explosion.Parent = game.Workspace
end)

criarBotao("🕺 Dança", UDim2.new(0.5, 10, 0, 320), function()
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://507777826"
	local track = player.Character.Humanoid:LoadAnimation(anim)
	track:Play()
end)

criarBotao("🔄 Girar", UDim2.new(0, 10, 0, 360), function()
	while true do
		player.Character:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(10), 0))
		wait(0.1)
	end
end)

criarBotao("🔊 Som Cósmico", UDim2.new(0.5, 10, 0, 360), function()
	local sound = Instance.new("Sound", player.Character.Head)
	sound.SoundId = "rbxassetid://9118823105"
	sound.Volume = 1
	sound:Play()
end)

-- Comandos VIP
criarBotao("🛸 Voo VIP", UDim2.new(0, 10, 0, 410), function()
	local hrp = player.Character:WaitForChild("HumanoidRootPart")
	local bv = Instance.new("BodyVelocity", hrp)
	bv.Velocity = Vector3.new(0, 50, 0)
	bv.MaxForce = Vector3.new(0, math.huge, 0)
	wait(2)
	bv:Destroy()
end)

criarBotao("📍 Teleporte", UDim2.new(0.5, 10, 0, 410), function()
	player.Character:MoveTo(Vector3.new(0, 100, 0))
end)

criarBotao("🛠️ Admin Cmds", UDim2.new(0, 10, 0, 450), function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

criarBotao("🧹 Limpar Efeitos", UDim2.new(0.5, 10, 0, 450), function()
	for _, obj in pairs(player.Character:GetDescendants()) do
		if obj:IsA("Sound") or obj:IsA("ParticleEmitter") then
			obj:Destroy()
		end
	end
end)
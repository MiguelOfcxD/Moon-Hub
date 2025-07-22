-- MoonHub_Abas.lua | Criado por Miguel
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Variáveis de controle
local gravidadeAtiva = false
local noclipAtivo = false
local killAuraAtiva = false
local tpToolAtivo = false

-- Configurações iniciais
local velocidade = 16
local forcaPulo = 50

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MoonHubAbas"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
main.BorderSizePixel = 0
main.Visible = true
main.Active = true
main.Draggable = true
main.Name = "Main"

local uicorner = Instance.new("UICorner", main)
uicorner.CornerRadius = UDim.new(0, 12)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
close.BorderSizePixel = 0
close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

local abrirBtn = Instance.new("TextButton", gui)
abrirBtn.Text = "🌙"
abrirBtn.Size = UDim2.new(0, 40, 0, 40)
abrirBtn.Position = UDim2.new(0, 10, 0.5, -20)
abrirBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
abrirBtn.TextColor3 = Color3.new(1,1,1)
abrirBtn.BorderSizePixel = 0
abrirBtn.Visible = false
Instance.new("UICorner", abrirBtn)

abrirBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	abrirBtn.Visible = false
end)

close.MouseButton1Click:Connect(function()
	main.Visible = false
	abrirBtn.Visible = true
end)

local tabs = {
	["Movimentação"] = {},
	["Funções"] = {},
}

local tabButtons = {}
local currentTab = nil

local tabHolder = Instance.new("Frame", main)
tabHolder.Size = UDim2.new(0, 100, 1, -40)
tabHolder.Position = UDim2.new(0, 0, 0, 40)
tabHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", tabHolder)

local contentHolder = Instance.new("Frame", main)
contentHolder.Size = UDim2.new(1, -110, 1, -40)
contentHolder.Position = UDim2.new(0, 110, 0, 40)
contentHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
contentHolder.ClipsDescendants = true
Instance.new("UICorner", contentHolder)

local function createTab(name)
	local button = Instance.new("TextButton", tabHolder)
	button.Size = UDim2.new(1, 0, 0, 40)
	button.Text = name
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	button.TextColor3 = Color3.new(1,1,1)
	button.BorderSizePixel = 0
	Instance.new("UICorner", button)

	local content = Instance.new("Frame", contentHolder)
	content.Size = UDim2.new(1, 0, 1, 0)
	content.Visible = false
	content.BackgroundTransparency = 1

	tabButtons[name] = {button = button, content = content}
	tabs[name] = content

	button.MouseButton1Click:Connect(function()
		for n, tb in pairs(tabButtons) do
			tb.content.Visible = false
		end
		content.Visible = true
		currentTab = name
	end)
end

-- Criar tabs
createTab("Movimentação")
createTab("Funções")
tabButtons["Movimentação"].content.Visible = true
currentTab = "Movimentação"

-- Criação de botão simples ON/OFF
local function criarBotao(nome, parent, callback)
	local botao = Instance.new("TextButton", parent)
	botao.Size = UDim2.new(0, 150, 0, 30)
	botao.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	botao.TextColor3 = Color3.new(1, 1, 1)
	botao.BorderSizePixel = 0
	Instance.new("UICorner", botao)

	local ativo = false
	botao.Text = nome .. ": OFF"

	botao.MouseButton1Click:Connect(function()
		ativo = not ativo
		botao.Text = nome .. ": " .. (ativo and "ON" or "OFF")
		callback(ativo)
	end)
end

-- Criação de botões + e - para valores
local function criarAjustador(nome, parent, valorInicial, onChange)
	local valor = valorInicial

	local label = Instance.new("TextLabel", parent)
	label.Size = UDim2.new(0, 150, 0, 20)
	label.Text = nome .. ": " .. valor
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1

	local mais = Instance.new("TextButton", parent)
	mais.Size = UDim2.new(0, 30, 0, 20)
	mais.Position = UDim2.new(0, 155, 0, label.Position.Y.Offset)
	mais.Text = "+"
	mais.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	Instance.new("UICorner", mais)

	local menos = Instance.new("TextButton", parent)
	menos.Size = UDim2.new(0, 30, 0, 20)
	menos.Position = UDim2.new(0, 190, 0, label.Position.Y.Offset)
	menos.Text = "-"
	menos.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	Instance.new("UICorner", menos)

	local function atualizar()
		label.Text = nome .. ": " .. valor
		onChange(valor)
	end

	mais.MouseButton1Click:Connect(function()
		valor += 1
		atualizar()
	end)

	menos.MouseButton1Click:Connect(function()
		valor -= 1
		atualizar()
	end)

	atualizar()
end

-- Funções

-- Gravidade Zero
criarBotao("Gravidade Zero", tabs["Funções"], function(state)
	gravidadeAtiva = state
	if state then
		character.Humanoid.UseJumpPower = true
		character.Humanoid.JumpPower = 200
	else
		character.Humanoid.JumpPower = 50
	end
end)

-- Noclip
criarBotao("Noclip", tabs["Funções"], function(state)
	noclipAtivo = state
end)

game:GetService("RunService").Stepped:Connect(function()
	if noclipAtivo then
		for _, v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

-- Kill Aura
criarBotao("Kill Aura", tabs["Funções"], function(state)
	killAuraAtiva = state
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if killAuraAtiva then
		for _, plr in pairs(game.Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if (plr.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 10 then
					plr.Character:FindFirstChildOfClass("Humanoid").Health = 0
				end
			end
		end
	end
end)

-- Tp Tool
criarBotao("Tp Tool", tabs["Funções"], function(state)
	tpToolAtivo = state
	if state then
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Tp-tool-script-5767"))()
	else
		local tool = player.Backpack:FindFirstChild("TpTool")
		if tool then tool:Destroy() end
	end
end)

-- Curar Vida
local healBtn = Instance.new("TextButton", tabs["Funções"])
healBtn.Size = UDim2.new(0, 150, 0, 30)
healBtn.Text = "Curar Vida"
healBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
healBtn.TextColor3 = Color3.new(1, 1, 1)
healBtn.BorderSizePixel = 0
Instance.new("UICorner", healBtn)

healBtn.MouseButton1Click:Connect(function()
	character:FindFirstChildOfClass("Humanoid").Health = character:FindFirstChildOfClass("Humanoid").MaxHealth
end)

-- Reset Rápido
local resetBtn = Instance.new("TextButton", tabs["Funções"])
resetBtn.Size = UDim2.new(0, 150, 0, 30)
resetBtn.Text = "Reset Rápido"
resetBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
resetBtn.TextColor3 = Color3.new(1, 1, 1)
resetBtn.BorderSizePixel = 0
Instance.new("UICorner", resetBtn)

resetBtn.MouseButton1Click:Connect(function()
	character:BreakJoints()
end)

-- Velocidade
criarAjustador("Velocidade", tabs["Movimentação"], 16, function(v)
	velocidade = v
	character.Humanoid.WalkSpeed = velocidade
end)

-- Pulo
criarAjustador("Pulo", tabs["Movimentação"], 50, function(v)
	forcaPulo = v
	character.Humanoid.JumpPower = forcaPulo
end)

-- Créditos
local creditos = Instance.new("TextLabel", main)
creditos.Size = UDim2.new(1, 0, 0, 30)
creditos.Position = UDim2.new(0, 0, 0, 0)
creditos.BackgroundTransparency = 1
creditos.Text = "Moon Hub 🌙 | by Miguel"
creditos.TextColor3 = Color3.fromRGB(255, 255, 255)
creditos.TextScaled = true
-- Moon Hub Launcher 🌙 por Miguel

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Criar tela
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MoonHubLauncher"
ScreenGui.ResetOnSpawn = false

-- Janela principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Visible = true

-- UICorner e sombra
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(85, 85, 85)

-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Moon Hub🌙"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- Subtítulo
local Subtitle = Instance.new("TextLabel", MainFrame)
Subtitle.Size = UDim2.new(1, 0, 0, 30)
Subtitle.Position = UDim2.new(0, 0, 0, 50)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Escolha sua versão preferida"
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.Gotham

-- Função botão
local function criarBotao(nome, posY, link)
	local Btn = Instance.new("TextButton", MainFrame)
	Btn.Size = UDim2.new(0.8, 0, 0, 40)
	Btn.Position = UDim2.new(0.1, 0, 0, posY)
	Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Btn.Text = nome
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextScaled = true
	Btn.Font = Enum.Font.GothamBold

	local UICornerBtn = Instance.new("UICorner", Btn)
	UICornerBtn.CornerRadius = UDim.new(0, 8)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		}):Play()
	end)

	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		}):Play()
	end)

	Btn.MouseButton1Click:Connect(function()
		pcall(function()
			loadstring(game:HttpGet(link))()
			MainFrame.Visible = false
			OpenButton.Visible = true
		end)
	end)
end

-- Botões
criarBotao("🌑 Versão Simples", 100, "https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_Simples.lua")
criarBotao("🌓 Versão com Abas", 150, "https://raw.githubusercontent.com/MiguelOfcxD/Moon-Hub/refs/heads/main/MoonHub_abas.lua")

-- Créditos
local Credits = Instance.new("TextLabel", MainFrame)
Credits.Size = UDim2.new(1, 0, 0, 25)
Credits.Position = UDim2.new(0, 0, 1, -25)
Credits.BackgroundTransparency = 1
Credits.Text = "Feito por Miguel"
Credits.TextColor3 = Color3.fromRGB(120, 120, 120)
Credits.TextScaled = true
Credits.Font = Enum.Font.Gotham

-- Botão Fechar
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundTransparency = 1

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	OpenButton.Visible = true
end)

-- Botão Abrir
OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size = UDim2.new(0, 120, 0, 35)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.Text = "Abrir Moon Hub🌙"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextScaled = true
OpenButton.Font = Enum.Font.Gotham
OpenButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OpenButton.Visible = false

local UICornerOpen = Instance.new("UICorner", OpenButton)
UICornerOpen.CornerRadius = UDim.new(0, 8)

OpenButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	OpenButton.Visible = false
end)

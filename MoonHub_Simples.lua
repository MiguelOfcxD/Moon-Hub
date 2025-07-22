-- MoonHub Simples 🌙 by Miguel

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

-- UI Proteção
pcall(function() syn.protect_gui(game.CoreGui) end)

-- Criação da Interface
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MoonHub_Simples"

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 320)
Frame.Position = UDim2.new(0.5, -200, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundTransparency = 0.05

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Shadow = Instance.new("ImageLabel", Frame)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.7
Shadow.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🌙 Moon Hub - Simples"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- Botão de Fechar
local CloseButton = Instance.new("TextButton", Frame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseButton.BorderSizePixel = 0
local corner = Instance.new("UICorner", CloseButton)
corner.CornerRadius = UDim.new(0, 6)
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Botão para abrir novamente
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size = UDim2.new(0, 120, 0, 35)
OpenButton.Position = UDim2.new(0, 20, 1, -50)
OpenButton.Text = "🌙 Abrir MoonHub"
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
OpenButton.BorderSizePixel = 0
local corner2 = Instance.new("UICorner", OpenButton)
corner2.CornerRadius = UDim.new(0, 8)
OpenButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
end)

-- UIList para os botões
local ButtonList = Instance.new("UIListLayout", Frame)
ButtonList.SortOrder = Enum.SortOrder.LayoutOrder
ButtonList.Padding = UDim.new(0, 6)

-- Container
local Container = Instance.new("Frame", Frame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1

local function criarBotao(nome, callback)
    local Botao = Instance.new("TextButton")
    Botao.Size = UDim2.new(1, 0, 0, 30)
    Botao.Text = nome
    Botao.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    Botao.Font = Enum.Font.Gotham
    Botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    Botao.Parent = Container
    Instance.new("UICorner", Botao).CornerRadius = UDim.new(0, 6)
    Botao.MouseButton1Click:Connect(callback)
end

-- Variáveis de estado
local noclipAtivo = false
local tptoolAtivo = false

-- Funções
criarBotao("Gravidade Zero (ON)", function()
    player.Character:FindFirstChild("Humanoid").UseJumpPower = true
    player.Character.Humanoid.JumpPower = 200
end)

criarBotao("Gravidade Normal (OFF)", function()
    player.Character.Humanoid.JumpPower = 50
end)

criarBotao("Noclip (ON/OFF)", function()
    noclipAtivo = not noclipAtivo
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclipAtivo and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)

criarBotao("Kill Aura", function()
    local hum = player.Character:WaitForChild("HumanoidRootPart")
    game:GetService("RunService").Heartbeat:Connect(function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                if (v.Character.HumanoidRootPart.Position - hum.Position).Magnitude < 10 then
                    v.Character.Humanoid:TakeDamage(5)
                end
            end
        end
    end)
end)

criarBotao("TpTool (ON/OFF)", function()
    tptoolAtivo = not tptoolAtivo
    local tool = player.Backpack:FindFirstChild("TpTool") or player.Character:FindFirstChild("TpTool")
    if tptoolAtivo and not tool then
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Tp-tool-script-5767"))()
    elseif not tptoolAtivo and tool then
        tool:Destroy()
    end
end)

criarBotao("Curar Vida", function()
    if player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
    end
end)

criarBotao("Reset Rápido", function()
    player.Character:BreakJoints()
end)

-- Créditos
local credit = Instance.new("TextLabel", Frame)
credit.Text = "Criado por Miguel"
credit.Size = UDim2.new(1, -10, 0, 20)
credit.Position = UDim2.new(0, 10, 1, -25)
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.TextScaled = true
credit.Font = Enum.Font.Gotham
credit.BackgroundTransparency = 1
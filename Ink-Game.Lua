-- Moon Hub🌙 - Ink Game Edition (100% Mobile)
-- Desenvolvido por Miguel
-- Layout compacto, visual preto/azul, janelas móveis, abas, botões ON/OFF animados

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Moon_Hub"

-- Janela Principal
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 230)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -115)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = true

-- UI Corner e sombra
local UICorner = Instance.new("UICorner", mainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Moon Hub🌙"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1

-- Botão abrir/fechar
local openButton = Instance.new("TextButton", ScreenGui)
openButton.Size = UDim2.new(0, 40, 0, 40)
openButton.Position = UDim2.new(0, 10, 0.5, -20)
openButton.Text = "🌙"
openButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
openButton.TextColor3 = Color3.fromRGB(0, 170, 255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 24
openButton.Visible = false
local corner = Instance.new("UICorner", openButton)
corner.CornerRadius = UDim.new(1, 0)

local function toggleUI()
    mainFrame.Visible = not mainFrame.Visible
    openButton.Visible = not mainFrame.Visible
end

-- Botão fechar
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
local cornerX = Instance.new("UICorner", closeButton)
cornerX.CornerRadius = UDim.new(1, 0)

closeButton.MouseButton1Click:Connect(toggleUI)
openButton.MouseButton1Click:Connect(toggleUI)

-- Tabs
local tabFolder = Instance.new("Folder", mainFrame)
tabFolder.Name = "Tabs"

local tabButtons = {}
local tabContents = {}
local tabNames = {"Movimento", "Funções", "Extras"}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0, 100, 0, 25)
    btn.Position = UDim2.new(0, (i - 1) * 100, 0, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    local content = Instance.new("Frame", tabFolder)
    content.Size = UDim2.new(1, -10, 1, -70)
    content.Position = UDim2.new(0, 5, 0, 65)
    content.BackgroundTransparency = 1
    content.Visible = i == 1

    tabButtons[i] = btn
    tabContents[i] = content

    btn.MouseButton1Click:Connect(function()
        for j = 1, #tabContents do
            tabContents[j].Visible = (i == j)
        end
    end)
end

-- Criador de botões ON/OFF com animação
local function createToggle(parent, name, callback)
    local on = false
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 35)
    button.Text = name .. ": OFF"
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    local toggleCorner = Instance.new("UICorner", button)
    toggleCorner.CornerRadius = UDim.new(0, 6)

    button.MouseButton1Click:Connect(function()
        on = not on
        button.Text = name .. (on and ": ON" or ": OFF")
        button.BackgroundColor3 = on and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 40)
        callback(on)
    end)
end

-- Criador de botões simples
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 35)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(0, 6)
    button.MouseButton1Click:Connect(callback)
end

-- Funções
createToggle(tabContents[1], "Gravidade Zero", function(state)
    workspace.Gravity = state and 0 or 196.2
end)

createToggle(tabContents[1], "Noclip", function(state)
    local conn
    if state then
        conn = game:GetService("RunService").Stepped:Connect(function()
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if conn then conn:Disconnect() end
    end
end)

createToggle(tabContents[2], "TpTool", function(state)
    if state then
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "TpTool"
        tool.Activated:Connect(function()
            local pos = mouse.Hit + Vector3.new(0, 3, 0)
            player.Character:MoveTo(pos.Position)
        end)
        tool.Parent = player.Backpack
    else
        for _, v in pairs(player.Backpack:GetChildren()) do
            if v.Name == "TpTool" then v:Destroy() end
        end
    end
end)

createButton(tabContents[2], "Curar Vida", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
    end
end)

createButton(tabContents[2], "Reset Rápido", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = 0
    end
end)

createToggle(tabContents[3], "Kill Aura", function(state)
    local conn
    if state then
        conn = game:GetService("RunService").Heartbeat:Connect(function()
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                    if (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < 10 then
                        v.Character.Humanoid:TakeDamage(5)
                    end
                end
            end
        end)
    else
        if conn then conn:Disconnect() end
    end
end)

createToggle(tabContents[1], "Velocidade", function(state)
    player.Character.Humanoid.WalkSpeed = state and 50 or 16
end)

createToggle(tabContents[1], "Pulo Alto", function(state)
    player.Character.Humanoid.JumpPower = state and 120 or 50
end)

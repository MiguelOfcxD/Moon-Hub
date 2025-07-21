-- Moon Hub 🌙 com Abas

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MoonHubAbas"

-- Janela principal
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 350)
Main.Position = UDim2.new(0.5, -225, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Text = "Moon Hub🌙"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local CloseButton = Instance.new("TextButton", Main)
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container de abas e painéis
local TabButtonsFrame = Instance.new("Frame", Main)
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 35)
TabButtonsFrame.BackgroundTransparency = 1

local PanelsFrame = Instance.new("Frame", Main)
PanelsFrame.Size = UDim2.new(1, -20, 1, -80)
PanelsFrame.Position = UDim2.new(0, 10, 0, 75)
PanelsFrame.BackgroundTransparency = 1

local function CreateTabButton(name, position)
    local btn = Instance.new("TextButton", TabButtonsFrame)
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.Position = UDim2.new(0, position, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.TextColor3 = Color3.new(1, 1, 1)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

local function CreatePanel()
    local panel = Instance.new("Frame", PanelsFrame)
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    panel.Visible = false
    return panel
end

-- Função auxiliar para criar botão dentro do painel
local function CreatePanelButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (#parent:GetChildren() * 45) - 45) -- vertical empilhamento
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = text
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Variáveis
local speed = 16
local jump = 50
local flyAtivo = false
local noclipAtivo = false
local killAuraAtivo = false
local killAuraConnection

-- Abas
local tabMovement = CreateTabButton("Movimentação", 0)
local tabFunctions = CreateTabButton("Funções", 140)
local tabExtras = CreateTabButton("Extras", 280)

local panelMovement = CreatePanel()
local panelFunctions = CreatePanel()
local panelExtras = CreatePanel()

panelMovement.Visible = true

local function showPanel(panel)
    panelMovement.Visible = false
    panelFunctions.Visible = false
    panelExtras.Visible = false
    panel.Visible = true
end

tabMovement.MouseButton1Click:Connect(function()
    showPanel(panelMovement)
end)

tabFunctions.MouseButton1Click:Connect(function()
    showPanel(panelFunctions)
end)

tabExtras.MouseButton1Click:Connect(function()
    showPanel(panelExtras)
end)

-- Movimento - Velocidade
local btnSpeedUp = CreatePanelButton(panelMovement, "Aumentar Velocidade", function()
    speed = speed + 10
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

local btnSpeedDown = CreatePanelButton(panelMovement, "Diminuir Velocidade", function()
    speed = math.max(0, speed - 10)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

-- Movimento - Pulo
local btnJumpUp = CreatePanelButton(panelMovement, "Aumentar Pulo", function()
    jump = jump + 10
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jump
    end
end)

local btnJumpDown = CreatePanelButton(panelMovement, "Diminuir Pulo", function()
    jump = math.max(0, jump - 10)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jump
    end
end)

-- Funções - Fly
local btnFlyOn = CreatePanelButton(panelFunctions, "Ativar Fly", function()
    if flyAtivo then return end
    flyAtivo = true

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
    local bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)

    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = humanoidRootPart.CFrame

    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0,0,0)

    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyAtivo then
            flyConnection:Disconnect()
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
            return
        end

        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - cam.CFrame.UpVector end

        bodyVelocity.Velocity = moveDir.Unit * speed
        bodyGyro.CFrame = cam.CFrame
    end)
end)

local btnFlyOff = CreatePanelButton(panelFunctions, "Desativar Fly", function()
    flyAtivo = false
end)

-- Funções - Noclip
local btnNoclipOn = CreatePanelButton(panelFunctions, "Ativar Noclip", function()
    noclipAtivo = true
end)

local btnNoclipOff = CreatePanelButton(panelFunctions, "Desativar Noclip", function()
    noclipAtivo = false
end)

RunService.Stepped:Connect(function()
    if noclipAtivo and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Extras - FPS Unlocker
local btnFPSUnlocker = CreatePanelButton(panelExtras, "Desbloquear FPS", function()
    if setfpscap then
        setfpscap(999)
    end
end)

-- Extras - Kill Aura com Fling real
local btnKillAuraOn = CreatePanelButton(panelExtras, "Ativar Kill Aura", function()
    if killAuraAtivo then return end
    killAuraAtivo = true

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    killAuraConnection = RunService.Heartbeat:Connect(function()
        for _, target in pairs(game.Players:GetPlayers()) do
            if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = target.Character.HumanoidRootPart
                local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
                if distance < 7 then
                    targetHRP.Velocity = Vector3.zero
                    targetHRP.AssemblyLinearVelocity = Vector3.zero
                    targetHRP:ApplyImpulse(Vector3.new(9999, 9999, 9999))
                end
            end
        end
    end)
end)

local btnKillAuraOff = CreatePanelButton(panelExtras, "Desativar Kill Aura", function()
    if killAuraConnection then
        killAuraConnection:Disconnect()
        killAuraConnection = nil
    end
    killAuraAtivo = false
end)

-- Resetar variáveis ao morrer
player.CharacterAdded:Connect(function(char)
    flyAtivo = false
    noclipAtivo = false
    if killAuraConnection then
        killAuraConnection:Disconnect()
        killAuraConnection = nil
    end
    killAuraAtivo = false
end)

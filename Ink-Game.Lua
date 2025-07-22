-- Moon Hub🌙 - Ink Game (100% Mobile)
-- Autor: Miguel (adaptado por ChatGPT)
-- Script completo com interface moderna e funções para celular

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Vars de estado
local noclipEnabled = false
local killAuraEnabled = false
local gravityZeroEnabled = false
local tpToolEnabled = false
local tpTool = nil
local speedValue = 16
local jumpPowerValue = 50

-- Cria GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Função auxiliar pra criar botão
local function CreateButton(text, size, position, parent)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.AutoButtonColor = false
    btn.Parent = parent
    btn.ZIndex = 10
    btn.AnchorPoint = Vector2.new(0, 0)
    -- efeito toque simples
    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    end)
    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end)
    return btn
end

-- Função auxiliar pra criar slider
local function CreateSlider(text, min, max, default, size, position, parent)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(40,40,50)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text .. ": " .. tostring(default)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,0,0,20)
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 20)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(70,70,90)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    sliderBg.ClipsDescendants = true
    sliderBg.AnchorPoint = Vector2.new(0,0)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local dragging = false
    local value = default

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderBg.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local x = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = x / sliderBg.AbsoluteSize.X
            value = min + (max - min) * percent
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. math.floor(value)
            if text == "Velocidade" then
                speedValue = value
                humanoid.WalkSpeed = speedValue
            elseif text == "Pulo" then
                jumpPowerValue = value
                humanoid.JumpPower = jumpPowerValue
            end
        end
    end)

    return frame
end

-- Cria janela principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 460)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0, 0)
mainFrame.Parent = ScreenGui
mainFrame.ClipsDescendants = true
mainFrame.Active = true

-- Bordas arredondadas e sombra (UIStroke + UIGradient)
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 16)
uicorner.Parent = mainFrame

local uistroke = Instance.new("UIStroke")
uistroke.Color = Color3.fromRGB(0, 120, 255)
uistroke.Thickness = 2
uistroke.Parent = mainFrame

-- Cabeçalho da janela
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,44)
header.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerText = Instance.new("TextLabel")
headerText.Text = "Moon Hub🌙"
headerText.Font = Enum.Font.GothamBold
headerText.TextSize = 26
headerText.TextColor3 = Color3.fromRGB(0, 170, 255)
headerText.BackgroundTransparency = 1
headerText.Size = UDim2.new(1, -44, 1, 0)
headerText.Position = UDim2.new(0, 12, 0, 0)
headerText.TextXAlignment = Enum.TextXAlignment.Left
headerText.Parent = header

-- Botão fechar (com ícone de lua simples)
local closeButton = Instance.new("ImageButton")
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -40, 0, 6)
closeButton.BackgroundTransparency = 1
closeButton.Image = "rbxassetid://10817464012" -- Ícone de lua simples
closeButton.Parent = header
closeButton.ZIndex = 20
closeButton.AutoButtonColor = false

closeButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- Permite arrastar a janela pelo header via toque
local dragging = false
local dragInput
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        mainFrame.Position = UDim2.new(
            math.clamp(startPos.X.Scale, 0, 1),
            math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - mainFrame.AbsoluteSize.X),
            math.clamp(startPos.Y.Scale, 0, 1),
            math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - mainFrame.AbsoluteSize.Y)
        )
    end
end)

-- Velocidade (slider)
local speedSlider = CreateSlider("Velocidade", 8, 100, 16, UDim2.new(1, -20, 0, 60), UDim2.new(0, 10, 0, 60), mainFrame)

-- Pulo alto (slider)
local jumpSlider = CreateSlider("Pulo", 30, 150, 50, UDim2.new(1, -20, 0, 60), UDim2.new(0, 10, 0, 140), mainFrame)

-- Gravidade Zero (toggle button)
local gravityBtn = CreateButton("Gravidade Zero: OFF", UDim2.new(0.5, -15, 0, 40), UDim2.new(0, 10, 0, 220), mainFrame)
gravityBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
gravityBtn.MouseButton1Click:Connect(function()
    gravityZeroEnabled = not gravityZeroEnabled
    if gravityZeroEnabled then
        gravityBtn.Text = "Gravidade Zero: ON"
        gravityBtn.TextColor3 = Color3.fromRGB(100, 255, 255)
        humanoid.PlatformStand = true
        workspace.Gravity = 0
    else
        gravityBtn.Text = "Gravidade Zero: OFF"
        gravityBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        humanoid.PlatformStand = false
        workspace.Gravity = 196.2
    end
end)

-- Noclip (toggle button)
local noclipBtn = CreateButton("Noclip: OFF", UDim2.new(0.5, -15, 0, 40), UDim2.new(0.5, 5, 0, 220), mainFrame)
noclipBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "Noclip: ON"
        noclipBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        noclipBtn.Text = "Noclip: OFF"
        noclipBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        -- Garantir colisão normal ao desligar
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Kill Aura (toggle button)
local killAuraBtn = CreateButton("Kill Aura: OFF", UDim2.new(1, 0, 0, 40), UDim2.new(0, 10, 0, 280), mainFrame)
killAuraBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
killAuraBtn.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        killAuraBtn.Text = "Kill Aura: ON"
        killAuraBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
    else
        killAuraBtn.Text = "Kill Aura: OFF"
        killAuraBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Função Kill Aura simples, sem fling
RunService.Heartbeat:Connect(function()
    if killAuraEnabled and character and rootPart and character:FindFirstChild("HumanoidRootPart") then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") then
                local dist = (otherPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if dist <= 15 and otherPlayer.Character.Humanoid.Health > 0 then
                    -- Aplicar dano simples sem fling, diminuindo a vida do inimigo diretamente
                    otherPlayer.Character.Humanoid:TakeDamage(10)
                end
            end
        end
    end
end)

-- Teleport Tool com botão ON/OFF
local tpBtn = CreateButton("TpTool: OFF", UDim2.new(1, 0, 0, 40), UDim2.new(0, 10, 0, 330), mainFrame)
tpBtn.TextColor3 = Color3.fromRGB(255, 100, 100)

local function createTpTool()
    local tool = Instance.new("Tool")
    tool.Name = "TpTool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    local remote = Instance.new("RemoteEvent")
    remote.Name = "TpRemote"
    remote.Parent = tool

    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        if mouse and mouse.Target then
            local targetPos = mouse.Hit + Vector3.new(0, 3, 0)
            rootPart.CFrame = CFrame.new(targetPos.Position)
        end
    end)
    return tool
end

tpBtn.MouseButton1Click:Connect(function()
    tpToolEnabled = not tpToolEnabled
    if tpToolEnabled then
        tpBtn.Text = "TpTool: ON"
        tpBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        if not tpTool then
            tpTool = createTpTool()
            tpTool.Parent = player.Backpack
        end
        player.Character.Humanoid:EquipTool(tpTool)
    else
        tpBtn.Text = "TpTool: OFF"
        tpBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        if tpTool then
            tpTool.Parent = nil
        end
    end
end)

-- Curar vida (botão)
local healBtn = CreateButton("Curar Vida", UDim2.new(1, 0, 0, 40), UDim2.new(0, 10, 0, 380), mainFrame)
healBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
healBtn.MouseButton1Click:Connect(function()
    if humanoid and humanoid.Health > 0 then
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- Reset rápido (botão)
local resetBtn = CreateButton("Reset Rápido", UDim2.new(1, 0, 0, 40), UDim2.new(0, 10, 0, 430), mainFrame)
resetBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
resetBtn.MouseButton1Click:Connect(function()
    player:LoadCharacter()
end)

-- Noclip loop
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Inicializar valores
humanoid.WalkSpeed = speedValue
humanoid.JumpPower = jumpPowerValue

return ScreenGui
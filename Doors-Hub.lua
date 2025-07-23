-- Moon Hub 🌙 para Doors (compatível 100% celular)
-- Funções: Auto abrir portas, auto coletar itens, speed hack, pulo alto, noclip, auto sprint
-- Interface móvel, estilo moderno, botão abrir/fechar com ícone de lua

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Vars de estado
local autoDoor = false
local autoCollect = false
local speedHack = false
local highJump = false
local noclip = false
local autoSprint = false

local normalWalkSpeed = humanoid.WalkSpeed
local normalJumpPower = humanoid.JumpPower

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonHubDoors"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 320)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = ScreenGui
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Selectable = true
mainFrame.AutoButtonColor = false
mainFrame.ZIndex = 10
mainFrame.BackgroundTransparency = 0.1
mainFrame.Modal = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "Moon Hub 🌙 - Doors"
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(180, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "🌙"
closeBtn.TextSize = 28
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 255)
closeBtn.Parent = mainFrame

local container = Instance.new("Frame")
container.Position = UDim2.new(0, 10, 0, 50)
container.Size = UDim2.new(1, -20, 1, -60)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Função para criar botão toggle com animação ON/OFF
local function createToggleButton(text, initialState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.AutoButtonColor = false
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = container
    btn.Margin = 6
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local on = false
    local function updateText()
        if on then
            btn.Text = text .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(40, 150, 240)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        end
    end
    
    on = initialState or false
    updateText()
    
    btn.MouseButton1Click:Connect(function()
        on = not on
        updateText()
        callback(on)
    end)
    
    return btn
end

-- Função para auto abrir portas
local function autoOpenDoors()
    RunService.Heartbeat:Connect(function()
        if autoDoor then
            local doorsFolder = workspace:FindFirstChild("Doors") or workspace:FindFirstChild("Door")
            if doorsFolder then
                for _, door in pairs(doorsFolder:GetChildren()) do
                    if door:IsA("Model") and door:FindFirstChild("Door") and door:FindFirstChild("Open") then
                        local doorPart = door:FindFirstChild("Door")
                        local openEvent = door:FindFirstChild("Open")
                        if doorPart and openEvent then
                            local dist = (doorPart.Position - rootPart.Position).Magnitude
                            if dist < 8 then
                                pcall(function()
                                    openEvent:FireServer()
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Função para auto coletar itens importantes
local function autoCollectItems()
    RunService.Heartbeat:Connect(function()
        if autoCollect then
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Tool") or item:IsA("Part") then
                    if item.Name == "Flashlight" or item.Name == "Key" or item.Name == "Vase" or item.Name == "Knife" then
                        local dist = (item.Position - rootPart.Position).Magnitude
                        if dist < 15 then
                            pcall(function()
                                item.CFrame = rootPart.CFrame * CFrame.new(0, 0, -2)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

-- Speed hack
local function setSpeed(state)
    if state then
        humanoid.WalkSpeed = 24
    else
        humanoid.WalkSpeed = normalWalkSpeed
    end
end

-- Pulo alto
local function setJump(state)
    if state then
        humanoid.JumpPower = 75
    else
        humanoid.JumpPower = normalJumpPower
    end
end

-- Noclip
local function noclipLoop()
    RunService.Stepped:Connect(function()
        if noclip then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and not part.CanCollide then
                    part.CanCollide = true
                end
            end
        end
    end)
end

-- Auto Sprint (andar correndo automaticamente)
local function autoSprintLoop()
    RunService.Heartbeat:Connect(function()
        if autoSprint then
            humanoid.WalkSpeed = 24
        elseif not speedHack then
            humanoid.WalkSpeed = normalWalkSpeed
        end
    end)
end

-- Criar botões e ligar funções

createToggleButton("Auto Abrir Portas", false, function(state)
    autoDoor = state
end)

createToggleButton("Auto Coletar Itens", false, function(state)
    autoCollect = state
end)

createToggleButton("Speed Hack", false, function(state)
    speedHack = state
    setSpeed(state)
end)

createToggleButton("Pulo Alto", false, function(state)
    highJump = state
    setJump(state)
end)

createToggleButton("Noclip", false, function(state)
    noclip = state
end)

createToggleButton("Auto Sprint", false, function(state)
    autoSprint = state
end)

noclipLoop()
autoOpenDoors()
autoCollectItems()
autoSprintLoop()

-- Botão abrir/fechar menu
local toggleVisible = true
closeBtn.MouseButton1Click:Connect(function()
    toggleVisible = not toggleVisible
    if toggleVisible then
        mainFrame.Visible = true
    else
        mainFrame.Visible = false
    end
end)

-- Atualiza character se morrer / resetar
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = normalWalkSpeed
    humanoid.JumpPower = normalJumpPower
end)

print("Moon Hub 🌙 - Doors script carregado com sucesso!")
-- Moon Hub Simples 🌙 - Estilo KRNL moderno, janelas móveis, gravidade nula, teleporte

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "MoonHubSimpleGui"
gui.ResetOnSpawn = false

-- Settings
local speed = 16
local jump = 50
local zeroGravEnabled = false
local noclipEnabled = false
local fpsUnlockerEnabled = false
local killAuraEnabled = false
local tpToolEnabled = false

local gravityOriginal = workspace.Gravity

-- Utility Functions
local function toggleZeroGravity(on)
    if on then
        workspace.Gravity = 0
    else
        workspace.Gravity = gravityOriginal
    end
end

local function toggleNoclip(on)
    if on then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function toggleFPSUnlocker(on)
    if on then
        settings().Rendering.QualityLevel = 1 -- mínimo
        settings().Rendering.FrameRateManager.Enable = false
    else
        settings().Rendering.QualityLevel = 10 -- padrão
        settings().Rendering.FrameRateManager.Enable = true
    end
end

local function fling(victim)
    if victim and victim.Character and victim.Character:FindFirstChild("HumanoidRootPart") then
        local hrpVictim = victim.Character.HumanoidRootPart
        local force = Instance.new("BodyVelocity")
        force.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        force.Velocity = Vector3.new(0, 100, 0)
        force.Parent = hrpVictim
        delay(0.3, function() force:Destroy() end)
    end
end

-- Kill Aura
local function runKillAura()
    while killAuraEnabled do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < 10 then
                    fling(player)
                end
            end
        end
        wait(0.5)
    end
end

-- Teleport Tool (baseado no RawScripts)
local mouse = LocalPlayer:GetMouse()
local teleportTool

local function createTpTool()
    teleportTool = Instance.new("Tool")
    teleportTool.Name = "TP Tool"
    teleportTool.RequiresHandle = false
    teleportTool.CanBeDropped = false

    teleportTool.Activated:Connect(function()
        local targetPos = mouse.Hit.p
        if targetPos then
            if character and hrp then
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            end
        end
    end)
end

local function equipTpTool()
    if not teleportTool then createTpTool() end
    teleportTool.Parent = LocalPlayer.Backpack
    LocalPlayer.Character.Humanoid:EquipTool(teleportTool)
end

local function removeTpTool()
    if teleportTool and teleportTool.Parent then
        teleportTool.Parent = nil
    end
end

-- GUI Elements
local function createButton(text, posY, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)

    return btn
end

local function createToggleButton(text, posY, parent, initialState, callback)
    local btn = createButton(text .. ": OFF", posY, parent)
    local state = initialState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
    return btn
end

local function createSlider(labelText, posY, defaultValue, minVal, maxVal, callback)
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(0.4, 0, 0, 25)
    label.Position = UDim2.new(0.1, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.Text = labelText .. ": " .. defaultValue

    local plusBtn = Instance.new("TextButton", gui)
    plusBtn.Size = UDim2.new(0, 25, 0, 25)
    plusBtn.Position = UDim2.new(0.52, 0, 0, posY)
    plusBtn.Text = "+"
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 20
    plusBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    plusBtn.TextColor3 = Color3.new(1,1,1)

    local minusBtn = Instance.new("TextButton", gui)
    minusBtn.Size = UDim2.new(0, 25, 0, 25)
    minusBtn.Position = UDim2.new(0.42, 0, 0, posY)
    minusBtn.Text = "-"
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 20
    minusBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
    minusBtn.TextColor3 = Color3.new(1,1,1)

    plusBtn.MouseButton1Click:Connect(function()
        if defaultValue < maxVal then
            defaultValue += 1
            label.Text = labelText .. ": " .. defaultValue
            callback(defaultValue)
        end
    end)
    minusBtn.MouseButton1Click:Connect(function()
        if defaultValue > minVal then
            defaultValue -= 1
            label.Text = labelText .. ": " .. defaultValue
            callback(defaultValue)
        end
    end)

    return label, plusBtn, minusBtn
end

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moon Hub Simples 🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 30
title.TextColor3 = Color3.new(1, 1, 1)

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 1

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)

-- Open button
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 130, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.Text = "Abrir Moon Hub Simples"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openBtn.Visible = false

local openCorner = Instance.new("UICorner", openBtn)
openCorner.CornerRadius = UDim.new(0, 10)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)

-- Velocidade
local speedLabel, speedPlus, speedMinus = createSlider("Velocidade", 60, speed, 0, 200, function(val)
    speed = val
    humanoid.WalkSpeed = speed
end)
speedLabel.Parent = frame
speedPlus.Parent = frame
speedMinus.Parent = frame

-- Pulo
local jumpLabel, jumpPlus, jumpMinus = createSlider("Pulo", 110, jump, 0, 200, function(val)
    jump = val
    humanoid.JumpPower = jump
end)
jumpLabel.Parent = frame
jumpPlus.Parent = frame
jumpMinus.Parent = frame

-- Zero Gravity toggle
local zeroGravBtn = createToggleButton("Gravidade Nula", 160, frame, zeroGravEnabled, function(state)
    zeroGravEnabled = state
    toggleZeroGravity(state)
end)

-- Noclip toggle
local noclipBtn = createToggleButton("Noclip", 210, frame, noclipEnabled, function(state)
    noclipEnabled = state
    toggleNoclip(state)
end)

-- FPS Unlocker toggle
local fpsBtn = createToggleButton("FPS Unlocker", 260, frame, fpsUnlockerEnabled, function(state)
    fpsUnlockerEnabled = state
    toggleFPSUnlocker(state)
end)

-- Kill Aura toggle
local killAuraBtn = createToggleButton("Kill Aura", 310, frame, killAuraEnabled, function(state)
    killAuraEnabled = state
    if state then
        coroutine.wrap(runKillAura)()
    end
end)

-- Teleport Tool toggle (Extra)
local tpBtn = createToggleButton("TP Tool 🧭", 360, frame, tpToolEnabled, function(state)
    tpToolEnabled = state
    if state then
        equipTpTool()
    else
        removeTpTool()
    end
end)

-- Atualizar noclip constantemente para garantir
RunService.Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Limpar gravidade ao resetar personagem
LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    workspace.Gravity = gravityOriginal
    zeroGravEnabled = false
    noclipEnabled = false
    fpsUnlockerEnabled = false
    killAuraEnabled = false
    tpToolEnabled = false
    removeTpTool()
end)

humanoid.WalkSpeed = speed
humanoid.JumpPower = jump

return gui
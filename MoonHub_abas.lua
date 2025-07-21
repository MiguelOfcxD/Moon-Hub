-- Moon Hub Com Abas 🌙 - Estilo KRNL moderno, abas, gravidade nula, teleporte

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "MoonHubAbasGui"
gui.ResetOnSpawn = false

local speed = 16
local jump = 50
local zeroGravEnabled = false
local noclipEnabled = false
local fpsUnlockerEnabled = false
local killAuraEnabled = false
local tpToolEnabled = false

local gravityOriginal = workspace.Gravity

-- Functions

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
        settings().Rendering.QualityLevel = 1
        settings().Rendering.FrameRateManager.Enable = false
    else
        settings().Rendering.QualityLevel = 10
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

-- Teleport Tool
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

-- GUI Creation helpers
local function createButton(text, posY, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

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

local function createSlider(labelText, posY, defaultValue, minVal, maxVal, parent, callback)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0.5, 0, 0, 25)
    label.Position = UDim2.new(0.1, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.Text = labelText .. ": " .. defaultValue

    local plusBtn = Instance.new("TextButton", parent)
    plusBtn.Size = UDim2.new(0, 25, 0, 25)
    plusBtn.Position = UDim2.new(0.62, 0, 0, posY)
    plusBtn.Text = "+"
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 20
    plusBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    plusBtn.TextColor3 = Color3.new(1,1,1)

    local minusBtn = Instance.new("TextButton", parent)
    minusBtn.Size = UDim2.new(0, 25, 0, 25)
    minusBtn.Position = UDim2.new(0.52, 0, 0, posY)
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
frame.Size = UDim2.new(0, 450, 0, 380)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moon Hub Com Abas 🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 32
title.TextColor3 = Color3.new(1, 1, 1)

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0, 6)
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
openBtn.Size = UDim2.new(0, 140, 0, 40)
openBtn.Position = UDim2.new(0, 15, 0, 15)
openBtn.Text = "Abrir Moon Hub Abas"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openBtn.Visible = false

local openCorner = Instance.new("UICorner", openBtn)
openCorner.CornerRadius = UDim.new(0, 12)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    openBtn.Visible = false
end)

-- Tabs setup
local tabButtonsFolder = Instance.new("Folder", frame)
local panelsFolder = Instance.new("Folder", frame)

local tabs = {
    {Name = "Movimentação"},
    {Name = "Funções"},
    {Name = "Extras"}
}

local activePanel = nil

local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 130, 0, 40)
    btn.Position = UDim2.new(0, posX, 0, 55)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        if activePanel ~= name then
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end)
    btn.MouseLeave:Connect(function()
        if activePanel ~= name then
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtonsFolder:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        activePanel = name

        for _, p in pairs(panelsFolder:GetChildren()) do
            if p:IsA("Frame") then
                p.Visible = false
            end
        end
        local panel = panelsFolder:FindFirstChild(name .. "Panel")
        if panel then
            panel.Visible = true
        end
    end)

    btn.Parent = tabButtonsFolder
    return btn
end

-- Create Tabs and Panels
for i, tabInfo in ipairs(tabs) do
    local btn = createTabButton(tabInfo.Name, (i -1) * 140 + 10)
    if i == 1 then
        btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        activePanel = tabInfo.Name
    end

    local panel = Instance.new("Frame", panelsFolder)
    panel.Name = tabInfo.Name .. "Panel"
    panel.Size = UDim2.new(1, -20, 1, -110)
    panel.Position = UDim2.new(0, 10, 0, 105)
    panel.BackgroundTransparency = 1
    panel.Visible = i == 1
end

local movementPanel = panelsFolder.MovimentaçãoPanel
local functionsPanel = panelsFolder.FunçõesPanel
local extrasPanel = panelsFolder.ExtrasPanel

-- Movimento Panel: Velocidade e Pulo
local speedLabel, speedPlus, speedMinus = createSlider("Velocidade", 10, speed, 0, 200, movementPanel, function(val)
    speed = val
    humanoid.WalkSpeed = speed
end)

local jumpLabel, jumpPlus, jumpMinus = createSlider("Pulo", 60, jump, 0, 200, movementPanel, function(val)
    jump = val
    humanoid.JumpPower = jump
end)

-- Funções Panel: Gravidade Nula e Noclip
local zeroGravBtn = createToggleButton("Gravidade Nula", 10, functionsPanel, zeroGravEnabled, function(state)
    zeroGravEnabled = state
    toggleZeroGravity(state)
end)

local noclipBtn = createToggleButton("Noclip", 60, functionsPanel, noclipEnabled, function(state)
    noclipEnabled = state
    toggleNoclip(state)
end)

-- Extras Panel: FPS Unlocker, Kill Aura e Teleport Tool
local fpsBtn = createToggleButton("FPS Unlocker", 10, extrasPanel, fpsUnlockerEnabled, function(state)
    fpsUnlockerEnabled = state
    toggleFPSUnlocker(state)
end)

local killAuraBtn = createToggleButton("Kill Aura", 60, extrasPanel, killAuraEnabled, function(state)
    killAuraEnabled = state
    if state then
        coroutine.wrap(runKillAura)()
    end
end)

local tpBtn = createToggleButton("TP Tool 🧭", 110, extrasPanel, tpToolEnabled, function(state)
    tpToolEnabled = state
    if state then
        equipTpTool()
    else
        removeTpTool()
    end
end)

-- Atualizar noclip sempre ativo
RunService.Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Resetar personagem
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
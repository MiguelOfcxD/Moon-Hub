-- MoonHub Simples - Versão Atualizada (Sem Abas)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Estado das funções
local flyEnabled = false
local noclipEnabled = false

-- Configs iniciais
local walkSpeed = 16
local jumpPower = 50

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão abrir/fechar
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -50, 0, 20)
toggleBtn.AnchorPoint = Vector2.new(0, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://6031075938" -- lua
toggleBtn.Parent = gui

-- Janela principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 10)

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Text = "X"
closeBtn.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moon Hub 🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Helper para criar sliders
local function createSlider(parent, labelText, yPos, initialValue, minValue, maxValue, callback)
    local value = initialValue

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.Text = labelText .. ": " .. value
    label.Parent = parent

    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0, 30, 0, 25)
    plus.Position = UDim2.new(0, 250, 0, yPos)
    plus.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    plus.TextColor3 = Color3.new(1, 1, 1)
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 20
    plus.Text = "+"
    plus.Parent = parent

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0, 30, 0, 25)
    minus.Position = UDim2.new(0, 210, 0, yPos)
    minus.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
    minus.TextColor3 = Color3.new(1, 1, 1)
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 20
    minus.Text = "-"
    minus.Parent = parent

    local function updateValue(newVal)
        value = math.clamp(newVal, minValue, maxValue)
        label.Text = labelText .. ": " .. value
        if callback then callback(value) end
    end

    plus.MouseButton1Click:Connect(function()
        updateValue(value + 1)
    end)

    minus.MouseButton1Click:Connect(function()
        updateValue(value - 1)
    end)

    return label, plus, minus, function() return value end
end

-- Velocidade slider
local speedLabel, speedPlus, speedMinus, getSpeed = createSlider(frame, "Velocidade", 50, walkSpeed, 0, 250, function(v)
    walkSpeed = v
    humanoid.WalkSpeed = walkSpeed
end)

-- Pulo slider
local jumpLabel, jumpPlus, jumpMinus, getJump = createSlider(frame, "Pulo", 100, jumpPower, 0, 250, function(v)
    jumpPower = v
    humanoid.JumpPower = jumpPower
end)

-- Helper para toggle button (ON/OFF)
local function createToggleButton(parent, text, yPos, initialState, callback)
    local state = initialState
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = text .. ": OFF"
    btn.Parent = parent

    local function update()
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        if callback then callback(state) end
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        update()
    end)

    update()
    return btn, function() return state end, function(s)
        state = s
        update()
    end
end

-- Fly toggle e funções
local bodyGyro, bodyVelocity

local function toggleFly(on)
    if on then
        humanoid.PlatformStand = true
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.P = 9e4
        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
    else
        humanoid.PlatformStand = false
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    end
end

local flyBtn, isFlyOn, setFlyOn = createToggleButton(frame, "Fly", 150, flyEnabled, function(state)
    flyEnabled = state
    toggleFly(flyEnabled)
end)

RunService.Heartbeat:Connect(function()
    if flyEnabled and bodyGyro and bodyVelocity then
        local cam = workspace.CurrentCamera
        local moveVector = Vector3.new(0,0,0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector -= cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector += Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector -= Vector3.new(0,1,0)
        end

        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * 50
            bodyVelocity.Velocity = moveVector
            bodyGyro.CFrame = cam.CFrame
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Noclip toggle
local noclipBtn, isNoclipOn, setNoclipOn = createToggleButton(frame, "Noclip", 200, noclipEnabled, function(state)
    noclipEnabled = state
end)

RunService.Stepped:Connect(function()
    if noclipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Extras FPS Unlocker e Kill Aura
local fpsUnlockerEnabled = false
local killAuraEnabled = false
local killAuraRadius = 15

local fpsBtn, isFpsOn, setFpsOn = createToggleButton(frame, "FPS Unlocker", 250, fpsUnlockerEnabled, function(state)
    fpsUnlockerEnabled = state
    if fpsUnlockerEnabled then
        setfpscap(1000)
    else
        setfpscap(60)
    end
end)

local killAuraBtn, isKillAuraOn, setKillAuraOn = createToggleButton(frame, "Kill Aura", 300, killAuraEnabled, function(state)
    killAuraEnabled = state
end)

RunService.Heartbeat:Connect(function()
    if killAuraEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = plr.Character.HumanoidRootPart
                local dist = (hrp.Position - targetHRP.Position).Magnitude
                if dist <= killAuraRadius then
                    local bodyVelocityFling = Instance.new("BodyVelocity")
                    bodyVelocityFling.Velocity = (targetHRP.Position - hrp.Position).Unit * 100
                    bodyVelocityFling.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bodyVelocityFling.Parent = targetHRP
                    game.Debris:AddItem(bodyVelocityFling, 0.3)
                end
            end
        end
    end
end)

-- Botões abrir/fechar janela
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Atualizar humanoid com valores iniciais
humanoid.WalkSpeed = walkSpeed
humanoid.JumpPower = jumpPower

-- Reset de personagem: desativa fly e noclip
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
    flyEnabled = false
    noclipEnabled = false
    setFlyOn(false)
    setNoclipOn(false)
    humanoid.WalkSpeed = walkSpeed
    humanoid.JumpPower = jumpPower
end)

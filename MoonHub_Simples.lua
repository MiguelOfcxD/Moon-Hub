-- Moon Hub Simples - Com TP Tool integrada, Fly, Noclip, Velocidade, Pulo, Kill Aura e FPS Unlocker

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local backpack = player:WaitForChild("Backpack")
local starterGear = player:WaitForChild("StarterGear")

-- Variáveis globais
local flyEnabled = false
local noclipEnabled = false
local tpToolEnabled = false
local speed = 16
local jump = 50

-- Função para criar a TP Tool no Backpack
local function createTpTool()
    -- Checa se já tem e remove pra evitar duplicatas
    if backpack:FindFirstChild("TpTool") then
        backpack.TpTool:Destroy()
    end
    if starterGear:FindFirstChild("TpTool") then
        starterGear.TpTool:Destroy()
    end

    local tool = Instance.new("Tool")
    tool.Name = "TpTool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    -- Script interno da TP Tool (adaptado do seu link)
    local toolScript = Instance.new("LocalScript")
    toolScript.Name = "TpScript"
    toolScript.Parent = tool
    toolScript.Source = [[
        local tool = script.Parent
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()

        tool.Equipped:Connect(function()
            mouse.Button1Down:Connect(function()
                local target = mouse.Hit
                if target and target.p then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(target.p + Vector3.new(0,3,0))
                    end
                end
            end)
        end)
    ]]

    tool.Parent = backpack
end

-- Função para remover TP Tool
local function removeTpTool()
    if backpack:FindFirstChild("TpTool") then
        backpack.TpTool:Destroy()
    end
    if starterGear:FindFirstChild("TpTool") then
        starterGear.TpTool:Destroy()
    end
end

-- Criar GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubSimple"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão abrir/fechar (imagem lua)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -50, 0, 20)
toggleBtn.AnchorPoint = Vector2.new(0, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://6031075938"
toggleBtn.Parent = gui

-- Janela principal arredondada e móvel
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

local uICorner = Instance.new("UICorner")
uICorner.CornerRadius = UDim.new(0, 15)
uICorner.Parent = frame

-- Função para tornar janela móvel
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Toggle botão abrir/fechar janela
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Moon Hub 🌙 - Simples"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Função helper para criar botão toggle ON/OFF
local function createToggleButton(text, yPos, colorOff, colorOn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = colorOff
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text .. ": OFF"
    btn.AutoButtonColor = false
    btn.Parent = frame
    return btn
end

-- Função helper para criar label + e - para sliders
local function createSliderControl(labelText, yPos, defaultValue, minValue, maxValue, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 25)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = labelText .. ": " .. defaultValue
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextColor3 = Color3.new(1,1,1)
    label.Parent = frame

    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 30, 0, 25)
    plusBtn.Position = UDim2.new(0.55, 0, 0, yPos)
    plusBtn.Text = "+"
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 20
    plusBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    plusBtn.TextColor3 = Color3.new(1,1,1)
    plusBtn.Parent = frame

    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 30, 0, 25)
    minusBtn.Position = UDim2.new(0.65, 0, 0, yPos)
    minusBtn.Text = "-"
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 20
    minusBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
    minusBtn.TextColor3 = Color3.new(1,1,1)
    minusBtn.Parent = frame

    plusBtn.MouseButton1Click:Connect(function()
        if defaultValue < maxValue then
            defaultValue = defaultValue + 1
            callback(defaultValue)
            label.Text = labelText .. ": " .. defaultValue
        end
    end)
    minusBtn.MouseButton1Click:Connect(function()
        if defaultValue > minValue then
            defaultValue = defaultValue - 1
            callback(defaultValue)
            label.Text = labelText .. ": " .. defaultValue
        end
    end)

    return label, plusBtn, minusBtn
end

-- Velocidade e Pulo controles
local speedLabel = nil
local jumpLabel = nil

speedLabel = createSliderControl("Velocidade", 50, speed, 0, 100, function(value)
    speed = value
    humanoid.WalkSpeed = speed
end)
jumpLabel = createSliderControl("Pulo", 90, jump, 0, 200, function(value)
    jump = value
    humanoid.JumpPower = jump
end)

-- Atualiza humanoid valores iniciais
humanoid.WalkSpeed = speed
humanoid.JumpPower = jump

-- Fly toggle
local flyBtn = createToggleButton("Fly", 130, Color3.fromRGB(100, 149, 237), Color3.fromRGB(65, 105, 225))

local bodyGyro, bodyVelocity

flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    if flyEnabled then
        humanoid.PlatformStand = true
        bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.P = 3000
        bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
    else
        humanoid.PlatformStand = false
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    end
end)

rs.Heartbeat:Connect(function()
    if flyEnabled and bodyGyro and bodyVelocity then
        local move = Vector3.new()
        local cam = workspace.CurrentCamera
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then
            bodyVelocity.Velocity = move.Unit * 50
            bodyGyro.CFrame = cam.CFrame
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Noclip toggle
local noclipBtn = createToggleButton("Noclip", 170, Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 165, 0))

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

rs.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- FPS Unlocker toggle (simples)
local fpsUnlockBtn = createToggleButton("FPS Unlocker", 210, Color3.fromRGB(34, 139, 34), Color3.fromRGB(50,205,50))
local fpsUnlocked = false

fpsUnlockBtn.MouseButton1Click:Connect(function()
    fpsUnlocked = not fpsUnlocked
    fpsUnlockBtn.Text = "FPS Unlocker: " .. (fpsUnlocked and "ON" or "OFF")
    if fpsUnlocked then
        setfpscap(999)
    else
        setfpscap(60)
    end
end)

-- Kill Aura toggle
local killAuraBtn = createToggleButton("Kill Aura", 250, Color3.fromRGB(178, 34, 34), Color3.fromRGB(220, 20, 60))
local killAuraEnabled = false

killAuraBtn.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    killAuraBtn.Text = "Kill Aura: " .. (killAuraEnabled and "ON" or "OFF")
end)

rs.Stepped:Connect(function()
    if killAuraEnabled and character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, playerInGame in pairs(game.Players:GetPlayers()) do
                if playerInGame ~= player and playerInGame.Character and playerInGame.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = playerInGame.Character.HumanoidRootPart
                    local distance = (root.Position - targetRoot.Position).Magnitude
                    if distance <= 10 then
                        -- Fling: aplica velocidade explosiva para afastar
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Velocity = (targetRoot.Position - root.Position).Unit * 100 + Vector3.new(0, 50, 0)
                        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        bodyVelocity.Parent = targetRoot
                        game.Debris:AddItem(bodyVelocity, 0.3)
                    end
                end
            end
        end
    end
end)

-- TP Tool toggle
local tpToolBtn = createToggleButton("TP Tool", 290, Color3.fromRGB(123, 104, 238), Color3.fromRGB(138, 43, 226))

tpToolBtn.MouseButton1Click:Connect(function()
    tpToolEnabled = not tpToolEnabled
    tpToolBtn.Text = "TP Tool: " .. (tpToolEnabled and "ON" or "OFF")
    if tpToolEnabled then
        createTpTool()
    else
        removeTpTool()
    end
end)

-- Atualiza humanoid valores iniciais (garante que funcione ao respawn)
humanoid.WalkSpeed = speed
humanoid.JumpPower = jump

-- Detecta respawn do personagem para reaplicar configs e desativar fly e noclip
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    -- Reseta flags e objetos
    flyEnabled = false
    noclipEnabled = false
    tpToolEnabled = false
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    humanoid.WalkSpeed = speed
    humanoid.JumpPower = jump
    -- Remove TP Tool no respawn para evitar bugs
    removeTpTool()
    -- Atualiza botões ON/OFF
    flyBtn.Text = "Fly: OFF"
    noclipBtn.Text = "Noclip: OFF"
    tpToolBtn.Text = "TP Tool: OFF"
end)
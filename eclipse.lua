local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão Lua (abrir/fechar)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -50, 0, 20)
toggleBtn.AnchorPoint = Vector2.new(0, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://6031075938"
toggleBtn.Parent = gui

-- Janela principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Moon Hub 🌙"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

-- Função para criar botões
local function createButton(name, text, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.8, 0, 0, 36)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = frame
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    return btn
end

-- Velocidade
local speed = 16
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0, 30)
speedLabel.Position = UDim2.new(0.1, 0, 0, 40)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.Text = "Velocidade: "..speed
speedLabel.Parent = frame

local speedUpBtn = createButton("SpeedUp", "+", 70)
local speedDownBtn = createButton("SpeedDown", "-", 110)

speedUpBtn.MouseButton1Click:Connect(function()
    speed = math.clamp(speed + 1, 1, 250)
    speedLabel.Text = "Velocidade: "..speed
    humanoid.WalkSpeed = speed
end)

speedDownBtn.MouseButton1Click:Connect(function()
    speed = math.clamp(speed - 1, 1, 250)
    speedLabel.Text = "Velocidade: "..speed
    humanoid.WalkSpeed = speed
end)

humanoid.WalkSpeed = speed

-- Pulo
local jump = 50
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0.4, 0, 0, 30)
jumpLabel.Position = UDim2.new(0.55, 0, 0, 40)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 18
jumpLabel.Text = "Pulo: "..jump
jumpLabel.Parent = frame

local jumpUpBtn = createButton("JumpUp", "+", 70)
local jumpDownBtn = createButton("JumpDown", "-", 110)

jumpUpBtn.MouseButton1Click:Connect(function()
    jump = math.clamp(jump + 1, 1, 250)
    jumpLabel.Text = "Pulo: "..jump
    humanoid.JumpPower = jump
end)

jumpDownBtn.MouseButton1Click:Connect(function()
    jump = math.clamp(jump - 1, 1, 250)
    jumpLabel.Text = "Pulo: "..jump
    humanoid.JumpPower = jump
end)

humanoid.JumpPower = jump

-- Fly
local flying = false
local bodyGyro, bodyVelocity

local flyBtn = createButton("FlyBtn", "Fly: OFF", 160)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")
    if flying then
        humanoid.PlatformStand = true
        bodyGyro = Instance.new("BodyGyro", rootPart)
        bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
        bodyGyro.P = 10000
        bodyVelocity = Instance.new("BodyVelocity", rootPart)
        bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
    else
        humanoid.PlatformStand = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)

-- Noclip
local noclip = false
local noclipBtn = createButton("NoclipBtn", "Noclip: OFF", 210)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
    if noclip then
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
end)

-- Controle do fly movement (PC + celular)
RunService.Heartbeat:Connect(function()
    if flying and bodyGyro and bodyVelocity then
        local direction = Vector3.new()
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction -= Vector3.new(0,1,0)
        end

        -- Suporte para celular (usar humanoid.MoveDirection para andar)
        if UserInputService.TouchEnabled then
            direction += humanoid.MoveDirection
        end

        if direction.Magnitude > 0 then
            bodyVelocity.Velocity = direction.Unit * 50
            bodyGyro.CFrame = cam.CFrame
        else
            bodyVelocity.Velocity = Vector3.new()
        end
    end
end)

-- Botão fechar
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Botão lua abrir/fechar
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Janela arrastável (mouse e toque)
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

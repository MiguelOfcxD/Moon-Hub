-- MoonHub.lua FINAL - Completo (Fly, Noclip, Pulo Alto, Velocidade, GUI arrastável, suporte PC e celular)

local Players = game:GetService("Players") local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService")

local player = Players.LocalPlayer local character = player.Character or player.CharacterAdded:Wait() local humanoid = character:WaitForChild("Humanoid") local rootPart = character:WaitForChild("HumanoidRootPart") local playerGui = player:WaitForChild("PlayerGui")

-- Controle de estado do

local flying = false
local noclip = false
local highJump = false
local flySpeed = 50
local flyBodyVelocity

local upPressed = false
local downPressed = false

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MoonHubGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 12)

local uiListLayout = Instance.new("UIListLayout", mainFrame)
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function createHubButton(name, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 17
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local flyButton = createHubButton("FlyButton", "Fly: OFF")
local noclipButton = createHubButton("NoclipButton", "Noclip: OFF")
local jumpButton = createHubButton("JumpButton", "Pulo Alto: OFF")
local speedUpButton = createHubButton("SpeedUpButton", "+ Velocidade")
local speedDownButton = createHubButton("SpeedDownButton", "- Velocidade")
local closeButton = createHubButton("CloseButton", "Fechar GUI")
local upButton, downButton
if UserInputService.TouchEnabled then
    upButton = createHubButton("UpButton", "Subir")
    downButton = createHubButton("DownButton", "Descer")
end

local function updateSpeedText()
    speedUpButton.Text = "+ Velocidade (" .. flySpeed .. ")"
    speedDownButton.Text = "- Velocidade (" .. flySpeed .. ")"
end

speedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, 10, 150)
    updateSpeedText()
end)

speedDownButton.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, 10, 150)
    updateSpeedText()
end)

updateSpeedText()

local function startFly()
    if flying then return end
    flying = true
    flyButton.Text = "Fly: ON"
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = rootPart
end

local function stopFly()
    flying = false
    flyButton.Text = "Fly: OFF"
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
end

flyButton.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

noclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipButton.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

jumpButton.MouseButton1Click:Connect(function()
    highJump = not highJump
    jumpButton.Text = highJump and "Pulo Alto: ON" or "Pulo Alto: OFF"
    humanoid.JumpPower = highJump and 150 or 50
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

if upButton then
    upButton.MouseButton1Down:Connect(function() upPressed = true end)
    upButton.MouseButton1Up:Connect(function() upPressed = false end)
    downButton.MouseButton1Down:Connect(function() downPressed = true end)
    downButton.MouseButton1Up:Connect(function() downPressed = false end)
end

RunService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if flying and flyBodyVelocity then
        local direction = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction -= Vector3.new(0, 1, 0)
        end
        if UserInputService.TouchEnabled then
            direction += humanoid.MoveDirection
            if upPressed then direction += Vector3.new(0, 1, 0) end
            if downPressed then direction -= Vector3.new(0, 1, 0) end
        end
        flyBodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.zero
    end
end)

-- Tornar o frame arrastável (PC e celular)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

end


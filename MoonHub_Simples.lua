-- Moon Hub🌙 Simples
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MoonHubSimples"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Text = "Moon Hub🌙"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local CloseButton = Instance.new("TextButton", Main)
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.Gotham
CloseButton.TextSize = 18
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local UIListLayout = Instance.new("UIListLayout", Main)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = Main

-- Função para criar botões
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.MouseButton1Click:Connect(callback)

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    return btn
end

local speed = 16
local jump = 50
local flyAtivo = false
local noclipAtivo = false
local killAuraAtivo = false
local killAuraConnection

-- Movimento
CreateButton("Aumentar Velocidade", function()
    speed = speed + 10
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

CreateButton("Diminuir Velocidade", function()
    speed = math.max(0, speed - 10)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

CreateButton("Aumentar Pulo", function()
    jump = jump + 10
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jump
    end
end)

CreateButton("Diminuir Pulo", function()
    jump = math.max(0, jump - 10)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jump
    end
end)

-- Fly
CreateButton("Ativar Fly", function()
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

CreateButton("Desativar Fly", function()
    flyAtivo = false
end)

-- Noclip
CreateButton("Ativar Noclip", function()
    noclipAtivo = true
end)

CreateButton("Desativar Noclip", function()
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

-- FPS Unlocker
CreateButton("Desbloquear FPS", function()
    if setfpscap then
        setfpscap(999)
    end
end)

-- Kill Aura com Fling real
CreateButton("Ativar Kill Aura", function()
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

CreateButton("Desativar Kill Aura", function()
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

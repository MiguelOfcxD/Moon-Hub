loadstring([[
    -- Inicialização do hub
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Criação da tela do hub
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MoonHub"
    screenGui.Parent = playerGui

    -- Função para criar os botões
    local function createButton(name, position, size, text, parent)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = size
        button.Position = position
        button.Text = text
        button.Parent = parent
        return button
    end

    -- Função para criar a imagem da lua
    local function createMoonIcon(position, size, parent)
        local moonImage = Instance.new("ImageButton")
        moonImage.Name = "MoonIcon"
        moonImage.Size = size
        moonImage.Position = position
        moonImage.Image = "rbxassetid://1603230081"  -- Substitua com o ID da imagem da lua
        moonImage.Parent = parent
        return moonImage
    end

    -- Função para esconder/mostrar a UI do hub
    local function toggleHubVisibility(hub, moonIcon)
        if hub.Visible then
            hub.Visible = false
        else
            hub.Visible = true
        end
    end

    -- Função para aumentar e diminuir velocidade
    local speed = 16
    local maxSpeed = 100
    local minSpeed = 16

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 50)
    speedLabel.Position = UDim2.new(0, 10, 0, 10)
    speedLabel.Text = "Velocidade: " .. speed
    speedLabel.Parent = screenGui

    local increaseSpeedButton = createButton("IncreaseSpeed", UDim2.new(0, 10, 0, 70), UDim2.new(0, 100, 0, 50), "Aumentar Vel.", screenGui)
    local decreaseSpeedButton = createButton("DecreaseSpeed", UDim2.new(0, 120, 0, 70), UDim2.new(0, 100, 0, 50), "Diminuir Vel.", screenGui)

    increaseSpeedButton.MouseButton1Click:Connect(function()
        if speed < maxSpeed then
            speed = speed + 1
            player.Character.Humanoid.WalkSpeed = speed
            speedLabel.Text = "Velocidade: " .. speed
        end
    end)

    decreaseSpeedButton.MouseButton1Click:Connect(function()
        if speed > minSpeed then
            speed = speed - 1
            player.Character.Humanoid.WalkSpeed = speed
            speedLabel.Text = "Velocidade: " .. speed
        end
    end)

    -- Função de voo
    local flying = false
    local flyingPart = nil

    local flyButton = createButton("Fly", UDim2.new(0, 10, 0, 130), UDim2.new(0, 100, 0, 50), "Voo", screenGui)

    flyButton.MouseButton1Click:Connect(function()
        if not flying then
            flying = true
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(5000, 5000, 5000)
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            bodyVelocity.Parent = player.Character.HumanoidRootPart

            flyingPart = Instance.new("Part")
            flyingPart.Size = Vector3.new(1, 1, 1)
            flyingPart.Anchored = true
            flyingPart.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
            flyingPart.Parent = workspace

            local flyLabel = Instance.new("TextLabel")
            flyLabel.Size = UDim2.new(0, 200, 0, 50)
            flyLabel.Position = UDim2.new(0, 10, 0, 190)
            flyLabel.Text = "Voando"
            flyLabel.Parent = screenGui
        else
            flying = false
            if flyingPart then
                flyingPart:Destroy()
            end
            player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()

            local flyLabel = screenGui:FindFirstChild("FlyLabel")
            if flyLabel then
                flyLabel:Destroy()
            end
        end
    end)

    -- Criar a lua que mostra o hub
    local moonIcon = createMoonIcon(UDim2.new(0, 10, 0, 250), UDim2.new(0, 50, 0, 50), screenGui)
    moonIcon.MouseButton1Click:Connect(function()
        toggleHubVisibility(screenGui, moonIcon)
    end)

    -- Inicialmente, esconder o hub
    screenGui.Visible = false
]])

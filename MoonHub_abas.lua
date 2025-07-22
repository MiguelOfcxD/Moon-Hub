-- Moon Hub🌙 (Avançado com Abas e Interface Profissional)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Criar GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHub_Pro"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createButton(text, parent, size)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.AutoButtonColor = false
    btn.Parent = parent
    createUICorner(btn, 6)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    return btn
end

local function createTitle(text, parent)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 40)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28
    label.Parent = parent
    return label
end

-- Botão abrir
local openBtn = Instance.new("ImageButton")
openBtn.Name = "OpenButton"
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 15, 0.5, -25)
openBtn.AnchorPoint = Vector2.new(0, 0.5)
openBtn.BackgroundTransparency = 1
openBtn.Image = "rbxassetid://15015056434"
openBtn.Parent = gui
createUICorner(openBtn, 12)

-- Janela principal
local window = Instance.new("Frame")
window.Name = "MainWindow"
window.Size = UDim2.new(0, 480, 0, 520)
window.Position = UDim2.new(0.5, -240, 0.5, -260)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
window.Visible = false
window.Parent = gui
createUICorner(window, 14)

-- Título
local title = createTitle("Moon Hub🌙 - Pro", window)
title.Position = UDim2.new(0, 0, 0, 10)

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0, 10)
closeBtn.AnchorPoint = Vector2.new(0, 0)
closeBtn.Parent = window
createUICorner(closeBtn, 10)

-- Aba container
local tabsContainer = Instance.new("Frame")
tabsContainer.Name = "TabsContainer"
tabsContainer.BackgroundTransparency = 1
tabsContainer.Size = UDim2.new(1, -40, 0, 45)
tabsContainer.Position = UDim2.new(0, 20, 0, 60)
tabsContainer.Parent = window

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 10)
tabLayout.Parent = tabsContainer

-- Conteúdo das abas
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.BackgroundTransparency = 1
contentContainer.Size = UDim2.new(1, -40, 1, -120)
contentContainer.Position = UDim2.new(0, 20, 0, 115)
contentContainer.Parent = window
contentContainer.ClipsDescendants = true

-- Criar função para aba e seu conteúdo
local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Text = name
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = 20
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.Size = UDim2.new(0, 140, 1, 0)
    tabButton.AutoButtonColor = false
    createUICorner(tabButton, 8)
    tabButton.Parent = tabsContainer

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.CanvasSize = UDim2.new(0, 0, 3, 0)
    tabContent.ScrollBarThickness = 8
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = contentContainer

    local listLayout = Instance.new("UIListLayout", tabContent)
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    return tabButton, tabContent
end

-- Ativar aba
local function activateTab(activeTabBtn, activeTabContent)
    for _, tabBtn in pairs(tabsContainer:GetChildren()) do
        if tabBtn:IsA("TextButton") then
            tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    for _, cont in pairs(contentContainer:GetChildren()) do
        if cont:IsA("ScrollingFrame") then
            cont.Visible = false
        end
    end
    activeTabBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    activeTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    activeTabContent.Visible = true
end

-- Criar abas
local tabMovimentacaoBtn, tabMovimentacaoContent = createTab("Movimentação")
local tabFuncoesBtn, tabFuncoesContent = createTab("Funções")
local tabExtrasBtn, tabExtrasContent = createTab("Extras")

-- Ativar aba padrão
activateTab(tabMovimentacaoBtn, tabMovimentacaoContent)

-- Função helper para botões ON/OFF que mudam cor
local function createToggleButton(text, parent)
    local btn = createButton(text, parent)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Toggled = false
    local function updateColor()
        if btn.Toggled then
            btn.BackgroundColor3 = Color3.fromRGB(50,150,50) -- verde ligado
        else
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40) -- cinza desligado
        end
    end
    btn.MouseButton1Click:Connect(function()
        btn.Toggled = not btn.Toggled
        updateColor()
    end)
    updateColor()
    return btn
end

-- --- Conteúdo da aba Movimentação ---
do
    local speedBtnUp = createButton("⚡ Velocidade +", tabMovimentacaoContent)
    speedBtnUp.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = math.min(humanoid.WalkSpeed + 10, 500)
        end
    end)

    local speedBtnDown = createButton("⚡ Velocidade -", tabMovimentacaoContent)
    speedBtnDown.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = math.max(humanoid.WalkSpeed - 10, 0)
        end
    end)

    local jumpBtnUp = createButton("🦘 Pulo +", tabMovimentacaoContent)
    jumpBtnUp.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = math.min(humanoid.JumpPower + 10, 500)
        end
    end)

    local jumpBtnDown = createButton("🦘 Pulo -", tabMovimentacaoContent)
    jumpBtnDown.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = math.max(humanoid.JumpPower - 10, 0)
        end
    end)

    local gravOnBtn = createToggleButton("🛰️ Gravidade Zero", tabMovimentacaoContent)
    gravOnBtn.MouseButton1Click:Connect(function()
        if gravOnBtn.Toggled then
            workspace.Gravity = 0
        else
            workspace.Gravity = 196.2
        end
    end)
end

-- --- Conteúdo da aba Funções ---
do
    local noclipBtn = createToggleButton("🚪 Noclip", tabFuncoesContent)
    local noclipConnection

    noclipBtn.MouseButton1Click:Connect(function()
        if noclipBtn.Toggled then
            if noclipConnection then noclipConnection:Disconnect() end
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and not part.CanCollide then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)

    local killAuraBtn = createButton("🔁 Kill Aura", tabFuncoesContent)
    local killAuraActive = false
    local killAuraThread

    killAuraBtn.MouseButton1Click:Connect(function()
        if killAuraActive then
            killAuraActive = false
        else
            killAuraActive = true
            killAuraThread = coroutine.create(function()
                while killAuraActive do
                    wait(0.25)
                    if not gui or not gui.Parent then break end
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local rootPos = player.Character.HumanoidRootPart.Position
                        for _, enemy in pairs(workspace:GetChildren()) do
                            if enemy:IsA("Model") and enemy ~= player.Character and enemy:FindFirstChild("HumanoidRootPart") then
                                if (enemy.HumanoidRootPart.Position - rootPos).Magnitude < 10 then
                                    pcall(function()
                                        firetouchinterest(player.Character.HumanoidRootPart, enemy.HumanoidRootPart, 0)
                                        firetouchinterest(player.Character.HumanoidRootPart, enemy.HumanoidRootPart, 1)
                                    end)
                                end
                            end
                        end
                    end
                end
            end)
            coroutine.resume(killAuraThread)
        end
    end)

    local tpToolBtn = createToggleButton("🧪 Tp Tool", tabFuncoesContent)
    local tool

    tpToolBtn.MouseButton1Click:Connect(function()
        if tpToolBtn.Toggled then
            if not tool then
                tool = Instance.new("Tool")
                tool.RequiresHandle = false
                tool.Name = "TP Tool"
                tool.Parent = player.Backpack
                tool.Activated:Connect(function()
                    if mouse.Target then
                        player.Character:MoveTo(mouse.Hit.p)
                    end
                end)
            end
        else
            if tool then
                tool:Destroy()
                tool = nil
            end
        end
    end)
end

-- --- Conteúdo da aba Extras ---
do
    local healBtn = createButton("❤️ Curar Vida", tabExtrasContent)
    healBtn.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    local resetBtn = createButton("🔁 Reset Rápido", tabExtrasContent)
    resetBtn.MouseButton1Click:Connect(function()
        if player.Character then
            player.Character:BreakJoints()
        end
    end)

    local girarToggleBtn = createToggleButton("🔄 Giro", tabExtrasContent)
    local girarSpeed = 2
    local girarConn

    girarToggleBtn.MouseButton1Click:Connect(function()
        if girarToggleBtn.Toggled then
            if girarConn then girarConn:Disconnect() end
            girarConn = RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(girarSpeed), 0)
                end
            end)
        else
            if girarConn then
                girarConn:Disconnect()
                girarConn = nil
            end
        end
    end)

    -- Slider para controlar velocidade do giro
    local sliderFrame = Instance.new("Frame", tabExtrasContent)
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    createUICorner(sliderFrame, 8)

    local sliderLabel = Instance.new("TextLabel", sliderFrame)
    sliderLabel.Size = UDim2.new(0.4, 0, 1, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextSize = 16
    sliderLabel.Text = "Velocidade do Giro:"
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBar = Instance.new("Frame", sliderFrame)
    sliderBar.Size = UDim2.new(0.55, -20, 0.3, 0)
    sliderBar.Position = UDim2.new(0.45, 10, 0.35, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    createUICorner(sliderBar, 6)

    local sliderHandle = Instance.new("Frame", sliderBar)
    sliderHandle.Size = UDim2.new(0, 20, 1, 0)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    createUICorner(sliderHandle, 6)
    sliderHandle.Position = UDim2.new(0.5, -10, 0, 0)

    local dragging = false

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    sliderBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            sliderHandle.Position = UDim2.new(0, relativeX - sliderHandle.AbsoluteSize.X/2, 0, 0)
            girarSpeed = math.clamp(math.floor((relativeX / sliderBar.AbsoluteSize.X)*20), 1, 20)
        end
    end)

    local speedValueLabel = Instance.new("TextLabel", sliderFrame)
    speedValueLabel.Size = UDim2.new(0.1, 0, 1, 0)
    speedValueLabel.Position = UDim2.new(1, -50, 0, 0)
    speedValueLabel.BackgroundTransparency = 1
    speedValueLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedValueLabel.Font = Enum.Font.GothamBold
    speedValueLabel.TextSize = 18
    speedValueLabel.Text = tostring(girarSpeed)

    RunService.RenderStepped:Connect(function()
        speedValueLabel.Text = tostring(girarSpeed)
    end)
end

-- Abrir e fechar janela
openBtn.MouseButton1Click:Connect(function()
    openBtn.Visible = false
    window.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    window.Visible = false
    openBtn.Visible = true
end)
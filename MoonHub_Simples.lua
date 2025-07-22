-- Moon Hub🌙 (Simples) - Interface Moderna Atualizada local player = game.Players.LocalPlayer local mouse = player:GetMouse()

-- Criar GUI local gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "MoonHub_Simples"

-- Botão para abrir local openButton = Instance.new("ImageButton", gui) openButton.Size = UDim2.new(0, 50, 0, 50) openButton.Position = UDim2.new(0, 10, 0.5, -25) openButton.Image = "rbxassetid://15015056434" -- Ícone de lua openButton.BackgroundTransparency = 1 openButton.Visible = true

-- Janela principal local main = Instance.new("Frame", gui) main.Size = UDim2.new(0, 400, 0, 400) main.Position = UDim2.new(0.5, -200, 0.5, -200) main.BackgroundColor3 = Color3.fromRGB(25, 25, 25) main.BorderSizePixel = 0 main.Visible = false main.Active = true main.Draggable = true main.ClipsDescendants = true main.BackgroundTransparency = 0.1 main.ZIndex = 2 Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Título local title = Instance.new("TextLabel", main) title.Size = UDim2.new(1, 0, 0, 40) title.BackgroundTransparency = 1 title.Text = "Moon Hub🌙" title.TextColor3 = Color3.fromRGB(255, 255, 255) title.Font = Enum.Font.GothamSemibold title.TextSize = 24

-- Botão de fechar local close = Instance.new("TextButton", main) close.Text = "X" close.Size = UDim2.new(0, 30, 0, 30) close.Position = UDim2.new(1, -35, 0, 5) close.BackgroundColor3 = Color3.fromRGB(60, 60, 60) close.TextColor3 = Color3.fromRGB(255, 255, 255) close.Font = Enum.Font.GothamBold close.TextSize = 16 Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

-- Container dos botões local buttonFrame = Instance.new("Frame", main) buttonFrame.Size = UDim2.new(1, -20, 1, -60) buttonFrame.Position = UDim2.new(0, 10, 0, 50) buttonFrame.BackgroundTransparency = 1 local layout = Instance.new("UIListLayout", buttonFrame) layout.Padding = UDim.new(0, 10)

-- Criador de botão local function createButton(text, callback) local btn = Instance.new("TextButton", buttonFrame) btn.Size = UDim2.new(1, 0, 0, 40) btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) btn.TextColor3 = Color3.fromRGB(255, 255, 255) btn.Text = text btn.Font = Enum.Font.Gotham btn.TextSize = 16 btn.AutoButtonColor = true Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8) btn.MouseButton1Click:Connect(callback) end

-- Gravidade Zero createButton("🪐 Gravidade Zero (Ativar)", function() workspace.Gravity = 0 end)

createButton("⛔ Desativar Gravidade", function() workspace.Gravity = 196.2 end)

-- Noclip ON/OFF local noclipAtivo = false local noclipCon

createButton("🚪 Noclip (ON)", function() if noclipCon then noclipCon:Disconnect() end noclipAtivo = true noclipCon = game:GetService("RunService").Stepped:Connect(function() if noclipAtivo and player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid:ChangeState(11) end end) end)

createButton("⛔ Noclip (OFF)", function() noclipAtivo = false if noclipCon then noclipCon:Disconnect() end end)

-- Kill Aura createButton("🌀 Kill Aura", function() spawn(function() while true do wait(0.3) for _, v in pairs(workspace:GetChildren()) do if v:IsA("Model") and v ~= player.Character and v:FindFirstChild("HumanoidRootPart") then if (v.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < 10 then firetouchinterest(player.Character:FindFirstChild("HumanoidRootPart"), v:FindFirstChild("HumanoidRootPart"), 0) firetouchinterest(player.Character:FindFirstChild("HumanoidRootPart"), v:FindFirstChild("HumanoidRootPart"), 1) end end end end end) end)

-- TP Tool createButton("🧪 Tp Tool (ON)", function() local tool = Instance.new("Tool", player.Backpack) tool.RequiresHandle = false tool.Name = "TP Tool" tool.Activated:Connect(function() if mouse.Target then player.Character:MoveTo(mouse.Hit.p) end end) end)

createButton("🛋️ Tp Tool (OFF)", function() local tool = player.Backpack:FindFirstChild("TP Tool") if tool then tool:Destroy() end end)

-- Curar Vida createButton("❤️ Curar Vida", function() if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth end end)

-- Reset createButton("🔁 Reset Rápido", function() player.Character:BreakJoints() end)

-- Velocidade e Pulo createButton("⚡ Velocidade +", function() player.Character.Humanoid.WalkSpeed += 10 end)

createButton("⚡ Velocidade -", function() player.Character.Humanoid.WalkSpeed -= 10 end)

createButton("🥼 Pulo +", function() player.Character.Humanoid.JumpPower += 10 end)

createButton("🥼 Pulo -", function() player.Character.Humanoid.JumpPower -= 10 end)

-- Girar personagem local girarCon = nil local velocidadeGiro = 2

createButton("🔄 Ativar Giro", function() if girarCon then girarCon:Disconnect() end girarCon = game:GetService("RunService").RenderStepped:Connect(function() if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then local root = player.Character.HumanoidRootPart root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(velocidadeGiro), 0) end end) end)

createButton("📉 Giro - Lento", function() velocidadeGiro = math.max(1, velocidadeGiro - 1) end)

createButton("📈 Giro - Rápido", function() velocidadeGiro = velocidadeGiro + 1 end)

createButton("❌ Parar Giro", function() if girarCon then girarCon:Disconnect() girarCon = nil end end)

-- Controles principais openButton.MouseButton1Click:Connect(function() main.Visible = true openButton.Visible = false end)

close.MouseButton1Click:Connect(function() main.Visible = false openButton.Visible = true end)


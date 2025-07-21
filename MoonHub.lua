-- Moon Hub 🌙 - Interface Estilo KRNL com Abas

local player = game.Players.LocalPlayer local character = player.Character or player.CharacterAdded:Wait() local humanoid = character:WaitForChild("Humanoid") local uis = game:GetService("UserInputService") local rs = game:GetService("RunService")

-- GUI Principal local gui = Instance.new("ScreenGui") gui.Name = "MoonHubGui" gui.ResetOnSpawn = false gui.Parent = player:WaitForChild("PlayerGui")

-- Botão Lua (Abrir/Fechar) local toggleBtn = Instance.new("ImageButton") toggleBtn.Size = UDim2.new(0, 40, 0, 40) toggleBtn.Position = UDim2.new(1, -50, 0, 20) toggleBtn.AnchorPoint = Vector2.new(0, 0) toggleBtn.BackgroundTransparency = 1 toggleBtn.Image = "rbxassetid://6031075938" toggleBtn.Parent = gui

-- Janela principal estilo KRNL local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 400, 0, 300) frame.Position = UDim2.new(0.5, 0, 0.5, 0) frame.AnchorPoint = Vector2.new(0.5, 0.5) frame.BackgroundColor3 = Color3.fromRGB(25, 25, 112) frame.BackgroundTransparency = 0.2 frame.BorderSizePixel = 0 frame.Visible = false frame.Parent = gui

-- Botão de fechar [X] local closeBtn = Instance.new("TextButton") closeBtn.Size = UDim2.new(0, 30, 0, 30) closeBtn.Position = UDim2.new(1, -35, 0, 5) closeBtn.Text = "X" closeBtn.TextColor3 = Color3.new(1, 1, 1) closeBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34) closeBtn.Font = Enum.Font.GothamBold closeBtn.TextSize = 18 closeBtn.Parent = frame

-- Título local title = Instance.new("TextLabel") title.Size = UDim2.new(1, 0, 0, 30) title.BackgroundTransparency = 1 title.Text = "Moon Hub 🌙" title.Font = Enum.Font.GothamBold title.TextSize = 22 title.TextColor3 = Color3.new(1, 1, 1) title.Parent = frame

-- Abas local tabFolder = Instance.new("Folder", frame)

local tabs = {} local function createTab(name, position) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 100, 0, 30) btn.Position = UDim2.new(0, position, 0, 40) btn.Text = name btn.Font = Enum.Font.GothamBold btn.TextSize = 16 btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180) btn.TextColor3 = Color3.new(1, 1, 1) btn.Parent = frame return btn end

local panels = {} local function createPanel() local panel = Instance.new("Frame") panel.Size = UDim2.new(1, -20, 1, -80) panel.Position = UDim2.new(0, 10, 0, 75) panel.BackgroundTransparency = 1 panel.Visible = false panel.Parent = frame return panel end

-- Movimento Panel local tab1 = createTab("Movimento", 10) local movementPanel = createPanel()

local speed = 16 local jump = 50

local function addSlider(labelText, yPos, default, callback) local label = Instance.new("TextLabel") label.Size = UDim2.new(1, 0, 0, 25) label.Position = UDim2.new(0, 0, 0, yPos) label.BackgroundTransparency = 1 label.Text = labelText .. ": " .. default label.Font = Enum.Font.Gotham label.TextSize = 18 label.TextColor3 = Color3.new(1, 1, 1) label.Parent = movementPanel

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0, 30, 0, 25)
plus.Position = UDim2.new(1, -35, 0, yPos)
plus.Text = "+"
plus.Font = Enum.Font.GothamBold
plus.TextSize = 18
plus.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
plus.TextColor3 = Color3.new(1, 1, 1)
plus.Parent = movementPanel

local minus = plus:Clone()
minus.Text = "-"
minus.Position = UDim2.new(1, -70, 0, yPos)
minus.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
minus.Parent = movementPanel

return label, plus, minus

end

local speedLabel, speedPlus, speedMinus = addSlider("Velocidade", 10, speed) speedPlus.MouseButton1Click:Connect(function() speed += 1 humanoid.WalkSpeed = speed speedLabel.Text = "Velocidade: " .. speed end) speedMinus.MouseButton1Click:Connect(function() speed = math.max(0, speed - 1) humanoid.WalkSpeed = speed speedLabel.Text = "Velocidade: " .. speed end)

local jumpLabel, jumpPlus, jumpMinus = addSlider("Pulo", 50, jump) jumpPlus.MouseButton1Click:Connect(function() jump += 1 humanoid.JumpPower = jump jumpLabel.Text = "Pulo: " .. jump end) jumpMinus.MouseButton1Click:Connect(function() jump = math.max(0, jump - 1) humanoid.JumpPower = jump jumpLabel.Text = "Pulo: " .. jump end)

-- Funções Panel local tab2 = createTab("Funções", 120) local funcPanel = createPanel()

-- Fly local flyEnabled = false local bodyGyro, bodyVelocity local flyBtn = Instance.new("TextButton") flyBtn.Size = UDim2.new(0.8, 0, 0, 30) flyBtn.Position = UDim2.new(0.1, 0, 0, 10) flyBtn.Text = "Fly: OFF" flyBtn.Font = Enum.Font.GothamBold flyBtn.TextSize = 20 flyBtn.BackgroundColor3 = Color3.fromRGB(100, 149, 237) flyBtn.TextColor3 = Color3.new(1, 1, 1) flyBtn.Parent = funcPanel

flyBtn.MouseButton1Click:Connect(function() flyEnabled = not flyEnabled flyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF") if not flyEnabled then if bodyGyro then bodyGyro:Destroy() end if bodyVelocity then bodyVelocity:Destroy() end humanoid.PlatformStand = false else humanoid.PlatformStand = true bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart) bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart) bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9) bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9) end end)

rs.Heartbeat:Connect(function() if flyEnabled and bodyGyro and bodyVelocity then local move = Vector3.zero local cam = workspace.CurrentCamera if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end if uis:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0, 1, 0) end

bodyVelocity.Velocity = move.Unit * 50
	bodyGyro.CFrame = cam.CFrame
end

end)

-- Noclip local noclip = false local noclipBtn = Instance.new("TextButton") noclipBtn.Size = UDim2.new(0.8, 0, 0, 30) noclipBtn.Position = UDim2.new(0.1, 0, 0, 60) noclipBtn.Text = "Noclip: OFF" noclipBtn.Font = Enum.Font.GothamBold noclipBtn.TextSize = 20 noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0) noclipBtn.TextColor3 = Color3.new(1, 1, 1) noclipBtn.Parent = funcPanel

noclipBtn.MouseButton1Click:Connect(function() noclip = not noclip noclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF") end)

rs.Stepped:Connect(function() if noclip then for _, part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide == true then part.CanCollide = false end end else for _, part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") and not part.CanCollide then


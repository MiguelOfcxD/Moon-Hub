-- Moon Hub🌙 - Slap Battles (versão com abas) - by Miguel

-- Serviços local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UIS = game:GetService("UserInputService") local RS = game:GetService("ReplicatedStorage") local LP = Players.LocalPlayer

local Char = LP.Character or LP.CharacterAdded:Wait() local HRP = Char:WaitForChild("HumanoidRootPart") local Humanoid = Char:WaitForChild("Humanoid")

-- Estado local state = { killAura = false, autoSlap = false, speedHack = false, gravity = false, noclip = false, fly = false, godmode = false, antiRagdoll = false, noKnockback = false, }

local speedValue = 50 local connectionFly, connectionNoclip

-- GUI Principal local gui = Instance.new("ScreenGui", game.CoreGui) gu i.ResetOnSpawn = false gui.Name = "MoonHub_SlapBattles"

local main = Instance.new("Frame", gui) main.Size = UDim2.new(0, 380, 0, 400) main.Position = UDim2.new(0.5, -190, 0.5, -200) main.BackgroundColor3 = Color3.fromRGB(25, 25, 25) main.Active = true main.Draggable = true Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Título local title = Instance.new("TextLabel", main) title.Size = UDim2.new(1, -35, 0, 40) title.Position = UDim2.new(0, 10, 0, 0) title.BackgroundTransparency = 1 title.Text = "Moon Hub🌙 - Slap Battles" title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.GothamBold title.TextSize = 18

local close = Instance.new("TextButton", main) close.Size = UDim2.new(0, 30, 0, 30) close.Position = UDim2.new(1, -35, 0, 5) close.Text = "✕" close.BackgroundColor3 = Color3.fromRGB(40, 40, 40) close.TextColor3 = Color3.fromRGB(255, 100, 100) close.Font = Enum.Font.GothamBold close.TextSize = 18 Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8) close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Abas local abas = {"Combate", "Movimento", "Utilitários"} local atual = "Combate" local botoesAba = {}

for i, nome in ipairs(abas) do local btn = Instance.new("TextButton", main) btn.Size = UDim2.new(0, 100, 0, 30) btn.Position = UDim2.new(0, 10 + (i-1)*110, 0, 50) btn.Text = nome btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.Gotham btn.TextSize = 14 Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) botoesAba[nome] = btn btn.MouseButton1Click:Connect(function() atual = nome updateAbas() end) end

local conteudo = Instance.new("Frame", main) conteudo.Position = UDim2.new(0, 10, 0, 90) conteudo.Size = UDim2.new(1, -20, 1, -100) conteudo.BackgroundTransparency = 1

local function limparConteudo() for _, v in pairs(conteudo:GetChildren()) do v:Destroy() end end

local function criarBotao(nome, ordem, callback) local btn = Instance.new("TextButton", conteudo) btn.Size = UDim2.new(1, 0, 0, 35) btn.Position = UDim2.new(0, 0, 0, (ordem-1)*40) btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) btn.Text = nome btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.Gotham btn.TextSize = 14 Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) btn.MouseButton1Click:Connect(callback) end

function updateAbas() limparConteudo() if atual == "Combate" then criarBotao("Kill Aura (ON/OFF)", 1, function() state.killAura = not state.killAura end) criarBotao("Auto Slap (ON/OFF)", 2, function() state.autoSlap = not state.autoSlap end) criarBotao("Kill All", 3, function() for _, plr in pairs(Players:GetPlayers()) do if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then HRP.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) local atk = RS:FindFirstChild("Attack") if atk then atk:FireServer(plr.Character) end task.wait(0.2) end end end) criarBotao("God Mode (ON/OFF)", 4, function() state.godmode = not state.godmode end) elseif atual == "Movimento" then criarBotao("Speed Hack (ON/OFF)", 1, function() state.speedHack = not state.speedHack end) criarBotao("Gravidade Zero (ON/OFF)", 2, function() state.gravity = not state.gravity end) criarBotao("Noclip (ON/OFF)", 3, function() state.noclip = not state.noclip end) criarBotao("Fly (ON/OFF)", 4, function() state.fly = not state.fly end) elseif atual == "Utilitários" then criarBotao("Teleportar para jogador", 1, function() local nome = LP:Prompt("Digite o nome do jogador") local alvo = Players:FindFirstChild(nome) if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then HRP.CFrame = alvo.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0) end end) criarBotao("Reset Rápido", 2, function() LP.Character:BreakJoints() end) criarBotao("Anti-Ragdoll (ON/OFF)", 3, function() state.antiRagdoll = not state.antiRagdoll end) criarBotao("No Knockback (ON/OFF)", 4, function() state.noKnockback = not state.noKnockback end) criarBotao("FPS Boost", 5, function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Decal") then v:Destroy() end end end) end end

updateAbas()

-- Lógicas por frame RunService.Heartbeat:Connect(function() pcall(function() Char = LP.Character or LP.CharacterAdded:Wait() HRP = Char:WaitForChild("HumanoidRootPart") Humanoid = Char:WaitForChild("Humanoid") end)

if state.speedHack then Humanoid.WalkSpeed = speedValue else Humanoid.WalkSpeed = 16 end

if state.killAura then
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (HRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 10 then
                local atk = RS:FindFirstChild("Attack")
                if atk then atk:FireServer(plr.Character) end
            end
        end
    end
end

if state.autoSlap then
    local atk = RS:FindFirstChild("Attack")
    if atk then atk:FireServer() end
end

if state.gravity then workspace.Gravity = 2 else workspace.Gravity = 196.2 end

if state.noclip and not connectionNoclip then
    connectionNoclip = RunService.Stepped:Connect(function()
        for _, part in pairs(Char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end)
elseif not state.noclip and connectionNoclip then
    connectionNoclip:Disconnect()
    connectionNoclip = nil
end

end)

print("Moon Hub🌙 carregado com abas!")


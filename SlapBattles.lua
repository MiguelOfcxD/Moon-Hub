
-- Moon Hub🌙 - Slap Battles Edition (100% Mobile, Moderno e Otimizado)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

-- Proteção
pcall(function() setfpscap(999) end)

-- Interface Principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MoonHubSB"
ScreenGui.ResetOnSpawn = false

-- Janela Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 320)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 0.1
MainFrame.ZIndex = 2

-- UICorner + sombra
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local shadow = Instance.new("ImageLabel", MainFrame)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.6
shadow.BackgroundTransparency = 1
shadow.ZIndex = 1

-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "Moon Hub🌙 - Slap Battles"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- Botão de abrir/fechar
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.Image = "rbxassetid://16002162253"
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.ZIndex = 3

ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Abas
local Tabs = {}
local TabButtons = {}

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 400, 0, 30)
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundTransparency = 1
TabFrame.ZIndex = 2

local function createTab(name)
	local btn = Instance.new("TextButton", TabFrame)
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local frame = Instance.new("Frame", MainFrame)
	frame.Size = UDim2.new(1, 0, 1, -60)
	frame.Position = UDim2.new(0, 0, 0, 60)
	frame.BackgroundTransparency = 1
	frame.Visible = false

	table.insert(TabButtons, btn)
	Tabs[name] = frame

	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(Tabs) do f.Visible = false end
		for _, b in pairs(TabButtons) do b.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
		frame.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
	end)

	return frame
end

local combate = createTab("Combate")
local move = createTab("Movimentação")
local util = createTab("Utilitários")
local players = createTab("Players")

local function createLayout(container)
	local UIListLayout = Instance.new("UIListLayout", container)
	UIListLayout.Padding = UDim.new(0, 6)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local padding = Instance.new("UIPadding", container)
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
end

createLayout(combate)
createLayout(move)
createLayout(util)
createLayout(players)

local function createToggle(parent, nome, callback)
	local estado = false
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Text = nome .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(255, 0, 0)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		estado = not estado
		btn.Text = nome .. (estado and ": ON" or ": OFF")
		btn.TextColor3 = estado and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		callback(estado)
	end)
end

createToggle(combate, "Kill Aura", function(on)
	if on then
		_G.KillAura = true
		task.spawn(function()
			while _G.KillAura do
				for _, v in pairs(game.Players:GetPlayers()) do
					if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
						if (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < 15 then
							firetouchinterest(v.Character.HumanoidRootPart, player.Character:FindFirstChild("Slap"), 0)
							firetouchinterest(v.Character.HumanoidRootPart, player.Character:FindFirstChild("Slap"), 1)
						end
					end
				end
				wait(0.2)
			end
		end)
	else
		_G.KillAura = false
	end
end)

createToggle(combate, "Auto Slap", function(on)
	if on then
		_G.AutoSlap = true
		task.spawn(function()
			while _G.AutoSlap do
				local slap = player.Character and player.Character:FindFirstChild("Slap")
				if slap then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
							if (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < 15 then
								firetouchinterest(v.Character.HumanoidRootPart, slap, 0)
								firetouchinterest(v.Character.HumanoidRootPart, slap, 1)
							end
						end
					end
				end
				wait(0.2)
			end
		end)
	else
		_G.AutoSlap = false
	end
end)

createToggle(move, "Speed Hack", function(on)
	if on then
		_G.MoonSpeed = true
		player.Character.Humanoid.WalkSpeed = 50
	else
		_G.MoonSpeed = false
		player.Character.Humanoid.WalkSpeed = 16
	end
end)


-- Continuação: outras funções
createToggle(move, "High Jump", function(on)
	if on then
		player.Character.Humanoid.JumpPower = 120
	else
		player.Character.Humanoid.JumpPower = 50
	end
end)

createToggle(move, "Gravidade Zero", function(on)
	workspace.Gravity = on and 0 or 196.2
end)

createToggle(move, "Noclip", function(on)
	_G.NoclipSB = on
	if on then
		task.spawn(function()
			while _G.NoclipSB do
				pcall(function()
					player.Character.Humanoid:ChangeState(11)
				end)
				task.wait()
			end
		end)
	end
end)

createToggle(util, "TpTool", function(on)
	if on then
		local tool = Instance.new("Tool", player.Backpack)
		tool.RequiresHandle = false
		tool.Name = "TpTool"
		tool.Activated:Connect(function()
			if mouse then
				player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
			end
		end)
	else
		for _, v in pairs(player.Backpack:GetChildren()) do
			if v.Name == "TpTool" then v:Destroy() end
		end
	end
end)

createToggle(util, "Curar Vida", function(on)
	if on then
		pcall(function()
			player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
		end)
	end
end)

createToggle(util, "Reset Rápido", function(on)
	if on then
		player.Character:BreakJoints()
	end
end)

createToggle(util, "Anti-Kick", function(on)
	if on then
		local mt = getrawmetatable(game)
		local old; old = hookfunction(mt.__namecall, newcclosure(function(self, ...)
			local args = {...}
			if getnamecallmethod() == "Kick" then
				return
			end
			return old(self, unpack(args))
		end))
	end
end)

createToggle(players, "Auto Rejoin", function(on)
	if on then
		game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(state)
			if state == Enum.TeleportState.Failed then
				game:GetService("TeleportService"):Teleport(game.PlaceId)
			end
		end)
	end
end)

createToggle(players, "Server Hop", function(on)
	if on then
		local ts = game:GetService("TeleportService")
		local servers = {}
		local HttpService = game:GetService("HttpService")

		local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")
		local data = HttpService:JSONDecode(req)
		for _, v in pairs(data.data) do
			if v.playing < v.maxPlayers then
				table.insert(servers, v.id)
			end
		end
		ts:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
	end
end)

createToggle(players, "Hide Name", function(on)
	if on then
		pcall(function()
			player.Character.Head:FindFirstChild("Nametag"):Destroy()
		end)
	end
end)

TabButtons[1].MouseButton1Click:Fire()

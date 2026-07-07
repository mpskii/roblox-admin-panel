-- By Melik

local RankConfig = {
	Ranks = {
		{
			Name = "Guest",
			Level = 0,
			Color = Color3.fromRGB(150, 150, 150),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {}
		},
		{
			Name = "Member",
			Level = 1,
			Color = Color3.fromRGB(180, 180, 180),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {}
		},
		{
			Name = "Trial Moderator",
			Level = 10,
			Color = Color3.fromRGB(100, 200, 255),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"warn", "mute", "unmute", "spectate", "reports", "basiclogs"}
		},
		{
			Name = "Moderator",
			Level = 20,
			Color = Color3.fromRGB(100, 200, 255),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"warn", "mute", "unmute", "spectate", "reports", "basiclogs", "kick", "freeze", "jail", "bring", "goto", "teleport", "announcements"}
		},
		{
			Name = "Senior Moderator",
			Level = 30,
			Color = Color3.fromRGB(100, 220, 255),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"warn", "mute", "unmute", "spectate", "reports", "basiclogs", "kick", "freeze", "jail", "bring", "goto", "teleport", "announcements", "tempban", "heal", "respawn", "chatmod", "extendedlogs"}
		},
		{
			Name = "Administrator",
			Level = 40,
			Color = Color3.fromRGB(255, 200, 0),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"warn", "mute", "unmute", "spectate", "reports", "basiclogs", "kick", "freeze", "jail", "bring", "goto", "teleport", "announcements", "tempban", "heal", "respawn", "chatmod", "extendedlogs", "permanentban", "revive", "fly", "invisible", "godmode", "servercontrols"}
		},
		{
			Name = "Head Administrator",
			Level = 50,
			Color = Color3.fromRGB(255, 150, 0),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"warn", "mute", "unmute", "spectate", "reports", "basiclogs", "kick", "freeze", "jail", "bring", "goto", "teleport", "announcements", "tempban", "heal", "respawn", "chatmod", "extendedlogs", "permanentban", "revive", "fly", "invisible", "godmode", "servercontrols", "staffmanagement", "analytics", "modconfig"}
		},
		{
			Name = "Management",
			Level = 60,
			Color = Color3.fromRGB(255, 100, 0),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"warn", "mute", "unmute", "spectate", "reports", "basiclogs", "kick", "freeze", "jail", "bring", "goto", "teleport", "announcements", "tempban", "heal", "respawn", "chatmod", "extendedlogs", "permanentban", "revive", "fly", "invisible", "godmode", "servercontrols", "staffmanagement", "analytics", "modconfig", "promote", "demote", "rankmanagement", "permissionmanagement", "globalannouncements"}
		},
		{
			Name = "Developer",
			Level = 65,
			Color = Color3.fromRGB(150, 100, 255),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"debug", "devtools", "perfmonitor", "remoteeventviewer", "remotefunctionviewer", "configmanager"}
		},
		{
			Name = "Lead Developer",
			Level = 75,
			Color = Color3.fromRGB(200, 100, 255),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"debug", "devtools", "perfmonitor", "remoteeventviewer", "remotefunctionviewer", "configmanager", "devteamoversight", "advanceddiagnostics", "devpermmanagement", "sysconfiguration"}
		},
		{
			Name = "Co-Owner",
			Level = 90,
			Color = Color3.fromRGB(255, 50, 50),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"*"}
		},
		{
			Name = "Owner",
			Level = 100,
			Color = Color3.fromRGB(255, 215, 0),
			BadgeIcon = "rbxasset://textures/face_default_large.png",
			Permissions = {"*"}
		}
	}
}

local PermissionSystem = {}

function PermissionSystem:GetPlayerRank(player)
	local userId = player.UserId
  
	return "Member"
end

function PermissionSystem:HasPermission(player, permission)
	local rank = self:GetPlayerRank(player)
	for _, rankData in ipairs(RankConfig.Ranks) do
		if rankData.Name == rank then
			if rankData.Permissions[1] == "*" then
				return true
			end
			for _, perm in ipairs(rankData.Permissions) do
				if perm == permission or perm == "*" then
					return true
				end
			end
		end
	end
	return false
end

function PermissionSystem:GetRankData(rankName)
	for _, rank in ipairs(RankConfig.Ranks) do
		if rank.Name == rankName then
			return rank
		end
	end
	return nil
end

function PermissionSystem:GetRankLevel(rankName)
	local rankData = self:GetRankData(rankName)
	return rankData and rankData.Level or 0
end

local CommandSystem = {}
CommandSystem.Commands = {}
CommandSystem.CommandPrefix = "/"

function CommandSystem:Register(command)
	self.Commands[command.Name:lower()] = command
end

function CommandSystem:Execute(player, commandName, args)
	local cmd = self.Commands[commandName:lower()]
	if not cmd then
		return false, "Command not found"
	end
	
	if not PermissionSystem:HasPermission(player, cmd.Permission) then
		return false, "You don't have permission to use this command"
	end
	
	return cmd.Execute(player, args)
end

CommandSystem:Register({
	Name = "warn",
	Permission = "warn",
	Description = "Warn a player",
	Execute = function(player, args)
		local targetName = args[1]
		local reason = table.concat(args, " ", 2) or "No reason provided"
		print("Warned " .. targetName .. ": " .. reason)
		return true, "Player warned"
	end
})

CommandSystem:Register({
	Name = "mute",
	Permission = "mute",
	Description = "Mute a player",
	Execute = function(player, args)
		local targetName = args[1]
		local duration = tonumber(args[2]) or 3600
		print("Muted " .. targetName .. " for " .. duration .. " seconds")
		return true, "Player muted"
	end
})

CommandSystem:Register({
	Name = "unmute",
	Permission = "unmute",
	Description = "Unmute a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Unmuted " .. targetName)
		return true, "Player unmuted"
	end
})

CommandSystem:Register({
	Name = "kick",
	Permission = "kick",
	Description = "Kick a player",
	Execute = function(player, args)
		local targetName = args[1]
		local reason = table.concat(args, " ", 2) or "No reason provided"
		print("Kicked " .. targetName .. ": " .. reason)
		return true, "Player kicked"
	end
})

CommandSystem:Register({
	Name = "ban",
	Permission = "permanentban",
	Description = "Permanently ban a player",
	Execute = function(player, args)
		local targetName = args[1]
		local reason = table.concat(args, " ", 2) or "No reason provided"
		print("Banned " .. targetName .. ": " .. reason)
		return true, "Player banned"
	end
})

CommandSystem:Register({
	Name = "tempban",
	Permission = "tempban",
	Description = "Temporarily ban a player",
	Execute = function(player, args)
		local targetName = args[1]
		local duration = tonumber(args[2]) or 3600
		local reason = table.concat(args, " ", 3) or "No reason provided"
		print("Temp banned " .. targetName .. " for " .. duration .. " seconds: " .. reason)
		return true, "Player temporarily banned"
	end
})

CommandSystem:Register({
	Name = "unban",
	Permission = "permanentban",
	Description = "Unban a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Unbanned " .. targetName)
		return true, "Player unbanned"
	end
})

CommandSystem:Register({
	Name = "freeze",
	Permission = "freeze",
	Description = "Freeze a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Froze " .. targetName)
		return true, "Player frozen"
	end
})

CommandSystem:Register({
	Name = "jail",
	Permission = "jail",
	Description = "Jail a player",
	Execute = function(player, args)
		local targetName = args[1]
		local duration = tonumber(args[2]) or 3600
		print("Jailed " .. targetName .. " for " .. duration .. " seconds")
		return true, "Player jailed"
	end
})

CommandSystem:Register({
	Name = "bring",
	Permission = "bring",
	Description = "Bring a player to you",
	Execute = function(player, args)
		local targetName = args[1]
		print("Brought " .. targetName)
		return true, "Player brought"
	end
})

CommandSystem:Register({
	Name = "goto",
	Permission = "goto",
	Description = "Go to a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Went to " .. targetName)
		return true, "Teleported"
	end
})

CommandSystem:Register({
	Name = "teleport",
	Permission = "teleport",
	Description = "Teleport to coordinates",
	Execute = function(player, args)
		local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
		print("Teleported to " .. x .. ", " .. y .. ", " .. z)
		return true, "Teleported"
	end
})

CommandSystem:Register({
	Name = "heal",
	Permission = "heal",
	Description = "Heal a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Healed " .. targetName)
		return true, "Player healed"
	end
})

CommandSystem:Register({
	Name = "kill",
	Permission = "godmode",
	Description = "Kill a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Killed " .. targetName)
		return true, "Player killed"
	end
})

CommandSystem:Register({
	Name = "respawn",
	Permission = "respawn",
	Description = "Respawn a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Respawned " .. targetName)
		return true, "Player respawned"
	end
})

CommandSystem:Register({
	Name = "fly",
	Permission = "fly",
	Description = "Enable fly mode",
	Execute = function(player, args)
		local targetName = args[1]
		print("Enabled fly for " .. targetName)
		return true, "Fly enabled"
	end
})

CommandSystem:Register({
	Name = "spectate",
	Permission = "spectate",
	Description = "Spectate a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Spectating " .. targetName)
		return true, "Now spectating"
	end
})

CommandSystem:Register({
	Name = "godmode",
	Permission = "godmode",
	Description = "Enable god mode",
	Execute = function(player, args)
		local targetName = args[1]
		print("Enabled god mode for " .. targetName)
		return true, "God mode enabled"
	end
})

CommandSystem:Register({
	Name = "invisible",
	Permission = "invisible",
	Description = "Make invisible",
	Execute = function(player, args)
		local targetName = args[1]
		print("Made " .. targetName .. " invisible")
		return true, "Player invisible"
	end
})

CommandSystem:Register({
	Name = "announce",
	Permission = "announcements",
	Description = "Make an announcement",
	Execute = function(player, args)
		local message = table.concat(args, " ")
		print("Announcement: " .. message)
		return true, "Announced"
	end
})

CommandSystem:Register({
	Name = "shutdown",
	Permission = "servercontrols",
	Description = "Shutdown the server",
	Execute = function(player, args)
		local delay = tonumber(args[1]) or 10
		print("Server shutting down in " .. delay .. " seconds")
		return true, "Shutdown initiated"
	end
})

CommandSystem:Register({
	Name = "restart",
	Permission = "servercontrols",
	Description = "Restart the server",
	Execute = function(player, args)
		print("Server restarting")
		return true, "Restart initiated"
	end
})

CommandSystem:Register({
	Name = "promote",
	Permission = "promote",
	Description = "Promote a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Promoted " .. targetName)
		return true, "Player Promoted"
	end
})

CommandSystem:Register({
	Name = "demote",
	Permission = "demote",
	Description = "Demote a player",
	Execute = function(player, args)
		local targetName = args[1]
		print("Demoted " .. targetName)
		return true, "Player Demoted"
	end
})

CommandSystem:Register({
	Name = "setrank",
	Permission = "rankmanagement",
	Description = "Set a player's rank",
	Execute = function(player, args)
		local targetName = args[1]
		local rankName = table.concat(args, " ", 2)
		print("Set " .. targetName .. " rank to " .. rankName)
		return true, "Rank Set"
	end
})

CommandSystem:Register({
	Name = "debug",
	Permission = "debug",
	Description = "Open debug console",
	Execute = function(player, args)
		print("Debug console opened")
		return true, "Debug console ready"
	end
})

CommandSystem:Register({
	Name = "logs",
	Permission = "basiclogs",
	Description = "View logs",
	Execute = function(player, args)
		print("Fetching logs")
		return true, "Logs Retrieved"
	end
})

local LoggingService = {}
LoggingService.Logs = {}

function LoggingService:Log(action, executor, target, reason, duration)
	local logEntry = {
		Timestamp = os.time(),
		Action = action,
		Executor = executor.Name,
		ExecutorId = executor.UserId,
		Target = target,
		Reason = reason or "No reason",
		Duration = duration,
		ServerId = game.GameId
	}
	table.insert(self.Logs, logEntry)
	print("[LOG] " .. action .. " by " .. executor.Name .. " on " .. target .. ": " .. reason)
end

function LoggingService:GetLogs(filter)
	local results = {}
	for _, log in ipairs(self.Logs) do
		if not filter or (filter.Action and log.Action == filter.Action) or (filter.Executor and log.Executor == filter.Executor) then
			table.insert(results, log)
		end
	end
	return results
end

local ModerationService = {}
ModerationService.MutedPlayers = {}
ModerationService.FrozenPlayers = {}
ModerationService.BannedPlayers = {}
ModerationService.JailedPlayers = {}

function ModerationService:Mute(player, duration)
	self.MutedPlayers[player.UserId] = {
		Duration = duration,
		StartTime = os.time()
	}
	LoggingService:Log("MUTE", game.Players:FindFirstChild("ServerAdmin") or game.Players:GetPlayers()[1], player.Name, "Muted", duration)
end

function ModerationService:Unmute(player)
	self.MutedPlayers[player.UserId] = nil
end

function ModerationService:Freeze(player)
	self.FrozenPlayers[player.UserId] = true
	if player.Character then
		local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			humanoidRootPart.CanCollide = true
		end
	end
end

function ModerationService:Ban(player, permanent, duration, reason)
	self.BannedPlayers[player.UserId] = {
		Permanent = permanent,
		Duration = duration or 0,
		Reason = reason,
		BannedAt = os.time()
	}
	player:Kick("You have been banned: " .. reason)
end

function ModerationService:IsMuted(userId)
	if not self.MutedPlayers[userId] then return false end
	local muteData = self.MutedPlayers[userId]
	if os.time() - muteData.StartTime > muteData.Duration then
		self.MutedPlayers[userId] = nil
		return false
	end
	return true
end

function ModerationService:IsBanned(userId)
	return self.BannedPlayers[userId] ~= nil
end

local UIUtilities = {}

function UIUtilities:CreateFrame(parent, name, position, size, color, transparency)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Parent = parent
	frame.Position = position
	frame.Size = size
	frame.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
	frame.BackgroundTransparency = transparency or 0.1
	frame.BorderSizePixel = 0
	return frame
end

function UIUtilities:CreateButton(parent, name, position, size, text, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Parent = parent
	button.Position = position
	button.Size = size
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.BackgroundTransparency = 0.2
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button
	
	button.MouseButton1Click:Connect(callback)
	return button
end

function UIUtilities:CreateLabel(parent, name, position, size, text, textSize, color)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Parent = parent
	label.Position = position
	label.Size = size
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = textSize or 14
	label.BorderSizePixel = 0
	return label
end

function UIUtilities:CreateTextBox(parent, name, position, size, placeholder)
	local textBox = Instance.new("TextBox")
	textBox.Name = name
	textBox.Parent = parent
	textBox.Position = position
	textBox.Size = size
	textBox.Text = ""
	textBox.PlaceholderText = placeholder
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	textBox.BackgroundTransparency = 0.2
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 14
	textBox.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = textBox
	
	return textBox
end

function UIUtilities:ApplyGradient(frame, color1, color2)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2)
	})
	gradient.Parent = frame
	return gradient
end

function UIUtilities:ApplyCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

function UIUtilities:ApplyStroke(instance, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Parent = instance
	return stroke
end

local AdminPanel = {}
AdminPanel.IsOpen = false
AdminPanel.IsDragging = false
AdminPanel.DragStart = nil
AdminPanel.StartPos = nil

function AdminPanel:Create()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AdminPanelGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	
	local mainFrame = UIUtilities:CreateFrame(screenGui, "MainFrame", UDim2.new(0, 50, 0, 50), UDim2.new(0, 600, 0, 700), Color3.fromRGB(20, 20, 20), 0)
	UIUtilities:ApplyCorner(mainFrame, 12)
	UIUtilities:ApplyStroke(mainFrame, Color3.fromRGB(80, 80, 80), 1)
	
	local titleBar = UIUtilities:CreateFrame(mainFrame, "TitleBar", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), Color3.fromRGB(25, 25, 25), 0)
	UIUtilities:ApplyCorner(titleBar, 12)
	
	local titleLabel = UIUtilities:CreateLabel(titleBar, "Title", UDim2.new(0, 15, 0, 10), UDim2.new(1, -30, 1, 0), "⚙ Admin Panel", 16, Color3.fromRGB(255, 255, 255))
	titleLabel.Font = Enum.Font.GothamBold
	
	local closeBtn = UIUtilities:CreateButton(mainFrame, "CloseBtn", UDim2.new(1, -40, 0, 8), UDim2.new(0, 24, 0, 24), "×", function()
		mainFrame:Destroy()
	end)
	closeBtn.TextSize = 20
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	
	local tabFrame = UIUtilities:CreateFrame(mainFrame, "TabFrame", UDim2.new(0, 0, 0, 40), UDim2.new(0.3, 0, 1, -40), Color3.fromRGB(25, 25, 25), 0)
	
	local contentFrame = UIUtilities:CreateFrame(mainFrame, "ContentFrame", UDim2.new(0.3, 5, 0, 40), UDim2.new(0.7, -10, 1, -40), Color3.fromRGB(20, 20, 20), 0)
	
	local tabs = {
		{Name = "Dashboard", Icon = "📊"},
		{Name = "Players", Icon = "👥"},
		{Name = "Moderation", Icon = "🛡"},
		{Name = "Server", Icon = "🖥"},
		{Name = "Staff", Icon = "⭐"},
		{Name = "Logs", Icon = "📋"},
		{Name = "Developer", Icon = "🛠"}
	}
	
	local tabButtons = {}
	for i, tab in ipairs(tabs) do
		local tabBtn = UIUtilities:CreateButton(tabFrame, tab.Name, UDim2.new(0, 5, 0, 5 + (i-1) * 40), UDim2.new(1, -10, 0, 35), tab.Icon .. " " .. tab.Name, function()

			for _, child in ipairs(contentFrame:GetChildren()) do
				if child.Name ~= "UIListLayout" then
					child:Destroy()
				end
			end
        
			AdminPanel:LoadTab(tab.Name, contentFrame)
		end)
		tabBtn.TextSize = 12
		table.insert(tabButtons, tabBtn)
	end

	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	titleBar.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)
	
	titleBar.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessed)
		if dragging and dragStart then
			local delta = input.Position - dragStart
			mainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end)
	
	AdminPanel:LoadTab("Dashboard", contentFrame)
	
	return screenGui
end

function AdminPanel:LoadTab(tabName, contentFrame)
	if tabName == "Dashboard" then
		self:CreateDashboard(contentFrame)
	elseif tabName == "Players" then
		self:CreatePlayersTab(contentFrame)
	elseif tabName == "Moderation" then
		self:CreateModerationTab(contentFrame)
	elseif tabName == "Server" then
		self:CreateServerTab(contentFrame)
	elseif tabName == "Staff" then
		self:CreateStaffTab(contentFrame)
	elseif tabName == "Logs" then
		self:CreateLogsTab(contentFrame)
	elseif tabName == "Developer" then
		self:CreateDeveloperTab(contentFrame)
	end
end

function AdminPanel:CreateDashboard(parent)
	UIUtilities:CreateLabel(parent, "DashboardTitle", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 30), "📊 Dashboard", 20, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
	
	UIUtilities:CreateLabel(parent, "Info1", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 0, 25), "Players Online: " .. #game.Players:GetPlayers(), 14)
	UIUtilities:CreateLabel(parent, "Info2", UDim2.new(0, 10, 0, 80), UDim2.new(1, -20, 0, 25), "Server Uptime: 2h 45m", 14)
	UIUtilities:CreateLabel(parent, "Info3", UDim2.new(0, 10, 0, 110), UDim2.new(1, -20, 0, 25), "FPS: 60", 14)
	UIUtilities:CreateLabel(parent, "Info4", UDim2.new(0, 10, 0, 140), UDim2.new(1, -20, 0, 25), "Memory: 256 MB", 14)
end

function AdminPanel:CreatePlayersTab(parent)
	UIUtilities:CreateLabel(parent, "PlayersTitle", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 30), "👥 Players", 20, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
	
	local searchBox = UIUtilities:CreateTextBox(parent, "Search", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 0, 30), "Search player...")
	
	local playerList = UIUtilities:CreateFrame(parent, "PlayerList", UDim2.new(0, 10, 0, 90), UDim2.new(1, -20, 1, -100), Color3.fromRGB(25, 25, 25), 0)
	UIUtilities:ApplyCorner(playerList, 6)
	
	for _, player in ipairs(game.Players:GetPlayers()) do
		local playerBtn = UIUtilities:CreateButton(playerList, player.Name, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), player.Name .. " (" .. player.UserId .. ")", function()
			print("Selected: " .. player.Name)
		end)
		playerBtn.TextSize = 12
	end
end

function AdminPanel:CreateModerationTab(parent)
	UIUtilities:CreateLabel(parent, "ModTitle", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 30), "🛡 Moderation", 20, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
	
	local actions = {"Warn", "Mute", "Kick", "Ban", "Freeze", "Jail", "Teleport"}
	
	for i, action in ipairs(actions) do
		UIUtilities:CreateButton(parent, action, UDim2.new(0, 10, 0, 50 + (i-1) * 40), UDim2.new(0.4, -15, 0, 35), action, function()
			print("Action: " .. action)
		end)
	end
end

function AdminPanel:CreateServerTab(parent)
	UIUtilities:CreateLabel(parent, "ServerTitle", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 30), "🖥 Server Controls", 20, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
	
	UIUtilities:CreateButton(parent, "Lock", UDim2.new(0, 10, 0, 50), UDim2.new(0.4, -15, 0, 35), "🔒 Lock Server", function()
		print("Server locked")
	end)
	
	UIUtilities:CreateButton(parent, "Restart", UDim2.new(0.5, 5, 0, 50), UDim2.new(0.4, -15, 0, 35), "🔄 Restart", function()
		print("Restarting server")
	end)
	
	UIUtilities:CreateButton(parent, "Shutdown", UDim2.new(0, 10, 0, 95), UDim2.new(0.4, -15, 0, 35), "⏹ Shutdown", function()
		print("Shutting down server")
	end)
end

function AdminPanel:CreateStaffTab(parent)
	UIUtilities:CreateLabel(parent, "StaffTitle", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 30), "⭐ Staff Management", 20, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
	
	UIUtilities:CreateLabel(parent, "StaffList", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 1, -60), "No staff currently online", 14)
end

function AdminPanel:CreateLogsTab(parent)
	UIUtilities:CreateLabel(parent, "LogsTitle", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 30), "📋 Logs", 20, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
	
	local logs = LoggingService:GetLogs()
	local logText = "Recent Actions:\n"
	for i, log in ipairs(logs) do
		if i <= 10 then
			logText = logText .. "[" .. os.date("%H:%M:%S", log.Timestamp) .. "] " .. log.Action .. "\n"
		end
	end
	
	UIUtilities:CreateLabel(parent, "LogsList", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 1, -60), logText, 12)
end

function AdminPanel:CreateDeveloperTab(parent)
	UIUtilities:CreateLabel(parent, "DevTitle", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 30), "🛠 Developer Tools", 20, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
	
	UIUtilities:CreateButton(parent, "Debug", UDim2.new(0, 10, 0, 50), UDim2.new(0.4, -15, 0, 35), "Debug Console", function()
		print("Debug console opened")
	end)
	
	UIUtilities:CreateButton(parent, "Perf", UDim2.new(0.5, 5, 0, 50), UDim2.new(0.4, -15, 0, 35), "Performance", function()
		print("Performance monitor opened")
	end)
end

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	if player == Players.LocalPlayer then
		wait(1)
		AdminPanel:Create()
	end
end)

if Players.LocalPlayer then
	wait(1)
	AdminPanel:Create()
end

print("✅ Admin Panel Loaded Successfully")

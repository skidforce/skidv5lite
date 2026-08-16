local run = function(func)
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end
local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new('BindableEvent')
		return self[index]
	end
})

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local replicatedFirst = cloneref(game:GetService('ReplicatedFirst'))
local collectionService = cloneref(game:GetService('CollectionService'))
local runService = cloneref(game:GetService('RunService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local mapobj
local lstats

local function isFriend(plr, recolor)
	if vape.Categories.Friends.Options['Use friends'].Enabled then
		local friend = table.find(vape.Categories.Friends.ListEnabled, plr.Name) and true
		if recolor then
			friend = friend and vape.Categories.Friends.Options['Recolor visuals'].Enabled
		end
		return friend
	end
	return nil
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function waitForChildOfType(obj, name, timeout, prop)
	local checktick = tick() + timeout
	local returned
	repeat
		returned = prop and obj[name] or obj:FindFirstChildOfClass(name)
		if returned or checktick < tick() then break end
		task.wait()
	until false
	return returned
end

run(function()
	lstats = lplr:FindFirstChild('TempPlayerStatsModule')
	if not lstats then
		repeat
			lstats = lplr:FindFirstChild('TempPlayerStatsModule')
			task.wait()
		until lstats or vape.Loaded == nil

		if vape.Loaded == nil then
			return
		end
	end

	local mapval = replicatedStorage.CurrentMap
	local function updateMap()
		if mapval.Value then
			mapobj = mapval.Value
			vapeEvents.MapAdded:Fire(mapobj)
		elseif mapboj then
			vapeEvents.MapRemoved:Fire(mapboj)
			mapobj = nil
		end
	end

	vape:Clean(mapval:GetPropertyChangedSignal('Value'):Connect(updateMap))
	if mapval.Value then
		updateMap()
	end
end)

run(function()
	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = waitForChildOfType(char, 'Humanoid', 10)
			local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
			local head = char:WaitForChild('Head', 10) or humrootpart
			local plrstats = plr:WaitForChild('TempPlayerStatsModule', 10) or {IsBeast = {GetPropertyChangedSignal = function() return {Connect = function() end} end}}

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = hum.Health,
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					IsBeast = plrstats.IsBeast.Value,
					HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
					MaxHealth = hum.MaxHealth,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					TeamCheck = teamfunc
				}

				if plr == lplr then
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
				else
					entity.Targetable = entitylib.targetCheck(entity)

					table.insert(entity.Connections, plrstats.IsBeast:GetPropertyChangedSignal('Value'):Connect(function()
						entitylib.refreshEntity(entity.Character, entity.Player)
					end))

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							entity.Health = hum.Health
							entity.MaxHealth = hum.MaxHealth
							entitylib.Events.EntityUpdated:Fire(entity)
						end))
					end

					table.insert(entitylib.List, entity)
					entitylib.Events.EntityAdded:Fire(entity)
				end
			end
			entitylib.EntityThreads[char] = nil
		end)
	end

	entitylib.getEntityColor = function(ent)
		if not (ent.Player and vape.Categories.Main.Options['Use team color'].Enabled) then return end
		if isFriend(ent.Player, true) then
			return Color3.fromHSV(vape.Categories.Friends.Options['Friends color'].Hue, vape.Categories.Friends.Options['Friends color'].Sat, vape.Categories.Friends.Options['Friends color'].Value)
		end
		return ent.IsBeast and Color3.new(1, 0.2, 0.2) or Color3.new(0.3, 1, 0.3)
	end

	entitylib.start()
end)

for _, v in {'AimAssist', 'Reach', 'SilentAim', 'TriggerBot', 'AntiFall', 'Invisible', 'Jesus', 'Killaura', 'AntiRagdoll', 'Disabler', 'MurderMystery'} do
	vape:Remove(v)
end











run(function()
	local ComputerESP
	local FillColor
	local OutlineColor
	local FillTransparency
	local OutlineTransparency
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local function Added(computer)
		local screen = computer:FindFirstChild('Screen')
		local cham = Instance.new('Highlight')
		cham.Adornee = computer
		cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		cham.FillColor = Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
		cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
		cham.FillTransparency = FillTransparency.Value
		cham.OutlineTransparency = OutlineTransparency.Value
		cham.Parent = Folder
		cham.Enabled = screen.Color ~= Color3.fromRGB(40, 127, 71)
	
		ComputerESP:Clean(screen:GetPropertyChangedSignal('Color'):Connect(function()
			cham.Enabled = screen.Color ~= Color3.fromRGB(40, 127, 71)
		end))
	
		Reference[computer] = cham
	end
	
	local function Removed(computer)
		if Reference[computer] then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
	
			Reference[computer]:Destroy()
			Reference[computer] = nil
		end
	end
	
	local function MapAdded(map)
		local status = replicatedStorage.GameStatus
		if status.Value:find('LOADING') or status.Value:find('START') then
			repeat
				task.wait()
			until not (status.Value:find('LOADING') or status.Value:find('START')) or not ComputerESP.Enabled
	
			if not ComputerESP.Enabled then
				return
			end
		end
	
		for _, v in map:GetChildren() do
			if v.Name == 'ComputerTable' then
				task.spawn(Added, v)
			end
		end
	end
	
	ComputerESP = vape.Categories.Render:CreateModule({
		Name = 'ComputerESP',
		Function = function(callback)
			if callback then
				ComputerESP:Clean(vapeEvents.MapAdded.Event:Connect(MapAdded))
				ComputerESP:Clean(vapeEvents.MapRemoved.Event:Connect(function()
					for _, v in Reference do
						v:Destroy()
					end
					table.clear(Reference)
				end))
	
				if mapobj then
					task.spawn(MapAdded, mapobj)
				end
			else
				for _, v in Reference do
					v:Destroy()
				end
				table.clear(Reference)
			end
		end,
		Tooltip = 'Show nearby uncompleted computers.'
	})
	FillColor = ComputerESP:CreateColorSlider({
		Name = 'Color',
		Function = function(hue, sat, val)
			for _, v in Reference do
				v.FillColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	OutlineColor = ComputerESP:CreateColorSlider({
		Name = 'Outline Color',
		DefaultSat = 0,
		Function = function(hue, sat, val)
			for _, v in Reference do
				v.OutlineColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	FillTransparency = ComputerESP:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Default = 0.5,
		Function = function(val)
			for _, v in Reference do
				v.FillTransparency = val
			end
		end,
		Decimal = 10
	})
	OutlineTransparency = ComputerESP:CreateSlider({
		Name = 'Outline Transparency',
		Min = 0,
		Max = 1,
		Default = 0.5,
		Function = function(val)
			for _, v in Reference do
				v.OutlineTransparency = val
			end
		end,
		Decimal = 10
	})
end)

run(function()
	local AutoComputer
	local connection, old
	
	local function getConnection(event)
		local connection = getconnections(lstats.TimingGoalPosition.Changed)[1]
		if not connection then
			repeat
				connection = getconnections(lstats.TimingGoalPosition.Changed)[1]
				task.wait()
			until connection or not AutoComputer.Enabled
		end
	
		return AutoComputer.Enabled and connection
	end
	
	
	AutoComputer = vape.Categories.Utility:CreateModule({
		Name = 'AutoComputer',
		Function = function(callback)
			if callback then
				connection = getConnection()
				if not connection then return end
	
				old = hookfunction(connection.Function, function(...)
					if lplr.TempPlayerStatsModule.TimingGoalPosition.Value > 0 then
						replicatedStorage.RemoteEvent:FireServer('SetPlayerMinigameResult', true)
					end
				end)
			else
				if old and connection.Function then
					hookfunction(connection.Function, old)
				end
				connection = nil
			end
		end,
		Tooltip = 'Automatically complete the computer skill check.'
	})
end)
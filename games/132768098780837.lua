local run = function(func)
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local collectionService = cloneref(game:GetService('CollectionService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local runService = cloneref(game:GetService('RunService'))
local guiService = cloneref(game:GetService('GuiService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local gameLighting = game:GetService('Lighting')
local httpService = cloneref(game:GetService('HttpService'))
local tweenService = cloneref(game:GetService('TweenService'))
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo

local bw = {}
local blocks = {}
local BlockTimes = {}
local AnticheatBypass
local bypassRoot
local isAttacking

local combatRemotes = replicatedStorage:WaitForChild('GameEvents'):WaitForChild('CombatRemotes')
local combatFeint = combatRemotes:WaitForChild('Combat_FeintSwing')
local combatAttack = combatRemotes:WaitForChild('Combat_RequestAttack')

local function applySpeed(speed, dt)
	local root = entitylib.character.RootPart
	local dest = (entitylib.character.Humanoid.MoveDirection * math.max((speed + (entitylib.character.Humanoid.WalkSpeed - 16)) - entitylib.character.Humanoid.WalkSpeed, 0) * dt)
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
	rayCheck.CollisionGroup = root.CollisionGroup

	local ray = workspace:Raycast(root.Position, dest, rayCheck)
	if ray then
		dest = ((ray.Position + ray.Normal) - root.Position)
	end
	root.CFrame += dest
end

local function collection(tags, module, customadd, customremove)
	tags = typeof(tags) ~= 'table' and {tags} or tags
	local objs, connections = {}, {}

	for _, tag in tags do
		table.insert(connections, collectionService:GetInstanceAddedSignal(tag):Connect(function(v)
			if customadd then
				customadd(objs, v, tag)
				return
			end
			table.insert(objs, v)
		end))
		table.insert(connections, collectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
			if customremove then
				customremove(objs, v, tag)
				return
			end
			v = table.find(objs, v)
			if v then
				table.remove(objs, v)
			end
		end))

		for _, v in collectionService:GetTagged(tag) do
			if customadd then
				customadd(objs, v, tag)
				continue
			end
			table.insert(objs, v)
		end
	end

	local cleanFunc = function(self)
		for _, v in connections do
			v:Disconnect()
		end
		table.clear(connections)
		table.clear(objs)
		table.clear(self)
	end
	if module then
		module:Clean(cleanFunc)
	end
	return objs, cleanFunc
end

local function getInventory()
	local inv = {}
	local backpack = lplr:FindFirstChildWhichIsA('Backpack')
	if backpack then
		inv = backpack:GetChildren()
	end

	local equipped = lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool')
	if equipped then
		table.insert(inv, equipped)
	end

	return inv
end

local function getTool()
	return lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool')
end

run(function()
	local oldstart = entitylib.start
	local function customEntity(ent)
		entitylib.addEntity(ent, nil, function(self)
			return (lplr.Team and lplr.Team.Name or '') ~= self.Character:GetAttribute('TeamId')
		end)
	end

	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			for _, ent in collectionService:GetTagged('Attackable') do
				customEntity(ent)
			end
			table.insert(entitylib.Connections, collectionService:GetInstanceAddedSignal('Attackable'):Connect(customEntity))
			table.insert(entitylib.Connections, collectionService:GetInstanceRemovedSignal('Attackable'):Connect(function(ent)
				entitylib.removeEntity(ent)
			end))
		end
	end
end)
entitylib.start()

run(function()
	bw = {
		RemoteIndex = require(replicatedStorage.Modules.RemotesIndex),
		BlockBreakConstants = require(replicatedStorage.Modules.Configs.BlockBreakConfig),
		ShopConfig = require(replicatedStorage.Modules.Configs.ShopConfig),
		Inventory = debug.getupvalue(require(replicatedStorage.Modules.ShopUIClient).Start, 8)
	}

	blocks = collection('BedWarsX_PlacedBlock', vape, function(tab, block)
		tab[block.Position // 3] = block
	end, function(tab, block)
		tab[block.Position // 3] = nil
	end)

	local kills = sessioninfo:AddItem('Kills')
	local beds = sessioninfo:AddItem('Beds')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	task.delay(1, function()
		if workspace:GetAttribute('ServerType') ~= 'Lobby' then
			games:Increment()
		end
	end)

	vape:Clean(lplr:GetAttributeChangedSignal('RoundKills'):Connect(function()
		if lplr:GetAttribute('RoundKills') > 0 then
			kills:Increment()
		end
	end))

	vape:Clean(bw.RemoteIndex.Round_Event.OnClientEvent:Connect(function(data)
		if type(data) == 'table' and data.id == 'final_kill' then
			if lplr.Team and lplr.Team.Name == data.teamId then
				wins:Increment()
			end
		end
	end))

	vape:Clean(bw.RemoteIndex.Bed_Destroyed.OnClientEvent:Connect(function(data)
		if type(data) == 'table' and data.breakerId == lplr.UserId then
			beds:Increment()
		end
	end))

	vape:Clean(entitylib.Events.EntityAdded:Connect(function(entity)
		BlockTimes[entity.Character] = 0

		local animator = entity.Humanoid:FindFirstChild('Animator')
		if animator then
			table.insert(entity.Connections, animator.AnimationPlayed:Connect(function(track)
				if track.Animation.AnimationId == 'rbxassetid://99664081334494' or track.Animation.AnimationId == 'rbxassetid://75062274621204' then
					BlockTimes[entity.Character] = os.clock()
				end
			end))
		end
	end))

	vape:Clean(entitylib.Events.EntityRemoving:Connect(function(entity)
		BlockTimes[entity.Character] = nil
	end))
end)

for _, v in {'AimAssist', 'Reach', 'SilentAim', 'TriggerBot', 'Jesus', 'AutoRejoin', 'Disabler', 'FastProxPrompt', 'SafeWalk', 'MurderMystery'} do
	vape:Remove(v)
end



local Fly






run(function()
	local AutoLeave
	
	AutoLeave = vape.Categories.Utility:CreateModule({
		Name = 'AutoLeave',
		Function = function(callback)
			if callback then
				AutoLeave:Clean(bw.RemoteIndex.Victory_Show.OnClientEvent:Connect(function()
					replicatedStorage.GameEvents.BedWarsRemotes.Return_To_Lobby:FireServer()
				end))
			end
		end,
		Tooltip = 'Automatically leave after the match ends.'
	})
end)

run(function()
	local AutoQueue
	
	AutoQueue = vape.Categories.Utility:CreateModule({
		Name = 'AutoQueue',
		Function = function(callback)
			if callback then
				if workspace:GetAttribute('ServerType') == 'Lobby' then
					task.spawn(function()
						bw.RemoteIndex.Matchmaking_Request:InvokeServer('queue')
					end)
				end
			end
		end,
		Tooltip = 'Automatically queue in the lobby.'
	})
end)

run(function()
	local AutoToxic
	local GG
	local Toggles, Lists, Cloned, Presets = {}, {}, {}, {}
	
	local function sendMessage(name, obj, default)
		local message = default
		if #Lists[name].ListEnabled > 0 then
			if #Cloned[name] <= 0 then
				Cloned[name] = table.clone(Lists[name].ListEnabled)
			end
	
			local entry = Random.new():NextInteger(1, #Cloned[name])
			message = Cloned[name][entry]
			table.remove(Cloned[name], entry)
		end
	
		if not message then return end
	
		message = message and message:gsub('<obj>', obj or '') or ''
		if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			if textChatService:CanUserChatAsync(lplr.UserId) then
				textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
			else
				textChatService.ChatInputBarConfiguration.TargetTextChannel:SendPresetAsync(Presets[message] or Presets['So close'])
			end
		else
			replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, 'All')
		end
	end
	
	AutoToxic = vape.Categories.Utility:CreateModule({
		Name = 'AutoToxic',
		Function = function(callback)
			if callback then
				AutoToxic:Clean(bw.RemoteIndex.Round_Event.OnClientEvent:Connect(function(data)
					if type(data) == 'table' and data.id == 'final_kill' then
						if GG.Enabled then
							if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
								if textChatService:CanUserChatAsync(lplr.UserId) then
									textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('gg')
								else
									textChatService.ChatInputBarConfiguration.TargetTextChannel:SendPresetAsync(Presets['Good game'])
								end
							else
								replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('gg', 'All')
							end
						end
	
						if lplr.Team and lplr.Team.Name == data.teamId then
							if Toggles.Win.Enabled then
								sendMessage('Win', nil, 'yall garbage')
							end
						end
					end
				end))
			end
		end,
		Tooltip = 'Says a message after a certain action'
	})
	GG = AutoToxic:CreateToggle({
		Name = 'AutoGG',
		Default = true
	})
	for _, v in {'Win'} do
		Cloned[v] = {}
		Toggles[v] = AutoToxic:CreateToggle({
			Name = v..' ',
			Function = function(callback)
				if Lists[v] then
					Lists[v].Object.Visible = callback
				end
			end
		})
		Lists[v] = AutoToxic:CreateTextList({
			Name = v,
			Darker = true,
			Visible = false,
			Function = function()
				table.clear(Cloned[v])
			end
		})
	end
	
	pcall(function()
		for _, group in textChatService:GetPresetsAsync().categoryGroups do
			for _, category in group.categories do
				for _, message in category.messages do
					Presets[message.value] = message.presetId
				end
			end
		end
	end)
end)

run(function()
	local AutoBuy
	local shops = {}
	local requirements = {
		armor = {
			['Leather Armor'] = 'pickaxe_iron'
		},
		pickaxe = {
			['pickaxe_gold'] = 'Golden Armor',
			['pickaxe_diamond'] = 'Diamond Armor'
		}
	}
	
	local function buyCategory(ladder, default)
		local tierItems = {}
		for _, item in bw.ShopConfig.Items do
			if item.ladder == ladder then
				table.insert(tierItems, item)
			end
		end
	
		table.sort(tierItems, function(a, b)
			return (a.tier or -1) < (b.tier or -1)
		end)
	
		local nextTier = default and tierItems[1] or nil
		for _, item in tierItems do
			if bw.Inventory.items[item.id] then
				nextTier = tierItems[table.find(tierItems, item) + 1]
				break
			end
		end
	
		if nextTier then
			for index, item in {'Block', 'Gold', 'Diamond'} do
				if (nextTier.cost and nextTier.cost[item] or 0) > (bw.Inventory[index == 1 and 'blocks' or item:lower()] or 0) then
					return false
				end
			end
	
			if requirements[ladder] and requirements[ladder][nextTier.id] and not bw.Inventory.items[requirements[ladder][nextTier.id]] then
				return false
			end
	
			bw.RemoteIndex.Shop_Purchase:InvokeServer({itemId = nextTier.id})
			return true
		end
	
		return false
	end
	
	AutoBuy = vape.Categories.Inventory:CreateModule({
		Name = 'AutoBuy',
		Function = function(callback)
			if callback then
				shops = collection('BedWarsX_ShopNPC')
	
				repeat
					if entitylib.isAlive then
						local localPosition = entitylib.character.RootPart.Position
						for _, shop in shops do
							if (shop.Position - localPosition).Magnitude < 20 then
								if buyCategory('armor', true) then break end
								if buyCategory('pickaxe') then break end
								if buyCategory('sword') then break end
								break
							end
						end
					end
	
					task.wait(0.2)
				until not AutoBuy.Enabled
			end
		end,
		Tooltip = 'lol'
	})
end)

run(function()
	local Breaker
	local Mode
	local Range
	local BreakSpeed
	local BedToggle
	local GeneratorToggle
	local SelfBreak
	local origCF
	local currentTarget = nil

	local function getPick()
		local inv = getInventory()
		for _, tool in inv do
			if tool:GetAttribute('Tier') then
				return tool
			end
		end
	end

	local function attemptBreak(tab, localPosition, tool)
		if not tab then return end
		for _, v in tab do
			local noRangeCheck = Mode.Value == 'Auto'
			if noRangeCheck or (v.Position - localPosition).Magnitude < Range.Value then
				if v:GetAttribute('BedTeamId') ~= (lplr.Team and lplr.Team.Name or '') and (v:GetAttribute('HP') or 10) > 0 then
				if tool.Parent ~= lplr.Character then
					entitylib.character.Humanoid:EquipTool(tool)
				end

				if v:HasTag('BedWarsX_BedSpawn') then
					local notCovered = false
					for _, normal in Enum.NormalId:GetEnumItems() do
						if normal ~= Enum.NormalId.Bottom then
							if not blocks[v.Position // 3 + Vector3.fromNormalId(normal)] then
								notCovered = true
								break
							end
						end
					end

					if notCovered then
						bw.RemoteIndex.Block_AttemptHit:FireServer({
							camPos = localPosition,
							hitPos = v:GetClosestPointOnSurface(localPosition),
							blockInstance = v
						})
					else
						local aboveBlock = blocks[v.Position // 3 + Vector3.new(0, 1, 0)]

						if aboveBlock then
							bw.RemoteIndex.Block_AttemptHit:FireServer({
								camPos = localPosition,
								hitPos = aboveBlock:GetClosestPointOnSurface(localPosition),
								blockInstance = aboveBlock
							})
						end
					end

					task.wait(0.15)
				else
					bw.RemoteIndex.Mine_AttemptHit:FireServer(v)
				end

				task.wait(0.05)
				return true
			end
		end
	end

	return false
end

	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Breaker',
		Function = function(callback)
			if callback then
				local beds = collection('BedWarsX_BedSpawn', Breaker)
				local generators = collection('BedWarsX_Resource', Breaker)

				repeat
					task.wait(1 / 60)
					if not Breaker.Enabled then break end

					local tool = getPick()
					if entitylib.isAlive and tool and not isAttacking then
						if Mode.Value == 'Teleport' then
							-- Teleport mode: lock onto ONE bed/generator until destroyed
							if BedToggle.Enabled then
								-- find target if none or current destroyed
								if not currentTarget or not currentTarget.Parent or currentTarget:GetAttribute('BedTeamId') == (lplr.Team and lplr.Team.Name or '') or (currentTarget:GetAttribute('HP') or 10) <= 0 then
									for _, v in collectionService:GetTagged('BedWarsX_BedSpawn') do
										if v:GetAttribute('BedTeamId') ~= (lplr.Team and lplr.Team.Name or '') and (v:GetAttribute('HP') or 10) > 0 then
											currentTarget = v
											break
										end
									end
								end

								if currentTarget then
									origCF = entitylib.character.RootPart.CFrame
									entitylib.character.RootPart.CFrame = CFrame.new(currentTarget.Position + Vector3.new(0, 5, 0))
									task.wait(0.1)
									
									attemptBreak({currentTarget}, entitylib.character.RootPart.Position, tool)
									
									task.wait(0.1)
									if origCF then entitylib.character.RootPart.CFrame = origCF end
								end
							end
							
							if GeneratorToggle.Enabled and not currentTarget then
								if not currentTarget or not currentTarget.Parent or (currentTarget:GetAttribute('HP') or 10) <= 0 then
									for _, v in collectionService:GetTagged('BedWarsX_Resource') do
										if (v:GetAttribute('HP') or 10) > 0 then
											currentTarget = v
											break
										end
									end
								end

								if currentTarget then
									origCF = entitylib.character.RootPart.CFrame
									entitylib.character.RootPart.CFrame = CFrame.new(currentTarget.Position + Vector3.new(0, 5, 0))
									task.wait(0.1)
									
									attemptBreak({currentTarget}, entitylib.character.RootPart.Position, tool)
									
									task.wait(0.1)
									if origCF then entitylib.character.RootPart.CFrame = origCF end
								end
							end
						else
							-- Normal mode: range check from your position
							local localPosition = entitylib.character.RootPart.Position
							if BedToggle.Enabled then
								if attemptBreak(beds, localPosition, tool) then continue end
							end
							if GeneratorToggle.Enabled then
								if attemptBreak(generators, localPosition, tool) then continue end
							end
						end
					end
				until not Breaker.Enabled
				currentTarget = nil
			else
				origCF = nil
				currentTarget = nil
			end
		end,
		Tooltip = 'Break blocks around you\nTeleport: lock onto ONE bed until destroyed\nNormal: break within range'
	})
	Mode = Breaker:CreateDropdown({
		Name = 'Mode',
		List = {'Teleport', 'Normal'},
		Default = 'Teleport',
		Tooltip = 'Teleport: TP to bed, break, TP back\nNormal: break within range'
	})
	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 12,
		Default = 12,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	BreakSpeed = Breaker:CreateSlider({
		Name = 'Break speed',
		Min = 0,
		Max = 0.3,
		Default = 0.25,
		Decimal = 100,
		Suffix = 'seconds'
	})
	BedToggle = Breaker:CreateToggle({
		Name = 'Break beds',
		Default = true
	})
	GeneratorToggle = Breaker:CreateToggle({
		Name = 'Break generators',
		Default = true
	})
	SelfBreak = Breaker:CreateToggle({
		Name = 'Self break',
		Default = false
	})
end)

run(function()
	local FixGUIs
	
	FixGUIs = vape.Legit:CreateModule({
		Name = 'FixGUIs',
		Function = function(callback)
			if callback then
				local guis = {lplr.PlayerGui:FindFirstChild('Team_UpgradesV3', true), lplr.PlayerGui:FindFirstChild('ItemShopV3', true)}
				if #guis < 2 then
					repeat
						guis = {lplr.PlayerGui:FindFirstChild('Team_UpgradesV3', true), lplr.PlayerGui:FindFirstChild('ItemShopV3', true)}
						task.wait()
					until #guis >= 2 or not FixGUIs.Enabled
	
					if not FixGUIs.Enabled then
						return
					end
				end
	
				local vis = false
				local mouse = Instance.new('ImageLabel')
				mouse.Size = UDim2.fromOffset(20, 20)
				mouse.Visible = false
				mouse.Parent = vape.gui
				FixGUIs:Clean(mouse)
	
				for _, gui in guis do
					if gui then
						for _, v in gui:QueryDescendants('TextButton') do
							local ancestor = v:FindFirstAncestorWhichIsA('ScrollingFrame')
							if not ancestor then
								v.Modal = true
							end
						end
	
						vis = vis or gui.Visible
						FixGUIs:Clean(gui:GetPropertyChangedSignal('Visible'):Connect(function()
							vis = gui.Visible
						end))
					end
				end
	
				FixGUIs:Clean(runService.Heartbeat:Connect(function()
					local location = inputService:GetMouseLocation()
					mouse.Visible = vis
					if mouse.Visible then
						mouse.Position = UDim2.fromOffset(location.X, location.Y)
					end
				end))
			end
		end,
		Tooltip = 'Fix GUI\'s in first person.'
	})
end)

run(function()
	local HideShield
	local parts = {}
	
	local function localAdded(char)
		local shield = char.Character:WaitForChild('ShieldModel', 10)
		if shield then
			parts = shield:QueryDescendants('BasePart')
		end
	end
	
	HideShield = vape.Legit:CreateModule({
		Name = 'HideShield',
		Function = function(callback)
			if callback then
				HideShield:Clean(entitylib.Events.LocalAdded:Connect(localAdded))
				if entitylib.isAlive then
					task.spawn(localAdded, entitylib.character)
				end
	
				repeat
					for _, v in parts do
						v.Transparency = 1
					end
	
					task.wait()
				until not HideShield.Enabled
			else
				table.clear(parts)
			end
		end,
		Tooltip = 'Hide the shield entirely.'
	})
end)

-- ============================================
-- AUTOSAVE CONFIG
-- ============================================
do
	local gameId = game.GameId
	local configPath = 'skidv5/profiles/'..gameId..'.txt'

	local function loadConfig()
		if isfile(configPath) then
			local ok, data = pcall(function()
				return httpService:JSONDecode(readfile(configPath))
			end)
			if ok and data then
				for moduleName, moduleData in pairs(data) do
					if moduleData and type(moduleData) == 'table' then
						local mod = vape.Modules[moduleName]
						if mod then
							if moduleData.Enabled and not mod.Enabled then
								pcall(function() mod:Toggle() end)
							elseif not moduleData.Enabled and mod.Enabled then
								pcall(function() mod:Toggle() end)
							end
							if moduleData.Options then
								for optionName, optionVal in pairs(moduleData.Options) do
									if mod.Options[optionName] then
										pcall(function()
											if type(optionVal) == 'table' and optionVal.Value ~= nil then
												mod.Options[optionName]:SetValue(optionVal.Value)
											elseif type(optionVal) == 'boolean' then
												if mod.Options[optionName].Enabled ~= optionVal then
													mod.Options[optionName]:Toggle()
												end
											elseif type(optionVal) == 'string' then
												mod.Options[optionName]:SetValue(optionVal)
											elseif type(optionVal) == 'number' then
												mod.Options[optionName]:SetValue(optionVal)
											end
										end)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local function saveConfig()
		local data = {}
		for name, mod in pairs(vape.Modules) do
			if mod.Enabled or (mod.Options and next(mod.Options)) then
				data[name] = {Enabled = mod.Enabled, Options = {}}
				if mod.Options then
					for optName, opt in pairs(mod.Options) do
						pcall(function()
							if opt.Value ~= nil then
								data[name].Options[optName] = {Value = opt.Value}
							elseif opt.Enabled ~= nil then
								data[name].Options[optName] = opt.Enabled
							end
						end)
					end
				end
			end
		end
		pcall(function()
			writefile(configPath, httpService:JSONEncode(data))
		end)
	end

	task.spawn(loadConfig)

	task.spawn(function()
		while task.wait(30) do
			if vape.Loaded then
				pcall(saveConfig)
			end
		end
	end)

	vape:Clean(function()
		pcall(saveConfig)
	end)

	pcall(function()
		game:GetService('Players').LocalPlayer.OnTeleport:Connect(function()
			pcall(saveConfig)
		end)
	end)

	pcall(function()
		lplr.CharacterAdded:Connect(function()
			task.wait(2)
			if vape.Loaded then
				pcall(saveConfig)
			end
		end)
	end)
end

-- ============================================
-- NOFALL (ground snap)
-- ============================================


-- ============================================
-- SWORD ANIMATIONS
-- ============================================
run(function()
	local SwordAnims
	local AnimStyle
	local AnimSpeed
	local AnimIntensity
	local ViewMode
	local oldSwing
	local animToken = 0
	local bases = {}
	local running = false

	local function getViewmodelWrist()
		local vm = gameCamera:FindFirstChild('Viewmodel')
		if vm and vm:FindFirstChild('RightHand') then
			return vm.RightHand:FindFirstChild('RightWrist')
		end
		return nil
	end

	local function getCharacterWrist()
		local char = lplr.Character
		if char then
			local hand = char:FindFirstChild('RightHand')
			if hand then
				return hand:FindFirstChild('RightWrist')
			end
		end
		return nil
	end

	local function getTargets()
		local targets = {}
		local mode = ViewMode and ViewMode.Value or 'Viewmodel'
		if mode ~= 'Character' then
			local wrist = getViewmodelWrist()
			if wrist then targets[wrist] = true end
		end
		if mode ~= 'Viewmodel' then
			local wrist = getCharacterWrist()
			if wrist then targets[wrist] = true end
		end
		return targets
	end

	local function stopAnimation()
		running = false
		animToken += 1
		for wrist, base in bases do
			pcall(function()
				wrist.C1 = base
			end)
		end
		bases = {}
	end

	local function playAnimation(style, speed, intensity)
		local targets = getTargets()
		local count = 0
		for _ in targets do count += 1 end
		if count == 0 then return end
		bases = {}
		for wrist in targets do
			bases[wrist] = wrist.C1
		end
		local token = animToken + 1
		animToken = token
		running = true
		local function isActive()
			return running and SwordAnims.Enabled and token == animToken
		end
		local function applyCF(cf)
			for wrist, base in bases do
				pcall(function()
					wrist.C1 = base * cf
				end)
			end
		end

		if style == 'BlockHit' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 10
					local phase = (math.sin(t) + 1) / 2
					local slash = CFrame.Angles(math.rad(-60 * intensity), 0, math.rad(-30 * intensity))
					local block = CFrame.Angles(0, 0, math.rad(90 * intensity))
					applyCF(slash:Lerp(block, phase))
				end
			end)

		elseif style == 'Spam' then
			task.spawn(function()
				while isActive() do
					applyCF(CFrame.Angles(
						math.rad(math.random(-80, 80) * intensity),
						math.rad(math.random(-50, 50) * intensity),
						math.rad(math.random(-60, 60) * intensity)
					))
					task.wait(0.04 / speed)
				end
			end)

		elseif style == 'Smooth' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 4
					local swing = math.sin(t) * intensity
					local rx = swing * 70
					local rz = math.cos(t * 0.5) * 20 * intensity
					applyCF(CFrame.Angles(math.rad(rx), 0, math.rad(rz)))
				end
			end)

		elseif style == 'Snap' then
			task.spawn(function()
				while isActive() do
					applyCF(CFrame.Angles(math.rad(-80 * intensity), 0, math.rad(40 * intensity)))
					task.wait(0.05 / speed)
					if not isActive() then break end
					applyCF(CFrame.Angles(math.rad(30 * intensity), 0, math.rad(-20 * intensity)))
					task.wait(0.08 / speed)
				end
			end)

		elseif style == 'Circular' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 6
					local rx = math.cos(t) * 50 * intensity
					local ry = math.sin(t) * 40 * intensity
					local rz = math.sin(t * 1.5) * 30 * intensity
					applyCF(CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz)))
				end
			end)

		elseif style == 'Jitter' then
			task.spawn(function()
				while isActive() do
					local rx = math.sin(tick() * 40) * 15 * intensity
					local ry = math.cos(tick() * 30) * 10 * intensity
					local rz = math.sin(tick() * 50) * 12 * intensity
					applyCF(CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz)))
					task.wait(0.03)
				end
			end)

		elseif style == 'Vertical' then
			task.spawn(function()
				while isActive() do
					applyCF(CFrame.Angles(math.rad(-90 * intensity), 0, 0))
					task.wait(0.1 / speed)
					if not isActive() then break end
					applyCF(CFrame.Angles(math.rad(40 * intensity), 0, 0))
					task.wait(0.12 / speed)
				end
			end)

		elseif style == 'Spin' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 8
					local rx = math.sin(t * 2) * 25 * intensity
					local ry = (t % (math.pi * 2)) * intensity
					local rz = math.cos(t) * 15 * intensity
					applyCF(CFrame.Angles(math.rad(rx), ry, math.rad(rz)))
				end
			end)

		elseif style == 'FigureEight' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 5
					local rx = math.sin(t) * 55 * intensity
					local ry = math.sin(t * 2) * 35 * intensity
					local rz = math.cos(t) * 20 * intensity
					applyCF(CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz)))
				end
			end)

		elseif style == 'Diagonal' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 5
					local phase = math.sin(t)
					local rx = phase * 70 * intensity
					local ry = math.abs(math.cos(t)) * 45 * intensity
					local rz = phase * 30 * intensity
					applyCF(CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz)))
				end
			end)

		elseif style == 'Twirl' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 10
					local rz = math.sin(t) * 180 * intensity
					local rx = math.cos(t * 1.5) * 20 * intensity
					applyCF(CFrame.Angles(math.rad(rx), 0, math.rad(rz)))
				end
			end)

		elseif style == 'Windmill' then
			task.spawn(function()
				local t = 0
				while isActive() do
					local dt = task.wait()
					t = t + dt * speed * 6
					local rx = math.cos(t) * 120 * intensity
					local ry = math.sin(t) * 40 * intensity
					applyCF(CFrame.Angles(math.rad(rx), math.rad(ry), 0))
				end
			end)
		end
	end

	SwordAnims = vape.Categories.Combat:CreateModule({
		Name = 'SwordAnimations',
		Function = function(callback)
			if callback then
				oldSwing = combatFeint.FireServer
				combatFeint.FireServer = function(self, ...)
					stopAnimation()
					playAnimation(AnimStyle.Value, AnimSpeed.Value, AnimIntensity.Value)
					return oldSwing(self, ...)
				end
			else
				if oldSwing then
					combatFeint.FireServer = oldSwing
					oldSwing = nil
				end
				stopAnimation()
			end
		end,
		Tooltip = 'Custom sword animations\nwith 12 different styles'
	})
	AnimStyle = SwordAnims:CreateDropdown({
		Name = 'Animation style',
		List = {'BlockHit', 'Spam', 'Smooth', 'Snap', 'Circular', 'Jitter', 'Vertical', 'Spin', 'FigureEight', 'Diagonal', 'Twirl', 'Windmill'},
		Default = 'Smooth',
		Tooltip = 'BlockHit: block-slash alternation\nSpam: rapid random rotations\nSmooth: interpolated swing arc\nSnap: instant snap between poses\nCircular: continuous orbital motion\nJitter: small random offsets\nVertical: overhead chopping motion\nSpin: full wrist spin\nFigureEight: figure-eight motion\nDiagonal: angled slash\nTwirl: fast wrist twirl\nWindmill: large overhead windmill'
	})
	AnimSpeed = SwordAnims:CreateSlider({
		Name = 'Animation speed',
		Min = 0.5,
		Max = 3,
		Default = 1,
		Decimal = 10
	})
	AnimIntensity = SwordAnims:CreateSlider({
		Name = 'Animation intensity',
		Min = 0.2,
		Max = 2,
		Default = 1,
		Decimal = 10
	})
	ViewMode = SwordAnims:CreateDropdown({
		Name = 'View mode',
		List = {'Viewmodel', 'Character', 'Both'},
		Default = 'Viewmodel',
		Tooltip = 'Viewmodel: first-person viewmodel\nCharacter: your 3rd person character rig\nBoth: animate both at once'
	})
end)

-- ============================================
-- HITSOUND
-- ============================================
run(function()
	local HitSound
	local SoundList
	local Volume
	local Pitch

	local sounds = {
		'rbxassetid://14736249347',
		'rbxassetid://8200754399',
		'rbxassetid://6993372814',
		'rbxassetid://279227693',
		'rbxassetid://279229192',
		'rbxassetid://287112271',
		'rbxassetid://388723916',
		'rbxassetid://388726667',
		'rbxassetid://405194080',
		'rbxassetid://481088553',
		'rbxassetid://484200742',
		'rbxassetid://83690472549256',
		'rbxassetid://107176344504758',
		'rbxassetid://111090572475133',
		'rbxassetid://113267949064300',
		'rbxassetid://131326339350805',
	}

	local function getSound()
		local val = SoundList.Value
		if val ~= '' and val:find('rbxassetid') then
			return val
		end
		return sounds[math.random(1, #sounds)]
	end

	HitSound = vape.Categories.Render:CreateModule({
		Name = 'HitSound',
		Function = function(callback)
			if callback then
				HitSound:Clean(combatAttack.OnClientEvent:Connect(function()
					local sound = Instance.new('Sound')
					sound.SoundId = getSound()
					sound.Volume = Volume.Value
					sound.PlaybackSpeed = Pitch.Value
					sound.Parent = gameCamera
					sound.Ended:Connect(function() sound:Destroy() end)
					sound:Play()
				end))
			end
		end,
		Tooltip = 'Plays a sound when you hit an enemy'
	})
	SoundList = HitSound:CreateTextBox({
		Name = 'Sound ID',
		Default = '',
		Placeholder = 'rbxassetid://... (blank = random)',
		Tooltip = 'Enter a Roblox sound ID\nLeave blank for random from preset list'
	})
	Volume = HitSound:CreateSlider({
		Name = 'Volume',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10
	})
	Pitch = HitSound:CreateSlider({
		Name = 'Pitch',
		Min = 0.5,
		Max = 2,
		Default = 1,
		Decimal = 10
	})
end)

-- ============================================
-- FULLBRIGHT
-- ============================================
run(function()
	local Fullbright
	local OldAmbient, OldBrightness

	Fullbright = vape.Categories.Render:CreateModule({
		Name = 'Fullbright',
		Function = function(callback)
			if callback then
				OldAmbient = gameLighting.Ambient
				OldBrightness = gameLighting.Brightness
				gameLighting.Ambient = Color3.fromRGB(255, 255, 255)
				gameLighting.Brightness = 3
				gameLighting.GlobalShadows = false
				gameLighting.ForceEndShadows = true
			else
				gameLighting.Ambient = OldAmbient or Color3.fromRGB(178, 178, 178)
				gameLighting.Brightness = OldBrightness or 1
				gameLighting.GlobalShadows = true
				gameLighting.ForceEndShadows = false
			end
		end,
		Tooltip = 'Max brightness, no shadows'
	})
end)

-- ============================================
-- BLOOM
-- ============================================
run(function()
	local Bloom
	local Intensity
	local Size
	local Threshold
	local effect

	Bloom = vape.Categories.Render:CreateModule({
		Name = 'Bloom',
		Function = function(callback)
			if callback then
				effect = Instance.new('BloomEffect')
				effect.Intensity = Intensity.Value
				effect.Size = Size.Value
				effect.Threshold = Threshold.Value
				effect.Parent = gameLighting
			else
				if effect then effect:Destroy() effect = nil end
			end
		end,
		Tooltip = 'Glow around bright objects'
	})
	Intensity = Bloom:CreateSlider({
		Name = 'Intensity',
		Min = 0,
		Max = 2,
		Default = 0.8,
		Decimal = 10
	})
	Size = Bloom:CreateSlider({
		Name = 'Size',
		Min = 0,
		Max = 56,
		Default = 24
	})
	Threshold = Bloom:CreateSlider({
		Name = 'Threshold',
		Min = 0,
		Max = 2,
		Default = 1,
		Decimal = 10
	})
end)

-- ============================================
-- SUNRAYS
-- ============================================
run(function()
	local SunRays
	local Intensity
	local Spread
	local effect

	SunRays = vape.Categories.Render:CreateModule({
		Name = 'SunRays',
		Function = function(callback)
			if callback then
				effect = Instance.new('SunRaysEffect')
				effect.Intensity = Intensity.Value
				effect.Spread = Spread.Value
				effect.Parent = gameLighting
			else
				if effect then effect:Destroy() effect = nil end
			end
		end,
		Tooltip = 'Light rays from the sun'
	})
	Intensity = SunRays:CreateSlider({
		Name = 'Intensity',
		Min = 0,
		Max = 1,
		Default = 0.2,
		Decimal = 10
	})
	Spread = SunRays:CreateSlider({
		Name = 'Spread',
		Min = 0,
		Max = 1,
		Default = 0.5,
		Decimal = 10
	})
end)

-- ============================================
-- COLOR CORRECTION
-- ============================================
run(function()
	local ColorCorrection
	local Saturation
	local Contrast
	local Brightness
	local effect

	ColorCorrection = vape.Categories.Render:CreateModule({
		Name = 'ColorCorrection',
		Function = function(callback)
			if callback then
				effect = Instance.new('ColorCorrectionEffect')
				effect.Saturation = Saturation.Value
				effect.Contrast = Contrast.Value
				effect.Brightness = Brightness.Value
				effect.Parent = gameLighting
			else
				if effect then effect:Destroy() effect = nil end
			end
		end,
		Tooltip = 'Adjust screen colors'
	})
	Saturation = ColorCorrection:CreateSlider({
		Name = 'Saturation',
		Min = -1,
		Max = 1,
		Default = 0.3,
		Decimal = 10
	})
	Contrast = ColorCorrection:CreateSlider({
		Name = 'Contrast',
		Min = -1,
		Max = 1,
		Default = 0.1,
		Decimal = 10
	})
	Brightness = ColorCorrection:CreateSlider({
		Name = 'Brightness',
		Min = -0.5,
		Max = 0.5,
		Default = 0,
		Decimal = 10
	})
end)

-- ============================================
-- CUSTOM SKY
-- ============================================
run(function()
	local CustomSky
	local SkyboxTop
	local SkyboxBottom
	local SkyboxLeft
	local SkyboxRight
	local SkyboxFront
	local SkyboxBack
	local skyObj

	local function removeOld()
		if skyObj then pcall(function() skyObj:Destroy() end) skyObj = nil end
	end

	local function applySky()
		removeOld()
		if not CustomSky.Enabled then return end

		skyObj = Instance.new('Sky')
		skyObj.SkyboxBk = SkyboxBack.Value ~= '' and SkyboxBack.Value or 'rbxassetid://6444884337'
		skyObj.SkyboxDn = SkyboxBottom.Value ~= '' and SkyboxBottom.Value or 'rbxassetid://6444884785'
		skyObj.SkyboxFt = SkyboxFront.Value ~= '' and SkyboxFront.Value or 'rbxassetid://6444884337'
		skyObj.SkyboxLf = SkyboxLeft.Value ~= '' and SkyboxLeft.Value or 'rbxassetid://6444884337'
		skyObj.SkyboxRt = SkyboxRight.Value ~= '' and SkyboxRight.Value or 'rbxassetid://6444884337'
		skyObj.SkyboxUp = SkyboxTop.Value ~= '' and SkyboxTop.Value or 'rbxassetid://6444884785'
		skyObj.Parent = gameLighting
	end

	CustomSky = vape.Categories.Render:CreateModule({
		Name = 'CustomSky',
		Function = function(callback)
			if callback then
				applySky()
			else
				removeOld()
			end
		end,
		Tooltip = 'Replaces the skybox with custom textures'
	})
	SkyboxTop = CustomSky:CreateTextBox({
		Name = 'Top',
		Default = '',
		Placeholder = 'SkyboxUp texture ID'
	})
	SkyboxBottom = CustomSky:CreateTextBox({
		Name = 'Bottom',
		Default = '',
		Placeholder = 'SkyboxDn texture ID'
	})
	SkyboxLeft = CustomSky:CreateTextBox({
		Name = 'Left',
		Default = '',
		Placeholder = 'SkyboxLf texture ID'
	})
	SkyboxRight = CustomSky:CreateTextBox({
		Name = 'Right',
		Default = '',
		Placeholder = 'SkyboxRt texture ID'
	})
	SkyboxFront = CustomSky:CreateTextBox({
		Name = 'Front',
		Default = '',
		Placeholder = 'SkyboxFt texture ID'
	})
	SkyboxBack = CustomSky:CreateTextBox({
		Name = 'Back',
		Default = '',
		Placeholder = 'SkyboxBk texture ID'
	})
end)

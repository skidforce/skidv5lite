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
local collectionService = cloneref(game:GetService('CollectionService'))
local httpService = cloneref(game:GetService('HttpService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local tweenService = cloneref(game:GetService('TweenService'))
local runService = cloneref(game:GetService('RunService'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getcustomasset = vape.Libraries.getcustomasset

local skywars, remotes = {}, {}
local store = {
	blocks = {},
	hand = {},
	inventory = {},
	tools = {},
	noShoot = tick()
}
local ViewmodelTool
local ViewmodelMotor

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

local function getItem(check)
	for _, item in store.inventory do
		if item.Type == check then
			return item
		end
	end
end

local function getSword()
	local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		local swordDamage = item.Melee and item.Melee.Damage or 0
		if swordDamage > bestSwordDamage then
			bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
		end
	end
	return bestSword, bestSwordSlot
end

local function getPickaxe()
	local bestPick, bestPickSlot, bestPickDamage = nil, nil, math.huge
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		local pickDamage = item.Pickaxe and item.Pickaxe.TimeMultiplier or math.huge
		if pickDamage < bestPickDamage then
			bestPick, bestPickSlot, bestPickDamage = item, slot, pickDamage
		end
	end
	return bestPick, bestPickSlot
end

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

local function isTarget(plr)
	return table.find(vape.Categories.Targets.ListEnabled, plr.Name) and true
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function parsePositions(v, func)
	if v:IsA('Part') and v.Size // 1 == v.Size then
		local start = (v.Position - (v.Size / 2)) + Vector3.new(1.5, 1.5, 1.5)
		for x = 0, v.Size.X - 1, 3 do
			for y = 0, v.Size.Y - 1, 3 do
				for z = 0, v.Size.Z - 1, 3 do
					func(start + Vector3.new(x, y, z))
				end
			end
		end
	end
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
	entitylib.addPlayer = function(plr)
		if plr.Character then
			entitylib.refreshEntity(plr.Character, plr)
		end
		entitylib.PlayerConnections[plr] = {
			plr.CharacterAdded:Connect(function(char)
				entitylib.refreshEntity(char, plr)
			end),
			plr.CharacterRemoving:Connect(function(char)
				entitylib.removeEntity(char, plr == lplr)
			end),
			plr:GetAttributeChangedSignal('TeamId'):Connect(function()
				for i, v in entitylib.List do
					if v.Targetable ~= entitylib.targetCheck(v) then
						entitylib.refreshEntity(v.Character, v.Player)
					end
				end

				if plr == lplr then
					entitylib.start()
				else
					entitylib.refreshEntity(plr.Character, plr)
				end
			end)
		}
	end

	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = waitForChildOfType(char, 'Humanoid', 10)
			local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
			local head = char:WaitForChild('Head', 10) or humrootpart

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = (plr:GetAttribute('Health') or 100),
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
					MaxHealth = 100,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					TeamCheck = teamfunc
				}

				if plr == lplr then
					entity.GroundPosition = Vector3.zero
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
				else
					entity.Targetable = (teamfunc or entitylib.targetCheck)(entity)

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function()
							entity.Health = (plr:GetAttribute('Health') or 100)
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

	entitylib.getUpdateConnections = function(ent)
		return {
			ent.Player:GetAttributeChangedSignal('Health'),
			{
				Connect = function()
					ent.Friend = ent.Player and isFriend(ent.Player) or nil
					ent.Target = ent.Player and isTarget(ent.Player) or nil
					return {Disconnect = function() end}
				end
			}
		}
	end

	entitylib.targetCheck = function(ent)
		if ent.NPC then return true end
		if isFriend(ent.Player) then return false end
		if not select(2, whitelist:get(ent.Player)) then return false end
		return lplr:GetAttribute('TeamId') ~= ent.Player:GetAttribute('TeamId')
	end

	entitylib.getEntityColor = function(ent)
		ent = ent.Player
		if not (ent and vape.Categories.Main.Options['Use team color'].Enabled) then return end
		if isFriend(ent, true) then
			return Color3.fromHSV(vape.Categories.Friends.Options['Friends color'].Hue, vape.Categories.Friends.Options['Friends color'].Sat, vape.Categories.Friends.Options['Friends color'].Value)
		end
		return skywars.TeamController:getTeamColour(ent:GetAttribute('TeamId'))
	end
end)
entitylib.start()

run(function()
	local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
	local ControllerTable = {}

	if not debug.getupvalue(Flamework.ignite, 1) then
		repeat task.wait() until debug.getupvalue(Flamework.ignite, 1)
	end

	local function searchFunction(name, i2, v2)
		for i3, v3 in debug.getconstants(v2) do
			if tostring(v3):find('-') == 9 then
				remotes[(rawget(remotes, i2) and name..':' or '')..i2] = v3
			end
		end
	end

	for i, v in debug.getupvalue(Flamework.ignite, 2).idToObj do
		local name = tostring(v)
		ControllerTable[name] = Flamework.resolveDependency(i)
		for i2, v2 in v do
			if type(v2) == 'function' then
				searchFunction(name, i2, v2)

				for _, v3 in debug.getprotos(v2) do
					searchFunction(name, i2, v3)
				end
			end
		end
	end

	local roactCheck = replicatedStorage['rbxts_include']['node_modules']['@rbxts']:FindFirstChild('roact')
	skywars = setmetatable({
		CameraUtil = require(lplr.PlayerScripts.TS.util['camera-util']).CameraUtil,
		FireOrigin = debug.getupvalue(ControllerTable.ProjectileController.chargeBow, 11).ORIGIN_OFFSET,
		Gravity = debug.getupvalue(ControllerTable.ProjectileController.chargeBow, 13).WORLD_ACCELERATION.Y,
		ItemMeta = debug.getupvalue(ControllerTable.HotbarController.getSword, 1),
		Remotes = debug.getupvalue(ControllerTable.MeleeController.strikeDesktop, 6),
		Roact = require(roactCheck and roactCheck.src or replicatedStorage['rbxts_include']['node_modules']['@rbxts'].ReactLua['node_modules']['@jsdotlua']['roact-compat']),
		Store = require(lplr.PlayerScripts.TS.ui.rodux['global-store']).GlobalStore,
		Shop = require(replicatedStorage.TS.game.shop['game-shop']).Shops
	}, {
		__index = function(self, ind)
			rawset(self, ind, ControllerTable[ind])
			return rawget(self, ind)
		end
	})

	local kills = sessioninfo:AddItem('Kills')
	local eggs = sessioninfo:AddItem('Eggs')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	task.delay(1, function()
		games:Increment()
	end)

	local function updateStore(newStore, oldStore)
		if newStore.GameCurrency ~= oldStore.GameCurrency then
			vapeEvents.CurrencyChange:Fire(table.clone(newStore.GameCurrency.Quantities))
		end

		if newStore.ActiveSlot ~= oldStore.ActiveSlot then
			store.hand = newStore.Inventory.Contents[newStore.ActiveSlot]
			store.hand = store.hand and skywars.ItemMeta[store.hand.Type] or {}
		end

		if newStore.Inventory ~= oldStore.Inventory then
			store.inventory = newStore.Inventory.Contents
			store.hand = newStore.Inventory.Contents[newStore.ActiveSlot]
			store.hand = store.hand and skywars.ItemMeta[store.hand.Type] or {}
			store.tools.sword = getSword()
			store.tools.pickaxe = getPickaxe()
			vapeEvents.InventoryAmountChanged:Fire()
		end

		if oldStore.Profile and oldStore.Profile.WasTeleporting and newStore.Profile.Stats ~= oldStore.Profile.Stats then
			if newStore.Profile.Stats.Kills ~= oldStore.Profile.Stats.Kills and oldStore.Profile.Stats.Kills then
				kills:Increment()
			end

			if newStore.Profile.Stats.Wins ~= oldStore.Profile.Stats.Wins and oldStore.Profile.Stats.Wins then
				wins:Increment()
			end
		end
	end

	local storeChanged = skywars.Store.changed:connect(updateStore)
	updateStore(skywars.Store:getState(), {})

	task.spawn(function()
		repeat
			if entitylib.isAlive then
				entitylib.character.GroundPosition = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and entitylib.character.RootPart.Position or entitylib.character.GroundPosition
			end
			task.wait()
		until vape.Loaded == nil
	end)

	vape:Clean(workspace.BlockContainer.DescendantAdded:Connect(function(v)
		parsePositions(v, function(pos)
			store.blocks[pos] = v
		end)
	end))
	vape:Clean(workspace.BlockContainer.DescendantRemoving:Connect(function(v)
		parsePositions(v, function(pos)
			store.blocks[pos] = nil
		end)
	end))
	for _, v in workspace.BlockContainer:GetDescendants() do
		parsePositions(v, function(pos)
			store.blocks[pos] = v
		end)
	end

	vape:Clean(function()
		for _, v in vapeEvents do
			v:Destroy()
		end
		table.clear(ControllerTable)
		table.clear(RemoteTable)
		table.clear(vapeEvents)
		table.clear(skywars)
		table.clear(store.blocks)
		table.clear(store)
		storeChanged:disconnect()
		storeChanged = nil
	end)
end)

for _, v in {'Reach', 'TriggerBot', 'Disabler', 'SilentAim', 'AutoRejoin', 'Rejoin', 'ServerHop', 'MurderMystery'} do
	vape:Remove(v)
end
run(function()
	local AutoClicker
	local CPS
	local Blocks
	local BlocksCPS = {Object = {}}
	local Thread
	local old
	
	local function AutoClick()
		Thread = task.delay(1 / 8, function()
			repeat
				local held = store.hand
				if held then
					if held.Rewrite and Blocks.Enabled then
						local block = skywars.ItemMeta[held.Rewrite.Type:gsub('{TeamId}', skywars.TeamController:getPlayerTeamId(lplr) or 'White')]
						local ray = skywars.BlockRaycastController:executeRaycast(inputService:GetMouseLocation(), 1, 0, block)
						if ray and ray.BlockPosition then
							skywars.BlockController:placeBlock(ray.BlockPosition, held.Name, block, ray.Rotation)
						end
					elseif held.Melee then
						skywars.MeleeController:strike(held)
					end
				end
	
				task.wait(1 / (held and held.Rewrite and BlocksCPS or CPS).GetRandomValue())
			until not AutoClicker.Enabled
		end)
	end
	
	AutoClicker = vape.Categories.Combat:CreateModule({
		Name = 'AutoClicker',
		Function = function(callback)
			if callback then
				AutoClicker:Clean(inputService.InputBegan:Connect(function(input, gameProcessed)
					if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
						AutoClick()
					end
				end))
				AutoClicker:Clean(inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Thread then
						task.cancel(Thread)
						Thread = nil
					end
				end))
			end
		end,
		Tooltip = 'Hold attack button to automatically click'
	})
	CPS = AutoClicker:CreateTwoSlider({
		Name = 'CPS',
		Min = 1,
		Max = 9,
		DefaultMin = 9,
		DefaultMax = 9
	})
	Blocks = AutoClicker:CreateToggle({
		Name = 'Place Blocks',
		Default = true,
		Function = function(callback)
			BlocksCPS.Object.Visible = callback
		end
	})
	BlocksCPS = AutoClicker:CreateTwoSlider({
		Name = 'Block CPS',
		Min = 1,
		Max = 20,
		DefaultMin = 9,
		DefaultMax = 9,
		Darker = true
	})
end)
	
run(function()
	local Sprint
	local old
	
	Sprint = vape.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				old = skywars.SprintingController.disableSprinting
				skywars.SprintingController.disableSprinting = function(tab, ...)
					local originalCall = old(tab, ...)
					if not tab.canSprint then
						task.spawn(function()
							repeat task.wait(0.1) until tab.canSprint or not Sprint.Enabled
							if Sprint.Enabled then
								skywars.SprintingController:enableSprinting(tab)
							end
						end)
					else
						skywars.SprintingController:enableSprinting(tab)
					end
					return originalCall
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function()
					skywars.SprintingController:disableSprinting()
				end))
				skywars.SprintingController:disableSprinting()
			else
				skywars.SprintingController.disableSprinting = old
				skywars.SprintingController:disableSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)
	
run(function()
	local ChestSteal
	local Range
	local Open
	local Delay = {}
	
	ChestSteal = vape.Categories.World:CreateModule({
		Name = 'ChestSteal',
		Function = function(callback)
			if callback then
				local chests = collection('block:chest', ChestSteal)
				ChestSteal:Clean(skywars.Remotes[remotes['ChestController:onStart']]:connect(function(self, items)
					if Delay[self] then return end
	
					for _, item in items do
						skywars.Remotes[remotes.updateChest]:fire(self, item.Type, -item.Quantity)
					end
					skywars.Remotes[remotes.closeChest]:fire(self)
					Delay[self] = true
				end))
	
				repeat
					if entitylib.isAlive and not Open.Enabled then
						local localPosition = entitylib.character.RootPart.Position
						for i, v in chests do
							if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude <= Range.Value and not Delay[v] then
								skywars.Remotes[remotes.openChest]:fire(v)
							end
						end
					end
					task.wait(0.1)
				until not ChestSteal.Enabled
			end
		end,
		Tooltip = 'Grabs items from near chests.'
	})
	Range = ChestSteal:CreateSlider({
		Name = 'Range',
		Min = 0,
		Max = 10,
		Default = 10,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
	Open = ChestSteal:CreateToggle({Name = 'GUI Check'})
end)
	
run(function()
	local AutoBuy
	local Sword
	local Armor
	local Pickaxe
	local Upgrades
	local UpgradeObjects = {}
	local Functions = {}
	
	local function buyCheck(currencytable)
		for i, v in Functions do 
			v(currencytable) 
		end
	end
	
	local function buyUpgrade(name, upgrade, currencytable)
		local currentitem
		for shopIndex, shopItem in upgrade.Items do
			if shopItem.ItemType == name then 
				currentitem = shopIndex 
			end
		end
		if not currentitem then return end
	
		for i = currentitem + 1, #upgrade.Items do
			local nextitem = upgrade.Items[i]
			if nextitem and currencytable[nextitem.CurrencyType] >= nextitem.Price then
				skywars.Remotes[remotes.purchaseItemUpgrade]:fire('Blacksmith', upgrade.ItemIndex)
				currencytable[nextitem.CurrencyType] -= nextitem.Price
			end
		end
	end
	
	local function buyTeamUpgrade(upgrade, currencytable)
		local currentitem = skywars.Store:getState().TeamUpgrades[upgrade.Name] or 0
		for i = currentitem + 1, #upgrade.Tiers do
			local nextitem = upgrade.Tiers[i]
			if nextitem and currencytable[nextitem.CurrencyType] >= nextitem.Price then
				skywars.Remotes[remotes.purchaseTeamUpgrade]:fire('Merchant', upgrade.ItemIndex)
				currencytable[nextitem.CurrencyType] -= nextitem.Price
			end
		end
	end
	
	AutoBuy = vape.Categories.Inventory:CreateModule({
		Name = 'AutoBuy',
		Function = function(callback)
			if callback then
				AutoBuy:Clean(vapeEvents.CurrencyChange.Event:Connect(buyCheck))
				buyCheck(table.clone(skywars.Store:getState().GameCurrency.Quantities))
			end
		end,
		Tooltip = 'Automatically buys items when you go near the shop'
	})
	Sword = AutoBuy:CreateToggle({
		Name = 'Buy Sword',
		Function = function(callback)
			Functions[2] = callback and function(currencytable, shop, upgrades)
				buyUpgrade(store.tools.sword and store.tools.sword.Name, skywars.Shop.Blacksmith.ItemUpgrades[2], currencytable)
			end or nil
		end,
		Default = true
	})
	Armor = AutoBuy:CreateToggle({
		Name = 'Buy Armor',
		Function = function(callback)
			Functions[1] = callback and function(currencytable, shop, upgrades)
				if lplr.Character then
					for _, v in lplr.Character:GetChildren() do
						if v:GetAttribute('Armour') and v.Name:find('Chestplate') then
							buyUpgrade(v.Name, skywars.Shop.Blacksmith.ItemUpgrades[1], currencytable)
							break
						end
					end
				end
			end or nil
		end,
		Default = true
	})
	Pickaxe = AutoBuy:CreateToggle({
		Name = 'Buy Pickaxe',
		Function = function(callback)
			Functions[3] = callback and function(currencytable, shop, upgrades)
				buyUpgrade(store.tools.pickaxe and store.tools.pickaxe.Name, skywars.Shop.Blacksmith.ItemUpgrades[3], currencytable)
			end or nil
		end,
		Default = true
	})
	Upgrades = AutoBuy:CreateToggle({
		Name = 'Buy Upgrades',
		Function = function(callback)
			for i, v in UpgradeObjects do
				v.Object.Visible = callback
			end
		end,
		Default = true
	})
	for i, v in skywars.Shop.Merchant.TeamUpgrades do
		table.insert(UpgradeObjects, AutoBuy:CreateToggle({
			Name = 'Buy '..v.Name,
			Function = function(callback)
				Functions[4 + i] = callback and function(currencytable, shop, upgrades)
					buyTeamUpgrade(v, currencytable)
				end or nil
			end,
			Darker = true,
			Default = (v.Name == 'Generator' or v.Name == 'Vampyrism')
		}))
	end
end)
	
run(function()
	local AutoConsume
	
	local function consumeCheck()
		if (lplr:GetAttribute('Shield') or 0) <= 0 and getItem('Shield') then
			skywars.Remotes[remotes.updateActiveItem]:fire('Shield')
			skywars.Remotes[remotes.usePowerUp]:fire()
			skywars.Remotes[remotes.updateActiveItem]:fire(store.hand.Name)
		end
	end
	
	AutoConsume = vape.Categories.Inventory:CreateModule({
		Name = 'AutoConsume',
		Function = function(callback)
			if callback then
				AutoConsume:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(consumeCheck))
				AutoConsume:Clean(lplr:GetAttributeChangedSignal('Shield'):Connect(consumeCheck))
				consumeCheck()
			end
		end,
		Tooltip = 'Automatically uses shield potions.'
	})
end)
	
run(function()
	local Breaker
	local Range
	local BreakerPart
	local BreakerUI
	local BreakerRef = skywars.Roact.createRef()
	
	local function clean()
		if not BreakerUI then return end
		if BreakerPart then 
			BreakerPart:Destroy() 
		end
		skywars.Roact.unmount(BreakerUI)
		BreakerUI = nil
		BreakerPart = nil
	end
	
	local function customHealthbar(block, health, maxHealth, changeHealth)
		if not BreakerPart then
			local create = skywars.Roact.createElement
			local percent = math.clamp(health / maxHealth, 0, 1)
			local cleanCheck = true
			local part = Instance.new('Part')
			part.Size = Vector3.one
			part.CFrame = block.PrimaryPart.CFrame
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = workspace
			BreakerPart = part
	
			BreakerUI = skywars.Roact.mount(create('BillboardGui', {
				Size = UDim2.fromOffset(249, 102),
				StudsOffset = Vector3.new(0, 2.5, 0),
				Adornee = part,
				MaxDistance = 40,
				AlwaysOnTop = true
			}, {
				create('Frame', {
					Size = UDim2.fromOffset(160, 50),
					Position = UDim2.fromOffset(44, 32),
					BackgroundColor3 = Color3.new(),
					BackgroundTransparency = 0.5
				}, {
					create('UICorner', {CornerRadius = UDim.new(0, 5)}),
					create('ImageLabel', {
						Size = UDim2.new(1, 89, 1, 52),
						Position = UDim2.fromOffset(-48, -31),
						BackgroundTransparency = 1,
						Image = getcustomasset('skidv5/assets/new/blur.png'),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(52, 31, 261, 502)
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(13, 12),
						BackgroundTransparency = 1,
						Text = block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Color3.new(),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('TextLabel', {
						Size = UDim2.fromOffset(145, 14),
						Position = UDim2.fromOffset(12, 11),
						BackgroundTransparency = 1,
						Text = block.Name,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = color.Dark(uipallet.Text, 0.16),
						TextScaled = true,
						Font = Enum.Font.Arial
					}),
					create('Frame', {
						Size = UDim2.fromOffset(138, 4),
						Position = UDim2.fromOffset(12, 32),
						BackgroundColor3 = uipallet.Main
					}, {
						create('UICorner', {CornerRadius = UDim.new(1, 0)}),
						create('Frame', {
							[skywars.Roact.Ref] = BreakerRef,
							Size = UDim2.fromScale(percent, 1),
							BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
						}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
					})
				})
			}), part)
	
			task.delay(5, clean)
		end
	
		local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
		if newpercent == 0 then 
			clean() 
			return 
		end
		
		task.delay(0, function()
			local val = BreakerRef:getValue()
			if val then
				tweenService:Create(val, TweenInfo.new(0.3), {
					Size = UDim2.fromScale(newpercent, 1), 
					BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
				}):Play()
			end
		end)
	end
	
	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Breaker',
		Function = function(callback)
			if callback then
				local eggs = collection('egg', Breaker)
				local currentblock
				local oldblockhealth = 0
				
				repeat
					if entitylib.isAlive and store.hand then
						local localPosition = entitylib.character.RootPart.Position
						for i, v in eggs do
							if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude < Range.Value then
								local hp = v:GetAttribute('Health') or 0
								if v:GetAttribute('TeamId') == lplr:GetAttribute('TeamId') then continue end
								if currentblock ~= v then
									oldblockhealth = hp
									currentblock = v
								end
	
								if hp ~= oldblockhealth then
									customHealthbar(v, oldblockhealth, 100, oldblockhealth - hp)
									oldblockhealth = hp
								end
	
								store.noShoot = tick() + 1
								if hp <= 0 then continue end
								if store.hand.Melee then 
									skywars.Remotes[remotes['MeleeController:attemptStrikeDesktop']]:fire(v)
								elseif store.hand.Pickaxe then 
									skywars.Remotes[remotes.hitBlock]:fire((v.PrimaryPart.Position + Vector3.new(0, 1.5, 0)) // 1)
								end
							end
						end
					end
					
					task.wait(0.016)
				until not Breaker.Enabled
			end
		end,
		Tooltip = 'Automatically destroys eggs around you'
	})
	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 40,
		Default = 40,
		Suffix = function(val) 
			return val == 1 and 'stud' or 'studs' 
		end
	})
end)
	
run(function()
	local Viewmodel
	local oldtool
	
	local function newCharacter(char)
		Viewmodel:Clean(char.Character.ChildAdded:Connect(function(obj)
			if obj:IsA('Tool') then 
				oldtool = obj
				ViewmodelTool = oldtool.Handle:Clone()
				ViewmodelTool.CanCollide = false
				ViewmodelTool.Massless = true
				ViewmodelTool.Anchored = true
				ViewmodelTool:ClearAllChildren()
				ViewmodelTool.Parent = gameCamera
				ViewmodelTool.LocalTransparencyModifier = 0
				oldtool.Handle.LocalTransparencyModifier = 1
			end
		end))
		
		Viewmodel:Clean(char.Character.ChildRemoved:Connect(function(obj)
			if obj == oldtool then 
				ViewmodelTool:Destroy()
				ViewmodelTool = nil
				oldtool = nil
			end
		end))
	end
	
	Viewmodel = vape.Legit:CreateModule({
		Name = 'Viewmodel',
		Function = function(callback)
			if callback then 
				ViewmodelMotor = Instance.new('Motor6D')
				vape:Clean(ViewmodelMotor)
				vape:Clean(runService.RenderStepped:Connect(function()
					if ViewmodelTool then 
						local dcf = ((CFrame.new(2.06, -2.44, -2.24) * CFrame.new(0.6, -0.2, -0.6)) * CFrame.Angles(math.rad(99), math.rad(2), math.rad(-4))) * ViewmodelMotor.C0
						local offsetcf = (CFrame.new(0, -0.15, -1.56) * CFrame.Angles(math.rad(-90), math.rad(-90), 0))
						ViewmodelTool.CFrame = ((gameCamera.CFrame * dcf) * offsetcf)
					end
				end))
				vape:Clean(entitylib.Events.LocalAdded:Connect(newCharacter))
				if entitylib.isAlive then 
					newCharacter(entitylib.character) 
				end
			else
				if ViewmodelTool then 
					ViewmodelTool:Destroy() 
				end
			end
		end,
		Tooltip = 'Replaces the default viewmodel'
	})
end)
	

local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local collectionService = cloneref(game:GetService('CollectionService'))
local runService = cloneref(game:GetService('RunService'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local prediction = vape.Libraries.prediction

local bd = {}
local store = {
	blocks = {},
	serverBlocks = {}
}

local function getTool()
	return lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool', true) or nil
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function parsePositions(v, func)
	if v:IsA('Part') then
		local start = -(v.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		for x = 0, v.Size.X - 1, 3 do
			for y = 0, v.Size.Y - 1, 3 do
				for z = 0, v.Size.Z - 1, 3 do
					local vec = start + Vector3.new(x, y, z)
					vec = v.CFrame:PointToWorldSpace(vec)
					vec = Vector3.new(math.round(vec.X), math.round(vec.Y), math.round(vec.Z))
					func(vec)
				end
			end
		end
	end
end

run(function()
	local Knit = require(replicatedStorage.Modules.Knit.Client)
	if not debug.getupvalue(Knit.Start, 1) then
		repeat task.wait() until debug.getupvalue(Knit.Start, 1)
	end

	bd = setmetatable({
		BedwarsShop = require(replicatedStorage.Constants.BedWarsShop),
		BedwarsUpgrades = require(replicatedStorage.Constants.BedWarsTeamUpgrades),
		Blink = require(replicatedStorage.Blink.Client),
		BreakTimes = require(replicatedStorage.Constants.Blocks),
		BowClient = require(replicatedStorage.Client.Components.All.Tools.BowClient),
		CombatConstants = require(replicatedStorage.Constants.Melee),
		Communication = require(replicatedStorage.Client.Communication),
		Knit = Knit,
		Entity = require(replicatedStorage.Modules.Entity),
		ServerData = require(replicatedStorage.Modules.ServerData),
	}, {
		__index = function(self, ind)
			rawset(self, ind, ind:find('Service') and Knit.GetService(ind) or Knit.GetController(ind))
			return rawget(self, ind)
		end
	})

	task.spawn(function()
		local map = workspace:WaitForChild('Map', 99999)
		if map and vape.Loaded ~= nil then
			vape:Clean(map.DescendantAdded:Connect(function(v)
				parsePositions(v, function(pos)
					store.blocks[pos] = v
				end)
			end))
			vape:Clean(map.DescendantRemoving:Connect(function(v)
				parsePositions(v, function(pos)
					if store.blocks[pos] == v then
						store.blocks[pos] = nil
						store.serverBlocks[pos] = nil
					end
				end)
			end))
			for _, v in map:GetDescendants() do
				parsePositions(v, function(pos)
					store.blocks[pos] = v
					store.serverBlocks[pos] = v
				end)
			end
		end
	end)

	vape:Clean(function()
		table.clear(store.blocks)
		table.clear(store)
	end)
end)

for _, v in {'Reach', 'SilentAim', 'Disabler', 'HitBoxes', 'MurderMystery', 'AutoRejoin'} do
	vape:Remove(v)
end
run(function()
	local AutoClicker
	local CPS
	
	AutoClicker = vape.Categories.Combat:CreateModule({
		Name = 'AutoClicker',
		Function = function(callback)
			if callback then
				repeat
					local tool = getTool()
					if tool and inputService:IsMouseButtonPressed(0) then
						tool:Activate()
					end
					task.wait(1 / CPS.GetRandomValue())
				until not AutoClicker.Enabled
			end
		end,
		Tooltip = 'Automatically clicks for you'
	})
	CPS = AutoClicker:CreateTwoSlider({
		Name = 'CPS',
		Min = 1,
		Max = 20,
		DefaultMin = 8,
		DefaultMax = 12
	})
end)
	
run(function()
	local AutoPlay
	local Delay
	
	AutoPlay = vape.Categories.Utility:CreateModule({
		Name = 'AutoPlay',
		Function = function(callback)
			if callback then
				AutoPlay:Clean(bd.Blink.game_state.team_won.on(function()
					if bd.ServerData.Submode ~= 'Playground' then
						bd.MatchController:EnterQueue(bd.ServerData.Submode)
					end
				end))
			end
		end,
		Tooltip = 'Automatically queues after the match ends.'
	})
end)
	
run(function()
	local AutoBuy
	local Sword
	local Armor
	local Upgrades
	local NPCs = {}
	local UpgradeToggles = {}
	local Functions = {}
	local Callbacks = {Functions}
	local npctick = tick()
	
	local function canBuy(item, currencytable, amount)
		return (currencytable[item.currency or 'Iron'] or 0) >= (item.cost * (amount or 1))
	end
	
	local function buyItem(item, itemTier, itemCategory, currencytable)
		notif('AutoBuy', 'Bought '..item.name, 3)
		task.spawn(function()
			bd.Blink.player_state.bedwars_buy_item.invoke({
				item = itemCategory or item.name,
				tier = itemTier
			})
		end)
		currencytable[item.currency or 'Iron'] -= item.cost
	end
	
	local function buyTier(category, currencytable)
		local nextItem, itemTier
		for i, v in category.tiers do
			if currencytable[v.name] then
				nextItem, nextTier = category.tiers[i + 1], i + 1
				break
			end
		end
	
		if nextItem and canBuy(nextItem, currencytable) then
			buyItem(nextItem, nextTier, category.name, currencytable)
		end
	end
	
	local function buyUpgrade(upgrade, currencytable)
		local upgradeItem = bd.BedwarsUpgrades[upgrade]
		local localTeam = bd.Entity.LocalEntity.Team or {Name = ''}
		local teamUpgrades = bd.Communication.team_upgrades.value[localTeam.Name] or {}
		local currentTier = (teamUpgrades[upgrade] or 0) + 1
		local bought = false
	
		for i = currentTier, #upgradeItem.tiers do
			local tier = upgradeItem.tiers[i]
	
			if canBuy({currency = 'Diamond', cost = tier.cost}, currencytable) then
				notif('AutoBuy', 'Bought '..upgrade..' '..i, 3)
				task.spawn(function()
					bd.Blink.player_state.bedwars_buy_upgrade.invoke(upgrade)
				end)
				currencytable.Diamond -= tier.cost
				bought = true
			else
				break
			end
		end
	
		return bought
	end
	
	local function getShopNPC()
		local shop, items, upgrades, newid = nil, false, false, nil
		if entitylib.isAlive then
			local localPosition = entitylib.character.RootPart.Position
			for ent, upgrade in NPCs do
				if (ent.Position - localPosition).Magnitude <= 10 then
					shop = true
					items = items or not upgrade
					upgrades = upgrade or upgrades
				end
			end
		end
		return shop, items, upgrades
	end
	
	AutoBuy = vape.Categories.Inventory:CreateModule({
		Name = 'AutoBuy',
		Function = function(callback)
			if callback then
				AutoBuy:Clean(collectionService:GetInstanceAddedSignal('menu_opener'):Connect(function(obj)
					NPCs[obj.Parent] = obj:GetAttribute('menu') == 'TeamUpgrades'
				end))
	
				for _, obj in collectionService:GetTagged('menu_opener') do
					NPCs[obj.Parent] = obj:GetAttribute('menu') == 'TeamUpgrades'
				end
	
				repeat
					local npc, shop, upgrades, newid = getShopNPC()
	
					if npc and npctick <= tick() then
						local currencytable = table.clone(bd.Entity.LocalEntity.Inventory)
						for _, tab in Callbacks do
							for _, callback in tab do
								callback(currencytable, shop, upgrades)
							end
						end
						npctick = tick() + 0.4
					end
	
					task.wait(0.1)
				until not AutoBuy.Enabled
			else
				table.clear(NPCs)
			end
		end,
		Tooltip = 'Automatically buys items when you go near the shop'
	})
	Sword = AutoBuy:CreateToggle({
		Name = 'Buy Sword',
		Function = function(callback)
			npctick = tick()
			Functions[2] = callback and function(currencytable, shop)
				if not shop then return end
				buyTier(bd.BedwarsShop[2].items[1], currencytable)
			end or nil
		end,
		Default = true
	})
	Armor = AutoBuy:CreateToggle({
		Name = 'Buy Armor',
		Function = function(callback)
			npctick = tick()
			Functions[1] = callback and function(currencytable, shop)
				if not shop then return end
				buyTier(bd.BedwarsShop[2].items[2], currencytable)
			end or nil
		end,
		Default = true
	})
	Pickaxe = AutoBuy:CreateToggle({
		Name = 'Buy Pickaxe',
		Function = function(callback)
			npctick = tick()
			Functions[1] = callback and function(currencytable, shop)
				if not shop then return end
				buyTier(bd.BedwarsShop[3].items[1], currencytable)
			end or nil
		end
	})
	Upgrades = AutoBuy:CreateToggle({
		Name = 'Buy Upgrades',
		Function = function(callback)
			for _, v in UpgradeToggles do
				v.Object.Visible = callback
			end
		end,
		Default = true
	})
	local count = 0
	for i, v in bd.BedwarsUpgrades do
		local toggleCount = count
		table.insert(UpgradeToggles, AutoBuy:CreateToggle({
			Name = 'Buy '..i,
			Function = function(callback)
				npctick = tick()
				Functions[5 + toggleCount + (i == 'ArmorProtection' and 20 or 0)] = callback and function(currencytable, shop, upgrades)
					if not upgrades then return end
					return buyUpgrade(i, currencytable)
				end or nil
			end,
			Darker = true,
			Default = (i == 'ArmorProtection' or i == 'SwordDamage')
		}))
		count += 1
	end
	--[[for i, v in bedwars.TeamUpgradeMeta do
		local toggleCount = count
		table.insert(UpgradeToggles, AutoBuy:CreateToggle({
			Name = 'Buy '..(v.name == 'Armor' and 'Protection' or v.name),
			Function = function(callback)
				npctick = tick()
				Functions[5 + toggleCount + (v.name == 'Armor' and 20 or 0)] = callback and function(currencytable, shop, upgrades)
					if not upgrades then return end
					if v.disabledInQueue and table.find(v.disabledInQueue, store.queueType) then return end
					return buyUpgrade(i, currencytable)
				end or nil
			end,
			Darker = true,
			Default = (i == 'ARMOR' or i == 'DAMAGE')
		}))
		count += 1
	end]]
end)
	
run(function()
	local Breaker
	local Value
	local OnlyPlayer
	
	local function getBlocksInPoints(s, e)
		local list = {}
		for x = s.X, e.X, 3 do
			for y = s.Y, e.Y, 3 do
				for z = s.Z, e.Z, 3 do
					local vec = Vector3.new(x, y, z)
					if store.blocks[vec] then
						list[vec] = store.blocks[vec]
					end
				end
			end
		end
		return list
	end
	
	local function getPickaxe()
		for name in bd.Entity.LocalEntity.Inventory do
			if name:find('Pickaxe') then
				return name
			end
		end
	end
	
	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Breaker',
		Function = function(callback)
			if callback then
				local breakBlock
				local breakTime = 0
				local lastBreak
	
				repeat
					breakBlock = nil
	
					if entitylib.isAlive then
						local pickaxe = getPickaxe()
	
						if pickaxe then
							local pos = (entitylib.character.RootPart.Position // 3) * 3
							local rvec = Vector3.new(3, 3, 3) * Range.Value
	
							for blockpos, block in getBlocksInPoints(pos - rvec, pos + rvec) do
								if block and block.Name == 'Block' and (block.Parent.Name == 'Bed' and lplr.Team and block.Parent:GetAttribute('Team') ~= lplr.Team.Name) then
									breakBlock = block
									break
								end
							end
	
							if breakBlock ~= lastBreak then
								if breakBlock then
									breakTime = os.clock() + bd.BreakTimes[breakBlock:GetAttribute('block_type') or 'Clay']
									bd.Blink.item_action.start_break_block.fire({
										position = breakBlock.Position,
										pickaxe_name = pickaxe,
										timestamp = workspace:GetServerTimeNow()
									})
								else
									bd.Blink.item_action.stop_break_block.fire(false)
								end
								lastBreak = breakBlock
							elseif breakBlock and breakTime < os.clock() then
								bd.Blink.item_action.stop_break_block.fire(true)
								breakTime = math.huge
							end
						end
					end
					task.wait(1 / 60)
				until not Breaker.Enabled
			end
		end,
		Tooltip = 'Breaks enemy blocks around you'
	})
	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 5,
		Default = 5,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)
	

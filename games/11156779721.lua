local run = function(func) 
	func() 
end
local cloneref = cloneref or function(obj) 
	return obj 
end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local tweenService = cloneref(game:GetService('TweenService'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local prediction = vape.Libraries.prediction
local color = vape.Libraries.color
local uipallet = vape.Libraries.uipallet
local getcustomasset = vape.Libraries.getcustomasset

local clientData = require(replicatedStorage.modules.player.ClientData)
local aiController = require(lplr.PlayerScripts.AIController)
local projectiles = require(replicatedStorage.modules.game.Projectiles).Projectile
local itemData = {}
for _, v in debug.getupvalue(require(replicatedStorage.game.Items).getItemData, 1) do 
	itemData[v.id] = v 
end
local Crypt = require(replicatedStorage.Crypt)

local top = replicatedStorage:WaitForChild('Water'):WaitForChild('top')
local topY = top.Position.Y + top.Size.Y / 2
--local anticheatloop = getconnections(main.Marco.OnClientEvent)[1].Function

local function getSpeed()
	local factor = 3.25
	local realSpeed = math.max(clientData.getSpeedFactor(), 0.8)
	if entitylib.isAlive and entitylib.character.RootPart.Position.Y < (topY - 1) and realSpeed >= 1 then 
		factor += 1
	end
	return 16 * (realSpeed * factor)
end	

local function getTool(breakType)
	local bestTool, bestToolData, bestToolDamage = nil, nil, 0
	for slot, item in clientData.getHotbar() do
		if item == -1 then continue end
		local toolMeta = itemData[item]
		if toolMeta.itemStats then
			local toolDamage = toolMeta.itemStats[breakType] or 0
			if toolDamage > bestToolDamage then
				bestTool, bestToolData, bestToolDamage = slot, toolMeta, toolDamage
			end
		end
	end
	return bestTool, bestToolData
end

run(function()
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

	local oldstart = entitylib.start
	entitylib.start = function()
		oldstart()
		if entitylib.Running then
			for _, ent in workspace.AI_Client:GetChildren() do 
				task.spawn(entitylib.addEntity, ent) 
			end
			table.insert(entitylib.Connections, workspace.AI_Client.ChildAdded:Connect(function(v) 
				entitylib.addEntity(v) 
			end))
			table.insert(entitylib.Connections, workspace.AI_Client.ChildRemoved:Connect(function(v) 
				entitylib.removeEntity(v) 
			end))
		end
	end

	entitylib.addEntity = function(char, plr, teamfunc)
		if not char then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = plr and waitForChildOfType(char, 'Humanoid', 10) or {
				RootPart = char.PrimaryPart,
				HipHeight = char:GetAttribute('HipHeight') or 2,
				Health = 100,
				MaxHealth = 100,
				GetPropertyChangedSignal = function() end
			}
			local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
			local head = char:WaitForChild('Head', 10) or humrootpart and {Name = 'Head', Size = Vector3.one, Parent = char}

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = hum.Health,
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
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

					for i, v in entitylib.getUpdateConnections(entity) do
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
end)
entitylib.start()


	
local Attacking

	

	

	
run(function()
	local AutoEat
	local Health
	local eatRemote = replicatedStorage.remoteInterface.interactions.eat
	local maxHunger = replicatedStorage.game.maxHunger.Value
	local regenTick = tick()
	
	local function getEatenItem()
		local inv, hunger = clientData.getInventory(lplr), clientData.getHunger()
		if inv and entitylib.isAlive then
			local chosen, lowest = nil, math.huge
	
			for i, v in inv do
				v = itemData[i]
				local food = v and v.itemStats and v.itemStats.food
				if food and (v.instantHealth or 1) > 0 then
					local healthCheck = entitylib.character.Humanoid.Health < entitylib.character.Humanoid.MaxHealth and Health.Enabled
					if ((hunger + food) < maxHunger or healthCheck) and food < lowest and not table.find(v.effectsOnEat or {}, "Food_Poisoning") then
						chosen, lowest = i, food
					end
	
					if entitylib.character.Humanoid.Health < entitylib.character.Humanoid.MaxHealth and Health.Enabled then
						if (v.instantHealth or v.durationHealth) and regenTick < tick() then
							if v.durationHealth then 
								regenTick = tick() + (v.durationHealth / v.durationHealthRate) 
							end
							chosen = i
							break
						end
					end
				end
			end
	
			return chosen
		end
	end
	
	AutoEat = vape.Categories.Utility:CreateModule({
		Name = 'AutoEat',
		Function = function(callback)
			if callback then
				repeat
					local item = getEatenItem()
					if item then 
						eatRemote:FireServer(item) 
					end
					task.wait(0.1)
				until not AutoEat.Enabled
			end
		end,
		Tooltip = 'Automatically eats healing items'
	})
	Health = AutoEat:CreateToggle({
		Name = 'Eat Healing Items',
		Default = true
	})
end)
	
run(function()
	local AutoPickup
	local dropped = workspace.droppedItems
	local pickupRemote =  replicatedStorage.remoteInterface.inventory.pickupItem
	local pickuptable = {}
	local pickupdelay = {}
	
	AutoPickup = vape.Categories.Utility:CreateModule({
		Name = 'AutoPickup',
		Function = function(callback)
			if callback then 
				AutoPickup:Clean(dropped.ChildAdded:Connect(function(v) 
					table.insert(pickuptable, v) 
				end))
				AutoPickup:Clean(dropped.ChildRemoved:Connect(function(v)
					local ind = table.find(pickuptable, v)
					if ind then 
						table.remove(pickuptable, ind) 
					end
				end))
				pickuptable = dropped:GetChildren()
				
				repeat
					if entitylib.isAlive then 
						for i, v in pickuptable do 
							if (v.Position - entitylib.character.RootPart.Position).Magnitude < 10 then 
								firetouchinterest(v, entitylib.character.RootPart, 1)
								firetouchinterest(v, entitylib.character.RootPart, 0)
							end
						end
					end
					task.wait(0.03)
				until not AutoPickup.Enabled
			else
				table.clear(pickuptable)
			end
		end,
		Tooltip = 'Picks up items within close range'
	})
end)
	
run(function()
	local Breaker
	local BreakerDisable
	local BreakerPart
	local BreakerUI
	local BreakerRef
	local BreakerObjects = {}
	local mine = replicatedStorage.remoteInterface.interactions.mine
	local chop = replicatedStorage.remoteInterface.interactions.chop
	local old
	
	local function clean()
		if not BreakerUI then return end
		if BreakerPart then 
			BreakerPart:Destroy() 
		end
		BreakerUI = nil
		BreakerPart = nil
		BreakerRef = nil
	end
	
	local function customHealthbar(block, health, maxHealth, changeHealth)
		if not BreakerPart then
			local percent = math.clamp(health / maxHealth, 0, 1)
			local part = Instance.new('Part')
			part.Size = Vector3.one
			part.CFrame = block.PrimaryPart.CFrame
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = workspace
			BreakerPart = part
			local billboard = Instance.new('BillboardGui')
			billboard.Size = UDim2.fromOffset(249, 102)
			billboard.StudsOffset = Vector3.new(0, 2.5, 0)
			billboard.Adornee = part
			billboard.MaxDistance = 100
			billboard.AlwaysOnTop = true
			billboard.Parent = part
			BreakerUI = billboard
			local holder = Instance.new('Frame')
			holder.Size = UDim2.fromOffset(160, 50)
			holder.Position = UDim2.fromOffset(44, 32)
			holder.BackgroundColor3 = Color3.new()
			holder.BackgroundTransparency = 0.5
			holder.Parent = billboard
			local corner = Instance.new('UICorner')
			corner.CornerRadius = UDim.new(0, 5)
			corner.Parent = holder
			local blur = Instance.new('ImageLabel')
			blur.Size = UDim2.new(1, 89, 1, 52)
			blur.Position = UDim2.fromOffset(-48, -31)
			blur.BackgroundTransparency = 1
			blur.Image = getcustomasset('skidv5/assets/new/blur.png')
			blur.ScaleType = Enum.ScaleType.Slice
			blur.SliceCenter = Rect.new(52, 31, 261, 502)
			blur.Parent = holder
			local shadow = Instance.new('TextLabel')
			shadow.Size = UDim2.fromOffset(145, 14)
			shadow.Position = UDim2.fromOffset(13, 12)
			shadow.BackgroundTransparency = 1
			shadow.Text = block.Name
			shadow.TextXAlignment = Enum.TextXAlignment.Left
			shadow.TextYAlignment = Enum.TextYAlignment.Top
			shadow.TextColor3 = Color3.new()
			shadow.TextScaled = true
			shadow.Font = Enum.Font.Arial
			shadow.Parent = holder
			local shadow = Instance.new('TextLabel')
			shadow.Size = UDim2.fromOffset(145, 14)
			shadow.Position = UDim2.fromOffset(12, 11)
			shadow.BackgroundTransparency = 1
			shadow.Text = block.Name
			shadow.TextXAlignment = Enum.TextXAlignment.Left
			shadow.TextYAlignment = Enum.TextYAlignment.Top
			shadow.TextColor3 = color.Dark(uipallet.Text, 0.16)
			shadow.TextScaled = true
			shadow.Font = Enum.Font.Arial
			shadow.Parent = holder
			local barholder = Instance.new('Frame')
			barholder.Size = UDim2.fromOffset(138, 4)
			barholder.Position = UDim2.fromOffset(12, 32)
			barholder.BackgroundColor3 = uipallet.Main
			barholder.Parent = holder
			local barcorner = Instance.new('UICorner')
			barcorner.CornerRadius = UDim.new(1, 0)
			barcorner.Parent = barholder
			local healthbar = Instance.new('Frame')
			healthbar.Size = UDim2.fromScale(percent, 1)
			healthbar.BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
			healthbar.Parent = barholder
			BreakerRef = healthbar
			local healthcorner = Instance.new('UICorner')
			healthcorner.CornerRadius = UDim.new(1, 0)
			healthcorner.Parent = healthbar
		end
	
		local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
		if newpercent == 0 then 
			clean() 
			return 
		end
		
		tweenService:Create(BreakerRef, TweenInfo.new(0.3), {
			Size = UDim2.fromScale(newpercent, 1),
			BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
		}):Play()
	end
	
	local function getBreakable()
		if entitylib.isAlive and (BreakerDisable.Enabled or not Attacking) then
			local closest, hp = nil, math.huge
			local localPosition = entitylib.character.RootPart.Position
	
			for _, v in BreakerObjects do
				if v:GetAttribute('health') > 0 and v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude < 30 then
					local newhp = v:GetAttribute('health')
					if newhp <= hp then closest, hp = v, newhp end
				elseif v == old then
					clean()
				end
			end
	
			return closest
		end
	end
	
	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Breaker',
		Function = function(callback)
			if callback then
				local oldhp = -1
	
				for _, obj in workspace.worldResources:GetDescendants() do
					if obj:GetAttribute('health') then 
						table.insert(BreakerObjects, obj) 
					end
				end
				Breaker:Clean(workspace.worldResources.DescendantAdded:Connect(function(obj)
					if obj:GetAttribute('health') then 
						table.insert(BreakerObjects, obj) 
					end
				end))
				Breaker:Clean(workspace.worldResources.DescendantRemoving:Connect(function(obj)
					local ind = table.find(BreakerObjects, obj)
					if ind then 
						table.remove(BreakerObjects, ind) 
					end
				end))
	
				repeat
					local obj = getBreakable()
					if obj then
						local axe, pickaxe = getTool('axeStrength'), getTool('pickaxeStrength')
						local done
						if obj:IsDescendantOf(workspace.worldResources.mineable) then 
							if pickaxe then
								done = true
								mine:FireServer(pickaxe, obj, obj.PrimaryPart.CFrame)
							end
						else
							if axe then
								done = true
								chop:FireServer(axe, obj, obj.PrimaryPart.CFrame)
							end
						end
	
						if done and (obj:GetAttribute('health') ~= oldhealth or obj ~= old) then
							if obj ~= old then
								oldhealth = obj:GetAttribute('health')
								clean()
							end
							customHealthbar(obj, oldhealth, obj:GetAttribute('maxHealth'), oldhealth - obj:GetAttribute('health'))
							oldhealth = obj:GetAttribute('health')
							old = obj
						end
					end
	
					task.wait(0.1)
				until not Breaker.Enabled
			else
				table.clear(BreakerObjects)
				clean()
			end
		end,
		Tooltip = 'Break resources around you automatically'
	})
	BreakerDisable = Breaker:CreateToggle({
		Name = 'Break while attacking',
		Default = true
	})
end)
	
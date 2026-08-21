local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local prediction = vape.Libraries.prediction

local ad = {}

run(function()
	local function searchForScripts(map)
		local scripts = {}
		local constants = {}

		for _, v in replicatedStorage:GetDescendants() do
			if v:IsA('ModuleScript') then
				pcall(function()
					constants[v] = debug.getconstants(getscriptclosure(v))
				end)
			end
		end

		for name, entry in map do
			for scr, list in constants do
				local found = 0

				for _, v in list do
					for _, comp in entry do
						if comp == v then
							found += 1
							break
						end
					end
				end

				if found == #entry then
					scripts[name] = scr
				end
			end
		end

		for name in map do
			if not scripts[name] then
				vape:CreateNotification('Vape', 'Unable to find script: '..name, 10, 'alert')
				return false
			end
		end

		return scripts
	end

	if starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) then
		repeat task.wait() until not starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) or vape.Loaded == nil
		if vape.Loaded == nil then return end
	end

	for _, v in getconnections(game:GetService('LogService').MessageOut) do
		if v.Function then
			v:Disable()
		end
	end

	local scripts = searchForScripts({
		BulletHandler = {'BulletUpdate', 'HitEffects'},
		CharacterController = {'BloodVignette', 'HealthBar'},
		CharacterReplicatorManager = {'CharacterReplicatorAngleUpdate'},
		Network = {'CreateRemoteEvent', 'CreateRemoteFunction', 'OnInvoke', 'ExceptPlayer', 'AllPlayers'},
		Memory = {'LocalPlayerMemory', 'GlobalPlayerMemory'}
	})

	ad = {
		CharacterController = require(scripts.CharacterController),
		Network = require(scripts.Network),
		Memory = require(scripts.Memory).GetLocalMemory(),
		ReplicationPlayers = debug.getupvalue(require(scripts.CharacterReplicatorManager).GetReplicator, 1),
		FireBullet = require(scripts.BulletHandler)
	}
end)
if vape.Loaded == nil then return end

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

	entitylib.addEntity = function(char, plr, obj)
		if not char or not obj then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = {
				Health = 100,
				MaxHealth = 100,
				HipHeight = 0,
				RigType = Enum.HumanoidRigType.R6,
				GetState = function()
					return Enum.HumanoidStateType.Running
				end,
				ChangeState = function() end,
				GetPropertyChangedSignal = function()
					return {
						Connect = function()
							return {Disconnect = function() end}
						end
					}
				end,
				MoveDirection = Vector3.zero
			}
			local humrootpart = char:WaitForChild('HumanoidRootPart', 10)
			local head = char:WaitForChild('Head', 10) or humrootpart

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = char:GetAttribute('Health') or 100,
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					HipHeight = 2,
					MaxHealth = char:GetAttribute('MaxHealth') or 0,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					Object = obj,
					SpawnTime = tick() + 2
				}

				if plr == lplr then
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
				else
					entity.Targetable = entitylib.targetCheck(entity)

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function() end))
					end

					table.insert(entity.Connections, char:GetAttributeChangedSignal('Health'):Connect(function()
						entity.Health = char:GetAttribute('Health') or 100
						entity.MaxHealth = char:GetAttribute('MaxHealth') or 0
						entitylib.Events.EntityUpdated:Fire(entity)
					end))

					table.insert(entity.Connections, obj.Destroying:Connect(function()
						entitylib.removeEntity(char, plr == lplr)
					end))

					table.insert(entitylib.List, entity)
					entitylib.Events.EntityAdded:Fire(entity)
				end
			end
			entitylib.EntityThreads[char] = nil
		end)
	end

	entitylib.isVulnerable = function(ent)
		return ent.Health > 0 and not ent.Character:HasTag('Protected')
	end

	entitylib.refreshEntity = function(char, plr)
		entitylib.removeEntity(char)
		local ent = ad.ReplicationPlayers[plr]
		if ent then
			entitylib.addEntity(ent.Character, plr, ent)
		end
	end

	entitylib.start = function()
		if entitylib.Running then
			entitylib.stop()
		end

		table.insert(entitylib.Connections, ad.Network:Connect('PlayerSpawned', function(plr)
			task.defer(function()
				local ent = ad.ReplicationPlayers[plr]
				if ent then
					entitylib.addEntity(ent.Character, ent.Player, ent)
				end
			end)
		end))
		for _, ent in ad.ReplicationPlayers do
			entitylib.addEntity(ent.Character, ent.Player, ent)
		end

		table.insert(entitylib.Connections, ad.Memory:GetMemoryChangedSignal('Character'):Connect(function()
			task.defer(function()
				if ad.Memory.Character then
					entitylib.addEntity(ad.Memory.Character, lplr, ad.Memory)
				else
					entitylib.removeEntity(ad.Memory.Character, lplr)
				end
			end)
		end))
		if ad.Memory.Character then
			entitylib.addEntity(ad.Memory.Character, lplr, ad.Memory)
		end

		entitylib.Running = true
	end
end)
entitylib.start()

for _, v in {'TriggerBot', 'Invisible', 'Swim', 'TargetStrafe', 'AntiRagdoll', 'Freecam', 'Parkour', 'SafeWalk', 'AntiFall', 'HitBoxes', 'Killaura', 'MurderMystery', 'AnimationPlayer', 'Blink', 'Disabler'} do
	vape:Remove(v)
end

local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

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
local bt = {}

local function notif(...)
	return vape:CreateNotification(...)
end

run(function()
	bt = {
		Ambassador = require(replicatedFirst.Ambassador),
		BattleClient = getsenv(lplr.PlayerScripts.Battle.BattleClient),
		Enemy = require(replicatedFirst.Classes.Entities.Enemy),
		Network = require(replicatedFirst.Network),
		Shucky = require(replicatedFirst.Modules.Shucky),
		Variables = require(replicatedFirst.Variables)
	}

	vape:Clean(function()
		table.clear(bt)
	end)
end)

for _, v in {'AimAssist', 'Reach', 'SilentAim', 'TriggerBot', 'AntiFall', 'HitBoxes', 'Invisible', 'Jesus', 'Killaura', 'TargetStrafe', 'AntiRagdoll', 'Disabler', 'MurderMystery', 'Freecam', 'ChatSpammer', 'SpinBot'} do
	vape:Remove(v)
end

run(function()
	local PickupTracers
	local Color
	local Transparency
	local Bux
	local Reference = {}
	
	local function Added(ent)
		if vape.ThreadFix then
			setthreadidentity(8)
		end
	
		if Bux.Enabled and ent.Name ~= 'BUX' then
			return
		end
	
		local EntityTracer = Drawing.new('Line')
		EntityTracer.Thickness = 1
		EntityTracer.Transparency = 1 - Transparency.Value
		EntityTracer.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
		Reference[ent] = EntityTracer
	end
	
	local function Removed(ent)
		local v = Reference[ent]
		if v then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
	
			Reference[ent] = nil
			pcall(function()
				v.Visible = false
				v:Remove()
			end)
		end
	end
	
	local function ColorFunc(hue, sat, val)
		local tracerColor = Color3.fromHSV(hue, sat, val)
		for ent, EntityTracer in Reference do
			EntityTracer.Color = tracerColor
		end
	end
	
	local function Loop()
		local screenSize = vape.gui.AbsoluteSize
		local startVector = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
	
		for ent, EntityTracer in Reference do
			if ent:GetAttribute('Inactive') then
				EntityTracer.Visible = false
				continue
			end
	
			local pos = ent.Position
			local rootPos, rootVis = gameCamera:WorldToViewportPoint(pos)
	
			if not rootVis then
				local tempPos = gameCamera.CFrame:PointToObjectSpace(pos)
				tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):VectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):VectorToWorldSpace(Vector3.new(0, 0, -1))))
				rootPos = gameCamera:WorldToViewportPoint(gameCamera.CFrame:pointToWorldSpace(tempPos))
				rootVis = true
			end
	
			local endVector = Vector2.new(rootPos.X, rootPos.Y)
			EntityTracer.Visible = rootVis
			EntityTracer.From = startVector
			EntityTracer.To = endVector
		end
	end
	
	PickupTracers = vape.Categories.Render:CreateModule({
		Name = 'PickupTracers',
		Function = function(callback)
			if callback then
				PickupTracers:Clean(collectionService:GetInstanceAddedSignal('Pickup'):Connect(function(ent)
					if Reference[ent] then
						Removed(ent)
					end
					Added(ent)
				end))
				PickupTracers:Clean(collectionService:GetInstanceRemovedSignal('Pickup'):Connect(Removed))
				for _, v in collectionService:GetTagged('Pickup') do
					if Reference[v] then
						Removed(v)
					end
					Added(v)
				end
				PickupTracers:Clean(runService.RenderStepped:Connect(Loop))
			else
				for i in Reference do
					Removed(i)
				end
			end
		end,
		Tooltip = 'Renders tracers on pickups.'
	})
	Color = PickupTracers:CreateColorSlider({
		Name = 'BUX Color',
		Function = function(hue, sat, val)
			if PickupTracers.Enabled then
				ColorFunc(hue, sat, val)
			end
		end
	})
	Transparency = PickupTracers:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Function = function(val)
			for _, tracer in Reference do
				tracer.Transparency = 1 - val
			end
		end,
		Decimal = 10
	})
	Bux = PickupTracers:CreateToggle({
		Name = 'Bux Only',
		Function = function()
			if PickupTracers.Enabled then
				PickupTracers:Toggle()
				PickupTracers:Toggle()
			end
		end,
		Tooltip = 'Hides non BUX pickups'
	})
end)

run(function()
	local AutoCamel
	
	AutoCamel = vape.Categories.Minigames:CreateModule({
		Name = 'AutoCamel',
		Function = function(callback)
			if callback then
				local camel = workspace.NPCs:FindFirstChild('Abu Baba')
				if not camel then
					notif('AutoCamel', 'Missing camel seller!', 5, 'warning')
					AutoCamel:Toggle()
					return
				end
	
				local module = require(camel.Dialogue:FindFirstChild('RunScript', true).ModuleScript)
				repeat
					if (lplr:GetAttribute('TIX') or 0) >= 30 then
						module:Run()
					end
	
					task.wait(0.5)
				until not AutoCamel.Enabled
			end
		end,
		Tooltip = 'Automatically buy camels'
	})
end)

run(function()
	local AutoCloudGrind
	
	AutoCloudGrind = vape.Categories.Minigames:CreateModule({
		Name = 'AutoCloudGrind',
		Function = function(callback)
			if callback then
				repeat
					if bt.Variables.arena and bt.Variables.arena:GetAttribute('State') == 'Picking' then
						local doRun = true
						for _, v in bt.Variables.arena.Goon:GetChildren() do
							local drop = v.Value and v.Value:GetAttribute('Item_Drop')
	
							if drop and drop:find('FX ') and not bt.Variables.data.CardCollection[drop] then
								doRun = false
							end
						end
	
						if doRun then
							bt.Network.FireServer('CommitToMove', 'Run Away', nil, nil)
							task.wait(3)
						else
							workspace.Sounds.Money:Play()
							workspace.Sounds.Money.Ended:Wait()
						end
					end
	
					task.wait(0.05)
				until not AutoCloudGrind.Enabled
			end
		end,
		Tooltip = 'Automatically grind for SFX Cards from Cloudie (floor 51)'
	})
end)

run(function()
	local AutoFish
	local KeepList
	local old
	
	AutoFish = vape.Categories.Minigames:CreateModule({
		Name = 'AutoFish',
		Function = function(callback)
			if callback then
				local fishman = workspace.NPCs:FindFirstChild('The Seller')
				if not fishman then
					notif('AutoFish', 'Missing fisherman!', 5, 'warning')
					AutoFish:Toggle()
					return
				end
	
				old = workspace.Sounds.Money.Volume
				workspace.Sounds.Money.Volume = 0
	
				repeat
					local fish = lplr.Status:GetAttribute('NextFish')
					local res = bt.Network.InvokeServer('FishItem')
					if res == true then
						if not table.find(KeepList.ListEnabled, fish) then
							bt.Network.InvokeServer('UseItem', fish, fishman)
						end
	
						bt.Network.InvokeServer('BuyItem', fishman.ShopItems:GetChildren()[1], fishman)
					end
	
					task.wait()
				until not AutoFish.Enabled
			else
				if old then
					workspace.Sounds.Money.Volume = old
				end
			end
		end,
		Tooltip = 'Automatically sell and buy fish'
	})
	KeepList = AutoFish:CreateTextList({
		Name = 'Keep List',
		Placeholder = 'item'
	})
end)

run(function()
	local AutoPaint
	
	AutoPaint = vape.Categories.Minigames:CreateModule({
		Name = 'AutoPaint',
		Function = function(callback)
			if callback then
				local gui = lplr.PlayerGui.HUD.Painter
				local canvas = gui:FindFirstChild('CanvasTime', true).Parent
				local colorpicker = gui.ColorPicker
	
				repeat
					if gui.Visible and bt.Variables.paintingflag and not bt.Variables.canvas:GetAttribute('Completed') then
						local solution = bt.Variables.canvas.Parent:FindFirstChild('Solution Easel')
	
						if solution then
							for _, v in solution.solution:GetDescendants() do
								if v:IsA('BasePart') and bt.Variables.canvas[v.Parent.Name][v.Name].BrickColor ~= v.BrickColor then
									local element = canvas:FindFirstChild(v.Parent.Name:sub(4)..'_'..v.Name)
									if element then
										for _, color in colorpicker:GetChildren() do
											if color:GetAttribute('BGColor') == v.BrickColor.Color then
												bt.Ambassador.Fire('ButtonPress', color)
												break
											end
										end
	
										bt.Ambassador.Fire('ButtonPress', element)
									end
	
									break
								end
							end
						end
					end
	
					task.wait(0.05)
				until not AutoPaint.Enabled
			end
		end,
		Tooltip = 'Automatically paint canvas photos'
	})
end)

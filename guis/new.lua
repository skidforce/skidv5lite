local inputService = game:GetService('UserInputService')
local textService = game:GetService('TextService')
local httpService = game:GetService('HttpService')
local tweenService = game:GetService('TweenService')
local runService = game:GetService('RunService')
local gameCamera = workspace.CurrentCamera
local players = game:GetService('Players')

local fontsize = Instance.new('TextLabel')
local notifications = Instance.new('Frame')
local assetfunction = getcustomasset
if not pcall(getcustomasset, '') then
	assetfunction = nil
end

local mainapi = {
	Categories = {},
	GUIColor = {},
	HeldKeybinds = {},
	Keybind = {'RightShift'},
	Loaded = false,
	Libraries = {},
	Modules = {},
	Place = game.PlaceId,
	Profile = 'default',
	Profiles = {},
	RainbowSpeed = {Value = 1},
	RainbowUpdateSpeed = {Value = 60},
	RainbowTable = {},
	Scale = {Value = 1},
	ThreadFix = setthreadidentity and true or false,
	ToggleNotifications = {},
	Version = '4.19',
	Windows = {}
}

local clickgui, contentcontainer, settingspane, sidebarlist, tabbar

local color = {}
local tween = {
	Tween = tweenService.Create,
	tweenstwo = TweenInfo.new(0.1)
}
local uipallet = {
	Main = Color3.fromRGB(26, 25, 26),
	Text = Color3.fromRGB(200, 200, 200),
	Font = Font.new('Arial'),
	FontSemiBold = Font.new('Arial SemiBold'),
	Tween = TweenInfo.new(0.16, Enum.EasingStyle.Linear)
}

local getcustomassets = {
	['skidv5/assets/new/add.png'] = 'rbxassetid://14368300605',
	['skidv5/assets/new/alert.png'] = 'rbxassetid://14368301329',
	['skidv5/assets/new/allowedicon.png'] = 'rbxassetid://14368302000',
	['skidv5/assets/new/allowedtab.png'] = 'rbxassetid://14368302875',
	['skidv5/assets/new/arrowmodule.png'] = 'rbxassetid://14473354880',
	['skidv5/assets/new/back.png'] = 'rbxassetid://14368303894',
	['skidv5/assets/new/bind.png'] = 'rbxassetid://14368304734',
	['skidv5/assets/new/bindbkg.png'] = 'rbxassetid://14368305655',
	['skidv5/assets/new/blatanticon.png'] = 'rbxassetid://14368306745',
	['skidv5/assets/new/blockedicon.png'] = 'rbxassetid://14385669108',
	['skidv5/assets/new/blockedtab.png'] = 'rbxassetid://14385672881',
	['skidv5/assets/new/blur.png'] = 'rbxassetid://14898786664',
	['skidv5/assets/new/blurnotif.png'] = 'rbxassetid://16738720137',
	['skidv5/assets/new/close.png'] = 'rbxassetid://14368309446',
	['skidv5/assets/new/closemini.png'] = 'rbxassetid://14368310467',
	['skidv5/assets/new/colorpreview.png'] = 'rbxassetid://14368311578',
	['skidv5/assets/new/combaticon.png'] = 'rbxassetid://14368312652',
	['skidv5/assets/new/customsettings.png'] = 'rbxassetid://14403726449',
	['skidv5/assets/new/discord.png'] = '',
	['skidv5/assets/new/dots.png'] = 'rbxassetid://14368314459',
	['skidv5/assets/new/edit.png'] = 'rbxassetid://14368315443',
	['skidv5/assets/new/expandicon.png'] = 'rbxassetid://14368353032',
	['skidv5/assets/new/expandright.png'] = 'rbxassetid://14368316544',
	['skidv5/assets/new/expandup.png'] = 'rbxassetid://14368317595',
	['skidv5/assets/new/friendstab.png'] = 'rbxassetid://14397462778',
	['skidv5/assets/new/guisettings.png'] = 'rbxassetid://14368318994',
	['skidv5/assets/new/guislider.png'] = 'rbxassetid://14368320020',
	['skidv5/assets/new/guisliderrain.png'] = 'rbxassetid://14368321228',
	['skidv5/assets/new/guiv4.png'] = 'rbxassetid://14368322199',
	['skidv5/assets/new/guivape.png'] = 'rbxassetid://14657521312',
	['skidv5/assets/new/info.png'] = 'rbxassetid://14368324807',
	['skidv5/assets/new/inventoryicon.png'] = 'rbxassetid://14928011633',
	['skidv5/assets/new/legit.png'] = 'rbxassetid://14425650534',
	['skidv5/assets/new/legittab.png'] = 'rbxassetid://14426740825',
	['skidv5/assets/new/miniicon.png'] = 'rbxassetid://14368326029',
	['skidv5/assets/new/notification.png'] = 'rbxassetid://16738721069',
	['skidv5/assets/new/overlaysicon.png'] = 'rbxassetid://14368339581',
	['skidv5/assets/new/overlaystab.png'] = 'rbxassetid://14397380433',
	['skidv5/assets/new/pin.png'] = 'rbxassetid://14368342301',
	['skidv5/assets/new/profilesicon.png'] = 'rbxassetid://14397465323',
	['skidv5/assets/new/radaricon.png'] = 'rbxassetid://14368343291',
	['skidv5/assets/new/rainbow_1.png'] = 'rbxassetid://14368344374',
	['skidv5/assets/new/rainbow_2.png'] = 'rbxassetid://14368345149',
	['skidv5/assets/new/rainbow_3.png'] = 'rbxassetid://14368345840',
	['skidv5/assets/new/rainbow_4.png'] = 'rbxassetid://14368346696',
	['skidv5/assets/new/range.png'] = 'rbxassetid://14368347435',
	['skidv5/assets/new/rangearrow.png'] = 'rbxassetid://14368348640',
	['skidv5/assets/new/rendericon.png'] = 'rbxassetid://14368350193',
	['skidv5/assets/new/rendertab.png'] = 'rbxassetid://14397373458',
	['skidv5/assets/new/search.png'] = 'rbxassetid://14425646684',
	['skidv5/assets/new/targetinfoicon.png'] = 'rbxassetid://14368354234',
	['skidv5/assets/new/targetnpc1.png'] = 'rbxassetid://14497400332',
	['skidv5/assets/new/targetnpc2.png'] = 'rbxassetid://14497402744',
	['skidv5/assets/new/targetplayers1.png'] = 'rbxassetid://14497396015',
	['skidv5/assets/new/targetplayers2.png'] = 'rbxassetid://14497397862',
	['skidv5/assets/new/targetstab.png'] = 'rbxassetid://14497393895',
	['skidv5/assets/new/textguiicon.png'] = 'rbxassetid://14368355456',
	['skidv5/assets/new/textv4.png'] = 'rbxassetid://14368357095',
	['skidv5/assets/new/textvape.png'] = 'rbxassetid://14368358200',
	['skidv5/assets/new/utilityicon.png'] = 'rbxassetid://14368359107',
	['skidv5/assets/new/vape.png'] = 'rbxassetid://99295797606112',
	['skidv5/assets/new/warning.png'] = 'rbxassetid://14368361552',
	['skidv5/assets/new/worldicon.png'] = 'rbxassetid://14368362492'
}

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local getfontsize = function(text, size, font, bounds)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end
	if bounds then
		fontsize.MaxSize = bounds
	end
	return textService:GetTextBoundsAsync(fontsize)
end

local function addBlur(parent, notif)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 89, 1, 52)
	blur.Position = UDim2.fromOffset(-48, -31)
	blur.BackgroundTransparency = 1
	blur.Image = getcustomasset('skidv5/assets/new/'..(notif and 'blurnotif' or 'blur')..'.png')
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(52, 31, 261, 502)
	blur.Parent = parent

	return blur
end

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

local function addCloseButton(parent, offset)
	local close = Instance.new('ImageButton')
	close.Name = 'Close'
	close.Size = UDim2.fromOffset(24, 24)
	close.Position = UDim2.new(1, -35, 0, offset or 9)
	close.BackgroundColor3 = Color3.new(1, 1, 1)
	close.BackgroundTransparency = 1
	close.AutoButtonColor = false
	close.Image = getcustomasset('skidv5/assets/new/close.png')
	close.ImageColor3 = color.Light(uipallet.Text, 0.2)
	close.ImageTransparency = 0.5
	close.Parent = parent
	addCorner(close, UDim.new(1, 0))

	close.MouseEnter:Connect(function()
		close.ImageTransparency = 0.3
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 0.6
		})
	end)
	close.MouseLeave:Connect(function()
		close.ImageTransparency = 0.5
		tween:Tween(close, uipallet.Tween, {
			BackgroundTransparency = 1
		})
	end)

	return close
end

local function addMaid(object)
	object.Connections = {}
	function object:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(self.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'function' then
			table.insert(self.Connections, {
				Disconnect = callback
			})
		else
			table.insert(self.Connections, callback)
		end
	end
end

local function addTooltip(gui, text)
	if not text then return end

	local function tooltipMoved(x, y)
		local right = x + 16 + tooltip.Size.X.Offset > (scale.Scale * 1920)
		tooltip.Position = UDim2.fromOffset(
			(right and x - (tooltip.Size.X.Offset * scale.Scale) - 16 or x + 16) / scale.Scale,
			((y + 11) - (tooltip.Size.Y.Offset / 2)) / scale.Scale
		)
		tooltip.Visible = toolblur.Visible
	end

	gui.MouseEnter:Connect(function(x, y)
		local tooltipSize = getfontsize(text, tooltip.TextSize, uipallet.Font)
		tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
		tooltip.Text = text
		tooltipMoved(x, y)
	end)
	gui.MouseMoved:Connect(tooltipMoved)
	gui.MouseLeave:Connect(function()
		tooltip.Visible = false
	end)
end

local function checkKeybinds(compare, target, key)
	if type(target) == 'table' then
		if table.find(target, key) then
			for i, v in target do
				if not table.find(compare, v) then
					return false
				end
			end
			return true
		end
	end

	return false
end

local function createDownloader(text)
	if mainapi.Loaded ~= true then
		local downloader = mainapi.Downloader
		if not downloader then
			downloader = Instance.new('TextLabel')
			downloader.Size = UDim2.new(1, 0, 0, 40)
			downloader.BackgroundTransparency = 1
			downloader.TextStrokeTransparency = 0
			downloader.TextSize = 20
			downloader.TextColor3 = Color3.new(1, 1, 1)
			downloader.FontFace = uipallet.Font
			downloader.Parent = mainapi.gui
			mainapi.Downloader = downloader
		end
		downloader.Text = 'Downloading '..text
	end
end

local function createMobileButton(buttonapi, position)
	local heldbutton = false
	local button = Instance.new('TextButton')
	button.Size = UDim2.fromOffset(40, 40)
	button.Position = UDim2.fromOffset(position.X, position.Y)
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.BackgroundColor3 = buttonapi.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
	button.BackgroundTransparency = 0.5
	button.Text = buttonapi.Name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Font = Enum.Font.Gotham
	button.Parent = mainapi.gui
	local buttonconstraint = Instance.new('UITextSizeConstraint')
	buttonconstraint.MaxTextSize = 16
	buttonconstraint.Parent = button
	addCorner(button, UDim.new(1, 0))

	button.MouseButton1Down:Connect(function()
		heldbutton = true
		local holdtime, holdpos = tick(), inputService:GetMouseLocation()
		repeat
			heldbutton = (inputService:GetMouseLocation() - holdpos).Magnitude < 6
			task.wait()
		until (tick() - holdtime) > 1 or not heldbutton
		if heldbutton then
			buttonapi.Bind = {}
			button:Destroy()
		end
	end)
	button.MouseButton1Up:Connect(function()
		heldbutton = false
	end)
	button.MouseButton1Click:Connect(function()
		buttonapi:Toggle()
		button.BackgroundColor3 = buttonapi.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
	end)

	buttonapi.Bind = {Button = button}
end

local function hasContent(path)
	if not isfile(path) then return false end
	local ok, body = pcall(readfile, path)
	return ok and type(body) == 'string' and body ~= ''
end

local function downloadFile(path, func)
	if not hasContent(path) then
		createDownloader(path)
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/skidforce/skidv5lite/main/'..select(1, path:gsub('skidv5/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function usableAsset(value)
	return type(value) == 'string' and value:match('^rbx%a*://') ~= nil
end
getcustomasset = not inputService.TouchEnabled and assetfunction and function(path)
	local ok, res = pcall(downloadFile, path, assetfunction)
	if ok and usableAsset(res) then return res end
	return getcustomassets[path] or ''
end or function(path)
	return getcustomassets[path] or ''
end

local function getTableSize(tab)
	local ind = 0
	for _ in tab do ind += 1 end
	return ind
end

local function loopClean(tab)
	for i, v in tab do
		if type(v) == 'table' then
			loopClean(v)
		end
		tab[i] = nil
	end
end

local function loadJson(path)
	local suc, res = pcall(function()
		return httpService:JSONDecode(readfile(path))
	end)
	if suc then return res end
	return {}
end

local function makeDraggable(gui, draggable)
	draggable = draggable or gui
	draggable.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local dragPos, startPos = input.Position, gui.Position
			local changed = inputService.InputChanged:Connect(function(i)
				if i.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					gui.Position = UDim2.fromOffset(
						startPos.X.Offset + ((i.Position - dragPos).X / scale.Scale),
						startPos.Y.Offset + ((i.Position - dragPos).Y / scale.Scale)
					)
				end
			end)
			local ended
			ended = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					changed:Disconnect()
					ended:Disconnect()
				end
			end)
		end
	end)
end

local function randomString(len)
	local str = ''
	for i = 1, len or 10 do
		str ..= string.char(math.random(97, 122))
	end
	return str
end

local function removeTags(text)
	return tostring(text):gsub('<[^>]+>', '')
end

local colorfile = isfile('skidv5/assets/color.txt') and readfile('skidv5/assets/color.txt') or '26,25,26|200,200,200|Arial|Arial SemiBold|0.16|Linear'
local colorparts = colorfile:split('|')
local function parseColor(str)
	local t = str:split(',')
	return Color3.fromRGB(tonumber(t[1]) or 26, tonumber(t[2]) or 25, tonumber(t[3]) or 26)
end
uipallet.Main = parseColor(colorparts[1])
uipallet.Text = parseColor(colorparts[2])
uipallet.Font = Font.new(colorparts[3] or 'Arial')
uipallet.FontSemiBold = Font.new(colorparts[4] or 'Arial SemiBold')
uipallet.Tween = TweenInfo.new(tonumber(colorparts[5]) or 0.16, Enum.EasingStyle[colorparts[6]] or Enum.EasingStyle.Linear)

color.Dark = function(c, a)
	return c:Lerp(Color3.new(), a)
end
color.Light = function(c, a)
	return c:Lerp(Color3.new(1, 1, 1), a)
end

function mainapi:Color(hue)
	return hue % 1
end

function mainapi:TextColor(h, s, v)
	local c = Color3.fromHSV(h, s, v)
	local lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B
	if lum > 0.55 then
		return Color3.new(0.11, 0.11, 0.11)
	end
	return Color3.new(1, 1, 1)
end

mainapi.Libraries = {
	color = color,
	getcustomasset = getcustomasset,
	getfontsize = getfontsize,
	tween = tween,
	uipallet = uipallet
}

local function accentColor(h, s, v, rainbow, ind)
	if rainbow then
		return Color3.fromHSV(mainapi:Color((h - ((ind or 0) * 0.025)) % 1), s, v)
	end
	return Color3.fromHSV(h, s, v)
end

local components = {
	Toggle = function(children, settings, api)
		local optionapi = {
			Type = 'Toggle',
			Enabled = false,
			Index = getTableSize(api.Options)
		}
		local width = settings.Width or 478
		local height = settings.Height or 40
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(width, height)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local icon
		local iconoffset = 0
		if settings.Icon then
			icon = Instance.new('ImageLabel')
			icon.Name = 'Icon'
			icon.Size = settings.Size or UDim2.fromOffset(14, 14)
			icon.Position = UDim2.fromOffset(12, (height - (settings.Size or UDim2.fromOffset(14, 14)).Y.Offset) / 2)
			icon.BackgroundTransparency = 1
			icon.Image = settings.Icon
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
			icon.Parent = row
			iconoffset = (settings.Size or UDim2.fromOffset(14, 14)).X.Offset + 14
		end
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(width - iconoffset - 80, height)
		name.Position = UDim2.fromOffset(iconoffset + 10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.Size = UDim2.fromOffset(40, 20)
		knob.Position = UDim2.new(1, -10, 0.5, 0)
		knob.AnchorPoint = Vector2.new(1, 0.5)
		knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		knob.BorderSizePixel = 0
		knob.Parent = row
		addCorner(knob, UDim.new(1, 0))
		local knobinner = Instance.new('Frame')
		knobinner.Name = 'KnobInner'
		knobinner.Size = UDim2.fromOffset(32, 16)
		knobinner.Position = UDim2.fromOffset(3, 2)
		knobinner.BackgroundColor3 = color.Light(uipallet.Main, 0.5)
		knobinner.BorderSizePixel = 0
		knobinner.Parent = knob
		addCorner(knobinner, UDim.new(1, 0))
		settings.Function = settings.Function or function() end
		optionapi.Object = row
		optionapi.Knob = knob

		local function restyle()
			if optionapi.Enabled then
				local accent = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
				knob.BackgroundColor3 = accent
				knobinner.BackgroundColor3 = color.Light(accent, 0.65)
				tween:Tween(knobinner, uipallet.Tween, {
					Position = UDim2.fromOffset(5, 2)
				})
			else
				knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
				knobinner.BackgroundColor3 = color.Light(uipallet.Main, 0.5)
				tween:Tween(knobinner, uipallet.Tween, {
					Position = UDim2.fromOffset(3, 2)
				})
			end
		end

		function optionapi:Toggle()
			self.Enabled = not self.Enabled
			restyle()
			settings.Function(self.Enabled)
		end

		function optionapi:Color(h, s, v, rainbow)
			if self.Enabled then
				local accent = accentColor(h, s, v, rainbow, self.Index)
				knob.BackgroundColor3 = accent
				knobinner.BackgroundColor3 = color.Light(accent, 0.65)
			end
		end

		row.MouseButton1Click:Connect(function()
			optionapi:Toggle()
		end)
		row.MouseEnter:Connect(function()
			if not optionapi.Enabled then
				row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end
		end)
		row.MouseLeave:Connect(function()
			if not optionapi.Enabled then
				row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
			end
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				Enabled = self.Enabled
			}
		end

		function optionapi:Load(tab)
			if self.Enabled ~= tab.Enabled then
				self:Toggle()
			end
		end

		if settings.Default then
			optionapi:Toggle()
		end
		if settings.Visible == false then
			row.Visible = false
		end
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	Slider = function(children, settings, api)
		local optionapi = {
			Type = 'Slider',
			Value = settings.Default or settings.Min or 0,
			Min = settings.Min or 0,
			Max = settings.Max or 100,
			Decimal = settings.Decimal or 0,
			Suffix = settings.Suffix or '',
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local value = Instance.new('TextLabel')
		value.Size = UDim2.fromOffset(120, 40)
		value.Position = UDim2.new(1, -10, 0, 0)
		value.AnchorPoint = Vector2.new(1, 0)
		value.BackgroundTransparency = 1
		value.Text = ''
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.TextColor3 = color.Dark(uipallet.Text, 0.43)
		value.TextSize = 12
		value.FontFace = uipallet.Font
		value.Parent = row
		local holder = Instance.new('Frame')
		holder.Name = 'Slider'
		holder.Size = UDim2.fromOffset(140, 2)
		holder.Position = UDim2.new(1, -160, 0.5, 0)
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		holder.BorderSizePixel = 0
		holder.Parent = row
		local fill = Instance.new('Frame')
		fill.Name = 'Fill'
		fill.Size = UDim2.fromScale(0, 1)
		fill.BackgroundColor3 = color.Light(uipallet.Main, 0.4)
		fill.BorderSizePixel = 0
		fill.Parent = holder
		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.Size = UDim2.fromOffset(12, 12)
		knob.Position = UDim2.fromScale(0, 0.5)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.BackgroundColor3 = color.Light(uipallet.Main, 0.6)
		knob.BorderSizePixel = 0
		knob.Parent = holder
		addCorner(knob, UDim.new(1, 0))
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		local function render(val)
			local pos = (val - optionapi.Min) / (optionapi.Max - optionapi.Min)
			fill.Size = UDim2.fromScale(pos, 1)
			knob.Position = UDim2.fromScale(pos, 0.5)
			local suffix = settings.Suffix or ''
			value.Text = settings.Decimal > 0 and string.format('%.'..settings.Decimal..'f', val)..suffix or tostring(math.round(val))..suffix
		end

		function optionapi:SetValue(val, pos, final)
			self.Value = math.clamp(val, self.Min, self.Max)
			render(self.Value)
			settings.Function(self.Value, final)
		end

		row.InputBegan:Connect(function(inputObj)
			if
				(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
				and (inputObj.Position.Y - row.AbsolutePosition.Y) > (16 * scale.Scale)
			then
				local function update(input)
					local val = math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
					optionapi:SetValue(optionapi.Min + (optionapi.Max - optionapi.Min) * val, true, false)
				end
				update(inputObj)
				local changed = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						update(input)
					end
				end)
				local ended
				ended = inputObj.Changed:Connect(function()
					if inputObj.UserInputState == Enum.UserInputState.End then
						optionapi:SetValue(optionapi.Value, false, true)
						if changed then changed:Disconnect() end
						if ended then ended:Disconnect() end
					end
				end)
			end
		end)
		row.MouseEnter:Connect(function()
			tween:Tween(knob, uipallet.Tween, {
				Size = UDim2.fromOffset(14, 14)
			})
		end)
		row.MouseLeave:Connect(function()
			tween:Tween(knob, uipallet.Tween, {
				Size = UDim2.fromOffset(12, 12)
			})
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				Value = self.Value,
				Max = self.Max
			}
		end

		function optionapi:Load(tab)
			if tab.Max then
				self.Max = tab.Max
			end
			self:SetValue(tab.Value or self.Min)
		end

		if settings.Visible == false then
			row.Visible = false
		end
		render(optionapi.Value)
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	TwoSlider = function(children, settings, api)
		local optionapi = {
			Type = 'TwoSlider',
			ValueMin = settings.Min or 0,
			ValueMax = settings.Max or 100,
			Min = settings.Min or 0,
			Max = settings.Max or 100,
			Decimal = settings.Decimal or 0,
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local value = Instance.new('TextLabel')
		value.Size = UDim2.fromOffset(150, 40)
		value.Position = UDim2.new(1, -10, 0, 0)
		value.AnchorPoint = Vector2.new(1, 0)
		value.BackgroundTransparency = 1
		value.Text = ''
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.TextColor3 = color.Dark(uipallet.Text, 0.43)
		value.TextSize = 12
		value.FontFace = uipallet.Font
		value.Parent = row
		local holder = Instance.new('Frame')
		holder.Name = 'Slider'
		holder.Size = UDim2.fromOffset(180, 2)
		holder.Position = UDim2.new(1, -200, 0.5, 0)
		holder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		holder.BorderSizePixel = 0
		holder.Parent = row
		local fill = Instance.new('Frame')
		fill.Name = 'Fill'
		fill.BackgroundColor3 = color.Light(uipallet.Main, 0.4)
		fill.BorderSizePixel = 0
		fill.Parent = holder
		local knobmin = Instance.new('Frame')
		knobmin.Name = 'KnobMin'
		knobmin.Size = UDim2.fromOffset(12, 12)
		knobmin.Position = UDim2.fromScale(0, 0.5)
		knobmin.AnchorPoint = Vector2.new(0.5, 0.5)
		knobmin.BackgroundColor3 = color.Light(uipallet.Main, 0.6)
		knobmin.BorderSizePixel = 0
		knobmin.Parent = holder
		addCorner(knobmin, UDim.new(1, 0))
		local knobmax = knobmin:Clone()
		knobmax.Name = 'KnobMax'
		knobmax.Parent = holder
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		local function render()
			local posmin = (optionapi.ValueMin - optionapi.Min) / (optionapi.Max - optionapi.Min)
			local posmax = (optionapi.ValueMax - optionapi.Min) / (optionapi.Max - optionapi.Min)
			fill.Position = UDim2.fromScale(posmin, 0)
			fill.Size = UDim2.fromScale(posmax - posmin, 1)
			knobmin.Position = UDim2.fromScale(posmin, 0.5)
			knobmax.Position = UDim2.fromScale(posmax, 0.5)
			value.Text = tostring(optionapi.ValueMin)..' - '..tostring(optionapi.ValueMax)
		end

		function optionapi:SetValue(max, min)
			self.ValueMax = math.clamp(max, self.Min, self.Max)
			self.ValueMin = math.clamp(min, self.Min, self.Max)
			render()
			settings.Function(self.ValueMin, self.ValueMax)
		end

		row.InputBegan:Connect(function(inputObj)
			if
				(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
				and (inputObj.Position.Y - row.AbsolutePosition.Y) > (16 * scale.Scale)
			then
				local function update(input)
					local val = math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1) * (optionapi.Max - optionapi.Min) + optionapi.Min
					if math.abs(val - optionapi.ValueMin) < math.abs(val - optionapi.ValueMax) then
						optionapi:SetValue(optionapi.ValueMax, val)
					else
						optionapi:SetValue(val, optionapi.ValueMin)
					end
				end
				update(inputObj)
				local changed = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						update(input)
					end
				end)
				local ended
				ended = inputObj.Changed:Connect(function()
					if inputObj.UserInputState == Enum.UserInputState.End then
						if changed then changed:Disconnect() end
						if ended then ended:Disconnect() end
					end
				end)
			end
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				ValueMin = self.ValueMin,
				ValueMax = self.ValueMax
			}
		end

		function optionapi:Load(tab)
			self:SetValue(tab.ValueMax or self.Max, tab.ValueMin or self.Min)
		end

		if settings.Visible == false then
			row.Visible = false
		end
		render()
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	Dropdown = function(children, settings, api)
		local optionapi = {
			Type = 'Dropdown',
			Value = settings.Default or settings.List[1] or '',
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local value = Instance.new('TextLabel')
		value.Size = UDim2.fromOffset(170, 40)
		value.Position = UDim2.new(1, -34, 0, 0)
		value.AnchorPoint = Vector2.new(1, 0)
		value.BackgroundTransparency = 1
		value.Text = optionapi.Value
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.TextColor3 = color.Dark(uipallet.Text, 0.43)
		value.TextSize = 12
		value.FontFace = uipallet.Font
		value.Parent = row
		local arrow = Instance.new('TextLabel')
		arrow.Size = UDim2.fromOffset(14, 40)
		arrow.Position = UDim2.new(1, -20, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = '▼'
		arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
		arrow.TextSize = 9
		arrow.FontFace = uipallet.Font
		arrow.Parent = row
		local window = children.Parent
		local dropdown = Instance.new('Frame')
		dropdown.Name = 'Dropdown'
		dropdown.Size = UDim2.fromOffset(478, 0)
		dropdown.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
		dropdown.BorderSizePixel = 0
		dropdown.Visible = false
		dropdown.ZIndex = 8
		dropdown.Parent = window
		addCorner(dropdown, UDim.new(0, 4))
		local list = Instance.new('ScrollingFrame')
		list.Size = UDim2.fromScale(1, 1)
		list.BackgroundTransparency = 1
		list.BorderSizePixel = 0
		list.ScrollBarThickness = 2
		list.ScrollBarImageTransparency = 0.75
		list.AutomaticCanvasSize = Enum.AutomaticSize.Y
		list.CanvasSize = UDim2.fromOffset(0, 0)
		list.Parent = dropdown
		local listlayout = Instance.new('UIListLayout')
		listlayout.SortOrder = Enum.SortOrder.LayoutOrder
		listlayout.Padding = UDim.new(0, 2)
		listlayout.Parent = list
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		local function openDropdown()
			local pos = row.AbsolutePosition - window.AbsolutePosition
			dropdown.Position = UDim2.fromOffset(pos.X, pos.Y + 40)
			dropdown.Size = UDim2.fromOffset(478, math.min(#settings.List * 34 + 4, 240))
			dropdown.Visible = true
		end

		for i, v in settings.List do
			local item = Instance.new('TextButton')
			item.Name = v
			item.Size = UDim2.fromOffset(478, 32)
			item.BackgroundColor3 = Color3.new(1, 1, 1)
			item.BackgroundTransparency = 1
			item.AutoButtonColor = false
			item.Text = ''
			item.LayoutOrder = i
			item.Parent = list
			local itemname = Instance.new('TextLabel')
			itemname.Size = UDim2.fromOffset(440, 32)
			itemname.Position = UDim2.fromOffset(10, 0)
			itemname.BackgroundTransparency = 1
			itemname.Text = v
			itemname.TextXAlignment = Enum.TextXAlignment.Left
			itemname.TextColor3 = color.Dark(uipallet.Text, 0.16)
			itemname.TextSize = 13
			itemname.FontFace = uipallet.Font
			itemname.Parent = item
			local check = Instance.new('TextLabel')
			check.Size = UDim2.fromOffset(16, 32)
			check.Position = UDim2.new(1, -24, 0, 0)
			check.BackgroundTransparency = 1
			check.Text = optionapi.Value == v and '✓' or ''
			check.TextColor3 = color.Dark(uipallet.Text, 0.43)
			check.TextSize = 13
			check.FontFace = uipallet.FontSemiBold
			check.Parent = item
			item.MouseEnter:Connect(function()
				item.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end)
			item.MouseLeave:Connect(function()
				item.BackgroundColor3 = Color3.new(1, 1, 1)
				item.BackgroundTransparency = 1
			end)
			item.MouseButton1Click:Connect(function()
				optionapi:SetValue(v, true)
				dropdown.Visible = false
			end)
		end

		function optionapi:SetValue(val, mouse)
			self.Value = val
			value.Text = val
			for _, item in list:GetChildren() do
				if item:IsA('TextButton') then
					local check = item:FindFirstChildOfClass('TextLabel')
					if check then
						check.Text = item.Name == val and '✓' or ''
					end
				end
			end
			settings.Function(val, mouse)
		end

		row.MouseButton1Click:Connect(function()
			if dropdown.Visible then
				dropdown.Visible = false
			else
				openDropdown()
			end
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				Value = self.Value
			}
		end

		function optionapi:Load(tab)
			if tab.Value then
				self:SetValue(tab.Value)
			end
		end

		if settings.Visible == false then
			row.Visible = false
		end
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	ColorSlider = function(children, settings, api)
		local optionapi = {
			Type = 'ColorSlider',
			Hue = settings.DefaultHue or 0,
			Sat = settings.DefaultSat or 1,
			Value = settings.DefaultValue or 1,
			Opacity = 1,
			Rainbow = false,
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local preview = Instance.new('ImageLabel')
		preview.Name = 'Preview'
		preview.Size = UDim2.fromOffset(12, 12)
		preview.Position = UDim2.new(1, -30, 0.5, 0)
		preview.AnchorPoint = Vector2.new(1, 0.5)
		preview.BackgroundTransparency = 1
		preview.Image = getcustomasset('skidv5/assets/new/colorpreview.png')
		preview.ImageColor3 = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
		preview.Parent = row
		local arrow = Instance.new('TextLabel')
		arrow.Size = UDim2.fromOffset(14, 40)
		arrow.Position = UDim2.new(1, -16, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = '▼'
		arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
		arrow.TextSize = 9
		arrow.FontFace = uipallet.Font
		arrow.Parent = row
		local slider = Instance.new('Frame')
		slider.Name = 'Slider'
		slider.Size = UDim2.fromOffset(478, 50)
		slider.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		slider.BorderSizePixel = 0
		slider.Visible = false
		slider.Parent = children
		addCorner(slider, UDim.new(0, 4))
		local holder = Instance.new('Frame')
		holder.Name = 'Holder'
		holder.Size = UDim2.fromOffset(400, 2)
		holder.Position = UDim2.fromOffset(10, 24)
		holder.BackgroundColor3 = Color3.new(1, 1, 1)
		holder.BorderSizePixel = 0
		holder.Parent = slider
		local rainbowtable = {}
		for i = 0, 1, 0.1 do
			table.insert(rainbowtable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
		end
		local uigradient = Instance.new('UIGradient')
		uigradient.Color = ColorSequence.new(rainbowtable)
		uigradient.Parent = holder
		local fill = holder:Clone()
		fill.Name = 'Fill'
		fill.Size = UDim2.fromScale(math.clamp(optionapi.Hue, 0.04, 0.96), 1)
		fill.Position = UDim2.new()
		fill.BackgroundTransparency = 1
		fill.Parent = holder
		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.Size = UDim2.fromOffset(14, 14)
		knob.Position = UDim2.fromScale(optionapi.Hue, 0.5)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.BackgroundColor3 = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
		knob.BorderSizePixel = 0
		knob.Parent = holder
		addCorner(knob, UDim.new(1, 0))
		local rainbowbutton = Instance.new('TextButton')
		rainbowbutton.Name = 'Rainbow'
		rainbowbutton.Size = UDim2.fromOffset(28, 28)
		rainbowbutton.Position = UDim2.new(1, -34, 0.5, 0)
		rainbowbutton.AnchorPoint = Vector2.new(1, 0.5)
		rainbowbutton.BackgroundTransparency = 1
		rainbowbutton.Text = ''
		rainbowbutton.Parent = slider
		local rainbowicon = Instance.new('ImageLabel')
		rainbowicon.Size = UDim2.fromOffset(12, 12)
		rainbowicon.Position = UDim2.fromOffset(8, 8)
		rainbowicon.BackgroundTransparency = 1
		rainbowicon.Image = getcustomasset('skidv5/assets/new/rainbow_1.png')
		rainbowicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
		rainbowicon.Parent = rainbowbutton
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		function optionapi:SetValue(h, s, v, o)
			self.Hue = h or self.Hue
			self.Sat = s or self.Sat
			self.Value = v or self.Value
			self.Opacity = o or self.Opacity
			preview.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
			knob.BackgroundColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
			if not self.Rainbow then
				fill.Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
				knob.Position = UDim2.fromScale(self.Hue, 0.5)
			end
			settings.Function(self.Hue, self.Sat, self.Value, self.Opacity)
		end

		function optionapi:Toggle()
			self.Rainbow = not self.Rainbow
			local ind = table.find(mainapi.RainbowTable, self)
			if self.Rainbow then
				if not ind then
					table.insert(mainapi.RainbowTable, self)
				end
				rainbowicon.ImageColor3 = Color3.fromHSV(0.5, 1, 1)
				knob.BackgroundColor3 = Color3.new(1, 1, 1)
			else
				if ind then
					table.remove(mainapi.RainbowTable, ind)
				end
				rainbowicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
				knob.BackgroundColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
				self:SetValue(nil, nil, nil, nil)
			end
		end

		function optionapi:Color(h, s, v, rainbow)
			if rainbow and self.Rainbow then
				preview.ImageColor3 = Color3.fromHSV(mainapi:Color((h - (self.Index * 0.025)) % 1), self.Sat, self.Value)
			elseif not self.Rainbow then
				preview.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
			end
		end

		row.MouseButton1Click:Connect(function()
			slider.Visible = not slider.Visible
			arrow.Rotation = slider.Visible and 180 or 0
		end)
		rainbowbutton.MouseButton1Click:Connect(function()
			optionapi:Toggle()
		end)
		slider.InputBegan:Connect(function(inputObj)
			if
				(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
				and (inputObj.Position.Y - slider.AbsolutePosition.Y) > (10 * scale.Scale)
			then
				local function update(input)
					optionapi:SetValue(math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1))
				end
				update(inputObj)
				local changed = inputService.InputChanged:Connect(function(input)
					if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
						update(input)
					end
				end)
				local ended
				ended = inputObj.Changed:Connect(function()
					if inputObj.UserInputState == Enum.UserInputState.End then
						if changed then changed:Disconnect() end
						if ended then ended:Disconnect() end
					end
				end)
			end
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				Hue = self.Hue,
				Sat = self.Sat,
				Value = self.Value,
				Opacity = self.Opacity,
				Rainbow = self.Rainbow
			}
		end

		function optionapi:Load(tab)
			if tab.Rainbow then
				self:Toggle()
			end
			self:SetValue(tab.Hue, tab.Sat, tab.Value, tab.Opacity)
		end

		if settings.Visible == false then
			row.Visible = false
		end
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	TextBox = function(children, settings, api)
		local optionapi = {
			Type = 'TextBox',
			Value = settings.Default or '',
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('Frame')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local icon
		local iconoffset = 0
		if settings.Icon then
			icon = Instance.new('ImageLabel')
			icon.Name = 'Icon'
			icon.Size = settings.Size or UDim2.fromOffset(14, 14)
			icon.Position = UDim2.new(1, -(settings.Size or UDim2.fromOffset(14, 14)).X.Offset - 20, 0.5, 0)
			icon.AnchorPoint = Vector2.new(1, 0.5)
			icon.BackgroundTransparency = 1
			icon.Image = settings.Icon
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
			icon.Parent = row
			iconoffset = (settings.Size or UDim2.fromOffset(14, 14)).X.Offset + 8
		end
		local textbox = Instance.new('TextBox')
		textbox.Name = 'Box'
		textbox.Size = UDim2.fromOffset(150, 30)
		textbox.Position = UDim2.new(1, -(iconoffset + 8), 0.5, 0)
		textbox.AnchorPoint = Vector2.new(1, 0.5)
		textbox.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
		textbox.BorderSizePixel = 0
		textbox.Text = optionapi.Value
		textbox.PlaceholderText = settings.Placeholder or ''
		textbox.PlaceholderColor3 = color.Dark(uipallet.Text, 0.43)
		textbox.TextColor3 = color.Dark(uipallet.Text, 0.16)
		textbox.TextSize = 13
		textbox.FontFace = uipallet.Font
		textbox.TextXAlignment = Enum.TextXAlignment.Left
		textbox.ClearTextOnFocus = true
		textbox.Parent = row
		addCorner(textbox, UDim.new(0, 4))
		local textpadding = Instance.new('UIPadding')
		textpadding.PaddingLeft = UDim.new(0, 8)
		textpadding.PaddingRight = UDim.new(0, 8)
		textpadding.Parent = textbox
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		function optionapi:SetValue(val)
			self.Value = val or ''
			textbox.Text = self.Value
		end

		textbox.FocusLost:Connect(function(enter)
			if enter then
				optionapi.Value = textbox.Text
			end
			settings.Function(enter)
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				Value = self.Value
			}
		end

		function optionapi:Load(tab)
			self:SetValue(tab.Value)
		end

		if settings.Visible == false then
			row.Visible = false
		end
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	TextList = function(children, settings, api)
		local optionapi = {
			Type = 'TextList',
			List = {},
			ListEnabled = {},
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local count = Instance.new('TextLabel')
		count.Size = UDim2.fromOffset(120, 40)
		count.Position = UDim2.new(1, -34, 0, 0)
		count.AnchorPoint = Vector2.new(1, 0)
		count.BackgroundTransparency = 1
		count.Text = '0'
		count.TextXAlignment = Enum.TextXAlignment.Right
		count.TextColor3 = color.Dark(uipallet.Text, 0.43)
		count.TextSize = 12
		count.FontFace = uipallet.Font
		count.Parent = row
		local arrow = Instance.new('TextLabel')
		arrow.Size = UDim2.fromOffset(14, 40)
		arrow.Position = UDim2.new(1, -20, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = '▼'
		arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
		arrow.TextSize = 9
		arrow.FontFace = uipallet.Font
		arrow.Parent = row
		local expanded = Instance.new('Frame')
		expanded.Name = 'Expanded'
		expanded.Size = UDim2.fromOffset(478, 0)
		expanded.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		expanded.BorderSizePixel = 0
		expanded.Visible = false
		expanded.Parent = children
		addCorner(expanded, UDim.new(0, 4))
		local list = Instance.new('UIListLayout')
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 2)
		list.Parent = expanded
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		local function rebuild()
			for _, v in expanded:GetChildren() do
				if v:IsA('TextButton') or v:IsA('Frame') then
					v:Destroy()
				end
			end
			for i, v in optionapi.List do
				local item = Instance.new('TextButton')
				item.Name = 'Item'
				item.Size = UDim2.fromOffset(458, 30)
				item.Position = UDim2.fromOffset(10, 0)
				item.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				item.AutoButtonColor = false
				item.Text = ''
				item.LayoutOrder = i
				item.Parent = expanded
				addCorner(item, UDim.new(0, 4))
				local itemname = Instance.new('TextLabel')
				itemname.Size = UDim2.fromOffset(400, 30)
				itemname.Position = UDim2.fromOffset(10, 0)
				itemname.BackgroundTransparency = 1
				itemname.Text = v
				itemname.TextXAlignment = Enum.TextXAlignment.Left
				itemname.TextColor3 = color.Dark(uipallet.Text, 0.16)
				itemname.TextSize = 13
				itemname.FontFace = uipallet.Font
				itemname.Parent = item
				local dot = Instance.new('Frame')
				dot.Name = 'Dot'
				dot.Size = UDim2.fromOffset(8, 8)
				dot.Position = UDim2.new(1, -20, 0.5, 0)
				dot.AnchorPoint = Vector2.new(1, 0.5)
				dot.BackgroundColor3 = table.find(optionapi.ListEnabled, v) and Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value) or color.Light(uipallet.Main, 0.37)
				dot.BorderSizePixel = 0
				dot.Parent = item
				addCorner(dot, UDim.new(1, 0))
				item.MouseButton1Click:Connect(function()
					optionapi:ChangeValue(v)
				end)
			end
			local addrow = Instance.new('Frame')
			addrow.Name = 'AddRow'
			addrow.Size = UDim2.fromOffset(458, 30)
			addrow.Position = UDim2.fromOffset(10, 0)
			addrow.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			addrow.BorderSizePixel = 0
			addrow.LayoutOrder = #optionapi.List + 1
			addrow.Parent = expanded
			addCorner(addrow, UDim.new(0, 4))
			local addtext = Instance.new('TextBox')
			addtext.Size = UDim2.new(1, -70, 1, 0)
			addtext.Position = UDim2.fromOffset(10, 0)
			addtext.BackgroundTransparency = 1
			addtext.PlaceholderText = settings.Placeholder or 'Add entry...'
			addtext.PlaceholderColor3 = color.Dark(uipallet.Text, 0.43)
			addtext.TextColor3 = color.Dark(uipallet.Text, 0.16)
			addtext.TextSize = 13
			addtext.FontFace = uipallet.Font
			addtext.TextXAlignment = Enum.TextXAlignment.Left
			addtext.ClearTextOnFocus = true
			addtext.Parent = addrow
			local addbutton = Instance.new('TextButton')
			addbutton.Size = UDim2.fromOffset(52, 22)
			addbutton.Position = UDim2.new(1, -58, 0.5, 0)
			addbutton.AnchorPoint = Vector2.new(1, 0.5)
			addbutton.BackgroundColor3 = color.Light(uipallet.Main, 0.06)
			addbutton.BorderSizePixel = 0
			addbutton.Text = 'ADD'
			addbutton.TextColor3 = color.Dark(uipallet.Text, 0.43)
			addbutton.TextSize = 10
			addbutton.FontFace = uipallet.FontSemiBold
			addbutton.AutoButtonColor = false
			addbutton.Parent = addrow
			addCorner(addbutton, UDim.new(0, 4))
			addbutton.MouseButton1Click:Connect(function()
				if addtext.Text ~= '' then
					optionapi:ChangeValue(addtext.Text)
					addtext.Text = ''
				end
			end)
			count.Text = tostring(#optionapi.List)
		end

		function optionapi:ChangeValue(val)
			if val then
				local ind = table.find(self.List, val)
				if ind then
					table.remove(self.List, ind)
					ind = table.find(self.ListEnabled, val)
					if ind then
						table.remove(self.ListEnabled, ind)
					end
				else
					table.insert(self.List, val)
					table.insert(self.ListEnabled, val)
				end
			end
			rebuild()
			settings.Function(self.List)
		end

		function optionapi:SetValue(val)
			self.List = table.clone(val or {})
			self.ListEnabled = table.clone(val or {})
			rebuild()
			settings.Function(self.List)
		end

		row.MouseButton1Click:Connect(function()
			expanded.Visible = not expanded.Visible
			arrow.Rotation = expanded.Visible and 180 or 0
			if expanded.Visible then
				local content = 0
				for _, v in expanded:GetChildren() do
					if v:IsA('TextButton') or v:IsA('Frame') then
						content += v.Size.Y.Offset + 2
					end
				end
				expanded.Size = UDim2.fromOffset(478, math.min(content, 240))
			end
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				List = self.List,
				ListEnabled = self.ListEnabled
			}
		end

		function optionapi:Load(tab)
			self.List = table.clone(tab.List or {})
			self.ListEnabled = table.clone(tab.ListEnabled or {})
			rebuild()
			settings.Function(self.List)
		end

		if settings.Visible == false then
			row.Visible = false
		end
		rebuild()
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	Font = function(children, settings, api)
		local optionapi = {
			Type = 'Font',
			Value = Font.new('Arial'),
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local value = Instance.new('TextLabel')
		value.Size = UDim2.fromOffset(170, 40)
		value.Position = UDim2.new(1, -34, 0, 0)
		value.AnchorPoint = Vector2.new(1, 0)
		value.BackgroundTransparency = 1
		value.Text = 'Arial'
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.TextColor3 = color.Dark(uipallet.Text, 0.43)
		value.TextSize = 12
		value.FontFace = uipallet.Font
		value.Parent = row
		local arrow = Instance.new('TextLabel')
		arrow.Size = UDim2.fromOffset(14, 40)
		arrow.Position = UDim2.new(1, -20, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = '▼'
		arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
		arrow.TextSize = 9
		arrow.FontFace = uipallet.Font
		arrow.Parent = row
		local window = children.Parent
		local dropdown = Instance.new('Frame')
		dropdown.Name = 'Dropdown'
		dropdown.Size = UDim2.fromOffset(478, 0)
		dropdown.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
		dropdown.BorderSizePixel = 0
		dropdown.Visible = false
		dropdown.ZIndex = 8
		dropdown.Parent = window
		addCorner(dropdown, UDim.new(0, 4))
		local list = Instance.new('ScrollingFrame')
		list.Size = UDim2.fromScale(1, 1)
		list.BackgroundTransparency = 1
		list.BorderSizePixel = 0
		list.ScrollBarThickness = 2
		list.ScrollBarImageTransparency = 0.75
		list.AutomaticCanvasSize = Enum.AutomaticSize.Y
		list.CanvasSize = UDim2.fromOffset(0, 0)
		list.Parent = dropdown
		local listlayout = Instance.new('UIListLayout')
		listlayout.SortOrder = Enum.SortOrder.LayoutOrder
		listlayout.Padding = UDim.new(0, 2)
		listlayout.Parent = list
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		local fonts = {}
		for _, font in Enum.Font:GetEnumItems() do
			if font.Name ~= (settings.Blacklist or '') then
				table.insert(fonts, font)
			end
		end

		local function openDropdown()
			local pos = row.AbsolutePosition - window.AbsolutePosition
			dropdown.Position = UDim2.fromOffset(pos.X, pos.Y + 40)
			dropdown.Size = UDim2.fromOffset(478, math.min(#fonts * 32 + 4, 240))
			dropdown.Visible = true
		end

		for i, font in fonts do
			local item = Instance.new('TextButton')
			item.Name = font.Name
			item.Size = UDim2.fromOffset(478, 30)
			item.BackgroundColor3 = Color3.new(1, 1, 1)
			item.BackgroundTransparency = 1
			item.AutoButtonColor = false
			item.Text = ''
			item.LayoutOrder = i
			item.Parent = list
			local itemname = Instance.new('TextLabel')
			itemname.Size = UDim2.fromOffset(440, 30)
			itemname.Position = UDim2.fromOffset(10, 0)
			itemname.BackgroundTransparency = 1
			itemname.Text = font.Name
			itemname.TextXAlignment = Enum.TextXAlignment.Left
			itemname.TextColor3 = color.Dark(uipallet.Text, 0.16)
			itemname.TextSize = 13
			itemname.FontFace = Font.new(font.Name)
			itemname.Parent = item
			item.MouseEnter:Connect(function()
				item.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end)
			item.MouseLeave:Connect(function()
				item.BackgroundColor3 = Color3.new(1, 1, 1)
				item.BackgroundTransparency = 1
			end)
			item.MouseButton1Click:Connect(function()
				optionapi:SetValue(Font.new(font.Name), true)
				dropdown.Visible = false
			end)
		end

		function optionapi:SetValue(font, mouse)
			self.Value = font
			value.Text = font.Name
			settings.Function()
		end

		row.MouseButton1Click:Connect(function()
			if dropdown.Visible then
				dropdown.Visible = false
			else
				openDropdown()
			end
		end)

		if settings.Visible == false then
			row.Visible = false
		end
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	Targets = function(children, settings, api)
		local optionapi = {
			Type = 'Targets',
			Players = {Enabled = false},
			NPCs = {Enabled = false},
			Invisible = {Enabled = false},
			Walls = {Enabled = false},
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local arrow = Instance.new('TextLabel')
		arrow.Size = UDim2.fromOffset(14, 40)
		arrow.Position = UDim2.new(1, -20, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = '▼'
		arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
		arrow.TextSize = 9
		arrow.FontFace = uipallet.Font
		arrow.Parent = row
		local expanded = Instance.new('Frame')
		expanded.Name = 'Expanded'
		expanded.Size = UDim2.fromOffset(478, 0)
		expanded.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		expanded.BorderSizePixel = 0
		expanded.Visible = false
		expanded.Parent = children
		addCorner(expanded, UDim.new(0, 4))
		local list = Instance.new('UIListLayout')
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 2)
		list.Parent = expanded
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		local function createSub(subname, key, enabled)
			local subapi = {
				Name = subname,
				Enabled = enabled or false,
				Index = getTableSize(expanded:GetChildren())
			}
			local subrow = Instance.new('TextButton')
			subrow.Name = subname
			subrow.Size = UDim2.fromOffset(458, 30)
			subrow.Position = UDim2.fromOffset(10, 0)
			subrow.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			subrow.AutoButtonColor = false
			subrow.Text = ''
			subrow.Parent = expanded
			addCorner(subrow, UDim.new(0, 4))
			local subname2 = Instance.new('TextLabel')
			subname2.Size = UDim2.fromOffset(350, 30)
			subname2.Position = UDim2.fromOffset(10, 0)
			subname2.BackgroundTransparency = 1
			subname2.Text = subname
			subname2.TextXAlignment = Enum.TextXAlignment.Left
			subname2.TextColor3 = color.Dark(uipallet.Text, 0.16)
			subname2.TextSize = 13
			subname2.FontFace = uipallet.Font
			subname2.Parent = subrow
			local knob = Instance.new('Frame')
			knob.Name = 'Knob'
			knob.Size = UDim2.fromOffset(36, 18)
			knob.Position = UDim2.new(1, -10, 0.5, 0)
			knob.AnchorPoint = Vector2.new(1, 0.5)
			knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
			knob.BorderSizePixel = 0
			knob.Parent = subrow
			addCorner(knob, UDim.new(1, 0))
			local knobinner = Instance.new('Frame')
			knobinner.Name = 'KnobInner'
			knobinner.Size = UDim2.fromOffset(28, 14)
			knobinner.Position = UDim2.fromOffset(3, 2)
			knobinner.BackgroundColor3 = color.Light(uipallet.Main, 0.5)
			knobinner.BorderSizePixel = 0
			knobinner.Parent = knob
			addCorner(knobinner, UDim.new(1, 0))
			subapi.Object = subrow
			subapi.Knob = knob

			function subapi:Toggle()
				self.Enabled = not self.Enabled
				if self.Enabled then
					local accent = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
					knob.BackgroundColor3 = accent
					knobinner.BackgroundColor3 = color.Light(accent, 0.65)
					tween:Tween(knobinner, uipallet.Tween, {
						Position = UDim2.fromOffset(5, 2)
					})
				else
					knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
					knobinner.BackgroundColor3 = color.Light(uipallet.Main, 0.5)
					tween:Tween(knobinner, uipallet.Tween, {
						Position = UDim2.fromOffset(3, 2)
					})
				end
				settings.Function(self.Enabled)
			end

			function subapi:Color(h, s, v, rainbow)
				if self.Enabled then
					knob.BackgroundColor3 = accentColor(h, s, v, rainbow, subapi.Index)
					knobinner.BackgroundColor3 = color.Light(accentColor(h, s, v, rainbow, subapi.Index), 0.65)
				end
			end

			subrow.MouseButton1Click:Connect(function()
				subapi:Toggle()
			end)

			optionapi[key] = subapi
		end

		createSub('Players', 'Players', settings.Players)
		createSub('NPCs', 'NPCs', settings.NPCs)
		createSub('Invisible', 'Invisible', settings.Invisible)
		createSub('Walls', 'Walls', settings.Walls)

		row.MouseButton1Click:Connect(function()
			expanded.Visible = not expanded.Visible
			arrow.Rotation = expanded.Visible and 180 or 0
			if expanded.Visible then
				expanded.Size = UDim2.fromOffset(478, 128)
			end
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				Players = self.Players.Enabled,
				NPCs = self.NPCs.Enabled,
				Invisible = self.Invisible.Enabled,
				Walls = self.Walls.Enabled
			}
		end

		function optionapi:Load(tab)
			for key, sub in {Players = self.Players, NPCs = self.NPCs, Invisible = self.Invisible, Walls = self.Walls} do
				if sub.Enabled ~= tab[key] then
					sub:Toggle()
				end
			end
		end

		function optionapi:Color(h, s, v, rainbow)
			for _, sub in {self.Players, self.NPCs, self.Invisible, self.Walls} do
				if sub.Enabled then
					sub:Color(h, s, v, rainbow)
				end
			end
		end

		if settings.Visible == false then
			row.Visible = false
		end
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	Button = function(children, settings, api)
		local optionapi = {
			Enabled = false,
			Index = getTableSize(api.Options)
		}
		local button = Instance.new('TextButton')
		button.Name = settings.Name
		button.Size = UDim2.fromOffset(478, 40)
		button.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		button.BorderSizePixel = 0
		button.AutoButtonColor = false
		button.Text = settings.Name
		button.TextColor3 = color.Dark(uipallet.Text, 0.16)
		button.TextSize = 14
		button.FontFace = uipallet.Font
		button.Parent = children
		addCorner(button, UDim.new(0, 4))
		local arrow = Instance.new('TextLabel')
		arrow.Size = UDim2.fromOffset(14, 40)
		arrow.Position = UDim2.new(1, -20, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = '›'
		arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
		arrow.TextSize = 16
		arrow.FontFace = uipallet.Font
		arrow.Parent = button
		optionapi.Name = settings.Name
		optionapi.Object = button
		button.MouseButton1Click:Connect(function()
			settings.Function()
		end)
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		end)
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		end)
		if settings.Visible == false then
			button.Visible = false
		end
		api.Options[settings.Name] = optionapi
		addTooltip(button, settings.Tooltip)

		return optionapi
	end,
	Divider = function(children, text)
		local divider = Instance.new('Frame')
		divider.Name = 'Divider'
		divider.Size = UDim2.fromOffset(478, 26)
		divider.BackgroundTransparency = 1
		divider.BorderSizePixel = 0
		divider.Parent = children
		local left = Instance.new('Frame')
		left.Size = UDim2.new(0.5, -70, 0, 1)
		left.Position = UDim2.fromOffset(10, 13)
		left.BackgroundColor3 = Color3.new(1, 1, 1)
		left.BackgroundTransparency = 0.93
		left.BorderSizePixel = 0
		left.Parent = divider
		local label = Instance.new('TextLabel')
		label.Size = UDim2.fromOffset(120, 26)
		label.Position = UDim2.fromScale(0.5, 0)
		label.AnchorPoint = Vector2.new(0.5, 0)
		label.BackgroundTransparency = 1
		label.Text = text or ''
		label.TextColor3 = color.Dark(uipallet.Text, 0.43)
		label.TextSize = 10
		label.FontFace = uipallet.FontSemiBold
		label.Parent = divider
		local right = left:Clone()
		right.Position = UDim2.new(0.5, 70, 0, 13)
		right.Parent = divider
	end,
	AddOption = function(children, settings, api)
		local optionapi = {
			Type = 'AddOption',
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('Frame')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		row.BorderSizePixel = 0
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(478, 40)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Center
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		optionapi.Object = row
		api.Options[settings.Name] = optionapi

		return optionapi
	end,
	AddList = function(children, settings, api)
		local optionapi = {
			Type = 'AddList',
			List = {},
			ListEnabled = {},
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(250, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local count = Instance.new('TextLabel')
		count.Size = UDim2.fromOffset(120, 40)
		count.Position = UDim2.new(1, -34, 0, 0)
		count.AnchorPoint = Vector2.new(1, 0)
		count.BackgroundTransparency = 1
		count.Text = '0'
		count.TextXAlignment = Enum.TextXAlignment.Right
		count.TextColor3 = color.Dark(uipallet.Text, 0.43)
		count.TextSize = 12
		count.FontFace = uipallet.Font
		count.Parent = row
		local arrow = Instance.new('TextLabel')
		arrow.Size = UDim2.fromOffset(14, 40)
		arrow.Position = UDim2.new(1, -20, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = '▼'
		arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
		arrow.TextSize = 9
		arrow.FontFace = uipallet.Font
		arrow.Parent = row
		local expanded = Instance.new('Frame')
		expanded.Name = 'Expanded'
		expanded.Size = UDim2.fromOffset(478, 0)
		expanded.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		expanded.BorderSizePixel = 0
		expanded.Visible = false
		expanded.Parent = children
		addCorner(expanded, UDim.new(0, 4))
		settings.Function = settings.Function or function() end
		optionapi.Object = row

		local function rebuild()
			for _, v in expanded:GetChildren() do
				if v:IsA('TextButton') or v:IsA('Frame') then
					v:Destroy()
				end
			end
			for i, v in optionapi.List do
				local item = Instance.new('TextButton')
				item.Name = 'Item'
				item.Size = UDim2.fromOffset(458, 30)
				item.Position = UDim2.fromOffset(10, 0)
				item.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				item.AutoButtonColor = false
				item.Text = ''
				item.LayoutOrder = i
				item.Parent = expanded
				addCorner(item, UDim.new(0, 4))
				local itemname = Instance.new('TextLabel')
				itemname.Size = UDim2.fromOffset(400, 30)
				itemname.Position = UDim2.fromOffset(10, 0)
				itemname.BackgroundTransparency = 1
				itemname.Text = v
				itemname.TextXAlignment = Enum.TextXAlignment.Left
				itemname.TextColor3 = color.Dark(uipallet.Text, 0.16)
				itemname.TextSize = 13
				itemname.FontFace = uipallet.Font
				itemname.Parent = item
				local dot = Instance.new('Frame')
				dot.Name = 'Dot'
				dot.Size = UDim2.fromOffset(8, 8)
				dot.Position = UDim2.new(1, -20, 0.5, 0)
				dot.AnchorPoint = Vector2.new(1, 0.5)
				dot.BackgroundColor3 = table.find(optionapi.ListEnabled, v) and Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value) or color.Light(uipallet.Main, 0.37)
				dot.BorderSizePixel = 0
				dot.Parent = item
				addCorner(dot, UDim.new(1, 0))
				item.MouseButton1Click:Connect(function()
					optionapi:ChangeValue(v)
				end)
			end
			count.Text = tostring(#optionapi.List)
		end

		function optionapi:ChangeValue(val)
			if val then
				local ind = table.find(self.List, val)
				if ind then
					table.remove(self.List, ind)
					ind = table.find(self.ListEnabled, val)
					if ind then
						table.remove(self.ListEnabled, ind)
					end
				else
					table.insert(self.List, val)
					table.insert(self.ListEnabled, val)
				end
			end
			rebuild()
			settings.Function(self.List)
		end

		row.MouseButton1Click:Connect(function()
			expanded.Visible = not expanded.Visible
			arrow.Rotation = expanded.Visible and 180 or 0
			if expanded.Visible then
				local content = 0
				for _, v in expanded:GetChildren() do
					if v:IsA('TextButton') or v:IsA('Frame') then
						content += v.Size.Y.Offset + 2
					end
				end
				expanded.Size = UDim2.fromOffset(478, math.min(content, 240))
			end
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				List = self.List,
				ListEnabled = self.ListEnabled
			}
		end

		function optionapi:Load(tab)
			self.List = table.clone(tab.List or {})
			self.ListEnabled = table.clone(tab.ListEnabled or {})
			rebuild()
			settings.Function(self.List)
		end

		rebuild()
		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end,
	AddItem = function(children, settings, api)
		local optionapi = {
			Name = settings.Name,
			Enabled = settings.Enabled or false,
			Index = getTableSize(api.Options)
		}
		local row = Instance.new('TextButton')
		row.Name = settings.Name
		row.Size = UDim2.fromOffset(478, 40)
		row.BackgroundColor3 = settings.Darker and color.Dark(uipallet.Main, 0.02) or uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = children
		addCorner(row, UDim.new(0, 4))
		local name = Instance.new('TextLabel')
		name.Size = UDim2.fromOffset(300, 40)
		name.Position = UDim2.fromOffset(10, 0)
		name.BackgroundTransparency = 1
		name.Text = settings.Name
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextColor3 = color.Dark(uipallet.Text, 0.16)
		name.TextSize = 14
		name.FontFace = uipallet.Font
		name.Parent = row
		local knob = Instance.new('Frame')
		knob.Name = 'Knob'
		knob.Size = UDim2.fromOffset(36, 18)
		knob.Position = UDim2.new(1, -10, 0.5, 0)
		knob.AnchorPoint = Vector2.new(1, 0.5)
		knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		knob.BorderSizePixel = 0
		knob.Parent = row
		addCorner(knob, UDim.new(1, 0))
		local knobinner = Instance.new('Frame')
		knobinner.Name = 'KnobInner'
		knobinner.Size = UDim2.fromOffset(28, 14)
		knobinner.Position = UDim2.fromOffset(3, 2)
		knobinner.BackgroundColor3 = color.Light(uipallet.Main, 0.5)
		knobinner.BorderSizePixel = 0
		knobinner.Parent = knob
		addCorner(knobinner, UDim.new(1, 0))
		settings.Function = settings.Function or function() end
		optionapi.Object = row
		optionapi.Knob = knob

		function optionapi:Toggle()
			self.Enabled = not self.Enabled
			if self.Enabled then
				local accent = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
				knob.BackgroundColor3 = accent
				knobinner.BackgroundColor3 = color.Light(accent, 0.65)
				tween:Tween(knobinner, uipallet.Tween, {
					Position = UDim2.fromOffset(5, 2)
				})
			else
				knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
				knobinner.BackgroundColor3 = color.Light(uipallet.Main, 0.5)
				tween:Tween(knobinner, uipallet.Tween, {
					Position = UDim2.fromOffset(3, 2)
				})
			end
			settings.Function(self.Enabled)
		end

		row.MouseButton1Click:Connect(function()
			optionapi:Toggle()
		end)

		function optionapi:Save(tab)
			tab[settings.Name] = {
				Enabled = self.Enabled
			}
		end

		function optionapi:Load(tab)
			if self.Enabled ~= tab.Enabled then
				self:Toggle()
			end
		end

		api.Options[settings.Name] = optionapi
		addTooltip(row, settings.Tooltip)

		return optionapi
	end
}

mainapi.Components = setmetatable({}, {
	__newindex = function(tab, ind, func)
		for _, v in mainapi.Modules do
			rawset(v, 'Create'..ind, func)
		end
		for _, v in mainapi.Legit.Modules do
			rawset(v, 'Create'..ind, func)
		end
		rawset(tab, ind, func)
	end
})

task.spawn(function()
	local hue = 0
	while true do
		task.wait(1 / mainapi.RainbowUpdateSpeed.Value)
		if mainapi.Loaded ~= nil and mainapi.GUIColor.Rainbow then
			hue = (tick() * (0.2 * mainapi.RainbowSpeed.Value)) % 1
			mainapi.RainbowHue = hue
			mainapi:UpdateGUI(hue, 1, 1)
		end
	end
end)

addMaid(mainapi)

local gui = Instance.new('ScreenGui')
gui.Name = 'SkidV5'
gui.DisplayOrder = 2147483647
gui.IgnoreGuiInset = true
pcall(function()
	gui.Parent = game:GetService('CoreGui')
end)
if not gui.Parent then
	gui.Parent = players.LocalPlayer:WaitForChild('PlayerGui')
end
mainapi.gui = gui

local scaledgui = Instance.new('Frame')
scaledgui.Name = 'ScaledGui'
scaledgui.Size = UDim2.fromScale(1, 1)
scaledgui.BackgroundTransparency = 1
scaledgui.BorderSizePixel = 0
scaledgui.Parent = gui
local scale = Instance.new('UIScale')
scale.Parent = scaledgui

local blurframe = Instance.new('Frame')
blurframe.Name = 'BlurFrame'
blurframe.Size = UDim2.fromScale(1, 1)
blurframe.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
blurframe.BackgroundTransparency = 0.5
blurframe.BorderSizePixel = 0
blurframe.Visible = false
blurframe.Parent = scaledgui
addBlur(blurframe)

local toolblur = Instance.new('Frame')
toolblur.Name = 'TooltipBlur'
toolblur.Size = UDim2.fromOffset(0, 0)
toolblur.BackgroundColor3 = Color3.new()
toolblur.BackgroundTransparency = 0.5
toolblur.BorderSizePixel = 0
toolblur.Visible = false
toolblur.Parent = scaledgui
addBlur(toolblur)
addCorner(toolblur, UDim.new(0, 4))

local tooltip = Instance.new('TextLabel')
tooltip.Name = 'Tooltip'
tooltip.Size = UDim2.fromOffset(0, 0)
tooltip.Position = UDim2.fromOffset(10, 10)
tooltip.ZIndex = 6
tooltip.BackgroundTransparency = 1
tooltip.TextColor3 = uipallet.Text
tooltip.TextSize = 13
tooltip.FontFace = uipallet.Font
tooltip.Visible = false
tooltip.Parent = scaledgui

notifications.Name = 'Notifications'
notifications.Size = UDim2.fromScale(1, 1)
notifications.BackgroundTransparency = 1
notifications.BorderSizePixel = 0
notifications.Parent = scaledgui

local overlaybar

function mainapi:BlurCheck()
	blurframe.Visible = clickgui.Visible and mainapi.Blur and mainapi.Blur.Enabled
	if overlaybar then
		overlaybar.Visible = clickgui.Visible and mainapi.OverlaysButton and mainapi.OverlaysButton.Enabled
	end
end

local function createModule(children, modulesettings, api, width)
	local moduleapi = {
		Type = 'Module',
		Enabled = false,
		Index = getTableSize(api.Modules),
		Options = {},
		Category = api.Name,
		Bind = {}
	}
	modulesettings.Function = modulesettings.Function or function() end
	local row = Instance.new('TextButton')
	row.Name = modulesettings.Name
	row.Size = UDim2.fromOffset(width, 40)
	row.BackgroundColor3 = uipallet.Main
	row.BorderSizePixel = 0
	row.AutoButtonColor = false
	row.Text = ''
	row.Parent = children
	addCorner(row, UDim.new(0, 4))
	local rowgradient = Instance.new('UIGradient')
	rowgradient.Enabled = false
	rowgradient.Parent = row
	local name = Instance.new('TextLabel')
	name.Size = UDim2.fromOffset(width - 140, 40)
	name.Position = UDim2.fromOffset(10, 0)
	name.BackgroundTransparency = 1
	name.Text = modulesettings.Name
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.TextColor3 = color.Dark(uipallet.Text, 0.16)
	name.TextSize = 14
	name.FontFace = uipallet.Font
	name.Parent = row
	local dots = Instance.new('Frame')
	dots.Name = 'Dots'
	dots.Size = UDim2.fromOffset(25, 40)
	dots.Position = UDim2.new(1, -25, 0, 0)
	dots.BackgroundTransparency = 1
	dots.Parent = row
	local dotsimage = Instance.new('ImageLabel')
	dotsimage.Name = 'Dots'
	dotsimage.Size = UDim2.fromOffset(3, 16)
	dotsimage.Position = UDim2.fromOffset(11, 12)
	dotsimage.BackgroundTransparency = 1
	dotsimage.Image = getcustomasset('skidv5/assets/new/dots.png')
	dotsimage.ImageColor3 = color.Light(uipallet.Main, 0.37)
	dotsimage.Parent = dots
	local bind = Instance.new('TextButton')
	bind.Name = 'Bind'
	bind.Size = UDim2.fromOffset(20, 20)
	bind.Position = UDim2.new(1, -30, 0.5, 0)
	bind.AnchorPoint = Vector2.new(1, 0.5)
	bind.BackgroundColor3 = Color3.new(1, 1, 1)
	bind.BackgroundTransparency = 0.94
	bind.BorderSizePixel = 0
	bind.AutoButtonColor = false
	bind.Text = ''
	bind.Visible = false
	bind.Parent = row
	addCorner(bind, UDim.new(0, 4))
	local bindicon = Instance.new('ImageLabel')
	bindicon.Name = 'Icon'
	bindicon.Size = UDim2.fromOffset(10, 10)
	bindicon.Position = UDim2.fromOffset(5, 5)
	bindicon.BackgroundTransparency = 1
	bindicon.Image = getcustomasset('skidv5/assets/new/bind.png')
	bindicon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
	bindicon.Parent = bind
	local bindtext = Instance.new('TextLabel')
	bindtext.Name = 'TextLabel'
	bindtext.Size = UDim2.fromScale(1, 1)
	bindtext.Position = UDim2.fromOffset(0, 1)
	bindtext.BackgroundTransparency = 1
	bindtext.Visible = false
	bindtext.Text = ''
	bindtext.TextColor3 = color.Dark(uipallet.Text, 0.43)
	bindtext.TextSize = 9
	bindtext.FontFace = uipallet.FontSemiBold
	bindtext.Parent = bind
	row.LayoutOrder = moduleapi.Index
	moduleapi.Object = row
	moduleapi.Name = modulesettings.Name

	bind.MouseEnter:Connect(function()
		bindtext.Visible = false
		bindicon.Visible = true
		bindicon.Image = getcustomasset('skidv5/assets/new/edit.png')
	end)
	bind.MouseLeave:Connect(function()
		bindtext.Visible = #moduleapi.Bind > 0
		bindicon.Visible = not bindtext.Visible
		bindicon.Image = getcustomasset('skidv5/assets/new/bind.png')
	end)
	bind.MouseButton1Click:Connect(function()
		mainapi.Binding = moduleapi
	end)

	function moduleapi:SetBind(tab, mouse)
		if type(tab) ~= 'table' then
			tab = {}
		end
		self.Bind = tab
		bindtext.Text = table.concat(tab, ' + '):upper()
		bindtext.Visible = #tab > 0
		bindicon.Visible = not bindtext.Visible
		bind.Size = UDim2.fromOffset(math.max(getfontsize(bindtext.Text, 9, uipallet.Font).X + 14, 20), 20)
		bind.Visible = #tab > 0
	end

	local function restyle()
		if moduleapi.Enabled then
			row.BackgroundColor3 = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
			row.TextColor3 = mainapi:TextColor(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
			name.TextColor3 = row.TextColor3
			bindtext.TextColor3 = row.TextColor3
			bindicon.ImageColor3 = row.TextColor3
			dotsimage.ImageColor3 = row.TextColor3
		else
			row.BackgroundColor3 = uipallet.Main
			name.TextColor3 = color.Dark(uipallet.Text, 0.16)
			bindtext.TextColor3 = color.Dark(uipallet.Text, 0.43)
			bindicon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
			dotsimage.ImageColor3 = color.Light(uipallet.Main, 0.37)
		end
	end

	function moduleapi:Toggle(arg)
		self.Enabled = not self.Enabled
		restyle()
		modulesettings.Function(self.Enabled)
		if not arg and mainapi.ToggleNotifications and mainapi.ToggleNotifications.Enabled then
			mainapi:CreateNotification('Module Toggled', modulesettings.Name.."<font color='#FFFFFF'> has been </font>"..(self.Enabled and "<font color='#5AFF5A'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>").."<font color='#FFFFFF'>!</font>", 0.75)
		end
		mainapi:UpdateTextGUI()
	end

	row.MouseButton1Click:Connect(function()
		moduleapi:Toggle()
	end)
	row.MouseEnter:Connect(function()
		if not moduleapi.Enabled then
			row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		end
	end)
	row.MouseLeave:Connect(function()
		if not moduleapi.Enabled then
			row.BackgroundColor3 = uipallet.Main
		end
	end)

	for name, comp in components do
		if name ~= 'Divider' then
			moduleapi['Create'..name] = function(settings)
				return comp(children, settings, moduleapi)
			end
		end
	end

	addMaid(moduleapi)
	api.Modules[modulesettings.Name] = moduleapi
	addTooltip(row, modulesettings.Tooltip)

	return moduleapi
end

function mainapi:CreateCategory(categorysettings)
	local categoryapi = {
		Type = 'Category',
		Expanded = false,
		Options = {},
		Buttons = {},
		Modules = {},
		Name = categorysettings.Name
	}
	local window = Instance.new('Frame')
	window.Name = categorysettings.Name
	window.Size = UDim2.fromOffset(490, 41)
	window.Position = UDim2.fromOffset(0, 0)
	window.BackgroundTransparency = 1
	window.BorderSizePixel = 0
	window.Visible = false
	window.Parent = contentcontainer
	categoryapi.Icon = categorysettings.Icon
	local title = Instance.new('TextLabel')
	title.Size = UDim2.fromOffset(300, 41)
	title.Position = UDim2.fromOffset(12, 0)
	title.BackgroundTransparency = 1
	title.Text = categorysettings.Name
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = color.Dark(uipallet.Text, 0.16)
	title.TextSize = 14
	title.FontFace = uipallet.FontSemiBold
	title.Parent = window
	local arrowbutton = Instance.new('TextButton')
	arrowbutton.Name = 'Arrow'
	arrowbutton.Size = UDim2.fromOffset(40, 41)
	arrowbutton.Position = UDim2.new(1, -40, 0, 0)
	arrowbutton.BackgroundTransparency = 1
	arrowbutton.Text = ''
	arrowbutton.Parent = window
	local arrow = Instance.new('TextLabel')
	arrow.Size = UDim2.fromOffset(14, 41)
	arrow.Position = UDim2.fromOffset(13, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = '▼'
	arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
	arrow.TextSize = 9
	arrow.FontFace = uipallet.Font
	arrow.Parent = arrowbutton
	local divider = Instance.new('Frame')
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.fromOffset(0, 40)
	divider.BackgroundColor3 = Color3.new(1, 1, 1)
	divider.BackgroundTransparency = 0.93
	divider.BorderSizePixel = 0
	divider.Parent = window
	local windowlist = Instance.new('ScrollingFrame')
	windowlist.Name = 'Children'
	windowlist.Size = UDim2.new(1, 0, 1, -41)
	windowlist.Position = UDim2.fromOffset(0, 41)
	windowlist.BackgroundTransparency = 1
	windowlist.BorderSizePixel = 0
	windowlist.ScrollBarThickness = 2
	windowlist.ScrollBarImageTransparency = 0.75
	windowlist.AutomaticCanvasSize = Enum.AutomaticSize.Y
	windowlist.CanvasSize = UDim2.fromOffset(0, 0)
	windowlist.Parent = window
	local listlayout = Instance.new('UIListLayout')
	listlayout.SortOrder = Enum.SortOrder.LayoutOrder
	listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listlayout.Padding = UDim.new(0, 3)
	listlayout.Parent = windowlist
	categoryapi.Window = window
	categoryapi.Object = window
	categoryapi.Content = windowlist
	categorysettings.Window = window
	categorysettings.Function = categorysettings.Function or function() end

	local function resize()
		if mainapi.ThreadFix then
			setthreadidentity(8)
		end
		local height = categoryapi.Expanded and windowlist.AbsoluteContentSize.Y / scale.Scale or 0
		window.Size = UDim2.fromOffset(490, math.min(41 + height, 427))
		windowlist.Size = UDim2.new(1, 0, 1, -41)
	end
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(resize)

	arrowbutton.MouseButton1Click:Connect(function()
		categoryapi.Expanded = not categoryapi.Expanded
		windowlist.Visible = categoryapi.Expanded
		arrow.Rotation = categoryapi.Expanded and 180 or 0
		resize()
	end)

	for name, comp in components do
		if name ~= 'Divider' then
			categoryapi['Create'..name] = function(settings)
				return comp(windowlist, settings, categoryapi)
			end
		end
	end

	function categoryapi:CreateDivider(text)
		return components.Divider(windowlist, text)
	end

	function categoryapi:CreateModule(modulesettings)
		local module = createModule(windowlist, modulesettings, categoryapi, 478)
		mainapi.Modules[module.Name] = module
		return module
	end

	categoryapi.Update = Instance.new('BindableEvent')
	categoryapi.ColorUpdate = Instance.new('BindableEvent')
	mainapi.Categories[categorysettings.Name] = categoryapi
	table.insert(mainapi.Windows, window)
	addMaid(categoryapi)

	return categoryapi
end

function mainapi:CreateCategoryList(categorysettings)
	local categoryapi = {
		Type = 'CategoryList',
		Expanded = false,
		List = {},
		ListEnabled = {},
		Objects = {},
		Options = {},
		Modules = {},
		Name = categorysettings.Name
	}
	categorysettings.Color = categorysettings.Color or Color3.fromRGB(5, 134, 105)
	categoryapi.Icon = categorysettings.Icon
	local window = Instance.new('Frame')
	window.Name = categorysettings.Name
	window.Size = UDim2.fromOffset(490, 41)
	window.Position = UDim2.fromOffset(0, 0)
	window.BackgroundTransparency = 1
	window.BorderSizePixel = 0
	window.Visible = false
	window.Parent = contentcontainer
	local title = Instance.new('TextLabel')
	title.Size = UDim2.fromOffset(300, 41)
	title.Position = UDim2.fromOffset(12, 0)
	title.BackgroundTransparency = 1
	title.Text = categorysettings.Name
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = color.Dark(uipallet.Text, 0.16)
	title.TextSize = 14
	title.FontFace = uipallet.FontSemiBold
	title.Parent = window
	local arrowbutton = Instance.new('TextButton')
	arrowbutton.Name = 'Arrow'
	arrowbutton.Size = UDim2.fromOffset(40, 41)
	arrowbutton.Position = UDim2.new(1, -40, 0, 0)
	arrowbutton.BackgroundTransparency = 1
	arrowbutton.Text = ''
	arrowbutton.Parent = window
	local arrow = Instance.new('TextLabel')
	arrow.Size = UDim2.fromOffset(14, 41)
	arrow.Position = UDim2.fromOffset(13, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = '▼'
	arrow.TextColor3 = color.Light(uipallet.Main, 0.37)
	arrow.TextSize = 9
	arrow.FontFace = uipallet.Font
	arrow.Parent = arrowbutton
	local divider = Instance.new('Frame')
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.fromOffset(0, 40)
	divider.BackgroundColor3 = Color3.new(1, 1, 1)
	divider.BackgroundTransparency = 0.93
	divider.BorderSizePixel = 0
	divider.Parent = window
	local windowlist = Instance.new('ScrollingFrame')
	windowlist.Name = 'Children'
	windowlist.Size = UDim2.new(1, 0, 1, -41)
	windowlist.Position = UDim2.fromOffset(0, 41)
	windowlist.BackgroundTransparency = 1
	windowlist.BorderSizePixel = 0
	windowlist.ScrollBarThickness = 2
	windowlist.ScrollBarImageTransparency = 0.75
	windowlist.AutomaticCanvasSize = Enum.AutomaticSize.Y
	windowlist.CanvasSize = UDim2.fromOffset(0, 0)
	windowlist.Parent = window
	local listlayout = Instance.new('UIListLayout')
	listlayout.SortOrder = Enum.SortOrder.LayoutOrder
	listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listlayout.Padding = UDim.new(0, 3)
	listlayout.Parent = windowlist
	local addbkg = Instance.new('Frame')
	addbkg.Name = 'Add'
	addbkg.Size = UDim2.fromOffset(484, 31)
	addbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	addbkg.BorderSizePixel = 0
	addbkg.LayoutOrder = 1
	addbkg.Parent = windowlist
	addCorner(addbkg)
	local addvalue = Instance.new('TextBox')
	addvalue.Name = 'Value'
	addvalue.Size = UDim2.new(1, -60, 1, 0)
	addvalue.Position = UDim2.fromOffset(10, 0)
	addvalue.BackgroundTransparency = 1
	addvalue.Text = ''
	addvalue.PlaceholderText = categorysettings.Placeholder or 'Add entry...'
	addvalue.PlaceholderColor3 = color.Dark(uipallet.Text, 0.43)
	addvalue.TextColor3 = color.Dark(uipallet.Text, 0.16)
	addvalue.TextSize = 13
	addvalue.FontFace = uipallet.Font
	addvalue.TextXAlignment = Enum.TextXAlignment.Left
	addvalue.ClearTextOnFocus = true
	addvalue.Parent = addbkg
	local addbutton = Instance.new('ImageButton')
	addbutton.Name = 'AddButton'
	addbutton.Size = UDim2.fromOffset(16, 16)
	addbutton.Position = UDim2.new(1, -26, 0, 8)
	addbutton.BackgroundTransparency = 1
	addbutton.AutoButtonColor = false
	addbutton.Image = getcustomasset('skidv5/assets/new/add.png')
	addbutton.ImageColor3 = categorysettings.Color
	addbutton.ImageTransparency = 0.3
	addbutton.Parent = addbkg
	categoryapi.Window = window
	categoryapi.Object = window
	categoryapi.Content = windowlist
	categorysettings.Window = window
	categorysettings.Function = categorysettings.Function or function() end

	local function resize()
		if mainapi.ThreadFix then
			setthreadidentity(8)
		end
		local height = categoryapi.Expanded and windowlist.AbsoluteContentSize.Y / scale.Scale or 0
		window.Size = UDim2.fromOffset(490, math.min(41 + height, 427))
		windowlist.Size = UDim2.new(1, 0, 1, -41)
	end
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(resize)

	arrowbutton.MouseButton1Click:Connect(function()
		categoryapi.Expanded = not categoryapi.Expanded
		windowlist.Visible = categoryapi.Expanded
		arrow.Rotation = categoryapi.Expanded and 180 or 0
		resize()
	end)

	local function createItemRow(v, ind)
		local profileitem = categorysettings.Profiles and v.Name or v
		local object = Instance.new('TextButton')
		object.Name = profileitem
		object.Size = UDim2.fromOffset(484, 33)
		object.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		object.AutoButtonColor = false
		object.Text = ''
		object.LayoutOrder = ind + 1
		object.Parent = windowlist
		addCorner(object)
		local dot = Instance.new('Frame')
		dot.Name = 'Dot'
		dot.Size = UDim2.fromOffset(10, 11)
		dot.Position = UDim2.fromOffset(12, 11)
		dot.BackgroundColor3 = color.Light(uipallet.Main, 0.37)
		dot.BorderSizePixel = 0
		dot.Parent = object
		addCorner(dot, UDim.new(1, 0))
		local objecttitle = Instance.new('TextLabel')
		objecttitle.Name = 'Title'
		objecttitle.Size = UDim2.new(1, -70, 1, 0)
		objecttitle.Position = UDim2.fromOffset(32, 0)
		objecttitle.BackgroundTransparency = 1
		objecttitle.Text = profileitem
		objecttitle.TextXAlignment = Enum.TextXAlignment.Left
		objecttitle.TextColor3 = color.Dark(uipallet.Text, 0.4)
		objecttitle.TextSize = 14
		objecttitle.FontFace = uipallet.Font
		objecttitle.Parent = object
		local dotsbutton = Instance.new('TextButton')
		dotsbutton.Name = 'Dots'
		dotsbutton.Size = UDim2.fromOffset(25, 33)
		dotsbutton.Position = UDim2.new(1, -25, 0, 0)
		dotsbutton.BackgroundTransparency = 1
		dotsbutton.Text = ''
		dotsbutton.Parent = object
		local dots = Instance.new('ImageLabel')
		dots.Name = 'Dots'
		dots.Size = UDim2.fromOffset(3, 16)
		dots.Position = UDim2.fromOffset(11, 9)
		dots.BackgroundTransparency = 1
		dots.Image = getcustomasset('skidv5/assets/new/dots.png')
		dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
		dots.Parent = dotsbutton
		local bind
		local itemapi = {
			Name = profileitem,
			Enabled = table.find(categoryapi.ListEnabled, profileitem) ~= nil,
			Object = object
		}
		local function restyle()
			local enabled = itemapi.Enabled
			dot.BackgroundColor3 = enabled and categorysettings.Color or color.Light(uipallet.Main, 0.37)
			objecttitle.TextColor3 = enabled and color.Dark(uipallet.Text, 0.16) or color.Dark(uipallet.Text, 0.4)
		end
		if categorysettings.Profiles then
			bind = Instance.new('TextButton')
			bind.Name = 'Bind'
			bind.Size = UDim2.fromOffset(20, 20)
			bind.Position = UDim2.new(1, -30, 0.5, 0)
			bind.AnchorPoint = Vector2.new(1, 0.5)
			bind.BackgroundColor3 = Color3.new(1, 1, 1)
			bind.BackgroundTransparency = 0.94
			bind.BorderSizePixel = 0
			bind.AutoButtonColor = false
			bind.Text = ''
			bind.Visible = false
			bind.Parent = object
			addCorner(bind, UDim.new(0, 4))
			local bindicon = Instance.new('ImageLabel')
			bindicon.Name = 'Icon'
			bindicon.Size = UDim2.fromOffset(10, 10)
			bindicon.Position = UDim2.fromOffset(5, 5)
			bindicon.BackgroundTransparency = 1
			bindicon.Image = getcustomasset('skidv5/assets/new/bind.png')
			bindicon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
			bindicon.Parent = bind
			local bindtext = Instance.new('TextLabel')
			bindtext.Name = 'TextLabel'
			bindtext.Size = UDim2.fromScale(1, 1)
			bindtext.Position = UDim2.fromOffset(0, 1)
			bindtext.BackgroundTransparency = 1
			bindtext.Visible = false
			bindtext.Text = ''
			bindtext.TextColor3 = color.Dark(uipallet.Text, 0.43)
			bindtext.TextSize = 9
			bindtext.FontFace = uipallet.FontSemiBold
			bindtext.Parent = bind
			local function setBind(tab, mouse)
				v.Bind = table.clone(tab)
				bindtext.Text = table.concat(v.Bind, ' + '):upper()
				bindtext.Visible = #v.Bind > 0
				bindicon.Visible = not bindtext.Visible
				bind.Size = UDim2.fromOffset(math.max(getfontsize(bindtext.Text, 9, uipallet.Font).X + 14, 20), 20)
				bind.Visible = #v.Bind > 0
			end
			setBind(v.Bind)
			bind.MouseButton1Click:Connect(function()
				mainapi.Binding = {SetBind = setBind, Bind = v.Bind}
			end)
			if profileitem == mainapi.Profile then
				categoryapi.Selected = itemapi
			end
		end
		object.MouseButton1Click:Connect(function()
			if categorysettings.Profiles then
				if profileitem ~= mainapi.Profile then
					mainapi:SetProfile(profileitem)
				end
			else
				local ind = table.find(categoryapi.ListEnabled, profileitem)
				if ind then
					table.remove(categoryapi.ListEnabled, ind)
				else
					table.insert(categoryapi.ListEnabled, profileitem)
				end
				itemapi.Enabled = ind == nil
				restyle()
				categorysettings.Function()
			end
		end)
		dotsbutton.MouseButton1Click:Connect(function()
			categoryapi:ChangeValue(profileitem)
		end)
		object.MouseEnter:Connect(function()
			object.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
			if bind then
				bind.Visible = true
			end
		end)
		object.MouseLeave:Connect(function()
			object.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			if bind then
				bind.Visible = #v.Bind > 0
			end
		end)
		restyle()
		table.insert(categoryapi.Objects, object)
	end

	function categoryapi:ChangeValue(val)
		if val then
			if categorysettings.Profiles then
				local ind
				for i, p in mainapi.Profiles do
					if p.Name == val then
						ind = i
						break
					end
				end
				if ind then
					if val ~= 'default' then
						table.remove(mainapi.Profiles, ind)
						if isfile('skidv5/profiles/'..val..mainapi.Place..'.txt') and delfile then
							delfile('skidv5/profiles/'..val..mainapi.Place..'.txt')
						end
					end
				else
					table.insert(mainapi.Profiles, {Name = val, Bind = {}})
				end
			else
				local ind = table.find(self.List, val)
				if ind then
					table.remove(self.List, ind)
					ind = table.find(self.ListEnabled, val)
					if ind then
						table.remove(self.ListEnabled, ind)
					end
				else
					table.insert(self.List, val)
					table.insert(self.ListEnabled, val)
				end
			end
		end
		categorysettings.Function()
		for _, v in self.Objects do
			pcall(v.Destroy, v)
		end
		table.clear(self.Objects)
		self.Selected = nil
		for i, v in (categorysettings.Profiles and mainapi.Profiles or self.List) do
			createItemRow(v.Name or v, i)
		end
		if categoryapi.Update then
			categoryapi.Update:Fire()
		end
		if categoryapi.ColorUpdate then
			categoryapi.ColorUpdate:Fire()
		end
	end

	addbutton.MouseButton1Click:Connect(function()
		if addvalue.Text ~= '' then
			categoryapi:ChangeValue(addvalue.Text)
			addvalue.Text = ''
		end
	end)
	addvalue.FocusLost:Connect(function(enter)
		if enter and addvalue.Text ~= '' then
			categoryapi:ChangeValue(addvalue.Text)
			addvalue.Text = ''
		end
	end)

	for name, comp in components do
		if name ~= 'Divider' then
			categoryapi['Create'..name] = function(settings)
				return comp(windowlist, settings, categoryapi)
			end
		end
	end

	function categoryapi:CreateDivider(text)
		return components.Divider(windowlist, text)
	end

	categoryapi.Update = Instance.new('BindableEvent')
	categoryapi.ColorUpdate = Instance.new('BindableEvent')
	mainapi.Categories[categorysettings.Name] = categoryapi
	table.insert(mainapi.Windows, window)
	addMaid(categoryapi)

	return categoryapi
end

function mainapi:CreateGUI()
	local categoryapi = {
		Type = 'Category',
		Expanded = false,
		Options = {},
		Buttons = {},
		Name = 'Main'
	}
	clickgui = Instance.new('Frame')
	clickgui.Name = 'ClickGui'
	clickgui.Size = UDim2.fromOffset(660, 520)
	clickgui.Position = UDim2.fromScale(0.5, 0.5)
	clickgui.AnchorPoint = Vector2.new(0.5, 0.5)
	clickgui.BackgroundColor3 = uipallet.Main
	clickgui.BorderSizePixel = 0
	clickgui.Visible = false
	clickgui.Parent = scaledgui
	addBlur(clickgui)
	addCorner(clickgui, UDim.new(0, 8))
	local mainstroke = Instance.new('UIStroke')
	mainstroke.Color = Color3.new(1, 1, 1)
	mainstroke.Transparency = 0.9
	mainstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainstroke.Parent = clickgui
	local header = Instance.new('Frame')
	header.Name = 'Header'
	header.Size = UDim2.new(1, 0, 0, 44)
	header.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
	header.BorderSizePixel = 0
	header.Parent = clickgui
	addCorner(header, UDim.new(0, 8))
	local headertitle = Instance.new('TextLabel')
	headertitle.Name = 'Title'
	headertitle.Size = UDim2.fromOffset(250, 44)
	headertitle.Position = UDim2.fromOffset(12, 0)
	headertitle.BackgroundTransparency = 1
	headertitle.Text = 'SKIDV5 LITE'
	headertitle.TextXAlignment = Enum.TextXAlignment.Left
	headertitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
	headertitle.TextSize = 15
	headertitle.FontFace = uipallet.FontSemiBold
	headertitle.Parent = header
	local version = Instance.new('TextLabel')
	version.Name = 'Version'
	version.Size = UDim2.fromOffset(80, 44)
	version.Position = UDim2.new(1, -160, 0, 0)
	version.AnchorPoint = Vector2.new(1, 0)
	version.BackgroundTransparency = 1
	version.Text = 'v'..mainapi.Version
	version.TextXAlignment = Enum.TextXAlignment.Right
	version.TextColor3 = color.Dark(uipallet.Text, 0.43)
	version.TextSize = 11
	version.FontFace = uipallet.Font
	version.Parent = header
	local settingsbutton = Instance.new('ImageButton')
	settingsbutton.Name = 'Settings'
	settingsbutton.Size = UDim2.fromOffset(16, 16)
	settingsbutton.Position = UDim2.new(1, -70, 0, 14)
	settingsbutton.BackgroundTransparency = 1
	settingsbutton.AutoButtonColor = false
	settingsbutton.Image = getcustomasset('skidv5/assets/new/guisettings.png')
	settingsbutton.ImageColor3 = color.Light(uipallet.Main, 0.37)
	settingsbutton.Parent = header
	local close = addCloseButton(header, 10)
	close.MouseButton1Click:Connect(function()
		clickgui.Visible = false
		mainapi:BlurCheck()
	end)
	makeDraggable(clickgui, header)
	local sidebar = Instance.new('Frame')
	sidebar.Name = 'Sidebar'
	sidebar.Size = UDim2.fromOffset(170, 476)
	sidebar.Position = UDim2.fromOffset(0, 44)
	sidebar.BackgroundColor3 = color.Dark(uipallet.Main, 0.04)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = clickgui
	addCorner(sidebar, UDim.new(0, 8))
	sidebarlist = Instance.new('ScrollingFrame')
	sidebarlist.Name = 'List'
	sidebarlist.Size = UDim2.fromOffset(170, 430)
	sidebarlist.Position = UDim2.fromOffset(0, 6)
	sidebarlist.BackgroundTransparency = 1
	sidebarlist.BorderSizePixel = 0
	sidebarlist.ScrollBarThickness = 2
	sidebarlist.ScrollBarImageTransparency = 0.75
	sidebarlist.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sidebarlist.CanvasSize = UDim2.fromOffset(0, 0)
	sidebarlist.Parent = sidebar
	local sidebarlayout = Instance.new('UIListLayout')
	sidebarlayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sidebarlayout.Padding = UDim.new(0, 4)
	sidebarlayout.Parent = sidebarlist
	local sidebarversion = Instance.new('TextLabel')
	sidebarversion.Size = UDim2.new(1, 0, 0, 20)
	sidebarversion.Position = UDim2.fromOffset(0, 452)
	sidebarversion.BackgroundTransparency = 1
	sidebarversion.Text = 'SKIDV5 LITE v'..mainapi.Version
	sidebarversion.TextColor3 = color.Dark(uipallet.Text, 0.43)
	sidebarversion.TextSize = 10
	sidebarversion.FontFace = uipallet.Font
	sidebarversion.Parent = sidebar
	local search = Instance.new('Frame')
	search.Name = 'Search'
	search.Size = UDim2.fromOffset(490, 49)
	search.Position = UDim2.fromOffset(170, 44)
	search.BackgroundTransparency = 1
	search.BorderSizePixel = 0
	search.Parent = clickgui
	local searchbkg = Instance.new('Frame')
	searchbkg.Name = 'Background'
	searchbkg.Size = UDim2.fromOffset(474, 37)
	searchbkg.Position = UDim2.fromOffset(8, 6)
	searchbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	searchbkg.BorderSizePixel = 0
	searchbkg.Parent = search
	addCorner(searchbkg, UDim.new(0, 6))
	local searchicon = Instance.new('ImageLabel')
	searchicon.Name = 'Icon'
	searchicon.Size = UDim2.fromOffset(14, 14)
	searchicon.Position = UDim2.fromOffset(14, 11)
	searchicon.BackgroundTransparency = 1
	searchicon.Image = getcustomasset('skidv5/assets/new/search.png')
	searchicon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
	searchicon.Parent = searchbkg
	local searchbox = Instance.new('TextBox')
	searchbox.Name = 'TextBox'
	searchbox.Size = UDim2.new(1, -44, 1, 0)
	searchbox.Position = UDim2.fromOffset(36, 0)
	searchbox.BackgroundTransparency = 1
	searchbox.Text = ''
	searchbox.PlaceholderText = 'Search modules...'
	searchbox.PlaceholderColor3 = color.Dark(uipallet.Text, 0.43)
	searchbox.TextColor3 = color.Dark(uipallet.Text, 0.16)
	searchbox.TextSize = 13
	searchbox.FontFace = uipallet.Font
	searchbox.TextXAlignment = Enum.TextXAlignment.Left
	searchbox.ClearTextOnFocus = false
	searchbox.Size = UDim2.new(1, -86, 1, 0)
	searchbox.Parent = searchbkg
	searchbkg.ZIndex = 2
	local legitdivider = Instance.new('Frame')
	legitdivider.Name = 'LegitDivider'
	legitdivider.Size = UDim2.fromOffset(2, 12)
	legitdivider.Position = UDim2.new(1, -40, 0.5, 0)
	legitdivider.AnchorPoint = Vector2.new(1, 0.5)
	legitdivider.BackgroundColor3 = color.Light(uipallet.Main, 0.11)
	legitdivider.BorderSizePixel = 0
	legitdivider.Parent = searchbkg
	local searchlegit = Instance.new('ImageButton')
	searchlegit.Name = 'Legit'
	searchlegit.Size = UDim2.fromOffset(29, 16)
	searchlegit.Position = UDim2.new(1, -34, 0.5, 0)
	searchlegit.AnchorPoint = Vector2.new(1, 0.5)
	searchlegit.BackgroundTransparency = 1
	searchlegit.Image = getcustomasset('skidv5/assets/new/legit.png')
	searchlegit.ImageColor3 = color.Dark(uipallet.Text, 0.43)
	searchlegit.Parent = searchbkg
	addTooltip(searchlegit, 'Open Legit mode')
	if mainapi.Legit then
		mainapi.Legit.Icon = searchlegit
	end
	searchlegit.MouseButton1Click:Connect(function()
		clickgui.Visible = false
		mainapi:BlurCheck()
		mainapi.Legit.Window.Visible = true
		mainapi.Legit.Window.Position = UDim2.fromScale(0.5, 0.5)
		mainapi.Legit.Window.AnchorPoint = Vector2.new(0.5, 0.5)
	end)
	local searchresults = Instance.new('ScrollingFrame')
	searchresults.Name = 'Results'
	searchresults.Size = UDim2.new(1, -16, 0, 0)
	searchresults.Position = UDim2.fromOffset(8, 44)
	searchresults.BackgroundTransparency = 1
	searchresults.BorderSizePixel = 0
	searchresults.ScrollBarThickness = 2
	searchresults.ScrollBarImageTransparency = 0.75
	searchresults.AutomaticCanvasSize = Enum.AutomaticSize.Y
	searchresults.CanvasSize = UDim2.fromOffset(0, 0)
	searchresults.Visible = false
	searchresults.Parent = searchbkg
	local searchlayout = Instance.new('UIListLayout')
	searchlayout.SortOrder = Enum.SortOrder.LayoutOrder
	searchlayout.Padding = UDim.new(0, 2)
	searchlayout.Parent = searchresults
	local function createSearchResult(moduleapi)
		local row = Instance.new('TextButton')
		row.Size = UDim2.new(1, 0, 0, 30)
		row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = searchresults
		addCorner(row, UDim.new(0, 4))
		local icon = Instance.new('ImageLabel')
		icon.Name = 'Icon'
		icon.Size = UDim2.fromOffset(16, 16)
		icon.Position = UDim2.fromOffset(7, 7)
		icon.BackgroundTransparency = 1
		icon.Image = getcustomasset('skidv5/assets/new/settings.png')
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		icon.Parent = row
		local title = Instance.new('TextLabel')
		title.Name = 'Title'
		title.Size = UDim2.new(1, -46, 1, 0)
		title.Position = UDim2.fromOffset(28, 0)
		title.BackgroundTransparency = 1
		title.Text = moduleapi.Name
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextColor3 = color.Dark(uipallet.Text, 0.29)
		title.TextSize = 13
		title.FontFace = uipallet.Font
		title.Parent = row
		row.MouseButton1Click:Connect(function()
			moduleapi:Toggle()
		end)
		row.MouseEnter:Connect(function()
			row.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
		end)
		row.MouseLeave:Connect(function()
			row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		end)
		return row
	end
	local function updateSearch()
		local text = searchbox.Text:lower()
		for i, v in searchresults:GetChildren() do
			if v:IsA('GuiObject') then
				v:Destroy()
			end
		end
		if #text < 2 then
			searchresults.Visible = false
			searchbkg.Size = UDim2.fromOffset(474, 37)
			return
		end
		local count = 0
		for i, v in mainapi.Modules do
			if v.Name:lower():find(text) then
				count = count + 1
				createSearchResult(v)
			end
		end
		searchresults.Size = UDim2.new(1, -16, 0, count * 32)
		searchbkg.Size = UDim2.fromOffset(474, math.min(37 + (count * 32) + 8, 437))
		searchresults.Visible = count > 0
	end
	searchbox:GetPropertyChangedSignal('Text'):Connect(updateSearch)
	searchbox.FocusLost:Connect(function(enter)
		if enter then
			for i, v in searchresults:GetChildren() do
				if v:IsA('GuiObject') then
					v:Destroy()
				end
			end
			searchresults.Visible = false
			searchbkg.Size = UDim2.fromOffset(474, 37)
		end
	end)
	local searchcoloring = task.spawn(function()
		while true do
			task.wait(0.1)
			if searchresults.Visible then
				for i, v in searchresults:GetChildren() do
					if v:IsA('TextButton') then
						local icon = v:FindFirstChild('Icon')
						local title = v:FindFirstChild('Title')
						if icon and title then
							if v.Enabled then
								icon.ImageColor3 = color.Light(uipallet.Text, 0)
								title.TextColor3 = uipallet.Text
							else
								icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
								title.TextColor3 = color.Dark(uipallet.Text, 0.29)
							end
						end
					end
				end
			end
		end
	end)
	mainapi:Clean(searchcoloring)
	contentcontainer = Instance.new('Frame')
	contentcontainer.Name = 'Content'
	contentcontainer.Size = UDim2.fromOffset(490, 427)
	contentcontainer.Position = UDim2.fromOffset(170, 93)
	contentcontainer.BackgroundTransparency = 1
	contentcontainer.BorderSizePixel = 0
	contentcontainer.Parent = clickgui
	settingspane = Instance.new('Frame')
	settingspane.Name = 'SettingsPane'
	settingspane.Size = UDim2.fromOffset(490, 427)
	settingspane.Position = UDim2.fromOffset(0, 0)
	settingspane.BackgroundColor3 = color.Light(uipallet.Main, 0.01)
	settingspane.BorderSizePixel = 0
	settingspane.Visible = false
	settingspane.Parent = contentcontainer
	addCorner(settingspane, UDim.new(0, 8))
	local settingsheader = Instance.new('TextLabel')
	settingsheader.Size = UDim2.fromOffset(150, 40)
	settingsheader.Position = UDim2.fromOffset(12, 0)
	settingsheader.BackgroundTransparency = 1
	settingsheader.Text = 'SETTINGS'
	settingsheader.TextXAlignment = Enum.TextXAlignment.Left
	settingsheader.TextColor3 = color.Dark(uipallet.Text, 0.16)
	settingsheader.TextSize = 13
	settingsheader.FontFace = uipallet.FontSemiBold
	settingsheader.Parent = settingspane
	local backbutton = Instance.new('ImageButton')
	backbutton.Name = 'Back'
	backbutton.Size = UDim2.fromOffset(14, 14)
	backbutton.Position = UDim2.new(1, -30, 0, 13)
	backbutton.BackgroundTransparency = 1
	backbutton.AutoButtonColor = false
	backbutton.Image = getcustomasset('skidv5/assets/new/back.png')
	backbutton.ImageColor3 = color.Light(uipallet.Main, 0.37)
	backbutton.MouseEnter:Connect(function()
		backbutton.ImageColor3 = uipallet.Text
	end)
	backbutton.MouseLeave:Connect(function()
		backbutton.ImageColor3 = color.Light(uipallet.Main, 0.37)
	end)
	backbutton.MouseButton1Click:Connect(function()
		settingspane.Visible = false
		if mainapi.OverlaysButton and mainapi.OverlaysButton.Enabled and overlaybar then
			overlaybar.Visible = clickgui.Visible
		end
	end)
	tabbar = Instance.new('Frame')
	tabbar.Name = 'Tabs'
	tabbar.Size = UDim2.fromOffset(490, 34)
	tabbar.Position = UDim2.fromOffset(0, 40)
	tabbar.BackgroundTransparency = 1
	tabbar.BorderSizePixel = 0
	tabbar.Parent = settingspane
	local tablayout = Instance.new('UIListLayout')
	tablayout.SortOrder = Enum.SortOrder.LayoutOrder
	tablayout.FillDirection = Enum.FillDirection.Horizontal
	tablayout.Padding = UDim.new(0, 6)
	tablayout.Parent = tabbar
	local settingschildren = Instance.new('ScrollingFrame')
	settingschildren.Name = 'Children'
	settingschildren.Size = UDim2.fromOffset(490, 353)
	settingschildren.Position = UDim2.fromOffset(0, 74)
	settingschildren.BackgroundTransparency = 1
	settingschildren.BorderSizePixel = 0
	settingschildren.ScrollBarThickness = 2
	settingschildren.ScrollBarImageTransparency = 0.75
	settingschildren.AutomaticCanvasSize = Enum.AutomaticSize.Y
	settingschildren.CanvasSize = UDim2.fromOffset(0, 0)
	settingschildren.Visible = false
	settingschildren.Parent = settingspane
	local settingslayout = Instance.new('UIListLayout')
	settingslayout.SortOrder = Enum.SortOrder.LayoutOrder
	settingslayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	settingslayout.Padding = UDim.new(0, 3)
	settingslayout.Parent = settingschildren
	mainapi.SettingsPanes = {}
	local settingsparent = function()
		local pane = mainapi.SettingsPanes['GUI']
		return pane and pane.Children or settingschildren
	end
	local function registerOption(option)
		categoryapi.Options[option.Name or settingsparent.Name] = option
	end

	function categoryapi:CreateBind()
		local optionapi = {Bind = {'RightShift'}}

		local button = Instance.new('TextButton')
		button.Size = UDim2.fromOffset(478, 40)
		button.BackgroundColor3 = uipallet.Main
		button.BorderSizePixel = 0
		button.AutoButtonColor = false
		button.Text = ''
		button.Parent = settingsparent()
		addCorner(button, UDim.new(0, 4))
		addTooltip(button, 'Change the bind of the GUI')
		local title = Instance.new('TextLabel')
		title.Size = UDim2.fromOffset(300, 40)
		title.Position = UDim2.fromOffset(10, 0)
		title.BackgroundTransparency = 1
		title.Text = 'Rebind GUI'
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 14
		title.FontFace = uipallet.Font
		title.Parent = button
		local bind = Instance.new('TextButton')
		bind.Name = 'Bind'
		bind.Size = UDim2.fromOffset(20, 20)
		bind.Position = UDim2.new(1, -10, 0.5, 0)
		bind.AnchorPoint = Vector2.new(1, 0.5)
		bind.BackgroundColor3 = Color3.new(1, 1, 1)
		bind.BackgroundTransparency = 0.94
		bind.BorderSizePixel = 0
		bind.AutoButtonColor = false
		bind.Text = ''
		bind.Parent = button
		addTooltip(bind, 'Click to bind')
		addCorner(bind, UDim.new(0, 4))
		local icon = Instance.new('ImageLabel')
		icon.Name = 'Icon'
		icon.Size = UDim2.fromOffset(10, 10)
		icon.Position = UDim2.fromOffset(5, 5)
		icon.BackgroundTransparency = 1
		icon.Image = getcustomasset('skidv5/assets/new/bind.png')
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		icon.Parent = bind
		local label = Instance.new('TextLabel')
		label.Name = 'Text'
		label.Size = UDim2.fromScale(1, 1)
		label.Position = UDim2.fromOffset(0, 1)
		label.BackgroundTransparency = 1
		label.Visible = false
		label.Text = ''
		label.TextColor3 = color.Dark(uipallet.Text, 0.43)
		label.TextSize = 9
		label.FontFace = uipallet.FontSemiBold
		label.Parent = bind

		function optionapi:SetBind(tab, mouse)
			mainapi.Keybind = #tab <= 0 and mainapi.Keybind or table.clone(tab)
			self.Bind = mainapi.Keybind
			if mainapi.VapeButton then
				mainapi.VapeButton:Destroy()
				mainapi.VapeButton = nil
			end
			bind.Visible = true
			label.Visible = true
			icon.Visible = false
			label.Text = table.concat(mainapi.Keybind, ' + '):upper()
			bind.Size = UDim2.fromOffset(math.max(getfontsize(label.Text, label.TextSize, label.Font).X + 14, 20), 20)
		end

		bind.MouseEnter:Connect(function()
			label.Visible = false
			icon.Visible = true
			icon.Image = getcustomasset('skidv5/assets/new/edit.png')
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
		end)
		bind.MouseLeave:Connect(function()
			label.Visible = true
			icon.Visible = false
			icon.Image = getcustomasset('skidv5/assets/new/bind.png')
			icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		end)
		bind.MouseButton1Click:Connect(function()
			mainapi.Binding = optionapi
		end)

		optionapi.Name = 'Bind'
		categoryapi.Options.Bind = optionapi
		optionapi:SetBind(mainapi.Keybind)

		return optionapi
	end

	function categoryapi:CreateButton(categorysettings)
		local optionapi = {
			Enabled = false,
			Index = getTableSize(categoryapi.Buttons),
			Name = categorysettings.Name,
			Category = categoryapi
		}
		categorysettings.NoRadio = categorysettings.NoRadio or false

		local row = Instance.new('TextButton')
		row.Name = categorysettings.Name
		row.Size = UDim2.fromOffset(158, 34)
		row.BackgroundColor3 = uipallet.Main
		row.BorderSizePixel = 0
		row.AutoButtonColor = false
		row.Text = ''
		row.Parent = sidebarlist
		addCorner(row, UDim.new(0, 4))
		local icon = Instance.new('ImageLabel')
		icon.Name = 'Icon'
		icon.Size = categorysettings.Size or UDim2.fromOffset(16, 16)
		icon.Position = UDim2.fromOffset(9, 9)
		icon.BackgroundTransparency = 1
		icon.Image = categorysettings.Icon
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
		icon.Parent = row
		local title = Instance.new('TextLabel')
		title.Name = 'Title'
		title.Size = UDim2.fromOffset(118, 34)
		title.Position = UDim2.fromOffset(32, 0)
		title.BackgroundTransparency = 1
		title.Text = categorysettings.Name
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 13
		title.FontFace = uipallet.Font
		title.Parent = row
		local highlight = Instance.new('Frame')
		highlight.Name = 'Highlight'
		highlight.Size = UDim2.fromOffset(2, 26)
		highlight.Position = UDim2.fromOffset(0, 4)
		highlight.BackgroundColor3 = Color3.fromHSV(0.46, 1, 1)
		highlight.BorderSizePixel = 0
		highlight.Visible = false
		highlight.Parent = row
		optionapi.Object = row
		optionapi.Icon = icon

		local function restyle()
			if optionapi.Enabled then
				row.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
				title.TextColor3 = uipallet.Text
				icon.ImageColor3 = uipallet.Text
				highlight.Visible = true
			else
				row.BackgroundColor3 = uipallet.Main
				title.TextColor3 = color.Dark(uipallet.Text, 0.16)
				icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
				highlight.Visible = false
			end
		end

		function optionapi:Set(b)
			self.Enabled = b and true or false
			restyle()
			if categorysettings.Window then
				categorysettings.Window.Visible = self.Enabled
			end
		end

		function optionapi:Toggle(b, force)
			if b == nil then
				b = not self.Enabled
			end
			if b and not force and not categorysettings.NoRadio then
				for _, v in mainapi.SidebarButtons do
					if v ~= optionapi then
						v:Set(false)
					end
				end
				settingspane.Visible = false
			end
			self:Set(b)
		end

		row.MouseButton1Click:Connect(function()
			optionapi:Toggle()
		end)
		row.MouseEnter:Connect(function()
			if not optionapi.Enabled then
				row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				title.TextColor3 = color.Dark(uipallet.Text, 0.29)
			end
		end)
		row.MouseLeave:Connect(function()
			if not optionapi.Enabled then
				restyle()
			end
		end)

		categoryapi.Buttons[categorysettings.Name] = optionapi
		mainapi.SidebarButtons[optionapi.Index] = optionapi
		optionapi.NoRadio = categorysettings.NoRadio

		return optionapi
	end

	function categoryapi:CreateDivider(text)
		return components.Divider(sidebarlist, text)
	end

	function categoryapi:CreateSettingsPane(name)
		if not mainapi.SettingsPanes then
			mainapi.SettingsPanes = {}
		end
		local paneapi = {}
		local index = getTableSize(categoryapi.Panes) + 1
		local tab = Instance.new('TextButton')
		tab.Name = name
		tab.Size = UDim2.fromOffset(96, 26)
		tab.Position = UDim2.fromOffset(12 + (#categoryapi.Panes * 102), 4)
		tab.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		tab.BorderSizePixel = 0
		tab.AutoButtonColor = false
		tab.Text = name:upper()
		tab.TextColor3 = color.Dark(uipallet.Text, 0.4)
		tab.TextSize = 11
		tab.FontFace = uipallet.FontSemiBold
		tab.Parent = tabbar
		addCorner(tab, UDim.new(0, 4))
		local pane = Instance.new('ScrollingFrame')
		pane.Name = name
		pane.Size = UDim2.fromOffset(490, 353)
		pane.Position = UDim2.fromOffset(0, 74)
		pane.BackgroundTransparency = 1
		pane.BorderSizePixel = 0
		pane.ScrollBarThickness = 2
		pane.ScrollBarImageTransparency = 0.75
		pane.AutomaticCanvasSize = Enum.AutomaticSize.Y
		pane.CanvasSize = UDim2.fromOffset(0, 0)
		pane.Visible = false
		pane.Parent = settingspane
		local panechildren = Instance.new('Frame')
		panechildren.Name = 'Children'
		panechildren.Size = UDim2.fromOffset(484, 348)
		panechildren.BackgroundTransparency = 1
		panechildren.BorderSizePixel = 0
		panechildren.Parent = pane
		local panelayout = Instance.new('UIListLayout')
		panelayout.SortOrder = Enum.SortOrder.LayoutOrder
		panelayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		panelayout.Padding = UDim.new(0, 3)
		panelayout.Parent = panechildren
		local function select()
			for i, v in categoryapi.Panes do
				v.Tab.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				v.Tab.TextColor3 = color.Dark(uipallet.Text, 0.4)
				v.Pane.Visible = false
			end
			tab.BackgroundColor3 = color.Light(uipallet.Main, 0.06)
			tab.TextColor3 = uipallet.Text
			pane.Visible = true
		end
		tab.MouseButton1Click:Connect(function()
			select()
		end)
		tab.MouseEnter:Connect(function()
			if pane.Visible then return end
			tab.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
		end)
		tab.MouseLeave:Connect(function()
			if pane.Visible then return end
			tab.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		end)
		paneapi.Tab = tab
		paneapi.Pane = pane
		paneapi.Children = panechildren
		categoryapi.Panes[index] = paneapi
		mainapi.SettingsPanes[name] = paneapi
		if index == 1 then
			select()
		end
		for i, v in components do
			if i ~= 'Divider' then
				paneapi[i] = function(settings)
					return v(panechildren, settings, categoryapi)
				end
			end
		end
		function paneapi:CreateDivider(text)
			return components.Divider(panechildren, text)
		end
		function paneapi:CreateButton(settings)
			local row = Instance.new('TextButton')
			row.Name = settings.Name
			row.Size = UDim2.fromOffset(478, 40)
			row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			row.BorderSizePixel = 0
			row.AutoButtonColor = false
			row.Text = ''
			row.Parent = panechildren
			addCorner(row, UDim.new(0, 4))
			local title = Instance.new('TextLabel')
			title.Size = UDim2.fromOffset(300, 40)
			title.Position = UDim2.fromOffset(10, 0)
			title.BackgroundTransparency = 1
			title.Text = settings.Name
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.TextColor3 = color.Dark(uipallet.Text, 0.16)
			title.TextSize = 14
			title.FontFace = uipallet.Font
			title.Parent = row
			row.MouseButton1Click:Connect(function()
				if settings.Function then
					settings.Function()
				end
			end)
			row.MouseEnter:Connect(function()
				row.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
			end)
			row.MouseLeave:Connect(function()
				row.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end)
			addTooltip(row, settings.Tooltip)
			return {Object = row}
		end
		function paneapi:Clear()
			for i, v in panechildren:GetChildren() do
				if v:IsA('GuiObject') then
					v:Destroy()
				end
			end
		end
		return paneapi
	end

	function categoryapi:CreateOverlayBar()
		local bar = Instance.new('Frame')
		bar.Name = 'OverlayBar'
		bar.Size = UDim2.fromOffset(200, 30)
		bar.Position = UDim2.new(0, 12, 1, -12)
		bar.AnchorPoint = Vector2.new(0, 1)
		bar.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
		bar.BorderSizePixel = 0
		bar.Visible = false
		bar.Parent = scaledgui
		addBlur(bar)
		addCorner(bar, UDim.new(0, 8))
		local title = Instance.new('TextLabel')
		title.Size = UDim2.fromOffset(200, 30)
		title.BackgroundTransparency = 1
		title.Text = 'Overlays'
		title.TextColor3 = color.Dark(uipallet.Text, 0.4)
		title.TextSize = 13
		title.FontFace = uipallet.FontSemiBold
		title.Parent = bar
		local barlist = Instance.new('ScrollingFrame')
		barlist.Name = 'List'
		barlist.Size = UDim2.new(1, 0, 1, -30)
		barlist.Position = UDim2.fromOffset(0, 30)
		barlist.BackgroundTransparency = 1
		barlist.BorderSizePixel = 0
		barlist.ScrollBarThickness = 2
		barlist.ScrollBarImageTransparency = 0.75
		barlist.AutomaticCanvasSize = Enum.AutomaticSize.Y
		barlist.CanvasSize = UDim2.fromOffset(0, 0)
		barlist.Parent = bar
		local barlayout = Instance.new('UIListLayout')
		barlayout.SortOrder = Enum.SortOrder.LayoutOrder
		barlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		barlayout.Padding = UDim.new(0, 2)
		barlayout.Parent = barlist
		local optionapi = {Toggles = {}}

		function optionapi:CreateToggle(settings)
			local toggleapi = {
				Name = settings.Name,
				Icon = settings.Icon,
				Enabled = false,
				Index = #optionapi.Toggles + 1
			}
			local chip = Instance.new('TextButton')
			chip.Name = settings.Name
			chip.Size = UDim2.fromOffset(188, 32)
			chip.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			chip.BorderSizePixel = 0
			chip.AutoButtonColor = false
			chip.Text = ''
			chip.Parent = barlist
			addCorner(chip, UDim.new(0, 4))
			local chipicon = Instance.new('ImageLabel')
			chipicon.Name = 'Icon'
			chipicon.Size = UDim2.fromOffset(16, 16)
			chipicon.Position = UDim2.fromOffset(6, 8)
			chipicon.BackgroundTransparency = 1
			chipicon.Image = settings.Icon
			chipicon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
			chipicon.Parent = chip
			local chiptitle = Instance.new('TextLabel')
			chiptitle.Name = 'Title'
			chiptitle.Size = UDim2.new(1, -70, 1, 0)
			chiptitle.Position = UDim2.fromOffset(28, 0)
			chiptitle.BackgroundTransparency = 1
			chiptitle.Text = settings.Name
			chiptitle.TextXAlignment = Enum.TextXAlignment.Left
			chiptitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
			chiptitle.TextSize = 13
			chiptitle.FontFace = uipallet.Font
			chiptitle.Parent = chip
			local knob = Instance.new('Frame')
			knob.Name = 'Knob'
			knob.Size = UDim2.fromOffset(22, 12)
			knob.Position = UDim2.new(1, -30, 0.5, 0)
			knob.AnchorPoint = Vector2.new(1, 0.5)
			knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
			knob.BorderSizePixel = 0
			knob.Parent = chip
			addCorner(knob, UDim.new(1, 0))
			local knobmain = Instance.new('Frame')
			knobmain.Name = 'KnobMain'
			knobmain.Size = UDim2.fromOffset(8, 8)
			knobmain.Position = UDim2.fromOffset(2, 2)
			knobmain.BackgroundColor3 = color.Light(uipallet.Main, 0.26)
			knobmain.BorderSizePixel = 0
			knobmain.Parent = knob
			addCorner(knobmain, UDim.new(1, 0))
			toggleapi.Object = chip
			toggleapi.Knob = knobmain

			local function restyle()
				if toggleapi.Enabled then
					chiptitle.TextColor3 = uipallet.Text
					chipicon.ImageColor3 = uipallet.Text
					knob.BackgroundColor3 = Color3.fromHSV(
						mainapi.GUIColor.Hue,
						mainapi.GUIColor.Sat,
						math.clamp(mainapi.GUIColor.Value + 0.08, 0, 1)
					)
					knobmain.Position = UDim2.fromOffset(12, 2)
				else
					chiptitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
					chipicon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
					knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
					knobmain.Position = UDim2.fromOffset(2, 2)
				end
			end

			function toggleapi:Toggle(b)
				if b == nil then
					b = not self.Enabled
				end
				self.Enabled = b and true or false
				restyle()
				task.spawn(settings.Function, self.Enabled)
			end

			function toggleapi:Set(b)
				self.Enabled = b and true or false
				restyle()
			end

			chip.MouseButton1Click:Connect(function()
				toggleapi:Toggle()
			end)
			chip.MouseEnter:Connect(function()
				chip.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
			end)
			chip.MouseLeave:Connect(function()
				chip.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			end)

			restyle()
			optionapi.Toggles[toggleapi.Index] = toggleapi
			bar.Size = UDim2.fromOffset(200, math.min(30 + (32 * #optionapi.Toggles) + (2 * (#optionapi.Toggles - 1)) + 6, 400))
			return toggleapi
		end

		function optionapi:Clear()
			for i, v in barlist:GetChildren() do
				if v:IsA('GuiObject') then
					v:Destroy()
				end
			end
			optionapi.Toggles = {}
			bar.Size = UDim2.fromOffset(200, 30)
		end

		overlaybar = bar
		mainapi.Overlaybar = bar
		mainapi.Overlays = optionapi

		return optionapi
	end

	function categoryapi:CreateGUISlider(categorysettings)
		local slidercolors = {
			Color3.fromRGB(255, 95, 95),
			Color3.fromRGB(255, 184, 87),
			Color3.fromRGB(255, 235, 105),
			Color3.fromRGB(118, 255, 173),
			Color3.fromRGB(91, 232, 255),
			Color3.fromRGB(133, 125, 255),
			Color3.fromRGB(248, 125, 255)
		}
		local slidercolorpos = {4, 33, 62, 90, 119, 148, 177}
		local optionapi = {
			Type = 'GUISlider',
			Notch = 4,
			Hue = 0.46,
			Sat = 0.96,
			Value = 0.52,
			Rainbow = false,
			CustomColor = false
		}

		local button = Instance.new('TextButton')
		button.Name = categorysettings.Name
		button.Size = UDim2.fromOffset(478, 40)
		button.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
		button.BorderSizePixel = 0
		button.AutoButtonColor = false
		button.Text = ''
		button.Parent = settingsparent()
		addCorner(button, UDim.new(0, 4))
		addTooltip(button, 'Change the color of the GUI')
		local title = Instance.new('TextLabel')
		title.Size = UDim2.fromOffset(300, 40)
		title.Position = UDim2.fromOffset(10, 0)
		title.BackgroundTransparency = 1
		title.Text = categorysettings.Name
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextColor3 = color.Dark(uipallet.Text, 0.16)
		title.TextSize = 14
		title.FontFace = uipallet.Font
		title.Parent = button
		local colorframe = Instance.new('Frame')
		colorframe.Size = UDim2.fromOffset(70, 30)
		colorframe.Position = UDim2.new(1, -10, 0.5, 0)
		colorframe.AnchorPoint = Vector2.new(1, 0.5)
		colorframe.BackgroundColor3 = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
		colorframe.BorderSizePixel = 0
		colorframe.Parent = button
		addCorner(colorframe, UDim.new(0, 4))
		local customchildren = Instance.new('Frame')
		customchildren.Size = UDim2.new(1, 0, 0, 0)
		customchildren.Position = UDim2.new(0, 0, 1, 0)
		customchildren.BackgroundTransparency = 1
		customchildren.BorderSizePixel = 0
		customchildren.Visible = false
		customchildren.Parent = button
		local customlayout = Instance.new('UIListLayout')
		customlayout.SortOrder = Enum.SortOrder.LayoutOrder
		customlayout.Padding = UDim.new(0, 4)
		customlayout.Parent = customchildren

		local function updateCustom()
			customchildren.Size = UDim2.new(1, 0, 0, customlayout.AbsoluteContentSize.Y)
			customchildren.Visible = optionapi.Notch == 1
		end

		local function notifySlider(setting, value)
			local label = customchildren:FindFirstChild(setting)
			if label and label:IsA('TextLabel') then
				label.Text = setting .. ' - ' .. math.round(value * 100) .. '%'
			end
		end

		local function updateColor()
			local hue = optionapi.Hue
			local sat = optionapi.Sat
			local value = optionapi.Value
			if optionapi.Rainbow then
				optionapi.Hue = mainapi.RainbowHue
				hue = mainapi.RainbowHue
			end
			local color = Color3.fromHSV(hue, sat, value)
			colorframe.BackgroundColor3 = color
			if mainapi.GUIColor == optionapi then
				mainapi.RainbowTable = {hue, sat, value, optionapi.Rainbow, optionapi.CustomColor}
			end
			if categorysettings.Function then
				categorysettings.Function(hue, sat, value)
			end
		end

		local function createSlider(settings)
			local expand = Instance.new('TextButton')
			expand.Name = settings.Name
			expand.Size = UDim2.fromOffset(478, 28)
			expand.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			expand.BorderSizePixel = 0
			expand.AutoButtonColor = false
			expand.Text = ''
			expand.Parent = customchildren
			addCorner(expand, UDim.new(0, 4))
			local expandtitle = Instance.new('TextLabel')
			expandtitle.Size = UDim2.fromOffset(240, 28)
			expandtitle.Position = UDim2.fromOffset(10, 0)
			expandtitle.BackgroundTransparency = 1
			expandtitle.Text = settings.Name .. ' - ' .. math.round(settings.Value * 100) .. '%'
			expandtitle.TextXAlignment = Enum.TextXAlignment.Left
			expandtitle.TextColor3 = color.Dark(uipallet.Text, 0.29)
			expandtitle.TextSize = 13
			expandtitle.FontFace = uipallet.Font
			expandtitle.Parent = expand
			local slider = Instance.new('Frame')
			slider.Name = 'Slider'
			slider.Size = UDim2.new(1, -120, 0, 4)
			slider.Position = UDim2.fromOffset(40, 12)
			slider.BackgroundColor3 = color.Light(uipallet.Main, 0.11)
			slider.BorderSizePixel = 0
			slider.Parent = expand
			local fill = Instance.new('Frame')
			fill.Name = 'Fill'
			fill.BackgroundColor3 = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
			fill.BorderSizePixel = 0
			fill.Parent = slider
			local knob = Instance.new('ImageLabel')
			knob.Name = 'Knob'
			knob.Size = UDim2.fromOffset(14, 14)
			knob.Position = UDim2.new(0.5, -7, 0.5, -7)
			knob.BackgroundTransparency = 1
			knob.Image = getcustomasset('skidv5/assets/new/guislider.png')
			knob.ImageColor3 = color.Dark(uipallet.Text, 0.29)
			knob.Parent = slider
			local function setPosition()
				local x = math.clamp(settings.Value, 0, 1) * (slider.AbsoluteSize.X - knob.AbsoluteSize.X)
				fill.Size = UDim2.fromOffset(x + 7, 4)
				knob.Position = UDim2.fromOffset(x, -5)
			end
			local function updateValue(x)
				settings.Value = math.clamp((x - slider.AbsolutePosition.X) / (slider.AbsoluteSize.X - knob.AbsoluteSize.X), 0, 1)
				expandtitle.Text = settings.Name .. ' - ' .. math.round(settings.Value * 100) .. '%'
				setPosition()
			end
			slider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					updateValue(input.Position.X)
					local connection
					connection = inputService.InputChanged:Connect(function(input2)
						if input2.UserInputType == Enum.UserInputType.MouseMovement then
							updateValue(input2.Position.X)
						end
					end)
					local connection2
					connection2 = inputService.InputEnded:Connect(function(input2)
						if input2 == input then
							connection:Disconnect()
							connection2:Disconnect()
						end
					end)
				end
			end)
			slider.MouseWheelForward:Connect(function()
				settings.Value = math.clamp(settings.Value + 0.05, 0, 1)
				expandtitle.Text = settings.Name .. ' - ' .. math.round(settings.Value * 100) .. '%'
				setPosition()
			end)
			slider.MouseWheelBackward:Connect(function()
				settings.Value = math.clamp(settings.Value - 0.05, 0, 1)
				expandtitle.Text = settings.Name .. ' - ' .. math.round(settings.Value * 100) .. '%'
				setPosition()
			end)
			settings.Set = setPosition
			return expand, expandtitle, settings
		end

		local function updateSliders()
			for i, v in {optionapi.Sat, optionapi.Value, optionapi.Hue} do
				local expand = customchildren:FindFirstChild(v.Name)
				if expand then
					local slider = expand:FindFirstChild('Slider')
					if slider then
						local fill = slider:FindFirstChild('Fill')
						local knob = slider:FindFirstChild('Knob')
						local x = math.clamp(v.Value, 0, 1) * (slider.AbsoluteSize.X - knob.AbsoluteSize.X)
						fill.Size = UDim2.fromOffset(x + 7, 4)
						knob.Position = UDim2.fromOffset(x, -5)
						fill.BackgroundColor3 = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
						local expandtitle = expand:FindFirstChildOfClass('TextLabel')
						if expandtitle then
							expandtitle.Text = v.Name .. ' - ' .. math.round(v.Value * 100) .. '%'
						end
					end
				end
			end
			if optionapi.Rainbow then
				optionapi.Hue = mainapi.RainbowHue
			end
			updateColor()
		end

		local function updateRainbow()
			optionapi.Hue = mainapi.RainbowHue
			updateColor()
		end

		local function updateCustomColor()
			optionapi.CustomColor = true
			updateSliders()
		end

		local function setValue(v, s, b, n)
			if v then optionapi.Hue = v end
			if s then optionapi.Sat = s end
			if b then optionapi.Value = b end
			if n then optionapi.Notch = n end
			updateSliders()
			updateCustom()
		end

		function optionapi:SetValue(v, s, b, n)
			setValue(v, s, b, n)
		end

		function optionapi:Load(tab)
			setValue(tab.Hue, tab.Sat, tab.Value, 4)
		end

		local hsv = {Hue = 0, Sat = 1, Value = 1}
		local function open()
			updateSliders()
			updateCustom()
		end

		local rainbowtoggle = components.Toggle(customchildren, {
			Name = 'Rainbow Mode',
			Function = function(callback)
				optionapi.Rainbow = callback
				if callback then
					optionapi.Hue = mainapi.RainbowHue
				end
				updateColor()
			end
		}, optionapi)
		local rspeed = components.Slider(customchildren, {
			Name = 'Rainbow speed',
			Min = 1,
			Max = 10,
			Value = mainapi.RainbowSpeed.Value,
			Function = function(value)
				mainapi.RainbowSpeed.Value = value
			end
		}, optionapi)
		local rrate = components.Slider(customchildren, {
			Name = 'Rainbow update rate',
			Min = 1,
			Max = 15,
			Value = mainapi.RainbowUpdateSpeed.Value,
			Function = function(value)
				mainapi.RainbowUpdateSpeed.Value = value
			end
		}, optionapi)
		local expansion = Instance.new('Frame')
		expansion.Size = UDim2.fromOffset(478, 4)
		expansion.BackgroundTransparency = 1
		expansion.BorderSizePixel = 0
		expansion.Parent = customchildren
		local expand1 = components.Slider(customchildren, {
			Name = 'Saturation',
			Min = 0,
			Max = 1,
			Value = optionapi.Sat,
			Function = function(value)
				optionapi.Sat = value
				updateColor()
				notifySlider('Saturation', value)
			end
		}, optionapi)
		local expand2 = components.Slider(customchildren, {
			Name = 'Vibrance',
			Min = 0,
			Max = 1,
			Value = optionapi.Value,
			Function = function(value)
				optionapi.Value = value
				updateColor()
				notifySlider('Vibrance', value)
			end
		}, optionapi)
		local expand3 = components.Slider(customchildren, {
			Name = 'Hue',
			Min = 0,
			Max = 1,
			Value = optionapi.Hue,
			Function = function(value)
				optionapi.Hue = value
				updateColor()
				notifySlider('Hue', value)
			end
		}, optionapi)
		local rainbow1 = components.Toggle(customchildren, {
			Name = 'Custom color',
			Function = updateCustomColor
		}, optionapi)

		local function onToggle(value)
			updateCustom()
		end

		button.MouseButton1Click:Connect(function()
			optionapi.Notch = optionapi.Notch == 1 and 4 or 1
			updateCustom()
		end)
		button.MouseEnter:Connect(function()
			button.BackgroundColor3 = color.Light(uipallet.Main, 0.06)
		end)
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
		end)

		optionapi.Name = categorysettings.Name
		categoryapi.Options[categorysettings.Name] = optionapi
		updateColor()

		return optionapi
	end

	settingsbutton.MouseButton1Click:Connect(function()
		settingspane.Visible = not settingspane.Visible
		if settingspane.Visible then
			for _, v in mainapi.SidebarButtons do
				v:Set(false)
			end
			mainapi.OverlaysButton:Set(false)
		end
	end)
	categoryapi.Object = clickgui
	categoryapi.Buttons = {}
	categoryapi.Panes = {}
	categoryapi.Options = {}
	categoryapi.Objects = {}
	categoryapi.List = {}
	mainapi.SidebarButtons = {}
	mainapi.Categories.Main = categoryapi

	return categoryapi
end

function mainapi:CreateOverlay(categorysettings)
	local name = categorysettings.Name
	local icon = categorysettings.Icon
	local window = Instance.new('TextButton')
	window.Name = name..'Overlay'
	window.Size = UDim2.fromOffset(categorysettings.CategorySize or 220, 41)
	window.Position = categorysettings.Position or UDim2.fromOffset(240, 46)
	window.BackgroundColor3 = uipallet.Main
	window.BorderSizePixel = 0
	window.Text = ''
	window.Visible = false
	window.Parent = scaledgui
	addBlur(window)
	addCorner(window, UDim.new(0, 6))
	makeDraggable(window, window)
	local iconlabel = Instance.new('ImageLabel')
	iconlabel.Name = 'Icon'
	iconlabel.Size = categorysettings.Size or UDim2.fromOffset(16, 16)
	iconlabel.Position = UDim2.fromOffset(12, iconlabel.Size.X.Offset > 14 and 14 or 13)
	iconlabel.BackgroundTransparency = 1
	iconlabel.Image = icon
	iconlabel.ImageColor3 = color.Dark(uipallet.Text, 0.43)
	iconlabel.Parent = window
	local title = Instance.new('TextLabel')
	title.Size = UDim2.new(1, -32, 0, 41)
	title.Position = UDim2.fromOffset(32, 0)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = color.Dark(uipallet.Text, 0.16)
	title.TextSize = 14
	title.FontFace = uipallet.Font
	title.Parent = window
	local categoryapi = {
		Type = 'Overlay',
		Expanded = false,
		Button = nil,
		Pinned = false,
		Options = {}
	}
	categoryapi.Icon = icon
	categoryapi.Size = categorysettings.Size
	local customchildren = Instance.new('Frame')
	customchildren.Name = 'Children'
	customchildren.Size = UDim2.new(1, 0, 0, 0)
	customchildren.Position = UDim2.new(0, 0, 1, 0)
	customchildren.BackgroundTransparency = 1
	customchildren.BorderSizePixel = 0
	customchildren.Visible = false
	customchildren.Parent = window
	local customlayout = Instance.new('UIListLayout')
	customlayout.SortOrder = Enum.SortOrder.LayoutOrder
	customlayout.Padding = UDim.new(0, 4)
	customlayout.Parent = customchildren
	local function updateCustom()
		local y = customlayout.AbsoluteContentSize.Y
		customchildren.Size = UDim2.new(1, 0, 0, y)
		customchildren.Visible = categoryapi.Expanded
		window.Size = UDim2.fromOffset(categorysettings.CategorySize or 220, 41 + y)
	end
	window.MouseButton1Click:Connect(function()
		if not categoryapi.Expanded then
			categoryapi.Expanded = true
		end
		updateCustom()
	end)
	categoryapi.Window = window
	categoryapi.Object = window
	categoryapi.Children = customchildren
	categoryapi.Button = mainapi.Overlays:CreateToggle({
		Name = name,
		Icon = icon,
		Size = categorysettings.Size,
		Function = function(callback)
			window.Visible = callback and (clickgui.Visible or categoryapi.Pinned)
			if not callback then
				for i, v in categoryapi.Connections do
					v:Disconnect()
				end
				table.clear(categoryapi.Connections)
			end
			if callback then
				task.spawn(categorysettings.Function, callback)
			end
		end
	})
	function categoryapi:Load(tab)
		self.Button:Set(tab.Enabled or false)
		self.Pinned = tab.Pinned or false
		self.Position = tab.Position or {X = 240, Y = 46}
		self.Expanded = tab.Expanded or false
		window.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
		window.Visible = tab.Enabled and (clickgui.Visible or self.Pinned)
		updateCustom()
	end
	function categoryapi:Save()
		local save = {}
		save.Enabled = self.Button.Enabled
		save.Options = {}
		for i, v in self.Options do
			if v.Save then
				save.Options[i] = v:Save()
			end
		end
		save.Position = {X = window.Position.X.Offset, Y = window.Position.Y.Offset}
		save.Pinned = self.Pinned
		save.Expanded = self.Expanded
		return save
	end
	for name, comp in components do
		if name ~= 'Divider' then
			categoryapi['Create'..name] = function(settings)
				return comp(customchildren, settings, categoryapi)
			end
		end
	end
	function categoryapi:CreateDivider(text)
		return components.Divider(customchildren, text)
	end
	categoryapi.Update = Instance.new('BindableEvent')
	categoryapi.ColorUpdate = Instance.new('BindableEvent')
	mainapi.Categories[name] = categoryapi
	table.insert(mainapi.Windows, window)
	addMaid(categoryapi)
	return categoryapi
end

function mainapi:CreateLegit()
	local legitapi = {Modules = {}, Type = 'Legit'}
	local window = Instance.new('TextButton')
	window.Name = 'LegitWindow'
	window.Size = UDim2.fromOffset(420, 520)
	window.Position = UDim2.fromScale(0.5, 0.5)
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.BackgroundColor3 = uipallet.Main
	window.BorderSizePixel = 0
	window.Text = ''
	window.Visible = false
	window.Parent = scaledgui
	addBlur(window)
	addCorner(window, UDim.new(0, 8))
	local mainstroke = Instance.new('UIStroke')
	mainstroke.Color = Color3.new(1, 1, 1)
	mainstroke.Transparency = 0.9
	mainstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainstroke.Parent = window
	local header = Instance.new('Frame')
	header.Name = 'Header'
	header.Size = UDim2.new(1, 0, 0, 44)
	header.BackgroundColor3 = color.Dark(uipallet.Main, 0.03)
	header.BorderSizePixel = 0
	header.Parent = window
	addCorner(header, UDim.new(0, 8))
	makeDraggable(window, header)
	local headertitle = Instance.new('TextLabel')
	headertitle.Name = 'Title'
	headertitle.Size = UDim2.fromOffset(250, 44)
	headertitle.Position = UDim2.fromOffset(12, 0)
	headertitle.BackgroundTransparency = 1
	headertitle.Text = 'LEGIT'
	headertitle.TextXAlignment = Enum.TextXAlignment.Left
	headertitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
	headertitle.TextSize = 15
	headertitle.FontFace = uipallet.FontSemiBold
	headertitle.Parent = header
	local close = addCloseButton(header, 10)
	close.MouseButton1Click:Connect(function()
		window.Visible = false
	end)
	local children = Instance.new('ScrollingFrame')
	children.Name = 'Children'
	children.Size = UDim2.new(1, 0, 1, -44)
	children.Position = UDim2.fromOffset(0, 44)
	children.BackgroundTransparency = 1
	children.BorderSizePixel = 0
	children.ScrollBarThickness = 2
	children.ScrollBarImageTransparency = 0.75
	children.AutomaticCanvasSize = Enum.AutomaticSize.Y
	children.CanvasSize = UDim2.fromOffset(0, 0)
	children.Parent = window
	local legitlayout = Instance.new('UIListLayout')
	legitlayout.SortOrder = Enum.SortOrder.LayoutOrder
	legitlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	legitlayout.Padding = UDim.new(0, 3)
	legitlayout.Parent = children
	legitapi.Window = window
	function legitapi:CreateModule(settings)
		local moduleapi = createModule(children, settings, legitapi, 490)
		mainapi.Modules[moduleapi.Name] = moduleapi
		return moduleapi
	end
	mainapi.Legit = legitapi
	table.insert(mainapi.Windows, window)
	return legitapi
end

function mainapi:CreateNotification(name, text, time, tag, sound)
	time = time or 3
	tag = tag or 'INFO'
	local notification = Instance.new('Frame')
	notification.Name = name
	notification.Size = UDim2.fromOffset(268, 78)
	notification.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
	notification.BorderSizePixel = 0
	notification.Parent = notifications
	addBlur(notification)
	addCorner(notification, UDim.new(0, 8))
	local count = 0
	for i, v in notifications:GetChildren() do
		if v:IsA('Frame') then
			count = count + 1
		end
	end
	local y = 29 + (78 * count)
	notification.Position = UDim2.new(1, -90, 0, y)
	local title = Instance.new('TextLabel')
	title.Name = 'Title'
	title.Size = UDim2.fromOffset(240, 40)
	title.Position = UDim2.fromOffset(18, 10)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = uipallet.Text
	title.TextSize = 15
	title.FontFace = uipallet.FontSemiBold
	title.Parent = notification
	local description = Instance.new('TextLabel')
	description.Name = 'Description'
	description.Size = UDim2.fromOffset(240, 40)
	description.Position = UDim2.fromOffset(18, 38)
	description.BackgroundTransparency = 1
	description.Text = text or ''
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextColor3 = color.Dark(uipallet.Text, 0.29)
	description.TextSize = 12
	description.FontFace = uipallet.Font
	description.TextWrapped = true
	description.Parent = notification
	local taglabel = Instance.new('TextLabel')
	taglabel.Name = 'Tag'
	taglabel.Size = UDim2.fromOffset(80, 16)
	taglabel.Position = UDim2.fromOffset(8, -8)
	taglabel.BackgroundColor3 = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
	taglabel.BorderSizePixel = 0
	taglabel.Text = tag
	taglabel.TextColor3 = Color3.new(1, 1, 1)
	taglabel.TextSize = 9
	taglabel.FontFace = uipallet.FontSemiBold
	taglabel.Parent = notification
	addCorner(taglabel, UDim.new(0, 4))
	local close = Instance.new('ImageButton')
	close.Name = 'Close'
	close.Size = UDim2.fromOffset(14, 14)
	close.Position = UDim2.new(1, -20, 0, 9)
	close.BackgroundTransparency = 1
	close.AutoButtonColor = false
	close.Image = getcustomasset('skidv5/assets/new/close.png')
	close.ImageColor3 = color.Dark(uipallet.Text, 0.43)
	close.Parent = notification
	local function reposition()
		local count = 0
		for i, v in notifications:GetChildren() do
			if v:IsA('Frame') then
				v.Position = UDim2.new(1, -(278), 0, 29 + (78 * count))
				count = count + 1
			end
		end
	end
	notifications.ChildRemoved:Connect(function()
		reposition()
	end)
	local function animate(to, done)
		local start = tick()
		local from = notification.Position.X.Offset
		while tick() - start < 0.3 do
			local t = (tick() - start) / 0.3
			notification.Position = UDim2.new(1, from + ((to - from) * t), 0, notification.Position.Y.Offset)
			task.wait()
		end
		notification.Position = UDim2.new(1, to, 0, notification.Position.Y.Offset)
		if done then
			done()
		end
	end
	task.spawn(function()
		animate(-278, function()
			task.wait(time)
			animate(-90, function()
				notification:Destroy()
			end)
		end)
	end)
	close.MouseButton1Click:Connect(function()
		notification:Destroy()
	end)
	return notification
end

function mainapi:LoadOptions(tab, object)
	if not tab then
		return
	end
	for i, v in object.Options do
		if v.Load then
			local saved = tab[i]
			if saved then
				pcall(v.Load, v, saved)
			end
		end
	end
end

function mainapi:SetProfile(name)
	mainapi:Save(name)
	mainapi:Load(true)
end

function mainapi:Remove()
	mainapi:Uninject()
end

function mainapi:Save(customProfile)
	local save = {}
	save.Modules = {}
	save.Categories = {}
	for i, v in mainapi.Modules do
		local tosave = {
			Enabled = v.Enabled,
			Bind = v.Bind,
			Options = {}
		}
		for j, o in v.Options do
			if o.Save then
				tosave.Options[j] = o:Save()
			end
		end
		save.Modules[i] = tosave
	end
	for i, v in mainapi.Categories do
		if i ~= 'Main' then
			local tosave = {}
			if v.Type == 'Overlay' then
				tosave.Enabled = v.Button.Enabled
				tosave.Options = {}
				for j, o in v.Options do
					if o.Save then
						tosave.Options[j] = o:Save()
					end
				end
				tosave.Position = {X = v.Window.Position.X.Offset, Y = v.Window.Position.Y.Offset}
				tosave.Pinned = v.Pinned
			else
				tosave.Options = {}
				for j, o in v.Options do
					if o.Save then
						tosave.Options[j] = o:Save()
					end
				end
				tosave.Position = {X = v.Window.Position.X.Offset, Y = v.Window.Position.Y.Offset}
				tosave.List = table.clone(v.List)
				tosave.ListEnabled = table.clone(v.ListEnabled)
				tosave.Expanded = v.Expanded
			end
			save.Categories[i] = tosave
		end
	end
	local dir = 'skidv5/profiles/'
	if customProfile then
		writefile(dir..customProfile..tostring(mainapi.Place)..'.txt', game:GetService('HttpService'):JSONEncode(save))
	else
		writefile(dir..tostring(mainapi.Place)..'.txt', game:GetService('HttpService'):JSONEncode(save))
	end
	mainapi:SaveOptions()
end

function mainapi:SaveOptions()
	local save = {}
	save.Profile = mainapi.Profile
	save.Categories = {}
	local maintab = {}
	maintab.Options = {}
	for i, v in mainapi.Categories.Main.Options do
		if v.Save then
			maintab.Options[i] = v:Save()
		end
	end
	maintab.Position = {
		X = clickgui.Position.X.Offset,
		Y = clickgui.Position.Y.Offset,
		XS = clickgui.Position.X.Scale,
		YS = clickgui.Position.Y.Scale
	}
	save.Categories.Main = maintab
	writefile('skidv5/gui.txt', game:GetService('HttpService'):JSONEncode(save))
end

function mainapi:Load(customProfile, setdefault)
	local guidata = loadJson('skidv5/gui.txt')
	if not guidata.Categories then
		guidata = {}
	end
	customProfile = customProfile or guidata.Profile or 'default'
	mainapi.Profile = customProfile
	local profile = loadJson('skidv5/profiles/'..customProfile..tostring(mainapi.Place)..'.txt')
	if not profile.Categories then
		profile = loadJson('skidv5/profiles/'..tostring(mainapi.Place)..'.txt')
	end
	if not profile.Categories then
		profile = {}
	end
	for i, v in mainapi.Modules do
		local saved = profile.Modules and profile.Modules[v.Name]
		if saved then
			if v.Enabled and not saved.Enabled then
				v:Toggle()
			elseif not v.Enabled and saved.Enabled then
				v:Toggle(true)
			end
			if v.Bind then
				v.Bind = saved.Bind or v.Bind
			end
			mainapi:LoadOptions(saved.Options, v)
		end
	end
	for i, v in mainapi.Categories do
		if i ~= 'Main' then
			local saved = profile.Categories and profile.Categories[i]
			if saved then
				if v.Type == 'Overlay' then
					v:Load(saved)
				else
					mainapi:LoadOptions(saved.Options, v)
					v.List = saved.List or {}
					v.ListEnabled = saved.ListEnabled or {}
					v.Expanded = saved.Expanded or false
					v:ChangeValue()
				end
			end
		end
	end
	local maintab = guidata.Categories and guidata.Categories.Main or {}
	mainapi:LoadOptions(maintab.Options, mainapi.Categories.Main)
	local pos = maintab.Position
	if pos then
		clickgui.Position = UDim2.new(pos.XS or 0, pos.X or 0, pos.YS or 0, pos.Y or 0)
	end
	if setdefault then
		mainapi:Save()
	end
	mainapi.Loaded = true
	if mainapi.Downloader then
		mainapi.Downloader:Destroy()
		mainapi.Downloader = nil
	end
	mainapi:UpdateTextGUI()
end

function mainapi:Uninject()
	for i, v in mainapi.Modules do
		if v.Enabled then
			v:Toggle()
		end
	end
	if mainapi.Legit then
		for i, v in mainapi.Legit.Modules do
			if v.Enabled then
				v:Toggle()
			end
		end
	end
	for i, v in mainapi.Categories do
		if v.Type == 'Overlay' and v.Button.Enabled then
			v.Button:Toggle()
		end
	end
	for i, v in mainapi.Connections do
		v:Disconnect()
	end
	table.clear(mainapi.Connections)
	if mainapi.ThreadFix then
		setthreadidentity(8)
		clickgui.Visible = false
		mainapi:BlurCheck()
	end
	mainapi.gui:ClearAllChildren()
	mainapi.gui:Destroy()
	table.clear(mainapi.Libraries)
	loopClean(mainapi)
	shared.vape = nil
	shared.vapereload = nil
	shared.VapeIndependent = nil
end

mainapi:CreateLegit()
mainapi:CreateGUI()

mainapi:CreateCategory({
	Name = 'Combat',
	Icon = getcustomasset('skidv5/assets/new/combaticon.png'),
	Size = UDim2.fromOffset(13, 14)
})
mainapi:CreateCategory({
	Name = 'Render',
	Icon = getcustomasset('skidv5/assets/new/rendericon.png'),
	Size = UDim2.fromOffset(15, 14)
})
mainapi:CreateCategory({
	Name = 'Utility',
	Icon = getcustomasset('skidv5/assets/new/utilityicon.png'),
	Size = UDim2.fromOffset(15, 14)
})
mainapi:CreateCategory({
	Name = 'World',
	Icon = getcustomasset('skidv5/assets/new/worldicon.png'),
	Size = UDim2.fromOffset(14, 14)
})
mainapi:CreateCategory({
	Name = 'Inventory',
	Icon = getcustomasset('skidv5/assets/new/inventoryicon.png'),
	Size = UDim2.fromOffset(15, 14)
})
mainapi:CreateCategory({
	Name = 'Minigames',
	Icon = getcustomasset('skidv5/assets/new/miniicon.png'),
	Size = UDim2.fromOffset(19, 12)
})

local friends
local friendscolor = {
	Hue = 1,
	Sat = 1,
	Value = 1
}
local friendssettings = {
	Name = 'Friends',
	Icon = getcustomasset('skidv5/assets/new/friendstab.png'),
	Size = UDim2.fromOffset(17, 16),
	Placeholder = 'Roblox username',
	Color = Color3.fromRGB(5, 134, 105),
	Function = function()
		friends.Update:Fire()
		friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
	end
}
friends = mainapi:CreateCategoryList(friendssettings)
friends:CreateToggle({
	Name = 'Recolor visuals',
	Darker = true,
	Default = true,
	Function = function()
		friends.Update:Fire()
		friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
	end
})
friendscolor = friends:CreateColorSlider({
	Name = 'Friends color',
	Darker = true,
	Function = function(hue, sat, val)
		for _, v in friends.Object.Children:GetChildren() do
			local dot = v:FindFirstChild('Dot')
			if dot and dot.BackgroundColor3 ~= color.Light(uipallet.Main, 0.37) then
				dot.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		end
		friendssettings.Color = Color3.fromHSV(hue, sat, val)
		friends.ColorUpdate:Fire(hue, sat, val)
	end
})
friends:CreateToggle({
	Name = 'Use friends',
	Darker = true,
	Default = true,
	Function = function()
		friends.Update:Fire()
		friends.ColorUpdate:Fire(friendscolor.Hue, friendscolor.Sat, friendscolor.Value)
	end
})

mainapi:CreateCategoryList({
	Name = 'Profiles',
	Icon = getcustomasset('skidv5/assets/new/profilesicon.png'),
	Size = UDim2.fromOffset(17, 10),
	Placeholder = 'Type name',
	Profiles = true
})
mainapi.Profiles = mainapi.Categories.Profiles

local targets
targets = mainapi:CreateCategoryList({
	Name = 'Targets',
	Icon = getcustomasset('skidv5/assets/new/friendstab.png'),
	Size = UDim2.fromOffset(17, 16),
	Placeholder = 'Roblox username',
	Function = function()
		targets.Update:Fire()
	end
})

mainapi:CreateOverlayBar()

for i, v in mainapi.Categories do
	if v.Name ~= 'Main' then
		mainapi.Categories.Main:CreateButton({
			Name = v.Name,
			Icon = v.Icon,
			Size = v.Size,
			Window = v.Window
		})
	end
end
mainapi.OverlaysButton = mainapi.Categories.Main:CreateButton({
	Name = 'Overlays',
	Icon = getcustomasset('skidv5/assets/new/overlaysicon.png'),
	Size = UDim2.fromOffset(16, 16),
	NoRadio = true,
	Window = mainapi.Overlaybar
})
mainapi.LegitButton = mainapi.Categories.Main:CreateButton({
	Name = 'Legit',
	Icon = getcustomasset('skidv5/assets/new/legit.png'),
	Size = UDim2.fromOffset(16, 16),
	Window = mainapi.Legit.Window
})

local general = mainapi.Categories.Main:CreateSettingsPane('General')
mainapi.MultiKeybind = general:CreateToggle({
	Name = 'Enable Multi-Keybinding',
	Tooltip = 'Allows multiple keys to be bound to a module (eg. G + H)'
})
general:CreateButton({
	Name = 'Reset current profile',
	Function = function()
		mainapi.Save = function() end
		if isfile('skidv5/profiles/'..mainapi.Profile..tostring(mainapi.Place)..'.txt') and delfile then
			delfile('skidv5/profiles/'..mainapi.Profile..tostring(mainapi.Place)..'.txt')
		end
		shared.vapereload = true
		if shared.SkidV5Developer then
			loadstring(readfile('skidv5/loader.lua'), 'loader')()
		else
			loadstring(game:HttpGet('https://raw.githubusercontent.com/skidforce/skidv5lite/main/loader.lua', true))()
		end
	end,
	Tooltip = 'This will set your profile to the default settings of Vape'
})
general:CreateButton({
	Name = 'Self destruct',
	Function = function()
		mainapi:Uninject()
	end,
	Tooltip = 'Removes vape from the current game'
})
general:CreateButton({
	Name = 'Reinject',
	Function = function()
		shared.vapereload = true
		if shared.SkidV5Developer then
			loadstring(readfile('skidv5/loader.lua'), 'loader')()
		else
			loadstring(game:HttpGet('https://raw.githubusercontent.com/skidforce/skidv5lite/main/loader.lua', true))()
		end
	end,
	Tooltip = 'Reloads vape for debugging purposes'
})

local modules = mainapi.Categories.Main:CreateSettingsPane('Modules')
modules:CreateToggle({
	Name = 'Teams by server',
	Tooltip = 'Ignore players on your team designated by the server',
	Default = true,
	Function = function()
		if mainapi.Libraries.entity and mainapi.Libraries.entity.Running then
			mainapi.Libraries.entity.refresh()
		end
	end
})
modules:CreateToggle({
	Name = 'Use team color',
	Tooltip = 'Uses the TeamColor property on players for render modules',
	Default = true,
	Function = function()
		if mainapi.Libraries.entity and mainapi.Libraries.entity.Running then
			mainapi.Libraries.entity.refresh()
		end
	end
})

local guipane = mainapi.Categories.Main:CreateSettingsPane('GUI')
mainapi.Blur = guipane:CreateToggle({
	Name = 'Blur background',
	Function = function()
		mainapi:BlurCheck()
	end,
	Default = true,
	Tooltip = 'Blur the background of the GUI'
})
guipane:CreateToggle({
	Name = 'GUI bind indicator',
	Default = true,
	Tooltip = "Displays a message indicating your GUI upon injecting.\nI.E. 'Press RSHIFT to open GUI'"
})
guipane:CreateToggle({
	Name = 'Show tooltips',
	Function = function(enabled)
		tooltip.Visible = false
		toolblur.Visible = enabled
	end,
	Default = true,
	Tooltip = 'Toggles visibility of these'
})
guipane:CreateToggle({
	Name = 'Show legit mode',
	Function = function(enabled)
		clickgui.Search.Background.Legit.Visible = enabled
		clickgui.Search.Background.LegitDivider.Visible = enabled
		clickgui.Search.Background.TextBox.Size = UDim2.new(1, enabled and -86 or -44, 1, 0)
		if mainapi.LegitButton then
			mainapi.LegitButton.Object.Visible = enabled
		end
	end,
	Default = true,
	Tooltip = 'Shows the button to change to Legit Mode'
})
local scaleslider = {Object = {}, Value = 1}
local autoscale = guipane:CreateToggle({
	Name = 'Auto rescale',
	Default = true,
	Function = function(callback)
		scaleslider.Object.Visible = not callback
		if callback then
			scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
		else
			scale.Scale = scaleslider.Value
		end
	end,
	Tooltip = 'Automatically rescales the gui using the screens resolution'
})
mainapi.Scale = autoscale
scaleslider = guipane:CreateSlider({
	Name = 'Scale',
	Min = 0.1,
	Max = 2,
	Decimal = 10,
	Function = function(val, final)
		if final and not autoscale.Enabled then
			scale.Scale = val
		end
	end,
	Default = 1,
	Darker = true,
	Visible = false
})

local notifpane = mainapi.Categories.Main:CreateSettingsPane('Notifications')
mainapi.Notifications = notifpane:CreateToggle({
	Name = 'Notifications',
	Function = function(enabled)
		if mainapi.ToggleNotifications.Object then
			mainapi.ToggleNotifications.Object.Visible = enabled
		end
	end,
	Tooltip = 'Shows notifications',
	Default = true
})
mainapi.ToggleNotifications = notifpane:CreateToggle({
	Name = 'Toggle alert',
	Tooltip = 'Notifies you if a module is enabled/disabled.',
	Default = true,
	Darker = true
})

mainapi.GUIColor = mainapi.Categories.Main:CreateGUISlider({
	Name = 'GUI Theme',
	Function = function(h, s, v)
		mainapi:UpdateGUI(h, s, v, true)
	end
})
mainapi.Categories.Main:CreateBind()

local textgui = mainapi:CreateOverlay({
	Name = 'Text GUI',
	Icon = getcustomasset('skidv5/assets/new/textguiicon.png'),
	Size = UDim2.fromOffset(16, 12),
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local textguisort = textgui:CreateDropdown({
	Name = 'Sort',
	List = {'Alphabetical', 'Length'},
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local textguifont = textgui:CreateFont({
	Name = 'Font',
	Blacklist = 'Arial',
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local textguicolor
local textguicolordrop = textgui:CreateDropdown({
	Name = 'Color Mode',
	List = {'Match GUI color', 'Custom color'},
	Function = function(val)
		textguicolor.Object.Visible = val == 'Custom color'
		mainapi:UpdateTextGUI()
	end
})
textguicolor = textgui:CreateColorSlider({
	Name = 'Text GUI color',
	Function = function()
		mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
	end,
	Darker = true,
	Visible = false
})
local textguiscaleobj = Instance.new('UIScale')
textguiscaleobj.Parent = textgui.Children
local textguiscale = textgui:CreateSlider({
	Name = 'Scale',
	Min = 0,
	Max = 2,
	Decimal = 10,
	Default = 1,
	Function = function(val)
		textguiscaleobj.Scale = val
		mainapi:UpdateTextGUI()
	end
})
local textguishadow = textgui:CreateToggle({
	Name = 'Shadow',
	Tooltip = 'Renders shadowed text.',
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local textguigradientv4
local textguigradient = textgui:CreateToggle({
	Name = 'Gradient',
	Tooltip = 'Renders a gradient',
	Function = function(callback)
		textguigradientv4.Object.Visible = callback
		mainapi:UpdateTextGUI()
	end
})
textguigradientv4 = textgui:CreateToggle({
	Name = 'V4 Gradient',
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
local textguianimations = textgui:CreateToggle({
	Name = 'Animations',
	Tooltip = 'Use animations on text gui',
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local textguiwatermark = textgui:CreateToggle({
	Name = 'Watermark',
	Tooltip = 'Renders a vape watermark',
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local textguibackgroundtransparency = {
	Value = 0.5,
	Object = {Visible = {}}
}
local textguibackgroundtint = {Enabled = false}
local textguibackground = textgui:CreateToggle({
	Name = 'Render background',
	Function = function(callback)
		textguibackgroundtransparency.Object.Visible = callback
		textguibackgroundtint.Object.Visible = callback
		mainapi:UpdateTextGUI()
	end
})
textguibackgroundtransparency = textgui:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Decimal = 10,
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
textguibackgroundtint = textgui:CreateToggle({
	Name = 'Tint',
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
local textguimoduleslist
local textguimodules = textgui:CreateToggle({
	Name = 'Hide modules',
	Tooltip = 'Allows you to blacklist certain modules from being shown.',
	Function = function(enabled)
		textguimoduleslist.Object.Visible = enabled
		mainapi:UpdateTextGUI()
	end
})
textguimoduleslist = textgui:CreateTextList({
	Name = 'Blacklist',
	Tooltip = 'Name of module to hide.',
	Icon = getcustomasset('skidv5/assets/new/blockedicon.png'),
	Tab = getcustomasset('skidv5/assets/new/blockedtab.png'),
	TabSize = UDim2.fromOffset(21, 16),
	Color = Color3.fromRGB(250, 50, 56),
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Visible = false,
	Darker = true
})
local textguirender = textgui:CreateToggle({
	Name = 'Hide render',
	Function = function()
		mainapi:UpdateTextGUI()
	end
})
local textguibox
local textguifontcustom
local textguicolorcustomtoggle
local textguicolorcustom
local textguitext = textgui:CreateToggle({
	Name = 'Add custom text',
	Function = function(enabled)
		textguibox.Object.Visible = enabled
		textguifontcustom.Object.Visible = enabled
		textguicolorcustomtoggle.Object.Visible = enabled
		textguicolorcustom.Object.Visible = textguicolorcustomtoggle.Enabled and enabled
		mainapi:UpdateTextGUI()
	end
})
textguibox = textgui:CreateTextBox({
	Name = 'Custom text',
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
textguifontcustom = textgui:CreateFont({
	Name = 'Custom Font',
	Blacklist = 'Arial',
	Function = function()
		mainapi:UpdateTextGUI()
	end,
	Darker = true,
	Visible = false
})
textguicolorcustomtoggle = textgui:CreateToggle({
	Name = 'Set custom text color',
	Function = function(enabled)
		textguicolorcustom.Object.Visible = enabled
		mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
	end,
	Darker = true,
	Visible = false
})
textguicolorcustom = textgui:CreateColorSlider({
	Name = 'Color of custom text',
	Function = function()
		mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
	end,
	Darker = true,
	Visible = false
})

local TextLabels = {}
local TextWatermark = Instance.new('TextLabel')
TextWatermark.Name = 'Watermark'
TextWatermark.Size = UDim2.fromOffset(100, 21)
TextWatermark.Position = UDim2.new(1, -142, 0, 3)
TextWatermark.BackgroundTransparency = 1
TextWatermark.BorderSizePixel = 0
TextWatermark.Visible = false
TextWatermark.Text = 'SKIDV5 LITE'
TextWatermark.TextSize = 15
TextWatermark.FontFace = uipallet.FontSemiBold
TextWatermark.Parent = textgui.Children
local TextWatermarkShadow = TextWatermark:Clone()
TextWatermarkShadow.Position = UDim2.fromOffset(1, 1)
TextWatermarkShadow.ZIndex = 0
TextWatermarkShadow.Visible = true
TextWatermarkShadow.TextColor3 = Color3.new()
TextWatermarkShadow.TextTransparency = 0.65
TextWatermarkShadow.Parent = TextWatermark
local TextWatermarkGradient = Instance.new('UIGradient')
TextWatermarkGradient.Rotation = 90
TextWatermarkGradient.Parent = TextWatermark
local lastside = textgui.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
mainapi:Clean(textgui.Children:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
	if mainapi.ThreadFix then
		setthreadidentity(8)
	end
	local newside = textgui.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
	if lastside ~= newside then
		lastside = newside
		mainapi:UpdateTextGUI()
	end
end))
local TextCustom = Instance.new('TextLabel')
TextCustom.Position = UDim2.fromOffset(5, 2)
TextCustom.BackgroundTransparency = 1
TextCustom.BorderSizePixel = 0
TextCustom.Visible = false
TextCustom.Text = ''
TextCustom.TextSize = 25
TextCustom.FontFace = textguifontcustom.Value
TextCustom.RichText = true
local TextCustomShadow = TextCustom:Clone()
TextCustom:GetPropertyChangedSignal('Position'):Connect(function()
	TextCustomShadow.Position = UDim2.new(TextCustom.Position.X.Scale, TextCustom.Position.X.Offset + 1, 0, TextCustom.Position.Y.Offset + 1)
end)
TextCustom:GetPropertyChangedSignal('FontFace'):Connect(function()
	TextCustomShadow.FontFace = TextCustom.FontFace
end)
TextCustom:GetPropertyChangedSignal('Text'):Connect(function()
	TextCustomShadow.Text = removeTags(TextCustom.Text)
end)
TextCustom:GetPropertyChangedSignal('Size'):Connect(function()
	TextCustomShadow.Size = TextCustom.Size
end)
TextCustomShadow.TextColor3 = Color3.new()
TextCustomShadow.TextTransparency = 0.65
TextCustomShadow.Parent = textgui.Children
TextCustom.Parent = textgui.Children
local TextHolder = Instance.new('Frame')
TextHolder.Name = 'Holder'
TextHolder.Size = UDim2.fromScale(1, 1)
TextHolder.Position = UDim2.fromOffset(5, 37)
TextHolder.BackgroundTransparency = 1
TextHolder.Parent = textgui.Children
local TextSorter = Instance.new('UIListLayout')
TextSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
TextSorter.VerticalAlignment = Enum.VerticalAlignment.Top
TextSorter.SortOrder = Enum.SortOrder.LayoutOrder
TextSorter.Parent = TextHolder

local targetinfo
local targetinfoobj
local targetinfobcolor
targetinfoobj = mainapi:CreateOverlay({
	Name = 'Target Info',
	Icon = getcustomasset('skidv5/assets/new/targetinfoicon.png'),
	Size = UDim2.fromOffset(14, 14),
	CategorySize = 240,
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat
					targetinfo:UpdateInfo()
					task.wait()
				until not targetinfoobj.Button or not targetinfoobj.Button.Enabled
			end)
		end
	end
})
local targetinfobkg = Instance.new('Frame')
targetinfobkg.Size = UDim2.fromOffset(240, 89)
targetinfobkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.1)
targetinfobkg.BackgroundTransparency = 0.5
targetinfobkg.Parent = targetinfoobj.Children
local targetinfoblurobj = addBlur(targetinfobkg)
targetinfoblurobj.Visible = false
addCorner(targetinfobkg)
local targetinfoshot = Instance.new('ImageLabel')
targetinfoshot.Size = UDim2.fromOffset(26, 27)
targetinfoshot.Position = UDim2.fromOffset(19, 17)
targetinfoshot.BackgroundColor3 = uipallet.Main
targetinfoshot.Image = 'rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420'
targetinfoshot.Parent = targetinfobkg
local targetinfoshotflash = Instance.new('Frame')
targetinfoshotflash.Size = UDim2.fromScale(1, 1)
targetinfoshotflash.BackgroundTransparency = 1
targetinfoshotflash.BackgroundColor3 = Color3.new(1, 0, 0)
targetinfoshotflash.Parent = targetinfoshot
addCorner(targetinfoshotflash)
local targetinfoshotblur = addBlur(targetinfoshot)
targetinfoshotblur.Visible = false
addCorner(targetinfoshot)
local targetinfoname = Instance.new('TextLabel')
targetinfoname.Size = UDim2.fromOffset(145, 20)
targetinfoname.Position = UDim2.fromOffset(54, 20)
targetinfoname.BackgroundTransparency = 1
targetinfoname.Text = 'Target name'
targetinfoname.TextXAlignment = Enum.TextXAlignment.Left
targetinfoname.TextYAlignment = Enum.TextYAlignment.Top
targetinfoname.TextScaled = true
targetinfoname.TextColor3 = color.Light(uipallet.Text, 0.4)
targetinfoname.TextStrokeTransparency = 1
targetinfoname.FontFace = uipallet.Font
local targetinfoshadow = targetinfoname:Clone()
targetinfoshadow.Position = UDim2.fromOffset(55, 21)
targetinfoshadow.TextColor3 = Color3.new()
targetinfoshadow.TextTransparency = 0.65
targetinfoshadow.Visible = false
targetinfoshadow.Parent = targetinfobkg
targetinfoname:GetPropertyChangedSignal('Size'):Connect(function()
	targetinfoshadow.Size = targetinfoname.Size
end)
targetinfoname:GetPropertyChangedSignal('Text'):Connect(function()
	targetinfoshadow.Text = targetinfoname.Text
end)
targetinfoname:GetPropertyChangedSignal('FontFace'):Connect(function()
	targetinfoshadow.FontFace = targetinfoname.FontFace
end)
targetinfoname.Parent = targetinfobkg
local targetinfohealthbkg = Instance.new('Frame')
targetinfohealthbkg.Name = 'HealthBKG'
targetinfohealthbkg.Size = UDim2.fromOffset(200, 9)
targetinfohealthbkg.Position = UDim2.fromOffset(20, 56)
targetinfohealthbkg.BackgroundColor3 = uipallet.Main
targetinfohealthbkg.BorderSizePixel = 0
targetinfohealthbkg.Parent = targetinfobkg
addCorner(targetinfohealthbkg, UDim.new(1, 0))
local targetinfohealth = targetinfohealthbkg:Clone()
targetinfohealth.Size = UDim2.fromScale(0.8, 1)
targetinfohealth.Position = UDim2.new()
targetinfohealth.BackgroundColor3 = Color3.fromHSV(1 / 2.5, 0.89, 0.75)
targetinfohealth.Parent = targetinfohealthbkg
targetinfohealth:GetPropertyChangedSignal('Size'):Connect(function()
	targetinfohealth.Visible = targetinfohealth.Size.X.Scale > 0.01
end)
local targetinfohealthextra = targetinfohealth:Clone()
targetinfohealthextra.Size = UDim2.new()
targetinfohealthextra.Position = UDim2.fromScale(1, 0)
targetinfohealthextra.AnchorPoint = Vector2.new(1, 0)
targetinfohealthextra.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
targetinfohealthextra.Visible = false
targetinfohealthextra.Parent = targetinfohealthbkg
targetinfohealthextra:GetPropertyChangedSignal('Size'):Connect(function()
	targetinfohealthextra.Visible = targetinfohealthextra.Size.X.Scale > 0.01
end)
local targetinfohealthblur = addBlur(targetinfohealthbkg)
targetinfohealthblur.SliceCenter = Rect.new(52, 31, 261, 510)
targetinfohealthblur.ImageColor3 = Color3.new()
targetinfohealthblur.Visible = false
local targetinfob = Instance.new('UIStroke')
targetinfob.Enabled = false
targetinfob.Color = Color3.fromHSV(0.44, 1, 1)
targetinfob.Parent = targetinfobkg
targetinfoobj:CreateFont({
	Name = 'Font',
	Blacklist = 'Arial',
	Function = function(val)
		targetinfoname.FontFace = val
	end
})
local targetinfobackgroundtransparency = {
	Value = 0.5,
	Object = {Visible = {}}
}
local targetinfodisplay = targetinfoobj:CreateToggle({
	Name = 'Use Displayname',
	Default = true
})
targetinfoobj:CreateToggle({
	Name = 'Render Background',
	Function = function(callback)
		targetinfobkg.BackgroundTransparency = callback and targetinfobackgroundtransparency.Value or 1
		targetinfoshadow.Visible = not callback
		targetinfoblurobj.Visible = callback
		targetinfohealthblur.Visible = not callback
		targetinfoshotblur.Visible = not callback
		targetinfobackgroundtransparency.Object.Visible = callback
	end,
	Default = true
})
targetinfobackgroundtransparency = targetinfoobj:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Decimal = 10,
	Function = function(val)
		targetinfobkg.BackgroundTransparency = val
	end,
	Darker = true
})
local targetinfocolor
local targetinfocolortoggle = targetinfoobj:CreateToggle({
	Name = 'Custom Color',
	Function = function(callback)
		targetinfocolor.Object.Visible = callback
		if callback then
			targetinfobkg.BackgroundColor3 = Color3.fromHSV(targetinfocolor.Hue, targetinfocolor.Sat, targetinfocolor.Value)
			targetinfoshot.BackgroundColor3 = Color3.fromHSV(targetinfocolor.Hue, targetinfocolor.Sat, math.max(targetinfocolor.Value - 0.1, 0.075))
			targetinfohealthbkg.BackgroundColor3 = targetinfoshot.BackgroundColor3
		else
			targetinfobkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.1)
			targetinfoshot.BackgroundColor3 = uipallet.Main
			targetinfohealthbkg.BackgroundColor3 = uipallet.Main
		end
	end
})
targetinfocolor = targetinfoobj:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		if targetinfocolortoggle.Enabled then
			targetinfobkg.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			targetinfoshot.BackgroundColor3 = Color3.fromHSV(hue, sat, math.max(val - 0.1, 0))
			targetinfohealthbkg.BackgroundColor3 = targetinfoshot.BackgroundColor3
		end
	end,
	Darker = true,
	Visible = false
})
targetinfoobj:CreateToggle({
	Name = 'Border',
	Function = function(callback)
		targetinfob.Enabled = callback
		targetinfobcolor.Object.Visible = callback
	end
})
targetinfobcolor = targetinfoobj:CreateColorSlider({
	Name = 'Border Color',
	Function = function(hue, sat, val, opacity)
		targetinfob.Color = Color3.fromHSV(hue, sat, val)
		targetinfob.Transparency = 1 - opacity
	end,
	Darker = true,
	Visible = false
})
local lasthealth = 0
local lastmaxhealth = 0
targetinfo = {
	Targets = {},
	Object = targetinfobkg,
	UpdateInfo = function(self)
		local entitylib = mainapi.Libraries
		if not entitylib then return end

		for i, v in self.Targets do
			if v < tick() then
				self.Targets[i] = nil
			end
		end

		local v, highest = nil, tick()
		for i, check in self.Targets do
			if check > highest then
				v = i
				highest = check
			end
		end

		targetinfobkg.Visible = v ~= nil or mainapi.gui.ScaledGui.ClickGui.Visible
		if v then
			targetinfoname.Text = v.Player and (targetinfodisplay.Enabled and v.Player.DisplayName or v.Player.Name) or v.Character and v.Character.Name or targetinfoname.Text
			targetinfoshot.Image = 'rbxthumb://type=AvatarHeadShot&id='..(v.Player and v.Player.UserId or 1)..'&w=420&h=420'

			if not v.Character then
				v.Health = v.Health or 0
				v.MaxHealth = v.MaxHealth or 100
			end

			if v.Health ~= lasthealth or v.MaxHealth ~= lastmaxhealth then
				local percent = math.max(v.Health / v.MaxHealth, 0)
				tween:Tween(targetinfohealth, TweenInfo.new(0.3), {
					Size = UDim2.fromScale(math.min(percent, 1), 1),
					BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
				})
				tween:Tween(targetinfohealthextra, TweenInfo.new(0.3), {
					Size = UDim2.fromScale(math.clamp(percent - 1, 0, 0.8), 1)
				})
				if lasthealth > v.Health and self.LastTarget == v then
					tween:Cancel(targetinfoshotflash)
					targetinfoshotflash.BackgroundTransparency = 0.3
					tween:Tween(targetinfoshotflash, TweenInfo.new(0.5), {
						BackgroundTransparency = 1
					})
				end
				lasthealth = v.Health
				lastmaxhealth = v.MaxHealth
			end

			if not v.Character then table.clear(v) end
			self.LastTarget = v
		end
		return v
	end
}
mainapi.Libraries.targetinfo = targetinfo

function mainapi:UpdateTextGUI(afterload)
	if not afterload and not mainapi.Loaded then return end
	if textgui.Button.Enabled then
		local right = textgui.Children.AbsolutePosition.X > (gui.AbsoluteSize.X / 2)
		TextWatermark.Visible = textguiwatermark.Enabled
		TextWatermark.Position = right and UDim2.new(1 / textguiscaleobj.Scale, -113, 0, 6) or UDim2.fromOffset(0, 6)
		TextWatermarkShadow.Visible = TextWatermark.Visible and textguishadow.Enabled
		TextCustom.Text = textguibox.Value
		TextCustom.FontFace = textguifontcustom.Value
		TextCustom.Visible = TextCustom.Text ~= '' and textguitext.Enabled
		TextCustomShadow.Visible = TextCustom.Visible and textguishadow.Enabled
		TextSorter.HorizontalAlignment = right and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
		TextHolder.Size = UDim2.fromScale(1 / textguiscaleobj.Scale, 1)
		TextHolder.Position = UDim2.fromOffset(right and 3 or 0, 11 + (TextWatermark.Visible and TextWatermark.Size.Y.Offset or 0) + (TextCustom.Visible and 28 or 0) + (textguibackground.Enabled and 3 or 0))
		if TextCustom.Visible then
			local size = getfontsize(removeTags(TextCustom.Text), TextCustom.TextSize, TextCustom.FontFace)
			TextCustom.Size = UDim2.fromOffset(size.X, size.Y)
			TextCustom.Position = UDim2.new(right and 1 / textguiscaleobj.Scale or 0, right and -size.X or 0, 0, (TextWatermark.Visible and 32 or 8))
		end

		local found = {}
		for _, v in TextLabels do
			if v.Enabled then
				table.insert(found, v.Object.Name)
			end
			v.Object:Destroy()
		end
		table.clear(TextLabels)

		local info = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)
		for i, v in mainapi.Modules do
			if textguimodules.Enabled and table.find(textguimoduleslist.ListEnabled, i) then continue end
			if textguirender.Enabled and v.Category == 'Render' then continue end
			if v.Enabled or table.find(found, i) then
				local holder = Instance.new('Frame')
				holder.Name = i
				holder.Size = UDim2.fromOffset()
				holder.BackgroundTransparency = 1
				holder.ClipsDescendants = true
				holder.Parent = TextHolder
				local holderbackground
				local holdercolorline
				if textguibackground.Enabled then
					holderbackground = Instance.new('Frame')
					holderbackground.Size = UDim2.new(1, 3, 1, 0)
					holderbackground.BackgroundColor3 = color.Dark(uipallet.Main, 0.15)
					holderbackground.BackgroundTransparency = textguibackgroundtransparency.Value
					holderbackground.BorderSizePixel = 0
					holderbackground.Parent = holder
					local holderline = Instance.new('Frame')
					holderline.Size = UDim2.new(1, 0, 0, 1)
					holderline.Position = UDim2.new(0, 0, 1, -1)
					holderline.BackgroundColor3 = Color3.new()
					holderline.BackgroundTransparency = 0.928 + (0.072 * math.clamp((textguibackgroundtransparency.Value - 0.5) / 0.5, 0, 1))
					holderline.BorderSizePixel = 0
					holderline.Parent = holderbackground
					local holderline2 = holderline:Clone()
					holderline2.Name = 'Line'
					holderline2.Position = UDim2.new()
					holderline2.Parent = holderbackground
					holdercolorline = Instance.new('Frame')
					holdercolorline.Size = UDim2.new(0, 2, 1, 0)
					holdercolorline.Position = right and UDim2.new(1, -5, 0, 0) or UDim2.new()
					holdercolorline.BorderSizePixel = 0
					holdercolorline.Parent = holderbackground
				end
				local holdertext = Instance.new('TextLabel')
				holdertext.Position = UDim2.fromOffset(right and 3 or 6, 2)
				holdertext.BackgroundTransparency = 1
				holdertext.BorderSizePixel = 0
				holdertext.Text = i..(v.ExtraText and " <font color='#A8A8A8'>"..v.ExtraText()..'</font>' or '')
				holdertext.TextSize = 15
				holdertext.FontFace = textguifont.Value
				holdertext.RichText = true
				local size = getfontsize(removeTags(holdertext.Text), holdertext.TextSize, holdertext.FontFace)
				holdertext.Size = UDim2.fromOffset(size.X, size.Y)
				if textguishadow.Enabled then
					local holderdrop = holdertext:Clone()
					holderdrop.Position = UDim2.fromOffset(holdertext.Position.X.Offset + 1, holdertext.Position.Y.Offset + 1)
					holderdrop.Text = removeTags(holdertext.Text)
					holderdrop.TextColor3 = Color3.new()
					holderdrop.Parent = holder
				end
				holdertext.Parent = holder
				local holdersize = UDim2.fromOffset(size.X + 10, size.Y + (textguibackground.Enabled and 5 or 3))
				if textguianimations.Enabled then
					if not table.find(found, i) then
						tween:Tween(holder, info, {
							Size = holdersize
						})
					else
						holder.Size = holdersize
						if not v.Enabled then
							tween:Tween(holder, info, {
								Size = UDim2.fromOffset()
							})
						end
					end
				else
					holder.Size = v.Enabled and holdersize or UDim2.fromOffset()
				end
				table.insert(TextLabels, {
					Object = holder,
					Text = holdertext,
					Background = holderbackground,
					Color = holdercolorline,
					Enabled = v.Enabled
				})
			end
		end

		if textguisort.Value == 'Alphabetical' then
			table.sort(TextLabels, function(a, b)
				return a.Text.Text < b.Text.Text
			end)
		else
			table.sort(TextLabels, function(a, b)
				return a.Text.Size.X.Offset > b.Text.Size.X.Offset
			end)
		end

		for i, v in TextLabels do
			if v.Color then
				v.Color.Parent.Line.Visible = i ~= 1
			end
			v.Object.LayoutOrder = i
		end
	end

	mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value, true)
end

function mainapi:UpdateGUI(hue, sat, val, default)
	if mainapi.Loaded == nil then return end
	if not default and mainapi.GUIColor.Rainbow then return end
	if textgui.Button.Enabled then
		TextWatermarkGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
			ColorSequenceKeypoint.new(1, textguigradient.Enabled and Color3.fromHSV(mainapi:Color((hue - 0.075) % 1)) or Color3.fromHSV(hue, sat, val))
		})
		TextCustom.TextColor3 = textguicolorcustomtoggle.Enabled and Color3.fromHSV(textguicolorcustom.Hue, textguicolorcustom.Sat, textguicolorcustom.Value) or TextWatermarkGradient.Color.Keypoints[2].Value

		local customcolor = textguicolordrop.Value == 'Custom color' and Color3.fromHSV(textguicolor.Hue, textguicolor.Sat, textguicolor.Value) or nil
		for i, v in TextLabels do
			v.Text.TextColor3 = customcolor or (mainapi.GUIColor.Rainbow and Color3.fromHSV(mainapi:Color((hue - ((i + 2) * 0.025)) % 1)) or TextWatermarkGradient.Color.Keypoints[2].Value)
			if v.Color then
				v.Color.BackgroundColor3 = v.Text.TextColor3
			end
			if textguibackgroundtint.Enabled and v.Background then
				v.Background.BackgroundColor3 = color.Dark(v.Text.TextColor3, 0.75)
			end
		end
	end

	if not clickgui.Visible and not mainapi.Legit.Window.Visible then return end
	local rainbow = mainapi.GUIColor.Rainbow

	for i, v in mainapi.Categories do
		if i == 'Main' then
			v.Object.Header.Title.TextColor3 = Color3.fromHSV(hue, sat, val)
			for _, button in v.Buttons do
				if button.Enabled then
					button.Object.Title.TextColor3 = rainbow and Color3.fromHSV(mainapi:Color((hue - (button.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)
					button.Object.Highlight.BackgroundColor3 = button.Object.Title.TextColor3
					if button.Icon then
						button.Icon.ImageColor3 = button.Object.Title.TextColor3
					end
				end
			end
		end

		if v.Options then
			for _, option in v.Options do
				if option.Color then
					option:Color(hue, sat, val, rainbow)
				end
			end
		end

		if v.Type == 'CategoryList' then
			v.Object.Children.Add.AddButton.ImageColor3 = rainbow and Color3.fromHSV(mainapi:Color(hue % 1)) or Color3.fromHSV(hue, sat, val)
			if v.Selected then
				v.Selected.Object.BackgroundColor3 = rainbow and Color3.fromHSV(mainapi:Color(hue % 1)) or Color3.fromHSV(hue, sat, val)
				v.Selected.Object.Title.TextColor3 = mainapi.GUIColor.Rainbow and Color3.new(0.19, 0.19, 0.19) or mainapi:TextColor(hue, sat, val)
				v.Selected.Object.Dots.Dots.ImageColor3 = v.Selected.Object.Title.TextColor3
			end
		end
	end

	for _, button in mainapi.Modules do
		if button.Enabled then
			button.Object.BackgroundColor3 = rainbow and Color3.fromHSV(mainapi:Color((hue - (button.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)
			button.Object.TextColor3 = mainapi.GUIColor.Rainbow and Color3.new(0.19, 0.19, 0.19) or mainapi:TextColor(hue, sat, val)
			button.Object.UIGradient.Enabled = false
			local namelabel = button.Object:FindFirstChildOfClass('TextLabel')
			if namelabel then
				namelabel.TextColor3 = button.Object.TextColor3
			end
			button.Object.Bind.Icon.ImageColor3 = button.Object.TextColor3
			button.Object.Bind.TextLabel.TextColor3 = button.Object.TextColor3
			button.Object.Dots.Dots.ImageColor3 = button.Object.TextColor3
		end

		for _, option in button.Options do
			if option.Color then
				option:Color(hue, sat, val, rainbow)
			end
		end
	end

	for i, v in mainapi.Overlays.Toggles do
		if v.Enabled then
			v.Object.Knob.BackgroundColor3 = rainbow and Color3.fromHSV(mainapi:Color((hue - (i * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
		end
	end

	if mainapi.Legit.Icon then
		mainapi.Legit.Icon.ImageColor3 = Color3.fromHSV(hue, sat, val)
	end

	if mainapi.Legit.Window.Visible then
		for _, v in mainapi.Legit.Modules do
			if v.Enabled then
				v.Object.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
				v.Object.TextColor3 = mainapi:TextColor(hue, sat, val)
				v.Object.Bind.Icon.ImageColor3 = v.Object.TextColor3
				v.Object.Bind.TextLabel.TextColor3 = v.Object.TextColor3
				v.Object.Dots.Dots.ImageColor3 = v.Object.TextColor3
			end

			for _, option in v.Options do
				if option.Color then
					option:Color(hue, sat, val, rainbow)
				end
			end
		end
	end
end

mainapi:Clean(inputService.InputBegan:Connect(function(inputObj)
	if not inputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		table.insert(mainapi.HeldKeybinds, inputObj.KeyCode.Name)
		if mainapi.Binding then return end

		if checkKeybinds(mainapi.HeldKeybinds, mainapi.Keybind, inputObj.KeyCode.Name) then
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			for _, v in mainapi.Windows do
				v.Visible = false
			end
			clickgui.Visible = not clickgui.Visible
			tooltip.Visible = false
			mainapi:BlurCheck()
		end

		local toggled = false
		for i, v in mainapi.Modules do
			if checkKeybinds(mainapi.HeldKeybinds, v.Bind, inputObj.KeyCode.Name) then
				toggled = true
				if mainapi.ToggleNotifications.Enabled then
					mainapi:CreateNotification('Module Toggled', i.."<font color='#FFFFFF'> has been </font>"..(not v.Enabled and "<font color='#5AFF5A'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>").."<font color='#FFFFFF'>!</font>", 0.75)
				end
				v:Toggle(true)
			end
		end
		if toggled then
			mainapi:UpdateTextGUI()
		end

		for _, v in mainapi.Profiles do
			if checkKeybinds(mainapi.HeldKeybinds, v.Bind, inputObj.KeyCode.Name) and v.Name ~= mainapi.Profile then
				mainapi:SetProfile(v.Name)
				break
			end
		end
	end
end))

mainapi:Clean(inputService.InputEnded:Connect(function(inputObj)
	if not inputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		if mainapi.Binding then
			if not mainapi.MultiKeybind.Enabled then
				mainapi.HeldKeybinds = {inputObj.KeyCode.Name}
			end
			mainapi.Binding:SetBind(checkKeybinds(mainapi.HeldKeybinds, mainapi.Binding.Bind, inputObj.KeyCode.Name) and {} or mainapi.HeldKeybinds, true)
			mainapi.Binding = nil
		end
	end

	local ind = table.find(mainapi.HeldKeybinds, inputObj.KeyCode.Name)
	if ind then
		table.remove(mainapi.HeldKeybinds, ind)
	end
end))

return mainapi

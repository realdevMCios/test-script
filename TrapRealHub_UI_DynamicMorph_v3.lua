-- TRAPREAL HUB | UI ONLY TEMPLATE
-- UI-only standalone hub with a same-surface Dynamic Island spring morph.
-- No Blox Fruits gameplay, farming, ESP, combat, teleport, or tween logic is included.
-- All feature controls are visual placeholders with intentionally empty callbacks.
-- The full rounded window morphs into a clickable pill; connect gameplay logic later.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

function BF_LoadUILibrary()
	-- Standalone UI: no external UI library, no remote UI loader.
	local Players = game:GetService("Players")
	local UIS = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local LP = Players.LocalPlayer
	local Library = { AutoSave = false, Settings = {}, Unloaded = false, BindCount = 0, _connections = {} }
	local UI_TEXT_SCALE = 1.0
	local function trackConnection(conn)
		if conn then Library._connections[#Library._connections + 1] = conn end
		return conn
	end
	local C = {
		BG = Color3.fromRGB(7, 8, 10), Panel = Color3.fromRGB(14, 15, 18), Card = Color3.fromRGB(22, 24, 27),
		Card2 = Color3.fromRGB(32, 35, 39), Line = Color3.fromRGB(82, 86, 93), Text = Color3.fromRGB(248, 249, 251),
		Muted = Color3.fromRGB(159, 164, 172), Accent = Color3.fromRGB(245, 247, 250), Accent2 = Color3.fromRGB(83, 88, 96),
		Green = Color3.fromRGB(235, 238, 242), Red = Color3.fromRGB(225, 228, 232),
	}
	local function new(class, props, parent)
		local obj = Instance.new(class)
		for k, v in pairs(props or {}) do obj[k] = v end
		obj.Parent = parent
		return obj
	end
	local function corner(obj, radius)
		return new("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, obj)
	end
	local function stroke(obj, color, transparency)
		return new("UIStroke", { Color = color or C.Line, Transparency = transparency or 0, Thickness = 1 }, obj)
	end
	local function label(parent, text, size, color, bold)
		return new("TextLabel", {
			BackgroundTransparency = 1, Text = tostring(text or ""), Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium,
			TextSize = math.max(11, math.floor((tonumber(size) or 13) * UI_TEXT_SCALE + 0.5)), TextColor3 = color or C.Text, TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = true,
		}, parent)
	end
	local function button(parent, text, size, bg, fg)
		local b = new("TextButton", {
			AutoButtonColor = false, Text = tostring(text or ""), Font = Enum.Font.GothamSemibold, TextSize = math.max(11, math.floor((tonumber(size) or 12) * UI_TEXT_SCALE + 0.5)),
			TextColor3 = fg or C.Text, BackgroundColor3 = bg or C.Card2, BorderSizePixel = 0,
		}, parent)
		corner(b, 12)
		return b
	end
	local function tween(obj, props, duration)
		if not obj or not obj.Parent then return end
		local ok, tw = pcall(function()
			return TweenService:Create(obj, TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
		end)
		if ok and tw then tw:Play() end
	end
	local function safeCall(cb, ...)
		if type(cb) ~= "function" then return end
		local args = table.pack(...)
		task.defer(function()
			local ok, err = pcall(cb, table.unpack(args, 1, args.n))
			if not ok then warn("[CustomUI] callback: " .. tostring(err)) end
		end)
	end

	function Library:CreateWindow(options)
		options = options or {}
		local parent
		pcall(function() if gethui then parent = gethui() end end)
		if not parent then pcall(function() parent = game:GetService("CoreGui") end) end
		if not parent then parent = LP:WaitForChild("PlayerGui") end
		local gui = new("ScreenGui", {
			Name = "BloxFruits_CustomHub", ResetOnSpawn = false, IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 99990,
		}, parent)
		self.Gui = gui
		local BASE_W, BASE_H = 1360, 850
		local main = new("Frame", {
			Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(BASE_W, BASE_H), BackgroundColor3 = C.BG, BorderSizePixel = 0,
			ClipsDescendants = true,
		}, gui)
		corner(main, 30)
		local mainCorner = main:FindFirstChildOfClass("UICorner")
		local mainRim = stroke(main, C.Accent, 0.78); mainRim.Thickness = 1.15
		local scale = new("UIScale", { Scale = 1 }, main)
		local header = new("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, 86), BackgroundColor3 = C.Panel, BorderSizePixel = 0 }, main)
		new("UIGradient", { Rotation = 0, Color = ColorSequence.new(Color3.fromRGB(31, 33, 37), Color3.fromRGB(13, 14, 17)) }, header)
		local accentBar = new("Frame", { Size = UDim2.new(0, 4, 1, -20), Position = UDim2.fromOffset(0, 10), BackgroundColor3 = C.Accent, BorderSizePixel = 0 }, header); corner(accentBar, 4)
		-- Branded image/monogram tile removed for a clean text-only header.
		local title = label(header, options.Title or "TRAPREAL HUB", 19, C.Text, true); title.Position = UDim2.fromOffset(26, 10); title.Size = UDim2.new(1, -190, 0, 32)
		local subtitle = label(header, options.SubTitle or "BLOX FRUITS  •  CONTROL CENTER", 10, C.Muted, true); subtitle.Position = UDim2.fromOffset(27, 45); subtitle.Size = UDim2.new(1, -190, 0, 20)
		local headerLine = new("Frame", { Name = "AccentDivider", Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.Accent, BackgroundTransparency = 0.68, BorderSizePixel = 0 }, header)
		local live = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -118, 0.5, 0), Size = UDim2.fromOffset(88, 32), BackgroundColor3 = C.Card, BorderSizePixel = 0 }, header); corner(live, 14); stroke(live, C.Line, 0.5)
		local liveDot = new("Frame", { Position = UDim2.fromOffset(11, 12), Size = UDim2.fromOffset(9, 9), BackgroundColor3 = C.Accent, BorderSizePixel = 0 }, live); corner(liveDot, 5)
		local liveText = label(live, "READY", 10, C.Text, true); liveText.Position = UDim2.fromOffset(27, 0); liveText.Size = UDim2.new(1, -30, 1, 0)
		local minimizeBtn = button(header, "—", 18, C.Card2, C.Text); minimizeBtn.AnchorPoint = Vector2.new(1, 0.5); minimizeBtn.Position = UDim2.new(1, -72, 0.5, 0); minimizeBtn.Size = UDim2.fromOffset(40, 40); stroke(minimizeBtn, C.Line, 0.58)
		local closeBtn = button(header, "×", 20, C.Card2, C.Text); closeBtn.AnchorPoint = Vector2.new(1, 0.5); closeBtn.Position = UDim2.new(1, -20, 0.5, 0); closeBtn.Size = UDim2.fromOffset(40, 40); stroke(closeBtn, C.Line, 0.58)

		local sidebar = new("Frame", { Position = UDim2.fromOffset(18, 102), Size = UDim2.new(0, 280, 1, -120), BackgroundColor3 = C.Panel, BorderSizePixel = 0 }, main); corner(sidebar, 18); stroke(sidebar, C.Line, 0.58)
		local sideCaption = label(sidebar, "NAVIGATION", 10, C.Muted, true); sideCaption.Position = UDim2.fromOffset(18, 16); sideCaption.Size = UDim2.new(1, -36, 0, 24)
		local search = new("TextBox", { Position = UDim2.fromOffset(14, 48), Size = UDim2.new(1, -28, 0, 44), BackgroundColor3 = C.Card, BorderSizePixel = 0, PlaceholderText = "Search features...", PlaceholderColor3 = C.Muted, Text = "", TextColor3 = C.Text, Font = Enum.Font.Gotham, TextSize = 15, ClearTextOnFocus = false }, sidebar); corner(search, 12); stroke(search, C.Line, 0.55)
		local nav = new("ScrollingFrame", { Position = UDim2.fromOffset(12, 104), Size = UDim2.new(1, -24, 1, -116), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y }, sidebar)
		new("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3) }, nav)
		local navLayout = new("UIListLayout", { Padding = UDim.new(0, 9), SortOrder = Enum.SortOrder.LayoutOrder }, nav)
		local content = new("Frame", { Position = UDim2.fromOffset(314, 102), Size = UDim2.new(1, -332, 1, -120), BackgroundTransparency = 1, BorderSizePixel = 0 }, main)
		local pageAccent = new("Frame", { Position = UDim2.fromOffset(2, 8), Size = UDim2.fromOffset(4, 20), BackgroundColor3 = C.Accent, BorderSizePixel = 0 }, content); corner(pageAccent, 3)
		local pageTitle = label(content, "WELCOME", 20, C.Text, true); pageTitle.Position = UDim2.fromOffset(18, 0); pageTitle.Size = UDim2.new(1, -22, 0, 36)
		local pageHint = label(content, "Choose a section from the navigation", 11, C.Muted, false); pageHint.Position = UDim2.fromOffset(19, 38); pageHint.Size = UDim2.new(1, -22, 0, 24)
		local pageHolder = new("Frame", { Position = UDim2.fromOffset(0, 70), Size = UDim2.new(1, 0, 1, -70), BackgroundTransparency = 1, BorderSizePixel = 0 }, content)
		local reopen = button(gui, "OPEN HUB", 11, C.Card2, C.Text); reopen.AnchorPoint = Vector2.new(1, 1); reopen.Position = UDim2.new(1, -18, 1, -18); reopen.Size = UDim2.fromOffset(176, 48); reopen.Visible = false; stroke(reopen, C.Line, 0.45)
		-- The main window itself morphs into a Dynamic-Island-style pill when collapsed.
		local morphPill = new("TextButton", { Name = "DynamicMorphPill", BackgroundTransparency = 1, BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), Text = "TRAPREAL HUB",
			TextColor3 = C.Text, TextSize = 16, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center, AutoButtonColor = false, Visible = false, ZIndex = 50 }, main)
		local morphDot = new("Frame", { Name = "DynamicMorphDot", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 18, 0.5, 0),
			Size = UDim2.fromOffset(9, 9), BackgroundColor3 = C.Accent, BorderSizePixel = 0, Visible = false, ZIndex = 51 }, morphPill)
		corner(morphDot, 6)

		local Window = { Main = main, Gui = gui, UIElements = { Main = main, SideBar = nav, SideBarContainer = sidebar }, MinimizeKey = options.MinimizeKey or Enum.KeyCode.LeftControl, IsFullscreen = false, Destroyed = false, Closed = false }
		local pages, tabs = {}, {}
		local activePage = nil
		local function setPage(page)
			if not page or not page.Frame then return end
			activePage = page
			for _, p in ipairs(pages) do
				p.Frame.Visible = (p == page)
				if p.NavButton then
					local selected = p == page
					tween(p.NavButton, { BackgroundColor3 = selected and Color3.fromRGB(42, 45, 50) or C.Panel }, 0.14)
					p.NavButton.TextColor3 = selected and C.Text or C.Muted
					if p.NavAccent then p.NavAccent.Visible = selected end
				end
			end
			pageTitle.Text = page.Title:upper()
			pageHint.Text = "Select an option below to configure " .. page.Title
		end
		local morphCollapsed = false
		local currentScale = 1
		local userScale = 1
		local function updateScale()
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1280, 800)
			local availableW = math.max(vp.X - 24, 120)
			local availableH = math.max(vp.Y - 24, 120)
			local factor = math.min(availableW / BASE_W, availableH / BASE_H, 1)
			currentScale = math.clamp(factor * userScale, 0.12, 1)
			if not morphCollapsed then scale.Scale = currentScale end
		end
		updateScale()
		local viewportConn
		local function bindCamera(cam)
			if viewportConn then pcall(function() viewportConn:Disconnect() end) end
			viewportConn = nil
			if cam then viewportConn = trackConnection(cam:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)) end
			updateScale()
		end
		bindCamera(workspace.CurrentCamera)
		trackConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() bindCamera(workspace.CurrentCamera) end))
		local drag, dragStart, startPos
		header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = true; dragStart = input.Position; startPos = main.Position end
		end)
		header.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end
		end)
		trackConnection(UIS.InputChanged:Connect(function(input)
			if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end))
		local transitionId = 0
		local savedPosition = main.Position
		local fullSize = main.Size
		local PILL_W, PILL_H = 218, 58
		local pillPosition = UDim2.new(0.5, 0, 0, 38)
		local function setExpandedContentVisible(visible)
			header.Visible = visible
			sidebar.Visible = visible
			content.Visible = visible
			reopen.Visible = false
		end
		local function setPillVisible(visible)
			morphPill.Visible = visible
			morphDot.Visible = visible
		end
		morphPill.MouseButton1Click:Connect(function()
			if Window.Closed then Window:Restore() end
		end)
		function Window:Minimize(instant)
			if self.Destroyed or self.Closed then return end
			transitionId = transitionId + 1
			local token = transitionId
			savedPosition = main.Position
			self.Closed = true
			morphCollapsed = true
			setPillVisible(true)
			if instant then
				setExpandedContentVisible(false)
				scale.Scale = 1
				main.Size = UDim2.fromOffset(PILL_W, PILL_H)
				main.Position = pillPosition
				mainCorner.CornerRadius = UDim.new(0, 29)
				mainRim.Transparency = 0.28
				morphPill.TextTransparency = 0
				return
			end
			morphPill.TextTransparency = 1
			local targetScale = scale.Scale
			local shrink = TweenService:Create(main, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.fromOffset(PILL_W, PILL_H), Position = pillPosition,
			})
			local shrinkScale = TweenService:Create(scale, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Scale = 1 })
			local round = TweenService:Create(mainCorner, TweenInfo.new(0.36, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { CornerRadius = UDim.new(0, 29) })
			local rim = TweenService:Create(mainRim, TweenInfo.new(0.25), { Transparency = 0.28 })
			local textIn = TweenService:Create(morphPill, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.16), { TextTransparency = 0 })
			task.delay(0.07, function()
				if transitionId == token and self.Closed then setExpandedContentVisible(false) end
			end)
			shrink:Play(); shrinkScale:Play(); round:Play(); rim:Play(); textIn:Play()
		end
		function Window:Restore(instant)
			if self.Destroyed or not self.Closed then return end
			transitionId = transitionId + 1
			local token = transitionId
			self.Closed = false
			morphCollapsed = false
			updateScale()
			local targetScale = currentScale
			if instant then
				main.Size = fullSize
				main.Position = savedPosition
				scale.Scale = targetScale
				mainCorner.CornerRadius = UDim.new(0, 30)
				mainRim.Transparency = 0.78
				setExpandedContentVisible(true)
				setPillVisible(false)
				return
			end
			main.Visible = true
			main.Size = UDim2.fromOffset(PILL_W, PILL_H)
			main.Position = pillPosition
			scale.Scale = 1
			setPillVisible(true)
			morphPill.TextTransparency = 0
			local expand = TweenService:Create(main, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = fullSize, Position = savedPosition,
			})
			local expandScale = TweenService:Create(scale, TweenInfo.new(0.48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = targetScale })
			local round = TweenService:Create(mainCorner, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { CornerRadius = UDim.new(0, 30) })
			local rim = TweenService:Create(mainRim, TweenInfo.new(0.28), { Transparency = 0.78 })
			local textOut = TweenService:Create(morphPill, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
			task.delay(0.12, function()
				if transitionId == token and not self.Closed then setExpandedContentVisible(true) end
			end)
			expand.Completed:Connect(function()
				if transitionId == token and not self.Closed then setPillVisible(false) end
			end)
			expand:Play(); expandScale:Play(); round:Play(); rim:Play(); textOut:Play()
		end
		function Window:Close() Library:Unload() end
		minimizeBtn.MouseButton1Click:Connect(function() Window:Minimize() end)
		reopen.MouseButton1Click:Connect(function() Window:Restore() end)
		closeBtn.MouseButton1Click:Connect(function() Library:Unload() end)
		trackConnection(UIS.InputBegan:Connect(function(input, processed)
			if processed or Library.Unloaded or UIS:GetFocusedTextBox() or (Library.BindCount or 0) > 0 then return end
			local key = Window.MinimizeKey
			local keyName = typeof(key) == "EnumItem" and key.Name or tostring(key)
			if input.KeyCode.Name == keyName then
				if Window.Closed then Window:Restore() else Window:Minimize() end
			end
		end))
		search:GetPropertyChangedSignal("Text"):Connect(function()
			local q = search.Text:lower()
			for _, p in ipairs(pages) do
				p.NavButton.Visible = (q == "" or p.Title:lower():find(q, 1, true) ~= nil)
			end
		end)

		function Window:AddTab(tabOptions)
			tabOptions = tabOptions or {}
			local name = tostring(tabOptions.Title or ("Page " .. (#pages + 1)))
			local navButton = button(nav, "   " .. name, 14, C.Panel, C.Muted)
			navButton.Size = UDim2.new(1, 0, 0, 50); navButton.TextXAlignment = Enum.TextXAlignment.Left
			local navAccent = new("Frame", { Name = "ActiveAccent", Position = UDim2.fromOffset(0, 9), Size = UDim2.fromOffset(4, 28), BackgroundColor3 = C.Accent, BorderSizePixel = 0, Visible = false }, navButton); corner(navAccent, 4)
			local pageFrame = new("ScrollingFrame", { Name = "Page_" .. tostring(#pages + 1), Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false }, pageHolder)
			new("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 8) }, pageFrame)
			new("UIListLayout", { Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder }, pageFrame)
			local page = { Title = name, Frame = pageFrame, NavButton = navButton, NavAccent = navAccent }
			pages[#pages + 1] = page; tabs[name] = page
			navButton.MouseButton1Click:Connect(function() setPage(page) end)

			function page:AddSection(sectionName)
				local card = new("Frame", { Name = "Section", Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.Panel, BorderSizePixel = 0 }, pageFrame)
				corner(card, 17); stroke(card, C.Line, 0.48)
				new("UIPadding", { PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) }, card)
				local stack = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y }, card)
				new("UIListLayout", { Padding = UDim.new(0, 9), SortOrder = Enum.SortOrder.LayoutOrder }, stack)
				local secTitle = label(stack, tostring(sectionName), 13, C.Accent, true); secTitle.Size = UDim2.new(1, 0, 0, 29)
				local section = {}
				local function row(titleText, descText, height)
					local r = new("Frame", { Size = UDim2.new(1, 0, 0, height or 66), BackgroundColor3 = C.Card, BorderSizePixel = 0 }, stack)
					corner(r, 12); stroke(r, C.Line, 0.62)
					local titleLbl = label(r, titleText, 11, C.Text, true); titleLbl.Position = UDim2.fromOffset(14, descText and 8 or 0); titleLbl.Size = UDim2.new(1, -146, 0, descText and 24 or (height or 66))
					if descText and tostring(descText) ~= "" then
						local d = label(r, descText, 9, C.Muted, false); d.Position = UDim2.fromOffset(14, 36); d.Size = UDim2.new(1, -150, 0, 22); d.TextYAlignment = Enum.TextYAlignment.Top
					end
					return r, titleLbl
				end
				function section:AddToggle(idx, spec)
					spec = spec or {}; local r = row(spec.Title or idx, spec.Description, 68)
					local track = button(r, "", 10, C.Card2, C.Text); track.AnchorPoint = Vector2.new(1, 0.5); track.Position = UDim2.new(1, -12, 0.5, 0); track.Size = UDim2.fromOffset(58, 30)
					local knob = new("Frame", { Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(4, 4), BackgroundColor3 = C.Muted, BorderSizePixel = 0 }, track); corner(knob, 10)
					local ctl = { Value = spec.Default == true }
					local function paint() tween(track, { BackgroundColor3 = ctl.Value and Color3.fromRGB(72, 77, 84) or C.Card2 }, 0.12); tween(knob, { Position = ctl.Value and UDim2.fromOffset(32, 4) or UDim2.fromOffset(4, 4), BackgroundColor3 = ctl.Value and C.Accent or C.Muted }, 0.12) end
					function ctl:SetValue(v, fireCb) self.Value = v == true; paint(); if fireCb ~= false then safeCall(spec.Callback, self.Value) end end
					track.MouseButton1Click:Connect(function() ctl:SetValue(not ctl.Value) end); paint(); return ctl
				end
				function section:AddButton(spec, cb)
					spec = spec or {}; local r = row(spec.Title or "Action", spec.Description, 64)
					local b = button(r, "RUN", 12, C.Card2, C.Accent); b.AnchorPoint = Vector2.new(1, 0.5); b.Position = UDim2.new(1, -14, 0.5, 0); b.Size = UDim2.fromOffset(76, 36)
					b.MouseButton1Click:Connect(function() safeCall(cb or spec.Callback) end); return { Button = b }
				end
				function section:AddParagraph(spec)
					spec = spec or {}; local r = new("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1 }, stack)
					local txt = label(r, spec.Title or "", 12, C.Muted, false); txt.Size = UDim2.fromScale(1, 1)
					local ctl = {}; function ctl:SetTitle(v) txt.Text = tostring(v or "") end; return ctl
				end
				function section:AddSlider(idx, spec)
					spec = spec or {}; local minV, maxV = tonumber(spec.Min) or 0, tonumber(spec.Max) or 100; if maxV < minV then maxV = minV end
					local val = math.clamp(tonumber(spec.Default) or minV, minV, maxV)
					local r = new("Frame", { Size = UDim2.new(1, 0, 0, 88), BackgroundColor3 = C.Card, BorderSizePixel = 0 }, stack); corner(r, 9)
					local titleLbl = label(r, spec.Title or idx, 11, C.Text, true); titleLbl.Position = UDim2.fromOffset(14, 7); titleLbl.Size = UDim2.new(1, -110, 0, 27)
					local valLbl = label(r, tostring(val), 10, C.Accent, true); valLbl.AnchorPoint = Vector2.new(1, 0); valLbl.Position = UDim2.new(1, -14, 0, 7); valLbl.Size = UDim2.fromOffset(90, 27); valLbl.TextXAlignment = Enum.TextXAlignment.Right
					local bar = new("Frame", { Position = UDim2.fromOffset(14, 54), Size = UDim2.new(1, -28, 0, 9), BackgroundColor3 = C.Card2, BorderSizePixel = 0 }, r); corner(bar, 6)
					local fill = new("Frame", { Size = UDim2.new(maxV == minV and 0 or (val - minV) / (maxV - minV), 0, 1, 0), BackgroundColor3 = C.Accent, BorderSizePixel = 0 }, bar); corner(fill, 6)
					local hit = new("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, 34), Position = UDim2.fromOffset(0, -12), AutoButtonColor = false }, bar)
					local ctl = { Value = val }; local dragging = false
					local function set(v, call)
						v = math.clamp(tonumber(v) or minV, minV, maxV); local step = tonumber(spec.Step) or ((spec.Rounding ~= nil) and (10 ^ -math.clamp(tonumber(spec.Rounding) or 0, 0, 4)) or 1); if step > 0 then v = minV + math.floor((v - minV) / step + 0.5) * step end
						if spec.Rounding ~= nil then local pow = 10 ^ math.clamp(tonumber(spec.Rounding) or 0, 0, 4); v = math.floor(v * pow + 0.5) / pow end
						ctl.Value = math.clamp(v, minV, maxV); local f = maxV == minV and 0 or (ctl.Value - minV) / (maxV - minV)
						fill.Size = UDim2.new(f, 0, 1, 0); valLbl.Text = tostring(ctl.Value); if call then safeCall(spec.Callback, ctl.Value) end
					end
					function ctl:SetValue(v, doCall) set(v, doCall ~= false) end
					local function fromX(x) local f = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1); set(minV + (maxV - minV) * f, true) end
					hit.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; fromX(input.Position.X) end end)
				hit.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
					trackConnection(UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then fromX(input.Position.X) end end))
					return ctl
				end
				function section:AddInput(idx, spec)
					spec = spec or {}; local r = row(spec.Title or idx, nil, 68)
					local box = new("TextBox", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(176, 42), BackgroundColor3 = C.Card2, BorderSizePixel = 0, Text = tostring(spec.Default or ""), PlaceholderText = spec.Placeholder or "Type here...", PlaceholderColor3 = C.Muted, TextColor3 = C.Text, Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false }, r); corner(box, 8)
					local ctl = {}; function ctl:SetValue(v) box.Text = tostring(v or "") end
					box.FocusLost:Connect(function()
						if spec.Numeric then
							local numeric = tonumber(box.Text)
							if numeric then box.Text = tostring(numeric) else box.Text = tostring(spec.Default or "") end
						end
						safeCall(spec.Callback, box.Text)
					end); return ctl
				end
				function section:AddKeybind(idx, spec)
					spec = spec or {}; local r = row(spec.Title or idx, "Click the key field, then press a key", 70)
					local keyName = tostring(spec.Default or "LeftControl"); local b = button(r, keyName, 10, C.Card2, C.Accent); b.AnchorPoint = Vector2.new(1, 0.5); b.Position = UDim2.new(1, -10, 0.5, 0); b.Size = UDim2.fromOffset(128, 38)
					b.MouseButton1Click:Connect(function()
						Library.BindCount = (Library.BindCount or 0) + 1
						 b.Text = "PRESS KEY"
						 local conn
						 conn = trackConnection(UIS.InputBegan:Connect(function(input, gp)
							 if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
							 keyName = input.KeyCode.Name; b.Text = keyName
							 Library.BindCount = math.max((Library.BindCount or 1) - 1, 0)
							 if conn then conn:Disconnect() end
							 safeCall(spec.Callback, keyName)
						 end))
					 end)
					return { GetValue = function() return keyName end }
				end
				function section:AddDropdown(idx, spec)
					spec = spec or {}; local values = {}; for _, v in ipairs(spec.Values or {}) do values[#values + 1] = tostring(v) end
					local multi = spec.Multi == true; local selected, order = {}, {}
					if multi and type(spec.Default) == "table" then for _, v in ipairs(spec.Default) do selected[tostring(v)] = true; order[#order + 1] = tostring(v) end elseif not multi and spec.Default ~= nil then selected[tostring(spec.Default)] = true end
					local r = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.Card, BorderSizePixel = 0 }, stack); corner(r, 9)
					local head = button(r, "", 10, C.Card, C.Text); head.Size = UDim2.new(1, 0, 0, 55); head.TextXAlignment = Enum.TextXAlignment.Left
					local t = label(head, spec.Title or idx, 11, C.Text, true); t.Position = UDim2.fromOffset(14, 0); t.Size = UDim2.new(0.48, -10, 1, 0)
					local valueLbl = label(head, "Select...  ▾", 10, C.Accent, true); valueLbl.AnchorPoint = Vector2.new(1, 0); valueLbl.Position = UDim2.new(1, -14, 0, 0); valueLbl.Size = UDim2.new(0.5, 0, 1, 0); valueLbl.TextXAlignment = Enum.TextXAlignment.Right
					local panel = new("ScrollingFrame", { Position = UDim2.fromOffset(10, 58), Size = UDim2.new(1, -20, 0, 0), BackgroundColor3 = C.Panel, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false }, r); corner(panel, 8)
					local padding = new("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) }, panel)
					new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, panel)
					local ctl = { Values = values, Value = multi and selected or (spec.Default and tostring(spec.Default) or nil), Order = order }
					local function labelText()
						if multi then local a = {}; for _, v in ipairs(order) do if selected[v] then a[#a + 1] = v end end; valueLbl.Text = (#a > 0 and table.concat(a, ", ") or "Select...") .. "  ▾"
						else valueLbl.Text = (ctl.Value or "Select...") .. "  ▾" end
					end
					local function draw()
						for _, ch in ipairs(panel:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
						for _, name in ipairs(values) do
							local chosen = multi and selected[name] or (ctl.Value == name)
							local opt = button(panel, (chosen and "✓   " or "      ") .. name, 12, chosen and Color3.fromRGB(44, 47, 52) or C.Card, chosen and C.Accent or C.Text)
							opt.Size = UDim2.new(1, -4, 0, 38); opt.TextXAlignment = Enum.TextXAlignment.Left
							opt.MouseButton1Click:Connect(function()
								if multi then
									selected[name] = not selected[name]
									if selected[name] then order[#order + 1] = name else for i = #order, 1, -1 do if order[i] == name then table.remove(order, i) end end end
									ctl.Value = selected; ctl.Order = order; safeCall(spec.Callback, selected)
								else ctl.Value = name; safeCall(spec.Callback, name); panel.Visible = false; panel.Size = UDim2.new(1, -20, 0, 0) end
								labelText(); draw()
							end)
						end
					end
					function ctl:SetValue(v)
						if multi then
							table.clear(selected); table.clear(order)
							if type(v) == "table" then if #v > 0 then for _, n in ipairs(v) do selected[tostring(n)] = true; order[#order + 1] = tostring(n) end else for _, n in ipairs(values) do if v[n] == true then selected[n] = true; order[#order + 1] = n end end end end
							ctl.Value = selected; ctl.Order = order; safeCall(spec.Callback, selected)
						else if v == nil then ctl.Value = nil else ctl.Value = tostring(v) end; safeCall(spec.Callback, ctl.Value) end
						labelText(); draw()
					end
					function ctl:GetValue() return ctl.Value end
					head.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible; panel.Size = panel.Visible and UDim2.new(1, -20, 0, math.min(#values * 41 + 12, 220)) or UDim2.new(1, -20, 0, 0); labelText() end)
					draw(); labelText(); return ctl
				end
				function section:AddSliderDropdown(idx, spec)
					spec = spec or {}; local items = spec.Items or {}; local vals = {}; local itemControls = {}; local opened = false
					local r = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.Card, BorderSizePixel = 0 }, stack); corner(r, 9)
					local head = button(r, tostring(spec.Title or idx) .. "   ▾", 13, C.Card, C.Text); head.TextXAlignment = Enum.TextXAlignment.Left; head.Size = UDim2.new(1, 0, 0, 52)
					local body = new("Frame", { Position = UDim2.fromOffset(10, 56), Size = UDim2.new(1, -16, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false }, r)
					local layout = new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, body)
					for _, item in ipairs(items) do
						local sub = new("Frame", { Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = C.Panel, BorderSizePixel = 0 }, body); corner(sub, 7)
						local nm = label(sub, item.Name, 10, C.Text, true); nm.Position = UDim2.fromOffset(12, 5); nm.Size = UDim2.new(1, -24, 0, 22)
						local mn, mx = tonumber(item.Min) or 0, tonumber(item.Max) or 100; local val = tonumber(item.Default) or mn
						local track = new("Frame", { Position = UDim2.fromOffset(12, 49), Size = UDim2.new(1, -24, 0, 8), BackgroundColor3 = C.Card2, BorderSizePixel = 0 }, sub); corner(track, 5)
						local fill = new("Frame", { Size = UDim2.new(mx == mn and 0 or math.clamp((val - mn) / (mx - mn), 0, 1), 0, 1, 0), BackgroundColor3 = C.Accent, BorderSizePixel = 0 }, track); corner(fill, 5)
						local hit = new("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, -11), AutoButtonColor = false }, track)
						local dragging = false
						local function setv(v, fire)
							val = math.clamp(v, mn, mx); if item.Rounding then local pow = 10 ^ item.Rounding; val = math.floor(val * pow + 0.5) / pow else val = math.floor(val + 0.5) end; vals[item.Name] = val
							fill.Size = UDim2.new(mx == mn and 0 or (val - mn) / (mx - mn), 0, 1, 0)
							if fire then safeCall(spec.Callback, nil, item.Name, val) end
						end
						hit.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; local f = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1); setv(mn + (mx - mn) * f, true) end end)
						hit.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
						trackConnection(UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local f = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1); setv(mn + (mx - mn) * f, true) end end))
						itemControls[item.Name] = { Set = function(v) setv(v, false) end }
					end
					local ctl = { Value = vals }
					function ctl:SetItem(name, value)
						vals[name] = value
						if itemControls[name] then itemControls[name].Set(value) end
					end
					head.MouseButton1Click:Connect(function() opened = not opened; body.Visible = opened; head.Text = tostring(spec.Title or idx) .. (opened and "   ▴" or "   ▾") end)
					return ctl
				end
				return section
			end
			if #pages == 1 then setPage(page) end
			return page
		end
		function Window:SetUIScale(v)
			userScale = math.clamp(tonumber(v) or 1, 0.5, 1)
			updateScale()
		end
		return Window
	end

	function Library:Notify(data)
		data = data or {}
		local gui = self.Gui and self.Gui.Parent and self.Gui
		if not gui then return end
		local width = math.clamp(tonumber(data.Width) or 320, 260, 480)
		local height = math.clamp(tonumber(data.Height) or 92, 82, 170)
		local duration = math.max(tonumber(data.Duration) or 4, 0)
		local fadeDuration = math.clamp(tonumber(data.FadeDuration) or 0, 0, duration)
		local toast = new("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 18), Size = UDim2.fromOffset(width, height), BackgroundColor3 = C.Panel, BorderSizePixel = 0, ZIndex = 300 }, gui)
		corner(toast, 12)
		local outline = stroke(toast, C.Accent, 0.4)
		local h = label(toast, data.Title or "TRAPREAL HUB", 12, C.Accent, true)
		h.Position = UDim2.fromOffset(12, 8); h.Size = UDim2.new(1, -24, 0, 20); h.ZIndex = 301
		local d = label(toast, data.Content or "", tonumber(data.TextSize) or 10, C.Text, false)
		d.Position = UDim2.fromOffset(12, 31); d.Size = UDim2.new(1, -24, 1, -39); d.TextYAlignment = Enum.TextYAlignment.Top; d.ZIndex = 301
		if fadeDuration > 0 then
			local faded = false
			local function fadeOut()
				if faded or not toast.Parent then return end
				faded = true
				local info = TweenInfo.new(fadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local function playFade(obj, props)
					pcall(function() TweenService:Create(obj, info, props):Play() end)
				end
				playFade(toast, { BackgroundTransparency = 1 })
				playFade(h, { TextTransparency = 1 })
				playFade(d, { TextTransparency = 1 })
				if outline then playFade(outline, { Transparency = 1 }) end
				task.delay(fadeDuration + 0.08, function()
					if toast.Parent then toast:Destroy() end
				end)
			end
			task.delay(math.max(duration - fadeDuration, 0), fadeOut)
		else
			task.delay(duration, function() if toast.Parent then toast:Destroy() end end)
		end
	end
	function Library:NotifyYesNo(data)
		data = data or {}
		local gui = self.Gui and self.Gui.Parent and self.Gui
		if not gui then return end
		local modal = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(380, 180), BackgroundColor3 = C.Panel, BorderSizePixel = 0, ZIndex = 500 }, gui); corner(modal, 14); stroke(modal, C.Accent, 0.2)
		local h = label(modal, data.Title or "Confirm", 14, C.Text, true); h.Position = UDim2.fromOffset(16, 12); h.Size = UDim2.new(1, -32, 0, 30); h.ZIndex = 501
		local d = label(modal, data.Content or "Continue?", 11, C.Muted, false); d.Position = UDim2.fromOffset(18, 52); d.Size = UDim2.new(1, -36, 0, 44); d.ZIndex = 501
		local yes = button(modal, data.YesText or "Yes", 11, C.Card2, C.Accent); yes.Position = UDim2.new(0, 18, 1, -56); yes.Size = UDim2.new(0.5, -24, 0, 40); yes.ZIndex = 501
		local no = button(modal, data.NoText or "No", 11, C.Card2, C.Text); no.Position = UDim2.new(0.5, 6, 1, -56); no.Size = UDim2.new(0.5, -24, 0, 40); no.ZIndex = 501
		local done = false
		local function finish(choice) if done then return end; done = true; safeCall(data.Callback, choice); if modal.Parent then modal:Destroy() end end
		yes.MouseButton1Click:Connect(function() finish(true) end); no.MouseButton1Click:Connect(function() finish(false) end)
		task.delay(tonumber(data.Duration) or 20, function() if not done then finish(false) end end)
	end
	function Library:Unload()
		if self.Unloaded then return end
		self.Unloaded = true
		for _, conn in ipairs(self._connections or {}) do pcall(function() conn:Disconnect() end) end
		self._connections = {}
		pcall(function() if self.Gui and self.Gui.Parent then self.Gui:Destroy() end end)
	end
	return Library
end


-- Dynamic-Island-style morph is implemented directly on the main rounded window.



-- Build the standalone UI shell.
local Library = BF_LoadUILibrary()
local Window = Library:CreateWindow({
    Title = "TRAPREAL HUB",
    SubTitle = "UI TEMPLATE  •  NO GAMEPLAY LOGIC",
    Size = UDim2.fromOffset(1360, 850),
    TabWidth = 280,
    MinimizeKey = Enum.KeyCode.LeftControl,
})

-- Start as a compact pill; clicking it expands the same surface into the full hub.
Window:Minimize(true)

-- Helper: create pages and sections. Every callback below is intentionally empty.
local function addPage(title)
    return Window:AddTab({ Title = title })
end
local function addSection(page, title)
    return page:AddSection(title)
end
local function noop() end

local home = addPage("Home")
local homeInfo = addSection(home, "Welcome")
homeInfo:AddParagraph({ Title = "TRAPREAL HUB — UI TEMPLATE" })
homeInfo:AddParagraph({ Title = "This build contains interface elements only. No gameplay features are connected." })
homeInfo:AddParagraph({ Title = "Use the Dynamic Island pill to open or collapse the large menu. Press LeftControl to toggle the menu." })
homeInfo:AddButton({ Title = "Example button", Description = "Visual test only — no action is connected." }, noop)

local farm = addPage("Farm")
local farmMain = addSection(farm, "Farming controls")
farmMain:AddToggle("Auto Farm Level", { Title = "Auto Farm Level", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
farmMain:AddToggle("Farm Mastery", { Title = "Farm Mastery", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
farmMain:AddToggle("Farm Boss", { Title = "Farm Boss", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
farmMain:AddDropdown("Farm Mode", { Title = "Farm Mode", Values = { "Level", "Mastery", "Boss", "Material" }, Default = "Level", Callback = noop })
farmMain:AddSlider("Farm Distance", { Title = "Farm Distance", Min = 50, Max = 500, Default = 200, Callback = noop })

local esp = addPage("ESP")
local espMain = addSection(esp, "ESP options")
espMain:AddToggle("Player ESP", { Title = "Player ESP", Description = "UI placeholder — renderer not connected.", Default = false, Callback = noop })
espMain:AddToggle("Fruit ESP", { Title = "Fruit ESP", Description = "UI placeholder — renderer not connected.", Default = false, Callback = noop })
espMain:AddToggle("Berry ESP", { Title = "Berry ESP", Description = "UI placeholder — renderer not connected.", Default = false, Callback = noop })
espMain:AddToggle("Island ESP", { Title = "Island ESP", Description = "UI placeholder — renderer not connected.", Default = false, Callback = noop })
espMain:AddToggle("Chest ESP", { Title = "Chest ESP", Description = "UI placeholder — renderer not connected.", Default = false, Callback = noop })
espMain:AddSlider("ESP Distance", { Title = "ESP Distance", Min = 250, Max = 10000, Default = 3000, Callback = noop })

local combat = addPage("Combat")
local combatMain = addSection(combat, "Combat controls")
combatMain:AddToggle("Fast Attack", { Title = "Fast Attack", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
combatMain:AddToggle("Skill Aim", { Title = "Skill Aim", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
combatMain:AddDropdown("Weapon", { Title = "Weapon", Values = { "Melee", "Sword", "Fruit", "Gun" }, Default = "Melee", Callback = noop })
combatMain:AddDropdown("Skill", { Title = "Skill", Values = { "Z", "X", "C", "V", "F" }, Multi = true, Default = { "Z", "X" }, Callback = noop })

local travel = addPage("Travel")
local travelMain = addSection(travel, "Movement controls")
travelMain:AddToggle("Bring Mob", { Title = "Bring Mob", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
travelMain:AddToggle("Tween to Mob", { Title = "Tween to Mob", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
travelMain:AddDropdown("Destination", { Title = "Destination", Values = { "First Sea", "Second Sea", "Third Sea" }, Default = "First Sea", Callback = noop })
travelMain:AddSlider("Tween Speed", { Title = "Tween Speed", Min = 1, Max = 200, Default = 200, Callback = noop })
travelMain:AddButton({ Title = "Teleport", Description = "UI placeholder — no teleport action is connected." }, noop)

local misc = addPage("Misc")
local miscMain = addSection(misc, "Other options")
miscMain:AddToggle("Auto Haki", { Title = "Auto Haki", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
miscMain:AddToggle("Anti AFK", { Title = "Anti AFK", Description = "UI placeholder — logic not connected.", Default = false, Callback = noop })
miscMain:AddButton({ Title = "Rejoin", Description = "UI placeholder — no action is connected." }, noop)

local settings = addPage("Settings")
local settingsMain = addSection(settings, "Interface settings")
settingsMain:AddKeybind("Toggle GUI", { Title = "Toggle GUI", Default = "LeftControl", Callback = noop })
settingsMain:AddSlider("UI Scale", { Title = "UI Scale", Min = 0.5, Max = 1, Default = 1, Rounding = 2, Callback = function(v) Window:SetUIScale(v) end })
settingsMain:AddButton({ Title = "Unload UI", Description = "Closes this UI-only template." }, function() Library:Unload() end)

-- Apply one consistent larger type scale to every UI text element, including controls
-- whose TextSize is assigned directly instead of using the label/button helpers.
local UI_FONT_SCALE = 1.32
local function scaleTextObject(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        if not obj:GetAttribute("TRAPREAL_BaseTextSize") then
            obj:SetAttribute("TRAPREAL_BaseTextSize", obj.TextSize)
            obj.TextSize = math.max(12, math.floor(obj.TextSize * UI_FONT_SCALE + 0.5))
        end
    elseif obj:IsA("UITextSizeConstraint") then
        if not obj:GetAttribute("TRAPREAL_BaseMax") then
            obj:SetAttribute("TRAPREAL_BaseMax", obj.MaxTextSize)
            obj:SetAttribute("TRAPREAL_BaseMin", obj.MinTextSize)
            obj.MaxTextSize = math.max(12, math.floor(obj.MaxTextSize * UI_FONT_SCALE + 0.5))
            obj.MinTextSize = math.max(10, math.floor(obj.MinTextSize * UI_FONT_SCALE + 0.5))
        end
    end
end
local uiRoot = Window.Main
for _, obj in ipairs(uiRoot:GetDescendants()) do scaleTextObject(obj) end
local textScaleConnection = uiRoot.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if obj and obj.Parent then scaleTextObject(obj) end
    end)
end)
Library._connections = Library._connections or {}
Library._connections[#Library._connections + 1] = textScaleConnection

-- UI-only build: all gameplay callbacks remain intentionally disconnected.
return {
    Library = Library,
    Window = Window,
    Island = nil,
    UIOnly = true,
    MorphStyle = "Dynamic Island spring morph",
}

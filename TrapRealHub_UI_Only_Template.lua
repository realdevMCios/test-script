-- TRAPREAL HUB | UI ONLY TEMPLATE
-- UI source based on the v7 standalone UI + Dynamic Island A.
-- No Blox Fruits gameplay, farming, ESP, combat, teleport, or tween logic is included.
-- All feature controls are visual placeholders with intentionally empty callbacks.
-- Use this file as the UI layer and connect your own logic later.

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
	local UI_TEXT_SCALE = 1.20
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
		local BASE_W, BASE_H = 1480, 920
		local main = new("Frame", {
			Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(BASE_W, BASE_H), BackgroundColor3 = C.BG, BorderSizePixel = 0,
			ClipsDescendants = true,
		}, gui)
		corner(main, 25)
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
		local function updateScale()
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1280, 800)
			local availableW = math.max(vp.X - 20, 80)
			local availableH = math.max(vp.Y - 20, 80)
			local factor = math.min(availableW / BASE_W, availableH / BASE_H, 1)
			scale.Scale = math.clamp(factor, 0.05, 1)
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
		local compactSize = UDim2.fromOffset(BASE_W * 0.965, BASE_H * 0.965)
		function Window:Minimize(instant)
			if self.Destroyed or self.Closed then return end
			transitionId = transitionId + 1
			local thisTransition = transitionId
			savedPosition = main.Position
			self.Closed = true
			reopen.Visible = false
			if instant then
				main.Visible = false
				main.Size = fullSize
				main.Position = savedPosition
				return
			end
			main.Visible = true
			local targetPosition = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, savedPosition.Y.Scale, savedPosition.Y.Offset - 9)
			local tw = TweenService:Create(main, TweenInfo.new(0.17, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = compactSize, Position = targetPosition,
			})
			tw.Completed:Connect(function()
				if transitionId == thisTransition and self.Closed and main.Parent then
					main.Visible = false
					main.Size = fullSize
					main.Position = savedPosition
				end
			end)
			tw:Play()
		end
		function Window:Restore(instant)
			if self.Destroyed or (not self.Closed and main.Visible) then return end
			transitionId = transitionId + 1
			self.Closed = false
			reopen.Visible = false
			local targetPosition = savedPosition
			if instant then
				main.Position = targetPosition
				main.Size = fullSize
				main.Visible = true
				return
			end
			main.Visible = true
			main.Size = compactSize
			main.Position = UDim2.new(targetPosition.X.Scale, targetPosition.X.Offset, targetPosition.Y.Scale, targetPosition.Y.Offset + 12)
			local tw = TweenService:Create(main, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = fullSize, Position = targetPosition,
			})
			tw:Play()
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
				if main.Visible then Window:Minimize() else Window:Restore() end
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
		function Window:SetUIScale(v) scale.Scale = math.clamp(tonumber(v) or 1, 0.32, 1) end
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


local function BF_LoadDynamicIslandModule()
	local a = {}
	a.IS = function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local V2, U2, UD = Vector2.new, UDim2.new, UDim.new
local QUAD, BACK = Enum.EasingStyle.Quad, Enum.EasingStyle.Back
local EIN, EOUT = Enum.EasingDirection.In, Enum.EasingDirection.Out
local FONT, FONTB = Enum.Font.MontserratMedium, Enum.Font.MontserratBold
local BASE_H = 1008
local SPEC = {
        Idle = { W = 148, H = 38, R = 19 },
        Wide = { W = 428, H = 100, R = 50 },
        Task = { W = 428, H = 150, R = 46 },
        Result = { W = 148, H = 150, R = 46 },
        Large = { W = 311, H = 170, R = 36 },
        Panel = { W = 311, H = 148, R = 34 },
        Square = { W = 70, H = 70, R = 22 },
        Card = { W = 340, H = 206, R = 38 },
        CardS = { W = 340, H = 194, R = 38 },
        TimerPill = { W = 184 },
        PillH = 38,
        Bubble = { D = 38, Gap = 17, Break = 11.5, Carve = 22 },
}
local SPR = {
        Expand = { r = 0.30, d = 0.80 },
        Shrink = { r = 0.22, d = 0.74 },
        Radius = { r = 0.22, d = 0.90 },
        Split = { r = 0.30, d = 0.50 },
        Merge = { r = 0.28, d = 0.92 },
        BubOpen = { r = 0.4056, d = 0.452 },
        BubClose = { r = 0.4056, d = 0.968 },
        Press = { r = 0.20, d = 0.72 },
}
local C = {
        Black = Color3.fromRGB(0, 0, 0),
        White = Color3.fromRGB(255, 255, 255),
        Sub = Color3.fromRGB(168, 173, 181),
        Dim = Color3.fromRGB(30, 32, 36),
        Tile = Color3.fromRGB(18, 20, 23),
        Track = Color3.fromRGB(67, 71, 78),
        Blue = Color3.fromRGB(245, 247, 250),
        Green = Color3.fromRGB(48, 209, 112),
        Red = Color3.fromRGB(255, 54, 76),
        Gold = Color3.fromRGB(247, 190, 64),
        GoldTile = Color3.fromRGB(30, 32, 36),
        StRed = Color3.fromRGB(255, 64, 82),
        StYellow = Color3.fromRGB(255, 200, 110),
        StGreen = Color3.fromRGB(80, 228, 130),
}
local IS = {}
local function new(class, props, kids)
        local o = Instance.new(class)
        local parent
        if class == "TextButton" or class == "ImageButton" then
                o.Selectable = false
        end
        for k, v in pairs(props or {}) do
                if k == "Parent" then
                        parent = v
                else
                        o[k] = v
                end
        end
        for _, c in ipairs(kids or {}) do
                c.Parent = o
        end
        if parent then
                o.Parent = parent
        end
        return o
end
local function frame(props, kids)
        if props.BorderSizePixel == nil then
                props.BorderSizePixel = 0
        end
        return new("Frame", props, kids)
end
local function corner(p, r)
        return new("UICorner", { CornerRadius = r and UD(0, r) or UD(0.5, 0), Parent = p })
end
local function tw(o, t, props, style, dir)
        local tween = TweenService:Create(o, TweenInfo.new(t, style or QUAD, dir or EOUT), props)
        tween:Play()
        return tween
end
local function label(parent, p)
        p.BackgroundTransparency = 1
        p.Font = p.Font or FONT
        p.TextColor3 = p.TextColor3 or C.White
        p.Parent = parent
        return new("TextLabel", p)
end
local function textW(text, size, font)
        local ok, res = pcall(function()
                return TextService:GetTextSize(text, size, font, V2(1000, 100)).X
        end)
        if ok and res then
                return res
        end
        return #text * size * 0.62
end
local function fmt(t)
        t = math.max(0, math.floor(t))
        return string.format("%d:%02d", math.floor(t / 60), t % 60)
end
local RAINBOW7 = {
        Color3.fromRGB(255, 59, 48), Color3.fromRGB(255, 149, 0), Color3.fromRGB(255, 204, 0), Color3.fromRGB(52, 199, 89),
        Color3.fromRGB(10, 132, 255), Color3.fromRGB(88, 86, 214), Color3.fromRGB(175, 82, 222),
}
local function rainbowAt(t, period, fade)
        period, fade = period or 10, fade or 2
        local x = t / period
        local i = math.floor(x)
        local f = x - i
        local a = RAINBOW7[i % 7 + 1]
        local b = RAINBOW7[(i + 1) % 7 + 1]
        local k = math.clamp((f * period - (period - fade)) / fade, 0, 1)
        k = k * k * (3 - 2 * k)
        return a:Lerp(b, k)
end
local LUCIDE = {
        play = "play", pause = "pause", x = "x", check = "check", prev = "skip-back",
        next = "skip-forward", down = "chevron-down", menu = "menu", wind = "wind",
}
local function lucide(Creator, name)
        if not (Creator and Creator.Icon) then
                return nil
        end
        local ok, res = pcall(Creator.Icon, name)
        if ok and type(res) == "table" and res[1] and type(res[2]) == "table" and res[2].ImageRectPosition then
                return res
        end
        return nil
end
local function applyIcon(lbl, icon, Creator)
        if icon == nil or icon == "" then
                return false
        end
        local s = tostring(icon)
        if tonumber(s) then
                s = "rbxassetid://" .. s
        end
        if s:find("rbxassetid") or s:find("roblox%.com/asset") then
                lbl.Image = s
                lbl.ImageRectOffset = V2(0, 0)
                lbl.ImageRectSize = V2(0, 0)
                lbl.ImageColor3 = C.White
                return true, "asset"
        end
        local res = lucide(Creator, s)
        if res then
                lbl.Image = res[1]
                lbl.ImageRectOffset = res[2].ImageRectPosition
                lbl.ImageRectSize = res[2].ImageRectSize
                return true, "lucide"
        end
        return false
end
local function bar(h, cx, cy, len, rot, thick, color)
        local f = frame({
                BackgroundColor3 = color, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(cx, cy),
                Size = UDim2.fromOffset(len, thick), Rotation = rot, Parent = h,
        })
        corner(f)
        return f
end
local function glyph(parent, kind, px, color, Creator)
        local h = new("Frame", {
                Name = "Glyph_" .. kind, BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(px, px), Parent = parent,
        })
        local res = LUCIDE[kind] and lucide(Creator, LUCIDE[kind])
        if res then
                new("ImageLabel", {
                        BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Image = res[1],
                        ImageRectOffset = res[2].ImageRectPosition, ImageRectSize = res[2].ImageRectSize,
                        ImageColor3 = color, Parent = h,
                })
                return h
        end
        local t = math.max(2, px * 0.13)
        if kind == "x" then
                bar(h, 0.5, 0.5, px * 0.95, 45, t, color)
                bar(h, 0.5, 0.5, px * 0.95, -45, t, color)
        elseif kind == "check" then
                bar(h, 0.36, 0.62, px * 0.4, 45, t, color)
                bar(h, 0.6, 0.5, px * 0.78, -50, t, color)
        elseif kind == "pause" then
                for _, x in ipairs({ 0.34, 0.66 }) do
                        local b = frame({
                                BackgroundColor3 = color, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(x, 0.5),
                                Size = UDim2.fromOffset(px * 0.22, px * 0.8), Parent = h,
                        })
                        corner(b, 2)
                end
        elseif kind == "play" then
                bar(h, 0.32, 0.5, px * 0.82, 90, t, color)
                bar(h, 0.58, 0.3, px * 0.72, 34, t, color)
                bar(h, 0.58, 0.7, px * 0.72, -34, t, color)
        elseif kind == "prev" or kind == "next" then
                local d = kind == "prev" and -1 or 1
                for _, x in ipairs({ 0.36, 0.64 }) do
                        bar(h, x, 0.34, px * 0.5, d * -45, t, color)
                        bar(h, x, 0.66, px * 0.5, d * 45, t, color)
                end
        elseif kind == "down" then
                bar(h, 0.36, 0.5, px * 0.55, 45, t, color)
                bar(h, 0.64, 0.5, px * 0.55, -45, t, color)
        else
                for _, y in ipairs({ 0.25, 0.5, 0.75 }) do
                        bar(h, 0.5, y, px * 0.8, 0, t, color)
                end
        end
        return h
end
local function recolor(h, color)
        for _, d in ipairs(h:GetDescendants()) do
                if d:IsA("ImageLabel") then
                        d.ImageColor3 = color
                elseif d:IsA("Frame") then
                        d.BackgroundColor3 = color
                end
        end
end
local function isPress(i)
        return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function pressFx(btn, scaleObj, amt)
        btn.InputBegan:Connect(function(i)
                if isPress(i) then
                        tw(scaleObj, 0.1, { Scale = amt })
                end
        end)
        btn.InputEnded:Connect(function(i)
                if isPress(i) then
                        tw(scaleObj, 0.28, { Scale = 1 }, BACK, EOUT)
                end
        end)
end
local Spring = {}
Spring.__index = Spring
function Spring.new(x, p)
        return setmetatable({ x = x, v = 0, t = x, resp = p and p.r or 0.45, damp = p and p.d or 0.8 }, Spring)
end
function Spring:to(t, p)
        self.t = t
        if p then
                self.resp, self.damp = p.r, p.d
        end
        if self.onTo then
                self.onTo()
        end
end
function Spring:snap(x)
        self.x, self.t, self.v = x, x, 0
        if self.onTo then
                self.onTo()
        end
end
function Spring:step(dt)
        local w = 2 * math.pi / self.resp
        local k, c = w * w, 2 * self.damp * w
        local n = math.max(1, math.ceil(dt / 0.005))
        local h = dt / n
        for _ = 1, n do
                local a = -k * (self.x - self.t) - c * self.v
                self.v = self.v + a * h
                self.x = self.x + self.v * h
        end
end
function IS.Attach(window, WindUI, userCfg)
        if userCfg == false then
                return nil
        end
        local cfg = {
                Top = 10, Scale = 1, Bubble = true, OpenPill = false, IdleText = "fps",
                ReplaceNotify = true, HoldTime = 0.38, DefaultDuration = 1.5,
                CollapseAfter = 1.5, LiveIntro = 3.2, BubbleIcon = nil,
        }
        if type(userCfg) == "table" then
                for k, v in pairs(userCfg) do
                        cfg[k] = v
                end
        end
        if cfg.Enabled == false then
                return nil
        end
        local Creator = WindUI and WindUI.Creator
        local Island = { Config = cfg, Spec = SPEC }
        local destroyed = false
        local parent = (WindUI and WindUI.ScreenGui and WindUI.ScreenGui.Parent)
                or (gethui and gethui())
                or Players.LocalPlayer:WaitForChild("PlayerGui")
        local old = parent:FindFirstChild("WindUI/DynamicIsland")
        if old then
                old:Destroy()
        end
        local gui = new("ScreenGui", {
                Name = "WindUI/DynamicIsland", ResetOnSpawn = false, IgnoreGuiInset = true,
                DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        pcall(function()
                gui.ScreenInsets = Enum.ScreenInsets.None
        end)
        local prot = protectgui or (syn and syn.protect_gui)
        if prot then
                pcall(prot, gui)
        end
        gui.Parent = parent
        Island.Gui = gui
        local root = new("Frame", {
                Name = "Root", BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0),
                Position = U2(0.5, 0, 0, 0), Parent = gui,
        })
        local uiScale = new("UIScale", { Scale = 1, Parent = root })
        local function boostOn()
                local f = _G.FARMX
                return cfg.TouchBoost ~= false and not (f and f.Enable and f.Enable.IslandTouchBoost == false)
        end
        local function fit()
                local cam = workspace.CurrentCamera
                local vp = cam and cam.ViewportSize or V2(1920, 1008)
                local s = (vp.Y / BASE_H) * cfg.Scale
                local lo = 0.45
                if boostOn() then
                        if UserInputService.TouchEnabled then
                                s = math.max(s * (cfg.TouchScale or 1.25), (cfg.MinTouchPx or 46) / SPEC.Bubble.D)
                                lo = 0.8
                        else
                                s = s * (cfg.PCScale or 1.08)
                        end
                end
                local maxS = (vp.X - 12) / (SPEC.Wide.W + 2 * (SPEC.Bubble.D + SPEC.Bubble.Gap))
                Island._base74 = math.clamp(math.min(s, maxS * cfg.Scale), lo, 2)
                uiScale.Scale = Island._base74 * (Island._k74 or 1) * (Island._lxShellOpen and (Island._lxShellScale or 1) or 1)
                root.Position = U2(0.5, 0, 0, cfg.Top * uiScale.Scale)
        end
        fit()
        local camConn
        if workspace.CurrentCamera then
                camConn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
        end
        local island = frame({
                Name = "Island", BackgroundColor3 = C.Black, AnchorPoint = V2(0.5, 0),
                Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(SPEC.Idle.W, SPEC.Idle.H),
                ClipsDescendants = true, ZIndex = 2, Parent = root,
        })
        local islandCorner = corner(island, SPEC.Idle.R)
        -- Persistent TRAPREAL outline: the original animated rim is hidden while idle.
        local trapRim = new("UIStroke", {
                Name = "TrapRealPermanentRim", Thickness = 1.35, Color = C.White, Transparency = 0.12,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = island,
        })
        local trapRimGradient = new("UIGradient", {
                Rotation = 0,
                Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.5, C.Red),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                }),
                Parent = trapRim,
        })
        if Creator and Creator.LGApply then
                pcall(Creator.LGApply, island, { corner = islandCorner.CornerRadius, link = islandCorner, sheen = false, touch = false, always = true })
        end
        local islandScale = new("UIScale", { Scale = 1, Parent = island })
        local GLOW = { frames = {}, corners = {}, pads = { 3, 6, 10, 15, 21, 28 }, trans = { 0.80, 0.86, 0.90, 0.93, 0.96, 0.985 }, on = false, color = nil, rimTween = nil }
        for gi = 1, #GLOW.pads do
                local gf = frame({
                        Name = "Glow" .. gi, BackgroundColor3 = Color3.fromRGB(215, 232, 245), BackgroundTransparency = 1,
                        AnchorPoint = V2(0.5, 0), Position = UDim2.fromOffset(0, -GLOW.pads[gi]), Size = UDim2.fromOffset(0, 0),
                        ZIndex = 1, Visible = false, Parent = root,
                })
                GLOW.corners[gi] = corner(gf, 20)
                GLOW.frames[gi] = gf
        end
        local rimStroke = new("UIStroke", { Thickness = 1, Color = Color3.new(1, 1, 1), Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = island })
        local rimGrad = new("UIGradient", {
                Rotation = 0,
                Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.5, C.Red), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) }),
                Parent = rimStroke,
        })
        local RING_MARGIN = 4
        local RING_THICK = 2.5
        local ringHolder = new("Frame", {
                Name = "IslandRing", BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0),
                Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(SPEC.Idle.W, SPEC.Idle.H),
                Visible = false, ZIndex = 0, Parent = root,
        })
        local ringScale = new("UIScale", { Scale = 1, Parent = ringHolder })
        local ring = {
                holder = ringHolder, scale = ringScale, segments = {}, visible = false,
                progress = 1, mode = "drain", source = nil, color = C.White, dirty = true, token = 0,
        }
        local function ringMaskSeq(t, after)
                if t <= 0.002 then
                        return NumberSequence.new(after and 0 or 1)
                elseif t >= 0.998 then
                        return NumberSequence.new(after and 1 or 0)
                end
                local high = math.min(t + 0.002, 1)
                if after then
                        return NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 1),
                                NumberSequenceKeypoint.new(t, 1),
                                NumberSequenceKeypoint.new(high, 0),
                                NumberSequenceKeypoint.new(1, 0),
                        })
                end
                return NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(t, 0),
                        NumberSequenceKeypoint.new(high, 1),
                        NumberSequenceKeypoint.new(1, 1),
                })
        end
        for i = 1, 5 do
                local vertical = (i == 2 or i == 4)
                local clip = frame({
                        Name = "RingClip" .. i, BackgroundTransparency = 1, ClipsDescendants = true,
                        Size = UDim2.fromOffset(0, 0), Visible = false, Parent = ringHolder,
                })
                local full = frame({
                        Name = "RingFull" .. i, BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0), Parent = clip,
                })
                corner(full)
                local stroke = new("UIStroke", {
                        Thickness = RING_THICK, Color = C.White, Transparency = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = full,
                })
                local mask = new("UIGradient", {
                        Transparency = NumberSequence.new(1), Rotation = vertical and 90 or 0, Parent = stroke,
                })
                ring.segments[i] = { clip = clip, full = full, stroke = stroke, mask = mask }
        end
        local function ringUpdate()
                local W = math.max(sp.W.x, 1)
                local H = math.max(sp.H.x, 1)
                local radius = H / 2
                local straight = math.max(W - H, 0)
                local half = straight / 2
                local arc = math.pi * radius
                local total = half * 2 + arc * 2 + straight
                local fill = ring.mode == "fill"
                local used = (fill and ring.progress or 1 - ring.progress) * total
                local margin = RING_MARGIN
                local starts = { 0, half, half + arc, half + arc + straight, half + arc * 2 + straight }
                local lengths = { half, arc, straight, arc, half }
                local boxes = {
                        { W / 2, -margin, half, radius + margin },
                        { W - radius, -margin, radius + margin, H + margin * 2 },
                        { radius, radius, straight, radius + margin },
                        { -margin, -margin, radius + margin, H + margin * 2 },
                        { radius, -margin, half, radius + margin },
                }
                for i = 1, 5 do
                        local seg = ring.segments[i]
                        local length = lengths[i]
                        local f
                        if length > 0.01 then
                                f = math.clamp((used - starts[i]) / length, 0, 1)
                        else
                                f = fill and 0 or 1
                        end
                        local hidden = (fill and f <= 0) or (not fill and f >= 1)
                        seg.clip.Visible = not hidden
                        if not hidden then
                                local b = boxes[i]
                                seg.clip.Position = UDim2.fromOffset(b[1], b[2])
                                seg.clip.Size = UDim2.fromOffset(b[3], b[4])
                                seg.full.Position = UDim2.fromOffset(-b[1], -b[2])
                                seg.full.Size = UDim2.fromOffset(W, H)
                                seg.stroke.Color = ring.color
                                local threshold, after
                                if i == 1 then
                                        threshold = (W / 2 + f * half) / W
                                        after = true
                                elseif i == 2 then
                                        threshold = radius * (1 - math.cos(f * math.pi)) / H
                                        after = true
                                elseif i == 3 then
                                        threshold = (W - radius - f * straight) / W
                                        after = false
                                elseif i == 4 then
                                        threshold = radius * (1 + math.cos(f * math.pi)) / H
                                        after = false
                                else
                                        threshold = (radius + f * half) / W
                                        after = true
                                end
                                if fill then after = not after end
                                seg.mask.Transparency = ringMaskSeq(threshold, after)
                        end
                end
                ring.dirty = false
        end
        local function ringShow(color, source, mode)
                local f = _G.FARMX
                if f and f.Enable and f.Enable.DimRing == false then return end
                ring.token = ring.token + 1
                ring.source = source
                ring.mode = mode or "drain"
                ring.progress = math.clamp(source and source() or 1, 0, 1)
                ring.color = color or C.White
                if not ring.visible then
                        ring.holder.Visible = true
                end
                ring.visible = true
                ring.dirty = true
                for _, seg in ipairs(ring.segments) do
                        seg.stroke.Color = ring.color
                        tw(seg.stroke, 0.3, { Transparency = 0 })
                end
                ringUpdate()
        end
        local function ringHide()
                if not ring.visible then return end
                ring.token = ring.token + 1
                local tok = ring.token
                for _, seg in ipairs(ring.segments) do
                        tw(seg.stroke, 0.25, { Transparency = 1 })
                end
                task.delay(0.32, function()
                        if ring.token == tok then
                                ring.visible = false
                                ring.holder.Visible = false
                        end
                end)
        end
        Island.Ring = { Show = ringShow, Hide = ringHide, Update = ringUpdate, ring = ring }
        local hit = new("TextButton", {
                Name = "Hit", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
                Size = UDim2.fromScale(1, 1), ZIndex = 2, Parent = island,
        })
        local HITPAD = 8
        local hitPad = new("TextButton", {
                Name = "HitPad", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
                AnchorPoint = V2(0.5, 0), Position = UDim2.fromOffset(0, -HITPAD),
                Size = UDim2.fromOffset(SPEC.Idle.W + HITPAD * 2, SPEC.Idle.H + HITPAD * 2), ZIndex = 1, Parent = root,
        })
        local neck = frame({
                Name = "Neck", BackgroundColor3 = C.Black, AnchorPoint = V2(0, 0.5), Visible = false, ZIndex = 1, Parent = root,
        })
        corner(neck)
        local bubble = new("TextButton", {
                Name = "MenuBubble", BackgroundColor3 = C.Black, AutoButtonColor = false, Text = "", AnchorPoint = V2(0.5, 0.5),
                Size = UDim2.fromOffset(SPEC.Bubble.D, SPEC.Bubble.D), BorderSizePixel = 0, Visible = false, ZIndex = 1, Parent = root,
        })
        local bubbleCorner = corner(bubble)
        if Creator and Creator.LGApply then
                pcall(Creator.LGApply, bubble, { corner = bubbleCorner.CornerRadius, link = bubbleCorner, sheen = false, touch = false, always = true })
        end
        local bubbleScale = new("UIScale", { Scale = 1, Parent = bubble })
        local bubblePad = new("TextButton", {
                Name = "BubblePad", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
                AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, HITPAD * 2, 1, HITPAD * 2), ZIndex = 1, Parent = bubble,
        })
        local bubbleIcon = new("ImageLabel", {
                BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(18, 18), ImageTransparency = 1, Parent = bubble,
        })
        local bubbleFallback
        if not (applyIcon(bubbleIcon, cfg.BubbleIcon, Creator) or applyIcon(bubbleIcon, window.Icon, Creator)) then
                bubbleIcon.Visible = false
                bubbleFallback = glyph(bubble, "menu", 16, C.White, Creator)
        end
        local DIM = { On = false, skin = nil, result = nil, downAt = 0, changedAt = 0, Glow = false, CycleSec = 3, MinShow = 0.35, Acts = nil, Promote = nil, Cards = false, Overview = false, Ctl = nil }
        local ACT_COL = {
                farm = Color3.fromRGB(255, 204, 0), track = Color3.fromRGB(10, 132, 255), media = Color3.fromRGB(255, 204, 0),
                timer = Color3.fromRGB(255, 159, 10), stopwatch = Color3.fromRGB(191, 90, 242), result = Color3.fromRGB(48, 209, 88),
                red = Color3.fromRGB(255, 69, 58), yellow = Color3.fromRGB(255, 204, 0), green = Color3.fromRGB(48, 209, 88),
        }
        Island.Dim = DIM
        DIM.Tick = function() end
        DIM.PromoteLive = function() end
        DIM.SetGlow = function() end
        local bubbleRing = new("UIStroke", { Thickness = 2, Color = Color3.fromRGB(255, 204, 0), Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bubble })
        local bubbleAct = new("ImageLabel", {
                BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(18, 18), ImageTransparency = 1, Visible = false, Parent = bubble,
        })
        local bubbleActText = new("TextLabel", {
                BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(34, 18), Text = "", TextColor3 = C.White, TextSize = 12, Font = FONTB,
                TextTransparency = 1, Visible = false, Parent = bubble,
        })
        local actScaleI = new("UIScale", { Scale = 1, Parent = bubbleAct })
        local actScaleT = new("UIScale", { Scale = 1, Parent = bubbleActText })
        local MT_FALLBACK = { media = "M", track = ">", farm = "Q", result = "OK", timer = "T", stopwatch = "S" }
        local bubbleShownKey, bubbleShownText, bubbleShownColor
        function DIM.SetBubbleSkin(sk)
                if sk == nil then
                        bubbleShownKey, bubbleShownText, bubbleShownColor = nil, nil, nil
                        bubbleAct.Visible, bubbleActText.Visible = false, false
                        return
                end
                if sk.color ~= bubbleShownColor then
                        bubbleShownColor = sk.color
                        tw(bubbleRing, 0.2, { Color = sk.color or Color3.fromRGB(255, 204, 0) })
                end
                if sk.key ~= bubbleShownKey or sk.text ~= bubbleShownText then
                        if sk.key ~= bubbleShownKey then
                                actScaleI.Scale, actScaleT.Scale = 0.7, 0.7
                                tw(actScaleI, 0.3, { Scale = 1 }, BACK, EOUT)
                                tw(actScaleT, 0.3, { Scale = 1 }, BACK, EOUT)
                        end
                        bubbleShownKey, bubbleShownText = sk.key, sk.text
                        if sk.text then
                                bubbleAct.Visible = false
                                bubbleActText.Text = sk.text
                                bubbleActText.Visible = true
                        else
                                local okI = false
                                pcall(function() okI = applyIcon(bubbleAct, sk.icon, Creator) and true or false end)
                                bubbleAct.Visible = okI
                                bubbleActText.Text = okI and "" or (MT_FALLBACK[sk.kind] or "")
                                bubbleActText.Visible = not okI
                        end
                end
        end
        local sp = {
                W = Spring.new(SPEC.Idle.W, SPR.Expand), H = Spring.new(SPEC.Idle.H, SPR.Expand),
                R = Spring.new(SPEC.Idle.R, SPR.Radius), Bubble = Spring.new(0, SPR.Split),
                Press = Spring.new(1, SPR.Press), BPress = Spring.new(1, SPR.Press), Carve = Spring.new(0, SPR.Split),
        }
        for _, s in pairs(sp) do
                s.onTo = function()
                        local w = Island.Wake
                        if w then
                                w()
                        end
                end
        end
        local windowOpen = not (window.Closed == true)
        local compactNow = true
        local bubbleShown = false
        if not windowOpen and cfg.Bubble ~= false then
                sp.Bubble:snap(1)
                sp.Carve:snap(0)
                bubbleShown = true
        end
        local function setSize(W, H, R)
                local grow = (W * H) >= (sp.W.t * sp.H.t)
                local p = grow and SPR.Expand or SPR.Shrink
                sp.W:to(W, p)
                sp.H:to(H, p)
                sp.R:to(R, SPR.Radius)
        end
        local function refreshBubble()
                local show = cfg.Bubble ~= false and not Island._lxShellOpen and (not windowOpen or (DIM.On and DIM.skin ~= nil))
                if show == bubbleShown then
                        return
                end
                bubbleShown = show
                if show then
                        sp.Bubble:to(1, SPR.BubOpen)
                        sp.Press.v = -1.1
                else
                        sp.Bubble:to(0, SPR.BubClose)
                        sp.Press.v = -2.0
                end
        end
        local views = {}
        local currentView = nil
        local XC = {}
        local current, live = nil, nil
        local function makeView(name, W, H)
                local viewClass = name == "Card" and "Frame" or "CanvasGroup"
                local props = {
                        Name = name, BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(W, H), Visible = false, ZIndex = 5, Parent = island,
                }
                if viewClass == "CanvasGroup" then props.GroupTransparency = 1 end
                local f = new(viewClass, props)
                local s = new("UIScale", { Scale = 1, Parent = f })
                return { name = name, frame = f, scale = s, W = W, H = H, token = 0 }
        end
        local function makeBody(v, bw, bh, k)
                local b = new("Frame", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(bw, bh), Parent = v.frame,
                })
                new("UIScale", { Scale = k, Parent = b })
                return b
        end
        local function navBar(parent, W, H, withChev)
                local hh = withChev and 22 or 12
                local holder = new("Frame", {
                        Name = "WANav", BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0),
                        Position = UDim2.fromOffset(W / 2, H - hh), Size = UDim2.fromOffset(64, hh), ZIndex = 10, Parent = parent,
                })
                holder.Active = false
                local bar = frame({
                        Name = "WANavBar", BackgroundColor3 = C.White, BackgroundTransparency = 0.38, AnchorPoint = V2(0.5, 0),
                        Position = UDim2.new(0.5, 0, 0, withChev and 13 or 3), Size = UDim2.fromOffset(46, 4), ZIndex = 10, Parent = holder,
                })
                bar.Active = false
                corner(bar)
                pcall(function()
                        TweenService:Create(bar, TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.12 }):Play()
                end)
                if withChev then
                        local okG, chev = pcall(glyph, holder, "down", 10, C.White, Creator)
                        if okG and chev then
                                chev.Rotation = 180
                                chev.Position = UDim2.new(0.5, 0, 0, 8)
                                pcall(function()
                                        TweenService:Create(chev, TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Position = UDim2.new(0.5, 0, 0, 3) }):Play()
                                end)
                        end
                end
                return holder
        end
        local function tweenViewAlpha(view, alpha, duration, style, direction)
                if view.frame:IsA("CanvasGroup") then
                        if math.abs(view.frame.GroupTransparency - alpha) > 0.02 then
                                tw(view.frame, duration, { GroupTransparency = alpha }, style or QUAD, direction or EOUT)
                        end
                        return
                end
                for _, child in ipairs(view.frame:GetChildren()) do
                        if child:IsA("CanvasGroup") and child.Visible and math.abs(child.GroupTransparency - alpha) > 0.02 then
                                tw(child, duration, { GroupTransparency = alpha }, style or QUAD, direction or EOUT)
                        end
                end
        end
        local function showView(v)
                if v == currentView then
                        if v and v.frame.Parent then
                                v.frame.Visible = true
                                tweenViewAlpha(v, 0, 0.14, QUAD, EOUT)
                                if math.abs(v.scale.Scale - 1) > 0.02 then
                                        tw(v.scale, 0.2, { Scale = 1 }, BACK, EOUT)
                                end
                        end
                        return
                end
                local oldv = currentView
                currentView = v
                if oldv then
                        oldv.token = oldv.token + 1
                        local t = oldv.token
                        tweenViewAlpha(oldv, 1, 0.12, QUAD, EIN)
                        tw(oldv.scale, 0.16, { Scale = 0.92 }, QUAD, EIN)
                        task.delay(0.18, function()
                                if oldv.token == t then
                                        oldv.frame.Visible = false
                                end
                        end)
                end
                if v then
                        v.token = v.token + 1
                        local t = v.token
                        v.frame.Visible = true
                        tweenViewAlpha(v, 1, 0.01, QUAD, EIN)
                        v.scale.Scale = 0.88
                        task.delay(0.08, function()
                                if destroyed or v.token ~= t then
                                        return
                                end
                                tweenViewAlpha(v, 0, 0.2, QUAD, EOUT)
                                tw(v.scale, 0.34, { Scale = 1 }, BACK, EOUT)
                        end)
                end
        end
        local function present(v, W, H, R, opts)
                opts = opts or {}
                compactNow = opts.compact == true
                setSize(W, H, R)
                showView(v)
                refreshBubble()
        end
        local function getView(name, builder)
                if not views[name] then
                        views[name] = builder()
                end
                return views[name]
        end
        local fpsAcc, fpsN, fpsVal = 0, 0, 60
        local function buildIdleClassic()
                local v = makeView("Idle", SPEC.Idle.W, SPEC.Idle.H)
                local f = v.frame
                local icon = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0, 0.5), Position = U2(0, 16, 0.5, 0),
                        Size = UDim2.fromOffset(17, 17), ImageColor3 = C.Blue, Parent = f,
                })
                local ok, kind = applyIcon(icon, window.Icon, Creator)
                if not ok then
                        icon.Visible = false
                end
                if ok and kind == "lucide" then
                        icon.ImageColor3 = C.Blue
                end
                local right = label(f, {
                        Font = FONTB, TextSize = 14, TextColor3 = C.Blue, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = U2(1, -16, 0.5, 0), Size = UDim2.fromOffset(120, 18), Text = "",
                })
                local acc = 0.5
                function v.Tick(dt)
                        acc = acc + dt
                        if acc < 0.5 then
                                return
                        end
                        acc = 0
                        if cfg.IdleText == "fps" then
                                right.Text = tostring(math.floor(fpsVal + 0.5)) .. " fps"
                        elseif cfg.IdleText == "title" then
                                right.Text = tostring(window.Title or "")
                        else
                                right.Text = ""
                        end
                end
                return v
        end
        local function buildIdle()
                if cfg.IdleStyle == "classic" then
                        return buildIdleClassic()
                end
                local v = makeView("Idle", SPEC.Idle.W, SPEC.Idle.H)
                local f = v.frame
                local bg = frame({ BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.fromScale(1, 1), Parent = f })
                new("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(42, 12, 22), Color3.fromRGB(4, 4, 7)), Parent = bg })
                corner(bg, SPEC.Idle.R)
                new("UIStroke", { Thickness = 1.2, Color = Color3.new(1, 1, 1), Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bg })
                local idleSp = frame({ BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.9, AnchorPoint = V2(0.5, 0), Position = U2(0.5, 0, 0, 2), Size = U2(1, -20, 0.4, 0), Parent = bg })
                idleSp.Active = false
                corner(idleSp)
                new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = idleSp })
                local dot = frame({
                        BackgroundColor3 = C.Red, AnchorPoint = V2(0, 0.5), Position = U2(0, 16, 0.5, 0),
                        Size = UDim2.fromOffset(12, 12), Parent = f,
                })
                corner(dot)
                local lab = label(f, {
                        Font = FONT, TextSize = 13, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        AnchorPoint = V2(0, 0.5), Position = U2(0, 36, 0.5, 0), Size = UDim2.fromOffset(110, 18), Text = "FPS",
                })
                local right = label(f, {
                        Font = FONTB, TextSize = 14, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = U2(1, -16, 0.5, 0), Size = UDim2.fromOffset(80, 18), Text = "",
                })
                local acc = 0.5
                function v.Tick(dt)
                        acc = acc + dt
                        if acc < 0.5 then
                                return
                        end
                        acc = 0
                        if cfg.IdleText == "fps" then
                                local fv = math.floor(fpsVal + 0.5)
                                lab.Text, right.Text = "FPS", tostring(fv)
                                dot.BackgroundColor3 = fv >= 60 and C.StGreen or (fv >= 30 and C.StYellow or C.Red)
                        elseif cfg.IdleText == "title" then
                                lab.Text, right.Text = tostring(window.Title or ""), ""
                        else
                                lab.Text, right.Text = "", ""
                        end
                end
                return v
        end
        local function buildPill()
                local v = makeView("Pill", 330, SPEC.PillH)
                local f = v.frame
                local icon = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0, 0.5), Position = U2(0, 16, 0.5, 0),
                        Size = UDim2.fromOffset(17, 17), Parent = f,
                })
                local lb = label(f, {
                        Font = FONTB, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                        AnchorPoint = V2(0, 0.5), Position = U2(0, 16, 0.5, 0), Size = UDim2.fromOffset(100, 18),
                })
                local right = label(f, {
                        Font = FONTB, TextSize = 14, TextColor3 = C.Blue, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = U2(1, -16, 0.5, 0), Size = UDim2.fromOffset(60, 18),
                })
                local bat = new("Frame", {
                        BackgroundTransparency = 1, AnchorPoint = V2(1, 0.5), Position = U2(1, -16, 0.5, 0),
                        Size = UDim2.fromOffset(26, 13), Visible = false, Parent = f,
                })
                local shell = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(23, 13), Parent = bat })
                corner(shell, 4)
                new("UIStroke", { Color = C.White, Transparency = 0.65, Thickness = 1, Parent = shell })
                local fill = frame({
                        BackgroundColor3 = C.Green, Position = UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(19, 9), Parent = shell,
                })
                corner(fill, 2.5)
                local cap = frame({
                        BackgroundColor3 = C.White, BackgroundTransparency = 0.65, Position = UDim2.fromOffset(24, 4.5),
                        Size = UDim2.fromOffset(2, 4), Parent = bat,
                })
                corner(cap, 1)
                local dotF = frame({
                        BackgroundColor3 = C.White, AnchorPoint = V2(0, 0.5), Position = U2(0, 16, 0.5, 0),
                        Size = UDim2.fromOffset(13, 13), Visible = false, Parent = f,
                })
                corner(dotF, 7)
                local AL = {}
                do
                        local GL = Color3.fromRGB(12, 12, 16)
                        AL.glow = frame({ Name = "WAAlGlow", BackgroundColor3 = C.White, BackgroundTransparency = 0.8, AnchorPoint = V2(0.5, 0.5),
                                Position = U2(0, 32, 0.5, 0), Size = UDim2.fromOffset(52, 52), Visible = false, Parent = f })
                        corner(AL.glow)
                        AL.pulse = frame({ Name = "WAAlPulse", BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5),
                                Position = U2(0, 32, 0.5, 0), Size = UDim2.fromOffset(36, 36), Visible = false, Parent = f })
                        corner(AL.pulse)
                        AL.pst = new("UIStroke", { Color = C.White, Thickness = 2, Transparency = 1, Parent = AL.pulse })
                        AL.disc = frame({ Name = "WAAlDisc", BackgroundColor3 = C.White, AnchorPoint = V2(0.5, 0.5),
                                Position = U2(0, 32, 0.5, 0), Size = UDim2.fromOffset(36, 36), Visible = false, Parent = f })
                        corner(AL.disc)
                        AL.ds = new("UIScale", { Scale = 1, Parent = AL.disc })
                        AL.gi = new("ImageLabel", { BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.fromOffset(20, 20), ImageColor3 = GL, Parent = AL.disc })
                        AL.gt = label(AL.disc, { Font = FONTB, TextSize = 16, TextColor3 = GL, Size = UDim2.fromScale(1, 1), Text = "", Visible = false })
                        AL.sub = label(f, { Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                                TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = V2(0, 0.5), Position = U2(0, 50, 0.5, 9),
                                Size = UDim2.fromOffset(100, 14), Visible = false })
                        AL.bar = frame({ Name = "WAAlBar", BackgroundColor3 = C.White, BackgroundTransparency = 0.15, AnchorPoint = V2(0.5, 1),
                                Position = U2(0.5, 0, 1, -2), Size = U2(1, -36, 0, 2), Visible = false, Parent = f })
                        corner(AL.bar)
                        AL.badge = label(f, { Font = FONTB, TextSize = 11, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Right,
                                AnchorPoint = V2(1, 0), Position = U2(1, -12, 0, 5), Size = UDim2.fromOffset(30, 12), Text = "", Visible = false })
                        -- [QM-GL] P78 nen den + liquid glass sang dan ve cuoi pill (thay glass xam)
                        AL.glass = frame({ Name = "WAAlGlass", BackgroundColor3 = C.White, BackgroundTransparency = 0, Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = -1, Parent = f })
                        AL.glass.Active = false
                        new("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = AL.glass })
                        new("UIGradient", {
                                Rotation = 0,
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.99), NumberSequenceKeypoint.new(0.78, 0.94), NumberSequenceKeypoint.new(1, 0.86) }),
                                Parent = AL.glass,
                        })
                        local alst = new("UIStroke", { Color = C.White, Thickness = 1, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = AL.glass })
                        new("UIGradient", {
                                Rotation = 0,
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 0.95), NumberSequenceKeypoint.new(0.8, 0.55), NumberSequenceKeypoint.new(1, 0.3) }),
                                Parent = alst,
                        })
                        AL.tok = 0
                        AL.col = C.White
                        AL.kind = "green"
                end
                local AL_ICON = { red = "x", yellow = "triangle-alert", green = "check" }
                local AL_TXT = { red = "\195\151", yellow = "!", green = "+" }
                local function alertShow(b)
                        AL.glow.Visible, AL.pulse.Visible, AL.disc.Visible, AL.bar.Visible = b, b, b, b
                        AL.glass.Visible = b
                        if not b then
                                lb.TextSize = 13
                                AL.sub.TextSize = 11
                                AL.sub.Visible = false
                                AL.badge.Visible = false
                        end
                end
                function v.Badge(n)
                        AL.badge.Visible = AL.disc.Visible and (n or 0) > 0
                        AL.badge.Text = "+" .. tostring(n or 0)
                end
                function v.Play(dur)
                        if not AL.disc.Visible then
                                return
                        end
                        AL.tok = AL.tok + 1
                        local tk = AL.tok
                        AL.ds.Scale = 0.3
                        tw(AL.ds, 0.5, { Scale = 1 }, BACK, EOUT)
                        AL.pulse.Size = UDim2.fromOffset(36, 36)
                        AL.pst.Transparency = 0.1
                        tw(AL.pulse, 0.7, { Size = UDim2.fromOffset(88, 88) }, QUAD, EOUT)
                        tw(AL.pst, 0.7, { Transparency = 1 }, QUAD, EOUT)
                        AL.glow.BackgroundTransparency = 0.45
                        tw(AL.glow, 0.9, { BackgroundTransparency = 0.82 }, QUAD, EOUT)
                        AL.bar.Size = U2(1, -36, 0, 2)
                        if dur and dur > 0 then
                                tw(AL.bar, dur, { Size = U2(0, 0, 0, 2) }, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        end
                        local kd = AL.kind
                        if kd == "red" then
                                task.spawn(function()
                                        for _, dx in ipairs({ 6, -5, 4, -3, 2, 0 }) do
                                                if AL.tok ~= tk then return end
                                                AL.disc.Position = U2(0, 32 + dx, 0.5, 0)
                                                task.wait(0.045)
                                        end
                                end)
                        elseif kd == "yellow" then
                                task.spawn(function()
                                        for _, ang in ipairs({ -16, 13, -9, 5, 0 }) do
                                                if AL.tok ~= tk then return end
                                                AL.disc.Rotation = ang
                                                task.wait(0.06)
                                        end
                                end)
                        end
                end
                local function setAlert(d)
                        local col = d.Dot
                        do
                                local fxA = _G.FARMX
                                if not (fxA and fxA.Enable and fxA.Enable.AlertBlack == false) then
                                        col = Color3.fromRGB(236, 236, 240)
                                end
                        end
                        local kd = d.Kind or "green"
                        AL.col, AL.kind = col, kd
                        alertShow(true)
                        icon.Visible, dotF.Visible, bat.Visible = false, false, false
                        right.Text = ""
                        AL.disc.BackgroundColor3, AL.glow.BackgroundColor3, AL.pst.Color, AL.bar.BackgroundColor3 = col, col, col, col
                        AL.badge.TextColor3 = col
                        AL.disc.Rotation = 0
                        AL.disc.Position = U2(0, 32, 0.5, 0)
                        local okI = false
                        pcall(function()
                                okI = applyIcon(AL.gi, AL_ICON[kd] or "info", Creator) and true or false
                        end)
                        AL.gi.Visible = okI
                        AL.gt.Visible = not okI
                        AL.gt.Text = AL_TXT[kd] or "i"
                        AL.gi.ImageColor3 = Color3.fromRGB(12, 12, 16)
                        -- [QM-BC] P77 thong bao kieu boncuti: 2 dong (tieu de 14 + noi dung 12), cao 64, disc 36, rong 230..360
                        local title = tostring(d.Text or "")
                        local sub = d.Sub and tostring(d.Sub) or ""
                        if sub == "" or sub == title then
                                sub = ({ red = "Có lỗi xảy ra", yellow = "Chú ý", green = "Hoàn tất" })[kd] or ""
                        end
                        local two = true
                        lb.Text, lb.TextColor3 = title, d.TextColor or C.White
                        lb.TextSize = 14
                        AL.sub.TextSize = 12
                        AL.sub.Text = sub
                        AL.sub.Visible = true
                        local H = 64
                        local x0 = 62
                        local lw = textW(title, 14, FONTB)
                        local sw = textW(sub, 12, FONT)
                        local W = math.clamp(x0 + math.max(lw, sw) + 30, 230, 360)
                        f.Size = UDim2.fromOffset(W, H)
                        lb.Position = U2(0, x0, 0.5, -11)
                        lb.Size = UDim2.fromOffset(W - x0 - 22, 20)
                        AL.sub.Position = U2(0, x0, 0.5, 11)
                        AL.sub.Size = UDim2.fromOffset(W - x0 - 22, 16)
                        v.W, v.H = W, H
                        return W
                end
                function v.Set(d)
                        if d.Dot ~= nil then
                                return setAlert(d)
                        end
                        alertShow(false)
                        v.H = nil
                        local hasIcon, kind = applyIcon(icon, d.Icon, Creator)
                        if hasIcon and kind == "lucide" then
                                icon.ImageColor3 = d.Color or C.Blue
                        end
                        local hasDot = d.Dot ~= nil
                        dotF.Visible = hasDot
                        if hasDot then
                                dotF.BackgroundColor3 = d.Dot
                                hasIcon = true
                        end
                        icon.Visible = hasIcon == true and not hasDot
                        local text = tostring(d.Text or "")
                        lb.Text = text
                        lb.TextColor3 = d.TextColor or C.White
                        local rt = d.Right
                        local hasBat = d.Value ~= nil
                        if hasBat then
                                local val = math.clamp(d.Value, 0, 1)
                                fill.Size = UDim2.fromOffset(math.max(2, 19 * val), 9)
                                fill.BackgroundColor3 = d.Color or C.Green
                                rt = rt or string.format("%d%%", math.floor(val * 100 + 0.5))
                        end
                        bat.Visible = hasBat
                        right.Text = rt or ""
                        right.TextColor3 = d.Color or (hasBat and C.Green or C.Blue)
                        local lw = textW(text, 13, FONTB)
                        local rw = rt and textW(rt, 14, FONTB) or 0
                        local x0 = 16 + (hasIcon and 27 or 0)
                        local extra = (rt and (rw + 14) or 0) + (hasBat and 32 or 0)
                        local W = math.clamp(x0 + lw + 16 + extra, 148, 300)
                        f.Size = UDim2.fromOffset(W, SPEC.PillH)
                        lb.Position = U2(0, x0, 0.5, 0)
                        lb.Size = UDim2.fromOffset(math.max(20, W - x0 - 16 - extra), 18)
                        right.Position = U2(1, -16 - (hasBat and 32 or 0), 0.5, 0)
                        right.Size = UDim2.fromOffset(rw + 4, 18)
                        v.W = W
                        return W
                end
                return v
        end
        local function buildWide()
                local v = makeView("Wide", SPEC.Wide.W, SPEC.Wide.H)
                local f = v.frame
                local tile = frame({
                        BackgroundColor3 = C.Tile, AnchorPoint = V2(0, 0.5), Position = U2(0, 28, 0.5, 0),
                        Size = UDim2.fromOffset(50, 50), Parent = f,
                })
                corner(tile, 14)
                local icon = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(25, 25), Parent = tile,
                })
                local letter = label(tile, {
                        Font = FONTB, TextSize = 22, TextColor3 = C.Blue, Size = UDim2.fromScale(1, 1), Text = "",
                })
                local title = label(f, {
                        Font = FONTB, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                        AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(94, 39), Size = UDim2.fromOffset(220, 20),
                })
                local sub = label(f, {
                        Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(94, 63),
                        Size = UDim2.fromOffset(220, 16),
                })
                local value = label(f, {
                        Font = FONTB, TextSize = 16, TextColor3 = C.Blue, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = UDim2.fromOffset(410, 42), Size = UDim2.fromOffset(90, 20),
                })
                local unit = label(f, {
                        Font = FONT, TextSize = 10, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = UDim2.fromOffset(410, 63), Size = UDim2.fromOffset(90, 14),
                })
                function v.Set(d)
                        local has, kind = applyIcon(icon, d.Icon, Creator)
                        if has and kind == "lucide" then
                                icon.ImageColor3 = d.Color or C.Blue
                        end
                        icon.Visible = has == true
                        letter.Visible = not has
                        letter.Text = tostring(d.Title or "!"):sub(1, 1):upper()
                        title.Text = tostring(d.Title or "")
                        sub.Text = tostring(d.Content or "")
                        value.Text = tostring(d.Value or "")
                        unit.Text = tostring(d.Unit or "")
                        value.TextColor3 = d.Color or C.Blue
                        local hasRight = d.Value ~= nil and tostring(d.Value) ~= ""
                        local tw_ = hasRight and 220 or 300
                        title.Size = UDim2.fromOffset(tw_, 20)
                        sub.Size = UDim2.fromOffset(tw_, 16)
                        if not (d.Content and tostring(d.Content) ~= "") then
                                title.Position = UDim2.fromOffset(94, 50)
                        else
                                title.Position = UDim2.fromOffset(94, 39)
                        end
                end
                return v
        end
        local function buildVerify()
                local v = makeView("Verify", SPEC.Square.W, SPEC.Square.H)
                local f = v.frame
                local ring = new("Frame", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(32, 32), Parent = f,
                })
                corner(ring)
                local st = new("UIStroke", { Color = C.White, Thickness = 3, Parent = ring })
                local grad = new("UIGradient", {
                        Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.45, 0.1),
                                NumberSequenceKeypoint.new(0.55, 0.95), NumberSequenceKeypoint.new(1, 0.9),
                        }),
                        Parent = st,
                })
                local okIcon = glyph(f, "check", 20, C.Green, Creator)
                local badIcon = glyph(f, "x", 18, C.Red, Creator)
                okIcon.Visible, badIcon.Visible = false, false
                local okScale = new("UIScale", { Scale = 0, Parent = okIcon })
                local badScale = new("UIScale", { Scale = 0, Parent = badIcon })
                v.state = "loading"
                function v.Set(state)
                        v.state = state
                        if state == "loading" then
                                grad.Enabled = true
                                st.Color = C.White
                                okIcon.Visible, badIcon.Visible = false, false
                        elseif state == "success" then
                                grad.Enabled = false
                                st.Color = C.Green
                                okIcon.Visible = true
                                okScale.Scale = 0
                                tw(okScale, 0.45, { Scale = 1 }, BACK, EOUT)
                                badIcon.Visible = false
                        else
                                grad.Enabled = false
                                st.Color = C.Red
                                badIcon.Visible = true
                                badScale.Scale = 0
                                tw(badScale, 0.45, { Scale = 1 }, BACK, EOUT)
                                okIcon.Visible = false
                                task.spawn(function()
                                        for _, x in ipairs({ 5, -5, 3, -3, 0 }) do
                                                f.Position = UDim2.new(0.5, x, 0.5, 0)
                                                task.wait(0.045)
                                        end
                                end)
                        end
                end
                function v.Tick()
                        if v.state == "loading" then
                                grad.Rotation = (os.clock() * 360) % 360
                        end
                end
                function v.Smooth()
                        return v.state == "loading"
                end
                return v
        end
        local function buildMedia()
                local v = makeView("Media", SPEC.Large.W, SPEC.Large.H)
                local f = makeBody(v, 366, 200, 0.85)
                local cover = frame({
                        BackgroundColor3 = C.Dim, Position = UDim2.fromOffset(20, 22), Size = UDim2.fromOffset(64, 64), Parent = f,
                })
                corner(cover, 10)
                local cimg = new("ImageLabel", {
                        BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, Parent = cover,
                })
                corner(cimg, 10)
                local title = label(f, {
                        Font = FONTB, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                        Position = UDim2.fromOffset(103, 31), Size = UDim2.fromOffset(200, 22),
                })
                local artist = label(f, {
                        Font = FONT, TextSize = 13, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.fromOffset(103, 56), Size = UDim2.fromOffset(200, 20),
                })
                local wave = {}
                for i = 1, 4 do
                        local b = frame({
                                BackgroundColor3 = C.Sub, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(318 + (i - 1) * 5, 44),
                                Size = UDim2.fromOffset(2.5, 4), Parent = f,
                        })
                        corner(b)
                        wave[i] = b
                end
                local tl = label(f, {
                        Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.fromOffset(20, 104), Size = UDim2.fromOffset(34, 16), Text = "0:00",
                })
                local tr = label(f, {
                        Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Right,
                        Position = UDim2.fromOffset(310, 104), Size = UDim2.fromOffset(36, 16), Text = "-0:00",
                })
                local track = frame({
                        BackgroundColor3 = C.Track, Position = UDim2.fromOffset(58, 109.5), Size = UDim2.fromOffset(246, 5), Parent = f,
                })
                corner(track)
                local fillbar = frame({
                        BackgroundColor3 = Color3.fromRGB(190, 190, 195), Size = UDim2.fromScale(0, 1), Parent = track,
                })
                corner(fillbar)
                local function ctrl(cx, kind, px)
                        local b = new("TextButton", {
                                BackgroundTransparency = 1, Text = "", AutoButtonColor = false, AnchorPoint = V2(0.5, 0.5),
                                Position = UDim2.fromOffset(cx, 157), Size = UDim2.fromOffset(40, 40), ZIndex = 6, Parent = f,
                        })
                        local s = new("UIScale", { Scale = 1, Parent = b })
                        glyph(b, kind, px, C.White, Creator)
                        pressFx(b, s, 0.86)
                        return b
                end
                v.Prev = ctrl(112, "prev", 20)
                v.Next = ctrl(251, "next", 20)
                v.Collapse = ctrl(319, "down", 18)
                recolor(v.Collapse, C.Sub)
                local playBtn = new("TextButton", {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 42), Text = "", AutoButtonColor = false, AnchorPoint = V2(0.5, 0.5),
                        Position = UDim2.fromOffset(183, 157), Size = UDim2.fromOffset(42, 42), ZIndex = 6, Parent = f,
                })
                corner(playBtn)
                local pscale = new("UIScale", { Scale = 1, Parent = playBtn })
                local gPlay = glyph(playBtn, "play", 18, C.White, Creator)
                local gPause = glyph(playBtn, "pause", 18, C.White, Creator)
                v.Play = playBtn
                pressFx(playBtn, pscale, 0.88)
                v.data = nil
                function v.Set(d)
                        v.data = d
                        local has = applyIcon(cimg, d.Cover, Creator)
                        cimg.Visible = has == true
                        title.Text = tostring(d.Title or "Not Playing")
                        artist.Text = tostring(d.Artist or "")
                        gPlay.Visible = not d.Playing
                        gPause.Visible = d.Playing == true
                end
                function v.Tick()
                        local d = v.data
                        if not d then
                                return
                        end
                        local pos, len = d.Position, d.Length
                        if type(d.Progress) == "function" then
                                local ok, p, l = pcall(d.Progress)
                                if ok then
                                        pos, len = p, l
                                end
                        end
                        if pos and len and len > 0 then
                                fillbar.Size = UDim2.fromScale(math.clamp(pos / len, 0, 1), 1)
                                tl.Text = fmt(pos)
                                tr.Text = "-" .. fmt(len - pos)
                        end
                        local now = os.clock()
                        for i = 1, 4 do
                                local h = d.Playing and (4 + math.abs(math.sin(now * 6 + i * 0.9)) * 9) or 3
                                wave[i].Size = UDim2.fromOffset(2.5, h)
                        end
                end
                function v.Smooth()
                        local dd = v.data
                        return dd ~= nil and dd.Playing == true
                end
                return v
        end
        local function buildLive()
                local v = makeView("Live", SPEC.Idle.W, SPEC.PillH)
                local f = v.frame
                local cov = new("ImageLabel", {
                        BackgroundColor3 = C.Dim, AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(10, SPEC.PillH / 2),
                        Size = UDim2.fromOffset(24, 24), ScaleType = Enum.ScaleType.Crop, Parent = f,
                })
                corner(cov, 7)
                local name = label(f, {
                        Font = FONTB, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                        AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(44, SPEC.PillH / 2), Size = UDim2.new(1, -96, 0, 18),
                })
                local wave = {}
                for i = 1, 4 do
                        local b = frame({
                                BackgroundColor3 = C.Blue, AnchorPoint = V2(0.5, 0.5), Position = U2(1, -34 + (i - 1) * 5, 0.5, 0),
                                Size = UDim2.fromOffset(2.5, 4), Parent = f,
                        })
                        corner(b)
                        wave[i] = b
                end
                function v.Set()
                        local lv = live
                        if not lv then
                                return
                        end
                        local has = applyIcon(cov, lv.data.Cover, Creator)
                        cov.Visible = has == true
                        name.Text = tostring(lv.data.Title or "")
                end
                function v.Tick()
                        local lv = live
                        if not lv then
                                return
                        end
                        local now = os.clock()
                        for i, b in ipairs(wave) do
                                local h = lv.data.Playing and (4 + math.abs(math.sin(now * 6 + i * 0.9)) * 9) or 3
                                b.Size = UDim2.fromOffset(2.5, h)
                        end
                end
                function v.Smooth()
                        local lv = live
                        return lv ~= nil and lv.data ~= nil and lv.data.Playing == true
                end
                return v
        end
        local function buildPanel()
                local v = makeView("Panel", SPEC.Panel.W, SPEC.Panel.H)
                local f = makeBody(v, 366, 158, 0.85)
                local tile = frame({
                        BackgroundColor3 = C.Tile, Position = UDim2.fromOffset(18, 16), Size = UDim2.fromOffset(42, 42), Parent = f,
                })
                corner(tile, 12)
                local icon = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(22, 22), Parent = tile,
                })
                local ok, kind = applyIcon(icon, window.Icon, Creator)
                if ok and kind == "lucide" then
                        icon.ImageColor3 = C.Blue
                end
                label(f, {
                        Font = FONTB, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                        Position = UDim2.fromOffset(72, 18), Size = UDim2.fromOffset(270, 20), Text = tostring(window.Title or "WindUI"),
                })
                label(f, {
                        Font = FONT, TextSize = 12, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.fromOffset(72, 38), Size = UDim2.fromOffset(270, 18),
                        Text = tostring(window.Author or ""),
                })
                local vals = {}
                for i, name in ipairs({ "FPS", "PING", "TIME" }) do
                        local x = 18 + (i - 1) * 110
                        label(f, {
                                Font = FONT, TextSize = 10, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                                Position = UDim2.fromOffset(x, 70), Size = UDim2.fromOffset(100, 14), Text = name,
                        })
                        vals[name] = label(f, {
                                Font = FONTB, TextSize = 18, TextColor3 = C.Blue, TextXAlignment = Enum.TextXAlignment.Left,
                                Position = UDim2.fromOffset(x, 84), Size = UDim2.fromOffset(100, 24), Text = "--",
                        })
                end
                local function pillBtn(x, w, text, bg)
                        local b = new("TextButton", {
                                BackgroundColor3 = bg, Text = "", AutoButtonColor = false, Position = UDim2.fromOffset(x, 120),
                                Size = UDim2.fromOffset(w, 28), ZIndex = 6, Parent = f,
                        })
                        corner(b)
                        local s = new("UIScale", { Scale = 1, Parent = b })
                        label(b, { Font = FONTB, TextSize = 12, Size = UDim2.fromScale(1, 1), Text = text, ZIndex = 7 })
                        pressFx(b, s, 0.93)
                        return b
                end
                v.Toggle = pillBtn(18, 160, "Toggle Menu", Color3.fromRGB(10, 100, 200))
                v.Done = pillBtn(190, 158, "Done", C.Dim)
                local acc = 0
                function v.Tick(dt)
                        acc = acc + dt
                        if acc < 0.25 then
                                return
                        end
                        acc = 0
                        vals.FPS.Text = tostring(math.floor(fpsVal + 0.5))
                        local ping = "--"
                        pcall(function()
                                ping = string.format("%dms", math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5))
                        end)
                        vals.PING.Text = ping
                        vals.TIME.Text = os.date("%H:%M")
                end
                navBar(v.frame, SPEC.Panel.W, SPEC.Panel.H, false)
                return v
        end
        local function buildTrack()
                local v = makeView("Track", SPEC.Idle.W, SPEC.PillH)
                local f = v.frame
                local icon = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0, 0.5), Position = U2(0, 16, 0.5, 0),
                        Size = UDim2.fromOffset(17, 17), ImageColor3 = C.Blue, Parent = f,
                })
                local val = label(f, {
                        Font = FONTB, TextSize = 14, TextColor3 = C.Blue, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = U2(1, -16, 0.5, 0), Size = UDim2.new(1, -46, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd, Text = "",
                })
                function v.Set()
                        local lv = live
                        if not lv or lv.kind == "media" then
                                return
                        end
                        local d = lv.data
                        local color = d.Color or (lv.kind == "farm" and C.Gold or C.Blue)
                        local has, kind = applyIcon(icon, d.Icon or (lv.kind == "farm" and "swords" or "navigation"), Creator)
                        icon.Visible = has == true
                        if has and kind == "lucide" then
                                icon.ImageColor3 = color
                        end
                        val.Text = tostring(d.Compact or d.Value or "")
                        val.TextColor3 = color
                end
                return v
        end
        local function buildTask()
                local v = makeView("Task", SPEC.Task.W, SPEC.Task.H)
                local f = v.frame
                local tile = frame({
                        BackgroundColor3 = C.GoldTile, AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(28, 50),
                        Size = UDim2.fromOffset(50, 50), Parent = f,
                })
                corner(tile, 15)
                local icon = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(26, 26), ImageColor3 = C.Gold, Parent = tile,
                })
                local title = label(f, {
                        Font = FONTB, TextSize = 15, TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(94, 40),
                        Size = UDim2.fromOffset(210, 20), Text = "",
                })
                local sub = label(f, {
                        Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(94, 62),
                        Size = UDim2.fromOffset(210, 16), Text = "",
                })
                local value = label(f, {
                        Font = FONTB, TextSize = 16, TextColor3 = C.Gold, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = UDim2.fromOffset(400, 41), Size = UDim2.fromOffset(120, 20), Text = "",
                })
                local unit = label(f, {
                        Font = FONT, TextSize = 10, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = UDim2.fromOffset(400, 62), Size = UDim2.fromOffset(120, 14), Text = "",
                })
                local track = frame({
                        BackgroundColor3 = C.Track, AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(28, 104),
                        Size = UDim2.fromOffset(372, 4), Parent = f,
                })
                corner(track)
                local fill = frame({ BackgroundColor3 = C.Gold, Size = UDim2.fromScale(0, 1), Parent = track })
                corner(fill)
                local star = XC.comet(track, C.Gold)
                local capL = label(f, {
                        Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(28, 126), Size = UDim2.fromOffset(180, 16), Text = "",
                })
                local capR = label(f, {
                        Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = UDim2.fromOffset(400, 126), Size = UDim2.fromOffset(180, 16), Text = "",
                })
                local shown = 0
                function v.Set(d)
                        v.data = d
                        local color = d.Color or C.Gold
                        local has, kind = applyIcon(icon, d.Icon or "swords", Creator)
                        icon.Visible = has == true
                        if has and kind == "lucide" then
                                icon.ImageColor3 = color
                        end
                        tile.BackgroundColor3 = d.TileColor or C.GoldTile
                        title.Text = tostring(d.Title or "")
                        sub.Text = tostring(d.Content or "")
                        value.Text = tostring(d.Value or "")
                        value.TextColor3 = color
                        unit.Text = tostring(d.Unit or "")
                        fill.BackgroundColor3 = color
                        XC.cometColor(star, color)
                        capL.Text = tostring(d.Left or "")
                        capR.Text = tostring(d.Right or "")
                end
                function v.Tick(dt)
                        local d = v.data
                        if not d then
                                return
                        end
                        local p = d.Progress
                        if type(p) == "function" then
                                local ok, r = pcall(p)
                                p = ok and r or nil
                        end
                        if type(p) == "number" then
                                local target = math.clamp(p, 0, 1)
                                if target >= shown then
                                        local fx = _G.FARMX
                                        local sec = tonumber(fx and fx.Cfg and fx.Cfg.IslandBarSec) or 18
                                        shown = math.min(target, shown + dt / math.max(4, sec))
                                else
                                        shown = shown + (target - shown) * math.min(1, dt * 10)
                                end
                                fill.Size = UDim2.fromScale(shown, 1)
                                star.Position = U2(shown, 0, 0.5, 0)
                                star.Visible = shown > 0.01
                        end
                end
                function v.Restart()
                        shown = 0
                        fill.Size = UDim2.fromScale(0, 1)
                        star.Position = U2(0, 0, 0.5, 0)
                        star.Visible = false
                end
                function v.Smooth()
                        local d = v.data
                        if not d then
                                return false
                        end
                        local p = d.Progress
                        if type(p) == "function" then
                                local ok, r = pcall(p)
                                p = ok and r or nil
                        end
                        return type(p) == "number" and math.abs(math.clamp(p, 0, 1) - shown) > 0.002
                end
                navBar(v.frame, SPEC.Task.W, SPEC.Task.H, false)
                return v
        end
        local function buildResult()
                local v = makeView("Result", SPEC.Result.W, SPEC.Result.H)
                local f = v.frame
                local ring = new("Frame", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(74, 50),
                        Size = UDim2.fromOffset(52, 52), Parent = f,
                })
                corner(ring)
                local stroke = new("UIStroke", { Color = C.Green, Thickness = 3, Parent = ring })
                local ringScale = new("UIScale", { Scale = 1, Parent = ring })
                local good = glyph(f, "check", 26, C.Green, Creator)
                good.Position = UDim2.fromOffset(74, 50)
                local bad = glyph(f, "x", 22, C.Red, Creator)
                bad.Position = UDim2.fromOffset(74, 50)
                local goodS = new("UIScale", { Scale = 0, Parent = good })
                local badS = new("UIScale", { Scale = 0, Parent = bad })
                local title = label(f, {
                        Font = FONTB, TextSize = 14, TextColor3 = C.Green, TextXAlignment = Enum.TextXAlignment.Center,
                        TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(74, 101),
                        Size = UDim2.fromOffset(132, 20), Text = "",
                })
                local sub = label(f, {
                        Font = FONT, TextSize = 10, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Center,
                        TextTruncate = Enum.TextTruncate.AtEnd, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(74, 122),
                        Size = UDim2.fromOffset(132, 14), Text = "",
                })
                function v.Set(d)
                        local ok = d.Success ~= false
                        local color = d.Color or (ok and C.Green or C.Red)
                        stroke.Color = color
                        good.Visible = ok
                        bad.Visible = not ok
                        recolor(ok and good or bad, color)
                        title.Text = tostring(d.Title or "")
                        title.TextColor3 = color
                        sub.Text = tostring(d.Content or "")
                        ringScale.Scale = 0.6
                        tw(ringScale, 0.5, { Scale = 1 }, BACK, EOUT)
                        goodS.Scale, badS.Scale = 0, 0
                        tw(ok and goodS or badS, 0.5, { Scale = 1 }, BACK, EOUT)
                end
                return v
        end
        local queue = {}
        local lives = {}
        local LIVE_ORDER = { "timer", "stopwatch", "farm", "track", "media" }
        local runJob, dismissJob, goIdle, showLive
        local lastTouch = os.clock()
        local function touch()
                lastTouch = os.clock()
                XC.touched = lastTouch
        end
        local function pickLive()
                live = nil
                for _, k in ipairs(LIVE_ORDER) do
                        if lives[k] and not (DIM.On and k == "media") then
                                live = lives[k]
                                break
                        end
                end
        end
        local function removeQueued(job)
                for i, j in ipairs(queue) do
                        if j == job then
                                table.remove(queue, i)
                                return
                        end
                end
        end
        local function buildActPill(kind)
                local isT = kind == "timer"
                local col = ACT_COL[kind]
                local v = makeView(isT and "TimerPill" or "WatchPill", SPEC.TimerPill.W, SPEC.PillH)
                local f = v.frame
                local bg = frame({ BackgroundColor3 = isT and Color3.fromRGB(53, 40, 20) or Color3.fromRGB(40, 28, 50), Size = UDim2.fromScale(1, 1), Parent = f })
                corner(bg, SPEC.Idle.R)
                new("UIStroke", { Thickness = 3, Color = col, Transparency = 0.15, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bg })
                local dot = frame({
                        BackgroundColor3 = col, AnchorPoint = V2(0.5, 0.5), Position = U2(0, 21, 0.5, 0),
                        Size = UDim2.fromOffset(10, 10), Parent = f,
                })
                corner(dot)
                local dscale = new("UIScale", { Scale = 1, Parent = dot })
                local ico = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0, 0.5), Position = U2(0, 13, 0.5, 0),
                        Size = UDim2.fromOffset(18, 18), ImageColor3 = col, Visible = false, Parent = f,
                })
                local icoScale = new("UIScale", { Scale = 1, Parent = ico })
                local hasIco = false
                for _, nm in ipairs(isT and { "hourglass", "timer", "alarm-clock" } or { "timer", "alarm-clock", "clock" }) do
                        local okI = false
                        pcall(function() okI = applyIcon(ico, nm, Creator) and true or false end)
                        if okI then
                                hasIco = true
                                break
                        end
                end
                ico.Visible = hasIco
                dot.Visible = not hasIco
                if hasIco then ico.ImageColor3 = col end
                label(f, {
                        Font = FONT, TextSize = 13, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                        AnchorPoint = V2(0, 0.5), Position = U2(0, hasIco and 38 or 34, 0.5, 0), Size = UDim2.fromOffset(84, 18), Text = isT and "Timer" or "Watch",
                })
                local val = label(f, {
                        Font = FONTB, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right,
                        AnchorPoint = V2(1, 0.5), Position = U2(1, -16, 0.5, 0), Size = UDim2.fromOffset(56, 18), Text = "",
                })
                TweenService:Create(hasIco and icoScale or dscale, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Scale = hasIco and 1.14 or 1.25 }):Play()
                local acc, last = 1, nil
                function v.Set()
                        acc = 1
                end
                function v.Tick(dt)
                        acc = acc + dt
                        if acc < 0.25 then
                                return
                        end
                        acc = 0
                        local okA, acts = pcall(function() return DIM.Acts and DIM.Acts() or {} end)
                        if not okA or type(acts) ~= "table" then
                                return
                        end
                        for _, a in ipairs(acts) do
                                if a.kind == kind and a.text ~= last then
                                        last = a.text
                                        val.Text = a.text or ""
                                end
                        end
                end
                return v
        end
        local CARD_ORDER = { "home", "music", "timer", "watch", "cross" }
        local function buildCard()
                local v = makeView("Card", SPEC.Card.W, SPEC.Card.H)
                local f = v.frame
                v.page, v.pages, v.dots = nil, {}, {}
                local ORANGE, PURPLE, RED = ACT_COL.timer, ACT_COL.stopwatch, C.Red
                local WHITE, SUB = Color3.new(1, 1, 1), C.Sub
                local function pageH(name)
                        return SPEC.Card.H
                end
                local function idxOf(name)
                        for i, n in ipairs(CARD_ORDER) do
                                if n == name then
                                        return i
                                end
                        end
                        return 1
                end
                local function actOf(kind)
                        local ok, acts = pcall(function() return DIM.Acts and DIM.Acts() or {} end)
                        if ok and type(acts) == "table" then
                                for _, a in ipairs(acts) do
                                        if a.kind == kind then
                                                return a
                                        end
                                end
                        end
                        return nil
                end
                local function avail()
                        -- Overview, Music and Longxgen are permanent pages.
                        -- Live activities remain independently promotable to the adjacent bubble.
                        local out = { "home", "music" }
                        if actOf("timer") then out[#out + 1] = "timer" end
                        if actOf("stopwatch") then out[#out + 1] = "watch" end
                        out[#out + 1] = "cross"
                        return out
                end
                local function newPage(name, c1, c2, c3)
                        local pg = new("CanvasGroup", {
                                Name = "Page_" .. name, BackgroundTransparency = 1, GroupTransparency = 1, AnchorPoint = V2(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(SPEC.Card.W, pageH(name)), Visible = false, Parent = f,
                        })
                        local bgf = frame({ BackgroundColor3 = WHITE, Size = UDim2.fromScale(1, 1), Parent = pg })
                        corner(bgf, SPEC.Card.R)
                        new("UIGradient", {
                                Rotation = 90,
                                Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c3) }),
                                Parent = bgf,
                        })
                        v.pages[name] = { frame = pg, bgf = bgf }
                        return pg
                end
                local function section(parent)
                        return new("CanvasGroup", { BackgroundTransparency = 1, GroupTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = parent })
                end
                local function grabber(parent)
                        corner(frame({
                                BackgroundColor3 = Color3.fromRGB(150, 150, 156), BackgroundTransparency = 0.45,
                                Position = UDim2.fromOffset(152, 6), Size = UDim2.fromOffset(36, 4), Parent = parent,
                        }))
                end
                local function mkBtn(parent, x, y, w, h, color, text, size)
                        local b = new("TextButton", {
                                BackgroundColor3 = color, Text = text, Font = FONTB, TextSize = size or 15, TextColor3 = WHITE,
                                AutoButtonColor = false, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h), Parent = parent,
                        })
                        corner(b, math.floor(h / 2))
                        local sc = new("UIScale", { Scale = 1, Parent = b })
                        pressFx(b, sc, 0.94)
                        XC.glass(b)
                        return b
                end
                local function addTabs(parent)
                        local seg = frame({
                                BackgroundColor3 = Color3.fromRGB(18, 12, 38), BackgroundTransparency = 0.38,
                                Position = UDim2.fromOffset(109, 151), Size = UDim2.fromOffset(122, 28), Parent = parent,
                        })
                        corner(seg)
                        new("UIStroke", { Thickness = 1, Color = Color3.new(1, 1, 1), Transparency = 0.82, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = seg })
                        local sel = frame({
                                BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.68,
                                Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(56, 22), Parent = seg,
                        })
                        sel.Active = false
                        corner(sel)
                        new("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(205, 196, 238)), Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.4) }), Parent = sel })
                        local lrim = new("UIStroke", { Thickness = 1.2, Color = Color3.new(1, 1, 1), Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = sel })
                        new("UIGradient", { Rotation = 45, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 0.7), NumberSequenceKeypoint.new(0.62, 0.86), NumberSequenceKeypoint.new(1, 0.15) }), Parent = lrim })
                        local lsp = frame({ BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.85, AnchorPoint = V2(0.5, 0), Position = U2(0.5, 0, 0, 1), Size = U2(1, -10, 0.4, 0), Parent = sel })
                        lsp.Active = false
                        corner(lsp)
                        new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = lsp })
                        local scl = new("UIScale", { Scale = 1, Parent = sel })
                        local function tabBtn(x, text, col)
                                return new("TextButton", {
                                        BackgroundTransparency = 1, Text = text, Font = FONTB, TextSize = 11, TextColor3 = col, AutoButtonColor = false,
                                        Position = UDim2.fromOffset(x, 3), Size = UDim2.fromOffset(56, 22), Visible = true, ZIndex = 3, Parent = seg,
                                })
                        end
                        local t1, t2, t3 = tabBtn(3, "Overview", WHITE), tabBtn(61, "Music", SUB), tabBtn(119, "Trapx", SUB)
                        t3.TextScaled = true
                        new("UITextSizeConstraint", { MaxTextSize = 11, MinTextSize = 7, Parent = t3 })
                        t3.Visible = true
                        local names = { "home", "music", "cross" }
                        local function slots()
                                return t3.Visible and 3 or 2
                        end
                        local function nearest(x)
                                return math.clamp(math.floor((x - 3) / 58 + 0.5) + 1, 1, slots())
                        end
                        local drag = nil
                        local enabled = true
                        local buttons = { t1, t2, t3 }
                        local function snapToCurrent()
                                local cur = v.page == "music" and 2 or (v.page == "cross" and 3 or 1)
                                tw(sel, 0.22, { Position = UDim2.fromOffset(3 + 58 * (cur - 1), 3) }, Enum.EasingStyle.Quint, EOUT)
                        end
                        local function setActive(on)
                                enabled = on == true
                                for _, b in ipairs(buttons) do
                                        b.Active = enabled and b.Visible
                                end
                                if not enabled and drag then
                                        local d = drag
                                        drag = nil
                                        v.dragging = false
                                        for _, c in ipairs(d.conns) do
                                                pcall(function() c:Disconnect() end)
                                        end
                                        tw(scl, 0.2, { Scale = 1 }, Enum.EasingStyle.Quint, EOUT)
                                        tw(sel, 0.2, { BackgroundTransparency = 0.68 })
                                        snapToCurrent()
                                end
                        end
                        local function begin(idx, inp)
                                local ut = inp.UserInputType
                                if not enabled or (ut ~= Enum.UserInputType.MouseButton1 and ut ~= Enum.UserInputType.Touch) or drag then
                                        return
                                end
                                local k = seg.AbsoluteSize.X / math.max(seg.Size.X.Offset, 1)
                                if k <= 0 then
                                        k = 1
                                end
                                local d = { x0 = inp.Position.X, l0 = sel.Position.X.Offset, k = k, moved = false, idx = idx, conns = {} }
                                drag = d
                                v.dragging = true
                                touch()
                                tw(scl, 0.18, { Scale = 1.16 }, Enum.EasingStyle.Back, EOUT)
                                tw(sel, 0.18, { BackgroundTransparency = 0.58 })
                                local function fin()
                                        if drag ~= d then
                                                return
                                        end
                                        drag = nil
                                        v.dragging = false
                                        touch()
                                        for _, c in ipairs(d.conns) do
                                                c:Disconnect()
                                        end
                                        tw(scl, 0.3, { Scale = 1 }, Enum.EasingStyle.Back, EOUT)
                                        tw(sel, 0.2, { BackgroundTransparency = 0.68 })
                                        tw(sel, 0.3, { Size = UDim2.fromOffset(56, 22) }, Enum.EasingStyle.Back, EOUT)
                                        if not enabled then
                                                snapToCurrent()
                                                return
                                        end
                                        local target = d.moved and nearest(d.lastTx or sel.Position.X.Offset) or d.idx
                                        local name = names[target]
                                        if name and name ~= v.page and currentView == v then
                                                touch()
                                                v.Go(name)
                                        else
                                                snapToCurrent()
                                        end
                                end
                                d.conns[1] = UserInputService.InputChanged:Connect(function(i)
                                        if i ~= inp and not (ut == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement) then
                                                return
                                        end
                                        touch()
                                        local dx = i.Position.X - d.x0
                                        if not d.moved and math.abs(dx) < 6 then
                                                return
                                        end
                                        d.moved = true
                                        local tx = math.clamp(d.l0 + dx / d.k, 3, 3 + 58 * (slots() - 1))
                                        local vx = tx - (d.lastTx or tx)
                                        d.lastTx = tx
                                        local sw = math.min(math.abs(vx) * 1.8, 14)
                                        d.sTok = (d.sTok or 0) + 1
                                        local stk = d.sTok
                                        tw(sel, 0.1, { Position = UDim2.fromOffset(tx - sw / 2, 3 - sw * 0.06), Size = UDim2.fromOffset(56 + sw, 22 - sw * 0.12) }, Enum.EasingStyle.Quad, EOUT)
                                        task.delay(0.12, function()
                                                if drag == d and d.sTok == stk then
                                                        tw(sel, 0.22, { Position = UDim2.fromOffset(tx, 3), Size = UDim2.fromOffset(56, 22) }, Enum.EasingStyle.Back, EOUT)
                                                end
                                        end)
                                end)
                                d.conns[2] = UserInputService.InputEnded:Connect(function(i)
                                        if i == inp or (ut == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseButton1) then
                                                fin()
                                        end
                                end)
                        end
                        t1.InputBegan:Connect(function(i) begin(1, i) end)
                        t2.InputBegan:Connect(function(i) begin(2, i) end)
                        t3.InputBegan:Connect(function(i) begin(3, i) end)
                        return { seg = seg, sel = sel, t1 = t1, t2 = t2, t3 = t3, SetActive = setActive }
                end
                local function tabLayout(tabs)
                        -- Keep all three navigation destinations available at all times.
                        tabs.seg.Size = UDim2.fromOffset(180, 28)
                        tabs.seg.Position = UDim2.fromOffset(80, 151)
                        tabs.t1.Visible, tabs.t2.Visible, tabs.t3.Visible = true, true, true
                end
                local function tabSet(tabs, name)
                        local idx = name == "music" and 2 or (name == "cross" and 3 or 1)
                        tw(tabs.sel, 0.45, { Position = UDim2.fromOffset(3 + 58 * (idx - 1), 3) }, Enum.EasingStyle.Back, EOUT)
                        tw(tabs.t1, 0.2, { TextColor3 = idx == 1 and WHITE or Color3.fromRGB(208, 198, 232) })
                        tw(tabs.t2, 0.2, { TextColor3 = idx == 2 and WHITE or Color3.fromRGB(208, 198, 232) })
                        tw(tabs.t3, 0.2, { TextColor3 = idx == 3 and WHITE or Color3.fromRGB(208, 198, 232) })
                end
                function v.UpdateDots()
                        local a = avail()
                        for _, ds in pairs(v.dots) do
                                local totalW = 0
                                for i = 1, #a do
                                        totalW = totalW + ((a[i] == v.page) and 16 or 6) + (i > 1 and 6 or 0)
                                end
                                local x = (SPEC.Card.W - totalW) / 2
                                for i = 1, 5 do
                                        local d = ds[i]
                                        if a[i] then
                                                local cur = a[i] == v.page
                                                local w = cur and 16 or 6
                                                d.Visible = true
                                                tw(d, 0.25, {
                                                        Position = UDim2.fromOffset(x, 160), Size = UDim2.fromOffset(w, 6),
                                                        BackgroundColor3 = cur and Color3.fromRGB(247, 245, 243) or Color3.fromRGB(143, 123, 93),
                                                })
                                                x = x + w + 6
                                        else
                                                d.Visible = false
                                        end
                                end
                        end
                end
                local function ctl()
                        return DIM.Ctl
                end
                local function fluxFor(name, pg, ribs, blobCol, bx, by)
                        local en = _G.FARMX and _G.FARMX.Enable
                        if en and en.IslandFlux == false then
                                return
                        end
                        local bgf = v.pages[name].bgf
                        bgf.ClipsDescendants = true
                        corner(pg, SPEC.Card.R)
                        v.fluxT = v.fluxT or {}
                        local list = {}
                        v.fluxT[name] = list
                        local fl = { ribs = {}, blob = nil }
                        v.fluxG = v.fluxG or {}
                        v.fluxG[name] = fl
                        local NSK = NumberSequenceKeypoint.new
                        for _, d in ipairs(ribs) do
                                local w, h, rot, cx, cy, ca, cb, tr, drift = d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9]
                                local rb = frame({
                                        Name = "WAFlux", BackgroundColor3 = Color3.new(1, 1, 1), AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
                                        Size = UDim2.fromOffset(w, h), Rotation = rot, Parent = bgf,
                                })
                                rb.Active = false
                                corner(rb, math.floor(h / 2))
                                local rg = new("UIGradient", { Color = ColorSequence.new(ca, cb), Transparency = NumberSequence.new({ NSK(0, 1), NSK(0.5, tr), NSK(1, 1) }), Parent = rb })
                                fl.ribs[#fl.ribs + 1] = { g = rg }
                                if drift and not (en and en.IslandFluxDrift == false) then
                                        list[#list + 1] = TweenService:Create(rb, TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Position = UDim2.fromOffset(cx + drift[1], cy + drift[2]) })
                                end
                        end
                        local blob = frame({ Name = "WAFlux", BackgroundColor3 = blobCol, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(bx, by), Size = UDim2.fromOffset(150, 150), Parent = bgf })
                        blob.Active = false
                        corner(blob)
                        new("UIGradient", { Rotation = 45, Transparency = NumberSequence.new({ NSK(0, 0.55), NSK(1, 1) }), Parent = blob })
                        fl.blob = blob
                end
                local function glassText(l, tint)
                        new("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.new(1, 1, 1), tint), Parent = l })
                        new("UIStroke", { Thickness = 1, Color = Color3.new(1, 1, 1), Transparency = 0.55, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Parent = l })
                end
                local home = newPage("home", Color3.fromRGB(128, 64, 216), Color3.fromRGB(80, 40, 172), Color3.fromRGB(28, 14, 96))
                grabber(home)
                fluxFor("home", home, {
                        { 470, 84, -24, 80, 40, Color3.fromRGB(255, 110, 214), Color3.fromRGB(150, 92, 255), 0.3, { 24, 12 } },
                        { 440, 96, 22, 270, 150, Color3.fromRGB(92, 160, 255), Color3.fromRGB(190, 110, 255), 0.34, { -22, -10 } },
                        { 300, 70, 35, 330, 40, Color3.fromRGB(255, 160, 96), Color3.fromRGB(255, 90, 170), 0.42, { -18, 14 } },
                        { 360, 60, -10, 200, 110, Color3.fromRGB(255, 170, 230), Color3.fromRGB(120, 100, 255), 0.46, nil },
                }, Color3.fromRGB(255, 140, 210), 300, 14)
                local hTop, hMid, hBot = section(home), section(home), section(home)
                local clock = label(hTop, {
                        Font = FONTB, TextSize = 40, TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.fromOffset(20, 14), Size = UDim2.fromOffset(160, 48), Text = "00:00",
                })
                new("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(206, 190, 255)), Parent = clock })
                new("UIStroke", { Thickness = 1, Color = Color3.new(1, 1, 1), Transparency = 0.55, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Parent = clock })
                local dateL = label(hTop, {
                        Font = FONT, TextSize = 13, TextColor3 = SUB, TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.fromOffset(22, 64), Size = UDim2.fromOffset(160, 18), Text = "",
                })
                local function chip(y)
                        local c = frame({ BackgroundColor3 = WHITE, BackgroundTransparency = 0.8, Position = UDim2.fromOffset(216, y), Size = UDim2.fromOffset(108, 28), Parent = hTop })
                        corner(c)
                        XC.glass(c)
                        local d = frame({ BackgroundColor3 = C.Green, AnchorPoint = V2(0, 0.5), Position = U2(0, 12, 0.5, 0), Size = UDim2.fromOffset(8, 8), Parent = c })
                        corner(d)
                        local t = label(c, {
                                Font = FONTB, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
                                AnchorPoint = V2(0, 0.5), Position = U2(0, 28, 0.5, 0), Size = UDim2.fromOffset(76, 18), Text = "",
                        })
                        return d, t
                end
                local fpsDot, fpsT = chip(16)
                local pingDot, pingT = chip(48)
                local tiles = {}
                local function tile(i, title, color)
                        local b = new("TextButton", {
                                BackgroundColor3 = color or Color3.fromRGB(255, 255, 255), BackgroundTransparency = color and 0.16 or 0.8, Text = "", AutoButtonColor = false,
                                Position = UDim2.fromOffset(18 + (i - 1) * 78, 93), Size = UDim2.fromOffset(70, 50), Parent = hMid,
                        })
                        corner(b, 16)
                        XC.glass(b)
                        local sc = new("UIScale", { Scale = 1, Parent = b })
                        pressFx(b, sc, 0.94)
                        label(b, { Font = FONTB, TextSize = 13, AnchorPoint = V2(0.5, 0), Position = U2(0.5, 0, 0, 8), Size = UDim2.fromOffset(68, 18), Text = title })
                        local sub = label(b, { Font = FONT, TextSize = 12, TextColor3 = Color3.fromRGB(226, 216, 252), AnchorPoint = V2(0.5, 0), Position = U2(0.5, 0, 0, 27), Size = UDim2.fromOffset(68, 16), Text = "" })
                        tiles[i] = { b = b, sub = sub }
                        return b
                end
                local tWin, tTim, tWat, tMus = tile(1, "Window", Color3.fromRGB(25, 135, 243)), tile(2, "Timer"), tile(3, "Stopwatch"), tile(4, "Music")
                tWin.Activated:Connect(function() touch() local fxo = _G.FARMX if fxo and fxo.Enable and fxo.Enable.OnlyBubbleOpens ~= false then return end if window.Open and not destroyed then window:Open() end end)
                tTim.Activated:Connect(function()
                        touch()
                        local c = ctl()
                        if c and c.Timer then
                                if c.Timer.state == "idle" then
                                        c.TimerStart(c.minutes)
                                end
                                task.delay(0.3, function()
                                        if v.page == "home" then
                                                v.Go("timer")
                                        end
                                end)
                        end
                end)
                tWat.Activated:Connect(function() touch() local c = ctl() if c and c.WatchToggle then c.WatchToggle() end end)
                tMus.Activated:Connect(function() touch() if actOf("media") then v.Go("music") end end)
                local tabsH = addTabs(hBot)
                local music = newPage("music", Color3.fromRGB(56, 56, 61), Color3.fromRGB(53, 39, 21), Color3.fromRGB(84, 54, 7))
                fluxFor("music", music, {
                        { 470, 84, -24, 80, 36, Color3.fromRGB(255, 170, 60), Color3.fromRGB(255, 90, 120), 0.5, { 24, 12 } },
                        { 440, 96, 22, 270, 130, Color3.fromRGB(255, 120, 80), Color3.fromRGB(200, 80, 200), 0.56, { -22, -10 } },
                        { 360, 60, -10, 200, 100, Color3.fromRGB(255, 200, 120), Color3.fromRGB(255, 110, 150), 0.66, nil },
                }, Color3.fromRGB(255, 150, 80), 300, 10)
                grabber(music)
                local cover = frame({ BackgroundColor3 = WHITE, Position = UDim2.fromOffset(17, 14), Size = UDim2.fromOffset(54, 54), Parent = music })
                corner(cover, 10)
                new("UIGradient", { Rotation = 45, Color = ColorSequence.new(ORANGE, RED), Parent = cover })
                new("UIStroke", { Thickness = 1.2, Color = Color3.new(1, 1, 1), Transparency = 0.45, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = cover })
                local note = label(cover, { Font = FONTB, TextSize = 26, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), Text = "" })
                pcall(function()
                    local musicIcon = new("ImageLabel", { BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(26, 26), ImageColor3 = C.White, Parent = cover })
                    applyIcon(musicIcon, "music", Creator)
                end)
                local cimg = new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, Visible = false, Parent = cover })
                corner(cimg, 10)
                local mTitle = label(music, { Font = FONTB, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.fromOffset(82, 18), Size = UDim2.fromOffset(200, 22), Text = "Not Playing" })
                local mArtist = label(music, { Font = FONT, TextSize = 13, TextColor3 = SUB, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.fromOffset(82, 41), Size = UDim2.fromOffset(200, 18), Text = "" })
                local eq = {}
                for i = 1, 5 do
                        local b = frame({ BackgroundColor3 = ORANGE, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(302 + (i - 1) * 5.5, 40), Size = UDim2.fromOffset(3, 4), Parent = music })
                        corner(b)
                        eq[i] = b
                end
                local mTrack = frame({ BackgroundColor3 = Color3.fromRGB(93, 79, 59), Position = UDim2.fromOffset(17, 80), Size = UDim2.fromOffset(306, 5), Parent = music })
                corner(mTrack)
                local mFill = frame({ BackgroundColor3 = Color3.fromRGB(255, 176, 32), Size = UDim2.fromScale(0, 1), Parent = mTrack })
                corner(mFill)
                local knob = XC.comet(mTrack, Color3.fromRGB(255, 176, 32))
                local tl = label(music, { Font = FONT, TextSize = 11, TextColor3 = SUB, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(17, 92), Size = UDim2.fromOffset(60, 14), Text = "0:00" })
                local tr = label(music, { Font = FONT, TextSize = 11, TextColor3 = SUB, TextXAlignment = Enum.TextXAlignment.Right, Position = UDim2.fromOffset(263, 92), Size = UDim2.fromOffset(60, 14), Text = "0:00" })
                local function circleBtn(cx, d, color, alpha)
                        local b = new("TextButton", {
                                BackgroundColor3 = color, BackgroundTransparency = alpha, Text = "", AutoButtonColor = false, AnchorPoint = V2(0.5, 0.5),
                                Position = UDim2.fromOffset(cx, 122), Size = UDim2.fromOffset(d, d), ZIndex = 6, Parent = music,
                        })
                        corner(b)
                        local sc = new("UIScale", { Scale = 1, Parent = b })
                        pressFx(b, sc, 0.88)
                        XC.glass(b)
                        return b
                end
                local function sym(parent, text, size, col)
                        return label(parent, { Font = FONTB, TextSize = size, TextColor3 = col, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), Text = text, ZIndex = 7 })
                end
                local prevB = circleBtn(108, 40, Color3.fromRGB(60, 48, 32), 0.15)
                local playB = circleBtn(170, 52, WHITE, 0)
                local nextB = circleBtn(231, 40, Color3.fromRGB(60, 48, 32), 0.15)
                sym(prevB, "|<", 14, WHITE)
                sym(nextB, ">|", 14, WHITE)
                local playSym = sym(playB, ">", 22, C.Black)
                local pauseSym = glyph(playB, "pause", 20, C.Black, Creator)
                pauseSym.ZIndex = 7
                local function md()
                        return lives.media and lives.media.data or nil
                end
                playB.Activated:Connect(function()
                        touch()
                        local dd = md()
                        if not dd then return end
                        dd.Playing = not dd.Playing
                        if dd.OnPlay then task.spawn(pcall, dd.OnPlay, dd.Playing) end
                end)
                prevB.Activated:Connect(function() touch() local dd = md() if dd and dd.OnPrev then task.spawn(pcall, dd.OnPrev) end end)
                nextB.Activated:Connect(function() touch() local dd = md() if dd and dd.OnNext then task.spawn(pcall, dd.OnNext) end end)
                local tabsM = addTabs(music)
                local timer = newPage("timer", Color3.fromRGB(56, 56, 61), Color3.fromRGB(53, 39, 21), Color3.fromRGB(84, 54, 7))
                fluxFor("timer", timer, {
                        { 440, 70, -22, 80, 30, Color3.fromRGB(255, 170, 60), Color3.fromRGB(255, 90, 120), 0.5, { 22, 10 } },
                        { 420, 80, 20, 270, 120, Color3.fromRGB(255, 120, 80), Color3.fromRGB(200, 80, 200), 0.56, { -20, -8 } },
                }, Color3.fromRGB(255, 150, 80), 300, 10)
                label(timer, { Font = FONTB, TextSize = 12, TextColor3 = ORANGE, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(22, 16), Size = UDim2.fromOffset(100, 16), Text = "Timer" })
                local tBig = label(timer, { Font = FONTB, TextSize = 48, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(20, 20), Size = UDim2.fromOffset(300, 60), Text = "0:00" })
                glassText(tBig, Color3.fromRGB(255, 224, 190))
                local tTrack = frame({ BackgroundColor3 = Color3.fromRGB(93, 79, 59), Position = UDim2.fromOffset(18, 84), Size = UDim2.fromOffset(304, 8), Parent = timer })
                corner(tTrack)
                local tFill = frame({ BackgroundColor3 = ORANGE, Size = UDim2.fromScale(1, 1), Parent = tTrack })
                corner(tFill)
                local tStar = XC.comet(tTrack, ORANGE)
                local stopB = mkBtn(timer, 18, 100, 148, 36, RED, "Stop timer", 15)
                local addB = mkBtn(timer, 174, 100, 148, 36, Color3.fromRGB(98, 76, 44), "+30s", 15)
                stopB.Activated:Connect(function() touch() local c = ctl() if c and c.TimerStop then c.TimerStop() end end)
                addB.Activated:Connect(function() touch() local c = ctl() if c and c.TimerAdd then c.TimerAdd(30) end end)
                local tabsT = addTabs(timer)
                local watch = newPage("watch", Color3.fromRGB(56, 56, 60), Color3.fromRGB(43, 28, 55), Color3.fromRGB(64, 31, 82))
                fluxFor("watch", watch, {
                        { 440, 70, -22, 80, 30, Color3.fromRGB(170, 90, 255), Color3.fromRGB(255, 100, 200), 0.5, { 22, 10 } },
                        { 420, 80, 20, 270, 120, Color3.fromRGB(110, 120, 255), Color3.fromRGB(220, 100, 255), 0.56, { -20, -8 } },
                }, Color3.fromRGB(200, 110, 255), 300, 10)
                label(watch, { Font = FONTB, TextSize = 12, TextColor3 = PURPLE, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(22, 16), Size = UDim2.fromOffset(120, 16), Text = "Stopwatch" })
                local wBig = label(watch, { Font = FONTB, TextSize = 44, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(20, 20), Size = UDim2.fromOffset(310, 54), Text = "00:00.00" })
                glassText(wBig, Color3.fromRGB(226, 205, 255))
                local lapL = label(watch, { Font = FONT, TextSize = 12, TextColor3 = SUB, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(22, 74), Size = UDim2.fromOffset(300, 16), Text = "" })
                local pauseB = mkBtn(watch, 18, 96, 96, 36, PURPLE, "Start", 15)
                local lapB = mkBtn(watch, 122, 96, 96, 36, Color3.fromRGB(80, 59, 91), "Lap", 15)
                local resetB = mkBtn(watch, 226, 96, 96, 36, Color3.fromRGB(80, 59, 91), "Reset", 15)
                pauseB.Activated:Connect(function() touch() local c = ctl() if c and c.WatchToggle then c.WatchToggle() end end)
                lapB.Activated:Connect(function() touch() local c = ctl() if c and c.WatchLap then c.WatchLap() end end)
                resetB.Activated:Connect(function() touch() local c = ctl() if c and c.WatchReset then c.WatchReset() end end)
                local tabsW = addTabs(watch)
                local crossPg = newPage("cross", Color3.fromRGB(60, 60, 64), Color3.fromRGB(60, 56, 54), Color3.fromRGB(10, 50, 100))
                grabber(crossPg)
                v.cross = XC.mountCard(crossPg, v.pages.cross.bgf:FindFirstChildOfClass("UIGradient")) or {}
                fluxFor("cross", crossPg, {
                        { 440, 70, -22, 90, 36, Color3.fromRGB(255, 110, 214), Color3.fromRGB(150, 92, 255), 0.5, { 22, 10 } },
                        { 420, 80, 20, 260, 128, Color3.fromRGB(92, 160, 255), Color3.fromRGB(190, 110, 255), 0.55, { -20, -8 } },
                        { 340, 56, -8, 190, 100, Color3.fromRGB(255, 170, 230), Color3.fromRGB(120, 100, 255), 0.66, nil },
                }, Color3.fromRGB(255, 140, 210), 300, 12)
                v.cross.flux = (function()
                        local gs = {}
                        for _, ch in ipairs(v.pages.cross.bgf:GetChildren()) do
                                if ch.Name == "WAFlux" then
                                        local g = ch:FindFirstChildOfClass("UIGradient")
                                        if g then
                                                gs[#gs + 1] = g
                                        end
                                end
                        end
                        local hv = Instance.new("NumberValue")
                        hv.Value = 0.78
                        local function col(h, dh, sat, val)
                                return Color3.fromHSV((h + dh) % 1, sat, val)
                        end
                        local function apply(h)
                                if gs[1] then gs[1].Color = ColorSequence.new(col(h, 0, 0.7, 1), col(h, 0.12, 0.65, 1)) end
                                if gs[2] then gs[2].Color = ColorSequence.new(col(h, 0.5, 0.6, 1), col(h, 0.62, 0.65, 1)) end
                                if gs[3] then gs[3].Color = ColorSequence.new(col(h, 0.08, 0.5, 1), col(h, -0.1, 0.6, 1)) end
                                if gs[4] then gs[4].Color = ColorSequence.new(col(h, -0.04, 0.7, 1)) end
                        end
                        hv.Changed:Connect(apply)
                        apply(hv.Value)
                        return function(c)
                                local th = c:ToHSV()
                                local cur = hv.Value % 1
                                local delta = ((th - cur + 0.5) % 1) - 0.5
                                TweenService:Create(hv, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Value = hv.Value + delta }):Play()
                        end
                end)()
                local tabsC = addTabs(crossPg)
                -- [QM-GL] P76 liquid glass boncuti (Sheen/Caustic/Rim) + flux cho music/timer/watch/cross | nguon: boncuti Glass.Skin | gan tai: truoc pageTransitionToken
                do
                        local fxg = _G.FARMX
                        if not (fxg and fxg.Enable and fxg.Enable.PageGlass == false) then
                                v.fluxT = v.fluxT or {}
                                local function glassFor(name, accent)
                                        local pg = v.pages[name]
                                        local host = pg and pg.bgf
                                        if not host or not (Creator and Creator.LGApply) then
                                                return
                                        end
                                        Creator.LGApply(host, { corner = UD(0, SPEC.Card.R), touch = false, always = true })
                                end
                                pcall(glassFor, "music", Color3.fromRGB(255, 176, 80))
                                pcall(glassFor, "timer", Color3.fromRGB(255, 150, 80))
                                pcall(glassFor, "watch", Color3.fromRGB(200, 120, 255))
                                pcall(glassFor, "cross", Color3.fromRGB(120, 180, 255))
                        end
                end
                local pageTransitionToken = 0
                local pageTabs = { home = tabsH, music = tabsM, cross = tabsC, timer = tabsT, watch = tabsW }
                local function activatePageTabs(name)
                        for pageName, tabs in pairs(pageTabs) do
                                tabs.SetActive(pageName == name)
                        end
                end
                function v.Go(name, instant)
                        local newp = v.pages[name]
                        if not newp then
                                return
                        end
                        if v.page == name then
                                local currentPage = v.pages[name]
                                if currentPage then
                                        currentPage.frame.Visible = true
                                        if currentPage.frame.GroupTransparency > 0.02 then
                                                tw(currentPage.frame, 0.14, { GroupTransparency = 0 }, QUAD, EOUT)
                                        end
                                        currentPage.frame.Position = UDim2.fromScale(0.5, 0.5)
                                end
                                activatePageTabs(name)
                                return
                        end
                        pageTransitionToken = pageTransitionToken + 1
                        local thisTransition = pageTransitionToken
                        local oldName = v.page
                        local oldp = oldName and v.pages[oldName]
                        local way = oldName and ((idxOf(name) >= idxOf(oldName)) and 1 or -1) or 1
                        activatePageTabs(name)
                        v.page = name
                        if currentView == v then
                                setSize(SPEC.Card.W, pageH(name), SPEC.Card.R)
                        end
                        for pageName, pageData in pairs(v.pages) do
                                if pageName ~= name and pageName ~= oldName and pageData.frame.Visible then
                                        pageData.frame.Visible = false
                                        pageData.frame.GroupTransparency = 1
                                        pageData.frame.Position = UDim2.fromScale(0.5, 0.5)
                                end
                        end
                        if oldp then
                                tw(oldp.frame, 0.16, { GroupTransparency = 1, Position = UDim2.new(0.5, -way * 20, 0.5, 0) }, QUAD, EIN)
                                task.delay(0.18, function()
                                        if pageTransitionToken == thisTransition and v.page ~= oldName then
                                                oldp.frame.Visible = false
                                                oldp.frame.GroupTransparency = 1
                                                oldp.frame.Position = UDim2.fromScale(0.5, 0.5)
                                        end
                                end)
                        end
                        newp.frame.Visible = true
                        if instant or not oldp then
                                newp.frame.Position = UDim2.fromScale(0.5, 0.5)
                                newp.frame.GroupTransparency = 0
                        else
                                newp.frame.Position = UDim2.new(0.5, way * 28, 0.5, 0)
                                newp.frame.GroupTransparency = 1
                                tw(newp.frame, 0.34, { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, Enum.EasingStyle.Quint, EOUT)
                        end
                        if pageTabs[name] then
                                -- [QM-NAV] P76 timer/stopwatch nam trong Overview (thanh Overview/Music/AI luon hien)
                                local eff = (name == "timer" or name == "watch") and "home" or name
                                for _, tb in pairs(pageTabs) do
                                        tabLayout(tb)
                                end
                                activatePageTabs(name)
                                tabSet(pageTabs[name], eff)
                                local px = UDim2.fromOffset(3 + 58 * (eff == "music" and 1 or (eff == "cross" and 2 or 0)), 3)
                                for _, tb in pairs(pageTabs) do
                                        tb.sel.Position = px
                                end
                        end
                        if v.fluxT then
                                for pn, list in pairs(v.fluxT) do
                                        for _, t in ipairs(list) do
                                                if pn == name then t:Play() else t:Pause() end
                                        end
                                end
                        end
                        if name == "cross" then
                                XC.cardShow(v.cross, function() return v.page == "cross" and not destroyed end)
                        else
                                XC.cardHide()
                        end
                        if name == "home" then
                                for i, sec in ipairs({ hTop, hMid, hBot }) do
                                        sec.GroupTransparency = 1
                                        task.delay(0.04 * (i - 1) + 0.05, function()
                                                if not destroyed and v.page == "home" then
                                                        tw(sec, 0.25, { GroupTransparency = 0 })
                                                end
                                        end)
                                end
                        else
                                for _, sec in ipairs({ hTop, hMid, hBot }) do
                                        sec.GroupTransparency = 0
                                end
                        end
                        v.UpdateDots()
                        -- [QM-FIX] P83e: sau khi chuyen trang, dua moi thu ve trang thai cuoi (tween bi huy khi keo qua lai nhanh)
                        task.delay(0.45, function()
                                if destroyed or pageTransitionToken ~= thisTransition or v.page ~= name then
                                        return
                                end
                                for pn, pd in pairs(v.pages) do
                                        if pn == name then
                                                pd.frame.Visible = true
                                                if pd.frame.GroupTransparency > 0.02 then
                                                        pd.frame.GroupTransparency = 0
                                                end
                                                pd.frame.Position = UDim2.fromScale(0.5, 0.5)
                                        elseif pd.frame.Visible then
                                                pd.frame.Visible = false
                                                pd.frame.GroupTransparency = 1
                                        end
                                end
                                if name == "home" then
                                        for _, sec in ipairs({ hTop, hMid, hBot }) do
                                                if sec.GroupTransparency > 0.02 then
                                                        sec.GroupTransparency = 0
                                                end
                                        end
                                end
                                if currentView == v then
                                        setSize(SPEC.Card.W, pageH(name), SPEC.Card.R)
                                end
                                local eff = (name == "timer" or name == "watch") and "home" or name
                                local px = UDim2.fromOffset(3 + 58 * (eff == "music" and 1 or (eff == "cross" and 2 or 0)), 3)
                                for _, tb in pairs(pageTabs) do
                                        tb.sel.Position = px
                                end
                        end)
                end
                function v.Open(page)
                        page = v.pages[page] and page or "home"
                        pageTransitionToken = pageTransitionToken + 1
                        for _, p in pairs(v.pages) do
                                p.frame.Visible = false
                                p.frame.GroupTransparency = 1
                                p.frame.Position = UDim2.fromScale(0.5, 0.5)
                        end
                        v.page = nil
                        v.Go(page, true)
                        present(v, SPEC.Card.W, pageH(page), SPEC.Card.R, {})
                end
                function v.activeKind()
                        local p = v.page
                        return p == "music" and "media" or (p == "timer" and "timer" or (p == "watch" and "stopwatch" or nil))
                end
                function v.Set() end
                function v.Smooth()
                        return v.page ~= nil
                end
                local accA, accF, accH, accW = 1, 1, 1, 1
                local accR, lastRB = 1, nil
                local function applyRainbow(c)
                        if lastRB and math.abs(lastRB.R - c.R) + math.abs(lastRB.G - c.G) + math.abs(lastRB.B - c.B) < 0.012 then
                                return
                        end
                        lastRB = c
                        local fg = v.fluxG and v.fluxG.music
                        local h, sat = c:ToHSV()
                        if fg then
                                for i, r in ipairs(fg.ribs) do
                                        r.g.Color = ColorSequence.new(Color3.fromHSV(h, math.clamp(sat * 0.8, 0, 1), 1), Color3.fromHSV((h + 0.05 * i) % 1, math.clamp(sat * 0.65, 0, 1), 1))
                                end
                                if fg.blob then fg.blob.BackgroundColor3 = c end
                        end
                        mFill.BackgroundColor3 = c
                        XC.cometColor(knob, c)
                        for i = 1, #eq do eq[i].BackgroundColor3 = c end
                end
                local fAcc, fN, fV, pingV = 0, 0, 60, 0
                local lastLaps, lastTxt = 0, {}
                local function setTxt(key, obj, text)
                        if lastTxt[key] ~= text then
                                lastTxt[key] = text
                                obj.Text = text
                        end
                end
                function v.Tick(dt)
                        fAcc, fN = fAcc + dt, fN + 1
                        if fAcc >= 0.5 then
                                fV, fAcc, fN = fN / fAcc, 0, 0
                        end
                        local pg = v.page
                        if not pg or destroyed then
                                return
                        end
                        local now = os.clock()
                        accA = accA + dt
                        if accA >= 0.25 then
                                accA = 0
                                if now - lastTouch > 20 and current and current.kind == "card" and not v.dragging then
                                        dismissJob(current)
                                        return
                                end
                                local ok = false
                                for _, n in ipairs(avail()) do
                                        if n == pg then
                                                ok = true
                                        end
                                end
                                if not ok then
                                        v.Go("home")
                                        return
                                end
                                v.UpdateDots()
                        end
                        if pg == "home" then
                                accH = accH + dt
                                if accH >= 0.5 then
                                        accH = 0
                                        setTxt("clock", clock, os.date("%H:%M"))
                                        setTxt("date", dateL, os.date("%d/%m/%Y"))
                                        local fv = math.floor(fV + 0.5)
                                        setTxt("fps", fpsT, fv .. " FPS")
                                        fpsDot.BackgroundColor3 = fv >= 55 and C.Green or (fv >= 30 and C.StYellow or C.Red)
                                        pcall(function()
                                                pingV = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                                        end)
                                        setTxt("ping", pingT, pingV .. " ms")
                                        pingDot.BackgroundColor3 = pingV < 100 and C.Green or (pingV < 200 and C.StYellow or C.Red)
                                        tiles[1].sub.Text = windowOpen and "Open" or "Closed"
                                        tWin.BackgroundColor3 = windowOpen and Color3.fromRGB(25, 135, 243) or Color3.fromRGB(60, 67, 77)
                                        local c = ctl()
                                        local ta, wa, ma = actOf("timer"), actOf("stopwatch"), actOf("media")
                                        tiles[2].sub.Text = ta and ta.text or string.format("%d:00", c and c.minutes or 5)
                                        tiles[3].sub.Text = wa and wa.text or "0:00"
                                        tiles[4].sub.Text = ma and ((md() and md().Playing) and "Playing" or "Paused") or "Stopped"
                                end
                        elseif pg == "music" then
                                accR = accR + dt
                                if accR >= 0.1 then
                                        accR = 0
                                        local fxr = _G.FARMX
                                        if not (fxr and fxr.Enable and fxr.Enable.IslandMusicRainbow == false) then
                                                applyRainbow(rainbowAt(now, 10, 2))
                                        end
                                end
                                local d = md()
                                local playing = d and d.Playing == true
                                for i = 1, 5 do
                                        eq[i].Size = UDim2.fromOffset(3, playing and (4 + math.abs(math.sin(now * 6 + i * 0.9)) * 10) or 3)
                                end
                                playSym.Visible = not playing
                                pauseSym.Visible = playing
                                accF = accF + dt
                                if accF >= 0.1 and d then
                                        accF = 0
                                        setTxt("title", mTitle, tostring(d.Title or "Not Playing"))
                                        setTxt("artist", mArtist, tostring(d.Artist or ""))
                                        local has = false
                                        if d.Cover ~= lastTxt.coverKey then
                                                lastTxt.coverKey = d.Cover
                                                has = applyIcon(cimg, d.Cover, Creator) == true
                                                cimg.Visible, note.Visible = has, not has
                                        end
                                        local pos, len = d.Position, d.Length
                                        if type(d.Progress) == "function" then
                                                local okP, p1, l1 = pcall(d.Progress)
                                                if okP then
                                                        pos, len = p1, l1
                                                end
                                        end
                                        if pos and len and len > 0 then
                                                local r = math.clamp(pos / len, 0, 1)
                                                mFill.Size = UDim2.fromScale(r, 1)
                                                knob.Position = U2(r, 0, 0.5, 0)
                                                setTxt("tl", tl, fmt(pos))
                                                setTxt("tr", tr, "-" .. fmt(len - pos))
                                        end
                                end
                        elseif pg == "timer" then
                                local a = actOf("timer")
                                if a then
                                        setTxt("tbig", tBig, a.text or "0:00")
                                        tFill.Size = UDim2.fromScale(math.clamp(a.ring or 0, 0, 1), 1)
                                        tStar.Position = U2(math.clamp(a.ring or 0, 0, 1), 0, 0.5, 0)
                                end
                        elseif pg == "watch" then
                                accW = accW + dt
                                if accW >= 0.05 then
                                        accW = 0
                                        local c = ctl()
                                        if c and c.WatchElapsed then
                                                local e = c.WatchElapsed()
                                                local cs = math.floor(e * 100) % 100
                                                setTxt("wbig", wBig, string.format("%02d:%02d.%02d", math.floor(e / 60), math.floor(e) % 60, cs))
                                                setTxt("pause", pauseB, (c.Watch.state == "run") and "Pause" or "Start")
                                                local laps = c.Watch.laps or {}
                                                if #laps ~= lastLaps then
                                                        lastLaps = #laps
                                                        lapL.Text = laps[1] and string.format("Lap %d  %s", #laps, fmt(laps[1])) or ""
                                                        lapL.Position, lapL.TextTransparency = UDim2.fromOffset(22, 76), 1
                                                        tw(lapL, 0.2, { Position = UDim2.fromOffset(22, 84), TextTransparency = 0 })
                                                end
                                        end
                                end
                        end
                end
                local PAGE_TINT = {
                        home = { Color3.fromRGB(60, 60, 64), 0.0 },
                        music = { Color3.fromRGB(255, 176, 32), 0.06 },
                        timer = { Color3.fromRGB(255, 159, 10), 0.06 },
                        watch = { Color3.fromRGB(191, 90, 242), 0.06 },
                }
                for name, pg in pairs(v.pages) do
                        local tint = frame({
                                Name = "Tint_" .. name, BackgroundColor3 = WHITE, BackgroundTransparency = 1,
                                Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = pg.frame,
                        })
                        corner(tint, SPEC.Card.R)
                        new("UIGradient", {
                                Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 0.4),
                                        NumberSequenceKeypoint.new(1, 1),
                                }), Rotation = 90, Parent = tint,
                        })
                        pg.tint = tint
                        navBar(pg.frame, SPEC.Card.W, pageH(name), true)
                end
                local function applyOverlay(name)
                        local f = _G.FARMX
                        if f and f.Enable and f.Enable.DimOverlay == false then return end
                        local pg = v.pages[name]
                        if not pg or not pg.tint then return end
                        local spec = PAGE_TINT[name]
                        if not spec then
                                tw(pg.tint, 0.35, { BackgroundTransparency = 1 })
                                return
                        end
                        pg.tint.BackgroundColor3 = spec[1]
                        tw(pg.tint, 0.35, { BackgroundTransparency = spec[2] })
                end
                v.ApplyOverlay = applyOverlay
                local swipeStartX, swipeStartY, swipeActive = nil, nil, false
                local function swipeBegin(i)
                        local f = _G.FARMX
                        if f and f.Enable and f.Enable.DimSwipe == false then return end
                        if currentView ~= v then return end
                        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
                                swipeStartX, swipeStartY, swipeActive = i.Position.X, i.Position.Y, true
                        end
                end
                local function swipeEnd(i)
                        if not swipeActive then return end
                        swipeActive = false
                        if currentView ~= v then return end
                        local dx = i.Position.X - (swipeStartX or 0)
                        local dy = i.Position.Y - (swipeStartY or 0)
                        if math.abs(dx) < 44 or math.abs(dx) < math.abs(dy) * 1.5 then return end
                        local a = avail()
                        local cur = v.page
                        local curIdx = idxOf(cur or "home")
                        local newIdx
                        if dx < 0 then
                                newIdx = math.min(curIdx + 1, #a)
                        else
                                newIdx = math.max(curIdx - 1, 1)
                        end
                        if newIdx ~= curIdx and a[newIdx] then
                                touch()
                                v.Go(a[newIdx])
                        end
                end
                hit.InputBegan:Connect(swipeBegin)
                hit.InputEnded:Connect(swipeEnd)
                hitPad.InputBegan:Connect(swipeBegin)
                hitPad.InputEnded:Connect(swipeEnd)
                local seekHit = new("TextButton", {
                        Name = "SeekHit", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
                        AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(153, 82.5), Size = UDim2.fromOffset(320, 28),
                        ZIndex = 8, Parent = music, Active = false, Visible = true,
                })
                local function seekGate()
                        local f = _G.FARMX
                        return not (f and f.Enable and f.Enable.DimSeek == false)
                end
                seekHit.Activated:Connect(function()
                        if not seekGate() then return end
                        local dd = md()
                        if not dd then return end
                        local len = dd.Length
                        if (not len or len <= 0) and type(dd.Progress) == "function" then
                                local ok, _, l = pcall(dd.Progress)
                                if ok then len = l end
                        end
                        if not len or len <= 0 then return end
                        local ap = seekHit.AbsolutePosition
                        local as = seekHit.AbsoluteSize
                        local mp = UserInputService:GetMouseLocation()
                        local alpha = math.clamp((mp.X - ap.X) / as.X, 0, 1)
                        if dd.OnSeek then
                                task.spawn(pcall, dd.OnSeek, alpha)
                        end
                        mFill.Size = UDim2.fromScale(alpha, 1)
                        knob.Position = U2(alpha, 0, 0.5, 0)
                        setTxt("tl", tl, fmt(alpha * len))
                        setTxt("tr", tr, "-" .. fmt(len - alpha * len))
                end)
                for name, pg in pairs(v.pages) do
                        local shine = frame({
                                Name = "Shine_" .. name, BackgroundColor3 = WHITE, BackgroundTransparency = 0.85,
                                Size = UDim2.fromScale(1, 1), ZIndex = 9, Visible = false, Parent = pg.frame,
                        })
                        corner(shine, SPEC.Card.R)
                        local shineGrad = new("UIGradient", {
                                Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.4, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.5),
                                        NumberSequenceKeypoint.new(0.6, 1),
                                        NumberSequenceKeypoint.new(1, 1),
                                }),
                                Rotation = 20, Offset = V2(-1, 0), Parent = shine,
                        })
                        pg.shine = shine
                        pg.shineGrad = shineGrad
                end
                local shineOn = false
                local function startShine()
                        local f = _G.FARMX
                        if f and f.Enable and f.Enable.DimShine == false then return end
                        if shineOn then return end
                        shineOn = true
                        for _, pg in pairs(v.pages) do
                                if pg.shine then pg.shine.Visible = true end
                        end
                        task.spawn(function()
                                while shineOn and not destroyed do
                                        local phase = (os.clock() % 7) / 3.5
                                        local off = phase < 1 and (2 * phase - 1) or -1
                                        for _, pg in pairs(v.pages) do
                                                if pg.shineGrad then pg.shineGrad.Offset = V2(off, 0) end
                                        end
                                        task.wait(0.05)
                                end
                        end)
                end
                local function stopShine()
                        shineOn = false
                        for _, pg in pairs(v.pages) do
                                if pg.shine then pg.shine.Visible = false end
                        end
                end
                v.StartShine = startShine
                v.StopShine = stopShine
                local rawGo = v.Go
                v.Go = function(name, instant)
                        rawGo(name, instant)
                        applyOverlay(name)
                        if name == "music" then
                                startShine()
                        else
                                stopShine()
                        end
                end
                local rawOpen = v.Open
                v.Open = function(page)
                        rawOpen(page)
                        applyOverlay(page)
                        if page == "music" then startShine() else stopShine() end
                end
                return v
        end
        function goIdle()
                current = nil
                if destroyed then
                        return
                end
                if live then
                        showLive()
                        return
                end
                local v = getView("idle", buildIdle)
                present(v, SPEC.Idle.W, SPEC.Idle.H, SPEC.Idle.R, { compact = true })
        end
        function showLive()
                local v
                local W = SPEC.Idle.W
                if live.kind == "media" then
                        v = getView("live", buildLive)
                elseif live.kind == "timer" then
                        v, W = getView("timerpill", function() return buildActPill("timer") end), SPEC.TimerPill.W
                elseif live.kind == "stopwatch" then
                        v, W = getView("watchpill", function() return buildActPill("stopwatch") end), SPEC.TimerPill.W
                else
                        v = getView("track", buildTrack)
                end
                v.Set()
                present(v, W, SPEC.PillH, SPEC.Idle.R, { compact = true })
        end
        function runJob(job)
                if destroyed then
                        return
                end
                current = job
                job.token = (job.token or 0) + 1
                local tok = job.token
                job.start(job)
                touch()
                if job.dur then
                        task.delay(job.dur, function()
                                if not destroyed and current == job and job.token == tok then
                                        dismissJob(job)
                                end
                        end)
                end
        end
        function dismissJob(job)
                if current ~= job then
                        removeQueued(job)
                        return
                end
                current = nil
                if job.onEnd then
                        pcall(job.onEnd)
                end
                local nxt = table.remove(queue, 1)
                if nxt then
                        task.delay(0.12, function()
                                if destroyed then
                                        return
                                end
                                if current then
                                        table.insert(queue, 1, nxt)
                                else
                                        runJob(nxt)
                                end
                        end)
                else
                        goIdle()
                end
        end
        local function enqueue(job)
                if current then
                        if (job.urgent or job.isDot) and current.kind == "cross" and XC.pause and XC.pause(job) then
                                runJob(job)
                                return job
                        end
                        if job.urgent and (current.isLive or current.kind == "pill" or current.kind == "wide") then
                                current = nil
                                runJob(job)
                        elseif current.sticky and not current.hold and not job.sticky then
                                table.insert(queue, 1, current)
                                current = nil
                                runJob(job)
                        else
                                table.insert(queue, job)
                        end
                        return job
                end
                runJob(job)
                return job
        end
        local function pillJob(data, dur)
                local job = { kind = "pill", data = data, dur = dur }
                job.start = function(j)
                        local v = getView("pill", buildPill)
                        local W = v.Set(j.data)
                        j.view = v
                        local Hh = v.H or SPEC.PillH
                        present(v, W, Hh, Hh > SPEC.PillH and 22 or SPEC.Idle.R, { compact = W <= 300 })
                        if j.data and j.data.Dot ~= nil and v.Play then
                                v.Badge(#queue)
                                v.Play(j.dur)
                        end
                end
                return job
        end
        local function wideJob(data, dur)
                local job = { kind = "wide", data = data, dur = dur }
                job.start = function(j)
                        local v = getView("wide", buildWide)
                        v.Set(j.data)
                        present(v, SPEC.Wide.W, SPEC.Wide.H, SPEC.Wide.R, {})
                end
                return job
        end
        local function liveJob(lv, intro, dur)
                local job = {
                        kind = "live", isLive = true, live = lv, data = lv.data,
                        dur = intro and (dur or cfg.LiveIntro) or nil,
                        hold = not intro, sticky = not intro, autoCollapse = not intro,
                }
                job.start = function(j)
                        if DIM.On and DIM.Cards and (lv.kind == "media" or lv.kind == "timer" or lv.kind == "stopwatch") then
                                local cv = getView("card", buildCard)
                                j.view = cv
                                cv.Open(lv.kind == "media" and "music" or (lv.kind == "timer" and "timer" or "watch"))
                                return
                        end
                        local v, spec
                        if lv.kind == "track" then
                                v, spec = getView("wide", buildWide), SPEC.Wide
                        elseif lv.kind == "farm" then
                                v, spec = getView("task", buildTask), SPEC.Task
                        else
                                v, spec = getView("media", buildMedia), SPEC.Large
                        end
                        v.Set(lv.data)
                        if v.Restart then v.Restart() end
                        j.view = v
                        present(v, spec.W, spec.H, spec.R, {})
                end
                return job
        end
        local function expandLive(sec)
                if not live or current then
                        return
                end
                local job = liveJob(live, true, sec)
                if not sec then
                        job.dur, job.hold, job.sticky, job.autoCollapse = nil, true, true, true
                end
                enqueue(job)
        end
        local function refreshLive(lv)
                pickLive()
                if current and current.live == lv then
                        if current.view and current.view.Set then
                                current.view.Set(lv.data)
                        end
                elseif not current and live == lv then
                        showLive()
                end
        end
        local function removeLive(lv)
                if lives[lv.kind] == lv then
                        lives[lv.kind] = nil
                end
                pickLive()
                if current and current.live == lv then
                        dismissJob(current)
                elseif not current then
                        goIdle()
                end
        end
        local function openPanel()
                if current and current.kind == "panel" then
                        return
                end
                local job = { kind = "panel", sticky = true, hold = true }
                job.start = function()
                        local v = getView("panel", buildPanel)
                        present(v, SPEC.Panel.W, SPEC.Panel.H, SPEC.Panel.R, {})
                end
                if current then
                        table.insert(queue, 1, current)
                        current = nil
                end
                runJob(job)
                return job
        end
        local function cardJob(page)
                local job = { kind = "card", page = page, sticky = true, hold = true }
                job.start = function(j)
                        local cv = getView("card", buildCard)
                        j.view = cv
                        cv.Open(page)
                end
                return job
        end
        local function openOverview(page)
                page = page or "home"
                if current and current.kind == "card" then
                        if current.view then
                                current.view.Go(page)
                        end
                        return
                end
                local job = cardJob(page)
                if current then
                        table.insert(queue, 1, current)
                        current = nil
                end
                runJob(job)
        end
        do
                local function hook()
                        return Island.CrossHook
                end
                local function enabled()
                        local h = hook()
                        if not (h and h.Enabled) then
                                return false
                        end
                        local ok, r = pcall(h.Enabled)
                        return ok and r == true
                end
                local function accent()
                        local h = hook()
                        local ok, c = pcall(function()
                                return h and h.Accent and h.Accent()
                        end)
                        if ok and typeof(c) == "Color3" then
                                return c
                        end
                        return C.Blue
                end
                local function prefix(source, count)
                        local n = utf8.len(source)
                        if not n then
                                return string.sub(source, 1, count)
                        end
                        if count >= n then
                                return source
                        end
                        if count <= 0 then
                                return ""
                        end
                        return string.sub(source, 1, utf8.offset(source, count + 1) - 1)
                end
                XC.st = "S0"
                XC.touched = 0
                XC.loops = {}
                XC.typeTok = {}
                XC.log = {}
                function XC.mark()
                        local l = XC.log
                        l[#l + 1] = { os.clock(), XC.st }
                        if #l > 40 then
                                table.remove(l, 1)
                        end
                end
                XC.on = enabled
                XC.accent = accent
                function XC.glass(b)
                        local cvg = tonumber(((_G.FARMX and _G.FARMX.Cfg) or {}).IslandGlass)
                        if cvg == 0 or b:GetAttribute("WAIsGlass") then
                                return
                        end
                        b:SetAttribute("WAIsGlass", true)
                        local cr = b:FindFirstChildOfClass("UICorner")
                        if Creator and Creator.LGApply then
                                pcall(Creator.LGApply, b, { rad = cr and cr.CornerRadius.Offset or 12, corner = cr and cr.CornerRadius or nil, always = true })
                        end
                end
                function XC.comet(track, color)
                        local clip = frame({
                                Name = "WAStarClip", BackgroundTransparency = 1, ClipsDescendants = true,
                                AnchorPoint = track.AnchorPoint, Position = UDim2.new(track.Position.X.Scale, track.Position.X.Offset, track.Position.Y.Scale, track.Position.Y.Offset - (track.AnchorPoint.Y == 0 and 6 or 0)),
                                Size = UDim2.new(track.Size.X.Scale, track.Size.X.Offset, track.Size.Y.Scale, track.Size.Y.Offset + 12), ZIndex = 3, Parent = track.Parent,
                        })
                        clip.Active = false
                        local th = math.max(3, track.Size.Y.Offset)
                        local col = color or Color3.fromRGB(255, 176, 32)
                        local tail = frame({
                                Name = "WAStar", BackgroundColor3 = Color3.new(1, 1, 1), AnchorPoint = V2(1, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                                Size = UDim2.new(0, 34, 0, th), ZIndex = 4, Parent = clip,
                        })
                        corner(tail)
                        new("UIGradient", {
                                Name = "WAGlowG",
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 0.5), NumberSequenceKeypoint.new(1, 0) }),
                                Color = ColorSequence.new(col, col:Lerp(Color3.new(1, 1, 1), 0.78)), Parent = tail,
                        })
                        local bloom = frame({
                                Name = "Bloom", BackgroundColor3 = col, BackgroundTransparency = 0.6, AnchorPoint = V2(1, 0.5),
                                Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(1, 8, 0, th + 8), ZIndex = 3, Parent = tail,
                        })
                        bloom.Active = false
                        corner(bloom)
                        new("UIGradient", {
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.15) }), Parent = bloom,
                        })
                        pcall(function()
                                TweenService:Create(bloom, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.88 }):Play()
                        end)
                        -- [QM-GL] P77 dom sang nho nhap nhay o khuc dang sang (kieu Color OS 17)
                        pcall(function()
                                local fxs = _G.FARMX
                                if fxs and fxs.Enable and fxs.Enable.BarSparks == false then
                                        return
                                end
                                for i = 1, 5 do
                                        local sz = (i % 2 == 0) and 2 or 3
                                        local yy = ((i % 3) - 1) * (th * 0.35)
                                        local sp = frame({
                                                Name = "WASpark", BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5),
                                                Position = UDim2.new(0, 4 + (i - 1) * 7, 0.5, yy), Size = UDim2.fromOffset(sz, sz), ZIndex = 5, Parent = tail,
                                        })
                                        sp.Active = false
                                        corner(sp)
                                        TweenService:Create(sp, TweenInfo.new(0.55 + i * 0.13, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, i * 0.11), { BackgroundTransparency = 0.05, Position = UDim2.new(0, 7 + (i - 1) * 7, 0.5, yy - 2) }):Play()
                                end
                        end)
                        return tail
                end
                function XC.cometColor(tail, color)
                        if not tail or typeof(color) ~= "Color3" then
                                return
                        end
                        local g = tail:FindFirstChild("WAGlowG")
                        if g then
                                g.Color = ColorSequence.new(color, color:Lerp(Color3.new(1, 1, 1), 0.78))
                        end
                        local b = tail:FindFirstChild("Bloom")
                        if b then
                                b.BackgroundColor3 = color
                        end
                end
                function XC.glassBtn(b)
                        if not b or b:GetAttribute("WAGlassBtn") then
                                return
                        end
                        b:SetAttribute("WAGlassBtn", true)
                        pcall(XC.glass, b)
                        local sc = new("UIScale", { Scale = 1, Parent = b })
                        pressFx(b, sc, 0.94)
                end
                -- [QM-LX] P84 Longxgen (Cross boncuti) gan vao island
                -- [LX] P84 giao dien Longxgen trong island: mat lanh/chan doi + khung chat + shell + pill shell (bo cuc tu Cross cua boncuti)
                local function LXO()
                    local h = Island.CrossHook
                    return h and h.Longxgen or nil
                end
                local LXCOL = { cmd = "#f5f6f8", ok = "#d9dde3", err = "#b7bcc4", dim = "#858b95", out = "#f5f6f8", warn = "#c6cbd2" }
                local function lxEsc(s)
                    s = string.gsub(tostring(s), "&", "&amp;")
                    s = string.gsub(s, "<", "&lt;")
                    return (string.gsub(s, ">", "&gt;"))
                end
                local MOODP = {
                    deadpan = { lid = 0.44, bl = -6, br = 6, mw = 13, mr = 0, my = 39, pdx = 0.0, pdy = 0.15 },
                    cold = { lid = 0.36, bl = -11, br = 11, mw = 12, mr = 0, my = 39, pdx = 0.0, pdy = 0.0 },
                    bored = { lid = 0.58, bl = 5, br = -5, mw = 9, mr = -5, my = 40, pdx = 0.0, pdy = 0.4 },
                    listen = { lid = 0.12, bl = -2, br = 2, mw = 8, mr = 0, my = 39, pdx = 0.0, pdy = 0.25 },
                    think = { lid = 0.28, bl = -3, br = 6, mw = 7, mr = 4, my = 40, pdx = -0.55, pdy = -0.55 },
                    annoyed = { lid = 0.52, bl = -16, br = 16, mw = 14, mr = 0, my = 40, pdx = 0.25, pdy = 0.0 },
                    eyeroll = { lid = 0.30, bl = -4, br = 4, mw = 10, mr = -3, my = 40, pdx = 0.0, pdy = 0.0 },
                }
                local function lxBuildFace(parent, px, pos)
                    local k = px / 52
                    local bgc = Color3.fromRGB(16, 17, 24)
                    local f = frame({ Name = "LXFace", BackgroundColor3 = bgc, Position = pos, Size = UDim2.fromOffset(px, px), Parent = parent })
                    f.Active = false
                    corner(f, math.floor(px * 0.34))
                    local stroke = new("UIStroke", { Thickness = 1.3, Color = Color3.fromRGB(170, 200, 255), Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = f })
                    local function eye(x)
                        local e = frame({
                            BackgroundColor3 = Color3.fromRGB(236, 240, 250), Position = UDim2.fromOffset(x * k, 16 * k),
                            Size = UDim2.fromOffset(11 * k, 14 * k), ClipsDescendants = true, Parent = f,
                        })
                        e.Active = false
                        corner(e, 5 * k)
                        local pu = frame({
                            BackgroundColor3 = Color3.fromRGB(14, 14, 20), AnchorPoint = V2(0.5, 0.5), Position = U2(0.5, 0, 0.5, 0),
                            Size = UDim2.fromOffset(6 * k, 6 * k), Parent = e,
                        })
                        corner(pu)
                        local lid = frame({ BackgroundColor3 = bgc, Size = U2(1, 0, 0, 0), ZIndex = 3, Parent = e })
                        return { e = e, pu = pu, lid = lid, h = 14 * k }
                    end
                    local function brow(cx)
                        local b = frame({
                            BackgroundColor3 = Color3.fromRGB(210, 218, 236), AnchorPoint = V2(0.5, 0.5),
                            Position = UDim2.fromOffset(cx * k, 10.5 * k), Size = UDim2.fromOffset(13 * k, math.max(2, 2 * k)), Parent = f,
                        })
                        corner(b)
                        return b
                    end
                    local mouth = frame({
                        BackgroundColor3 = Color3.fromRGB(210, 218, 236), AnchorPoint = V2(0.5, 0.5),
                        Position = UDim2.fromOffset(26 * k, 39 * k), Size = UDim2.fromOffset(13 * k, math.max(2, 2 * k)), Parent = f,
                    })
                    corner(mouth)
                    local face = {
                        f = f, stroke = stroke, k = k, L = eye(12), R = eye(29), bL = brow(17.5), bR = brow(34.5), mouth = mouth,
                        cur = { lid = 0.44, bl = -6, br = 6, mw = 13, mr = 0, my = 39, pdx = 0, pdy = 0.15 },
                        nextBlink = os.clock() + 2.5, blinkT = -1, rollT = -1, nextRoll = os.clock() + 14,
                    }
                    return face
                end
                local function lxFaceUpdate(face, dt, moodName, speaking)
                    if not face or not face.f.Parent then
                        return
                    end
                    local now = os.clock()
                    local tg = MOODP[moodName] or MOODP.deadpan
                    local cur = face.cur
                    local a = math.min(1, dt * 9)
                    for key, val in pairs(tg) do
                        cur[key] = cur[key] + (val - cur[key]) * a
                    end
                    local lid = cur.lid
                    local pdx, pdy = cur.pdx, cur.pdy
                    -- chop cham (cham, lanh)
                    if face.blinkT < 0 and now >= face.nextBlink then
                        face.blinkT = now
                        face.nextBlink = now + 3.2 + math.random() * 3.4
                    end
                    if face.blinkT >= 0 then
                        local u = (now - face.blinkT) / 0.26
                        if u >= 1 then
                            face.blinkT = -1
                        else
                            lid = lid + (1 - lid) * math.sin(u * math.pi)
                        end
                    end
                    -- liec mat (thinh thoang, hoac khi mood eyeroll)
                    if face.rollT < 0 and (moodName == "eyeroll" or (moodName == "bored" and now >= face.nextRoll)) then
                        face.rollT = now
                        face.nextRoll = now + 12 + math.random() * 8
                    end
                    if face.rollT >= 0 then
                        local u = (now - face.rollT) / 1.0
                        if u >= 1 then
                            face.rollT = -1
                        else
                            local ang = u * math.pi * 2.2 + math.pi * 0.5
                            pdx = math.cos(ang) * 0.85
                            pdy = -math.sin(ang) * 0.9
                            lid = math.min(lid, 0.3)
                        end
                    end
                    local k = face.k
                    for _, e in ipairs({ face.L, face.R }) do
                        e.lid.Size = U2(1, 0, 0, math.floor(e.h * math.clamp(lid, 0, 1) * 2 + 0.5) / 2)
                        e.pu.Position = U2(0.5, pdx * 2.6 * k, 0.5, pdy * 3.4 * k)
                    end
                    face.bL.Rotation = cur.bl
                    face.bR.Rotation = cur.br
                    local mh = math.max(2, 2 * k)
                    local mw = cur.mw * k
                    if speaking then
                        mh = mh + (0.5 + 0.5 * math.sin(now * 17)) * 2.2 * k
                        mw = mw * (0.8 + 0.2 * math.sin(now * 11))
                    end
                    face.mouth.Size = UDim2.fromOffset(mw, mh)
                    face.mouth.Rotation = cur.mr
                    face.mouth.Position = UDim2.fromOffset(26 * k, cur.my * k)
                end
                local function lxMood(L)
                    if L.MoodUntil > 0 and os.clock() >= L.MoodUntil then
                        L.MoodUntil = 0
                        L.Mood = L.Face
                    end
                    return L.Mood or "deadpan"
                end
                -- bo ve shell: nhieu dong, dong moi nhat danh may (typing) + con tro
                local function lxShellRender(L, st, maxLines, dt)
                    local lines = L.Lines
                    local n = #lines
                    local last = lines[n]
                    if n ~= st.n or last ~= st.last then
                        st.n, st.last, st.typed = n, last, 0
                    end
                    if last and st.typed < #last.text then
                        st.typed = math.min(#last.text, st.typed + dt * 95)
                    end
                    local typed = math.floor(st.typed)
                    local cur = (os.clock() % 1) < 0.55
                    local sig = n * 1000 + typed + (cur and 0.5 or 0) + (L.Ver * 0.001)
                    if sig == st.sig then
                        return nil
                    end
                    st.sig = sig
                    local out = {}
                    for i = math.max(1, n - maxLines + 1), n do
                        local l = lines[i]
                        local t = l.text
                        if i == n and typed < #t then
                            t = string.sub(t, 1, typed)
                        end
                        local s = '<font color="' .. (LXCOL[l.kind] or "#e6e8f0") .. '">' .. lxEsc(t) .. "</font>"
                        if i == n and cur then
                            s = s .. '<font color="#f5f6f8">_</font>'
                        end
                        out[#out + 1] = s
                    end
                    if n == 0 then
                        out[1] = '<font color="#858b95">trapx ~ $ </font>' .. (cur and '<font color="#f5f6f8">_</font>' or "")
                    end
                    return table.concat(out, "\n")
                end
                local XCARDS = {}
                function XC.mountCard(page, grad)
                    local card = {
                        page = page, viewRoot = page.Parent, grad = grad, full = "", count = 0, chatVer = -1,
                        speakUntil = 0, st = {}, bubbleAcc = 0, panelOpen = false,
                        panelMode = nil, panelToken = 0, panelUntil = 0,
                        inputExpanded = false, thinking = false, starClock = 0,
                        panelBaseIslandTransparency = island.BackgroundTransparency,
                        panelBaseRimTransparency = rimStroke.Transparency,
                    }
                    local face = lxBuildFace(page, 48, UDim2.fromOffset(16, 16))
                    card.face = face

                    local chatFrame = frame({
                        Name = "TrapxChatPill",
                        BackgroundColor3 = Color3.fromRGB(16, 10, 16),
                        BackgroundTransparency = 0.22,
                        Position = UDim2.fromOffset(74, 12),
                        Size = UDim2.fromOffset(252, 52),
                        ZIndex = 2,
                        Parent = page,
                    })
                    corner(chatFrame, 20)
                    local chatStroke = new("UIStroke", {
                        Thickness = 1.1, Color = Color3.fromRGB(133, 151, 224),
                        Transparency = 0.52, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Parent = chatFrame,
                    })
                    pcall(XC.glass, chatFrame)
                    card.chatFrame = chatFrame

                    local galaxy = frame({
                        Name = "ThinkingGalaxy",
                        BackgroundColor3 = Color3.fromRGB(8, 10, 30),
                        BackgroundTransparency = 0.03,
                        Size = UDim2.fromScale(1, 1),
                        Visible = false,
                        ZIndex = 2,
                        Parent = chatFrame,
                    })
                    corner(galaxy, 26)
                    local galaxyGradient = new("UIGradient", {
                        Rotation = 24,
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 15, 48)),
                            ColorSequenceKeypoint.new(0.28, Color3.fromRGB(42, 24, 94)),
                            ColorSequenceKeypoint.new(0.58, Color3.fromRGB(18, 47, 100)),
                            ColorSequenceKeypoint.new(0.82, Color3.fromRGB(70, 30, 96)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 34)),
                        }),
                        Parent = galaxy,
                    })
                    card.galaxyGradient = galaxyGradient

                    local nebula = {}
                    for i = 1, 3 do
                        local haze = frame({
                            Name = "Nebula" .. i,
                            BackgroundColor3 = ({ Color3.fromRGB(95, 74, 230), Color3.fromRGB(40, 128, 230), Color3.fromRGB(190, 70, 190) })[i],
                            BackgroundTransparency = 0.78,
                            AnchorPoint = V2(0.5, 0.5),
                            Position = UDim2.fromScale(({ 0.22, 0.62, 0.84 })[i], ({ 0.46, 0.30, 0.68 })[i]),
                            Size = UDim2.fromOffset(({ 82, 100, 68 })[i], ({ 26, 30, 22 })[i]),
                            ZIndex = 3,
                            Parent = galaxy,
                        })
                        corner(haze, 999)
                        new("UIGradient", {
                            Rotation = i * 57,
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.18),
                                NumberSequenceKeypoint.new(0.5, 0.62),
                                NumberSequenceKeypoint.new(1, 0.18),
                            }),
                            Parent = haze,
                        })
                        nebula[i] = haze
                    end
                    card.nebula = nebula

                    local stars = {}
                    for i = 1, 13 do
                        local sz = (i % 4 == 0) and 3 or 2
                        local star = frame({
                            Name = "GalaxyStar" .. i,
                            BackgroundColor3 = Color3.fromRGB(230, 238, 255),
                            BackgroundTransparency = 0.15 + (i % 3) * 0.12,
                            Position = UDim2.fromScale(((i * 37) % 93 + 3) / 100, ((i * 19) % 78 + 8) / 100),
                            Size = UDim2.fromOffset(sz, sz),
                            ZIndex = 4,
                            Parent = galaxy,
                        })
                        corner(star, 999)
                        stars[i] = { Object = star, Phase = i * 0.83, Speed = 1.2 + (i % 5) * 0.28 }
                    end
                    card.stars = stars

                    local orbit = frame({
                        Name = "ThinkingOrbit",
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(8, 8),
                        Size = UDim2.fromOffset(18, 18),
                        Visible = false,
                        ZIndex = 7,
                        Parent = chatFrame,
                    })
                    card.orbit = orbit
                    local orbitDots = {}
                    for i = 1, 4 do
                        local dot = frame({
                            Name = "OrbitDot" .. i,
                            BackgroundColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(167, 187, 255),
                            BackgroundTransparency = (i == 1) and 0.04 or 0.2 + i * 0.08,
                            AnchorPoint = V2(0.5, 0.5),
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromOffset(i == 1 and 5 or 4, i == 1 and 5 or 4),
                            ZIndex = 8,
                            Parent = orbit,
                        })
                        corner(dot, 999)
                        orbitDots[i] = dot
                    end
                    card.orbitDots = orbitDots

                    local thinkingText = label(chatFrame, {
                        Name = "ThinkingLabel",
                        Font = FONTB,
                        Text = "THINKING",
                        TextSize = 10,
                        TextColor3 = Color3.fromRGB(242, 245, 255),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        Position = UDim2.fromOffset(32, 0),
                        Size = UDim2.new(1, -38, 1, 0),
                        Visible = false,
                        ZIndex = 7,
                    })
                    card.thinkingText = thinkingText

                    local bubble = label(page, {
                        Name = "TrapxReply",
                        Font = FONT,
                        TextSize = 12,
                        TextColor3 = Color3.fromRGB(226, 230, 244),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top,
                        TextWrapped = true,
                        Position = UDim2.fromOffset(84, 18),
                        Size = UDim2.fromOffset(232, 42),
                        Text = "",
                        ZIndex = 5,
                    })
                    card.bubble = bubble
                    card.replyHeight = 52
                    local shell = frame({
                        Name = "TrapxShell",
                        BackgroundColor3 = Color3.fromRGB(8, 9, 14),
                        BackgroundTransparency = 0.12,
                        Position = UDim2.fromOffset(14, 68),
                        Size = UDim2.fromOffset(312, 54),
                        Parent = page,
                    })
                    shell.Active = false
                    corner(shell, 11)
                    new("UIStroke", {
                        Thickness = 1,
                        Color = Color3.fromRGB(170, 200, 255),
                        Transparency = 0.7,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Parent = shell,
                    })
                    pcall(XC.glass, shell)
                    card.shell = shell
                    card.shellText = label(shell, {
                        Font = Enum.Font.Code,
                        TextSize = 10,
                        RichText = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top,
                        Position = UDim2.fromOffset(8, 4),
                        Size = UDim2.fromOffset(296, 46),
                        Text = "",
                        TextWrapped = false,
                        ClipsDescendants = true,
                    })

                    local row = frame({
                        Name = "TrapxInputPill",
                        BackgroundColor3 = Color3.fromRGB(31, 16, 23),
                        BackgroundTransparency = 0.16,
                        Position = UDim2.fromOffset(14, 126),
                        Size = UDim2.fromOffset(46, 24),
                        ClipsDescendants = true,
                        ZIndex = 6,
                        Parent = page,
                    })
                    corner(row, 13)
                    new("UIStroke", {
                        Thickness = 1,
                        Color = Color3.fromRGB(170, 200, 255),
                        Transparency = 0.68,
                        Parent = row,
                    })
                    pcall(XC.glass, row)
                    local input = new("TextBox", {
                        Name = "TrapxInput",
                        BackgroundTransparency = 1,
                        ClearTextOnFocus = false,
                        Font = FONT,
                        TextSize = 11,
                        TextColor3 = C.White,
                        PlaceholderText = "⌕",
                        PlaceholderColor3 = Color3.fromRGB(154, 163, 190),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        Position = UDim2.fromOffset(9, 0),
                        Size = UDim2.new(1, -16, 1, 0),
                        Text = "",
                        ZIndex = 7,
                        Parent = row,
                    })
                    card.input = input

                    local send = new("TextButton", {
                        Name = "TrapxSend",
                        BackgroundColor3 = Color3.fromRGB(174, 28, 49),
                        BackgroundTransparency = 0.22,
                        Text = "Gửi",
                        Font = FONTB,
                        TextSize = 11,
                        TextColor3 = C.White,
                        AutoButtonColor = false,
                        Position = UDim2.fromOffset(276, 126),
                        Size = UDim2.fromOffset(50, 24),
                        Visible = false,
                        ZIndex = 7,
                        Parent = page,
                    })
                    corner(send, 12)
                    pcall(XC.glassBtn, send)
                    card.row, card.send = row, send

                    local function fitReply(text, animate, force)
                        text = tostring(text or "")
                        local targetH = 52
                        if text ~= "" then
                            local ok, measured = pcall(function()
                                return TextService:GetTextSize(text, 12, FONT, V2(232, 120))
                            end)
                            if ok and measured then
                                targetH = math.clamp(math.ceil(measured.Y + 16), 52, 84)
                            end
                        end
                        if not force and math.abs(targetH - (card.replyHeight or 52)) < 5 then
                            return
                        end
                        card.replyHeight = targetH
                        local shellY = 12 + targetH + 6
                        local inputY = shellY + 58
                        local useTween = animate ~= false
                        local function apply(obj, duration, props)
                            if useTween then
                                tw(obj, duration, props, Enum.EasingStyle.Quint, EOUT)
                            else
                                for k, v in pairs(props) do obj[k] = v end
                            end
                        end
                        if not card.thinking then
                            apply(chatFrame, 0.18, { Size = UDim2.fromOffset(252, targetH) })
                            apply(bubble, 0.18, { Size = UDim2.fromOffset(232, math.max(34, targetH - 10)) })
                        end
                        apply(shell, 0.18, { Position = UDim2.fromOffset(14, shellY) })
                        apply(row, 0.18, { Position = UDim2.fromOffset(14, inputY) })
                        apply(send, 0.18, { Position = UDim2.fromOffset(276, inputY) })
                    end
                    card.fitReply = fitReply

                    local panel = new("CanvasGroup", {
                        Name = "TrapxCommandPanel",
                        BackgroundColor3 = Color3.fromRGB(15, 8, 14),
                        BackgroundTransparency = 0.16,
                        GroupTransparency = 1,
                        Visible = false,
                        ClipsDescendants = true,
                        ZIndex = 20,
                        Parent = island,
                    })
                    corner(panel, 22)
                    new("UIStroke", {
                        Thickness = 1.1,
                        Color = Color3.fromRGB(147, 171, 242),
                        Transparency = 0.55,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Parent = panel,
                    })
                    pcall(XC.glass, panel)
                    card.panel = panel
                    local panelBridge = frame({
                        Name = "TrapxShellBridge",
                        BackgroundColor3 = Color3.fromRGB(35, 13, 22),
                        BackgroundTransparency = 0.20,
                        Visible = false,
                        ZIndex = 18,
                        Parent = island,
                    })
                    corner(panelBridge, 12)
                    pcall(XC.glass, panelBridge)
                    card.panelBridge = panelBridge
                    local panelScale = new("UIScale", { Scale = 0.94, Parent = panel })
                    card.panelScale = panelScale

                    local panelHeader = label(panel, {
                        Name = "CommandHeader",
                        Font = FONTB,
                        Text = "TRAPX  ·  COMMAND SHELL",
                        TextSize = 9,
                        TextColor3 = Color3.fromRGB(255, 228, 232),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.fromOffset(11, 7),
                        Size = UDim2.new(1, -22, 0, 16),
                        ZIndex = 22,
                    })
                    card.panelHeader = panelHeader
                    local panelQuery = label(panel, {
                        Name = "CommandQuery",
                        Font = Enum.Font.Code,
                        Text = "Gợi ý lệnh · chọn một nút để thực hiện",
                        TextSize = 8,
                        TextColor3 = Color3.fromRGB(135, 151, 187),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        Position = UDim2.fromOffset(11, 23),
                        Size = UDim2.new(1, -22, 0, 12),
                        ZIndex = 22,
                    })
                    card.panelQuery = panelQuery
                    local scroll = new("ScrollingFrame", {
                        Name = "CommandScroll",
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2.fromOffset(7, 40),
                        Size = UDim2.new(1, -14, 1, -47),
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        ScrollBarThickness = 2,
                        ScrollBarImageColor3 = Color3.fromRGB(153, 177, 240),
                        ZIndex = 21,
                        Parent = panel,
                    })
                    card.scroll = scroll
                    new("UIPadding", {
                        PaddingTop = UDim.new(0, 2),
                        PaddingBottom = UDim.new(0, 5),
                        PaddingLeft = UDim.new(0, 1),
                        PaddingRight = UDim.new(0, 3),
                        Parent = scroll,
                    })
                    new("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 4),
                        Parent = scroll,
                    })
                    local rows = {}
                    for i = 1, 36 do
                        local btn = new("TextButton", {
                            Name = "CommandButton" .. i,
                            BackgroundColor3 = Color3.fromRGB(28, 35, 58),
                            BackgroundTransparency = 0.30,
                            Text = "",
                            AutoButtonColor = false,
                            Size = UDim2.new(1, -3, 0, 34),
                            LayoutOrder = i,
                            ZIndex = 22,
                            Parent = scroll,
                        })
                        corner(btn, 9)
                        new("UIStroke", {
                            Thickness = 0.7,
                            Color = Color3.fromRGB(154, 176, 238),
                            Transparency = 0.82,
                            Parent = btn,
                        })
                        pcall(XC.glassBtn, btn)
                        local title = label(btn, {
                            Name = "CommandTitle",
                            Font = FONTB,
                            Text = "",
                            TextSize = 9,
                            TextColor3 = Color3.fromRGB(237, 241, 255),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            Position = UDim2.fromOffset(9, 3),
                            Size = UDim2.new(1, -65, 0, 14),
                            ZIndex = 24,
                        })
                        local detail = label(btn, {
                            Name = "CommandDetail",
                            Font = FONT,
                            Text = "",
                            TextSize = 8,
                            TextColor3 = Color3.fromRGB(152, 166, 205),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            Position = UDim2.fromOffset(9, 17),
                            Size = UDim2.new(1, -18, 0, 12),
                            ZIndex = 24,
                        })
                        local kind = label(btn, {
                            Name = "CommandType",
                            Font = Enum.Font.Code,
                            Text = "",
                            TextSize = 7,
                            TextColor3 = Color3.fromRGB(167, 190, 255),
                            TextXAlignment = Enum.TextXAlignment.Right,
                            Position = UDim2.new(1, -55, 0, 3),
                            Size = UDim2.fromOffset(46, 12),
                            ZIndex = 24,
                        })
                        local entry = { Button = btn, Title = title, Detail = detail, Kind = kind, Item = nil }
                        rows[i] = entry
                        btn.Activated:Connect(function()
                            local item = entry.Item
                            local L = LXO()
                            if not (item and L and L.Handle) then return end
                            local command = item.Command
                            card.suggestQuery = command
                            input.Text = ""
                            card.renderSuggestions(command)
                            if input:IsFocused() then input:ReleaseFocus() end
                            touch()
                            L.Handle(command)
                            card.panelUntil = os.clock() + 8
                        end)
                    end
                    card.rows = rows
                    local empty = label(panel, {
                        Name = "CommandEmpty",
                        Font = FONT,
                        Text = "Không tìm thấy lệnh phù hợp.",
                        TextSize = 9,
                        TextColor3 = Color3.fromRGB(148, 158, 183),
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Position = UDim2.new(0, 8, 0, 70),
                        Size = UDim2.new(1, -16, 0, 28),
                        Visible = false,
                        ZIndex = 23,
                    })
                    card.empty = empty

                    function card.renderSuggestions(query)
                        local L = LXO()
                        if not (L and L.Suggestions) then return end
                        local items = L.Suggestions(query or "")
                        local count = math.min(#items, #rows)
                        panelQuery.Text = (query and query ~= "") and ("SEARCH  ·  " .. tostring(query)) or "Gợi ý lệnh · chọn một nút để thực hiện"
                        empty.Visible = count == 0
                        for i, entry in ipairs(rows) do
                            local item = items[i]
                            entry.Item = item
                            entry.Button.Visible = item ~= nil and i <= count
                            if item then
                                entry.Title.Text = item.Title or "Command"
                                entry.Detail.Text = item.Detail or item.Command or ""
                                entry.Kind.Text = item.Category or "ACTION"
                            else
                                entry.Title.Text = ""
                                entry.Detail.Text = ""
                                entry.Kind.Text = ""
                            end
                        end
                        if scroll then scroll.CanvasPosition = Vector2.new(0, 0) end
                    end

                    local function setInputExpanded(on)
                        on = on == true
                        if card.inputExpanded == on then return end
                        card.inputExpanded = on
                        if on then
                            input.PlaceholderText = "Nhắn Trapx hoặc tìm lệnh..."
                            tw(row, 0.32, { Size = UDim2.fromOffset(256, 24) }, Enum.EasingStyle.Quint, EOUT)
                            tw(input, 0.25, { TextTransparency = 0 }, Enum.EasingStyle.Quint, EOUT)
                            send.Visible = true
                            send.BackgroundTransparency = 1
                            tw(send, 0.24, { BackgroundTransparency = 0.22 }, Enum.EasingStyle.Quint, EOUT)
                        else
                            input.PlaceholderText = "⌕"
                            tw(row, 0.30, { Size = UDim2.fromOffset(46, 24) }, Enum.EasingStyle.Quint, EOUT)
                            tw(send, 0.16, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, EOUT)
                            task.delay(0.18, function()
                                if not card.inputExpanded then send.Visible = false end
                            end)
                        end
                    end
                    card.setInputExpanded = setInputExpanded

                    local function submit()
                        local L = LXO()
                        local text = input.Text
                        if not L or text == "" then return end
                        card.suggestQuery = text
                        input.Text = ""
                        card.renderSuggestions(text)
                        touch()
                        card.panelUntil = os.clock() + 8
                        L.Handle(text)
                        if input:IsFocused() then input:ReleaseFocus() end
                    end
                    send.Activated:Connect(submit)
                    input.FocusLost:Connect(function(enter)
                        if enter then submit() end
                        local L = LXO()
                        if L then L.SetMood(L.Face) end
                        if input.Text == "" then setInputExpanded(false) end
                    end)
                    input.Focused:Connect(function()
                        touch()
                        setInputExpanded(true)
                        local L = LXO()
                        if L then L.SetMood("listen", 0) end
                        card.renderSuggestions(input.Text)
                    end)
                    input:GetPropertyChangedSignal("Text"):Connect(function()
                        if input.Text ~= "" then
                            card.suggestQuery = input.Text
                            setInputExpanded(true)
                            card.panelUntil = os.clock() + 8
                            if not card.searchTriggered then
                                card.searchTriggered = true
                                card.setPanel(true)
                            end
                            card.renderSuggestions(input.Text)
                        else
                            card.searchTriggered = false
                            if not card.panelOpen then
                                card.renderSuggestions(card.suggestQuery or "")
                            end
                        end
                    end)

                    function card.setPanel(open)
                        open = open == true
                        if open == (card.panelOpen == true) then return end
                        card.panelToken = card.panelToken + 1
                        local token = card.panelToken

                        local CARD_W, CARD_H = SPEC.Card.W, SPEC.Card.H
                        local SHELL_GAP = 7

                        if not open then
                            if not card.panelOpen then return end
                            card.panelOpen = false
                            card.panelMode = nil
                            Island._lxShellOpen = false
                            Island._lxShellScale = 1

                            local closeX = CARD_W + SHELL_GAP - 18
                            tw(panel, 0.22, {
                                Position = UDim2.fromOffset(closeX, panel.Position.Y.Offset),
                                Size = UDim2.fromOffset(28, panel.Size.Y.Offset),
                                GroupTransparency = 1,
                                Rotation = 0.7,
                            }, Enum.EasingStyle.Quint, EIN)
                            if card.panelBridge then
                                tw(card.panelBridge, 0.16, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, EIN)
                            end
                            if card.panelScale then
                                tw(card.panelScale, 0.18, { Scale = 0.94 }, Enum.EasingStyle.Quad, EIN)
                            end
                            if card.viewRoot then
                                tw(card.viewRoot, 0.32, {
                                    Position = UDim2.fromOffset(CARD_W / 2, CARD_H / 2),
                                }, BACK, EOUT)
                            end
                            sp.Press:to(1, SPR.Press)
                            setSize(CARD_W, CARD_H, SPEC.Card.R)

                            task.delay(0.26, function()
                                if card.panelToken == token and not card.panelOpen then
                                    panel.Visible = false
                                    panel.Rotation = 0
                                    panel.Position = UDim2.fromOffset(CARD_W + SHELL_GAP, 8)
                                    panel.Size = UDim2.fromOffset(28, CARD_H - 16)
                                    if card.panelBridge then
                                        card.panelBridge.Visible = false
                                        card.panelBridge.BackgroundTransparency = 0.20
                                    end
                                    if card.viewRoot then
                                        card.viewRoot.Position = UDim2.fromOffset(CARD_W / 2, CARD_H / 2)
                                    end
                                    island.BackgroundTransparency = card.panelBaseIslandTransparency
                                    rimStroke.Transparency = card.panelBaseRimTransparency
                                    refreshBubble()
                                end
                            end)
                            return
                        end

                        local cam = workspace.CurrentCamera
                        local vp = cam and cam.ViewportSize or V2(800, 600)
                        local baseScale = math.max((Island._base74 or uiScale.Scale) * (Island._k74 or 1), 0.45)
                        local availableLogical = math.max(1, (vp.X - 28) / baseScale)
                        local panelW = math.floor(math.clamp(availableLogical - CARD_W - SHELL_GAP, 188, 282))
                        local totalW = CARD_W + SHELL_GAP + panelW
                        local fitScale = math.min(1, (vp.X - 24) / math.max(totalW * baseScale, 1))
                        local panelH = math.floor(math.clamp((vp.Y / math.max(baseScale, 0.45)) * 0.26, 174, CARD_H - 12))
                        local panelTop = math.floor((CARD_H - panelH) / 2)
                        local finalX = CARD_W + SHELL_GAP

                        card.panelOpen = true
                        card.panelMode = "right-attached"
                        card.panelWidth = panelW
                        card.panelHeight = panelH
                        Island._lxShellOpen = true
                        Island._lxShellScale = math.clamp(fitScale, 0.58, 1)

                        page.Position = UDim2.fromScale(0.5, 0.5)
                        if card.viewRoot then
                            -- Pin the Longxgen card to the left edge of the expanded island group.
                            card.viewRoot.Position = UDim2.fromOffset(CARD_W / 2, CARD_H / 2)
                        end

                        -- The Island's own black backing/rim is hidden. The original card and
                        -- the command shell remain separate Flux-glass surfaces in one group.
                        island.BackgroundTransparency = 1
                        rimStroke.Transparency = 1

                        panel.AnchorPoint = V2(0, 0)
                        panel.Position = UDim2.fromOffset(finalX - 18, panelTop)
                        panel.Size = UDim2.fromOffset(28, panelH)
                        panel.GroupTransparency = 1
                        panel.Rotation = 1.15
                        if card.panelScale then card.panelScale.Scale = 0.92 end
                        panel.Visible = true

                        if card.panelBridge then
                            card.panelBridge.Position = UDim2.fromOffset(CARD_W - 8, math.floor(CARD_H / 2 - 15))
                            card.panelBridge.Size = UDim2.fromOffset(22, 30)
                            card.panelBridge.BackgroundTransparency = 0.20
                            card.panelBridge.Visible = true
                        end

                        -- Expanding the Island itself pushes the shell to the right. The card
                        -- stays pinned on the left, while the new shell slides out from its edge.
                        setSize(totalW, CARD_H, 30)
                        refreshBubble()
                        sp.Press:to(1.012, SPR.Press)
                        tw(panel, 0.30, {
                            Position = UDim2.fromOffset(finalX + 3, panelTop),
                            Size = UDim2.fromOffset(panelW, panelH),
                            GroupTransparency = 0,
                            Rotation = 1.15,
                        }, BACK, EOUT)
                        if card.panelScale then
                            tw(card.panelScale, 0.38, { Scale = 1 }, BACK, EOUT)
                        end
                        if card.panelBridge then
                            tw(card.panelBridge, 0.24, { BackgroundTransparency = 0.08 }, Enum.EasingStyle.Quint, EOUT)
                        end
                        task.delay(0.12, function()
                            if card.panelToken == token and card.panelOpen then
                                tw(panel, 0.14, {
                                    Position = UDim2.fromOffset(finalX - 2, panelTop),
                                    Rotation = -0.72,
                                }, Enum.EasingStyle.Sine, EOUT)
                            end
                        end)
                        task.delay(0.25, function()
                            if card.panelToken == token and card.panelOpen then
                                tw(panel, 0.13, {
                                    Position = UDim2.fromOffset(finalX + 1, panelTop),
                                    Rotation = 0.34,
                                }, Enum.EasingStyle.Sine, EOUT)
                            end
                        end)
                        task.delay(0.39, function()
                            if card.panelToken == token and card.panelOpen then
                                tw(panel, 0.18, {
                                    Position = UDim2.fromOffset(finalX, panelTop),
                                    Rotation = 0,
                                }, Enum.EasingStyle.Sine, EOUT)
                                sp.Press:to(1, SPR.Press)
                            end
                        end)
                    end

                    local function setThinking(on)
                        on = on == true
                        if card.thinking == on then return end
                        card.thinking = on
                        if on then
                            galaxy.Visible = true
                            orbit.Visible = true
                            thinkingText.Visible = true
                            bubble.TextTransparency = 1
                            tw(chatFrame, 0.28, {
                                Position = UDim2.fromOffset(100, 20),
                                Size = UDim2.fromOffset(194, 36),
                                BackgroundTransparency = 0.05,
                            }, Enum.EasingStyle.Quint, EOUT)
                            tw(orbit, 0.24, { Position = UDim2.fromOffset(7, 9), Size = UDim2.fromOffset(18, 18) }, Enum.EasingStyle.Quint, EOUT)
                            tw(chatStroke, 0.28, { Transparency = 0.18 }, Enum.EasingStyle.Quint, EOUT)
                            card.panelUntil = os.clock() + 8
                            card.setPanel(true)
                        else
                            galaxy.Visible = false
                            orbit.Visible = false
                            thinkingText.Visible = false
                            bubble.TextTransparency = 0
                            tw(chatFrame, 0.34, {
                                Position = UDim2.fromOffset(74, 12),
                                Size = UDim2.fromOffset(252, card.replyHeight or 52),
                                BackgroundTransparency = 0.22,
                            }, Enum.EasingStyle.Quint, EOUT)
                            tw(orbit, 0.22, { Position = UDim2.fromOffset(12, 12), Size = UDim2.fromOffset(22, 22) }, Enum.EasingStyle.Quint, EOUT)
                            tw(chatStroke, 0.28, { Transparency = 0.52 }, Enum.EasingStyle.Quint, EOUT)
                            if card.fitReply then card.fitReply(card.full, true, true) end
                        end
                    end
                    card.setThinking = setThinking

                    function card.tick(dt)
                        local L = LXO()
                        if not L then return end
                        if input:IsFocused() then touch() end
                        local now = os.clock()

                        if L.ChatVer ~= card.chatVer then
                            card.chatVer = L.ChatVer
                            local m = L.Chat[#L.Chat]
                            if m and m.role == "ai" then
                                card.full, card.count, card.bubbleAcc = m.text, 0, 0
                                card.speakUntil = now + (utf8.len(m.text) or #m.text) / 48 + 0.4
                                if card.suppressNextChatPanel then
                                    card.suppressNextChatPanel = false
                                else
                                    card.panelUntil = now + 8
                                end
                            elseif m then
                                card.full, card.count, card.bubbleAcc = "...", 1, 0
                                card.panelUntil = now + 8
                            end
                            card.renderSuggestions(input.Text ~= "" and input.Text or (card.suggestQuery or ""))
                        end

                        setThinking(L.Thinking == true)
                        local total = utf8.len(card.full) or #card.full
                        if not L.Thinking then
                            if card.count < total then
                                card.bubbleAcc = card.bubbleAcc + dt * 48
                                local step = math.floor(card.bubbleAcc)
                                if step > 0 then
                                    card.bubbleAcc = card.bubbleAcc - step
                                    card.count = math.min(total, card.count + step)
                                    bubble.Text = prefix(card.full, card.count)
                                    if card.fitReply then card.fitReply(bubble.Text, true) end
                                end
                            elseif bubble.Text ~= card.full then
                                bubble.Text = card.full
                                if card.fitReply then card.fitReply(card.full, true) end
                            end
                        end

                        local spin = now * 4.8
                        for i, dot in ipairs(orbitDots) do
                            local angle = spin + (i - 1) * (math.pi * 2 / #orbitDots)
                            dot.Position = UDim2.fromOffset(9 + math.cos(angle) * 5.8, 9 + math.sin(angle) * 5.8)
                            dot.BackgroundTransparency = 0.12 + (i - 1) * 0.14
                        end
                        if L.Thinking then
                            galaxyGradient.Rotation = (now * 8) % 360
                            for _, star in ipairs(stars) do
                                star.Object.BackgroundTransparency = 0.10 + (0.52 * (0.5 + 0.5 * math.sin(now * star.Speed + star.Phase)))
                            end
                            for i, haze in ipairs(nebula) do
                                haze.Position = UDim2.fromScale(
                                    ({ 0.22, 0.62, 0.84 })[i] + math.sin(now * (0.22 + i * 0.05) + i) * 0.035,
                                    ({ 0.46, 0.30, 0.68 })[i] + math.cos(now * (0.18 + i * 0.04) + i) * 0.045
                                )
                            end
                        end

                        local wantsPanel = card.searchTriggered == true
                            or L.Thinking == true
                            or (tonumber(L.Busy) or 0) > 0
                            or now < card.panelUntil
                        if wantsPanel and not card.panelOpen then
                            card.setPanel(true)
                        elseif not wantsPanel and card.panelOpen then
                            card.setPanel(false)
                        end

                        local txt = lxShellRender(L, card.st, 4, dt)
                        if txt then card.shellText.Text = txt end
                        lxFaceUpdate(face, dt, lxMood(L), now < card.speakUntil)
                    end

                    card.renderSuggestions("")
                    XCARDS[#XCARDS + 1] = card
                    return card
                end
                function XC.cardShow(card, alive)
                    if not card or card.conn then
                        return
                    end
                    XC.shown = card
                    card.panelToken = (card.panelToken or 0) + 1
                    card.panelOpen = false
                    card.panelMode = nil
                    card.panelUntil = 0
                    card.searchTriggered = false
                    card.inputExpanded = false
                    card.suggestQuery = ""
                    if card.panel then
                        card.panel.Visible = false
                        card.panel.GroupTransparency = 1
                        card.panel.Rotation = 0
                    end
                    if card.panelBridge then
                        card.panelBridge.Visible = false
                        card.panelBridge.BackgroundTransparency = 0.20
                    end
                    if card.panelScale then card.panelScale.Scale = 0.94 end
                    if card.input then card.input.Text = "" end
                    if card.setInputExpanded then
                        card.inputExpanded = true
                        card.setInputExpanded(false)
                    end
                    if card.renderSuggestions then card.renderSuggestions("") end
                    card.thinking = false
                    card.page.Position = UDim2.fromScale(0.5, 0.5)
                    if card.viewRoot then card.viewRoot.Position = UDim2.fromScale(0.5, 0.5) end
                    island.BackgroundTransparency = card.panelBaseIslandTransparency
                    rimStroke.Transparency = card.panelBaseRimTransparency
                    setSize(SPEC.Card.W, SPEC.Card.H, SPEC.Card.R)
                    local L = LXO()
                    if L and #L.Chat == 0 then
                        card.suppressNextChatPanel = true
                        local greet = { "Ừ. Có việc gì thì nói.", "Gì đó. Bật tắt gì cứ bảo.", "Tôi đây. Nói nhanh lên." }
                        L.Say(greet[math.random(1, #greet)], L.Face, 2)
                    end
                    card.conn = RunService.Heartbeat:Connect(function(dt)
                        if destroyed or (alive and not alive()) then
                            XC.cardHide()
                            return
                        end
                        local ok, err = pcall(card.tick, math.min(dt, 0.1))
                        if not ok then
                            card.conn:Disconnect()
                            card.conn = nil
                            warn("[Trapx] " .. tostring(err))
                        end
                    end)
                end
                function XC.cardHide()
                    local card = XC.shown
                    XC.shown = nil
                    if card and card.conn then
                        card.conn:Disconnect()
                        card.conn = nil
                    end
                    if card then
                        card.panelToken = card.panelToken + 1
                        card.panelOpen = false
                        card.panelMode = nil
                        card.panelUntil = 0
                        card.searchTriggered = false
                        card.inputExpanded = false
                        card.suggestQuery = ""
                        if card.panel then
                            card.panel.Visible = false
                            card.panel.GroupTransparency = 1
                            card.panel.Rotation = 0
                            card.panel.Position = UDim2.fromOffset(SPEC.Card.W + 7, 8)
                            card.panel.Size = UDim2.fromOffset(28, SPEC.Card.H - 16)
                        end
                        if card.panelBridge then
                            card.panelBridge.Visible = false
                            card.panelBridge.BackgroundTransparency = 0.20
                        end
                        if card.panelScale then card.panelScale.Scale = 0.94 end
                        if card.input and card.input:IsFocused() then
                            pcall(function() card.input:ReleaseFocus() end)
                        end
                        if card.input then card.input.Text = "" end
                        if card.setInputExpanded then
                            card.inputExpanded = true
                            card.setInputExpanded(false)
                        end
                        if card.thinking and card.setThinking then
                            card.setThinking(false)
                        end
                        card.thinking = false
                        card.page.Position = UDim2.fromScale(0.5, 0.5)
                        if card.viewRoot then card.viewRoot.Position = UDim2.fromScale(0.5, 0.5) end
                        island.BackgroundTransparency = card.panelBaseIslandTransparency
                        rimStroke.Transparency = card.panelBaseRimTransparency
                        setSize(SPEC.Card.W, SPEC.Card.H, SPEC.Card.R)
                    end
                end
                -- pill shell tren island: hien lenh dang chay (dong cuoi danh may) khi the Longxgen khong mo
                local function buildShellPill()
                    local v = makeView("XShell", 330, 76)
                    local f = v.frame
                    local bg = frame({ BackgroundColor3 = Color3.fromRGB(8, 9, 14), Size = UDim2.fromScale(1, 1), Parent = f })
                    corner(bg, 26)
                    new("UIStroke", { Thickness = 1.2, Color = Color3.fromRGB(170, 200, 255), Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = bg })
                    local sheen = frame({
                        BackgroundColor3 = C.White, BackgroundTransparency = 0.92, AnchorPoint = V2(0.5, 0), Position = U2(0.5, 0, 0, 2),
                        Size = U2(1, -24, 0.4, 0), Parent = f,
                    })
                    sheen.Active = false
                    corner(sheen)
                    new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = sheen })
                    local face = lxBuildFace(f, 40, UDim2.fromOffset(14, 18))
                    local txt = label(f, {
                        Font = Enum.Font.Code, TextSize = 11, RichText = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
                        Position = UDim2.fromOffset(64, 8), Size = UDim2.fromOffset(254, 60), Text = "", TextWrapped = false, ClipsDescendants = true,
                    })
                    local st = {}
                    local speakUntil = 0
                    v.face = face
                    function v.Refresh()
                        st.sig = nil
                        speakUntil = os.clock() + 1.2
                    end
                    function v.Tick(dt)
                        local L = LXO()
                        if not L then
                            return
                        end
                        local s = lxShellRender(L, st, 4, dt)
                        if s then
                            txt.Text = s
                        end
                        lxFaceUpdate(face, dt, lxMood(L), os.clock() < speakUntil)
                    end
                    return v
                end
                function XC.shellKick()
                    local L = LXO()
                    if not L or destroyed then
                        return
                    end
                    if XC.shown then
                        return
                    end
                    local job = XC.shellJob
                    if job and current == job then
                        job.token = (job.token or 0) + 1
                        local tok = job.token
                        if job.view and job.view.Refresh then
                            job.view.Refresh()
                        end
                        task.delay(3.4, function()
                            if not destroyed and current == job and job.token == tok then
                                dismissJob(job)
                            end
                        end)
                        return
                    end
                    if current and (current.kind == "card" or current.kind == "panel") then
                        return
                    end
                    job = { kind = "cross", dur = 3.4, urgent = true }
                    job.start = function(j)
                        local sv = getView("xshell", buildShellPill)
                        j.view = sv
                        sv.Refresh()
                        present(sv, 330, 76, 26, {})
                    end
                    XC.shellJob = job
                    enqueue(job)
                end
                function XC.openCard()
                    touch()
                    openOverview("cross")
                end
                function Island:BindLongxgen(L)
                    L.OnLine = function()
                        XC.shellKick()
                    end
                    L.OnOpen = function()
                        XC.openCard()
                    end
                end
                function XC.pause()
                    return false
                end
                function XC.swipe()
                    return false
                end
                function XC.destroy()
                    XC.cardHide()
                    local L = LXO()
                    if L then
                        L.OnLine, L.OnOpen = nil, nil
                    end
                    Island.CrossHook = nil
                end
        end
        local function setWindowOpen(open)
                if windowOpen == open then
                        return
                end
                windowOpen = open
                refreshBubble()
                if Creator and Creator.BCG then
                        Creator.BCG.Pause = not open
                end
                if open and cfg.OpenPill then
                        Island:Notify({ Title = tostring(window.Title or "Menu"), Icon = window.Icon, Duration = 1.4, Style = "Pill" })
                end
        end
        local function pointerInside()
                if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
                        return false
                end
                local ok, pos = pcall(function()
                        return UserInputService:GetMouseLocation()
                end)
                if not ok then
                        return false
                end
                local p, s = island.AbsolutePosition, island.AbsoluteSize
                return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
        end
        local pressed, held = false, false
        local activePressInput = nil
        local mainHoldToken = 0
        local mainPressMoved = false
        local holdInputConnections = {}
        local function samePressInput(a, b)
                if a == b then return true end
                if not a or not b or a.UserInputType ~= b.UserInputType then return false end
                if a.UserInputType == Enum.UserInputType.Touch then
                        return false
                end
                return a.UserInputType == Enum.UserInputType.MouseButton1
        end
        local function resetPressState()
                mainHoldToken = mainHoldToken + 1
                if not pressed and not held and not activePressInput then return end
                pressed, held, activePressInput = false, false, nil
                mainPressMoved = false
                XC.sw = nil
                sp.Press:to(1, SPR.Press)
        end
        local function hitBegan(i)
                if not isPress(i) or pressed then
                        return
                end
                touch()
                activePressInput = i
                pressed, held = true, false
                mainPressMoved = false
                mainHoldToken = mainHoldToken + 1
                local holdToken = mainHoldToken
                XC.sw = { x = i.Position.X, y = i.Position.Y, t = os.clock() }
                sp.Press:to(0.97, SPR.Press)
                task.delay(math.max(tonumber(cfg.HoldTime) or 0.38, 0.28), function()
                        if destroyed or not pressed or held or mainPressMoved or mainHoldToken ~= holdToken then
                                return
                        end
                        held = true
                        XC.sw = nil
                        touch()
                        sp.Press:to(1.025, SPR.Press)
                        task.delay(0.09, function()
                                if not destroyed and held and mainHoldToken == holdToken then
                                        sp.Press:to(1, SPR.Press)
                                end
                        end)
                        -- openOverview preserves a live job in the queue; DIM.Tick then
                        -- demotes that activity into the adjacent toggle bubble.
                        openOverview("home")
                end)
        end
        local function hitChanged(i)
                if not pressed or not i or not i.Position then return end
                local isActiveMove = samePressInput(i, activePressInput)
                        or (activePressInput and activePressInput.UserInputType == Enum.UserInputType.MouseButton1
                                and i.UserInputType == Enum.UserInputType.MouseMovement)
                if not isActiveMove then return end
                touch()
                local sw = XC.sw
                if sw and pressed and i and i.Position then
                        local dx, dy = i.Position.X - sw.x, i.Position.Y - sw.y
                        if (math.abs(dx) >= 10 or math.abs(dy) >= 10) and not mainPressMoved then
                                mainPressMoved = true
                                mainHoldToken = mainHoldToken + 1
                        end
                        if os.clock() - sw.t > 0.35 then
                                XC.sw = nil
                        elseif dy >= 22 and math.abs(dx) < 0.6 * dy then
                                XC.sw = nil
                                if XC.swipe and XC.swipe() then
                                        pressed, held, activePressInput = false, true, nil
                                        sp.Press:to(1, SPR.Press)
                                end
                        end
                end
        end
        local function hitEnded(i)
                if not isPress(i) or not pressed or not samePressInput(i, activePressInput) then
                        return
                end
                mainHoldToken = mainHoldToken + 1
                touch()
                pressed, activePressInput = false, nil
                mainPressMoved = false
                sp.Press:to(1, SPR.Press)
                if held then
                        held = false
                        return
                end
                if current and current.hold then
                        dismissJob(current)
                elseif current and current.isLive then
                        current.token = (current.token or 0) + 1
                        current.dur, current.hold, current.sticky, current.autoCollapse = nil, true, true, true
                elseif not current and live then
                        expandLive()
                elseif not current then
                        sp.Press:to(1.04, SPR.Press)
                        task.delay(0.12, function()
                                if not destroyed then
                                        sp.Press:to(1, SPR.Press)
                                end
                        end)
                        if not windowOpen and window.Open then
                                window.__BubbleOpen = true
                                pcall(window.Open, window)
                                window.__BubbleOpen = nil
                        elseif DIM.On and DIM.Overview then
                                openOverview("home")
                        else
                                openPanel()
                        end
                end
        end
        for _, hb in ipairs({ hit, hitPad }) do
                hb.InputBegan:Connect(hitBegan)
                hb.InputChanged:Connect(hitChanged)
                hb.InputEnded:Connect(hitEnded)
        end
        holdInputConnections[#holdInputConnections + 1] = UserInputService.InputEnded:Connect(hitEnded)
        if UserInputService.WindowFocusReleased then
                holdInputConnections[#holdInputConnections + 1] = UserInputService.WindowFocusReleased:Connect(resetPressState)
        end
        -- [QM-BUB] P83 nhan 1 cai: generic menu glyph opens the UI; no branded logo image is used.
        local function bubbleTap()
                if destroyed then
                        return
                end
                local sk = DIM.On and DIM.skin or nil
                if sk and window.Closed ~= true then
                        if sk.kind == "result" then
                                DIM.result = nil
                        elseif lives[sk.kind] then
                                DIM.PromoteLive(sk.kind)
                        elseif DIM.Promote then
                                pcall(DIM.Promote, sk)
                        end
                        return
                end
                if window.Open then
                        window.__BubbleOpen = true
                        pcall(window.Open, window)
                        window.__BubbleOpen = nil
                end
        end
        for _, bb in ipairs({ bubble, bubblePad }) do
                bb.InputBegan:Connect(function(i)
                        if isPress(i) then
                                sp.BPress:to(0.88, SPR.Press)
                                DIM.downAt = os.clock()
                        end
                end)
                bb.InputEnded:Connect(function(i)
                        if isPress(i) then
                                sp.BPress:to(1, SPR.Press)
                        end
                end)
                bb.Activated:Connect(bubbleTap)
        end
        local B = SPEC.Bubble
        local mism, wdAcc = 0, 0
        local driver
        local onFrame
        local function alwaysOn()
                local f = _G.FARMX
                return f ~= nil and f.Enable ~= nil and f.Enable.IslandTween == false
        end
        function Island.BCOn()
                local f = _G.FARMX
                return f ~= nil and f.Enable ~= nil and f.Enable.BCCore == true and f.Enable.BCIsland == true and Creator ~= nil and Creator.BCAddTask ~= nil
        end
        local function wake()
                if destroyed or driver then
                        return
                end
                if Island.BCOn() then
                        local rm
                        rm = Creator.BCAddTask(function(dt)
                                if destroyed or not Island.BCOn() then
                                        rm()
                                        if driver and driver.bc then
                                                driver = nil
                                                if not destroyed then
                                                        Island.Wake()
                                                end
                                        end
                                        return
                                end
                                onFrame(dt)
                        end)
                        driver = { bc = true, Disconnect = function() rm() end }
                        Creator.BCOffAdd(Island.BCOff)
                        return
                end
                driver = RunService.RenderStepped:Connect(function(dt)
                        onFrame(dt)
                end)
        end
        local function sleep()
                if driver then
                        driver:Disconnect()
                        driver = nil
                end
        end
        Island.Wake = wake
        function Island.BCOff()
                if driver and driver.bc then
                        driver.Disconnect()
                        driver = nil
                        if not destroyed then
                                wake()
                        end
                end
        end
        local function springsRest()
                for _, s in pairs(sp) do
                        local tol = 0.0005 * math.max(1, math.abs(s.t))
                        if math.abs(s.x - s.t) > tol or math.abs(s.v) > tol * 2 then
                                return false
                        end
                end
                return true
        end
        local function viewSmooth()
                local cv = currentView
                local f = cv and cv.Smooth
                if f then
                        local ok, r = pcall(f)
                        return ok and r == true
                end
                return false
        end
        local function serviceStep(dt, doTick)
                wdAcc = wdAcc + dt
                if wdAcc >= 0.1 then
                        local closed = window.Closed == true
                        if closed == windowOpen then
                                mism = mism + wdAcc
                                if mism > 0.4 then
                                        mism = 0
                                        setWindowOpen(not closed)
                                end
                        else
                                mism = 0
                        end
                        wdAcc = 0
                        pcall(DIM.Tick)
                end
                local cj = current
                if cj and cj.autoCollapse then
                        if pointerInside() then
                                touch()
                        end
                        if os.clock() - lastTouch >= cfg.CollapseAfter and not (cj.view and cj.view.dragging) then
                                dismissJob(cj)
                        end
                end
                if doTick and currentView then
                        local t = currentView.Tick
                        if t then
                                t(dt)
                        end
                end
        end
        onFrame = function(dt)
                if destroyed then
                        return
                end
                local legacy = alwaysOn()
                if legacy then
                        fpsAcc, fpsN = fpsAcc + dt, fpsN + 1
                        if fpsAcc >= 0.5 then
                                fpsVal = fpsN / fpsAcc
                                fpsAcc, fpsN = 0, 0
                        end
                end
                dt = math.min(dt, 1 / 20)
                if legacy then
                        serviceStep(dt, false)
                end
                for _, s in pairs(sp) do
                        s:step(dt)
                end
                local settle = false
                if not legacy and springsRest() and not viewSmooth() then
                        for _, s in pairs(sp) do
                                s.x, s.v = s.t, 0
                        end
                        settle = true
                end
                local W, H, R = math.max(sp.W.x, 1), math.max(sp.H.x, 1), math.max(sp.R.x, 0)
                local cv = 0
                local Wv = math.max(W - cv, 1)
                do
                        -- [QM-ISL] P76 IslandIOS thu island mo rong ~0.84 (giong 18 Pro Max)
                        local en74 = _G.FARMX and _G.FARMX.Enable
                        local kx = 1
                        if not (en74 and en74.IslandIOS == false) then
                                kx = 1 - 0.16 * math.clamp((W - 200) / 140, 0, 1)
                        end
                        if Island._base74 and math.abs((Island._k74 or 1) - kx) > 0.002 then
                                Island._k74 = kx
                        end
                        if Island._base74 then
                                local shellScale = Island._lxShellOpen and (Island._lxShellScale or 1) or 1
                                local targetScale = Island._base74 * kx * shellScale
                                if math.abs(uiScale.Scale - targetScale) > 0.002 then
                                        uiScale.Scale = targetScale
                                        root.Position = U2(0.5, 0, 0, cfg.Top * targetScale)
                                end
                        end
                end
                -- [QM-BUB] P83 island dich sang trai nua (bong bong + khe), giu ca cum o giua nhu boncuti
                local ox = -(SPEC.Bubble.D + SPEC.Bubble.Gap) / 2 * math.clamp(sp.Bubble.x, 0, 1)
                island.Size = UDim2.fromOffset(Wv, H)
                island.Position = UDim2.fromOffset(ox, 0)
                local cvw = currentView
                if cvw and compactNow and cvw.W and cvw.frame then
                        local nw = math.max(cvw.W - cv, 20)
                        if math.abs(cvw.frame.Size.X.Offset - nw) > 0.05 then
                                cvw.frame.Size = UDim2.fromOffset(nw, cvw.H or SPEC.PillH)
                        end
                end
                islandCorner.CornerRadius = UD(0, R)
                islandScale.Scale = sp.Press.x
                if GLOW.on then
                        for gi = 1, #GLOW.pads do
                                local pd = GLOW.pads[gi]
                                GLOW.frames[gi].Size = UDim2.fromOffset(Wv + pd * 2, H + pd * 2)
                                GLOW.frames[gi].Position = UDim2.fromOffset(ox, -pd)
                                GLOW.corners[gi].CornerRadius = UD(0, R + pd)
                        end
                end
                ringHolder.Size = UDim2.fromOffset(Wv, H)
                ringHolder.Position = UDim2.fromOffset(ox, 0)
                ringScale.Scale = sp.Press.x
                if ring.visible then
                        if ring.source then
                                local rv = math.clamp(ring.source(), 0, 1)
                                if math.abs(rv - ring.progress) > 0.0002 then
                                        ring.progress = rv
                                        ring.dirty = true
                                end
                        end
                        if ring.dirty then
                                ringUpdate()
                        end
                end
                local p = sp.Bubble.x
                local xr = Wv / 2 + ox
                local cy = SPEC.Idle.H / 2
                local D = B.D
                local pop = math.max(p, 0)
                -- [QM-BUB] P83 bong bong lon dan tu mep island + vot nhe (spring 240/14), khong con co cat/co gian
                local c = xr + (B.Gap + D / 2) * math.min(pop, 1.1)
                local visible = pop > 0.012 or math.abs(sp.Bubble.v) > 0.01
                bubble.Visible = visible
                bubble.Size = UDim2.fromOffset(D, D)
                bubble.Position = UDim2.fromOffset(c, cy)
                bubbleScale.Scale = math.max(sp.BPress.x * pop, 0.01)
                local vis = math.clamp((p - 0.45) / 0.45, 0, 1)
                local actOn = DIM.On and DIM.skin ~= nil
                bubbleIcon.ImageTransparency = actOn and 1 or (1 - vis)
                if bubbleFallback then
                        bubbleFallback.Visible = (not actOn) and vis > 0.2
                end
                bubbleAct.ImageTransparency = (actOn and bubbleAct.Visible) and (1 - vis) or 1
                bubbleActText.TextTransparency = (actOn and bubbleActText.Visible) and (1 - vis) or 1
                bubbleRing.Transparency = actOn and (1 - vis) or 1
                neck.Visible = false
                hitPad.Size = UDim2.fromOffset(Wv + HITPAD * 2, H + HITPAD * 2)
                hitPad.Position = UDim2.fromOffset(ox, -HITPAD)
                if currentView then
                        local t = currentView.Tick
                        if t then
                                t(dt)
                        end
                end
                if settle then
                        sleep()
                end
        end
        task.spawn(function()
                local last = os.clock()
                local fpsT = last
                while not destroyed do
                        task.wait(0.1)
                        if destroyed then
                                break
                        end
                        local now = os.clock()
                        local dt = now - last
                        last = now
                        if alwaysOn() then
                                wake()
                        else
                                serviceStep(dt, driver == nil)
                                if now - fpsT >= 0.5 then
                                        fpsT = now
                                        local d1 = RunService.RenderStepped:Wait()
                                        if d1 > 0 then
                                                fpsVal = fpsVal * 0.5 + (1 / d1) * 0.5
                                        end
                                end
                                if not driver and (not springsRest() or viewSmooth()) then
                                        wake()
                                end
                        end
                end
        end)
        wake()
        function Island:Notify(d)
                d = d or {}
                if Island.BCToastOn and Island.BCToastOn() then
                        return Island.BCToastPush("info", d, true)
                end
                local dur = d.Duration or cfg.DefaultDuration
                local hasContent = d.Content ~= nil and tostring(d.Content) ~= ""
                local hasValue = d.Value ~= nil and tostring(d.Value) ~= ""
                if d.Style == "Pill" or not (hasContent or hasValue) then
                        return enqueue(pillJob({ Icon = d.Icon, Text = d.Title or d.Content or "", Color = d.Color }, dur))
                end
                return enqueue(wideJob(d, dur))
        end
        function Island:Status(d)
                d = d or {}
                return enqueue(pillJob({
                        Icon = d.Icon, Text = d.Text or d.Title or "", Right = d.Right, Color = d.Color,
                }, d.Duration or cfg.DefaultDuration))
        end
        function Island:Progress(d)
                d = d or {}
                local data = { Text = d.Title or "Progress", Value = d.Value or 0, Right = d.Right, Color = d.Color, Icon = d.Icon }
                local job = pillJob(data, d.Duration)
                job.sticky = true
                local function refresh()
                        if current == job and job.view then
                                local W = job.view.Set(job.data)
                                compactNow = W <= 300
                                setSize(W, SPEC.PillH, SPEC.Idle.R)
                                refreshBubble()
                        end
                end
                enqueue(job)
                local h = {}
                function h:Set(value, text, color)
                        if value ~= nil then
                                data.Value = value
                        end
                        if text then
                                data.Text = text
                        end
                        if color then
                                data.Color = color
                        end
                        refresh()
                end
                function h:Done(text)
                        data.Value = 1
                        data.Text = text or data.Text
                        data.Color = C.Green
                        refresh()
                        task.delay(1.2, function()
                                dismissJob(job)
                        end)
                end
                function h:Close()
                        dismissJob(job)
                end
                return h
        end
        local function liveHandle(kind)
                local h = {}
                function h:Set(t)
                        local lv = lives[kind]
                        if not lv then
                                return
                        end
                        for k, v in pairs(t or {}) do
                                lv.data[k] = v
                        end
                        refreshLive(lv)
                end
                function h:Expand(sec)
                        local lv = lives[kind]
                        if not lv then
                                return
                        end
                        if current and current.live == lv then
                                touch()
                                return
                        end
                        enqueue(liveJob(lv, true, sec))
                end
                function h:Stop()
                        local lv = lives[kind]
                        if lv then
                                removeLive(lv)
                        end
                end
                function h:Active()
                        return lives[kind] ~= nil
                end
                return h
        end
        local function openLive(kind, d, intro)
                d = d or {}
                local lv = lives[kind]
                local fresh = lv == nil
                local newTarget = (not fresh) and (tostring(lv.data.Title) ~= tostring(d.Title))
                if fresh then
                        lv = { kind = kind, data = {} }
                        lives[kind] = lv
                end
                for k, v in pairs(d) do
                        lv.data[k] = v
                end
                pickLive()
                if intro ~= false and (fresh or newTarget) then
                        if current and current.isLive and current.live ~= lv then
                                current = nil
                        end
                        if current and current.live == lv then
                                refreshLive(lv)
                        else
                                enqueue(liveJob(lv, true))
                        end
                else
                        refreshLive(lv)
                        if not current then
                                goIdle()
                        end
                end
                return liveHandle(kind)
        end
        function Island:Detect(d)
                return openLive("track", d, d and d.Intro)
        end
        function Island:Farm(d)
                return openLive("farm", d, d and d.Intro)
        end
        function Island:Finish(d)
                d = d or {}
                local job = { kind = "result", data = d, urgent = true, dur = d.Duration or 2.6 }
                job.start = function(j)
                        local v = getView("result", buildResult)
                        v.Set(j.data)
                        j.view = v
                        present(v, SPEC.Result.W, SPEC.Result.H, SPEC.Result.R, {})
                end
                return enqueue(job)
        end
        function Island:FormatNumber(n)
                n = tonumber(n) or 0
                local a = math.abs(n)
                if a >= 1e9 then
                        return string.format("%.1fB", n / 1e9)
                elseif a >= 1e6 then
                        return string.format("%.1fM", n / 1e6)
                elseif a >= 1e3 then
                        return string.format("%.1fK", n / 1e3)
                end
                return tostring(math.floor(n + 0.5))
        end
        function Island:Media(d)
                d = d or {}
                local data = {
                        Title = d.Title, Artist = d.Artist, Cover = d.Cover, Playing = d.Playing == true,
                        Position = d.Position, Length = d.Length, Progress = d.Progress,
                        OnPlay = d.OnPlay, OnPrev = d.OnPrev, OnNext = d.OnNext,
                }
                local lv = { kind = "media", data = data }
                lives.media = lv
                pickLive()
                local mv = getView("media", buildMedia)
                if not mv.wired then
                        mv.wired = true
                        mv.Play.Activated:Connect(function()
                                touch()
                                local dd = mv.data
                                if not dd then
                                        return
                                end
                                dd.Playing = not dd.Playing
                                mv.Set(dd)
                                if dd.OnPlay then
                                        task.spawn(pcall, dd.OnPlay, dd.Playing)
                                end
                        end)
                        mv.Prev.Activated:Connect(function()
                                touch()
                                local dd = mv.data
                                if dd and dd.OnPrev then
                                        task.spawn(pcall, dd.OnPrev)
                                end
                        end)
                        mv.Next.Activated:Connect(function()
                                touch()
                                local dd = mv.data
                                if dd and dd.OnNext then
                                        task.spawn(pcall, dd.OnNext)
                                end
                        end)
                        mv.Collapse.Activated:Connect(function()
                                if current and current.live and current.live.kind == "media" then
                                        dismissJob(current)
                                end
                        end)
                end
                if current and current.isLive then
                        current = nil
                end
                enqueue(liveJob(lv, true, cfg.DefaultDuration))
                local h = {}
                function h:Set(t)
                        for k, v in pairs(t or {}) do
                                data[k] = v
                        end
                        if mv.data == data then
                                mv.Set(data)
                        end
                        if currentView == views.live and live == lv then
                                views.live.Set()
                        end
                end
                function h:Stop()
                        if lives.media == lv then
                                removeLive(lv)
                        end
                end
                return h
        end
        function Island:Verify(d)
                d = d or {}
                local job = { kind = "verify", data = d, sticky = true, dur = d.Duration }
                job.start = function()
                        local v = getView("verify", buildVerify)
                        v.Set("loading")
                        present(v, SPEC.Square.W, SPEC.Square.H, SPEC.Square.R, {})
                end
                enqueue(job)
                local h = {}
                local function finish(state)
                        local v = views.verify
                        if v and current == job then
                                v.Set(state)
                        end
                        task.delay(1.4, function()
                                dismissJob(job)
                        end)
                end
                function h:Success()
                        finish("success")
                end
                function h:Fail()
                        finish("error")
                end
                function h:Close()
                        dismissJob(job)
                end
                return h
        end
        function Island:Dismiss()
                if current then
                        dismissJob(current)
                end
        end
        function Island:SetScale(s)
                cfg.Scale = s
                fit()
        end
        function Island:Refit()
                fit()
        end
        function Island:GetBubbleCenter()
                local sc = uiScale.Scale
                local ap0 = root.AbsolutePosition
                local c = sp.W.t / 2 + SPEC.Bubble.Gap / 2
                return V2(ap0.X + c * sc, ap0.Y + (SPEC.Idle.H / 2) * sc)
        end
        function Island:SetTop(y)
                cfg.Top = y
                fit()
        end
        function Island:SetVisible(b)
                gui.Enabled = b ~= false
        end
        do
                local pv = getView("panel", buildPanel)
                pv.Toggle.Activated:Connect(function()
                        if window.Toggle then
                                window:Toggle()
                        end
                end)
                pv.Done.Activated:Connect(function()
                        if current and current.kind == "panel" then
                                dismissJob(current)
                        end
                end)
        end
        local STC = { red = C.StRed, yellow = C.StYellow, green = C.StGreen }
        function Island.BCToastOn()
                local f = _G.FARMX
                return f ~= nil and f.Enable ~= nil and f.Enable.BCToast == true and not destroyed and current ~= nil and sp.H.t >= 120
        end
        Island.BCToastQ = {}
        function Island.BCToastBuild()
                if Island.BCToastUI then
                        return Island.BCToastUI
                end
                local T = {}
                T.root = new("TextButton", {
                        Name = "WABCToast", AutoButtonColor = false, Text = "", BackgroundColor3 = Color3.fromRGB(34, 34, 40),
                        AnchorPoint = V2(0.5, 0), Position = U2(0.5, 0, 0, -70), Size = U2(1, -20, 0, 46), Visible = false, ZIndex = 30, Parent = island,
                })
                corner(T.root, 16)
                new("UIStroke", { Thickness = 1, Color = C.White, Transparency = 0.82, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = T.root })
                T.disc = frame({ BackgroundColor3 = C.Blue, AnchorPoint = V2(0, 0.5), Position = U2(0, 10, 0.5, 0), Size = UDim2.fromOffset(28, 28), ZIndex = 31, Parent = T.root })
                corner(T.disc)
                T.ds = new("UIScale", { Scale = 1, Parent = T.disc })
                T.img = new("ImageLabel", {
                        BackgroundTransparency = 1, AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(16, 16),
                        ImageColor3 = Color3.fromRGB(12, 12, 16), ZIndex = 32, Parent = T.disc,
                })
                T.title = label(T.root, {
                        Font = FONTB, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                        AnchorPoint = V2(0, 0.5), Position = U2(0, 48, 0.5, 0), Size = U2(1, -60, 0, 18), ZIndex = 31, Text = "",
                })
                T.desc = label(T.root, {
                        Font = FONT, TextSize = 11, TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                        AnchorPoint = V2(0, 0.5), Position = U2(0, 48, 0.5, 9), Size = U2(1, -60, 0, 14), ZIndex = 31, Text = "", Visible = false,
                })
                T.bar = frame({ BackgroundColor3 = C.White, BackgroundTransparency = 0.2, AnchorPoint = V2(0.5, 1), Position = U2(0.5, 0, 1, -2), Size = U2(1, -32, 0, 2), ZIndex = 31, Parent = T.root })
                corner(T.bar)
                T.root.Activated:Connect(function()
                        Island.BCToastSkip = true
                end)
                Island.BCToastUI = T
                return T
        end
        function Island.BCToastRun()
                if Island.BCToastBusy then
                        return
                end
                Island.BCToastBusy = true
                task.spawn(function()
                        local T = Island.BCToastBuild()
                        while #Island.BCToastQ > 0 and Island.BCToastOn() do
                                local it = table.remove(Island.BCToastQ, 1)
                                local col = STC[it.level] or C.Blue
                                T.disc.BackgroundColor3, T.bar.BackgroundColor3 = col, col
                                local ic = ({ red = "x", yellow = "triangle-alert", green = "check" })[it.level] or "info"
                                local okI = false
                                pcall(function()
                                        okI = applyIcon(T.img, ic, Creator) and true or false
                                end)
                                T.img.Visible = okI
                                T.img.ImageColor3 = Color3.fromRGB(12, 12, 16)
                                local two = it.desc ~= nil and tostring(it.desc) ~= "" and tostring(it.desc) ~= it.title
                                T.title.Text = it.title
                                T.desc.Text = two and tostring(it.desc) or ""
                                T.desc.Visible = two
                                T.title.Position = U2(0, 48, 0.5, two and -8 or 0)
                                T.root.Position = U2(0.5, 0, 0, -70)
                                T.root.Visible = true
                                T.ds.Scale = 0.3
                                tw(T.root, 0.4, { Position = U2(0.5, 0, 0, 12) }, BACK, EOUT)
                                tw(T.ds, 0.5, { Scale = 1 }, BACK, EOUT)
                                local hold = math.clamp(tonumber(it.dur) or 2.6, 1.8, 4)
                                T.bar.Size = U2(1, -32, 0, 2)
                                tw(T.bar, hold, { Size = U2(0, 0, 0, 2) }, Enum.EasingStyle.Linear, EOUT)
                                Island.BCToastSkip = false
                                local t0 = os.clock()
                                while not destroyed and Island.BCToastOn() and not Island.BCToastSkip and os.clock() - t0 < hold do
                                        task.wait(0.05)
                                end
                                tw(T.root, 0.26, { Position = U2(0.5, 0, 0, -70) }, Enum.EasingStyle.Quint, EIN)
                                task.wait(0.28)
                                T.root.Visible = false
                        end
                        Island.BCToastBusy = false
                        if not destroyed and #Island.BCToastQ > 0 then
                                local rest = Island.BCToastQ
                                Island.BCToastQ = {}
                                for _, it in ipairs(rest) do
                                        pcall(function()
                                                if it.notify then
                                                        Island:Notify(it.d)
                                                else
                                                        Island:StatusPill(it.level, it.d)
                                                end
                                        end)
                                end
                        end
                end)
        end
        function Island.BCToastPush(level, d, isNotify)
                local q = Island.BCToastQ
                if #q >= 3 then
                        table.remove(q, 1)
                end
                q[#q + 1] = {
                        level = level, d = d, notify = isNotify, title = tostring(d.Text or d.Title or d.Content or ""),
                        desc = d.Description or ((isNotify and d.Title and d.Content) and d.Content or nil), dur = d.Duration,
                }
                Island.BCToastRun()
        end
        local SP = { tok = 0, shown = false, level = nil, text = nil, card = false, tweens = {}, title = nil, desc = nil, icon = nil, lastTouch = 0 }
        local stH = SPEC.PillH
        local stLm, stDot, stGap, stRm = stH * 0.4, stH * 0.31, stH * 0.33, stH * 0.5
        local stMinW = stH * 1.35
        local sPill = frame({
                Name = "StatusPill", BackgroundColor3 = C.Black, AnchorPoint = V2(0.5, 0), Position = UDim2.fromOffset(0, SPEC.Idle.H + 8),
                Size = UDim2.fromOffset(stMinW, stH), ClipsDescendants = true, Visible = false, ZIndex = 1, Parent = root,
        })
        local sCorner = corner(sPill, stH / 2)
        local sHalo = frame({
                Name = "Halo", BackgroundColor3 = C.StGreen, BackgroundTransparency = 0.65, AnchorPoint = V2(0.5, 0.5),
                Position = UDim2.fromOffset(stLm + stDot / 2, stH / 2), Size = UDim2.fromOffset(stH * 0.45, stH * 0.45), ZIndex = 1, Parent = sPill,
        })
        corner(sHalo)
        local sDot = frame({
                Name = "Dot", BackgroundColor3 = C.StGreen, AnchorPoint = V2(0.5, 0.5),
                Position = UDim2.fromOffset(stLm + stDot / 2, stH / 2), Size = UDim2.fromOffset(stDot, stDot), ZIndex = 2, Parent = sPill,
        })
        corner(sDot)
        local sText = label(sPill, {
                Name = "Text", Font = FONTB, TextSize = math.floor(stH * 0.40), TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(stLm + stDot + stGap, stH / 2), Size = UDim2.fromOffset(40, stH), Text = "", ZIndex = 2,
        })
        local sIcon = new("ImageLabel", {
                Name = "CardIcon", BackgroundTransparency = 1, AnchorPoint = V2(0, 0.5), Position = UDim2.fromOffset(stLm, stH * 1.7),
                Size = UDim2.fromOffset(stH * 1.2, stH * 1.2), ImageTransparency = 1, Visible = false, ZIndex = 2, Parent = sPill,
        })
        local sTitle = label(sPill, {
                Name = "CardTitle", Font = FONTB, TextSize = math.floor(stH * 0.45), TextColor3 = C.White, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.fromOffset(stLm + stH * 1.2 + stGap, stH * 0.35),
                Size = UDim2.fromOffset(200, stH * 0.6), Text = "", TextTransparency = 1, Visible = false, ZIndex = 2,
        })
        local sDesc = label(sPill, {
                Name = "CardDesc", Font = FONT, TextSize = math.floor(stH * 0.30), TextColor3 = C.Sub, TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.fromOffset(stLm + stH * 1.2 + stGap, stH * 0.95), Size = UDim2.fromOffset(200, stH * 0.30 * 3 * 1.25),
                Text = "", TextTransparency = 1, Visible = false, ZIndex = 2,
        })
        local sHit = new("TextButton", {
                Name = "StatusHit", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), ZIndex = 3, Parent = sPill,
        })
        local function spCancel()
                SP.tok = SP.tok + 1
                for _, t in ipairs(SP.tweens) do
                        pcall(function()
                                t:Cancel()
                        end)
                end
                SP.tweens = {}
                return SP.tok
        end
        local function spTw(o, t, props, style, dir)
                local tween = tw(o, t, props, style, dir)
                SP.tweens[#SP.tweens + 1] = tween
                return tween
        end
        local function spMaxW()
                local cam = workspace.CurrentCamera
                local vpx = cam and cam.ViewportSize.X or 1920
                return math.max(stMinW, math.min(330, (vpx * 0.9) / math.max(uiScale.Scale, 0.1)))
        end
        local function spPillW(text)
                return math.clamp(stLm + stDot + stGap + textW(text, sText.TextSize, FONTB) + stRm, stMinW, spMaxW())
        end
        local function spTextW(text)
                return math.min(textW(text, sText.TextSize, FONTB) + 4, spMaxW() - (stLm + stDot + stGap + stRm))
        end
        local function spPillContent(t, dur)
                spTw(sDot, dur, { BackgroundTransparency = t }, QUAD, EOUT)
                spTw(sHalo, dur, { BackgroundTransparency = t == 0 and 0.65 or 1 }, QUAD, EOUT)
                spTw(sText, dur, { TextTransparency = t }, QUAD, EOUT)
        end
        local function spCardContent(show, dur)
                sIcon.Visible, sTitle.Visible, sDesc.Visible = true, true, true
                local t = show and 0 or 1
                spTw(sIcon, dur, { ImageTransparency = t }, QUAD, EOUT)
                spTw(sTitle, dur, { TextTransparency = t }, QUAD, EOUT)
                spTw(sDesc, dur, { TextTransparency = t }, QUAD, EOUT)
        end
        local function spHideCard()
                sIcon.Visible, sTitle.Visible, sDesc.Visible = false, false, false
                sIcon.ImageTransparency, sTitle.TextTransparency, sDesc.TextTransparency = 1, 1, 1
        end
        local function spCollapseCard(tok)
                if not SP.card then
                        return
                end
                SP.card = false
                spCardContent(false, 0.15)
                task.wait(0.15)
                if SP.tok ~= tok or destroyed then
                        return
                end
                spTw(sPill, 0.2, { Size = UDim2.fromOffset(spPillW(SP.text or ""), stH) }, Enum.EasingStyle.Quint, EOUT)
                spTw(sCorner, 0.2, { CornerRadius = UD(0, stH / 2) }, Enum.EasingStyle.Quint, EOUT)
                task.wait(0.2)
                if SP.tok ~= tok or destroyed then
                        return
                end
                spHideCard()
                spPillContent(0, 0.25)
        end
        local function spExpandCard()
                if SP.card or not SP.shown or not (SP.title or SP.desc) then
                        return
                end
                local tok = spCancel()
                SP.card = true
                SP.lastTouch = os.clock()
                task.spawn(function()
                        spPillContent(1, 0.1)
                        task.wait(0.1)
                        if SP.tok ~= tok or destroyed then
                                return
                        end
                        local W = math.min(stH * 10.8, spMaxW() + 80)
                        sTitle.Text, sDesc.Text = tostring(SP.title or SP.text or ""), tostring(SP.desc or "")
                        sTitle.Size = UDim2.fromOffset(W - (stLm + stH * 1.2 + stGap) - stLm, stH * 0.6)
                        sDesc.Size = UDim2.fromOffset(W - (stLm + stH * 1.2 + stGap) - stLm, stH * 0.30 * 3 * 1.25)
                        sIcon.Visible = false
                        local okI = false
                        if SP.icon then
                                okI = applyIcon(sIcon, SP.icon, Creator) and true or false
                        end
                        sIcon.Visible = okI
                        spTw(sPill, 0.28, { Size = UDim2.fromOffset(W, stH * 3.4) }, Enum.EasingStyle.Quint, EOUT)
                        spTw(sCorner, 0.28, { CornerRadius = UD(0, stH * 0.75) }, Enum.EasingStyle.Quint, EOUT)
                        task.wait(0.28)
                        if SP.tok ~= tok or destroyed then
                                return
                        end
                        spCardContent(true, 0.2)
                        task.spawn(function()
                                while SP.tok == tok and SP.card and not destroyed do
                                        task.wait(0.25)
                                        if os.clock() - SP.lastTouch >= cfg.CollapseAfter then
                                                if SP.tok == tok and SP.card then
                                                        local t2 = spCancel()
                                                        spCollapseCard(t2)
                                                end
                                                break
                                        end
                                end
                        end)
                end)
        end
        local sPressed, sHeld, sPressTok = false, false, 0
        sHit.InputBegan:Connect(function(i)
                if not isPress(i) then
                        return
                end
                SP.lastTouch = os.clock()
                sPressed, sHeld = true, false
                sPressTok = sPressTok + 1
                local pt = sPressTok
                task.delay(cfg.HoldTime, function()
                        if sPressed and sPressTok == pt and not destroyed then
                                sHeld = true
                                spExpandCard()
                        end
                end)
        end)
        sHit.InputEnded:Connect(function(i)
                if not isPress(i) then
                        return
                end
                sPressed = false
                if sHeld then
                        sHeld = false
                        return
                end
                if SP.card then
                        local t2 = spCancel()
                        task.spawn(spCollapseCard, t2)
                else
                        spExpandCard()
                end
        end)
        SP.drain = function(minRank)
                local q = SP.queue
                if not q or #q == 0 or destroyed then
                        return
                end
                local bi
                for i = 1, #q do
                        if q[i].rank >= (minRank or 0) and (not bi or q[i].rank > q[bi].rank) then
                                bi = i
                        end
                end
                if not bi then
                        return
                end
                local nxt = table.remove(q, bi)
                task.defer(function()
                        if not destroyed then
                                Island:StatusPill(nxt.level, nxt.d)
                        end
                end)
        end
        function Island:StatusPill(level, d)
                if destroyed then
                        return
                end
                d = d or {}
                local rank = ({ red = 3, yellow = 2, green = 1 })[level] or 1
                local fxd = _G.FARMX
                if fxd and fxd.Enable.DotArbiter and d.Duration and not d.Keep and d.Duration > fxd.Cfg.DotHold then
                        local d2 = {}
                        for k, v in pairs(d) do
                                d2[k] = v
                        end
                        d2.Duration = fxd.Cfg.DotHold
                        d = d2
                end
                if fxd and fxd.Enable.DotArbiter and SP.shown and SP.rank and os.clock() < (SP.expire or 0) then
                        local nowA = os.clock()
                        local lower = rank < SP.rank
                        local tooSoon = rank == SP.rank and nowA < (SP.minUntil or 0)
                        if lower or tooSoon then
                                local qtext = tostring(d.Text or d.Title or "")
                                SP.queue = SP.queue or {}
                                for i = #SP.queue, 1, -1 do
                                        if SP.queue[i].level == level and SP.queue[i].text == qtext then
                                                table.remove(SP.queue, i)
                                        end
                                end
                                SP.queue[#SP.queue + 1] = { level = level, d = d, rank = rank, text = qtext }
                                if #SP.queue > 5 then
                                        table.remove(SP.queue, 1)
                                end
                                if tooSoon then
                                        SP.qtk = (SP.qtk or 0) + 1
                                        local qtk = SP.qtk
                                        task.delay(math.max((SP.minUntil or 0) - nowA, 0) + 0.02, function()
                                                if SP.qtk == qtk and SP.shown and not destroyed then
                                                        SP.drain(SP.rank)
                                                end
                                        end)
                                end
                                return
                        end
                end
                if fxd and fxd.Enable.DotNative then
                        local nowN = os.clock()
                        local jobN = pillJob({ Dot = STC[level] or STC.green, Kind = level, Text = tostring(d.Text or d.Title or ""), Sub = d.Description }, d.Duration)
                        jobN.urgent = rank >= 2
                        jobN.isDot = true
                        jobN.onEnd = function()
                                if SP.job == jobN then
                                        SP.job, SP.shown, SP.rank, SP.expire = nil, false, nil, 0
                                        if SP.drain then
                                                SP.drain(0)
                                        end
                                end
                        end
                        SP.job, SP.shown, SP.rank, SP.level = jobN, true, rank, level
                        SP.expire = d.Duration and (nowN + d.Duration) or math.huge
                        SP.minUntil = nowN + (fxd.Cfg.DotMinShow or 0.6)
                        enqueue(jobN)
                        return
                end
                local text = tostring(d.Text or d.Title or "")
                local col = STC[level] or STC.green
                local first = not SP.shown
                local wasCard = SP.card
                local tok = spCancel()
                SP.rank = rank
                SP.expire = d.Duration and (os.clock() + d.Duration) or math.huge
                SP.minUntil = os.clock() + ((fxd and fxd.Cfg.DotMinShow) or 0.6)
                if SP.shown and SP.level and STC[SP.level] then
                        sDot.BackgroundColor3, sHalo.BackgroundColor3 = STC[SP.level], STC[SP.level]
                end
                local t0 = os.clock()
                SP.title, SP.desc, SP.icon = d.Title ~= d.Text and d.Title or nil, d.Description, d.Icon
                task.spawn(function()
                        local function alive()
                                return SP.tok == tok and not destroyed
                        end
                        local dii = _G.FARMX and _G.FARMX.Enable.DotInIsland
                        sPill.Position = UDim2.fromOffset(0, dii and 0 or (SPEC.Idle.H + 8))
                        sPill.ZIndex = dii and 6 or 1
                        sPill.Visible = true
                        if wasCard then
                                SP.card = false
                                spHideCard()
                                sCorner.CornerRadius = UD(0, stH / 2)
                                spPillContent(0, 0.01)
                        end
                        if first then
                                sDot.BackgroundColor3, sHalo.BackgroundColor3 = col, col
                                sText.Text = text
                                sText.Size = UDim2.fromOffset(spTextW(text), stH)
                                sPill.Size = UDim2.fromOffset(stMinW, stH)
                                SP.level, SP.text, SP.shown = level, text, true
                                spPillContent(0, 0.01)
                                spTw(sPill, 0.4, { Size = UDim2.fromOffset(spPillW(text), stH) }, Enum.EasingStyle.Quint, EOUT)
                                task.wait(0.4)
                        else
                                if SP.level ~= level then
                                        SP.level = level
                                        spTw(sDot, 0.22, { BackgroundColor3 = col }, QUAD, EOUT)
                                        spTw(sHalo, 0.22, { BackgroundColor3 = col }, QUAD, EOUT)
                                        task.wait(0.22)
                                        if not alive() then
                                                return
                                        end
                                end
                                if SP.text ~= text then
                                        spTw(sPill, 0.32, { Size = UDim2.fromOffset(stMinW, stH) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                                        task.wait(0.32)
                                        if not alive() then
                                                return
                                        end
                                        SP.text = text
                                        sText.Text = text
                                        sText.Size = UDim2.fromOffset(spTextW(text), stH)
                                        task.wait(0.08)
                                        if not alive() then
                                                return
                                        end
                                        spTw(sPill, 0.4, { Size = UDim2.fromOffset(spPillW(text), stH) }, Enum.EasingStyle.Quint, EOUT)
                                        task.wait(0.4)
                                else
                                        spTw(sPill, 0.2, { Size = UDim2.fromOffset(spPillW(text), stH) }, Enum.EasingStyle.Quint, EOUT)
                                end
                        end
                        if alive() and d.Duration then
                                task.delay(math.max(d.Duration - (os.clock() - t0), 0.05), function()
                                        if SP.tok == tok and not destroyed then
                                                Island:StatusStop()
                                        end
                                end)
                        end
                end)
        end
        function Island:StatusStop()
                if not SP.shown then
                        return
                end
                if SP.job then
                        local jb = SP.job
                        SP.job, SP.shown, SP.rank, SP.expire = nil, false, nil, 0
                        if current == jb then
                                dismissJob(jb)
                        else
                                removeQueued(jb)
                        end
                        if SP.drain then
                                SP.drain(0)
                        end
                        return
                end
                local tok = spCancel()
                SP.shown, SP.card, SP.level, SP.text = false, false, nil, nil
                SP.rank, SP.expire = nil, nil
                spPillContent(1, 0.2)
                spTw(sPill, 0.25, { Size = UDim2.fromOffset(stMinW, stH) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                task.delay(0.27, function()
                        if SP.tok == tok and not destroyed then
                                sPill.Visible = false
                                spHideCard()
                                sCorner.CornerRadius = UD(0, stH / 2)
                        end
                end)
                if SP.drain then
                        SP.drain(0)
                end
        end
        local oOpen, oClose, oDestroy = window.Open, window.Close, window.Destroy
        local oNotify = WindUI and WindUI.Notify
        window.IsOpenButtonEnabled = false
        pcall(function()
                if window.OpenButtonMain then
                        window.OpenButtonMain:Visible(false)
                end
        end)
        local bootT = os.clock()
        window.Open = function(self, ...)
                if not destroyed then
                        local fxo = _G.FARMX
                        local only = not (fxo and fxo.Enable and fxo.Enable.OnlyBubbleOpens == false)
                        if only and window.Closed == true and not window.__BubbleOpen and os.clock() - bootT > 4 then
                                return
                        end
                        setWindowOpen(true)
                end
                local r1 = oOpen(self, ...)
                if not destroyed and Creator and Creator.WAStackSide then
                        task.delay(0.12, function() pcall(Creator.WAStackSide, window) end)
                end
                return r1
        end
        window.Close = function(self, ...)
                if not destroyed then
                        setWindowOpen(false)
                end
                return oClose(self, ...)
        end
        window.Destroy = function(self, ...)
                Island:Destroy()
                return oDestroy(self, ...)
        end
        if WindUI and oNotify and cfg.ReplaceNotify then
                WindUI.Notify = function(self, nc)
                        nc = nc or {}
                        if destroyed or nc.Buttons or nc.Callback then
                                return oNotify(self, nc)
                        end
                        local ok = pcall(function()
                                Island:Notify({
                                        Title = nc.Title, Content = nc.Content, Icon = nc.Icon, Duration = nc.Duration,
                                        Value = nc.Value, Unit = nc.Unit,
                                })
                        end)
                        if not ok then
                                return oNotify(self, nc)
                        end
                        return { Close = function() end, Destroy = function() end }
                end
        end
        if WindUI then
                WindUI.NotifyRed = function(_, d)
                        if not destroyed then
                                Island:StatusPill("red", d)
                        end
                end
                WindUI.NotifyYellow = function(_, d)
                        if not destroyed then
                                Island:StatusPill("yellow", d)
                        end
                end
                WindUI.NotifyGreen = function(_, d)
                        if not destroyed then
                                Island:StatusPill("green", d)
                        end
                end
                WindUI.NotifyRedDot, WindUI.NotifyYellowDot, WindUI.NotifyGreenDot = WindUI.NotifyRed, WindUI.NotifyYellow, WindUI.NotifyGreen
                WindUI.NotifyDot = function(_, color, content, duration)
                        if destroyed then return end
                        local lvN = ({ g = "green", green = "green", y = "yellow", yellow = "yellow", r = "red", red = "red" })[string.lower(tostring(color))] or "green"
                        Island:StatusPill(lvN, { Text = tostring(content or ""), Duration = tonumber(duration) or cfg.DefaultDuration, Keep = true })
                end
        end
        local DIM_COL = ACT_COL
        local function dimTrace(code, a)
                local f = _G.FARMX
                if f and f.TraceAdd then
                        pcall(f.TraceAdd, code, tostring(a))
                end
        end
        local function dimMainColor()
                if SP.shown then
                        return DIM_COL[SP.level]
                end
                if current then
                        if current.kind == "result" then
                                return DIM_COL.result
                        end
                        if current.isLive and current.live then
                                return DIM_COL[current.live.kind]
                        end
                        return nil
                end
                if live then
                        return DIM_COL[live.kind]
                end
                return nil
        end
        function DIM.SetGlow(color)
                local want = DIM.On and DIM.Glow and color ~= nil
                if want then
                        if not GLOW.on then
                                GLOW.on = true
                                for gi = 1, #GLOW.pads do
                                        GLOW.frames[gi].Visible = true
                                end
                                rimStroke.Transparency = 0.65
                                if not GLOW.rimTween then
                                        GLOW.rimTween = TweenService:Create(rimGrad, TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), { Rotation = 360 })
                                end
                                GLOW.rimTween:Play()
                        end
                        if color ~= GLOW.color then
                                GLOW.color = color
                                for gi = 1, #GLOW.pads do
                                        TweenService:Create(GLOW.frames[gi], TweenInfo.new(color == ACT_COL.media and 0.7 or 0.35), { BackgroundColor3 = color, BackgroundTransparency = GLOW.trans[gi] }):Play()
                                end
                        end
                elseif GLOW.on then
                        GLOW.on, GLOW.color = false, nil
                        for gi = 1, #GLOW.pads do
                                GLOW.frames[gi].BackgroundTransparency = 1
                                GLOW.frames[gi].Visible = false
                        end
                        rimStroke.Transparency = 1
                        if GLOW.rimTween then
                                GLOW.rimTween:Cancel()
                        end
                end
        end
        do
                local base = ACT_COL.media
                task.spawn(function()
                        while not destroyed do
                                task.wait(0.5)
                                if destroyed then
                                        return
                                end
                                local en = _G.FARMX and _G.FARMX.Enable
                                local d = lives.media and lives.media.data
                                if d and d.Playing == true and not (en and en.IslandMusicRainbow == false) then
                                        ACT_COL.media = rainbowAt(os.clock(), 10, 2)
                                elseif ACT_COL.media ~= base then
                                        ACT_COL.media = base
                                end
                        end
                end)
        end
        function DIM.PromoteLive(kind)
                local lvT = lives[kind]
                if not lvT or destroyed then
                        return
                end
                if current and current.kind == "card" and current.view then
                        current.view.Go(({ media = "music", timer = "timer", stopwatch = "watch" })[kind] or "home")
                        return
                end
                if current and current.live == lvT then
                        touch()
                        return
                end
                if current and current.isLive then
                        current = nil
                end
                dimTrace("DIM_PROMOTE", kind)
                enqueue(liveJob(lvT, true, cfg.LiveIntro))
        end
        function DIM.Flash()
                if not GLOW.on then
                        return
                end
                task.spawn(function()
                        for _ = 1, 3 do
                                if destroyed then
                                        return
                                end
                                for gi = 1, #GLOW.pads do
                                        tw(GLOW.frames[gi], 0.125, { BackgroundTransparency = math.max(0.35, GLOW.trans[gi] - 0.25) })
                                end
                                task.wait(0.125)
                                for gi = 1, #GLOW.pads do
                                        tw(GLOW.frames[gi], 0.125, { BackgroundTransparency = GLOW.trans[gi] })
                                end
                                task.wait(0.125)
                        end
                end)
        end
        function DIM.Tick()
                if not DIM.On or destroyed then
                        for _, k in ipairs({ "timer", "stopwatch" }) do
                                if lives[k] then
                                        removeLive(lives[k])
                                end
                        end
                        if DIM.skin then
                                DIM.skin = nil
                                DIM.SetBubbleSkin(nil)
                                refreshBubble()
                        end
                        DIM.SetGlow(nil)
                        return
                end
                local now = os.clock()
                local okA, acts = pcall(function() return DIM.Acts and DIM.Acts() or {} end)
                if not okA or type(acts) ~= "table" then
                        acts = {}
                end
                local byKind = {}
                for _, a in ipairs(acts) do
                        byKind[a.kind] = a
                end
                for _, k in ipairs({ "timer", "stopwatch" }) do
                        if byKind[k] and not lives[k] then
                                lives[k] = { kind = k, data = {} }
                                refreshLive(lives[k])
                        elseif not byKind[k] and lives[k] then
                                removeLive(lives[k])
                        end
                end
                local mainKey
                if SP.shown then
                        mainKey = nil
                elseif current then
                        if current.kind == "card" then
                                mainKey = current.view and current.view.activeKind and current.view.activeKind() or nil
                        elseif current.isLive and current.live then
                                mainKey = current.live.kind
                        end
                else
                        mainKey = live and live.kind or nil
                end
                local resultC
                if DIM.result and now < DIM.result then
                        resultC = { key = "result", kind = "result", icon = "check", color = DIM_COL.result }
                end
                local cands = {}
                for _, k in ipairs({ "timer", "stopwatch" }) do
                        local a = byKind[k]
                        if a and mainKey ~= k then
                                cands[#cands + 1] = { key = k, kind = k, icon = a.icon, text = a.text, ring = a.ring, color = DIM_COL[k] }
                        end
                end
                local aK = lives.farm and "farm" or (lives.track and "track" or nil)
                if aK and mainKey ~= aK then
                        cands[#cands + 1] = { key = aK, kind = aK, icon = (aK == "farm") and "target" or "map-pin", color = DIM_COL[aK] }
                end
                if byKind.media and mainKey ~= "media" then
                        cands[#cands + 1] = { key = "media", kind = "media", icon = "music", color = DIM_COL.media }
                end
                local pool = cands
                local pick
                if resultC then
                        pick = resultC
                        pool = { resultC }
                        for _, c in ipairs(cands) do
                                pool[#pool + 1] = c
                        end
                else
                        local cyc = tonumber(DIM.CycleSec) or 0
                        if #cands >= 2 and cyc > 0 then
                                pick = cands[(math.floor(now / cyc) % #cands) + 1]
                        else
                                pick = cands[1]
                        end
                end
                if pick and DIM.skin and pick.key ~= DIM.skin.key and (now - DIM.changedAt) < (tonumber(DIM.MinShow) or 0.35) then
                        for _, c in ipairs(pool) do
                                if c.key == DIM.skin.key then
                                        pick = c
                                        break
                                end
                        end
                end
                local prevKey = DIM.skin and DIM.skin.key
                if (pick and pick.key) ~= prevKey then
                        DIM.changedAt = now
                        if pick then
                                dimTrace((pick.kind == "result" or pick.kind == "farm" or pick.kind == "track") and "DIM_DEMOTE" or "DIM_BUBBLE", pick.key)
                        else
                                dimTrace("DIM_BUBBLE", "none")
                        end
                end
                DIM.skin = pick
                DIM.SetBubbleSkin(pick)
                refreshBubble()
                DIM.SetGlow(dimMainColor())
        end
        local origStatusPill = Island.StatusPill
        function Island:StatusPill(level, d)
                if Island.BCToastOn and Island.BCToastOn() then
                        return Island.BCToastPush(level, d or {}, false)
                end
                if DIM.On and current and current.kind == "result" and not destroyed then
                        DIM.result = os.clock() + 4
                        pcall(dismissJob, current)
                end
                return origStatusPill(self, level, d)
        end
        function Island:Destroy()
                if destroyed then
                        return
                end
                destroyed = true
                resetPressState()
                for _, connection in ipairs(holdInputConnections) do
                        pcall(function() connection:Disconnect() end)
                end
                table.clear(holdInputConnections)
                pcall(spCancel)
                pcall(function() XC.destroy() end)
                if WindUI then
                        WindUI.NotifyRed, WindUI.NotifyYellow, WindUI.NotifyGreen = nil, nil, nil
                        WindUI.NotifyRedDot, WindUI.NotifyYellowDot, WindUI.NotifyGreenDot = nil, nil, nil
                        WindUI.NotifyDot = nil
                end
                Island.Wake = nil
                pcall(function()
                        if driver then
                                driver:Disconnect()
                                driver = nil
                        end
                end)
                if camConn then
                        pcall(function()
                                camConn:Disconnect()
                        end)
                end
                window.Open, window.Close, window.Destroy = oOpen, oClose, oDestroy
                if WindUI and oNotify then
                        WindUI.Notify = oNotify
                end
                gui:Destroy()
        end
        goIdle()
        window.Island = Island
        if WindUI then
                WindUI.Island = Island
        end
        function Island:CountInstances()
            if not self.Gui then return 0 end
            local n = 0
            pcall(function() n = #self.Gui:GetDescendants() end)
            return n
        end
        DIM.CountInstances = function() return Island:CountInstances() end
        return Island
end
return IS
	end
	return a.IS()
end
-- [/BF Dynamic Island A]


-- Build the standalone UI shell.
local Library = BF_LoadUILibrary()
local Window = Library:CreateWindow({
    Title = "TRAPREAL HUB",
    SubTitle = "UI TEMPLATE  •  NO GAMEPLAY LOGIC",
    Size = UDim2.fromOffset(1480, 920),
    TabWidth = 280,
    MinimizeKey = Enum.KeyCode.LeftControl,
})

-- Dynamic Island A: collapsed by default, opens/closes the large menu.
local islandHost = {
    Title = "TRAPREAL HUB",
    Author = "TRAPREAL",
    Closed = true,
    IsOpenButtonEnabled = false,
}
local rawMinimize, rawRestore = Window.Minimize, Window.Restore
function Window:Minimize(instant)
    if rawMinimize then rawMinimize(self, instant) end
    islandHost.Closed = true
end
function Window:Restore(instant)
    if rawRestore then rawRestore(self, instant) end
    islandHost.Closed = false
end
islandHost.Open = function() Window:Restore() end
islandHost.Close = function() Window:Minimize() end
islandHost.Toggle = function()
    if islandHost.Closed then Window:Restore() else Window:Minimize() end
end
islandHost.Destroy = function() Library:Unload() end
Window:Minimize(true)

local islandModule = BF_LoadDynamicIslandModule()
local islandWindUI = {
    ScreenGui = Window.Gui,
    Creator = nil,
    Notify = function(_, data) Library:Notify(data) end,
}
local islandOK, islandOrErr = pcall(function()
    return islandModule.Attach(islandHost, islandWindUI, {
        Top = 8,
        Scale = 1,
        Bubble = false,
        IdleText = "title",
        OpenPill = false,
        ReplaceNotify = true,
        CollapseAfter = 1.6,
        DefaultDuration = 2,
        LiveIntro = 2.5,
    })
end)
if not islandOK or not islandOrErr then
    warn("[TRAPREAL UI] Dynamic Island could not attach: " .. tostring(islandOrErr))
    Window:Restore(true)
end

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

-- Open the first page after the island is attached; the hub itself stays collapsed.
return {
    Library = Library,
    Window = Window,
    Island = islandOK and islandOrErr or nil,
    UIOnly = true,
}

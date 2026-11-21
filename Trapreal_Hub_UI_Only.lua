-- TRAPREAL HUB - UI ONLY
-- Giao dien demo: da loai bo toan bo logic game, farm, remote, teleport,
-- webhook, auto-buy, redeem, executor API va cac chuc nang tu dong.
-- Cac nut/toggle/slider ben duoi chi la thanh phan giao dien, khong thuc thi tac vu.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local old = guiParent:FindFirstChild("Trapreal_UI_Only")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(244, 241, 248),
    panel = Color3.fromRGB(234, 228, 242),
    section = Color3.fromRGB(222, 213, 235),
    button = Color3.fromRGB(213, 199, 232),
    hover = Color3.fromRGB(198, 179, 223),
    accent = Color3.fromRGB(155, 121, 197),
    text = Color3.fromRGB(57, 48, 68),
    sub = Color3.fromRGB(118, 108, 130),
    border = Color3.fromRGB(205, 193, 220),
}

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 12)}, parent)
end

local function stroke(parent, color, transparency)
    make("UIStroke", {
        Color = color or C.border,
        Transparency = transparency or 0.25,
        Thickness = 1,
    }, parent)
end

local function label(parent, text, size, position, dimensions, color, font)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Position = position,
        Size = dimensions,
        Text = text,
        TextColor3 = color or C.text,
        Font = font or Enum.Font.GothamMedium,
        TextSize = size or 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end

local screen = make("ScreenGui", {
    Name = "Trapreal_UI_Only",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, guiParent)

local scale = make("UIScale", {Scale = 1}, screen)
local root = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(650, 460),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, screen)
corner(root, 22)
stroke(root, C.border, 0.12)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.bg),
        ColorSequenceKeypoint.new(0.5, C.panel),
        ColorSequenceKeypoint.new(1, C.bg),
    }),
    Rotation = 35,
}, root)

-- Header
local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 62),
    BackgroundColor3 = C.panel,
    BackgroundTransparency = 0.18,
    BorderSizePixel = 0,
}, root)
local logo = make("Frame", {
    Position = UDim2.fromOffset(17, 11),
    Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = C.accent,
    BorderSizePixel = 0,
}, header)
corner(logo, 13)
make("UIGradient", {Color = ColorSequence.new(C.accent, C.hover), Rotation = 135}, logo)
label(logo, "T", 22, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), Color3.new(1,1,1), Enum.Font.GothamBold).TextXAlignment = Enum.TextXAlignment.Center
label(header, "TRAPREAL HUB", 18, UDim2.fromOffset(68, 8), UDim2.fromOffset(220, 25), C.text, Enum.Font.GothamBold)
label(header, "UI PREVIEW  •  VISUAL ONLY", 9, UDim2.fromOffset(69, 33), UDim2.fromOffset(230, 16), C.sub, Enum.Font.GothamBold)

local status = make("Frame", {
    Position = UDim2.new(1, -122, 0, 19),
    Size = UDim2.fromOffset(78, 24),
    BackgroundColor3 = C.button,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
}, header)
corner(status, 20)
label(status, "●  READY", 9, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), C.accent, Enum.Font.GothamBold).TextXAlignment = Enum.TextXAlignment.Center

local close = make("TextButton", {
    Position = UDim2.new(1, -37, 0, 17),
    Size = UDim2.fromOffset(25, 25),
    BackgroundColor3 = C.button,
    Text = "×",
    TextColor3 = C.sub,
    TextSize = 19,
    Font = Enum.Font.GothamMedium,
    AutoButtonColor = false,
    BorderSizePixel = 0,
}, header)
corner(close, 20)
close.MouseButton1Click:Connect(function() screen:Destroy() end)

-- Sidebar
local sidebar = make("Frame", {
    Name = "Sidebar",
    Position = UDim2.fromOffset(14, 76),
    Size = UDim2.fromOffset(145, 370),
    BackgroundColor3 = C.panel,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
}, root)
corner(sidebar, 16)
stroke(sidebar, C.border, 0.45)
label(sidebar, "NAVIGATION", 9, UDim2.fromOffset(13, 12), UDim2.fromOffset(115, 18), C.sub, Enum.Font.GothamBold)

local content = make("Frame", {
    Name = "Content",
    Position = UDim2.fromOffset(171, 76),
    Size = UDim2.new(1, -185, 1, -90),
    BackgroundTransparency = 1,
}, root)

local pages = {}
local tabButtons = {}
local activeTab = "Overview"

local function showPage(name)
    activeTab = name
    for pageName, page in pairs(pages) do page.Visible = pageName == name end
    for tabName, button in pairs(tabButtons) do
        local selected = tabName == name
        button.BackgroundColor3 = selected and C.accent or C.button
        button.TextColor3 = selected and Color3.new(1,1,1) or C.text
    end
end

local function addTab(name, icon, index)
    local b = make("TextButton", {
        Position = UDim2.fromOffset(9, 39 + (index-1)*43),
        Size = UDim2.new(1, -18, 0, 35),
        BackgroundColor3 = C.button,
        BackgroundTransparency = 0.08,
        Text = icon .. "   " .. name,
        TextColor3 = C.text,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, sidebar)
    corner(b, 10)
    local pad = make("UIPadding", {PaddingLeft = UDim.new(0, 11)}, b)
    tabButtons[name] = b
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

local function newPage(name)
    local page = make("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, content)
    make("UIListLayout", {Padding = UDim.new(0, 11), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    pages[name] = page
    return page
end

local function section(parent, title, subtitle)
    local card = make("Frame", {
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.panel,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
    }, parent)
    corner(card, 14)
    stroke(card, C.border, 0.45)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 13),
        PaddingRight = UDim.new(0, 13),
    }, card)
    make("UIListLayout", {Padding = UDim.new(0, 9), SortOrder = Enum.SortOrder.LayoutOrder}, card)
    label(card, title, 13, UDim2.new(), UDim2.new(1, 0, 0, 19), C.text, Enum.Font.GothamBold)
    if subtitle then label(card, subtitle, 10, UDim2.new(), UDim2.new(1, 0, 0, 15), C.sub) end
    return card
end

local function visualButton(parent, text)
    local b = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = C.button,
        Text = text,
        TextColor3 = C.text,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, parent)
    corner(b, 9)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.14), {BackgroundColor3 = C.hover}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.14), {BackgroundColor3 = C.button}):Play() end)
    return b
end

local function visualToggle(parent, text, initial)
    local row = make("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1}, parent)
    label(row, text, 11, UDim2.fromOffset(0, 0), UDim2.new(1, -58, 1, 0), C.text)
    local toggle = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(43, 23),
        BackgroundColor3 = initial and C.accent or C.section,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, row)
    corner(toggle, 20)
    local knob = make("Frame", {
        Position = initial and UDim2.fromOffset(22, 3) or UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(17, 17),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
    }, toggle)
    corner(knob, 20)
    local on = initial
    toggle.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(toggle, TweenInfo.new(0.14), {BackgroundColor3 = on and C.accent or C.section}):Play()
        TweenService:Create(knob, TweenInfo.new(0.14), {Position = on and UDim2.fromOffset(22,3) or UDim2.fromOffset(3,3)}):Play()
    end)
end

local function visualSlider(parent, text, valueText)
    local row = make("Frame", {Size = UDim2.new(1, 0, 0, 43), BackgroundTransparency = 1}, parent)
    label(row, text, 11, UDim2.fromOffset(0, 0), UDim2.new(0.7, 0, 0, 17), C.text)
    label(row, valueText or "50%", 10, UDim2.new(1, -55, 0, 0), UDim2.fromOffset(55, 17), C.accent, Enum.Font.GothamBold).TextXAlignment = Enum.TextXAlignment.Right
    local track = make("Frame", {Position = UDim2.fromOffset(0, 27), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = C.section, BorderSizePixel = 0}, row)
    corner(track, 8)
    local fill = make("Frame", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundColor3 = C.accent, BorderSizePixel = 0}, track)
    corner(fill, 8)
end

-- Pages and purely decorative controls
local overview = newPage("Overview")
local hero = section(overview, "Welcome to Trapreal Hub", "A clean interface preview. No game automation is included.")
local banner = make("Frame", {Size = UDim2.new(1, 0, 0, 78), BackgroundColor3 = C.section, BorderSizePixel = 0}, hero)
corner(banner, 11)
label(banner, "TRAPREAL", 20, UDim2.fromOffset(14, 10), UDim2.new(1, -28, 0, 27), C.accent, Enum.Font.GothamBold)
label(banner, "Pastel purple interface  •  UI only build", 10, UDim2.fromOffset(15, 41), UDim2.new(1, -28, 0, 18), C.sub)
local stats = section(overview, "Session overview", "Static preview cards")
local statRow = make("Frame", {Size = UDim2.new(1, 0, 0, 66), BackgroundTransparency = 1}, stats)
for i, item in ipairs({{"LEVEL","—"},{"STATUS","IDLE"},{"MODE","PREVIEW"}}) do
    local card = make("Frame", {Position = UDim2.new((i-1)/3, (i-1)*5, 0, 0), Size = UDim2.new(1/3, -5, 1, 0), BackgroundColor3 = C.section, BorderSizePixel = 0}, statRow)
    corner(card, 10)
    label(card, item[1], 9, UDim2.fromOffset(9, 9), UDim2.new(1, -18, 0, 15), C.sub, Enum.Font.GothamBold)
    label(card, item[2], 14, UDim2.fromOffset(9, 29), UDim2.new(1, -18, 0, 22), C.text, Enum.Font.GothamBold)
end

local farm = newPage("Farm")
local f1 = section(farm, "Farm settings", "Visual controls only — no farming code")
visualToggle(f1, "Auto Farm", false)
visualToggle(f1, "Fast Mode", false)
visualToggle(f1, "Bring Mobs", false)
visualSlider(f1, "Tween Speed", "199")
visualButton(f1, "Start Farm  ·  UI only")

local playerPage = newPage("Player")
local p1 = section(playerPage, "Player options", "Decorative settings")
visualToggle(p1, "Walk Speed", false)
visualToggle(p1, "Jump Power", false)
visualToggle(p1, "Anti AFK", false)
visualSlider(p1, "Walk Speed", "50")
visualSlider(p1, "Jump Power", "50")

local misc = newPage("Misc")
local m1 = section(misc, "Miscellaneous", "Non-functional preview controls")
visualToggle(m1, "Performance Mode", false)
visualToggle(m1, "Hide Interface", false)
visualToggle(m1, "Dark Overlay", false)
visualButton(m1, "Refresh Interface")

local settings = newPage("Settings")
local s1 = section(settings, "Interface settings", "The only active action is closing this UI")
visualButton(s1, "Theme  ·  Trapreal Pastel Purple")
visualButton(s1, "Layout  ·  Rounded")
visualButton(s1, "Build  ·  UI Only")
label(sidebar, "TRAPREAL HUB  •  UI ONLY", 8, UDim2.fromOffset(12, 337), UDim2.fromOffset(125, 20), C.sub, Enum.Font.GothamBold)

addTab("Overview", "⌂", 1)
addTab("Farm", "✦", 2)
addTab("Player", "♙", 3)
addTab("Misc", "☷", 4)
addTab("Settings", "⚙", 5)
showPage("Overview")

-- Drag window from header
do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = root.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Responsive scaling
local function updateScale()
    local camera = workspace.CurrentCamera
    if camera then
        local v = camera.ViewportSize
        scale.Scale = math.clamp(math.min(v.X / 700, v.Y / 510), 0.58, 1)
    end
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

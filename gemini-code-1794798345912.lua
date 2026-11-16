local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Xóa UI cũ nếu chạy lại
if playerGui:FindFirstChild("DynamicIslandUI") then
    playerGui.DynamicIslandUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DynamicIslandUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- Khung viên thuốc chính (Trạng thái thu nhỏ)
local island = Instance.new("Frame")
island.Name = "Island"
island.AnchorPoint = Vector2.new(0.5, 0)
island.Position = UDim2.new(0.5, 0, 0, 14) -- Né tai thỏ iPhone 11
island.Size = UDim2.new(0, 170, 0, 34)
island.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
island.BackgroundTransparency = 0.1
island.ClipsDescendants = true
island.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 17)
corner.Parent = island

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(130, 95, 255)
stroke.Thickness = 1.2
stroke.Transparency = 0.4
stroke.Parent = island

-- Gradient nền tím xanh kiểu iOS
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 42, 115)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 20, 46))
})
gradient.Rotation = 35
gradient.Parent = island

-- Thanh hiển thị khi thu nhỏ (Mini Bar)
local miniBar = Instance.new("TextButton")
miniBar.Name = "MiniBar"
miniBar.Size = UDim2.new(1, 0, 0, 34)
miniBar.BackgroundTransparency = 1
miniBar.Text = ""
miniBar.Parent = island

local miniLabel = Instance.new("TextLabel")
miniLabel.Size = UDim2.new(1, -20, 1, 0)
miniLabel.Position = UDim2.new(0, 10, 0, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.Font = Enum.Font.GothamBold
miniLabel.TextSize = 12
miniLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
miniLabel.Text = "00:00  •  60 FPS"
miniLabel.Parent = miniBar

-- Khung nội dung khi bung to (Expanded Panel)
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 36)
content.Size = UDim2.new(1, 0, 1, -36)
content.BackgroundTransparency = 1
content.Visible = false
content.Parent = island

-- Đồng hồ lớn + FPS/Ping
local clockLabel = Instance.new("TextLabel")
clockLabel.Position = UDim2.new(0, 16, 0, 4)
clockLabel.Size = UDim2.new(0, 110, 0, 32)
clockLabel.BackgroundTransparency = 1
clockLabel.Font = Enum.Font.GothamBlack
clockLabel.TextSize = 26
clockLabel.TextXAlignment = Enum.TextXAlignment.Left
clockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
clockLabel.Text = "09:37"
clockLabel.Parent = content

local statsLabel = Instance.new("TextLabel")
statsLabel.Position = UDim2.new(1, -135, 0, 6)
statsLabel.Size = UDim2.new(0, 120, 0, 30)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamSemibold
statsLabel.TextSize = 11
statsLabel.TextXAlignment = Enum.TextXAlignment.Right
statsLabel.TextColor3 = Color3.fromRGB(160, 235, 185)
statsLabel.Text = "60 FPS\n45 ms"
statsLabel.Parent = content

-- Khu vực hiển thị Tab
local tabContainer = Instance.new("Frame")
tabContainer.Position = UDim2.new(0, 14, 0, 44)
tabContainer.Size = UDim2.new(1, -28, 0, 68)
tabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabContainer.BackgroundTransparency = 0.92
tabContainer.Parent = content

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 12)
tabCorner.Parent = tabContainer

local tabText = Instance.new("TextLabel")
tabText.Size = UDim2.new(1, -16, 1, -10)
tabText.Position = UDim2.new(0, 8, 0, 5)
tabText.BackgroundTransparency = 1
tabText.Font = Enum.Font.GothamMedium
tabText.TextSize = 12
tabText.TextWrapped = true
tabText.TextColor3 = Color3.fromRGB(235, 235, 250)
tabText.Text = "Tab Overview: Trạng thái hoạt động bình thường."
tabText.Parent = tabContainer

-- Thanh chuyển Tab phía dưới
local tabBar = Instance.new("Frame")
tabBar.Position = UDim2.new(0.5, -110, 1, -46)
tabBar.Size = UDim2.new(0, 220, 0, 26)
tabBar.BackgroundTransparency = 1
tabBar.Parent = content

local uiList = Instance.new("UIListLayout")
uiList.FillDirection = Enum.FillDirection.Horizontal
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.Padding = UDim.new(0, 8)
uiList.Parent = tabBar

local tabsData = {
    {Name = "Overview", Info = "Overview: Chạm nút bên dưới để chuyển tab chức năng."},
    {Name = "Main", Info = "Main: Nơi đặt các nút Toggle / Slider chính của bạn."},
    {Name = "Settings", Info = "Settings: Tùy chỉnh giao diện & phím tắt."}
}

for _, data in ipairs(tabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.85
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = data.Name
    btn.Parent = tabBar

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        tabText.Text = data.Info
    end)
end

-- Nút mũi tên thu gọn
local closeBtn = Instance.new("TextButton")
closeBtn.Position = UDim2.new(0.5, -30, 1, -18)
closeBtn.Size = UDim2.new(0, 60, 0, 16)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
closeBtn.Text = "^"
closeBtn.Parent = content

-- Logic Đóng / Mở Dynamic Island
local isExpanded = false
local tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function toggleIsland(state)
    isExpanded = state
    if isExpanded then
        content.Visible = true
        TweenService:Create(island, tweenInfo, {Size = UDim2.new(0, 310, 0, 175)}):Play()
        TweenService:Create(corner, tweenInfo, {CornerRadius = UDim.new(0, 26)}):Play()
    else
        content.Visible = false
        TweenService:Create(island, tweenInfo, {Size = UDim2.new(0, 170, 0, 34)}):Play()
        TweenService:Create(corner, tweenInfo, {CornerRadius = UDim.new(0, 17)}):Play()
    end
end

miniBar.MouseButton1Click:Connect(function()
    toggleIsland(not isExpanded)
end)

closeBtn.MouseButton1Click:Connect(function()
    toggleIsland(false)
end)

-- Cập nhật FPS, Ping & Giờ thực tế
local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastTime >= 1 then
        local fps = frames
        frames = 0
        lastTime = tick()

        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local timeStr = os.date("%H:%M")

        clockLabel.Text = timeStr
        miniLabel.Text = string.format("%s  •  %d FPS", timeStr, fps)
        statsLabel.Text = string.format("%d FPS\n%d ms", fps, ping)
    end
end)
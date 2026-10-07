-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- Safe Container Resolver
local function getSafeContainer()
    local container = nil
    if gethui then
        pcall(function() container = gethui() end)
    end
    if not container then
        pcall(function() container = CoreGui end)
    end
    if not container then
        local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        container = lp:FindFirstChild("PlayerGui")
    end
    return container or CoreGui
end

local parentContainer = getSafeContainer()

-- Clean up previous execution
if parentContainer:FindFirstChild("KJHub_StandaloneMobile") then
    parentContainer.KJHub_StandaloneMobile:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KJHub_StandaloneMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentContainer

-- Color Palette
local NeonGreen  = Color3.fromRGB(57, 255, 20)
local BrightNeon = Color3.fromRGB(100, 255, 100)
local MidnightBg = Color3.fromRGB(12, 16, 24)
local HeaderBg   = Color3.fromRGB(18, 24, 36)
local ElementBg  = Color3.fromRGB(22, 30, 44)
local TextWhite  = Color3.fromRGB(255, 255, 255)
local TextMuted  = Color3.fromRGB(170, 180, 200)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = MidnightBg
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = NeonGreen
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = HeaderBg
Header.Active = true
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Text = "KJ Hub"
Title.TextColor3 = TextWhite
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Floating KJ Toggle Button
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingToggle"
FloatingBtn.Size = UDim2.new(0, 52, 0, 52)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
FloatingBtn.BackgroundColor3 = MidnightBg
FloatingBtn.BorderSizePixel = 0
FloatingBtn.Text = ""
FloatingBtn.Visible = true
FloatingBtn.Active = true
FloatingBtn.ZIndex = 1000
FloatingBtn.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingBtn

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color = NeonGreen
FloatingStroke.Thickness = 2
FloatingStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FloatingStroke.Parent = FloatingBtn

local KJGlow = Instance.new("TextLabel")
KJGlow.Size = UDim2.new(1, 0, 1, 0)
KJGlow.Position = UDim2.new(0, 0, 0, 0)
KJGlow.BackgroundTransparency = 1
KJGlow.Text = "KJ"
KJGlow.Font = Enum.Font.GothamBlack
KJGlow.TextSize = 22
KJGlow.TextColor3 = NeonGreen
KJGlow.TextTransparency = 0.4
KJGlow.ZIndex = 1001
KJGlow.Parent = FloatingBtn

local KJText = Instance.new("TextLabel")
KJText.Size = UDim2.new(1, 0, 1, 0)
KJText.Position = UDim2.new(0, 0, 0, 0)
KJText.BackgroundTransparency = 1
KJText.Text = "KJ"
KJText.Font = Enum.Font.GothamBlack
KJText.TextSize = 22
KJText.TextColor3 = BrightNeon
KJText.ZIndex = 1002
KJText.Parent = FloatingBtn

-- Minimize Button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinimizeButton"
MinBtn.Parent = Header
MinBtn.Position = UDim2.new(1, -32, 0, 4)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.BackgroundColor3 = ElementBg
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Text = "-"
MinBtn.TextColor3 = NeonGreen
MinBtn.TextSize = 22
MinBtn.Active = true
MinBtn.ZIndex = 50

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = NeonGreen
MinStroke.Thickness = 1
MinStroke.Parent = MinBtn

-- Explicit direct connection for Minimize
MinBtn.MouseButton1Down:Connect(function()
    MainFrame.Visible = false
end)

MinBtn.Activated:Connect(function()
    MainFrame.Visible = false
end)

-- Pulse Animation Loop
task.spawn(function()
    while FloatingBtn and FloatingBtn.Parent do
        TweenService:Create(KJGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0.1
        }):Play()
        TweenService:Create(FloatingStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0
        }):Play()
        task.wait(1)

        if not FloatingBtn or not FloatingBtn.Parent then return end

        TweenService:Create(KJGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0.6
        }):Play()
        TweenService:Create(FloatingStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.4
        }):Play()
        task.wait(1)
    end
end)

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Position = UDim2.new(0, 8, 0, 42)
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = NeonGreen
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Parent = Sidebar
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 5)

SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y + 10)
end)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Position = UDim2.new(0, 145, 0, 42)
ContentArea.Size = UDim2.new(1, -153, 1, -50)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Tab System Setup
local tabFrames = {}
local tabButtons = {}

local tabsData = {
    {Name = "Home", Icon = "🏠"},
    {Name = "Script", Icon = "📜"},
    {Name = "Avatar Changer", Icon = "👤"},
    {Name = "Anti Hit", Icon = "🛡️"},
    {Name = "Anti Lag", Icon = "⚡"},
    {Name = "Server Finder", Icon = "🔍"},
    {Name = "Shaders", Icon = "🏙️"}
}

local function selectTab(tabName)
    for name, frame in pairs(tabFrames) do
        frame.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = ElementBg
            btn.TextColor3 = NeonGreen
        else
            btn.BackgroundColor3 = HeaderBg
            btn.TextColor3 = TextWhite
        end
    end
end

for i, data in ipairs(tabsData) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = data.Name .. "TabBtn"
    tabBtn.Size = UDim2.new(1, -4, 0, 30)
    tabBtn.BackgroundColor3 = HeaderBg
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Text = " " .. data.Icon .. " " .. data.Name
    tabBtn.TextColor3 = TextWhite
    tabBtn.TextSize = 12
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.LayoutOrder = i
    tabBtn.Active = true
    tabBtn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = NeonGreen
    btnStroke.Thickness = 1
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Parent = tabBtn

    local pageFrame = Instance.new("ScrollingFrame")
    pageFrame.Name = data.Name .. "Page"
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.ScrollBarThickness = 3
    pageFrame.ScrollBarImageColor3 = NeonGreen
    pageFrame.Visible = false
    pageFrame.Parent = ContentArea

    local pageList = Instance.new("UIListLayout")
    pageList.Parent = pageFrame
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Padding = UDim.new(0, 8)

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageFrame.CanvasSize = UDim2.new(0, 0, 0, pageList.AbsoluteContentSize.Y + 10)
    end)

    tabFrames[data.Name] = pageFrame
    tabButtons[data.Name] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        selectTab(data.Name)
    end)
end

-- Card Generator Helper
local function createCard(parent, height)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, height)
    card.BackgroundColor3 = ElementBg
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = NeonGreen
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = card

    return card
end

-- 1. HOME TAB
local homePage = tabFrames["Home"]

local discordCard = createCard(homePage, 84)
local discordTitle = Instance.new("TextLabel")
discordTitle.Position = UDim2.new(0, 10, 0, 6)
discordTitle.Size = UDim2.new(1, -20, 0, 16)
discordTitle.BackgroundTransparency = 1
discordTitle.Font = Enum.Font.SourceSansBold
discordTitle.Text = "💬 KJ HUB Discord"
discordTitle.TextColor3 = TextWhite
discordTitle.TextSize = 13
discordTitle.TextXAlignment = Enum.TextXAlignment.Left
discordTitle.Parent = discordCard

local discordSub = Instance.new("TextLabel")
discordSub.Position = UDim2.new(0, 10, 0, 22)
discordSub.Size = UDim2.new(1, -20, 0, 14)
discordSub.BackgroundTransparency = 1
discordSub.Font = Enum.Font.SourceSans
discordSub.Text = "Official community • updates • support"
discordSub.TextColor3 = TextMuted
discordSub.TextSize = 11
discordSub.TextXAlignment = Enum.TextXAlignment.Left
discordSub.Parent = discordCard

local joinBtn = Instance.new("TextButton")
joinBtn.Position = UDim2.new(0, 8, 0, 42)
joinBtn.Size = UDim2.new(1, -16, 0, 32)
joinBtn.BackgroundColor3 = HeaderBg
joinBtn.Font = Enum.Font.SourceSansBold
joinBtn.Text = "JOIN DISCORD"
joinBtn.TextColor3 = NeonGreen
joinBtn.TextSize = 12
joinBtn.Active = true
joinBtn.Parent = discordCard

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 6)
joinCorner.Parent = joinBtn

local joinStroke = Instance.new("UIStroke")
joinStroke.Color = NeonGreen
joinStroke.Thickness = 1
joinStroke.Parent = joinBtn

joinBtn.MouseButton1Click:Connect(function()
    local link = "https://discord.gg/PUmhGBuG3j"
    pcall(function()
        if setclipboard then setclipboard(link)
        elseif toclipboard then toclipboard(link)
        elseif Synapse and Synapse.write_clipboard then Synapse.write_clipboard(link)
        end
    end)
    joinBtn.Text = "COPIED TO CLIPBOARD!"
    task.wait(2)
    joinBtn.Text = "JOIN DISCORD"
end)

-- Creator
local creatorCard = createCard(homePage, 48)
local creatorTitle = Instance.new("TextLabel")
creatorTitle.Position = UDim2.new(0, 10, 0, 5)
creatorTitle.Size = UDim2.new(1, -20, 0, 14)
creatorTitle.BackgroundTransparency = 1
creatorTitle.Font = Enum.Font.SourceSansBold
creatorTitle.Text = "👑 CREATOR / DEVELOPER"
creatorTitle.TextColor3 = TextWhite
creatorTitle.TextSize = 11
creatorTitle.TextXAlignment = Enum.TextXAlignment.Left
creatorTitle.Parent = creatorCard

local creatorName = Instance.new("TextLabel")
creatorName.Position = UDim2.new(0, 10, 0, 22)
creatorName.Size = UDim2.new(1, -20, 0, 18)
creatorName.BackgroundTransparency = 1
creatorName.Font = Enum.Font.SourceSansBold
creatorName.Text = "jacob"
creatorName.TextColor3 = NeonGreen
creatorName.TextSize = 13
creatorName.TextXAlignment = Enum.TextXAlignment.Left
creatorName.Parent = creatorCard

-- Promoter
local promoterCard = createCard(homePage, 48)
local promoterTitle = Instance.new("TextLabel")
promoterTitle.Position = UDim2.new(0, 10, 0, 5)
promoterTitle.Size = UDim2.new(1, -20, 0, 14)
promoterTitle.BackgroundTransparency = 1
promoterTitle.Font = Enum.Font.SourceSansBold
promoterTitle.Text = "📢 PROMOTER"
promoterTitle.TextColor3 = TextWhite
promoterTitle.TextSize = 11
promoterTitle.TextXAlignment = Enum.TextXAlignment.Left
promoterTitle.Parent = promoterCard

local promoterText = Instance.new("TextLabel")
promoterText.Position = UDim2.new(0, 10, 0, 22)
promoterText.Size = UDim2.new(1, -20, 0, 18)
promoterText.BackgroundTransparency = 1
promoterText.Font = Enum.Font.SourceSansBold
promoterText.Text = "dm me to be promoter"
promoterText.TextColor3 = NeonGreen
promoterText.TextSize = 13
promoterText.TextXAlignment = Enum.TextXAlignment.Left
promoterText.Parent = promoterCard

-- 2. SCRIPT TAB
local scriptPage = tabFrames["Script"]
local scriptsData = {
    {Name = "Nexus", Url = "https://flowauth.net/v1/loaders/f975f17238962b01837f93842321a414.lua", HasKey = false},
    {Name = "Sena v6", Url = "https://senahub.xyz/senav6", HasKey = true},
    {Name = "Rene Hub", Url = "https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg", HasKey = false},
    {Name = "Cat Hub", Url = "https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub", HasKey = false},
    {Name = "Owl Hub", Url = "https://raw.githubusercontent.com/Owl-Hub-premium/Scripts/refs/heads/main/Mainloader.lua", HasKey = false},
    {Name = "Sources Hub", Url = "https://flowauth.net/v1/ui/sourceshubsae.lua", HasKey = false},
    {Name = "Nexora Hub", Url = "https://raw.githubusercontent.com/Dayvinksthik/Script/refs/heads/main/Games/JoshBNS-Crack.lua", HasKey = false},
    {Name = "Levon Hub", Url = "https://herculesshield.discloud.app/api/v1/scripts/public/f920e312-1eb3-498b-a64d-f0cf12a31dd6/download", HasKey = false},
    {Name = "Kazee Hub", Url = "https://raw.githubusercontent.com/KazeeHub/KazeHubV3/refs/heads/main/FREE", HasKey = false},
    {Name = "Lennon V4", Url = "https://api.luarmor.net/files/v4/loaders/4595fe31a5f7a8b4f4dd7071f3119ef7.lua", HasKey = false},
    {Name = "Miranda Afk", Url = "https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/mirandaafk.lua", HasKey = false},
    {Name = "RealKid Hub", Url = "https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua", HasKey = true},
    {Name = "Pulse Hub", Url = "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua", HasKey = false},
    {Name = "Bee Hub", Url = "https://raw.githubusercontent.com/beehub044/Beehub/refs/heads/main/BEE%20HUB%20IS%20BACK", HasKey = false},
    {Name = "Nova Hub", Url = "https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua", HasKey = true},
    {Name = "Achieson Hub", Url = "https://raw.githubusercontent.com/achiesonscript/ACHIESON-SCRIPT.v1/refs/heads/main/Free%20Keyless%20Script", HasKey = false},
    {Name = "Chilli Hub", Url = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua", HasKey = false},
    {Name = "LKZ", Url = "https://raw.githubusercontent.com/LucasggkX/LKZ-Hub/refs/heads/main/Loader.lua", HasKey = true},
    {Name = "Speed Hub", Url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", HasKey = true},
    {Name = "BigFroot", Url = "https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua", HasKey = true},
    {Name = "Ajjahans", Url = "https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua", HasKey = true}
}

for _, scriptInfo in ipairs(scriptsData) do
    local card = createCard(scriptPage, 54)
    card.Active = true

    local cardTitle = Instance.new("TextLabel")
    cardTitle.Position = UDim2.new(0, 10, 0, 8)
    cardTitle.Size = UDim2.new(1, -20, 0, 18)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Font = Enum.Font.SourceSansBold
    cardTitle.Text = scriptInfo.Name
    cardTitle.TextColor3 = TextWhite
    cardTitle.TextSize = 15
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left
    cardTitle.Parent = card

    local cardDesc = Instance.new("TextLabel")
    cardDesc.Position = UDim2.new(0, 10, 0, 28)
    cardDesc.Size = UDim2.new(1,

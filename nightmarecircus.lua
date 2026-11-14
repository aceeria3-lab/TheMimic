-- V3

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local ICONS_URL = "https://raw.githubusercontent.com/Footagesus/Icons/main/gravity/dist/Icons.lua"
local ICON_TABLE = {}

local function loadIconTable()
    if next(ICON_TABLE) then return end
    local ok, source = pcall(game.HttpGet, game, ICONS_URL)
    if not ok or not source then return end
    local loader = loadstring or load
    local chunk = loader(source)
    if chunk then
        local success, tbl = pcall(chunk)
        if success and type(tbl) == "table" then
            ICON_TABLE = tbl
        end
    end
end

local function getIcon(name)
    loadIconTable()
    local id = ICON_TABLE[name]
    if not id then return "rbxassetid://10723345479" end
    return id
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalMenuGui_Delta"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
    screenGui.Parent = CoreGui
else
    screenGui.Parent = CoreGui
end


local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 350)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- [BINAGO] Puti para lumabas nang tama ang gradient
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui



local mainGradient = Instance.new("UIGradient")

mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)), -- Mas madilim
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
})

mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame


local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "MenuToggleButton"
toggleButton.Size = UDim2.new(0, 68, 0, 68)
toggleButton.Position = UDim2.new(0, 20, 0.5, -34)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://139934599708171"
toggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Active = true
toggleButton.Parent = screenGui


local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end


local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "Controls"
controlsFrame.Size = UDim2.new(0, 72, 0, 20)
controlsFrame.Position = UDim2.new(1, -87, 0, 12)
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = mainFrame

local colors = {Color3.fromRGB(255, 95, 87), Color3.fromRGB(254, 188, 46), Color3.fromRGB(40, 200, 64)}
for i, color in ipairs(colors) do
    local dot = Instance.new("TextButton")
    dot.Name = "ControlDot" .. i
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, (i - 1) * 24, 0, 2)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Text = ""
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    dot.Parent = controlsFrame
end

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "IOHUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 24, 0, 24)
logo.Position = UDim2.new(0, 15, 0, 12)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://10840244199"
logo.ImageColor3 = Color3.fromRGB(255, 30, 30)
logo.Parent = mainFrame


----------------------------------------------------
-- TOGGLE LOGIC & MOUSE UNLOCK (PC)
----------------------------------------------------
local isMenuOpen = false
local isTweening = false

local function minimizeToButton()
    if isTweening then return end
    isTweening = true

    -- Kapag isinara ang menu, ibalik sa lock ang mouse (para makapaglaro)
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false

    local fadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(titleLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(logo, fadeInfo, {ImageTransparency = 1}):Play()
    TweenService:Create(mainCorner, fadeInfo, {CornerRadius = UDim.new(0, 0)}):Play()

    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, 480, 0, 0),
        Position = UDim2.new(0.5, -240, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        mainFrame.Visible = false
        titleLabel.TextTransparency = 0
        logo.ImageTransparency = 0
        mainCorner.CornerRadius = UDim.new(0, 16)
        isMenuOpen = false
        isTweening = false
    end)
end

local function openMenu()
    if isTweening then return end
    isTweening = true

    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 480, 0, 0)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, 0)

    -- Ipapakita ang mouse pagbukas ng menu
    UserInputService.MouseIconEnabled = true

    titleLabel.TextTransparency = 1
    logo.ImageTransparency = 1
    mainCorner.CornerRadius = UDim.new(0, 0)

    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 480, 0, 350),
        Position = UDim2.new(0.5, -240, 0.5, -175)
    })
    openTween:Play()

    task.delay(0.15, function()
        local fadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(titleLabel, fadeInfo, {TextTransparency = 0}):Play()
        TweenService:Create(logo, fadeInfo, {ImageTransparency = 0}):Play()
        TweenService:Create(mainCorner, fadeInfo, {CornerRadius = UDim.new(0, 16)}):Play()
    end)

    openTween.Completed:Connect(function()
        isMenuOpen = true
        isTweening = false
    end)
end

local function toggleMenu()
    if isTweening then return end
    if isMenuOpen then 
        minimizeToButton() 
    else 
        openMenu() 
    end
end

-- [MAHALAGANG DAGDAG] Loop para pwersahin ang mouse na lumabas kahit i-lock ng game (Shift Lock)
RunService.RenderStepped:Connect(function()
    if isMenuOpen then
        -- Kung nakabukas ang menu, pilitin ang mouse na maging free (Default)
        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end
end)

-- Mouse click sa floating button
toggleButton.MouseButton1Click:Connect(toggleMenu)

-- Keyboard Shortcut (Z key para sa Menu at Mouse)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end 
    
    if input.KeyCode == Enum.KeyCode.Z then
        if not UserInputService:GetFocusedTextBox() then
            toggleMenu() -- Ito na ang bahala mag-open/close at mag-unlock/lock ng mouse
        end
    end
end)

-- Window control dots (red, yellow, green)
for _, dot in ipairs(controlsFrame:GetChildren()) do
    if dot:IsA("TextButton") then
        dot.MouseButton1Click:Connect(minimizeToButton)
    end
end

makeDraggable(mainFrame)
makeDraggable(toggleButton)


----------------------------------------------------
-- NAVIGATION & PAGES SETUP
----------------------------------------------------
-- BINAGO: Height ng sidebar (-130) para may space sa bottom panel
local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, -130) 
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.ScrollBarThickness = 0
sidebar.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
sidebar.Parent = mainFrame

local uiListSide = Instance.new("UIListLayout")
uiListSide.Padding = UDim.new(0, 8)
uiListSide.SortOrder = Enum.SortOrder.LayoutOrder
uiListSide.Parent = sidebar

uiListSide:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sidebar.CanvasSize = UDim2.new(0, 0, 0, uiListSide.AbsoluteContentSize.Y)
end)

-- BAGONG DAGDAG: Bottom Panel para sa Icon Buttons
local bottomPanel = Instance.new("Frame")
bottomPanel.Name = "BottomPanel"
bottomPanel.Size = UDim2.new(0, 160, 0, 50)
bottomPanel.Position = UDim2.new(0, 10, 1, -60) -- Nasa pinaka-ilalim
bottomPanel.BackgroundTransparency = 1
bottomPanel.Parent = mainFrame

local bottomLayout = Instance.new("UIListLayout")
bottomLayout.FillDirection = Enum.FillDirection.Horizontal
bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
bottomLayout.VerticalAlignment = Enum.VerticalAlignment.Center
bottomLayout.Padding = UDim.new(0, 10)
bottomLayout.Parent = bottomPanel


local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -190, 1, -70)
contentFrame.Position = UDim2.new(0, 180, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
contentFrame.BackgroundTransparency = 0 
contentFrame.Parent = mainFrame


local contentGradient = Instance.new("UIGradient")

contentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
})

contentGradient.Rotation = 90
contentGradient.Parent = contentFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local tabs = {}
local pages = {}
local activeTab = nil

local function createPageContainer()
    local scrollPage = Instance.new("ScrollingFrame")
    scrollPage.Size = UDim2.new(1, 0, 1, 0)
    scrollPage.Position = UDim2.new(0, 0, 0, 0)
    scrollPage.BackgroundTransparency = 1
    scrollPage.BorderSizePixel = 0
    scrollPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollPage.ScrollBarThickness = 0
    scrollPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollPage.Visible = false
    scrollPage.Parent = contentFrame

    local scrollPadding = Instance.new("UIPadding")
    scrollPadding.PaddingLeft = UDim.new(0, 10)
    scrollPadding.PaddingRight = UDim.new(0, 10)
    scrollPadding.PaddingTop = UDim.new(0, 10)
    scrollPadding.PaddingBottom = UDim.new(0, 10)
    scrollPadding.Parent = scrollPage

    local uiListContent = Instance.new("UIListLayout")
    uiListContent.Padding = UDim.new(0, 10)
    uiListContent.SortOrder = Enum.SortOrder.LayoutOrder
    uiListContent.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListContent.Parent = scrollPage

    uiListContent:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollPage.CanvasSize = UDim2.new(0, 0, 0, uiListContent.AbsoluteContentSize.Y + 20)
    end)

    return scrollPage
end

local function switchTab(tabName)
    for name, btnElements in pairs(tabs) do
        if name == tabName then
            btnElements.Button.BackgroundTransparency = 0.9
            btnElements.Icon.ImageColor3 = Color3.fromRGB(255, 100, 120)
            if btnElements.Label then btnElements.Label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            if btnElements.Stroke then btnElements.Stroke.Enabled = true end
            pages[name].Visible = true

            -- [BAGONG DAGDAG] Kapag pinindot yung Global Chat, i-reset yung badge
            if name == "GlobalChat" and btnElements.Badge then
                _G.GlobalChatUnread = 0
                btnElements.Badge.Visible = false
                btnElements.Badge.Text = "0"
            end

        else
            btnElements.Button.BackgroundTransparency = 1
            btnElements.Icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
            if btnElements.Label then btnElements.Label.TextColor3 = Color3.fromRGB(180, 180, 180) end
            if btnElements.Stroke then btnElements.Stroke.Enabled = false end
            pages[name].Visible = false

            -- [BAGONG DAGDAG] Kapag lumipat sa ibang tab, ibalik yung badge kung may unread
            if name == "GlobalChat" and btnElements.Badge and _G.GlobalChatUnread > 0 then
                btnElements.Badge.Text = tostring(_G.GlobalChatUnread)
                btnElements.Badge.Visible = true
            end
        end
    end
    activeTab = tabName
end

_G.GlobalChatUnread = 0

local function AddUnreadMessage()
    -- Magdadagdag lang kung HINDI naka-open yung Global Chat
    if activeTab ~= "GlobalChat" then
        _G.GlobalChatUnread = _G.GlobalChatUnread + 1
        
        local chatTab = tabs["GlobalChat"]
        if chatTab and chatTab.Badge then
            chatTab.Badge.Text = tostring(_G.GlobalChatUnread)
            chatTab.Badge.Visible = true
        end
    end
end


-- BAGONG FUNCTION: Para sa Icon-only Buttons sa ilalim (Walang 'local' para global)
function createLeftUnderPanel(name, iconSource)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 45)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 20, 40)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Enabled = false
    stroke.Parent = btn

    local iconId = iconSource
    if not iconSource:match("^rbxasset") and not iconSource:match("^rbxthumb") then
        iconId = getIcon(iconSource)
    end

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 26, 0, 26)
    icon.Position = UDim2.new(0.5, -13, 0.5, -13)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    icon.Parent = btn

    -- Notification Badge
    local badge = Instance.new("TextLabel")
    badge.Name = "NotificationBadge"
    badge.Size = UDim2.new(0, 18, 0, 18)
    badge.Position = UDim2.new(1, -9, 0, -9)
    badge.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    badge.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 10
    badge.Text = "0"
    badge.Visible = false
    badge.ZIndex = 2
    badge.Parent = btn

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(1, 0)
    badgeCorner.Parent = badge

    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    btn.Parent = bottomPanel

    -- Isama natin yung Badge sa tabs table
    tabs[name] = {Button = btn, Icon = icon, Label = nil, Stroke = stroke, Badge = badge}
    pages[name] = createPageContainer()
end

local function createSidebarTab(name, iconSource)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 20, 40)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Enabled = false
    stroke.Parent = btn

    local iconId = iconSource
    if not iconSource:match("^rbxasset") and not iconSource:match("^rbxthumb") then
        iconId = getIcon(iconSource)
    end

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 12, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    icon.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Position = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    btn.Parent = sidebar

    tabs[name] = {Button = btn, Icon = icon, Label = lbl, Stroke = stroke}
    pages[name] = createPageContainer()
end


local TweenService = TweenService or game:GetService("TweenService")


local ICON_PRESETS = {
    success = {
        image     = getIcon("check") or "rbxassetid://10723345479",
        iconColor = Color3.fromRGB(100, 220, 150),
        boxColor  = Color3.fromRGB(25, 35, 30),
        barColor  = Color3.fromRGB(100, 220, 150),
    },
    error = {
        image     = getIcon("xmark") or "rbxassetid://10747384394",
        iconColor = Color3.fromRGB(255, 100, 100),
        boxColor  = Color3.fromRGB(45, 20, 20),
        barColor  = Color3.fromRGB(255, 100, 100),
    },
    alarm = {
        image     = getIcon("alarm") or "rbxassetid://103714651740365",
        iconColor = Color3.fromRGB(255, 200, 80),
        boxColor  = Color3.fromRGB(45, 38, 20),
        barColor  = Color3.fromRGB(255, 200, 80),
    },
    info = {
        image     = getIcon("bell") or "rbxassetid://78246583582436",
        iconColor = Color3.fromRGB(100, 180, 255),
        boxColor  = Color3.fromRGB(20, 30, 45),
        barColor  = Color3.fromRGB(100, 180, 255),
    },
}


local function detectType(title, subtitle, explicit)
    if explicit and ICON_PRESETS[explicit] then return explicit end
    local s = string.lower(tostring(title or "") .. " | " .. tostring(subtitle or ""))
    if s:find("success") then return "success" end
    if s:find("error") or s:find("fail") or s:find("not found") or s:find("invalid") then return "error" end
    if s:find("warning") or s:find("warn") or s:find("alert") then return "warning" end
    return "info"
end

local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotifContainer"
notifContainer.Size = UDim2.new(0, 300, 1, 0)
notifContainer.Position = UDim2.new(1, -320, 0, 20)
notifContainer.BackgroundTransparency = 1
notifContainer.Active = false
notifContainer.Parent = screenGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notifContainer

local function showCustomNotification(titleText, subtitleText, duration, iconType)
    duration = duration or 3
    local ntype  = detectType(titleText, subtitleText, iconType)
    local preset = ICON_PRESETS[ntype]

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 60)
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notif.BorderSizePixel = 0
    notif.ZIndex = 999
    notif.Parent = notifContainer

    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 10)
    nCorner.Parent = notif

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Color3.fromRGB(45, 45, 45)
    nStroke.Thickness = 1
    nStroke.Parent = notif


    local iconBox = Instance.new("Frame")
    iconBox.Size = UDim2.new(0, 32, 0, 32)
    iconBox.Position = UDim2.new(0, 12, 0.5, -16)
    iconBox.BackgroundColor3 = preset.boxColor
    iconBox.Parent = notif

    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(0, 8)
    iCorner.Parent = iconBox

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0, 16, 0, 16)
    iconImg.Position = UDim2.new(0.5, -8, 0.5, -8)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = preset.image
    iconImg.ImageColor3 = preset.iconColor
    iconImg.Parent = iconBox


    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -55, 0, 16)
    titleLbl.Position = UDim2.new(0, 52, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notif


    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -55, 0, 14)
    subLbl.Position = UDim2.new(0, 52, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = subtitleText
    subLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 11
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = notif


    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -24, 0, 3)
    barBg.Position = UDim2.new(0, 12, 1, -7)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.BorderSizePixel = 0
    barBg.Parent = notif

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(1, 0, 1, 0)
    barFill.BackgroundColor3 = preset.barColor
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = barFill


    notif.Position = UDim2.new(0, 300, 0, 0)
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(barFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()


    task.delay(duration, function()
        local fadeOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 300, 0, 0)
        })
        TweenService:Create(nStroke,   TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(titleLbl,  TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(subLbl,    TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(iconBox,   TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(iconImg,   TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        TweenService:Create(barBg,     TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(barFill,   TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            notif:Destroy()
        end)
    end)
end

local function notify(title, text, duration, notifType)
    showCustomNotification(title, text, duration, notifType)
end


local function createToggle(pageName, title, description, callback, customParent)
    local targetPage = customParent or pages[pageName]
    if not targetPage then return end

    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 40) 
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 28) 
    row.BackgroundTransparency = 1 
    row.Text = ""
    row.AutoButtonColor = false
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0) 
    titleLabel.Position = UDim2.new(0, 0, 0, 0) 
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = row
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -42, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Gray toggle off
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 18, 0, 18)
    indicator.Position = UDim2.new(0, 2, 0.5, -9)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    indicator.Parent = toggleBtn
    
    local enabled = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    local function toggleState()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play() -- Accent Blue
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
        if callback then callback(enabled) end
    end

    row.MouseButton1Click:Connect(toggleState)
    
    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
    
    toggleBtn.Parent = row
    row.Parent = targetPage
end


local function createSlider(pageName, title, minValue, maxValue, defaultVal, callback, customParent)
    local targetPage = customParent or pages[pageName]
    if not targetPage then return end

    local currentVal = defaultVal or minValue

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundTransparency = 1
    row.Parent = targetPage

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, 95, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = row

    local trackFrame = Instance.new("Frame")
    trackFrame.Size = UDim2.new(1, -165, 0, 6)
    trackFrame.Position = UDim2.new(0, 95, 0.5, -3)
    trackFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Darker gray track
    trackFrame.BorderSizePixel = 0
    trackFrame.Parent = row
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = trackFrame

    local fillFrame = Instance.new("Frame")
    fillFrame.Size = UDim2.new(0, 0, 1, 0)
    fillFrame.BackgroundColor3 = Color3.fromRGB(100, 150, 255) -- Accent Blue
    fillFrame.BorderSizePixel = 0
    fillFrame.Parent = trackFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fillFrame

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 0, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = trackFrame
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local valBtn = Instance.new("TextButton")
    valBtn.Size = UDim2.new(0, 55, 0, 28) 
    valBtn.Position = UDim2.new(1, -55, 0.5, -14)
    valBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Dark gray button
    valBtn.Text = (currentVal == minValue) and "Off" or tostring(currentVal)
    valBtn.TextColor3 = (currentVal == minValue) and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 255, 255)
    valBtn.Font = Enum.Font.GothamBold
    valBtn.TextSize = 13
    valBtn.Parent = row

    local valCorner = Instance.new("UICorner")
    valCorner.CornerRadius = UDim.new(0, 8)
    valCorner.Parent = valBtn
    
    local valStroke = Instance.new("UIStroke")
    valStroke.Color = Color3.fromRGB(45, 45, 45) -- Darker stroke
    valStroke.Parent = valBtn

    local dragging = false
    
    local function updateSlider(inputX)
        local trackPos = trackFrame.AbsolutePosition.X
        local trackSize = trackFrame.AbsoluteSize.X
        local percentage = math.clamp((inputX - trackPos) / trackSize, 0, 1)
        
        local newVal = math.floor(minValue + (maxValue - minValue) * percentage)
        
        knob.Position = UDim2.new(percentage, -8, 0.5, -8)
        fillFrame.Size = UDim2.new(percentage, 0, 1, 0)
        
        if newVal == minValue then
            valBtn.Text = "Off"
            valBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            valBtn.Text = tostring(newVal)
            valBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        currentVal = newVal
        if callback then callback(currentVal) end
    end

    trackFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end




local function createCustomButton(pageName, title, description, callback, isLocked, customParent)
    local targetPage = customParent or pages[pageName]
    if not targetPage then return end
    if isLocked == nil then isLocked = false end

    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = title .. "_CustomRectangle"
    actionBtn.Size = UDim2.new(1, 0, 0, 40) 
    actionBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Dark gray button
    actionBtn.BackgroundTransparency = 1 
    actionBtn.Text = ""
    actionBtn.AutoButtonColor = false
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -35, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = isLocked and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = actionBtn

    if isLocked then
        local lockIcon = Instance.new("ImageLabel")
        lockIcon.Size = UDim2.new(0, 14, 0, 14)
        lockIcon.Position = UDim2.new(1, -20, 0.5, -7)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = "rbxassetid://114748615465548"
        lockIcon.ImageColor3 = Color3.fromRGB(200, 50, 50)
        lockIcon.Parent = actionBtn
        actionBtn.MouseButton1Click:Connect(function() notify("Failed", "This Feature is Locked", 2) end)
    else
        local arrowIcon = Instance.new("ImageLabel")
        arrowIcon.Size = UDim2.new(0, 14, 0, 14)
        arrowIcon.Position = UDim2.new(1, -20, 0.5, -7)
        arrowIcon.BackgroundTransparency = 1
        arrowIcon.Image = getIcon("circle-play")
        arrowIcon.ImageColor3 = Color3.fromRGB(100, 100, 100)
        arrowIcon.Parent = actionBtn

        actionBtn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
    end
    
    
    actionBtn.MouseEnter:Connect(function()
        TweenService:Create(actionBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
    end)
    actionBtn.MouseLeave:Connect(function()
        TweenService:Create(actionBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)

    actionBtn.Parent = targetPage
    return actionBtn
end


local function createSlider(pageName, title, minValue, maxValue, defaultVal, callback, customParent)
    local targetPage = customParent or pages[pageName]
    if not targetPage then return end

    local currentVal = defaultVal or minValue

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundTransparency = 1
    row.Parent = targetPage

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, 95, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = row

    local trackFrame = Instance.new("Frame")
    trackFrame.Size = UDim2.new(1, -165, 0, 6)
    trackFrame.Position = UDim2.new(0, 95, 0.5, -3)
    trackFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Darker gray track
    trackFrame.BorderSizePixel = 0
    trackFrame.Parent = row
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = trackFrame

    local fillFrame = Instance.new("Frame")
    fillFrame.Size = UDim2.new(0, 0, 1, 0)
    fillFrame.BackgroundColor3 = Color3.fromRGB(100, 150, 255) -- Accent Blue
    fillFrame.BorderSizePixel = 0
    fillFrame.Parent = trackFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fillFrame

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 0, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = trackFrame
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local valBtn = Instance.new("TextButton")
    valBtn.Size = UDim2.new(0, 55, 0, 28) 
    valBtn.Position = UDim2.new(1, -55, 0.5, -14)
    valBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Dark gray button
    valBtn.Text = (currentVal == minValue) and "Off" or tostring(currentVal)
    valBtn.TextColor3 = (currentVal == minValue) and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 255, 255)
    valBtn.Font = Enum.Font.GothamBold
    valBtn.TextSize = 13
    valBtn.Parent = row

    local valCorner = Instance.new("UICorner")
    valCorner.CornerRadius = UDim.new(0, 8)
    valCorner.Parent = valBtn
    
    local valStroke = Instance.new("UIStroke")
    valStroke.Color = Color3.fromRGB(45, 45, 45) -- Darker stroke
    valStroke.Parent = valBtn

    local dragging = false
    
    local function updateSlider(inputX)
        local trackPos = trackFrame.AbsolutePosition.X
        local trackSize = trackFrame.AbsoluteSize.X
        local percentage = math.clamp((inputX - trackPos) / trackSize, 0, 1)
        
        local newVal = math.floor(minValue + (maxValue - minValue) * percentage)
        
        knob.Position = UDim2.new(percentage, -8, 0.5, -8)
        fillFrame.Size = UDim2.new(percentage, 0, 1, 0)
        
        if newVal == minValue then
            valBtn.Text = "Off"
            valBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            valBtn.Text = tostring(newVal)
            valBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        currentVal = newVal
        if callback then callback(currentVal) end
    end

    trackFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end


local CONFIG_PATH = "CandyTracker3_Config.txt"
local collectedCandy = 0
local collectedLbl = nil

local function loadCandyConfig()
    if isfile and isfile(CONFIG_PATH) then
        local success, data = pcall(readfile, CONFIG_PATH)
        if success and tonumber(data) then
            collectedCandy = tonumber(data)
        end
    end
end

local function saveCandyConfig()
    if writefile then
        pcall(writefile, CONFIG_PATH, tostring(collectedCandy))
    end
end

local function formatNumber(n)
    -- Kung "MAX" o may letters, ibalik lang agad nang hindi ginagawang number
    if type(n) == "string" and not tonumber(n) then
        return n 
    end
    
    local formatted = tostring(math.floor(tonumber(n) or 0))
    while true do
        formatted, k = string.gsub(formatted, "^(%-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end



local function createDoubleCubeUI(parent, opts)
    opts = opts or {}
    local refreshRate = opts.RefreshRate or 1

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1 
    container.Parent = parent

    local function createCube(posX, cfg)
        local cube = Instance.new("Frame")
        cube.Size = UDim2.new(0.485, 0, 1, 0)
        cube.Position = UDim2.new(posX, 0, 0, 0)
        cube.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Base white para sa gradient
        cube.BorderSizePixel = 0
        cube.Parent = container
        
        local cCorner = Instance.new("UICorner", cube)
        cCorner.CornerRadius = UDim.new(0, 8)
        
        -- INayos: Sobrang subtle nalang ng gradient para hindi magmukhang umbok
        local cGradient = Instance.new("UIGradient", cube)
        cGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)), -- Light gray
            ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 34, 34))  -- Slightly darker gray
        })
        cGradient.Rotation = 90
        
        -- BAGONG DAGDAG: Faint stroke para magkaroon ng outline pero hindi halata
        local cStroke = Instance.new("UIStroke", cube)
        cStroke.Color = Color3.fromRGB(60, 60, 60)
        cStroke.Thickness = 1
        cStroke.Transparency = 0.6 -- Halos hindi kita, pero nagbibigay ng crisp edge
        
        local ic = Instance.new("ImageLabel")
        ic.Size = UDim2.new(0, 28, 0, 28)
        ic.Position = UDim2.new(0, 12, 0.5, -14)
        ic.BackgroundTransparency = 1
        ic.Image = cfg.Icon or ""
        ic.Parent = cube
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, -50, 0, 14)
        tl.Position = UDim2.new(0, 48, 0, 12) 
        tl.BackgroundTransparency = 1
        tl.Text = string.upper(cfg.Label or "") -- Ginawang uppercase tulad ng venyx
        tl.TextColor3 = Color3.fromRGB(160, 160, 160)
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 11
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.Parent = cube
        
        local vl = Instance.new("TextLabel")
        vl.Size = UDim2.new(1, -50, 0, 20)
        vl.Position = UDim2.new(0, 48, 0, 28) 
        vl.BackgroundTransparency = 1
        vl.Text = "0"
        vl.TextColor3 = cfg.TextColor or Color3.fromRGB(255, 255, 255)
        vl.Font = Enum.Font.GothamBold
        vl.TextSize = 16
        vl.TextXAlignment = Enum.TextXAlignment.Left
        vl.Parent = cube
        return vl
    end

    local leftVal = createCube(0, opts.Left or {})
    local rightVal = createCube(0.515, opts.Right or {})

    if opts.Right and opts.Right.Label == "COLLECTED" then
        collectedLbl = rightVal 
    end

    task.spawn(function()
        while container.Parent do
            if opts.Left and opts.Left.GetValue then
                local ok, v = pcall(opts.Left.GetValue)
                if ok and v ~= nil then leftVal.Text = formatNumber(v) end
            end
            if opts.Right and opts.Right.GetValue then
                local ok, v = pcall(opts.Right.GetValue)
                if ok and v ~= nil then rightVal.Text = formatNumber(v) end
            end
            task.wait(refreshRate)
        end
    end)

    return container
end

local function createOneRectangleUI(parent, opts)
    opts = opts or {}

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60) 
    container.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Base white para sa gradient
    container.BackgroundTransparency = 0
    container.Parent = parent
    
    local cCorner = Instance.new("UICorner", container)
    cCorner.CornerRadius = UDim.new(0, 8) -- Ginawang 8 para pantay sa Double UI
    
    -- Kaparehong subtle gradient ng Double UI
    local cGradient = Instance.new("UIGradient", container)
    cGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 34, 34))  
    })
    cGradient.Rotation = 90
    
    -- Kaparehong faint outline
    local cStroke = Instance.new("UIStroke", container)
    cStroke.Color = Color3.fromRGB(60, 60, 60)
    cStroke.Thickness = 1
    cStroke.Transparency = 0.6 

    local ic = Instance.new("ImageLabel")
    ic.Size = UDim2.new(0, 28, 0, 28)
    ic.Position = UDim2.new(0, 12, 0.5, -14)
    ic.BackgroundTransparency = 1
    ic.Image = opts.Icon or "rbxassetid://10840244199"
    ic.Parent = container
    
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -50, 0, 14)
    tl.Position = UDim2.new(0, 48, 0, 12) 
    tl.BackgroundTransparency = 1
    tl.Text = string.upper(opts.Title or "TITLE") -- Ginawang UPPERCASE
    tl.TextColor3 = Color3.fromRGB(160, 160, 160) -- Kaparehong kulay ng label sa Double UI
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 11
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.Parent = container
    
    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(1, -50, 0, 20)
    vl.Position = UDim2.new(0, 48, 0, 28) 
    vl.BackgroundTransparency = 1
    vl.Text = "Checking..."
    vl.TextColor3 = Color3.fromRGB(255, 255, 255)
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 14 
    vl.TextXAlignment = Enum.TextXAlignment.Left
    vl.TextTruncate = Enum.TextTruncate.AtEnd
    vl.Parent = container

    if opts.GetValue then
        task.spawn(function()
            while container.Parent do
                local ok, text, color = pcall(opts.GetValue)
                if ok and text then
                    vl.Text = text
                    if color then vl.TextColor3 = color end
                end
                task.wait(0.5)
            end
        end)
    end

    return container
end

local function CreateHeaderDropdown(pageName, title, iconName)
    return function(HD)
        local targetPage = pages[pageName]
        if not targetPage then return end

        local container = Instance.new("Frame")
        container.Name = title .. "DropdownGroup"
        container.Size = UDim2.new(1, 0, 0, 0)
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- [BINAGO] Puti para sa gradient
        container.BackgroundTransparency = 0
        container.Parent = targetPage

        -- [BAGONG DAGDAG] Closed Header Gradient
        local headerGradient = Instance.new("UIGradient")
        headerGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 18))
        })
        headerGradient.Rotation = 90
        headerGradient.Parent = container

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = container

        local containerStroke = Instance.new("UIStroke")
        containerStroke.Color = Color3.fromRGB(45, 45, 45) -- Dark gray stroke
        containerStroke.Thickness = 1
        containerStroke.Transparency = 0.2
        containerStroke.Parent = container

        local containerLayout = Instance.new("UIListLayout")
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        containerLayout.Padding = UDim.new(0, 0)
        containerLayout.Parent = container

        local headerBtn = Instance.new("TextButton")
        headerBtn.Size = UDim2.new(1, 0, 0, 46)
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""
        headerBtn.LayoutOrder = 1
        headerBtn.Parent = container

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -70, 1, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = string.upper(title)
        titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 12
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = headerBtn

        if iconName and iconName ~= "" then
            titleLbl.Position = UDim2.new(0, 40, 0, 0)
            local headerIcon = Instance.new("ImageLabel")
            headerIcon.Size = UDim2.new(0, 16, 0, 16)
            headerIcon.Position = UDim2.new(0, 15, 0.5, -8)
            headerIcon.BackgroundTransparency = 1
            headerIcon.Image = getIcon(iconName)
            headerIcon.ImageColor3 = Color3.fromRGB(200, 150, 255) -- Purple accent
            headerIcon.Parent = headerBtn
        else
            titleLbl.Position = UDim2.new(0, 15, 0, 0)
        end

        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0, 18, 0, 18)
        arrow.Position = UDim2.new(1, -30, 0.5, -9)
        arrow.BackgroundTransparency = 1
        arrow.Image = getIcon("chevron-down")
        arrow.ImageColor3 = Color3.fromRGB(100, 120, 150)
        arrow.Parent = headerBtn

        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, 0, 0, 0)
        contentArea.AutomaticSize = Enum.AutomaticSize.Y
        contentArea.BackgroundTransparency = 1
        contentArea.LayoutOrder = 2
        contentArea.Parent = container

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 0) 
        contentLayout.Parent = contentArea

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.PaddingBottom = UDim.new(0, 10)
        contentPadding.Parent = contentArea

        local isOpen = true
        headerBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            contentArea.Visible = isOpen
            local targetRot = isOpen and 0 or -90
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = targetRot}):Play()
            
      -- Opened / Closed Header Gradient switching
if isOpen then
    -- Kapag Bukas (Medyo mas maliwanag ng konti)
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 18))
    })
else
    -- Kapag Sarado (Mas madilim)
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
    })
end
        end)

        local function createDivider()
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, 0, 0, 1)
    div.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Puti
    div.BackgroundTransparency = 0.9 -- 90% transparent (Magiging manipis na gray line)
    div.BorderSizePixel = 0
    div.Parent = contentArea
end

        local function createRow(labelText)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 40) 
            row.BackgroundTransparency = 1
            row.Parent = contentArea

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row
            
            return row, lbl
        end

        HD.createTextBox = function(labelText, placeholderText, callback)
            createDivider()
            local row, lbl = createRow(labelText)
            
            local txtBox = Instance.new("TextBox")
            txtBox.Size = UDim2.new(0, 130, 0, 32)
            txtBox.Position = UDim2.new(1, -130, 0.5, -16) 
            txtBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Dark gray textbox
            txtBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            txtBox.Font = Enum.Font.Gotham
            txtBox.TextSize = 13
            txtBox.PlaceholderText = placeholderText
            txtBox.PlaceholderColor3 = Color3.fromRGB(120, 130, 140)
            txtBox.Text = ""
            txtBox.ClearTextOnFocus = false
            txtBox.Parent = row

            local tbCorner = Instance.new("UICorner")
            tbCorner.CornerRadius = UDim.new(0, 8)
            tbCorner.Parent = txtBox
            
            local tbStroke = Instance.new("UIStroke")
            tbStroke.Color = Color3.fromRGB(45, 45, 45) -- Dark stroke
            tbStroke.Thickness = 1
            tbStroke.Parent = txtBox

            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 10)
            padding.Parent = txtBox

            txtBox.FocusLost:Connect(function()
                if callback then callback(txtBox.Text) end
            end)
        end

        HD.createStyledButton = function(labelText, buttonText, style, callback)
            createDivider()
            local row, lbl = createRow(labelText)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 32)
            btn.Position = UDim2.new(1, -100, 0.5, -16)
            btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Dark gray button
            btn.Text = buttonText
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 13
            btn.Parent = row

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Thickness = 1
            btnStroke.Parent = btn

            if style == "gold" then
                btn.TextColor3 = Color3.fromRGB(200, 180, 120)
                btnStroke.Color = Color3.fromRGB(200, 180, 120)
                btnStroke.Transparency = 0.5
            elseif style == "red" then
                btn.TextColor3 = Color3.fromRGB(255, 100, 100)
                btnStroke.Color = Color3.fromRGB(255, 100, 100)
                btnStroke.Transparency = 0.5
            end

            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        -- 3. OVERLAY DROPDOWN CREATOR (Dark Theme, Click-Blocker, Fixed Search Icon)
        HD.createDropdown = function(labelText, options, defaultOptions, callback)
            local selectedOptions = {}
            if type(defaultOptions) == "table" then
                for _, v in ipairs(defaultOptions) do selectedOptions[v] = true end
            elseif type(defaultOptions) == "string" then
                selectedOptions[defaultOptions] = true
            end

            createDivider()
            local row, lbl = createRow(labelText)
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 130, 0, 32)
            btn.Position = UDim2.new(1, -130, 0.5, -16)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Pure dark button
            btn.Text = ""
            btn.Parent = row

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Color3.fromRGB(45, 45, 45)
            btnStroke.Thickness = 1
            btnStroke.Parent = btn

            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(1, -30, 1, 0)
            valLbl.Position = UDim2.new(0, 10, 0, 0)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = "None"
            valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Left
            valLbl.TextTruncate = Enum.TextTruncate.AtEnd
            valLbl.Parent = btn

            local function updateValText()
                local count = 0
                local firstItem = nil
                for k, v in pairs(selectedOptions) do
                    if v then
                        count = count + 1
                        if not firstItem then firstItem = k end
                    end
                end

                if count == 0 then
                    valLbl.Text = "None"
                    valLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
                elseif count == 1 then
                    valLbl.Text = firstItem
                    valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    valLbl.Text = count .. " Selected"
                    valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end

            updateValText()

            local dropArrow = Instance.new("ImageLabel")
            dropArrow.Size = UDim2.new(0, 14, 0, 14)
            dropArrow.Position = UDim2.new(1, -24, 0.5, -7)
            dropArrow.BackgroundTransparency = 1
            dropArrow.Image = getIcon("chevron-down")
            dropArrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
            dropArrow.Parent = btn

            btn.MouseButton1Click:Connect(function()
                local existing = mainFrame:FindFirstChild("DropdownOverlay")
                if existing then
                    existing:Destroy()
                    return
                end

                local overlay = Instance.new("TextButton")
                overlay.Name = "DropdownOverlay"
                overlay.Size = UDim2.new(1, -190, 1, -70) 
                overlay.Position = UDim2.new(0, 480, 0, 50) -- Magsisimula sa labas ng kanan

                overlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15) 
                overlay.Text = ""
                overlay.AutoButtonColor = false
                overlay.BorderSizePixel = 0
                overlay.ZIndex = 100 
                overlay.Parent = mainFrame

                local ovCorner = Instance.new("UICorner")
                ovCorner.CornerRadius = UDim.new(0, 12)
                ovCorner.Parent = overlay

                TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 180, 0, 50)}):Play()

                -- HEADER
                local headerFrame = Instance.new("Frame")
                headerFrame.Size = UDim2.new(1, -20, 0, 50)
                headerFrame.Position = UDim2.new(0, 10, 0, 10)
                headerFrame.BackgroundTransparency = 1
                headerFrame.ZIndex = 101
                headerFrame.Parent = overlay

                local ovTitle = Instance.new("TextLabel")
                ovTitle.Size = UDim2.new(1, -40, 0, 24)
                ovTitle.Position = UDim2.new(0, 5, 0, 0)
                ovTitle.BackgroundTransparency = 1
                ovTitle.Text = labelText
                ovTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ovTitle.Font = Enum.Font.GothamBold
                ovTitle.TextSize = 16
                ovTitle.TextXAlignment = Enum.TextXAlignment.Left
                ovTitle.ZIndex = 101
                ovTitle.Parent = headerFrame

                local ovSubtitle = Instance.new("TextLabel")
                ovSubtitle.Size = UDim2.new(1, -40, 0, 14)
                ovSubtitle.Position = UDim2.new(0, 5, 0, 24)
                ovSubtitle.BackgroundTransparency = 1
                ovSubtitle.Text = "Pick any"
                ovSubtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
                ovSubtitle.Font = Enum.Font.Gotham
                ovSubtitle.TextSize = 12
                ovSubtitle.TextXAlignment = Enum.TextXAlignment.Left
                ovSubtitle.ZIndex = 101
                ovSubtitle.Parent = headerFrame

                local closeBtn = Instance.new("TextButton")
                closeBtn.Size = UDim2.new(0, 32, 0, 32)
                closeBtn.Position = UDim2.new(1, -32, 0, 0)
                closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Dark button
                closeBtn.Text = "X"
                closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 14
                closeBtn.ZIndex = 101
                closeBtn.Parent = headerFrame
                
                local closeCorner = Instance.new("UICorner")
                closeCorner.CornerRadius = UDim.new(0, 8)
                closeCorner.Parent = closeBtn

                -- SEARCH BAR
                local searchFrame = Instance.new("Frame")
                searchFrame.Size = UDim2.new(1, -20, 0, 36)
                searchFrame.Position = UDim2.new(0, 10, 0, 60)
                searchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                searchFrame.ZIndex = 101
                searchFrame.Parent = overlay
                
                local searchCorner = Instance.new("UICorner")
                searchCorner.CornerRadius = UDim.new(0, 8)
                searchCorner.Parent = searchFrame
                
                local searchStroke = Instance.new("UIStroke")
                searchStroke.Color = Color3.fromRGB(45, 45, 45)
                searchStroke.Thickness = 1
                searchStroke.Parent = searchFrame

                -- SEARCH ICON (Hardcoded fallback para siguradong lumabas)
                local searchIcon = Instance.new("ImageLabel")
                searchIcon.Size = UDim2.new(0, 16, 0, 16)
                searchIcon.Position = UDim2.new(0, 10, 0.5, -8)
                searchIcon.BackgroundTransparency = 1
                searchIcon.Image = "rbxassetid://129452776496055" -- Magnifying Glass Icon
                searchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
                searchIcon.ZIndex = 101
                searchIcon.Parent = searchFrame

                local searchBox = Instance.new("TextBox")
                searchBox.Size = UDim2.new(1, -40, 1, 0)
                searchBox.Position = UDim2.new(0, 32, 0, 0)
                searchBox.BackgroundTransparency = 1
                searchBox.Text = ""
                searchBox.PlaceholderText = "Filter"
                searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                searchBox.Font = Enum.Font.Gotham
                searchBox.TextSize = 13
                searchBox.TextXAlignment = Enum.TextXAlignment.Left
                searchBox.ClearTextOnFocus = false
                searchBox.ZIndex = 101
                searchBox.Parent = searchFrame

                -- OPTIONS GRID
                local scroll = Instance.new("ScrollingFrame")
                scroll.Size = UDim2.new(1, -20, 1, -165) 
                scroll.Position = UDim2.new(0, 10, 0, 105)
                scroll.BackgroundTransparency = 1
                scroll.BorderSizePixel = 0
                scroll.ScrollBarThickness = 0
                scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                scroll.ZIndex = 101
                scroll.Parent = overlay

                local gridLayout = Instance.new("UIGridLayout")
                gridLayout.CellSize = UDim2.new(0.48, 0, 0, 36)
                gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 8)
                gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
                gridLayout.Parent = scroll
                
                gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    scroll.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 10)
                end)

                -- FOOTER BUTTONS
                local footerFrame = Instance.new("Frame")
                footerFrame.Size = UDim2.new(1, -20, 0, 40)
                footerFrame.Position = UDim2.new(0, 10, 1, -50)
                footerFrame.BackgroundTransparency = 1
                footerFrame.ZIndex = 101
                footerFrame.Parent = overlay

                local footerLayout = Instance.new("UIListLayout")
                footerLayout.FillDirection = Enum.FillDirection.Horizontal
                footerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                footerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                footerLayout.Padding = UDim.new(0, 6)
                footerLayout.Parent = footerFrame

                local function createFooterBtn(text, bgColor, textColor)
                    local fBtn = Instance.new("TextButton")
                    fBtn.Size = UDim2.new(0.31, 0, 1, 0)
                    fBtn.BackgroundColor3 = bgColor
                    fBtn.Text = text
                    fBtn.TextColor3 = textColor
                    fBtn.Font = Enum.Font.GothamBold
                    fBtn.TextSize = 13
                    fBtn.ZIndex = 101
                    fBtn.Parent = footerFrame
                    local fCorner = Instance.new("UICorner")
                    fCorner.CornerRadius = UDim.new(0, 8)
                    fCorner.Parent = fBtn
                    return fBtn
                end

                local btnDefault = createFooterBtn("Default", Color3.fromRGB(35, 35, 35), Color3.fromRGB(255, 255, 255))
                local btnClear = createFooterBtn("Clear", Color3.fromRGB(35, 35, 35), Color3.fromRGB(255, 255, 255))
                local btnSelectAll = createFooterBtn("Select all", Color3.fromRGB(80, 180, 255), Color3.fromRGB(15, 15, 15)) -- Cyan button

                local optionButtons = {}

                local function refreshOptionUI()
                    for optText, data in pairs(optionButtons) do
                        if selectedOptions[optText] then
                            data.Button.BackgroundColor3 = Color3.fromRGB(40, 60, 80) -- Dark blue selected
                            data.Button.UIStroke.Color = Color3.fromRGB(80, 180, 255)
                            data.Check.Visible = true
                        else
                            data.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Dark unselected
                            data.Button.UIStroke.Color = Color3.fromRGB(45, 45, 45)
                            data.Check.Visible = false
                        end
                    end
                    updateValText()
                    if callback then
                        local selectedList = {}
                        for k, v in pairs(selectedOptions) do
                            if v then table.insert(selectedList, k) end
                        end
                        callback(selectedList)
                    end
                end

                -- Generate Options
                for _, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    optBtn.Text = ""
                    optBtn.ZIndex = 101
                    optBtn.Parent = scroll

                    local obCorner = Instance.new("UICorner")
                    obCorner.CornerRadius = UDim.new(0, 8)
                    obCorner.Parent = optBtn
                    
                    local obStroke = Instance.new("UIStroke")
                    obStroke.Color = Color3.fromRGB(45, 45, 45)
                    obStroke.Thickness = 1
                    obStroke.Parent = optBtn

                    local optTxt = Instance.new("TextLabel")
                    optTxt.Size = UDim2.new(1, -30, 1, 0)
                    optTxt.Position = UDim2.new(0, 10, 0, 0)
                    optTxt.BackgroundTransparency = 1
                    optTxt.Text = opt
                    optTxt.TextColor3 = Color3.fromRGB(240, 240, 240)
                    optTxt.Font = Enum.Font.GothamBold
                    optTxt.TextSize = 12
                    optTxt.TextXAlignment = Enum.TextXAlignment.Left
                    optTxt.TextTruncate = Enum.TextTruncate.AtEnd
                    optTxt.ZIndex = 101
                    optTxt.Parent = optBtn

                    local checkIcon = Instance.new("ImageLabel")
                    checkIcon.Size = UDim2.new(0, 14, 0, 14)
                    checkIcon.Position = UDim2.new(1, -22, 0.5, -7)
                    checkIcon.BackgroundTransparency = 1
                    checkIcon.Image = "rbxassetid://10723358141" -- Standard Check Icon
                    checkIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    checkIcon.Visible = false
                    checkIcon.ZIndex = 101
                    checkIcon.Parent = optBtn

                    optionButtons[opt] = {Button = optBtn, Text = optTxt, Check = checkIcon, UIStroke = obStroke}

                    optBtn.MouseButton1Click:Connect(function()
                        selectedOptions[opt] = not selectedOptions[opt]
                        refreshOptionUI()
                    end)
                end

                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local query = string.lower(searchBox.Text)
                    for optText, data in pairs(optionButtons) do
                        if string.find(string.lower(optText), query) then
                            data.Button.Visible = true
                        else
                            data.Button.Visible = false
                        end
                    end
                end)

                btnSelectAll.MouseButton1Click:Connect(function()
                    for optText, data in pairs(optionButtons) do
                        if data.Button.Visible then selectedOptions[optText] = true end
                    end
                    refreshOptionUI()
                end)

                btnClear.MouseButton1Click:Connect(function()
                    for optText, data in pairs(optionButtons) do
                        if data.Button.Visible then selectedOptions[optText] = false end
                    end
                    refreshOptionUI()
                end)

                btnDefault.MouseButton1Click:Connect(function()
                    for optText, data in pairs(optionButtons) do selectedOptions[optText] = false end
                    if type(defaultOptions) == "table" then
                        for _, v in ipairs(defaultOptions) do selectedOptions[v] = true end
                    elseif type(defaultOptions) == "string" then
                        selectedOptions[defaultOptions] = true
                    end
                    refreshOptionUI()
                end)

                local function closeOverlay()
                    local tw = TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0, 480, 0, 40)})
                    tw:Play()
                    tw.Completed:Connect(function() overlay:Destroy() end)
                end
                
                closeBtn.MouseButton1Click:Connect(closeOverlay)
                refreshOptionUI()
            end)
        end

        HD.createToggle = function(t, d, c)
            createDivider()
            createToggle(pageName, t, d, c, contentArea)
            end
        
        HD.createCustomButton = function(t, d, c, isLocked)
            createDivider()
            createCustomButton(pageName, t, d, c, isLocked, contentArea)
        end
        
HD.createDoubleCube = function(opts)

    local topSpace = Instance.new("Frame")
    topSpace.Size = UDim2.new(1, 0, 0, 5) 
    topSpace.BackgroundTransparency = 1
    topSpace.Parent = contentArea


    createDoubleCubeUI(contentArea, opts)


    local bottomSpace = Instance.new("Frame")
    bottomSpace.Size = UDim2.new(1, 0, 0, 5) 
    bottomSpace.BackgroundTransparency = 1
    bottomSpace.Parent = contentArea
end
        
HD.createOneRectangle = function(opts)
    local topSpace = Instance.new("Frame")
    topSpace.Size = UDim2.new(1, 0, 0, 5) 
    topSpace.BackgroundTransparency = 1
    topSpace.Parent = contentArea


    createOneRectangleUI(contentArea, opts)


    local bottomSpace = Instance.new("Frame")
    bottomSpace.Size = UDim2.new(1, 0, 0, 5)
    bottomSpace.BackgroundTransparency = 1
    bottomSpace.Parent = contentArea
end
        
        HD.createSlider = function(t, min, max, default, callback)
            createDivider()
            createSlider(pageName, t, min, max, default, callback, contentArea)
        end
    end
end

local RS = game:GetService("ReplicatedStorage")



local function fireReliable(remoteName, label, ...)
    local modules  = RS:FindFirstChild("modules")
    local packet   = modules and modules:FindFirstChild("Packet")
    local reliable = packet and packet:FindFirstChild("Reliable")

    if not reliable then
        notify("IOHUB", "Reliable remote not found!", 3)
        return false
    end

    local args = {...}
    local ok, err = pcall(function()
        if #args > 0 then
            reliable:FireServer(remoteName, table.unpack(args))
        else
            reliable:FireServer(remoteName)
        end
    end)

    if ok then
        return true
    else
        notify("IOHUB", "FireServer error: " .. tostring(err), 3)
        return false
    end
end

local function getObjectPos(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then
        return obj.Position
    end
    if obj:IsA("Model") then
        local ok, cf = pcall(function() return obj:GetPivot() end)
        if ok and cf then return cf.Position end
        local ok2, cf2 = pcall(function()
            local c = obj:GetBoundingBox()
            return c
        end)
        if ok2 and cf2 then return cf2.Position end
    end
    return nil
end

-- Helper para sa proximity prompt fire
local function firePrompt(prompt, label)
    if not prompt then
        notify("Error", (label or "Prompt") .. " not found!", 3, "error")
        return false
    end

    local oldLOS  = prompt.RequiresLineOfSight
    local oldDist = prompt.MaxActivationDistance
    pcall(function()
        prompt.RequiresLineOfSight   = false
        prompt.MaxActivationDistance = 100
    end)

    local ok, err = pcall(function()
        if typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration > 0 and prompt.HoldDuration or 0.5)
            prompt:InputHoldEnd()
        end
    end)

    pcall(function()
        if prompt and prompt.Parent then
            prompt.RequiresLineOfSight   = oldLOS
            prompt.MaxActivationDistance = oldDist
        end
    end)

    if ok then
        return true
    else
        notify("Prompt Error", tostring(err), 3, "error")
        return false
    end
end


local CoreGui   = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local function getContainer(name)
    local c = CoreGui:FindFirstChild(name)
    if not c then
        c = Instance.new("Folder")
        c.Name = name
        c.Parent = CoreGui
    end
    return c
end

local function addESPModel(model, container, color)
    if not model or not container then return end
    color = color or Color3.fromRGB(255, 100, 100)

    if not (model:IsA("Model") or model:IsA("BasePart")) then return end


    if not model:FindFirstChild("IOHUB_ESP_HL") then
        local hl = Instance.new("Highlight")
        hl.Name = "IOHUB_ESP_HL"
        hl.FillColor = color
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.Parent = model
    end


    local anchor
    if model:IsA("BasePart") then
        anchor = model
    else
        anchor = model.PrimaryPart
            or model:FindFirstChild("Hitbox")
            or model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChildWhichIsA("BasePart")
    end

    if anchor then

        local exists = false
        for _, bb in ipairs(container:GetChildren()) do
            if bb:IsA("BillboardGui") and bb.Adornee == anchor then
                exists = true
                break
            end
        end

        if not exists then
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 26)
            bb.AlwaysOnTop = true
            bb.ExtentsOffset = Vector3.new(0, 2.5, 0)
            bb.Adornee = anchor
            bb.Parent = container

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = model.Name
            lbl.TextColor3 = color
            lbl.TextSize = 14
            lbl.Font = Enum.Font.SourceSansBold
            lbl.TextStrokeTransparency = 0
            lbl.Parent = bb
        end
    end
end

local function addESPFolder(folder, container, color)
    if not folder or not container then return end
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Folder") then
            addESPFolder(child, container, color)
        else
            addESPModel(child, container, color)
        end
    end
end

local function removeESPFromModel(model)
    if not model then return end
    local hl = model:FindFirstChild("IOHUB_ESP_HL")
    if hl then pcall(function() hl:Destroy() end) end
    for _, d in ipairs(model:GetDescendants()) do
        if d.Name == "IOHUB_ESP_HL" then
            pcall(function() d:Destroy() end)
        end
    end
end

local function removeESPFromFolder(folder)
    if not folder then return end
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Folder") then
            removeESPFromFolder(child)
        else
            removeESPFromModel(child)
        end
    end
end



createSidebarTab("Section 1", "house")
createSidebarTab("Section 2", "house")
createSidebarTab("Section 3", "house")
createLeftUnderPanel("Setting", "wrench") 
createLeftUnderPanel("Global Chat", "rbxassetid://83881670383280") -- Palitan mo ng tamang chat icon name




local S1Tab = {}
CreateHeaderDropdown("Section 1", "StartUp", "layout")(S1Tab)

local S1miniTab = {}
CreateHeaderDropdown("Section 1", "Carnival Games", "layout")(S1miniTab)

local S1TeleporterTab = {}
CreateHeaderDropdown("Section 1", "Carnival Teleporter", "layout")(S1TeleporterTab)

local S2Tab = {}
CreateHeaderDropdown("Section 2", "StartUp", "layout")(S2Tab)

local S2RelicTab = {}
CreateHeaderDropdown("Section 2", "Relic", "layout")(S2RelicTab)

local S2RelicTeleporterTab = {}
CreateHeaderDropdown("Section 2", "Relic Teleporter", "layout")(S2RelicTeleporterTab)

local S3Tab = {}
CreateHeaderDropdown("Section 3", "Boss Fight", "layout")(S3Tab)



local GamePlayTab = {}
CreateHeaderDropdown("Setting", "Game Play", "")(GamePlayTab)

local GraphicsTab = {}
CreateHeaderDropdown("Setting", "Graphics", "")(GraphicsTab)

local GlobalChatTab = {}
CreateHeaderDropdown("Global Chat", "Global Chat", "message-square")(GlobalChatTab)


switchTab("Section 1")





S1Tab.createCustomButton("Skip Carnival", "", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    notify("Success", "Skipping Section 1", 3, "success")
    hrp.CFrame = CFrame.new(1804.395, -61.124, 4507.125)
    hrp.Velocity = Vector3.new(0, 0, 0)
end)




S1Tab.createCustomButton("Trigger Cutscene", "Fire TouchInterest on Intro Trigger then skip cutscene", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        notify("Error", "No character!", 2, "error")
        return 
    end

    if isDunkRunning then isDunkRunning = false end
    if isStrikeRunning then isStrikeRunning = false end


    local section1 = workspace:FindFirstChild("Section1")
    local introCutscene = section1 and section1:FindFirstChild("IntroCutscene")
    local triggerPart = introCutscene and introCutscene:FindFirstChild("Trigger")

    if not triggerPart or not triggerPart:IsA("BasePart") then
        notify("Error", "Intro Trigger not found!", 3, "error")
        return
    end

    notify("Cutscene", "Triggering intro cutscene...", 2, "info")

    pcall(function()
        firetouchinterest(triggerPart, hrp, 0)  
        task.wait(0.15)
        firetouchinterest(triggerPart, hrp, 1)  
    end)

    task.wait(0.5) 


    local RS = game:GetService("ReplicatedStorage")
    local modules = RS:FindFirstChild("modules")
    local packet = modules and modules:FindFirstChild("Packet")
    local reliable = packet and packet:FindFirstChild("Reliable")

    if reliable then
        notify("Cutscene", "Firing skip events...", 2, "info")
        

        pcall(function()
            reliable:FireServer("Section1/RonnieIntroSkip")
        end)
        task.wait(0.2)
        pcall(function()
            reliable:FireServer("Section1/RonnieIntroSkip")
        end)
        
        notify("Success", "Cutscene Skipped!", 3, "success")
    else
        notify("Error", "Reliable event not found!", 3, "error")
    end
end)


-- ====================================================================
-- SECTION 1 AUTO SAFE SPOT SETUP (MISSING VARIABLES & FUNCTIONS)
-- ====================================================================
local SAFE_CFRAME = CFrame.new(-134.730, 14.750, 251.264)
local ronnieSafetyEnabled = false
local brunoSafetyEnabled = false
local isSafeSpotCooldown = false
local isBrunoSafeSpotCooldown = false


-- Helper: Fire HighStriker Leave (safe exit sa minigame)
local function fireHighStrikerLeave()
    local modules = game:GetService("ReplicatedStorage"):FindFirstChild("modules")
    local packet = modules and modules:FindFirstChild("Packet")
    local reliable = packet and packet:FindFirstChild("Reliable")
    if reliable then
        pcall(function()
            reliable:FireServer("Section1/HighStrikerLeave")
        end)
    end
end



S1Tab.createToggle("Esp Ronnie X Auto Safe Spot", "", function(state)
    
    
    ronnieSafetyEnabled = state
    notify("IOHUB", "Ronnie Safety: " .. (ronnieSafetyEnabled and "ON" or "OFF"), 2)
    
    if ronnieSafetyEnabled then
        task.spawn(function()
            while ronnieSafetyEnabled do
                local s1 = workspace:FindFirstChild("Section1")
                local monster = s1 and s1:FindFirstChild("Monster")
                local ronnie = monster and monster:FindFirstChild("Ronnie")

                if ronnie and not ronnie:FindFirstChild("ESP_Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_Highlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = ronnie
                    
                    local hitbox = ronnie:FindFirstChild("Hitbox") or ronnie:FindFirstChild("Head") or ronnie:FindFirstChildWhichIsA("BasePart")
                    if hitbox and not hitbox:FindFirstChild("ESP_Name") then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "ESP_Name"
                        bb.Size = UDim2.new(0, 100, 0, 25) 
                        bb.StudsOffset = Vector3.new(0, 3, 0) 
                        bb.AlwaysOnTop = true
                        bb.Parent = hitbox
                        
                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = "RONNIE"
                        txt.TextColor3 = Color3.fromRGB(255, 50, 50)
                        txt.TextStrokeTransparency = 0
                        txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 16 
                        txt.Parent = bb
                    end
                end
                task.wait(1)
            end
            
            local s1 = workspace:FindFirstChild("Section1")
            local monster = s1 and s1:FindFirstChild("Monster")
            local ronnie = monster and monster:FindFirstChild("Ronnie")
            if ronnie then
                local hl = ronnie:FindFirstChild("ESP_Highlight")
                if hl then hl:Destroy() end
                local hitbox = ronnie:FindFirstChild("Hitbox") or ronnie:FindFirstChild("Head") or ronnie:FindFirstChildWhichIsA("BasePart")
                if hitbox then
                    local bb = hitbox:FindFirstChild("ESP_Name")
                    if bb then bb:Destroy() end
                                end
            end
        end)
    end
    
end)

S1Tab.createToggle("Esp Bruno X Auto Safe Spot", "", function(state)
    
    
    brunoSafetyEnabled = state
    notify("IOHUB", "Bruno Safety: " .. (brunoSafetyEnabled and "ON" or "OFF"), 2)
    
    if brunoSafetyEnabled then
        task.spawn(function()
            while brunoSafetyEnabled do
                local s1 = workspace:FindFirstChild("Section1")
                local monster2 = s1 and s1:FindFirstChild("Monster2")
                local bruno = monster2 and monster2:FindFirstChild("Bruno")

                if bruno and not bruno:FindFirstChild("ESP_Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_Highlight"
                    hl.FillColor = Color3.fromRGB(255, 140, 0) -- orange
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = bruno
                    
                    local hitbox = bruno:FindFirstChild("Hitbox") or bruno:FindFirstChild("Head") or bruno:FindFirstChildWhichIsA("BasePart")
                    if hitbox and not hitbox:FindFirstChild("ESP_Name") then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "ESP_Name"
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true
                        bb.Parent = hitbox
                        
                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = "BRUNO"
                        txt.TextColor3 = Color3.fromRGB(255, 140, 0)
                        txt.TextStrokeTransparency = 0
                        txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 16 
                        txt.Parent = bb
                    end
                end
                task.wait(1)
            end
            
            local s1 = workspace:FindFirstChild("Section1")
            local monster2 = s1 and s1:FindFirstChild("Monster2")
            local bruno = monster2 and monster2:FindFirstChild("Bruno")
            if bruno then
                local hl = bruno:FindFirstChild("ESP_Highlight")
                if hl then hl:Destroy() end
                local hitbox = bruno:FindFirstChild("Hitbox") or bruno:FindFirstChild("Head") or bruno:FindFirstChildWhichIsA("BasePart")
                if hitbox then
                    local bb = hitbox:FindFirstChild("ESP_Name")
                    if bb then bb:Destroy() end
                end
            end
        end)
    end
end)









RunService.Heartbeat:Connect(function()
    if not ronnieSafetyEnabled or isSafeSpotCooldown or _G.isEyeRelicRunning then return end
    
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s1 = workspace:FindFirstChild("Section1")
    local monster = s1 and s1:FindFirstChild("Monster")
    local ronnie = monster and monster:FindFirstChild("Ronnie")

    if ronnie then
        local ronniePart = ronnie:FindFirstChild("HumanoidRootPart") or ronnie:FindFirstChildWhichIsA("BasePart")
        if ronniePart and (ronniePart.Position - hrp.Position).Magnitude <= 30 then
            isSafeSpotCooldown = true
            fireHighStrikerLeave()
            notify("Warning", "Ronnie Near! Teleporting to Safe Spot...", 2, "alarm")
            hrp.CFrame = SAFE_CFRAME
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            task.delay(3, function() isSafeSpotCooldown = false end)
        end
    end
end)



RunService.Heartbeat:Connect(function()
    if not brunoSafetyEnabled or isBrunoSafeSpotCooldown then return end
    
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s1 = workspace:FindFirstChild("Section1")
    local monster2 = s1 and s1:FindFirstChild("Monster2")
    local bruno = monster2 and monster2:FindFirstChild("Bruno")

    if bruno then
        local brunoPart = bruno:FindFirstChild("Hitbox") or bruno:FindFirstChild("HumanoidRootPart") or bruno:FindFirstChildWhichIsA("BasePart")
        if brunoPart then
            local brunoY = brunoPart.Position.Y
            local distance = (brunoPart.Position - hrp.Position).Magnitude
            
            -- ⚠️ I-adjust kung iba ang Y threshold sa laro
            local nearTrigger = distance <= 30
            local yTrigger = brunoY >= 70
            
            if nearTrigger or yTrigger then
                isBrunoSafeSpotCooldown = true
                fireHighStrikerLeave()
                if yTrigger then
                    notify("Warning", string.format("Bruno Y=%.0f! Safe Spot...", brunoY), 2, "alarm")
                else
                    notify("Warning", "Bruno Near! Safe Spot...", 2, "alarm")
                end
                hrp.CFrame = SAFE_CFRAME
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                task.delay(3, function() isBrunoSafeSpotCooldown = false end)
            end
        end
    end
end)



local isAutoGolfActive = false

S1miniTab.createToggle("Auto Shoot Golf Ball", "Teleports the ball to exact CFrame every 1s", function(state)
    isAutoGolfActive = state

    if not state then
        notify("Info", "Auto Shoot Golf Ball: OFF", 2, "info")
        return
    end

    notify("Success", "Auto Shoot Golf Ball: ON", 2, "success")

    task.spawn(function()
        while isAutoGolfActive do

            local ball = workspace:FindFirstChild("Section1")
                and workspace.Section1:FindFirstChild("Games")
                and workspace.Section1.Games:FindFirstChild("MiniGolf")
                and workspace.Section1.Games.MiniGolf:FindFirstChild("GolfBall")

            if ball then
                local targetCFrame = CFrame.new(
                    39.2852325, 13.9085398, 76.4672394,
                    -0.950526834, 0, 0.310642511,
                     0,           1, 0,
                    -0.310642511, 0, -0.950526834
                )

                pcall(function()
                    ball.AssemblyLinearVelocity  = Vector3.zero
                    ball.AssemblyAngularVelocity = Vector3.zero
                    ball.CFrame = targetCFrame
                end)
            end

            task.wait(1) 
        end
    end)
end)





local isAutoDunk    = false
local autoDunkLoop  = false 
local DUNK_INTERVAL = 4.0

S1miniTab.createToggle("Auto Dunk", "Fire DunkThrow every 4.5s", function(state)
    isAutoDunk = state

    if not state then
        notify("IOHUB", "Auto Dunk: OFF", 2)
        return
    end


    local modules = RS:FindFirstChild("modules")
    local packet  = modules and modules:FindFirstChild("Packet")
    local reliable = packet and packet:FindFirstChild("Reliable")
    if not reliable then
        notify("Error", "Reliable remote not found", 3, "error")
        isAutoDunk = false
        return
    end

    notify("Success", "Auto Dunk: ON", 2, "success")


    if autoDunkLoop then return end
    autoDunkLoop = true

    task.spawn(function()
        while screenGui.Parent and isAutoDunk do
            pcall(function()
                reliable:FireServer("Section1/DunkThrow", 0.25392010239196705, -0.26619204827522902)
            end)
            task.wait(DUNK_INTERVAL)
        end
        autoDunkLoop = false   
    end)
end)


local isSpammingHighStriker = false
local highStrikerLoop = false   
local HIGHSTRIKER_INTERVAL = 0.1

S1miniTab.createToggle("Auto HighStriker", "Spam HighStrikerClick every 0.1s", function(state)
    isSpammingHighStriker = state

    if not state then
        notify("IOHUB", "HighStriker: OFF", 2)
        return
    end


    local modules = RS:FindFirstChild("modules")
    local packet  = modules and modules:FindFirstChild("Packet")
    local reliable = packet and packet:FindFirstChild("Reliable")
    if not reliable then
        notify("Error", "Reliable remote not found", 3, "error")
        isSpammingHighStriker = false
        return
    end

    notify("Success", "HighStriker: ON", 2, "success")

    if highStrikerLoop then return end
    highStrikerLoop = true

    task.spawn(function()
        while screenGui.Parent and isSpammingHighStriker do
            pcall(function()
                reliable:FireServer("Section1/HighStrikerClick")
            end)
            task.wait(HIGHSTRIKER_INTERVAL)
        end
        highStrikerLoop = false   
    end)
end)   
    

local isSpammingDarts  = false
local isSpammingRings  = false
local isAutoWhack      = false
local isAutoBasketball = false

local dartsLoop, ringLoop, whackLoop, basketballLoop = false, false, false, false

local dartCoords = {
    {-0.95, 1}, {-0.47, 1}, {0, 1}, {0.47, 1}, {0.95, 1},
    {-0.95, 0}, {-0.47, 0}, {0, 0}, {0.47, 0}, {0.95, 0},
    {-0.95, -1}, {-0.47, -1}, {0, -1}, {0.47, -1}, {0.95, -1}
}

local baseRingX = 0.3107165151845197
local baseRingY = 0.62630355188792397


local function getReliable()
    local modules  = RS:FindFirstChild("modules")
    local packet   = modules and modules:FindFirstChild("Packet")
    return packet and packet:FindFirstChild("Reliable")
end


S1miniTab.createToggle("Auto Pop Balloons", "Throw 15 darts continuously in a loop", function(state)
    isSpammingDarts = state
    if not state then
        notify("IOHUB", "Darts: OFF", 2, "info")
        return
    end

    local reliable = getReliable()
    if not reliable then
        notify("Error", "Reliable remote not found", 3, "error")
        isSpammingDarts = false
        return
    end

    if dartsLoop then return end
    dartsLoop = true
    notify("Success", "Darts: ON (looping)", 2, "success")

    task.spawn(function()
        while isSpammingDarts and screenGui.Parent do
            
   
            for i, coord in ipairs(dartCoords) do
                if not isSpammingDarts or not screenGui.Parent then break end
                pcall(function()
                    reliable:FireServer("Section1/DartsThrow", coord[1], coord[2])
                end)
                task.wait(0.4)
            end
            
   
            if isSpammingDarts then
                task.wait(0.4)
            end
        end
        dartsLoop = false
    end)
end)


S1miniTab.createToggle("Auto Ring Toss", "Aim at actual bottle positions", function(state)
    isSpammingRings = state
    if not state then
        notify("IOHUB", "Ring Toss: OFF", 2, "info")
        return
    end

    local reliable = getReliable()
    if not reliable then
        notify("Error", "Reliable remote not found", 3, "error")
        isSpammingRings = false
        return
    end

    if ringLoop then return end
    ringLoop = true
    notify("Success", "Ring Toss: ON (smart aim)", 2, "success")

    task.spawn(function()
        while screenGui.Parent and isSpammingRings do
            local ringToss = workspace:FindFirstChild("Section1")
                and workspace.Section1:FindFirstChild("Games")
                and workspace.Section1.Games:FindFirstChild("RingToss")
            
            local bottlesFolder = ringToss and ringToss:FindFirstChild("Bottles")
            
            if bottlesFolder then
                -- Get all bottles na hindi pa Ringed
                local bottles = {}
                local allBottles = {}
                for _, b in ipairs(bottlesFolder:GetChildren()) do
                    if b:IsA("BasePart") then
                        table.insert(allBottles, b)
                        if not b:GetAttribute("Ringed") then
                            table.insert(bottles, b)
                        end
                    end
                end
                
                -- Kung lahat Ringed na, i-reset target sa lahat
                if #bottles == 0 then bottles = allBottles end
                
                if #bottles > 0 then
                    -- Compute bottle center (para maging reference point)
                    local sumX, sumZ = 0, 0
                    for _, b in ipairs(allBottles) do
                        sumX = sumX + b.Position.X
                        sumZ = sumZ + b.Position.Z
                    end
                    local centerX = sumX / #allBottles
                    local centerZ = sumZ / #allBottles
                    
                    -- Pick a random bottle to aim at
                    local target = bottles[math.random(1, #bottles)]
                    
                    -- Reverse-engineer steer/power from bottle position
                    -- Anchor: baseRingX (0.31) = centerX, baseRingY (0.63) = centerZ
                    local steerOffset = (target.Position.X - centerX) / 12 -- tune if needed
                    local powerOffset = (target.Position.Z - centerZ) / 15 -- tune if needed
                    
                    local steer = baseRingX + steerOffset
                    local power = baseRingY + powerOffset
                    
                    -- Clamp para safe
                    steer = math.clamp(steer, -0.95, 0.95)
                    power = math.clamp(power, 0.2, 0.95)
                    
                    pcall(function()
                        reliable:FireServer("Section1/RingThrow", steer, power)
                    end)
                end
            else
                -- Fallback kung wala bottles folder
                local randomX = baseRingX + (math.random(-8, 8) / 100)
                local randomY = baseRingY + (math.random(-4, 4) / 100)
                pcall(function()
                    reliable:FireServer("Section1/RingThrow", randomX, randomY)
                end)
            end
            
            task.wait(1.1) -- Match server cooldown
        end
        ringLoop = false
    end)
end)


S1miniTab.createToggle("Auto Whack", "Whack all clowns continuously", function(state)
    isAutoWhack = state
    if not state then
        notify("IOHUB", "Whack: OFF", 2)
        return
    end

    local reliable = getReliable()
    if not reliable then
        notify("Error", "Reliable remote not found", 3, "error")
        isAutoWhack = false
        return
    end

    if whackLoop then return end
    whackLoop = true
    notify("Success", "Whack: ON", 2, "success")

    task.spawn(function()
        while screenGui.Parent and isAutoWhack do
            local Section1 = workspace:FindFirstChild("Section1")
            local Games    = Section1 and Section1:FindFirstChild("Games")
            local WAC      = Games and Games:FindFirstChild("WhackAClown")
            local Clowns   = WAC and WAC:FindFirstChild("Clowns")

            if Clowns then
                for _, clown in ipairs(Clowns:GetChildren()) do
                    if not isAutoWhack or not screenGui.Parent then break end
                    pcall(function()
                        reliable:FireServer("Section1/Whack", clown)
                    end)
                end
            end
            task.wait(0.1)
        end
        whackLoop = false
    end)
end)


S1miniTab.createToggle("Auto Basketball", "Hold → release every ~3.5s", function(state)
    isAutoBasketball = state
    if not state then
        notify("IOHUB", "Basketball: OFF", 2)
        return
    end

    local reliable = getReliable()
    if not reliable then
        notify("Error", "Reliable remote not found", 3, "error")
        isAutoBasketball = false
        return
    end

    if basketballLoop then return end
    basketballLoop = true
    notify("Success", "Basketball: ON", 2, "success")

    task.spawn(function()
        while screenGui.Parent and isAutoBasketball do
            
            pcall(function()
                reliable:FireServer("Section1/BasketballHold")
            end)
            task.wait(1.0)
            if not isAutoBasketball then break end


            pcall(function()
                reliable:FireServer("Section1/BasketballRelease", 1.1902276559994789)
            end)
            task.wait(1.5)
        end
        basketballLoop = false
    end)
end)
    
    
    -- ====================================================================
-- SECTION 1: CARNIVAL TELEPORTERS (TP + Look + Hold Prompt)
-- ====================================================================
local ControllersS1 = nil
pcall(function()
    ControllersS1 = require(game:GetService("ReplicatedStorage").Client.Controllers)
end)

local function teleportToCarnivalGame(promptPath, gameName)
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        notify("Error", "No character!", 2, "error")
        return 
    end

    -- Traverse prompt path
    local prompt = workspace
    for _, name in ipairs(promptPath) do
        prompt = prompt and prompt:FindFirstChild(name)
    end

    if not prompt or not prompt:IsA("ProximityPrompt") then
        notify("Error", gameName .. " Prompt not found!", 3, "error")
        return
    end

    local promptPart = prompt.Parent
    if not promptPart or not promptPart:IsA("BasePart") then
        notify("Error", gameName .. " Prompt part not found!", 3, "error")
        return
    end

    -- 1. Teleport
    notify("Teleporter", "Teleporting to " .. gameName .. "...", 1.5, "info")
    hrp.CFrame = promptPart.CFrame + Vector3.new(0, 3, 0)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    task.wait(0.3)

    -- 2. Force Look
    if ControllersS1 and ControllersS1.camera then
        local cam = workspace.CurrentCamera
        if cam then
            local targetCFrame = CFrame.lookAt(cam.CFrame.Position, promptPart.Position)
            local x, y, _ = targetCFrame:ToOrientation()
            pcall(function()
                ControllersS1.camera:Enforce(Vector2.new(math.deg(x), math.deg(y)))
            end)
        end
    end

    task.wait(0.2)

    -- 3. Hold Prompt
    local oldLOS = prompt.RequiresLineOfSight
    local oldDist = prompt.MaxActivationDistance
    prompt.RequiresLineOfSight = false
    prompt.MaxActivationDistance = 100

    pcall(function()
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration > 0 and prompt.HoldDuration or 0.5)
        prompt:InputHoldEnd()
        if typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt)
        end
    end)

    prompt.RequiresLineOfSight = oldLOS
    prompt.MaxActivationDistance = oldDist

    notify("Success", gameName .. " Interacted!", 2, "success")
end

-- ==========================================
-- 7 CARNIVAL GAME BUTTONS
-- ==========================================
S1TeleporterTab.createCustomButton("Basketball", "TP + Hold Basketball prompt", function()
    teleportToCarnivalGame({"Section1", "Games", "Basketball", "PromptPart", "ProximityPrompt"}, "Basketball")
end)

S1TeleporterTab.createCustomButton("Dunk Booth", "TP + Hold Dunk Booth prompt", function()
    teleportToCarnivalGame({"Section1", "Games", "DunkBooth", "ProxPart", "ProximityPrompt"}, "Dunk Booth")
end)

S1TeleporterTab.createCustomButton("High Striker", "TP + Hold High Striker prompt", function()
    teleportToCarnivalGame({"Section1", "Games", "High Striker", "ProxPart", "ProximityPrompt"}, "High Striker")
end)

S1TeleporterTab.createCustomButton("Mini Golf", "TP + Hold Mini Golf prompt", function()
    teleportToCarnivalGame({"Section1", "Games", "MiniGolf", "ProxPart", "ProximityPrompt"}, "Mini Golf")
end)

S1TeleporterTab.createCustomButton("Pop The Balloon", "TP + Hold Pop The Balloon prompt", function()
    teleportToCarnivalGame({"Section1", "Games", "PopTheBalloon", "Camera", "ProximityPrompt"}, "Pop The Balloon")
end)

S1TeleporterTab.createCustomButton("Ring Toss", "TP + Hold Ring Toss prompt", function()
    teleportToCarnivalGame({"Section1", "Games", "RingToss", "ring", "ProximityPrompt"}, "Ring Toss")
end)

S1TeleporterTab.createCustomButton("Whack A Clown", "TP + Hold Whack A Clown prompt", function()
    teleportToCarnivalGame({"Section1", "Games", "WhackAClown", "Hammer", "ProximityPrompt"}, "Whack A Clown")
end)
    
    
    
    
-- ============================================================
-- SECTION 2: STARTUP (Dimitra ESP & Safe Zone)
-- ============================================================
local isDimitraESP = false
local isDimitraCooldown = false
local SECTION2_SAFE_CFRAME = CFrame.new(1768.864, -37.218, 4478.665)
local isEyeRelicRunning = false

S2Tab.createToggle("ESP & Safe Zone Dimitra", "Highlight Dimitra & teleport if near", function(state)
    isDimitraESP = state
    notify("IOHUB", "Dimitra Safety: " .. (state and "ON" or "OFF"), 2, state and "success" or "info")
    
    if isDimitraESP then
        task.spawn(function()
            while screenGui.Parent and isDimitraESP do
                task.wait(1)
                local s2 = workspace:FindFirstChild("Section2")
                local monster = s2 and s2:FindFirstChild("Monster")
                local dimitra = monster and monster:FindFirstChild("Dimitra")
                
                if dimitra and not dimitra:FindFirstChild("DimitraESP_Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "DimitraESP_Highlight"
                    hl.Adornee = dimitra
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = dimitra
                end
            end
            
            -- Cleanup
            local s2 = workspace:FindFirstChild("Section2")
            local monster = s2 and s2:FindFirstChild("Monster")
            local dimitra = monster and monster:FindFirstChild("Dimitra")
            if dimitra then
                local hl = dimitra:FindFirstChild("DimitraESP_Highlight")
                if hl then hl:Destroy() end
            end
        end)
    end
end)

-- Heartbeat loop para sa Dimitra Safe Zone
RunService.Heartbeat:Connect(function()
    if not isDimitraESP or isDimitraCooldown then return end
    
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s2 = workspace:FindFirstChild("Section2")
    local monster = s2 and s2:FindFirstChild("Monster")
    local dimitra = monster and monster:FindFirstChild("Dimitra")

    if dimitra then
        local dimitraPart = dimitra:FindFirstChild("Hitbox") or dimitra:FindFirstChild("HumanoidRootPart") or dimitra:FindFirstChildWhichIsA("BasePart")
        if dimitraPart and (dimitraPart.Position - hrp.Position).Magnitude <= 25 then
            isDimitraCooldown = true
            notify("IOHUB", "Dimitra Near! Teleporting to Safe Spot.", 2, "alarm")
            hrp.CFrame = SECTION2_SAFE_CFRAME
            hrp.Velocity = Vector3.new(0, 0, 0)
            task.delay(3, function() isDimitraCooldown = false end)
        end
    end
end)



-- ============================================================
-- SECTION 2: AUTO RELIC TOGGLES (Fire Remote every 1s)
-- ============================================================
_G.S2StarActive = false
_G.S2MoonActive = false
_G.S2FateActive = false

local function startRelicRemoteLoop(remoteName, stateVar)
    if _G[stateVar] then return end
    _G[stateVar] = true
    
    task.spawn(function()
        local RS = game:GetService("ReplicatedStorage")
        local modules = RS:FindFirstChild("modules")
        local reliable = modules and modules:FindFirstChild("Packet") and modules.Packet:FindFirstChild("Reliable")
        
        if not reliable then
            notify("Error", "Reliable remote not found!", 3, "error")
            _G[stateVar] = false
            return
        end

        while _G[stateVar] do
            pcall(function()
                reliable:FireServer(remoteName)
            end)
            task.wait(1) -- Fire every 1 second
        end
    end)
end

S2RelicTab.createToggle("Auto Star", "Fires Star Puzzle Complete every 1 second", function(state)
    if state then
        notify("Auto Star", "ON (Firing every 1s)", 2, "success")
        startRelicRemoteLoop("Section2/StarPuzzleComplete", "S2StarActive")
    else
        _G.S2StarActive = false
        notify("Auto Star", "OFF", 2, "info")
    end
end)

S2RelicTab.createToggle("Auto Moon", "Fires Moon Puzzle Complete every 1 second", function(state)
    if state then
        notify("Auto Moon", "ON (Firing every 1s)", 2, "success")
        startRelicRemoteLoop("Section2/MoonPuzzleComplete", "S2MoonActive")
    else
        _G.S2MoonActive = false
        notify("Auto Moon", "OFF", 2, "info")
    end
end)

S2RelicTab.createToggle("Auto Fate Relic", "Fires Tarot Puzzle Complete every 1 second", function(state)
    if state then
        notify("Auto Fate", "ON (Firing every 1s)", 2, "success")
        startRelicRemoteLoop("Section2/TarotPuzzleComplete", "S2FateActive")
    else
        _G.S2FateActive = false
        notify("Auto Fate", "OFF", 2, "info")
    end
end)

-- AUTO EYE RELIC (Nightmare Mode)
S2RelicTab.createToggle("Auto Eye (Nightmare Mode)", "Auto Scan & Solve Eye Puzzle", function(state)
    isEyeRelicRunning = state
    
    if state then
        notify("IOHUB", "Auto Eye Relic (Nightmare): ON", 2, "success")
        
        task.spawn(function()
            local StatueCFrames = {
                [1] = CFrame.new(1826.129, -55.500, 4514.970),
                [2] = CFrame.new(1818.718, -55.050, 4520.048),
                [3] = CFrame.new(1811.461, -55.050, 4525.177),
                [4] = CFrame.new(1805.225, -55.050, 4529.687)
            }
            
            local function getMeshPart(index)
                local p2 = workspace:FindFirstChild("Section2") and workspace.Section2:FindFirstChild("MainObjective") and workspace.Section2.MainObjective:FindFirstChild("Puzzle2")
                local mirrors = p2 and p2:FindFirstChild("Mirrors")
                local mirror = mirrors and mirrors:FindFirstChild("Mirror"..index)
                local eye = mirror and mirror:FindFirstChild("Eye")
                local meshPart = eye and eye:FindFirstChild("MeshPart")
                return meshPart
            end
            
            local function fireManualEye(index)
                local p2 = workspace:FindFirstChild("Section2") and workspace.Section2:FindFirstChild("MainObjective") and workspace.Section2.MainObjective:FindFirstChild("Puzzle2")
                if not p2 then return end
                local eyeStatues = p2:FindFirstChild("EyeStatues")
                local eyeModel = eyeStatues and eyeStatues:FindFirstChild("Eye"..index)
                if not eyeModel then return end

                local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local targetCF = StatueCFrames[index] or eyeModel:GetPivot()
                hrp.CFrame = targetCF + Vector3.new(0, 3, 0)
                hrp.Velocity = Vector3.new(0, 0, 0)
                task.wait(0.25)

                local prompt = eyeModel:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    local oldLOS = prompt.RequiresLineOfSight
                    local oldDist = prompt.MaxActivationDistance
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = 100

                    pcall(function()
                        prompt:InputHoldBegin()
                        task.wait(prompt.HoldDuration > 0 and prompt.HoldDuration or 0.3)
                        prompt:InputHoldEnd()
                        if typeof(fireproximityprompt) == "function" then fireproximityprompt(prompt) end
                    end)

                    prompt.RequiresLineOfSight = oldLOS
                    prompt.MaxActivationDistance = oldDist
                end
            end

            local baselineTransparency = {}
            local currentSequence = {}
            local hasInitializedBaseline = false
            local lastHintTime = tick()
            local isExecuting = false
            local sequenceComplete = false

            local function takeSnapshot()
                baselineTransparency = {}
                for i = 1, 4 do
                    local part = getMeshPart(i)
                    if part then
                        baselineTransparency[i] = part.Transparency
                    else
                        baselineTransparency[i] = 1
                    end
                end
                hasInitializedBaseline = true
                lastHintTime = tick()
                sequenceComplete = false
            end

            takeSnapshot()

            while isEyeRelicRunning do
                task.wait(0.05)
                
                if not hasInitializedBaseline then
                    takeSnapshot()
                    continue
                end

                local newHintFound = false

                for i = 1, 4 do
                    local meshPart = getMeshPart(i)
                    if meshPart then
                        local currentT = meshPart.Transparency
                        local baseT = baselineTransparency[i]
                        
                        if baseT >= 0.99 and currentT < 0.99 then
                            if not table.find(currentSequence, i) then
                                table.insert(currentSequence, i)
                                baselineTransparency[i] = currentT 
                                lastHintTime = tick()
                                newHintFound = true
                                sequenceComplete = false
                                notify("IOHUB", "Hint Detected: Eye "..i, 1.5, "info")
                            end
                        end
                    end
                end
                
                if not newHintFound and #currentSequence >= 2 and not sequenceComplete then
                    if tick() - lastHintTime >= 2 then
                        sequenceComplete = true
                        
                        if not isExecuting then
                            isExecuting = true
                            task.spawn(function()
                                local batch = {}
                                for _, h in ipairs(currentSequence) do table.insert(batch, h) end
                                currentSequence = {}
                                
                                notify("IOHUB", "Executing Sequence...", 2, "info")
                                
                                for _, eyeIdx in ipairs(batch) do
                                    if not isEyeRelicRunning then break end
                                    fireManualEye(eyeIdx)
                                end
                                
                                takeSnapshot()
                                isExecuting = false
                            end)
                        end
                    end
                end
            end
        end)
    else
        notify("IOHUB", "Auto Eye Relic: OFF", 2, "info")
    end
end)

-- AUTO EYE RELIC (Normal Mode - The Hollow)
S2RelicTab.createToggle("Auto Eye Relic (Normal Mode)", "Auto Scan & Solve Eye Puzzle (The Hollow)", function(state)
    isEyeRelicRunning = state
    
    if state then
        notify("IOHUB", "Auto Eye Relic (The Hollow): ON", 2, "success")
        
        task.spawn(function()
            local StatueCFrames = {
                [1] = CFrame.new(1826.129, -55.500, 4514.970),
                [2] = CFrame.new(1818.718, -55.050, 4520.048),
                [3] = CFrame.new(1811.461, -55.050, 4525.177),
                [4] = CFrame.new(1805.225, -55.050, 4529.687)
            }
            
            local mirrorToEyeMap = { [1] = 4, [2] = 3, [3] = 2, [4] = 1 }
            
            local function getMeshPart(index)
                local p2 = workspace:FindFirstChild("Section2") and workspace.Section2:FindFirstChild("MainObjective") and workspace.Section2.MainObjective:FindFirstChild("Puzzle2")
                local mirrors = p2 and p2:FindFirstChild("Mirrors")
                local mirror = mirrors and mirrors:FindFirstChild("Mirror"..index)
                local eye = mirror and mirror:FindFirstChild("Eye")
                local meshPart = eye and eye:FindFirstChild("MeshPart")
                return meshPart
            end
            
            local function fireManualEye(index)
                local p2 = workspace:FindFirstChild("Section2") and workspace.Section2:FindFirstChild("MainObjective") and workspace.Section2.MainObjective:FindFirstChild("Puzzle2")
                if not p2 then return end
                local eyeStatues = p2:FindFirstChild("EyeStatues")
                local eyeModel = eyeStatues and eyeStatues:FindFirstChild("Eye"..index)
                if not eyeModel then return end

                local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local targetCF = StatueCFrames[index] or eyeModel:GetPivot()
                hrp.CFrame = targetCF + Vector3.new(0, 3, 0)
                hrp.Velocity = Vector3.new(0, 0, 0)
                task.wait(0.25)

                local prompt = eyeModel:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    local oldLOS = prompt.RequiresLineOfSight
                    local oldDist = prompt.MaxActivationDistance
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = 100

                    pcall(function()
                        prompt:InputHoldBegin()
                        task.wait(prompt.HoldDuration > 0 and prompt.HoldDuration or 0.3)
                        prompt:InputHoldEnd()
                        if typeof(fireproximityprompt) == "function" then fireproximityprompt(prompt) end
                    end)

                    prompt.RequiresLineOfSight = oldLOS
                    prompt.MaxActivationDistance = oldDist
                end
            end

            local baselineTransparency = {}
            local currentSequence = {}
            local hasInitializedBaseline = false
            local lastHintTime = tick()
            local isExecuting = false
            local sequenceComplete = false

            local function takeSnapshot()
                baselineTransparency = {}
                for i = 1, 4 do
                    local part = getMeshPart(i)
                    if part then
                        baselineTransparency[i] = part.Transparency
                    else
                        baselineTransparency[i] = 1
                    end
                end
                hasInitializedBaseline = true
                lastHintTime = tick()
                sequenceComplete = false
            end

            takeSnapshot()

            while isEyeRelicRunning do
                task.wait(0.05)
                
                if not hasInitializedBaseline then
                    takeSnapshot()
                    continue
                end

                local newHintFound = false

                for i = 1, 4 do
                    local meshPart = getMeshPart(i)
                    if meshPart then
                        local currentT = meshPart.Transparency
                        local baseT = baselineTransparency[i]
                        
                        if baseT >= 0.99 and currentT < 0.99 then
                            if not table.find(currentSequence, i) then
                                table.insert(currentSequence, i)
                                baselineTransparency[i] = currentT 
                                lastHintTime = tick()
                                newHintFound = true
                                sequenceComplete = false
                                notify("IOHUB", "Hint Detected: Mirror "..i, 1.5, "info")
                            end
                        end
                    end
                end
                
                if not newHintFound and #currentSequence >= 2 and not sequenceComplete then
                    if tick() - lastHintTime >= 2 then
                        sequenceComplete = true
                        
                        if not isExecuting then
                            isExecuting = true
                            task.spawn(function()
                                local batch = {}
                                for _, h in ipairs(currentSequence) do table.insert(batch, h) end
                                currentSequence = {}
                                
                                notify("IOHUB", "Executing Sequence...", 2, "info")
                                
                                for _, mirrorIdx in ipairs(batch) do
                                    if not isEyeRelicRunning then break end
                                    local eyeToFire = mirrorToEyeMap[mirrorIdx] 
                                    fireManualEye(eyeToFire)
                                end
                                
                                takeSnapshot()
                                isExecuting = false
                            end)
                        end
                    end
                end
            end
        end)
    else
        notify("IOHUB", "Auto Eye Relic: OFF", 2, "info")
    end
end)

-- ============================================================
-- SECTION 2: RELIC TELEPORTERS
-- ============================================================
local function teleportToRelic(puzzleName, displayName)
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s2 = workspace:FindFirstChild("Section2")
    local mainObj = s2 and s2:FindFirstChild("MainObjective")
    local puzzleFolder = mainObj and mainObj:FindFirstChild(puzzleName)
    local promptPart = puzzleFolder and puzzleFolder:FindFirstChild("PromptPart")

    if promptPart then
        notify("Teleporter", "Teleporting to " .. displayName, 2, "info")
        hrp.CFrame = promptPart.CFrame + Vector3.new(0, 3, 0)
        hrp.Velocity = Vector3.new(0, 0, 0)
    else
        notify("Error", displayName .. " PromptPart not found!", 3, "error")
    end
end

S2RelicTeleporterTab.createCustomButton("Teleport Star", "Teleport to Star Puzzle", function()
    teleportToRelic("Puzzle1", "Star Relic")
end)

S2RelicTeleporterTab.createCustomButton("Teleport Moon", "Teleport to Moon Puzzle", function()
    teleportToRelic("Puzzle3", "Moon Relic")
end)

S2RelicTeleporterTab.createCustomButton("Teleport Fate", "Teleport to Fate Puzzle", function()
    teleportToRelic("Puzzle4", "Fate Relic")
end)

S2RelicTeleporterTab.createCustomButton("Teleport to Eye Room", "Direct Teleport To Eye Room (Skip to Puzzle 2)", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        notify("Error", "Character not found!", 2, "error")
        return 
    end

    notify("Teleporter", "Teleporting to Eye Room...", 2, "info")
    hrp.CFrame = CFrame.new(1804.395, -61.124, 4507.125)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    task.wait(0.3)
    notify("Success", "Arrived at Eye Room!", 2, "success")
end)


-- ============================================================
-- SECTION 2: BLESSING
-- ============================================================
S2RelicTeleporterTab.createCustomButton("Crystal Ball Wish", "Teleport & Fire Prompt (with Fallback)", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s2 = workspace:FindFirstChild("Section2")
    local mainObj = s2 and s2:FindFirstChild("MainObjective")
    local crystalWish = mainObj and mainObj:FindFirstChild("CrystalBallWish")
    local promptPart = crystalWish and crystalWish:FindFirstChild("PromptPart")
    local prompt = promptPart and (promptPart:FindFirstChildOfClass("ProximityPrompt") or promptPart:FindFirstChild("ProximityPrompt"))

    if promptPart and prompt then
        notify("IOHUB", "Teleporting to Crystal Ball Wish...", 2, "info")
        hrp.CFrame = promptPart.CFrame + Vector3.new(0, 3, 0)
        hrp.Velocity = Vector3.new(0, 0, 0)
        task.wait(0.2)

        local realHold = prompt.HoldDuration > 0 and prompt.HoldDuration or 0.1
        notify("IOHUB", "Firing Crystal Ball Prompt...", 2, "info")
        
        local oldLOS = prompt.RequiresLineOfSight
        local oldDist = prompt.MaxActivationDistance
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 100

        pcall(function()
            prompt:InputHoldBegin()
            task.wait(realHold)
            prompt:InputHoldEnd()
        end)
        
        pcall(function() 
            if typeof(fireproximityprompt) == "function" then fireproximityprompt(prompt) end 
        end)

        prompt.RequiresLineOfSight = oldLOS
        prompt.MaxActivationDistance = oldDist
        task.wait(0.5)
        notify("IOHUB", "Crystal Ball Wish Done!", 3, "success")
    else
        notify("IOHUB", "Prompt not found! Using Fallback CFrame...", 2, "alarm")
        hrp.CFrame = SECTION2_SAFE_CFRAME
        hrp.Velocity = Vector3.new(0, 0, 0)
        task.wait(0.5)
        notify("IOHUB", "Teleported to Fallback Location.", 3, "info")
    end
end)

-- ============================================================
-- SECTION 3: BOSS FIGHT
-- ============================================================
local isSafeSpotEnabled = false
local isDashing = false
local isAutoBunny = false
local isClaimingBunny = false
local hasNotifiedBossDead = false
local isKillingBoss = false

local SAFE_SPOT = CFrame.new(2380.165, 205.233, 5131.306)

S3Tab.createToggle("Auto Safe Spot", "Keep teleporting back to safe spot", function(state)
    isSafeSpotEnabled = state
    if state then 
        hasNotifiedBossDead = false
        notify("IOHUB", "Safe Spot: ON", 2, "success")
    else 
        notify("IOHUB", "Safe Spot: OFF", 2, "info")
    end
end)

S3Tab.createCustomButton("Attack Boss", "Teleport 15 studs behind boss, hit (x1), then return to Safe Spot", function()
    if isDashing then return end 
    
    local section3 = workspace:FindFirstChild("Section3")
    local boss = section3 and section3:FindFirstChild("DimitraBOSS")
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if boss and hrp then
        local bossPart = boss:FindFirstChild("Hitbox") or boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChildWhichIsA("BasePart")
        if bossPart then
            isDashing = true
            notify("IOHUB", "Dashing to Boss...", 2, "info")
            
            local targetPos = bossPart.CFrame * CFrame.new(0, 3, 15).Position
            hrp.CFrame = CFrame.lookAt(targetPos, bossPart.Position)
            hrp.Velocity = Vector3.new(0, 0, 0)
            
            local backpack = localPlayer:FindFirstChild("Backpack")
            local axe = backpack and backpack:FindFirstChild("MagicAxe")
            if not axe then axe = char:FindFirstChild("MagicAxe") end
            if axe and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid:EquipTool(axe)
            end

            local modules = game:GetService("ReplicatedStorage"):FindFirstChild("modules")
            local reliable = modules and modules:FindFirstChild("Packet") and modules.Packet:FindFirstChild("Reliable")
            
            task.spawn(function()
                task.wait(0.25)
                if reliable then
                    pcall(function() reliable:FireServer("MagicAxe/SwingHit") end)
                end
                
                task.wait(0.15)
                if isSafeSpotEnabled and hrp and hrp.Parent then
                    hrp.CFrame = SAFE_SPOT
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
                
                task.wait(0.1)
                isDashing = false
            end)
        end
    end
end)

S3Tab.createToggle("Auto Collect Bunny", "Claim Bunny whenever spawned", function(state)
    isAutoBunny = state
    if state then notify("IOHUB", "Auto Bunny: ON", 2, "success") else notify("IOHUB", "Auto Bunny: OFF", 2, "info") end
end)

S3Tab.createCustomButton("Instant Kill Boss (Solo)", "Directly set Dimitra's health to 0", function()
    if isKillingBoss then return end
    
    local section3 = workspace:FindFirstChild("Section3")
    local boss = section3 and section3:FindFirstChild("DimitraBOSS")
    
    if boss then
        local bossHum = boss:FindFirstChildOfClass("Humanoid")
        if bossHum and bossHum.Health > 0 then
            isKillingBoss = true
            notify("IOHUB", "Instant Killing Boss...", 2, "info")
            
            pcall(function()
                bossHum.Health = 0
                bossHum:ChangeState(Enum.HumanoidStateType.Dead)
            end)
            
            task.wait(1)
            isKillingBoss = false
        else
            notify("IOHUB", "Boss already dead!", 2, "info")
        end
    else
        notify("IOHUB", "Boss not found!", 2, "error")
    end
end)

-- MAIN LOOP (Boss Death Check > Bunny Priority > Safe Spot)
RunService.Heartbeat:Connect(function()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- 1. Boss health check
    local s3 = workspace:FindFirstChild("Section3")
    local boss = s3 and s3:FindFirstChild("DimitraBOSS")
    local bossHum = boss and boss:FindFirstChild("Humanoid")
    
    if bossHum and bossHum.Health <= 1 then
        if isSafeSpotEnabled then
            isSafeSpotEnabled = false
            if not hasNotifiedBossDead then
                notify("IOHUB", "Boss Health is 0! Safe Spot Auto-OFF", 3, "alarm")
                hasNotifiedBossDead = true
            end
        end
        return
    end

    -- 2. Bunny priority
    local bunnySpawn = workspace:FindFirstChild("BunnySpawn") 
        or (workspace:FindFirstChild("Section3") and workspace.Section3:FindFirstChild("BunnySpawn"))
    
    if not bunnySpawn then
        bunnySpawn = workspace:FindFirstChild("BunnySpawn", true)
    end

    if bunnySpawn then
        local bunnyRoot = bunnySpawn:FindFirstChild("RootPart") or bunnySpawn:FindFirstChildWhichIsA("BasePart")
        local bunnyPrompt = bunnySpawn:FindFirstChildWhichIsA("ProximityPrompt", true)

        if isAutoBunny and bunnyRoot and bunnyPrompt and not isClaimingBunny then
            isClaimingBunny = true
            
            task.spawn(function()
                pcall(function()
                    notify("IOHUB", "Claiming Bunny!", 2, "info")
                    hrp.CFrame = bunnyRoot.CFrame + Vector3.new(0, 3, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    task.wait(0.3)

                    local oldLOS = bunnyPrompt.RequiresLineOfSight
                    local oldDist = bunnyPrompt.MaxActivationDistance
                    bunnyPrompt.RequiresLineOfSight = false
                    bunnyPrompt.MaxActivationDistance = 100

                    pcall(function() bunnyPrompt:InputHoldBegin() end)
                    task.wait(0.5)
                    pcall(function() bunnyPrompt:InputHoldEnd() end)
                    
                    if typeof(fireproximityprompt) == "function" then 
                        pcall(function() fireproximityprompt(bunnyPrompt) end)
                    end

                    bunnyPrompt.RequiresLineOfSight = oldLOS
                    bunnyPrompt.MaxActivationDistance = oldDist
                end)
                
                task.wait(0.5)
                isClaimingBunny = false
            end)
            return
        end
    end

    -- 3. Safe Spot
    if isSafeSpotEnabled and not isDashing and not isClaimingBunny then
        if (hrp.Position - SAFE_SPOT.Position).Magnitude > 1 then
            hrp.CFrame = SAFE_SPOT
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)


-- ====================================================================
-- 2. DAYTIME / MORNING TOGGLE
-- ====================================================================
local Lighting = game:GetService("Lighting")

local originalLightingData = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
    GlobalShadows = Lighting.GlobalShadows,
    Atmosphere = {},
    ColorCorrection = {},
    Sky = {}
}

GamePlayTab.createToggle("DayTime/Morning", "Toggles full brightness / removes darkness and red atmosphere", function(state)
    if state then
        originalLightingData.ClockTime = Lighting.ClockTime
        originalLightingData.Brightness = Lighting.Brightness
        originalLightingData.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLightingData.Ambient = Lighting.Ambient
        originalLightingData.GlobalShadows = Lighting.GlobalShadows

        pcall(function()
            Lighting.ClockTime = 14
            Lighting.Brightness = 3
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.Ambient = Color3.fromRGB(150, 150, 150)
            Lighting.GlobalShadows = false
            
            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("Atmosphere") then
                    originalLightingData.Atmosphere[child] = {Density = child.Density, Haze = child.Haze, Color = child.Color, Decay = child.Decay}
                    child.Density = 0
                    child.Haze = 0
                    child.Color = Color3.fromRGB(255, 255, 255)
                    child.Decay = Color3.fromRGB(255, 255, 255)
                elseif child:IsA("ColorCorrectionEffect") then
                    originalLightingData.ColorCorrection[child] = {TintColor = child.TintColor, Saturation = child.Saturation, Contrast = child.Contrast}
                    child.TintColor = Color3.fromRGB(255, 255, 255)
                    child.Saturation = 0.1
                    child.Contrast = 0.1
                elseif child:IsA("Sky") then
                    originalLightingData.Sky[child] = child.StarCount
                    child.StarCount = 0
                end
            end
        end)
        
        notify("Success", "DayTime Morning Enabled", 2.5, "success")
    else
        pcall(function()
            Lighting.ClockTime = originalLightingData.ClockTime
            Lighting.Brightness = originalLightingData.Brightness
            Lighting.OutdoorAmbient = originalLightingData.OutdoorAmbient
            Lighting.Ambient = originalLightingData.Ambient
            Lighting.GlobalShadows = originalLightingData.GlobalShadows
            
            for child, data in pairs(originalLightingData.Atmosphere) do
                if child and child.Parent then
                    child.Density = data.Density
                    child.Haze = data.Haze
                    child.Color = data.Color
                    child.Decay = data.Decay
                end
            end

            for child, data in pairs(originalLightingData.ColorCorrection) do
                if child and child.Parent then
                    child.TintColor = data.TintColor
                    child.Saturation = data.Saturation
                    child.Contrast = data.Contrast
                end
            end

            for child, starCount in pairs(originalLightingData.Sky) do
                if child and child.Parent then
                    child.StarCount = starCount
                end
            end
        end)

        notify("Info", "Original Darkness Restored", 2.5, "info")
    end
end)


-- ====================================================================
-- 3. ANTI-LAG / LOW GRAPHICS TOGGLE
-- ====================================================================
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local antilagConnection = nil
local originalSettings = {}

GraphicsTab.createToggle("Anti-Lag", "Boosts FPS by disabling shadows, particles, and heavy textures", function(state)
    if state then
        notify("Info", "Enabling FPS Boost...", 2, "info")

        local Terrain = Workspace:FindFirstChildWhichIsA("Terrain")
        if Terrain then
            originalSettings.WaterWaveSize = Terrain.WaterWaveSize
            originalSettings.WaterWaveSpeed = Terrain.WaterWaveSpeed
            originalSettings.WaterReflectance = Terrain.WaterReflectance
            originalSettings.WaterTransparency = Terrain.WaterTransparency
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

        originalSettings.GlobalShadows = Lighting.GlobalShadows
        originalSettings.FogEnd = Lighting.FogEnd
        originalSettings.FogStart = Lighting.FogStart
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9

        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                originalSettings[v] = {CastShadow = v.CastShadow, Material = v.Material, Reflectance = v.Reflectance}
                v.CastShadow = false
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                if originalSettings[v] == nil then originalSettings[v] = v.Transparency end
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                if originalSettings[v] == nil then originalSettings[v] = v.Lifetime end
                v.Lifetime = NumberRange.new(0)
            end
        end

        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then
                originalSettings[v] = v.Enabled
                v.Enabled = false
            end
        end

        antilagConnection = Workspace.DescendantAdded:Connect(function(child)
            task.spawn(function()
                if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") or child:IsA("Beam") then
                    RunService.Heartbeat:Wait()
                    child:Destroy()
                elseif child:IsA("BasePart") then
                    child.CastShadow = false
                end
            end)
        end)

        notify("Success", "Anti-Lag Enabled: Graphics Optimized", 3, "success")
    else
        if antilagConnection then
            antilagConnection:Disconnect()
            antilagConnection = nil
        end

        local Terrain = Workspace:FindFirstChildWhichIsA("Terrain")
        if Terrain and originalSettings.WaterTransparency then
            Terrain.WaterWaveSize = originalSettings.WaterWaveSize
            Terrain.WaterWaveSpeed = originalSettings.WaterWaveSpeed
            Terrain.WaterReflectance = originalSettings.WaterReflectance
            Terrain.WaterTransparency = originalSettings.WaterTransparency
        end

        Lighting.GlobalShadows = originalSettings.GlobalShadows ~= nil and originalSettings.GlobalShadows or true
        Lighting.FogEnd = originalSettings.FogEnd ~= nil and originalSettings.FogEnd or 100000
        Lighting.FogStart = originalSettings.FogStart ~= nil and originalSettings.FogStart or 0

        for _, v in pairs(game:GetDescendants()) do
            if originalSettings[v] then
                if v:IsA("BasePart") then
                    v.CastShadow = originalSettings[v].CastShadow
                    v.Material = originalSettings[v].Material
                    v.Reflectance = originalSettings[v].Reflectance
                elseif v:IsA("Decal") then
                    v.Transparency = originalSettings[v]
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = originalSettings[v]
                end
            end
        end

        for _, v in pairs(Lighting:GetDescendants()) do
            if originalSettings[v] ~= nil and v:IsA("PostEffect") then
                v.Enabled = originalSettings[v]
            end
        end

        originalSettings = {}
        notify("Info", "Anti-Lag Disabled: Original Graphics Restored", 2, "info")
    end
end)






-- latest global chat updated


do
    local chatPage = pages["Global Chat"]
    for _, c in ipairs(chatPage:GetChildren()) do
        if c:IsA("UIListLayout") then c:Destroy() end
    end
    chatPage.ScrollingEnabled = false
    chatPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    chatPage.ScrollBarThickness = 0
    
  chatPage.Position = UDim2.new(0, 0, 0, 0)
chatPage.Size = UDim2.new(1, 0, 1, 0)

    local P = game:GetService("Players")
    local H = game:GetService("HttpService")
    local TS = game:GetService("TweenService")
    local MarketplaceService = game:GetService("MarketplaceService")
    local TeleportService = game:GetService("TeleportService")
    local L = P.LocalPlayer

-- Direktang kukunin ang totoong pangalan ng laro gamit ang MarketplaceService
local MarketplaceService = game:GetService("MarketplaceService")
local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
end)

-- Kung nag-success, kunin ang .Name, kung hindi, "Unknown Game" (pero walang ibang checks)
local GameName = success and info.Name or "Unknown Game"

    local I = {
        info="rbxassetid://124560466474914", reply="rbxassetid://109788633497028",
        send="rbxassetid://127751956873796", x="rbxassetid://110786993356448",
        minus="rbxassetid://118026365011536", hash="rbxassetid://82890331678520",
        shield="rbxassetid://110987169760162", ["message-square"]="rbxassetid://83881670383280",
        user="rbxassetid://81589895647169",
    }

    local C = {
        DB="https://global-chat-bb7ef-default-rtdb.asia-southeast1.firebasedatabase.app",
        Poll=1.5, Max=180, History=40, Cool=1.2, PresTTL=20,
    }

    local S = {
        Main=nil, Input=nil, List=nil, Status=nil, ReplyBar=nil, ReplyLabel=nil,
        Msgs={}, Seen={}, LastCount=0, LastSend=0, Order=0,
        Alive=false, Mode="global", PrivTarget=nil, Online={}, DMList={}, ReplyTo=nil,
        OnlineCount = 1,
        PopupReady = false,
    }

    local function normalizeRobloxAsset(input)
        if not input or type(input) ~= "string" then return nil end
        local s = input:gsub("%s", "")
        if s == "" then return nil end
        if s:match("^%d+$") then return "rbxassetid://" .. s end
        local id = s:match("^rbxassetid://(%d+)")
        if id then return "rbxassetid://" .. id end
        id = s:match("^rbxassetid:(%d+)$")
        if id then return "rbxassetid://" .. id end
        id = s:match("roblox%.com/asset/?%?id=(%d+)")
        if id then return "rbxassetid://" .. id end
        id = s:match("roblox%.com/library/(%d+)")
        if id then return "rbxassetid://" .. id end
        id = s:match("roblox%.com/catalog/(%d+)")
        if id then return "rbxassetid://" .. id end
        return nil
    end

    local function getClipboardText()
        if type(getclipboard) == "function" then
            local ok, r = pcall(getclipboard)
            if ok and r then return tostring(r) end
        end
        if type(syn) == "table" and type(syn.get_clipboard) == "function" then
            local ok, r = pcall(syn.get_clipboard)
            if ok and r then return tostring(r) end
        end
        if type(fluxus) == "table" and type(fluxus.getclipboard) == "function" then
            local ok, r = pcall(fluxus.getclipboard)
            if ok and r then return tostring(r) end
        end
        return ""
    end

    local popupQueue = {}
    local popupActive = false

    local function ShowMentionPopup(title, subtitle, accentColor)
        table.insert(popupQueue, {t=title, s=subtitle, c=accentColor or Color3.fromRGB(88,101,242)})
        if popupActive then return end
        task.spawn(function()
            popupActive = true
            while #popupQueue > 0 do
                local data = table.remove(popupQueue, 1)
                local popup = Instance.new("Frame")
                popup.Size = UDim2.new(0, 340, 0, 56)
                popup.Position = UDim2.new(0.5, -170, 0, -80)
                popup.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
                popup.BackgroundTransparency = 1
                popup.BorderSizePixel = 0
                popup.ZIndex = 2000
                popup.Parent = screenGui

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 10)
                corner.Parent = popup
                local stroke = Instance.new("UIStroke")
                stroke.Color = data.c; stroke.Thickness = 1.5
                stroke.Transparency = 1; stroke.Parent = popup

                local accent = Instance.new("Frame")
                accent.Size = UDim2.new(0, 4, 1, -16)
                accent.Position = UDim2.new(0, 0, 0, 8)
                accent.BackgroundColor3 = data.c
                accent.BorderSizePixel = 0
                accent.ZIndex = 2001
                accent.Parent = popup
                Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 2)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -24, 0, 22)
                titleLbl.Position = UDim2.new(0, 14, 0, 8)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = data.t
                titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                titleLbl.Font = Enum.Font.GothamBold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
                titleLbl.TextTransparency = 1
                titleLbl.ZIndex = 2001
                titleLbl.Parent = popup

                local subLbl = Instance.new("TextLabel")
                subLbl.Size = UDim2.new(1, -24, 0, 18)
                subLbl.Position = UDim2.new(0, 14, 0, 30)
                subLbl.BackgroundTransparency = 1
                subLbl.Text = data.s or ""
                subLbl.TextColor3 = Color3.fromRGB(180, 185, 195)
                subLbl.Font = Enum.Font.Gotham
                subLbl.TextSize = 11
                subLbl.TextXAlignment = Enum.TextXAlignment.Left
                subLbl.TextTruncate = Enum.TextTruncate.AtEnd
                subLbl.TextTransparency = 1
                subLbl.ZIndex = 2001
                subLbl.Parent = popup

                local tIn = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                TweenService:Create(popup, tIn, {Position = UDim2.new(0.5, -170, 0, 20), BackgroundTransparency = 0}):Play()
                TweenService:Create(stroke, tIn, {Transparency = 0.2}):Play()
                TweenService:Create(accent, tIn, {BackgroundTransparency = 0}):Play()
                TweenService:Create(titleLbl, tIn, {TextTransparency = 0}):Play()
                TweenService:Create(subLbl, tIn, {TextTransparency = 0}):Play()

                task.wait(4)

                local tOut = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                TweenService:Create(popup, tOut, {Position = UDim2.new(0.5, -170, 0, -80), BackgroundTransparency = 1}):Play()
                TweenService:Create(stroke, tOut, {Transparency = 1}):Play()
                TweenService:Create(accent, tOut, {BackgroundTransparency = 1}):Play()
                TweenService:Create(titleLbl, tOut, {TextTransparency = 1}):Play()
                TweenService:Create(subLbl, tOut, {TextTransparency = 1}):Play()
                task.wait(0.3)
                if popup and popup.Parent then popup:Destroy() end
            end
            popupActive = false
        end)
    end

local function showProfilePopup(data)
    local panel = S.ProfilePanel
    if not panel then return end
    
    panel:ClearAllChildren()

    -- Background Gradient
    panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local pGrad = Instance.new("UIGradient")
    pGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    pGrad.Rotation = 90
    pGrad.Parent = panel
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

    -- Close Button (X) - Nasa pinakataas
    local closeX = Instance.new("TextButton")
    closeX.Size = UDim2.fromOffset(28, 28)
    closeX.Position = UDim2.new(1, -38, 0, 15)
    closeX.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeX.Text = "X"
    closeX.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeX.Font = Enum.Font.GothamBold
    closeX.TextSize = 12
    closeX.AutoButtonColor = true
    closeX.ZIndex = 22
    closeX.Parent = panel
    Instance.new("UICorner", closeX).CornerRadius = UDim.new(1, 0)

    closeX.MouseButton1Click:Connect(function()
        TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, 0)
        }):Play()
    end)

    -- =====================================================================
    -- TOP ROW (Avatar + Join Button)
    -- =====================================================================
    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, -40, 0, 64)
    topRow.Position = UDim2.new(0, 20, 0, 40) -- Inadjust pababa ng konti
    topRow.BackgroundTransparency = 1
    topRow.ZIndex = 21
    topRow.Parent = panel

    -- Profile Icon
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(64, 64)
    avatar.Position = UDim2.new(0, 0, 0, 0)
    avatar.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
    avatar.BorderSizePixel = 0
    avatar.Image = ""
    avatar.ZIndex = 22
    avatar.Parent = topRow
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    
    local aStroke = Instance.new("UIStroke")
    aStroke.Color = Color3.fromRGB(60, 60, 60)
    aStroke.Thickness = 2
    aStroke.Parent = avatar

    if data.userId and data.userId > 0 then
        task.spawn(function()
            local ok, url = pcall(P.GetUserThumbnailAsync, P, data.userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            if ok and url and avatar.Parent then avatar.Image = url end
        end)
    end

    -- Join Button (Nilagyan ng Stroke at inayos ang posisyon)
    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.fromOffset(90, 34)
    joinBtn.Position = UDim2.new(1, 0, 1, 0) -- Nakaposisyon sa ilalim ng topRow para hindi umabot sa X
    joinBtn.AnchorPoint = Vector2.new(1, 1)
    joinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    joinBtn.Text = "JOIN GAME"
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.TextSize = 12
    joinBtn.AutoButtonColor = false
    joinBtn.ZIndex = 22
    joinBtn.Parent = topRow
    
    Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 6)
    
    -- [BAGONG DAGDAG] Stroke para sa Join Button
    local jStroke = Instance.new("UIStroke")
    jStroke.Color = Color3.fromRGB(80, 80, 80)
    jStroke.Thickness = 1
    jStroke.Parent = joinBtn

    joinBtn.MouseEnter:Connect(function()
        TweenService:Create(jStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 150, 150)}):Play()
    end)
    joinBtn.MouseLeave:Connect(function()
        TweenService:Create(jStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 80)}):Play()
    end)

    joinBtn.MouseButton1Click:Connect(function()
        if data.placeId and data.jobId and tostring(data.jobId) ~= "Not Available" then
            local ok = pcall(function()
                TeleportService:TeleportToPlaceInstance(tonumber(data.placeId), tostring(data.jobId), L)
            end)
            if not ok then notify("Teleport Failed", "Executor blocked the teleport.") end
        elseif data.placeId then
            local ok = pcall(function()
                TeleportService:Teleport(tonumber(data.placeId), L)
            end)
            if not ok then notify("Teleport Failed", "Could not join the game.") end
        else
            notify("Cannot Join", "This message is old.")
        end
    end)

    -- =====================================================================
    -- NAME (Below Icon)
    -- =====================================================================
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -40, 0, 24)
    nameLbl.Position = UDim2.new(0, 20, 0, 115) -- Inadjust pababa
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = "@" .. tostring(data.name or "?")
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 18
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 21
    nameLbl.Parent = panel
    
    local nGrad = Instance.new("UIGradient")
    nGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100)),
    }
    nGrad.Parent = nameLbl

    -- =====================================================================
    -- INFO CARD (Compact)
    -- =====================================================================
    local infoCard = Instance.new("Frame")
    infoCard.Size = UDim2.new(1, -40, 0, 80) -- Dinagdagan ng konting height para sa gradient text
    infoCard.Position = UDim2.new(0, 20, 0, 150)
    infoCard.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    infoCard.BorderSizePixel = 0
    infoCard.ZIndex = 21
    infoCard.Parent = panel
    Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 8)
    
    local icStroke = Instance.new("UIStroke")
    icStroke.Color = Color3.fromRGB(50, 50, 50)
    icStroke.Thickness = 1
    icStroke.Parent = infoCard

    local icPad = Instance.new("UIPadding")
    icPad.PaddingTop = UDim.new(0, 10)
    icPad.PaddingBottom = UDim.new(0, 10)
    icPad.PaddingLeft = UDim.new(0, 12)
    icPad.PaddingRight = UDim.new(0, 12)
    icPad.Parent = infoCard
    
    local icLayout = Instance.new("UIListLayout")
    icLayout.Padding = UDim.new(0, 4)
    icLayout.SortOrder = Enum.SortOrder.LayoutOrder
    icLayout.Parent = infoCard

    local function infoRow(labelText, valueText, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 12)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(140, 145, 155)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.ZIndex = 22
        lbl.Parent = infoCard

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, 0, 0, 16)
        val.BackgroundTransparency = 1
        val.Text = tostring(valueText or "N/A")
        val.TextColor3 = Color3.fromRGB(255, 255, 255) -- Base white
        val.Font = Enum.Font.GothamMedium
        val.TextSize = 12
        val.TextXAlignment = Enum.TextXAlignment.Left
        val.TextTruncate = Enum.TextTruncate.AtEnd
        val.LayoutOrder = order + 1
        val.ZIndex = 22
        val.Parent = infoCard
        
        -- [BAGONG DAGDAG] Gradient sa Values ng Info para maging colorful
        local vGrad = Instance.new("UIGradient")
        vGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
        }
        vGrad.Parent = val
    end

    infoRow("GAME NAME", tostring(data.gameName or "Unknown Game"), 1)
    infoRow("JOB ID", data.jobId and tostring(data.jobId) or "Not Available", 3)

    -- I-slide pabalik sa screen
    TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
end

    local function showImageDialog(imageUrl)
        local backdrop = Instance.new("TextButton")
        backdrop.Size = UDim2.new(1, 0, 1, 0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency = 0.6
        backdrop.Text = ""
        backdrop.AutoButtonColor = false
        backdrop.ZIndex = 500
        backdrop.Parent = screenGui

        local dialog = Instance.new("Frame")
        dialog.Size = UDim2.new(0, 480, 0, 380)
        dialog.Position = UDim2.new(0.5, -240, 0.5, -190)
        dialog.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        dialog.BorderSizePixel = 0
        dialog.ZIndex = 501
        dialog.Parent = screenGui
        Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 12)
        local dStroke = Instance.new("UIStroke")
        dStroke.Color = Color3.fromRGB(88, 101, 242)
        dStroke.Thickness = 1.5
        dStroke.Transparency = 0.3
        dStroke.Parent = dialog

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, -24, 1, -72)
        img.Position = UDim2.new(0, 12, 0, 12)
        img.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        img.BorderSizePixel = 0
        img.Image = imageUrl
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 502
        img.Parent = dialog
        Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)

        local function destroy()
            if backdrop and backdrop.Parent then backdrop:Destroy() end
            if dialog and dialog.Parent then dialog:Destroy() end
        end
        backdrop.MouseButton1Click:Connect(destroy)

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 100, 0, 32)
        closeBtn.Position = UDim2.new(0.5, -50, 1, -42)
        closeBtn.BackgroundColor3 = Color3.fromRGB(60, 63, 70)
        closeBtn.Text = "Close"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 12
        closeBtn.AutoButtonColor = true
        closeBtn.ZIndex = 503
        closeBtn.Parent = dialog
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
        closeBtn.MouseButton1Click:Connect(destroy)

        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 110, 0, 32)
        copyBtn.Position = UDim2.new(1, -122, 1, -42)
        copyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        copyBtn.Text = "Copy ID"
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 12
        copyBtn.AutoButtonColor = true
        copyBtn.ZIndex = 503
        copyBtn.Parent = dialog
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
        copyBtn.MouseButton1Click:Connect(function()
            local id = imageUrl:match("(%d+)")
            if setclipboard then pcall(setclipboard, id or imageUrl)
            elseif toclipboard then pcall(toclipboard, id or imageUrl)
            elseif type(syn) == "table" and syn.write_clipboard then pcall(syn.write_clipboard, id or imageUrl) end
            notify("IOHUB", "Asset ID copied!", 2)
        end)
    end

    local function showOnlinePlayersDialog(others)
        local backdrop = Instance.new("TextButton")
        backdrop.Size = UDim2.new(1, 0, 1, 0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency = 0.45
        backdrop.Text = ""
        backdrop.AutoButtonColor = false
        backdrop.ZIndex = 500
        backdrop.Parent = screenGui

        local dialog = Instance.new("Frame")
        dialog.Size = UDim2.new(0, 340, 0, 360)
        dialog.Position = UDim2.new(0.5, -170, 0.5, -180)
        dialog.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        dialog.BorderSizePixel = 0
        dialog.ZIndex = 501
        dialog.Parent = screenGui
        Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 12)
        local dStroke = Instance.new("UIStroke")
        dStroke.Color = Color3.fromRGB(88, 101, 242)
        dStroke.Thickness = 1.5
        dStroke.Transparency = 0.3
        dStroke.Parent = dialog

        local dTitle = Instance.new("TextLabel")
        dTitle.Size = UDim2.new(1, -60, 0, 32)
        dTitle.Position = UDim2.new(0, 14, 0, 12)
        dTitle.BackgroundTransparency = 1
        dTitle.Text = "Online Players ("..(1 + #others)..")"
        dTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        dTitle.Font = Enum.Font.GothamBold
        dTitle.TextSize = 16
        dTitle.TextXAlignment = Enum.TextXAlignment.Left
        dTitle.ZIndex = 502
        dTitle.Parent = dialog

        local closeX = Instance.new("TextButton")
        closeX.Size = UDim2.fromOffset(24, 24)
        closeX.Position = UDim2.new(1, -36, 0, 14)
        closeX.BackgroundColor3 = Color3.fromRGB(60, 62, 70)
        closeX.Text = "X"
        closeX.TextColor3 = Color3.fromRGB(230, 230, 230)
        closeX.Font = Enum.Font.GothamBold
        closeX.TextSize = 12
        closeX.AutoButtonColor = true
        closeX.ZIndex = 502
        closeX.Parent = dialog
        Instance.new("UICorner", closeX).CornerRadius = UDim.new(0, 6)

        local function destroy()
            if backdrop and backdrop.Parent then backdrop:Destroy() end
            if dialog and dialog.Parent then dialog:Destroy() end
        end
        closeX.MouseButton1Click:Connect(destroy)
        backdrop.MouseButton1Click:Connect(destroy)

        local listFrame = Instance.new("ScrollingFrame")
        listFrame.Size = UDim2.new(1, -28, 1, -110)
        listFrame.Position = UDim2.new(0, 14, 0, 50)
        listFrame.BackgroundTransparency = 1
        listFrame.BorderSizePixel = 0
        listFrame.ScrollBarThickness = 4
        listFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 82, 88)
        listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listFrame.ZIndex = 502
        listFrame.Parent = dialog

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = listFrame

        local function makePlayerCard(name, gameName, isMe, userId, order)
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 56)
            card.BackgroundColor3 = isMe and Color3.fromRGB(44, 46, 56) or Color3.fromRGB(36, 38, 46)
            card.BorderSizePixel = 0
            card.LayoutOrder = order
            card.ZIndex = 503
            card.Parent = listFrame
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            local cStroke = Instance.new("UIStroke")
            cStroke.Color = isMe and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(60, 62, 70)
            cStroke.Thickness = 1
            cStroke.Transparency = isMe and 0.4 or 0.5
            cStroke.Parent = card

            local avatar = Instance.new("ImageLabel")
            avatar.Size = UDim2.fromOffset(38, 38)
            avatar.Position = UDim2.new(0, 8, 0.5, -19)
            avatar.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
            avatar.BorderSizePixel = 0
            avatar.Image = ""
            avatar.ZIndex = 504
            avatar.Parent = card
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
            if userId and userId > 0 then
                task.spawn(function()
                    local ok, url = pcall(P.GetUserThumbnailAsync, P, userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    if ok and url and avatar.Parent then avatar.Image = url end
                end)
            end

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -62, 0, 18)
            nameLbl.Position = UDim2.new(0, 54, 0, 8)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = "@" .. name .. (isMe and " (You)" or "")
            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.ZIndex = 504
            nameLbl.Parent = card
            local nGrad = Instance.new("UIGradient")
            nGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 150)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
            }
            nGrad.Parent = nameLbl

            local gameLbl = Instance.new("TextLabel")
            gameLbl.Size = UDim2.new(1, -62, 0, 16)
            gameLbl.Position = UDim2.new(0, 54, 0, 28)
            gameLbl.BackgroundTransparency = 1
            gameLbl.Text = "🎮 " .. tostring(gameName or "Unknown Game")
            gameLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
            gameLbl.Font = Enum.Font.GothamMedium
            gameLbl.TextSize = 11
            gameLbl.TextXAlignment = Enum.TextXAlignment.Left
            gameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            gameLbl.ZIndex = 504
            gameLbl.Parent = card
            local gGrad = Instance.new("UIGradient")
            gGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
            }
            gGrad.Parent = gameLbl
        end

        makePlayerCard(L.Name, GameName, true, L.UserId, 0)
        for i, info in ipairs(others) do
            makePlayerCard(info.n or "?", info.g or "Unknown Game", false, tonumber(info.uid), i)
        end

        if #others == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 40)
            empty.BackgroundTransparency = 1
            empty.Text = "Walang ibang online users ngayon."
            empty.TextColor3 = Color3.fromRGB(150, 150, 160)
            empty.Font = Enum.Font.Gotham
            empty.TextSize = 12
            empty.LayoutOrder = 999
            empty.ZIndex = 504
            empty.Parent = listFrame
        end
    end

    local function Req()
        if type(request)=="function" then return request end
        if type(http_request)=="function" then return http_request end
        if type(syn)=="table" and type(syn.request)=="function" then return syn.request end
        if type(fluxus)=="table" and type(fluxus.request)=="function" then return fluxus.request end
        local ok,g=pcall(function() return type(getgenv)=="function" and getgenv() or nil end)
        if ok and type(g)=="table" then
            if type(g.request)=="function" then return g.request end
            if type(g.http_request)=="function" then return g.http_request end
        end
        return nil
    end

    local RQ = Req()

    local function Http(o)
        if not RQ then return nil, "no request" end
        local ok,r=pcall(RQ,o)
        if not ok or type(r)~="table" then return nil, tostring(r) end
        local s=tonumber(r.StatusCode or r.Status or r.status_code or r.status)
        local b=tostring(r.Body or r.body or r.Data or r.data or "")
        local suc=r.Success; if suc==nil then suc=r.success end
        if suc==false then return nil, "fail" end
        if s and s~=0 and (s<200 or s>=300) then return nil, "HTTP "..tostring(s) end
        return b
    end

    local function Enc(v)
        local ok,r=pcall(H.JSONEncode,H,v); return ok and r or "{}"
    end
    local function Dec(v)
        local ok,r=pcall(H.JSONDecode,H,v); return ok and r or nil
    end
    local function Url(v) return H:UrlEncode(tostring(v)) end
    local function Tw(o,t,p)
        return TS:Create(o,TweenInfo.new(t or 0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p)
    end

    local function AddBorder(obj,ic,oc,it,ot)
        local o=Instance.new("UIStroke"); o.Name="OuterStroke"
        o.Color=oc or Color3.fromRGB(88,101,242); o.Thickness=ot or 1.5
        o.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; o.Parent=obj
        local i=Instance.new("UIStroke"); i.Name="InnerStroke"
        i.Color=ic or Color3.fromRGB(0,0,0); i.Thickness=it or 1
        i.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; i.Parent=obj
        return o
    end

    local function BindBorder(btn,baseT,hoverT,clickT)
        baseT=baseT or 1.5; hoverT=hoverT or 2.4; clickT=clickT or 3
        local outer=btn:FindFirstChild("OuterStroke")
        if not outer then return end
        btn.MouseEnter:Connect(function() Tw(outer,0.1,{Thickness=hoverT}):Play() end)
        btn.MouseLeave:Connect(function() Tw(outer,0.1,{Thickness=baseT}):Play() end)
        btn.MouseButton1Down:Connect(function() Tw(outer,0.08,{Thickness=clickT}):Play() end)
        btn.MouseButton1Up:Connect(function() Tw(outer,0.08,{Thickness=hoverT}):Play() end)
    end

    local function RelTime(ts)
        local t=tonumber(ts) or 0
        if t>1e12 then t=math.floor(t/1000) end
        local d=os.time()-t
        if d<60 then return "just now"
        elseif d<3600 then return math.floor(d/60).."m"
        elseif d<86400 then return math.floor(d/3600).."h"
        else return os.date("%m/%d",t) end
    end

    local function fmtName(dn,un)
        dn,un=tostring(dn or "?"),tostring(un or "?")
        if dn:lower()==un:lower() then return dn end
        return dn.." (@"..un..")"
    end

    function S:_base() return C.DB:gsub("/+$","") end

    function S:_o(t,p)
        local o=Instance.new(t[1])
        for k,v in pairs(t[2] or {}) do o[k]=v end
        o.Parent=p
        return o
    end

    function S:_ico(name,size,col)
        local img=Instance.new("ImageLabel")
        img.BackgroundTransparency=1
        img.Size=UDim2.fromOffset(size or 14,size or 14)
        img.Image=I[name] or ""
        img.ImageColor3=col or Color3.new(1,1,1)
        img.ScaleType=Enum.ScaleType.Fit
        return img
    end

    function S:_notice(t,c)
        if not self.Status then return end
        self.Status.Text=t
        self.Status.TextColor3=c or Color3.fromRGB(160,165,175)
        local s=os.clock(); self._ns=s
        task.delay(2,function()
            if self.Alive and self._ns==s and self.Status then
                self.Status.Text="● Active Now ("..(self.OnlineCount or 1)..")"
                self.Status.TextColor3=Color3.new(1,1,1)
            end
        end)
    end

    function S:_bottom()
        task.defer(function()
            if self.List then
                self.List.CanvasPosition=Vector2.new(0,math.max(0,self.List.AbsoluteCanvasSize.Y-self.List.AbsoluteWindowSize.Y))
            end
        end)
    end

    function S:_isBottom()
        if not self.List then return true end
        local m=math.max(0,self.List.AbsoluteCanvasSize.Y-self.List.AbsoluteWindowSize.Y)
        return m-self.List.CanvasPosition.Y<70
    end

    function S:SetReply(d)
        self.ReplyTo=d
        if self.ReplyBar and self.ReplyLabel then
            if d then
                self.ReplyBar.Visible=true
                self.ReplyLabel.Text="Reply: @"..(d.Username or d.username or "?")
            else
                self.ReplyBar.Visible=false
            end
        end
    end

    function S:ShowOnlineList()
    if not self.ActivePanel then return end
    
    -- Linisin ang lumang listahan
    for _, child in ipairs(self.ActivePanel:GetChildren()) do
        if child:IsA("ScrollingFrame") then child:Destroy() end
    end

    local others = {}
    for _, info in pairs(self.Online or {}) do
        table.insert(others, info)
    end
    table.sort(others, function(a, b) return (a.n or "") < (b.n or "") end)

    -- Gumawa ng ScrollingFrame
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -20, 1, -70) 
    listFrame.Position = UDim2.new(0, 10, 0, 55)
    listFrame.BackgroundTransparency = 1
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 0 -- [INAYOS] GINAWANG 0 PARA HINDI KITA
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.ZIndex = 12
    listFrame.Parent = self.ActivePanel

    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingLeft = UDim.new(0, 4)
    listPadding.PaddingRight = UDim.new(0, 4)
    listPadding.PaddingTop = UDim.new(0, 4)
    listPadding.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6) -- [INAYOS] Ginawang 6 lang para hindi masikip
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    -- Function para gumawa ng player card
    local function makePlayerCard(name, gameName, isMe, userId, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 52) -- [INAYOS] Height 52 (dating 60)
        card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.ZIndex = 13
        card.Parent = listFrame
        
        local cCorner = Instance.new("UICorner", card)
        cCorner.CornerRadius = UDim.new(0, 8)
        
        local cardGrad = Instance.new("UIGradient")
        if isMe then
            cardGrad.Color = ColorSequence.new(Color3.fromRGB(40, 45, 60), Color3.fromRGB(25, 30, 45))
        else
            cardGrad.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(22, 22, 22))
        end
        cardGrad.Rotation = 90
        cardGrad.Parent = card

        local cStroke = Instance.new("UIStroke", card)
        cStroke.Color = isMe and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(55, 55, 55)
        cStroke.Thickness = 1
        cStroke.Transparency = 0.5

        local avatar = Instance.new("ImageLabel")
        avatar.Size = UDim2.fromOffset(36, 36) -- [INAYOS] 36x36 (dating 40x40)
        avatar.Position = UDim2.new(0, 8, 0.5, -18)
        avatar.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
        avatar.BorderSizePixel = 0
        avatar.Image = ""
        avatar.ZIndex = 14
        avatar.Parent = card
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
        
        if userId and userId > 0 then
            task.spawn(function()
                local ok, url = pcall(P.GetUserThumbnailAsync, P, userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                if ok and url and avatar.Parent then avatar.Image = url end
            end)
        end

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -55, 0, 16)
        nameLbl.Position = UDim2.new(0, 52, 0, 8) 
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "@" .. name .. (isMe and " (You)" or "")
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 12 -- [INAYOS] 12 (dating 13)
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex = 14
        nameLbl.Parent = card

        local gameLbl = Instance.new("TextLabel")
        gameLbl.Size = UDim2.new(1, -55, 0, 14)
        gameLbl.Position = UDim2.new(0, 52, 0, 26)
        gameLbl.BackgroundTransparency = 1
        gameLbl.Text = "🎮 " .. tostring(gameName or "Unknown Game")
        gameLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
        gameLbl.Font = Enum.Font.GothamMedium
        gameLbl.TextSize = 10 -- [INAYOS] 10 (dating 11)
        gameLbl.TextXAlignment = Enum.TextXAlignment.Left
        gameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        gameLbl.ZIndex = 14
        gameLbl.Parent = card
    end

    makePlayerCard(L.Name, GameName, true, L.UserId, 0)
    for i, info in ipairs(others) do
        makePlayerCard(info.n or "?", info.g or "Unknown Game", false, tonumber(info.uid), i)
    end
    
    TweenService:Create(self.ActivePanel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
end

    function S:_postMessage(body)
        local path = self:_base() .. "/public_chat.json"
        local ok = false
        local res = select(1, Http({Url=path, Method="POST", Headers={["Content-Type"]="application/json"}, Body=Enc(body)}))
        if res then ok = true end
        if not ok then
            local id = tostring(L.UserId).."_"..tostring(os.time()).."_"..tostring(math.random(10000,99999))
            res = select(1, Http({Url=path:gsub("%.json$","").."/"..Url(id)..".json", Method="PUT", Headers={["Content-Type"]="application/json"}, Body=Enc(body)}))
            ok = res ~= nil
        end
        return ok
    end

    function S:SendImage(imageInput)
        local normalized = normalizeRobloxAsset(imageInput)
        if not normalized then
            self:_notice("Roblox asset ID lang ang pwede", Color3.fromRGB(237, 66, 69))
            return false
        end
        if os.clock() - self.LastSend < C.Cool then
            self:_notice("Slow down!", Color3.fromRGB(237, 66, 69))
            return false
        end
        self.LastSend = os.clock()

        local body = {
            sender = L.Name, Username = L.Name, DisplayName = L.DisplayName,
            msg = "[image]", Text = "[image]",
            imageUrl = normalized,
            userId = L.UserId, UserId = L.UserId,
            time = os.time(), timestamp = os.time(),
            gameName = GameName, JobId = game.JobId, PlaceId = game.PlaceId,
        }
        if self.ReplyTo then
            body.replyUser = fmtName(self.ReplyTo.DisplayName, self.ReplyTo.Username)
            body.replyText = tostring(self.ReplyTo.Text or ""):sub(1, 40)
            body.replyTo = self.ReplyTo.Id
            body.replyToUserId = self.ReplyTo.UserId
        end

        if not self:_postMessage(body) then
            self:_notice("Image send failed", Color3.fromRGB(237, 66, 69))
            return false
        end

        self:NewMessage(body)
        self.LastCount = self.LastCount + 1
        self:SetReply(nil)
        return true
    end

    function S:NewMessage(d)
        if not self.Alive or not self.List then return end
        if type(d)~="table" then return end
        local id=tostring(d.Id or d.id or d._key or "")
        local uid=tonumber(d.UserId or d.userId or d.userId or 0) or 0
        local un=tostring(d.Username or d.username or d.sender or "?")
        local raw=tostring(d.Text or d.text or d.msg or "")
        local ts=tonumber(d.timestamp or d.time or 0) or 0
        local gName=tostring(d.gameName or d.GameName or "Unknown Game")
        local msgPlaceId=d.PlaceId or d.placeId
        local msgJobId=d.JobId or d.jobId

        local msgImageUrl = ""
        local rawImageField = tostring(d.imageUrl or d.ImageUrl or "")
        if rawImageField ~= "" then
            msgImageUrl = normalizeRobloxAsset(rawImageField) or ""
        end
        if msgImageUrl == "" then
            local auto = normalizeRobloxAsset(raw)
            if auto then msgImageUrl = auto end
        end

        if #raw>C.Max then raw=raw:sub(1,C.Max).."…" end

        local fp=tostring(uid).."|"..tostring(ts).."|"..raw:sub(1,40)
        if (id~="" and self.Seen[id]) or self.Seen[fp] then
            if id~="" then self.Seen[id]=true end
            self.Seen[fp]=true
            return
        end
        if id~="" then self.Seen[id]=true end
        self.Seen[fp]=true

        local stick=self:_isBottom()
        self.Order=self.Order+1
        local mine=(uid==L.UserId) or (un:lower()==L.Name:lower())

        if self.PopupReady then
    local isEveryoneMsg = raw:lower():find("@everyone", 1, true) ~= nil
    local replyTargetUid = tonumber(d.replyToUserId or 0) or 0
    local replyToMe = (replyTargetUid > 0 and replyTargetUid == L.UserId)

    -- Gagamitin na natin yung custom notify() mo
    if isEveryoneMsg and not mine then
        notify("@everyone Mention", "@"..un..": "..raw:sub(1, 40).."...", 4, "warning")
    end
    
    if replyToMe then
        local preview
        if msgImageUrl ~= "" then
            preview = "📷 Sent you an image"
        elseif raw ~= "" then
            preview = '"'..raw:sub(1, 40)..'"'
        else
            preview = "Replied to your message"
        end
        notify("New Reply", "@"..un.." replied:\n"..preview, 4, "info")
    end
end

        local wrap=self:_o({"Frame",{
            Size=UDim2.new(1,-2,0,0),AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=self.Order
        }},self.List)

        local row=self:_o({"Frame",{
    Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
    BackgroundColor3=Color3.fromRGB(255,255,255), -- Base white
    BorderSizePixel=0
}},wrap)
self:_o({"UICorner",{CornerRadius=UDim.new(0,6)}},row)

-- Gradient para sa Message Bubbles
local rowGrad = Instance.new("UIGradient")
if mine then
    -- Sariling message (Medyo mas maliwanag at blue-ish)
    rowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 32, 45))
    })
else
    -- Iba pang tao (Dark gray)
    rowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22))
    })
end
rowGrad.Rotation = 90
rowGrad.Parent = row

local stroke=Instance.new("UIStroke")
stroke.Color=mine and Color3.fromRGB(88,101,242) or Color3.fromRGB(60,60,60)
stroke.Thickness=1
stroke.Transparency=mine and 0.6 or 0.7
stroke.Parent=row
        

        self:_o({"UIPadding",{
            PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),
            PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)
        }},row)
        
        self:_o({"UIListLayout",{
            FillDirection=Enum.FillDirection.Vertical,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder
        }},row)

        local lo=0
        if d.replyUser or d.replyText then
            lo=lo+1
            local rq=self:_o({"Frame",{
                Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Color3.fromRGB(48,50,56),BorderSizePixel=0,LayoutOrder=lo
            }},row)
            self:_o({"UICorner",{CornerRadius=UDim.new(0,4)}},rq)
            self:_o({"UIPadding",{
                PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,3),
                PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,4)
            }},rq)
            self:_o({"TextLabel",{
                Size=UDim2.new(1,-4,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
                Text=tostring(d.replyUser or "?").."\n"..tostring(d.replyText or ""):sub(1,50),
                TextColor3=Color3.fromRGB(160,170,190),Font=Enum.Font.Gotham,TextSize=10,
                TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left
            }},rq)
        end

        lo=lo+1
        local mainContainer = self:_o({"Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=lo}},row)
        self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Top}},mainContainer)

        -- ✅ PINALIT: Avatar size 28x28 (dating 36x36)
        local av = self:_o({"ImageButton",{
            Size=UDim2.fromOffset(28,28),BackgroundColor3=Color3.fromRGB(47,49,54),BorderSizePixel=0,Image="",LayoutOrder=1,
            AutoButtonColor=false
        }},mainContainer)
        self:_o({"UICorner",{CornerRadius=UDim.new(1,0)}},av)
        if uid>0 then
            task.spawn(function()
                local ok,url=pcall(P.GetUserThumbnailAsync,P,uid,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
                if ok and url and av.Parent then av.Image=url end
            end)
        end

        local function OpenProfilePopup()
            showProfilePopup({
                name = un, gameName = gName,
                placeId = msgPlaceId, jobId = msgJobId,
                userId = uid,
            })
        end

        av.MouseButton1Click:Connect(OpenProfilePopup)

        -- ✅ PINALIT: Content width -36 (dating -44)
        local contentColumn = self:_o({"Frame",{Size=UDim2.new(1,-36,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=2}},mainContainer)
        self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Vertical,Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder}},contentColumn)

        local headerRow = self:_o({"Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,LayoutOrder=1}},contentColumn)
        local leftHeader = self:_o({"Frame",{Size=UDim2.new(1,-50,1,0),BackgroundTransparency=1}},headerRow)
        self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center}},leftHeader)

      local userLabel = self:_o({"TextButton",{
            Size=UDim2.new(0, 90, 1, 0), -- Fixed width para hindi lumampas
            BackgroundTransparency=1,Text="@"..un,TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false,LayoutOrder=1,
            TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd
        }},leftHeader)
        
        
        local uGrad = Instance.new("UIGradient")
        uGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100))}
        uGrad.Parent = userLabel
        userLabel.MouseButton1Click:Connect(OpenProfilePopup)

        self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="|",TextColor3=Color3.fromRGB(150,150,150),Font=Enum.Font.Gotham,TextSize=12,LayoutOrder=2}},leftHeader)

        -- ✅ PINALIT: TextSize 12 (dating 13)
        local gameLabel = self:_o({"TextLabel",{
            Size=UDim2.new(1, -100, 1, 0), -- Kakainin yung natitirang space
            BackgroundTransparency=1,Text=gName,TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.GothamBold,TextSize=12,LayoutOrder=3,
            TextTruncate=Enum.TextTruncate.AtEnd, TextXAlignment=Enum.TextXAlignment.Left
        }},leftHeader)
        local gGrad = Instance.new("UIGradient")
        gGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))}
        gGrad.Parent = gameLabel

        local rightHeader = self:_o({"Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.fromOffset(50,20),BackgroundTransparency=1}},headerRow)
        self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Center}},rightHeader)

        local replyBtn = self:_o({"ImageButton",{Size=UDim2.fromOffset(14,14),BackgroundTransparency=1,Image=I.reply,ImageColor3=Color3.fromRGB(130,135,145),AutoButtonColor=false,LayoutOrder=1}},rightHeader)
        replyBtn.MouseButton1Click:Connect(function()
            self:SetReply({Id=id,Username=un,DisplayName=un,Text=raw,UserId=uid})
        end)
        replyBtn.MouseEnter:Connect(function() replyBtn.ImageColor3=Color3.fromRGB(88,150,255) end)
        replyBtn.MouseLeave:Connect(function() replyBtn.ImageColor3=Color3.fromRGB(130,135,145) end)

        self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=RelTime(ts),TextColor3=Color3.fromRGB(120,125,135),Font=Enum.Font.Gotham,TextSize=10,LayoutOrder=2}},rightHeader)

        -- ✅ PINALIT: TextSize 12 (dating 14)
        local txt=self:_o({"TextLabel",{
            Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
            Text=raw,TextColor3=Color3.fromRGB(235,235,235),Font=Enum.Font.GothamBold,TextSize=12,
            TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,LayoutOrder=2
        }},contentColumn)
        local chatStroke = Instance.new("UIStroke")
        chatStroke.Color = Color3.fromRGB(0, 0, 0)
        chatStroke.Thickness = 1.2
        chatStroke.Transparency = 0.3
        chatStroke.Parent = txt

        if msgImageUrl ~= "" then
            local imgBtn = Instance.new("ImageButton")
            imgBtn.Size = UDim2.new(1, 0, 0, 140) -- ✅ PINALIT: Height 140 (dating 170)
            imgBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            imgBtn.BorderSizePixel = 0
            imgBtn.Image = msgImageUrl
            imgBtn.ScaleType = Enum.ScaleType.Crop
            imgBtn.AutoButtonColor = false
            imgBtn.LayoutOrder = 3
            imgBtn.ClipsDescendants = true
            imgBtn.Parent = contentColumn
            Instance.new("UICorner", imgBtn).CornerRadius = UDim.new(0, 6)
            local iStroke = Instance.new("UIStroke")
            iStroke.Color = Color3.fromRGB(60, 62, 70)
            iStroke.Thickness = 1
            iStroke.Transparency = 0.5
            iStroke.Parent = imgBtn

            imgBtn.MouseEnter:Connect(function()
                TweenService:Create(imgBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
            end)
            imgBtn.MouseLeave:Connect(function()
                TweenService:Create(imgBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 15, 20)}):Play()
            end)
            imgBtn.MouseButton1Click:Connect(function()
                showImageDialog(msgImageUrl)
            end)

            if raw == "[image]" or raw == msgImageUrl then
                txt.Visible = false
            end
        end

        self.Msgs[#self.Msgs+1]=wrap
        while #self.Msgs>C.History+8 do
            local old=table.remove(self.Msgs,1)
            if old then pcall(function() old:Destroy() end) end
        end
        if stick then self:_bottom() end
    end

    function S:Clear()
        for i=#self.Msgs,1,-1 do
            local x=self.Msgs[i]
            if x then pcall(function() x:Destroy() end) end
            self.Msgs[i]=nil
        end
        for k in pairs(self.Seen) do self.Seen[k]=nil end
        self.LastCount=0
        self.Order=0
        self:SetReply(nil)
    end

    function S:_loadChat(full)
        local path=self:_base().."/public_chat.json"
        local body=Http({Url=path,Method="GET",Headers={["Content-Type"]="application/json"}})
        if not body or body=="" or body=="null" then return end
        local data=Dec(body)
        if type(data)~="table" then return end
        local list={}
        for k,v in pairs(data) do
            if type(v)=="table" then
                v._key=tostring(k); v.Id=tostring(k)
                if not v.Text and v.msg then v.Text=v.msg end
                if not v.Username and v.sender then v.Username=v.sender end
                if not v.UserId and v.userId then v.UserId=v.userId end
                if not v.timestamp and v.time then v.timestamp=v.time end
                list[#list+1]=v
            end
        end
        table.sort(list,function(a,b)
            return (tonumber(a.timestamp or a.time) or 0)<(tonumber(b.timestamp or b.time) or 0)
        end)
        if #list>C.History then
            local sliced={}
            for i=#list-C.History+1,#list do sliced[#sliced+1]=list[i] end
            list=sliced
        end
        if full then
            for _,v in ipairs(list) do self:NewMessage(v) end
            self.LastCount=#list; self:_bottom()
        else
            if #list>self.LastCount then
                for i=self.LastCount+1,#list do self:NewMessage(list[i]) end
                self.LastCount=#list
            elseif #list<self.LastCount then
                self:Clear()
                for _,v in ipairs(list) do self:NewMessage(v) end
                self.LastCount=#list
            end
        end
    end

    function S:Send(text)
        if os.clock()-self.LastSend<C.Cool then return false end
        text=tostring(text==nil and (self.Input and self.Input.Text or "") or text or "")
        text=text:gsub("\r",""):gsub("\0",""):gsub("^%s+",""):gsub("%s+$","")
        
        if text=="" then
            self:_notice("Type something",Color3.fromRGB(237,66,69))
            return false
        end


        local normalizedImage = normalizeRobloxAsset(text)
        if normalizedImage then
            if self.Input then self.Input.Text = "" end
            return self:SendImage(normalizedImage)
        end

        if #text>C.Max then
            text=text:sub(1,C.Max)
            self:_notice("Trimmed to "..C.Max,Color3.fromRGB(250,200,80))
        end
        self.LastSend=os.clock()
        if self.Input then self.Input.Text="" end

        local body={
            sender=L.Name, Username=L.Name, DisplayName=L.DisplayName,
            msg=text, Text=text, userId=L.UserId, UserId=L.UserId,
            time=os.time(), timestamp=os.time(),
            gameName=GameName, JobId=game.JobId, PlaceId=game.PlaceId
        }
        if self.ReplyTo then
            body.replyUser=fmtName(self.ReplyTo.DisplayName,self.ReplyTo.Username)
            body.replyText=tostring(self.ReplyTo.Text or ""):sub(1,40)
            body.replyTo=self.ReplyTo.Id
            body.replyToUserId=self.ReplyTo.UserId
        end

        if not self:_postMessage(body) then
            self:_notice("Send failed",Color3.fromRGB(237,66,69))
            return false
        end

        self:NewMessage(body)
        self.LastCount=self.LastCount+1
        self:SetReply(nil)
        return true
    end

    function S:_presence()
    -- [BAGONG DAGDAG] Hintayin makuha muna yung tamang pangalan ng laro bago mag-send
    if GameName == "Fetching..." then
        local timeout = 0
        repeat 
            task.wait(0.2) 
            timeout = timeout + 1
        until GameName ~= "Fetching..." or timeout > 25 or not self.Alive -- Max 5 seconds na hintay
    end

    pcall(function()
        Http({
            Url=self:_base().."/presence/"..Url(tostring(L.UserId))..".json",
            Method="PUT", Headers={["Content-Type"]="application/json"},
            Body=Enc({
                t=os.time(), n=L.Name, d=L.DisplayName,
                g=GameName, pid=game.PlaceId, jid=game.JobId,
            }),
        })
    end)
end

    function S:_cleanIfAlone()
        local body=select(1,Http({Url=self:_base().."/presence.json",Method="GET",Headers={["Content-Type"]="application/json"}}))
        if not body or body=="" or body=="null" then
            pcall(function() Http({Url=self:_base().."/public_chat.json",Method="DELETE"}) end)
            self:Clear(); return true
        end
        local d=Dec(body)
        if type(d)~="table" then return false end
        local now,any=os.time(),false
        self.Online={}
        local onlineCount = 1
        for uid,v in pairs(d) do
            if type(v)=="table" and tonumber(v.t) and (now-tonumber(v.t))<=C.PresTTL then
                any=true
                if tostring(uid)~=tostring(L.UserId) then
                    self.Online[tostring(uid)]={
                        n=tostring(v.n or "?"),
                        d=tostring(v.d or v.n or "?"),
                        t=v.t,
                        g=tostring(v.g or "Unknown Game"),
                        pid=v.pid, jid=v.jid,
                        uid=tonumber(uid),
                    }
                    onlineCount = onlineCount + 1
                end
            end
        end
        self.OnlineCount = onlineCount
        if self.Status then
            self.Status.Text = "● Active Now ("..onlineCount..")"
            self.Status.TextColor3 = Color3.new(1,1,1)
        end
        if not any then
            pcall(function() Http({Url=self:_base().."/public_chat.json",Method="DELETE"}) end)
            self:Clear(); return true
        end
        return false
    end

    function S:Destroy()
        self.Alive=false
        pcall(function()
            Http({Url=self:_base().."/presence/"..Url(tostring(L.UserId))..".json",Method="DELETE"})
        end)
        task.wait(0.3)
        pcall(function()
            local body=select(1,Http({Url=self:_base().."/presence.json",Method="GET",Headers={["Content-Type"]="application/json"}}))
            local alone=true
            if body and body~="" and body~="null" then
                local d=Dec(body)
                if type(d)=="table" then
                    local now=os.time()
                    for uid,v in pairs(d) do
                        if type(v)=="table" and tonumber(v.t) and (now-tonumber(v.t))<=C.PresTTL and tostring(uid)~=tostring(L.UserId) then
                            alone=false; break
                        end
                    end
                end
            end
            if alone then Http({Url=self:_base().."/public_chat.json",Method="DELETE"}) end
        end)
        if self.Main then pcall(function() self.Main:Destroy() end) end
        self.Main=nil
    end
 
    function S:Init()
        if self.Alive and self.Main then return self end
        self:Destroy()
        self.Alive=true
        self.PopupReady = false

        local container = pages["Global Chat"]
        local old = container:FindFirstChild("GlobalChatEmbedded")
        if old then old:Destroy() end

          local main=self:_o({"Frame",{
    Name="GlobalChatEmbedded",
    Size=UDim2.new(1, 0, 1, 0),
    Position=UDim2.new(0, 0, 0, 0),
    BackgroundColor3=Color3.fromRGB(255,255,255), -- Base white para sa gradient
    BorderSizePixel=0,ClipsDescendants=true
}},container)
self.Main=main
self:_o({"UICorner",{CornerRadius=UDim.new(0,12)}},main)


local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
})
mainGrad.Rotation = 90
mainGrad.Parent = main

local top=self:_o({"Frame",{
    Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,40),
    BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0
}},main)

local topGrad = Instance.new("UIGradient")
topGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
topGrad.Rotation = 90
topGrad.Parent = top


        local state=self:_o({"TextButton",{
            Position=UDim2.fromOffset(12,10),Size=UDim2.new(1,-24,0,20),
            BackgroundTransparency=1,
            Text="● Active Now (1)",TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.GothamBold,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,
            AutoButtonColor=false
        }},top)
        local statusGrad = Instance.new("UIGradient")
        statusGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
        }
        statusGrad.Parent = state
        self.Status = state
        state.MouseButton1Click:Connect(function() self:ShowOnlineList() end)
        state.MouseEnter:Connect(function()
            TweenService:Create(state, TweenInfo.new(0.15), {TextTransparency = 0.3}):Play()
        end)
        state.MouseLeave:Connect(function()
            TweenService:Create(state, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        end)

        local list=self:_o({"ScrollingFrame",{
            Position=UDim2.new(0,4,0,44),Size=UDim2.new(1,-8,1,-112),
            BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
            ScrollBarImageColor3=Color3.fromRGB(80,82,88),AutomaticCanvasSize=Enum.AutomaticSize.Y,
            CanvasSize=UDim2.fromScale(0,0),ScrollingDirection=Enum.ScrollingDirection.Y,ClipsDescendants=true
        }},main)
       self.List=list
self:_o({"UIPadding",{PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2)}},list)
self:_o({"UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder}},list)

-- [BAGONG DAGDAG] SLIDE PANEL PARA SA ACTIVE PLAYERS
local activePanel = self:_o({"Frame",{
    Name = "ActivePanel",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), -- PALITAN TO PUTI PARA LUMABAS GRADIENT
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 10
}}, main)

self:_o({"UICorner",{CornerRadius=UDim.new(0, 12)}},activePanel)

-- Ito yung gradient, kaya dapat puti yung base
local actGrad = Instance.new("UIGradient")
actGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 28)), -- Mas madilim na gray
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
})
actGrad.Rotation = 90
actGrad.Parent = activePanel
self.ActivePanel = activePanel



-- [BAGONG DAGDAG] PROFILE SLIDE PANEL
local profilePanel = self:_o({"Frame",{
    Name = "ProfilePanel",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(1, 0, 0, 0), -- Nakatago sa kanan
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 20 -- Mas mataas sa ActivePanel para hindi mag-overlap
}}, main)

self:_o({"UICorner",{CornerRadius=UDim.new(0, 12)}},profilePanel)

local pGrad = Instance.new("UIGradient")
pGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
})
pGrad.Rotation = 90
pGrad.Parent = profilePanel
self.ProfilePanel = profilePanel



-- PANSAMANTALANG AYUSIN: Ilagay natin yung UIStroke sa labas (hindi sa loob) para hindi magka-cube
-- Actually, yung UIStroke na may ApplyStrokeMode.Border minsan nagca-cause nito.
-- Pero dahil gradient at UICorner tayo, hayaan na natin walang UIStroke yung panel para super smooth.

-- Close Button sa Slide Panel
local closePanelBtn = self:_o({"TextButton",{
    Size=UDim2.fromOffset(30,30), Position=UDim2.new(1,-40,0,10),
    BackgroundColor3=Color3.fromRGB(50,50,50), Text="X", TextColor3=Color3.fromRGB(255,255,255),
    Font=Enum.Font.GothamBold, TextSize=14, ZIndex=11
}},activePanel)
self:_o({"UICorner",{CornerRadius=UDim.new(0,6)}},closePanelBtn)

closePanelBtn.MouseButton1Click:Connect(function()
    TweenService:Create(activePanel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 0, 0, 0) -- I-slide pabalik sa kanan
    }):Play()
end)

-- Title ng Slide Panel
self:_o({"TextLabel",{
    Size=UDim2.new(1,-60,0,30), Position=UDim2.new(0,15,0,10),
    BackgroundTransparency=1, Text="Active Players", TextColor3=Color3.fromRGB(255,255,255),
    Font=Enum.Font.GothamBold, TextSize=16, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11
}},activePanel)

        local replyBar=self:_o({"Frame",{
            AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,-52),Size=UDim2.new(1,0,0,22),
            BackgroundColor3=Color3.fromRGB(42,45,55),BorderSizePixel=0,Visible=false
        }},main)
        self.ReplyBar=replyBar
        local rI=self:_ico("reply",11,Color3.fromRGB(88,150,255))
        rI.Position=UDim2.fromOffset(6,5); rI.Parent=replyBar
        local rLab=self:_o({"TextLabel",{
            Position=UDim2.fromOffset(22,2),Size=UDim2.new(1,-48,1,-4),BackgroundTransparency=1,Text="",
            TextColor3=Color3.fromRGB(170,180,200),Font=Enum.Font.Gotham,TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd
        }},replyBar)
        self.ReplyLabel=rLab
        local rX=self:_o({"ImageButton",{
            AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-4,0.5,0),Size=UDim2.fromOffset(16,16),
            BackgroundTransparency=1,Image=I.x,ImageColor3=Color3.fromRGB(180,90,90),AutoButtonColor=false
        }},replyBar)
        rX.MouseButton1Click:Connect(function() self:SetReply(nil) end)

    -- =====================================================================
    -- BOTTOM BAR (Input & Send Button)
    -- =====================================================================
    local bottom=self:_o({"Frame",{
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,54), -- Pinalaki height
        BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0
    }},main)

    local botGrad = Instance.new("UIGradient")
    botGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    botGrad.Rotation = 90
    botGrad.Parent = bottom

    -- 1. GLASS INPUT BOX (Pill Shape)
    local input=self:_o({"TextBox",{
        Position=UDim2.fromOffset(10, 10), -- Margins
        Size=UDim2.new(1, -60, 0, 34), -- Height 34
        BackgroundColor3=Color3.fromRGB(40, 40, 40), 
        BackgroundTransparency=0.4, -- Glass effect (translucent)
        BorderSizePixel=0,
        ClearTextOnFocus=false,
        MultiLine=false,
        Text="",
        PlaceholderText="Message or Image ID...",
        PlaceholderColor3=Color3.fromRGB(150, 150, 150), 
        TextColor3=Color3.fromRGB(230,232,235),
        Font=Enum.Font.Gotham,
        TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center
    }},bottom)
    
    self.Input=input
    -- [BAGONG DAGDAG] Bilog na dulo (Pill shape)
    self:_o({"UICorner",{CornerRadius=UDim.new(1, 0)}},input)
    self:_o({"UIPadding",{PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14)}},input)

    -- [BAGONG DAGDAG] Faint Glass Stroke
    local inStroke = Instance.new("UIStroke")
    inStroke.Color = Color3.fromRGB(255, 255, 255)
    inStroke.Thickness = 1
    inStroke.Transparency = 0.85 -- Napaka-faint
    inStroke.Parent = input

    -- 2. SEND BUTTON (Icon Only)
    local send=self:_o({"ImageButton",{
        AnchorPoint=Vector2.new(1,0.5), 
        Position=UDim2.new(1,-10,0.5,0), -- Naka-center vertically sa kanan
        Size=UDim2.fromOffset(38, 38),
        BackgroundTransparency=1, -- WALANG BACKGROUND
        BorderSizePixel=0,
        Image=I.send,
        ImageColor3=Color3.fromRGB(100, 150, 255), -- Asul na icon
        ScaleType=Enum.ScaleType.Fit,
        AutoButtonColor=false
    }},bottom)
    
    self.SendBtn=send
    
    -- Hover effect
    send.MouseEnter:Connect(function()
        TweenService:Create(send, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(150, 180, 255)}):Play()
    end)
    send.MouseLeave:Connect(function()
        TweenService:Create(send, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(100, 150, 255)}):Play()
    end)
    
    send.MouseButton1Click:Connect(function() self:Send() end)
    input.FocusLost:Connect(function(e) if e then self:Send() end end)
    input.MouseEnter:Connect(function() self:_bottom() end)

    task.spawn(function()
        self:_presence()
        local alone=self:_cleanIfAlone()
        pcall(function() self:_loadChat(true) end)
        task.wait(0.5)
        self.PopupReady = true
        self:_notice(alone and "● Fresh" or "● Connected",Color3.fromRGB(87,242,135))
        local tick=0
        while self.Alive and self.Main and self.Main.Parent do
            tick=tick+1
            if tick%3==0 then
                self:_presence()
                self:_cleanIfAlone()
            end
            pcall(function() self:_loadChat(false) end)
            task.wait(C.Poll)
        end
    end)
    return self
end

        

    TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage, placeId, teleportOptions)
        if player == L then
            if teleportResult == Enum.TeleportResult.GameFull then
                notify("Server Is Full", "Cannot join the server. Please try again later.", 5)
            elseif teleportResult == Enum.TeleportResult.Fail then
                notify("Teleport Failed", tostring(errorMessage), 3)
            end
        end
    end)

    task.spawn(function()
        task.wait(0.5)
        S:Init()
    end)
end







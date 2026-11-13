-- V5

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


createSidebarTab("Main", "gem")
createSidebarTab("Section 1", "house")
createSidebarTab("Section 2", "house")
createSidebarTab("Section 3", "house")
createSidebarTab("Section 4", "house")
createSidebarTab("Section 5", "house")
createLeftUnderPanel("Setting", "wrench") 
createLeftUnderPanel("Global Chat", "rbxassetid://83881670383280") -- Palitan mo ng tamang chat icon name






local YenTab = {}
CreateHeaderDropdown("Main", "Yen", "circle-dollar")(YenTab)



local S1Tab = {}
CreateHeaderDropdown("Section 1", "Enzukai", "layout")(S1Tab)

local S11Tab = {}
CreateHeaderDropdown("Section 1", "Isamu's Workplace", "layout")(S11Tab)



local S2Tab = {}
CreateHeaderDropdown("Section 2", "Mall", "layout")(S2Tab)

local S2MiniTab = {}
CreateHeaderDropdown("Section 2", "Chihiro MiniGame", "layout")(S2MiniTab)


local S3Tab = {}
CreateHeaderDropdown("Section 3", "Temple", "layout")(S3Tab)


local S4Tab = {}
CreateHeaderDropdown("Section 4", "Tokyo", "layout")(S4Tab)

local S5StartTab = {}
CreateHeaderDropdown("Section 5", "Desolated Arena (Startup)", "layout")(S5StartTab)

local S5Tab = {}
CreateHeaderDropdown("Section 5", "Desolated Arena (Auto)", "layout")(S5Tab)

local S5ManualTab = {}
CreateHeaderDropdown("Section 5", "Desolated Arena (Manual)", "layout")(S5ManualTab)


local GamePlayTab = {}
CreateHeaderDropdown("Setting", "Game Play", "")(GamePlayTab)

local GraphicsTab = {}
CreateHeaderDropdown("Setting", "Graphics", "")(GraphicsTab)

local GlobalChatTab = {}
CreateHeaderDropdown("Global Chat", "Global Chat", "message-square")(GlobalChatTab)


switchTab("Main")









-- ====================================================================
-- YEN PATH RESOLVER (Bagong path: MimicCurrencySpawns | Old: Yen)
-- ====================================================================
local function getYenItems()
    local items = {}
    local seen = {}

    -- 🔍 Priority 1: Bagong path (MimicCurrencySpawns)
    local mcs = workspace:FindFirstChild("MimicCurrencySpawns")
    if mcs then
        -- Baka may "Yen" subfolder sa loob, o direkta ang YenCoin
        local yenSub = mcs:FindFirstChild("Yen")
        local scanContainer = yenSub or mcs
        for _, child in ipairs(scanContainer:GetChildren()) do
            if not seen[child] and (child.Name == "YenCoin" or string.find(string.lower(child.Name), "yen")) then
                seen[child] = true
                table.insert(items, child)
            end
        end
    end

    -- 🔍 Priority 2 (Fallback): Lumang path (Yen folder)
    local yenFolder = workspace:FindFirstChild("Yen")
    if yenFolder then
        for _, child in ipairs(yenFolder:GetChildren()) do
            if not seen[child] and (child.Name == "YenCoin" or string.find(string.lower(child.Name), "yen")) then
                seen[child] = true
                table.insert(items, child)
            end
        end
    end

    return items
end
-- ====================================================================
-- 1. DECLARE VARIABLE (Para hindi mag-error sa simula)
-- ====================================================================
_G.YenDetectActive = false

-- ====================================================================
-- 2. YEN DOUBLE CUBE (With MAX Support & Lag Prevention)
-- ====================================================================
YenTab.createDoubleCube({
    Left = {
        Icon     = "rbxassetid://87106715212007", 
        Label    = "MY YEN",
        TextColor = Color3.fromRGB(255, 197, 116),
        GetValue = function()
            -- 🛑 KAPAG NAKA-OFF, WAG MAG-SCAN
            if not _G.YenDetectActive then return "-" end 

            local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            local yenGui = pg and pg:FindFirstChild("Yen")
            local popout = yenGui and yenGui:FindFirstChild("Popout")
            local container = popout and popout:FindFirstChild("Container")
            local textContainer = container and container:FindFirstChild("TextContainer")
            local textLabel = textContainer and textContainer:FindFirstChild("Text")

            if textLabel and (textLabel:IsA("TextLabel") or textLabel:IsA("TextButton")) then
                if string.find(string.upper(textLabel.Text), "MAX") then
                    return "MAX"
                end
                return tonumber((textLabel.Text:gsub("[^%d]", ""))) or 0
            end
            return 0
        end
    },
    Right = {
    Icon     = "rbxassetid://87106715212007", 
    Label    = "SEC YEN",
    TextColor = Color3.fromRGB(255, 197, 116),
    GetValue = function()
        if not _G.YenDetectActive then return "-" end 
        return #getYenItems()   -- ✅ Gagamit na ng bagong path
    end
}
})

-- ====================================================================
-- 3. DETECT YEN STATS TOGGLE (Nasa ibaba na ng DoubleCube)
-- ====================================================================
YenTab.createToggle("Show Yen Count", "Enable to show Yen count & Wallet (prevents lag)", function(state)
    _G.YenDetectActive = state
    
    if not state then
        notify("Info", "Show Yen : OFF", 2, "info")
        return
    end
    
    notify("Success", "Show Yen : ON", 2, "success")
    
end)


-- ====================================================================
-- 4. ESP YEN (Gold Highlight + Name + Distance Tracker)
-- ====================================================================
local YenContainerName = "IOHUB_Yen_ESP"

local function addYenESPModel(yenItem, container, color)
    if not yenItem or not container then return end
    if not (yenItem:IsA("Model") or yenItem:IsA("BasePart")) then return end

    -- 1. Highlight
    if not yenItem:FindFirstChild("IOHUB_ESP_HL") then
        local hl = Instance.new("Highlight")
        hl.Name = "IOHUB_ESP_HL"
        hl.FillColor = color
        hl.FillTransparency = 0.4
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.Parent = yenItem
    end

    -- 2. Billboard + Name Label
    local anchor = yenItem:IsA("BasePart") and yenItem or yenItem.PrimaryPart or yenItem:FindFirstChildWhichIsA("BasePart")
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
            bb.Name = "YenESP_" .. yenItem.Name
            bb.Size = UDim2.new(0, 150, 0, 40)
            bb.AlwaysOnTop = true
            bb.ExtentsOffset = Vector3.new(0, 2, 0)
            bb.Adornee = anchor
            bb.Parent = container
            bb.MaxDistance = 10000

            local lbl = Instance.new("TextLabel")
            lbl.Name = "YenLabel"
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "💰 Yen" 
            lbl.TextColor3 = color
            lbl.TextSize = 14
            lbl.Font = Enum.Font.SourceSansBold
            lbl.TextStrokeTransparency = 0
            lbl.Parent = bb
        end
    end
end

YenTab.createToggle("Yen ESP", "Highlights scattered Yen items", function(state)
    _G.YenESP_Active = state
    local container = getContainer(YenContainerName)
    local COLOR = Color3.fromRGB(255, 215, 0)

    if state then
        for _, yen in ipairs(getYenItems()) do   -- ✅ Bagong path
            addYenESPModel(yen, container, COLOR)
        end

        task.spawn(function()
            while _G.YenESP_Active do
                task.wait(1)
                if not _G.YenESP_Active then break end
                for _, yen in ipairs(getYenItems()) do   -- ✅ Bagong path
                    addYenESPModel(yen, container, COLOR)
                end
            end
        end)

        notify("Success", "Yen ESP: ON", 2, "success")
    else
        -- Linisin ang HL kahit saan man naka-parent ang Yen
        for _, yen in ipairs(getYenItems()) do
            local hl = yen:FindFirstChild("IOHUB_ESP_HL")
            if hl then pcall(function() hl:Destroy() end) end
        end
        -- Fallback clean sa old folder kung may natira
        local oldFolder = workspace:FindFirstChild("Yen")
        if oldFolder then
            for _, yen in ipairs(oldFolder:GetChildren()) do
                local hl = yen:FindFirstChild("IOHUB_ESP_HL")
                if hl then pcall(function() hl:Destroy() end) end
            end
        end
        container:ClearAllChildren()
        notify("Info", "Yen ESP: OFF", 2, "info")
    end
end)


YenTab.createToggle("Yen Show Studs", "Shows live distance (studs) for every Yen", function(state)
    _G.YenDistance_Active = state
    local container = getContainer(YenContainerName)

    if state then
        notify("Success", "Yen Studs Tracker: ON", 2, "success")

        task.spawn(function()
            while _G.YenDistance_Active do
                task.wait(0.1)
                if not _G.YenDistance_Active then break end
                
                if not _G.YenESP_Active then continue end 

                -- [INAYOS] Ginawang Player imbes na player
                local myChar = Player.Character or localPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                
                if myRoot then
                    for _, gui in ipairs(container:GetChildren()) do
                        if gui:IsA("BillboardGui") then
                            local lbl = gui:FindFirstChild("YenLabel")
                            local adornee = gui.Adornee
                            
                            if lbl and adornee and adornee.Parent then
                                local distance = math.floor((myRoot.Position - adornee.Position).Magnitude)
                                lbl.Text = "💰 Yen [" .. distance .. "s]"
                            end
                        end
                    end
                end
            end
        end)
    else
        for _, gui in ipairs(container:GetChildren()) do
            if gui:IsA("BillboardGui") then
                local lbl = gui:FindFirstChild("YenLabel")
                if lbl then
                    lbl.Text = "💰 Yen"
                end
            end
        end
        notify("Info", "Yen Studs Tracker: OFF", 2, "info")
    end
end)






_G.IsCollectingYen = false 


YenTab.createCustomButton("Auto Collect Yen", "", function()

    if _G.IsCollectingYen then
        _G.IsCollectingYen = false
        notify("IOHUB", "Auto Collect Yen: STOPPED", 2, "info")
        return
    end
    

    _G.IsCollectingYen = true
    notify("IOHUB", "Auto Collect Yen: STARTED", 2, "success")

    task.spawn(function()
    local emptyScans = 0

    while _G.IsCollectingYen do
        local found = false
        local char = Player.Character or localPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        if rootPart then
            for _, child in ipairs(getYenItems()) do   -- ✅ Bagong path
                if not _G.IsCollectingYen then break end

                local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    found = true
                    emptyScans = 0

                    local basePart = child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart")
                    if basePart then
                        rootPart.CFrame = basePart.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.2)
                        prompt.HoldDuration = 0
                        fireproximityprompt(prompt)
                        task.wait(0.4)
                    end
                    break
                end
            end
        end

        if not found then
            emptyScans = emptyScans + 1
            if emptyScans >= 2 then
                _G.IsCollectingYen = false
                notify("IOHUB", "Auto Collect: Stopped (No Yen Found)", 2, "warning")
                break
            else
                task.wait(1)
            end
        end
    end
end)
end)



S1Tab.createCustomButton("Touch Exit", "", function()
    local part = workspace:FindFirstChild("Section1") and workspace.Section1:FindFirstChild("OfficeTeleA")
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if part and hrp then

        firetouchinterest(part, hrp, 0) 
        
        task.wait(0.1) 
        
        firetouchinterest(part, hrp, 1) 
        
        notify("Success", "Exit Part Touched!", 2, "success")
    else
        notify("Error", "Exit Part not found", 2, "error")
    end
end)









-- ====================================================================
-- SECTION 11: AUTO CODE (Isamu's Workplace)
-- ====================================================================

-- Helper function para auto-scan ang 6 floors
local function scanS11Code()
    local floors = {"6thFloor", "5thFloor", "4thFloor", "3rdFloor", "2ndFloor", "1stFloor"}
    local codeTable = {}
    local displayString = ""
    
    local section1 = workspace:FindFirstChild("Section1")
    local objective = section1 and section1:FindFirstChild("PlayerObjective")
    local codeNums = objective and objective:FindFirstChild("CodeNumbers")
    
    if not codeNums then return nil, nil, "Not Found" end
    
    for _, fName in pairs(floors) do
        local floor = codeNums:FindFirstChild(fName)
        local surfaceGui = floor and floor:FindFirstChild("SurfaceGui")
        local randomLabel = surfaceGui and surfaceGui:FindFirstChild("Random")
        
        if randomLabel then
            local codeStr = nil
            -- Sinusuportahan ang TextLabel, TextButton, at StringValue
            if randomLabel:IsA("TextLabel") or randomLabel:IsA("TextButton") then
                codeStr = randomLabel.Text
            elseif randomLabel:IsA("StringValue") then
                codeStr = randomLabel.Value
            else
                local ok, t = pcall(function() return randomLabel.Text end)
                if ok and t then codeStr = t end
            end
            
            local codeNum = tonumber(codeStr)
            if codeNum then 
                table.insert(codeTable, codeNum) 
                displayString = displayString .. codeNum .. " "
            else 
                return nil, nil, "Waiting" -- Baka hindi pa naka-load
            end
        else
            return nil, nil, "Waiting"
        end
    end
    
    if #codeTable == 6 then
        return codeTable, displayString, "Scanned"
    end
    return nil, nil, "Waiting"
end

-- 1. ONE RECTANGLE DISPLAY (Auto-scan agad kapag binuksan ang tab)
S11Tab.createOneRectangle({
    Icon = "rbxassetid://104988684970777",
    Title = "PASSWORD",
    GetValue = function()
        local tbl, display, status = scanS11Code()
        if status == "Scanned" then
            return display, Color3.fromRGB(100, 220, 150)
        elseif status == "Not Found" then
            return "Not Found", Color3.fromRGB(255, 100, 100)
        else
            return "Waiting for scan...", Color3.fromRGB(255, 200, 80)
        end
    end,
})

S11Tab.createCustomButton("Interact Quest NPC", "", function()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        -- 1. Teleport sa NPC
        rootPart.CFrame = CFrame.new(4449.49902, 43.9929123, 1659.43604)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Clear momentum para iwas talsik
        
        -- 2. Maikling pahinga para mag-sync ang character sa bagong posisyon
        task.wait(0.5)
        
        -- 3. Direct Path sa ProximityPrompt (Walang nang GetDescendants)
        local section1 = workspace:FindFirstChild("Section1")
        local playerObj = section1 and section1:FindFirstChild("PlayerObjective")
        local npc = playerObj and playerObj:FindFirstChild("QuestGiverNPC")
        local head = npc and npc:FindFirstChild("Head")
        local prompt = head and head:FindFirstChild("ProximityPrompt")
        
        -- 4. I-fire kung nahanap
        if prompt and prompt:IsA("ProximityPrompt") then
            if prompt.Enabled then
                prompt.HoldDuration = 0 -- Bypass holding delay
                fireproximityprompt(prompt)
                notify("Success", "Quest NPC Interacted!", 2, "success")
            else
                notify("Warning", "Nahanap ang NPC pero naka-Disable ang Prompt.", 2, "warning")
            end
        else
            notify("Error", "Hindi mahanap ang ProximityPrompt sa NPC path!", 2, "error")
        end
    end
end)







-- 2. CUSTOM BUTTON (Pangalawa para lumabas sa ilalim ng code)
S11Tab.createCustomButton("Auto Code", "Scans, TP to keypad, and submits code", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    _G.S11_ScannedCodeStatus = "Waiting"
    _G.S11_ScannedCode = nil
    
    -- ==========================================
    -- STEP 1: SCAN CODE
    -- ==========================================
    local floors = {"6thFloor", "5thFloor", "4thFloor", "3rdFloor", "2ndFloor", "1stFloor"}
    local codeTable = {}
    local displayString = ""
    local success = true

    local section1 = workspace:FindFirstChild("Section1")
    local objective = section1 and section1:FindFirstChild("PlayerObjective")
    local codeNums = objective and objective:FindFirstChild("CodeNumbers")

    if not codeNums then
        _G.S11_ScannedCodeStatus = "Error"
        notify("Error", "CodeNumbers folder not found!", 3, "error")
        return
    end

    for _, fName in pairs(floors) do
        local floor = codeNums:FindFirstChild(fName)
        local surfaceGui = floor and floor:FindFirstChild("SurfaceGui")
        local randomLabel = surfaceGui and surfaceGui:FindFirstChild("Random")
        
        if randomLabel and (randomLabel.ContentText ~= "" or randomLabel.Text ~= "") then
            local codeStr = (randomLabel.ContentText ~= "" and randomLabel.ContentText) or randomLabel.Text
            local codeNum = tonumber(codeStr)
            
            if codeNum then 
                table.insert(codeTable, codeNum) 
                displayString = displayString .. codeNum .. " " -- Iniipon para sa display
            else 
                success = false; break 
            end
        else
            success = false; break
        end
    end

    if not success or #codeTable ~= 6 then
        _G.S11_ScannedCodeStatus = "Error"
        notify("Error", "❌ Hindi mabasa ang code! (Baka hindi pa naka-load)", 3, "error")
        return
    end

    -- Update UI Display
    _G.S11_ScannedCode = displayString
    _G.S11_ScannedCodeStatus = "Scanned"
    notify("Success", "Code Found: " .. displayString, 4, "success")


    -- ==========================================
    -- STEP 2: TP KEYPAD & FIRE PROMPT
    -- ==========================================
    rootPart.CFrame = CFrame.new(4472.323, 43.994, 1634.620)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(0.5) -- Hintayin mag-load ang paligid

    local codeDoorFolder = objective:FindFirstChild("CodeDoor")
    local keypadPrompt = codeDoorFolder 
        and codeDoorFolder:FindFirstChild("Keypad") 
        and codeDoorFolder.Keypad:FindFirstChild("Screen") 
        and codeDoorFolder.Keypad.Screen:FindFirstChild("ProximityPrompt")

    if keypadPrompt and keypadPrompt:IsA("ProximityPrompt") then
        keypadPrompt.HoldDuration = 0
        fireproximityprompt(keypadPrompt)
    else
        -- Fallback kung sakaling hindi mahanap sa eksaktong path
        if codeDoorFolder then
            for _, obj in pairs(codeDoorFolder:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                    fireproximityprompt(obj)
                    break
                end
            end
        end
    end

    task.wait(0.3)


    -- ==========================================
    -- STEP 3: SUBMIT CODE REMOTE
    -- ==========================================
    if codeDoorFolder then
        local remote = codeDoorFolder:FindFirstChild("Remote") or codeDoorFolder:FindFirstChild("RemoteEvent")
        if remote then 
            remote:FireServer(1, codeTable) 
            notify("Success", "Code Successfully Sent!", 3, "success")
        else
            notify("Error", "RemoteEvent not found in CodeDoor!", 3, "error")
        end
    end
end)



-- ====================================================================
-- 🆕 FORCE UI LAYOUT REFRESH
-- Pilitin ang "Isamu's Workplace" dropdown na i-calculate ang size niya
-- ====================================================================
task.spawn(function()
    task.wait(0.5) -- Bigyan ng oras mag-load ang buong menu
    
    local s1Page = pages["Section 1"]
    if not s1Page then return end
    
    -- Hahanapin natin yung specific dropdown frame ng Isamu
    local targetDropdown = s1Page:FindFirstChild("Isamu's WorkplaceDropdownGroup")
    
    if targetDropdown then
        -- Poke the size of its content area
        for _, child in ipairs(targetDropdown:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("UIListLayout") then
                local oldSize = child.Size
                child.Size = UDim2.new(1, 0, 0, 1) -- Force recalculate
                task.wait(0.05)
                child.Size = oldSize -- Ibalik sa tamang size
                break
            end
        end
    end
end)

S11Tab.createCustomButton("Auto Dig and Exit", "Collects shovel, digs 5x, and opens exit", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChild("Humanoid")

    if not rootPart or not humanoid then 
        notify("Error", "Character not loaded!", 3, "error")
        return 
    end

    notify("Auto Dig", "Starting sequence...", 2, "info")

    local shovelCFrame = CFrame.new(4464.73975, 43.9939728, 1625.5343, 0.220124543, -8.13470194e-11, 0.975471795, -1.96750491e-10, 1, 1.27791111e-10, -0.975471795, -2.20054516e-10, 0.220124543)
    local rubbleCFrame = CFrame.new(4449.78125, 43.9939728, 1634.13147, 0.112206995, -1.24661934e-08, 0.993684828, -2.79826584e-09, 1, 1.28613999e-08, -0.993684828, -4.22373336e-09, 0.112206995)

    -- ==========================================
    -- [STEP 1: TP SHOVEL & COLLECT]
    -- ==========================================
    notify("Auto Dig", "Teleporting to Shovel...", 1.5, "info")
    rootPart.CFrame = shovelCFrame
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
    task.wait(0.6) 

    -- Scan for nearby prompts (Shovel prompt)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local parentPart = obj.Parent
            if parentPart and (parentPart:IsA("BasePart") or parentPart:IsA("Attachment")) then
                local promptPos = parentPart:IsA("Attachment") and parentPart.WorldPosition or parentPart.Position
                local dist = (rootPart.Position - promptPos).Magnitude
                if dist <= 15 then
                    obj.HoldDuration = 0
                    fireproximityprompt(obj)
                    break 
                end
            end
        end
    end

    -- ==========================================
    -- [STEP 2: TP RUBBLE AREA, EQUIP SHOVEL & DIG 5X]
    -- ==========================================
    task.wait(1.0) 
    notify("Auto Dig", "Teleporting to Rubble Area...", 1.5, "info")
    
    rootPart.CFrame = rubbleCFrame
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(0.5)

    -- Equip Shovel Logic
    local shovelName = "Mimic@Tool_Shovel"
    local shovelInBackpack = player.Backpack:FindFirstChild(shovelName)

    if shovelInBackpack then
        humanoid:EquipTool(shovelInBackpack)
        task.wait(0.3)
    else
        for _, tool in pairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find("Shovel") then
                humanoid:EquipTool(tool)
                task.wait(0.3)
                break
            end
        end
    end

    -- Dig Loop
    local digPrompt = workspace:FindFirstChild("Section1") 
        and workspace.Section1:FindFirstChild("PlayerObjective") 
        and workspace.Section1.PlayerObjective:FindFirstChild("DirtDigObjective") 
        and workspace.Section1.PlayerObjective.DirtDigObjective:FindFirstChild("Attachment") 
        and workspace.Section1.PlayerObjective.DirtDigObjective.Attachment:FindFirstChild("ProximityPrompt")

    if digPrompt then
        digPrompt.HoldDuration = 0
        for i = 1, 5 do
            if not rootPart or not rootPart.Parent then break end -- Check if alive
            
            local attachment = digPrompt.Parent
            local dist = (rootPart.Position - attachment.WorldPosition).Magnitude
            
            if dist <= 20 then
                fireproximityprompt(digPrompt)
            else
                rootPart.CFrame = CFrame.new(attachment.WorldPosition + Vector3.new(0, 2, 0))
                task.wait(0.2)
                fireproximityprompt(digPrompt)
            end
            notify("Digging", "Digging... [" .. i .. "/5]", 0.5, "info")
            task.wait(0.7) 
        end
    else
        notify("Warning", "DirtDigObjective Prompt missing!", 2, "warning")
    end

    -- ==========================================
    -- [STEP 3: OPEN TELEPORT DOOR / EXIT]
    -- ==========================================
    task.wait(0.5)
    notify("Auto Dig", "Opening Exit Door...", 1.5, "info")
    
    local doorPrompt = workspace:FindFirstChild("Section1")
        and workspace.Section1:FindFirstChild("PlayerObjective")
        and workspace.Section1.PlayerObjective:FindFirstChild("TeleportDoor")
        and workspace.Section1.PlayerObjective.TeleportDoor:FindFirstChild("PROMPT")
        and workspace.Section1.PlayerObjective.TeleportDoor.PROMPT:FindFirstChild("ProximityPrompt")

    if doorPrompt then
        doorPrompt.HoldDuration = 0
        local promptParent = doorPrompt.Parent
        local doorPos = promptParent:IsA("Attachment") and promptParent.WorldPosition or promptParent.Position
        
        if (rootPart.Position - doorPos).Magnitude > 12 then
            rootPart.CFrame = CFrame.new(doorPos + Vector3.new(0, 2, 0))
            task.wait(0.3)
        end
        fireproximityprompt(doorPrompt)
    end

    notify("Success", "🔥 Dig & Exit Complete!", 3, "success")
end)



S11Tab.createCustomButton("Auto Collect Lantern & Ladder", "Collects White Flame Lantern and uses the Ladder", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    -- ==========================================
    -- [STEP 1: WHITE FLAME LANTERN]
    -- ==========================================
    notify("Lantern", "Teleporting to White Flame Lantern...", 1.5, "info")
    
    local whiteLanternCFrame = CFrame.new(4952.143, 27.121, 1224.793)
    rootPart.CFrame = whiteLanternCFrame
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
    task.wait(0.4)

    local lanternPrompt = workspace:FindFirstChild("WHITE_FLAME_LANTERN") 
        and workspace.WHITE_FLAME_LANTERN:FindFirstChild("PieceA") 
        and workspace.WHITE_FLAME_LANTERN.PieceA:FindFirstChild("ProximityPrompt")

    if lanternPrompt and lanternPrompt:IsA("ProximityPrompt") then
        lanternPrompt.HoldDuration = 0
        fireproximityprompt(lanternPrompt)
        notify("Lantern", "White Flame Lantern collected!", 1.5, "success")
    else
        notify("Warning", "White Flame Lantern Prompt not found!", 2, "warning")
    end

    -- ==========================================
    -- [STEP 2: LADDER PROMPT]
    -- ==========================================
    task.wait(0.6) -- Kaunting hintay bago lumipat sa ladder
    
    notify("Ladder", "Teleporting to Ladder...", 1.5, "info")
    
    local ladderCFrame = CFrame.new(4976.486, 27.121, 1219.697)
    rootPart.CFrame = ladderCFrame
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
    task.wait(0.4)

    local ladderPrompt = workspace:FindFirstChild("Section1") 
        and workspace.Section1:FindFirstChild("PlayerObjective") 
        and workspace.Section1.PlayerObjective:FindFirstChild("LADDERPROMPT") 
        and workspace.Section1.PlayerObjective.LADDERPROMPT:FindFirstChild("ProximityPrompt")

    if ladderPrompt and ladderPrompt:IsA("ProximityPrompt") then
        ladderPrompt.HoldDuration = 0
        fireproximityprompt(ladderPrompt)
        notify("Ladder", "Ladder used successfully!", 1.5, "success")
    else
        notify("Warning", "Ladder Prompt not found!", 2, "warning")
    end

    -- Final Notification
    notify("Success", "✨ Lantern & Ladder Complete!", 3, "success")
end)

S2Tab.createCustomButton("Auto Walkie Talkie", "Teleports to all NPCs and interacts", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    task.spawn(function()
        -- Helper function para maghanap at mag-fire ng pinakamalapit na prompt
        local function interactWithNearestPrompt()
            task.wait(0.5) -- Bigyan ng 0.5 seconds ang laro para mag-load
            
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local target = prompt.Parent
                    if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                        local targetPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                        local distance = (rootPart.Position - targetPos).Magnitude
                        
                        if distance <= 15 then
                            -- Bypass restrictions para sureball na mag-ffire
                            prompt.HoldDuration = 0
                            prompt.RequiresLineOfSight = false
                            prompt.MaxActivationDistance = 50
                            
                            fireproximityprompt(prompt)
                            break 
                        end
                    end
                end
            end
        end

        -- [[ START OF AUTO FARM ROUTINE ]]
        notify("Auto Walkie", "Starting NPC sequence...", 2, "info")
        
        -- 1. Teleport to NPC 1 + Interact
        rootPart.CFrame = CFrame.new(-1218.073, -165.374435, -963.733826)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
        interactWithNearestPrompt()
        notify("Auto Walkie", "NPC 1 Interacted", 1, "success")
        task.wait(0.1)

        -- 2. Teleport to NPC 2 + Interact
        rootPart.CFrame = CFrame.new(-1194.18591, -165.374435, -1003.34747)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        interactWithNearestPrompt()
        notify("Auto Walkie", "NPC 2 Interacted", 1, "success")
        task.wait(0.1)

        -- 3. Teleport to NPC 3 + Interact
        rootPart.CFrame = CFrame.new(-1144.55237, -142.647232, -1037.26892)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        interactWithNearestPrompt()
        notify("Auto Walkie", "NPC 3 Interacted", 1, "success")
        task.wait(0.1)

        -- 4. Teleport to NPC 4 + Interact
        rootPart.CFrame = CFrame.new(-1108.55176, -142.274261, -1038.53027)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        interactWithNearestPrompt()
        notify("Auto Walkie", "NPC 4 Interacted", 1, "success")
        task.wait(0.5) -- Medyo hinabaan natin ng konti bago mag-leave

        -- 5. LEAVE THE MALL
        notify("Auto Walkie", "Leaving the mall...", 1.5, "info")
        rootPart.CFrame = CFrame.new(-1335.1084, -165.374435, -1118.14185)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

        -- Notification pag tapos na lahat!
        notify("Success", "Walkie Talkie Quest Finished!", 5, "success")
    end)
end)

S2Tab.createCustomButton("Trigger Cinematic", "Teleports to trigger and returns to Safezone", function()
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then
        notify("Error", "Character not found!", 2, "error")
        return
    end
    
    -- Mga CFrame coordinates
    local triggerCFrame = CFrame.new(-1313.560, -157.775, -1119.744)
    local safezoneCFrame = CFrame.new(-1335.889, -165.374, -1118.517)
    
    -- Gumamit ng task.spawn para hindi mag-freeze ang ibang UI habang naghihintay
    task.spawn(function()
        local success, err = pcall(function()
            -- 1. Teleport papunta sa Trigger point
            rootPart.CFrame = triggerCFrame
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            
            notify("Cinematic", "🚀 Triggering Spawn...", 1.5, "info")
            
            -- Maghintay ng sandali para mag-register sa server
            task.wait(0.3)
            
            -- 2. Teleport pabalik sa Safezone
            rootPart.CFrame = safezoneCFrame
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            
            notify("Cinematic", "🛡️ Returned to SafeZone successfully!", 2, "success")
        end)
        
        if not success then
            notify("Error", "Cinematic sequence failed: " .. tostring(err), 3, "error")
        end
    end)
end)

--[[
S2Tab.createCustomButton("Auto Eyes", "Collects all eyes in TimedTrial and returns to safezone", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end
    
    local section2 = workspace:FindFirstChild("Section2")
    local floor1 = section2 and section2:FindFirstChild("Floor1")
    local timedTrial = floor1 and floor1:FindFirstChild("TimedTrial")
    local safeEscalator = CFrame.new(-1160.70581, -149.304581, -1011.77954, 0.991296649, -7.29874339e-09, 0.131647274, 8.19504553e-09, 1, -6.26657481e-09, -0.131647274, 7.29089011e-09, 0.991296649)
    
    if not timedTrial then 
        notify("Error", "❌ TimedTrial folder not found!", 3, "error")
        return 
    end
    

    local activeTargets = {}
    
    for _, trialFolder in pairs(timedTrial:GetChildren()) do
        if tonumber(trialFolder.Name) then
            for _, eye in pairs(trialFolder:GetChildren()) do
                local rootPartModel = eye:FindFirstChild("RootPart")
                local prompt = rootPartModel and rootPartModel:FindFirstChild("ProximityPrompt") or eye:FindFirstChildWhichIsA("ProximityPrompt", true)
                
                if prompt and prompt.Enabled then
                    table.insert(activeTargets, {
                        Instance = eye,
                        Prompt = prompt,
                        Root = rootPartModel or eye
                    })
                end
            end
        end
    end
    
    if #activeTargets == 0 then
        notify("Info", "👀 Walang aktibong mata na nahanap!", 2, "info")
        return
    end
    
    notify("Auto Eyes", "🚀 Starting Eye collection...", 2, "success")
    
    task.spawn(function()

        local punchingActive = true
        task.spawn(function()
            while punchingActive do
                task.wait()
                local currentCharacter = player.Character
                local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
                local animator = currentHumanoid and currentHumanoid:FindFirstChildOfClass("Animator")
                
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop(0) 
                    end
                end
                
                if currentHumanoid then
                    for _, track in pairs(currentHumanoid:GetPlayingAnimationTracks()) do
                        track:Stop(0)
                    end
                end
            end
        end)
        
  
        local punchCount = 0
        for _, target in ipairs(activeTargets) do
            if not rootPart or not rootPart.Parent then break end
            
            local eye = target.Instance
            local prompt = target.Prompt
            local eyeRoot = target.Root
            
            if prompt and prompt.Enabled and prompt.Parent then
                punchCount = punchCount + 1
                
                local targetCFrame = eyeRoot:IsA("BasePart") and eyeRoot.CFrame or eye:GetPivot()
                
        
                rootPart.CFrame = targetCFrame
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
                task.wait(0.15) 
                
         
                prompt.HoldDuration = 0
                fireproximityprompt(prompt)
                task.wait(0.05)
                fireproximityprompt(prompt)
                
                notify("Auto Eyes", "Punched Eye [" .. punchCount .. "/" .. #activeTargets .. "]", 0.5, "info")
                task.wait(0.25) 
            end
        end
        
     
        punchingActive = false 
        
        if punchCount > 0 and rootPart and rootPart.Parent then
            task.wait(0.2)
            rootPart.CFrame = safeEscalator
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) 
            notify("Success", "🔥 EMPTIED " .. tostring(punchCount) .. " EYES! Restored animations.", 3, "success")
        end
    end)
end)


S2Tab.createCustomButton("Grab Speaker", "Picks up speaker and teleports to escalator 2", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    task.spawn(function()

        local section2 = workspace:FindFirstChild("Section2")
        local speakerFolder = section2 and section2:FindFirstChild("Speaker")
        local speakerModel = speakerFolder and speakerFolder:FindFirstChild("SPEAKER")

        if not speakerModel then
            notify("Error", "❌ Speaker model not found!", 3, "error")
            return
        end

   
        notify("Speaker", "Teleporting to Speaker...", 1.5, "info")
        
        rootPart.CFrame = speakerModel:GetPivot() * CFrame.new(0, 1.5, 0)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
        task.wait(0.5) 
        

        local found = false
        

        for _, obj in pairs(speakerModel:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
                obj.RequiresLineOfSight = false
                fireproximityprompt(obj)
                found = true
                break 
            end
        end
        

        if not found then
            local pickupRemote = speakerModel:FindFirstChild("Pick Up")
            if pickupRemote and pickupRemote:IsA("RemoteEvent") then
                pcall(function()
                    pickupRemote:FireServer()
                end)
                found = true
            end
        end


        if found then
            notify("Success", "SPEAKER PICKED UP! Moving to Escalator 2...", 2, "success")
            
            task.wait(1.0) 
            
   
            rootPart.CFrame = CFrame.new(-1338.47424, -125.925087, -933.825439, 0.341684461, -7.77278952e-09, 0.939814746, -1.18997062e-10, 1, 8.31381808e-09, -0.939814746, -2.95253755e-09, 0.341684461)
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            
        else
            notify("Error", "❌ CANT PICKUP SPEAKER! Someone might be holding it.", 3, "error")
        end
    end)
end)
--]]


S2Tab.createCustomButton("Auto Drop & Fire Speaker", "Drops speaker at end mall and triggers sound", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    task.spawn(function()
        -- ==========================================
        -- STEP 1: TP SA END MALL LOCATION
        -- ==========================================
        notify("Speaker", "Teleporting to End Mall...", 1.5, "info")
        
        rootPart.CFrame = CFrame.new(-1434.377, -119.984, -939.303)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
        task.wait(0.5) 
        
        -- ==========================================
        -- STEP 2: AUTO DROP (Fire UI & Signal)
        -- ==========================================
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            local s2Gui = playerGui:FindFirstChild("S2")
            if s2Gui then
                local dropBtn = s2Gui:FindFirstChild("DropButton")
                if dropBtn then
                    if dropBtn:IsA("GuiButton") then
                        -- Nilagyan ng pcall para hindi mag-crash kung walang connections
                        pcall(function()
                            for _, connection in pairs(getconnections(dropBtn.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end)
                    end
                    -- Itago ang DropButton para malinis ang screen
                    dropBtn.Visible = false
                end
            end
        end
        
        -- Fire ang RemoteEvent para sa Drop signal
        local section2 = workspace:FindFirstChild("Section2")
        local speakerFolder = section2 and section2:FindFirstChild("Speaker")
        local speakerSignal = speakerFolder and speakerFolder:FindFirstChild("Signal")
        
        if speakerSignal and speakerSignal:IsA("RemoteEvent") then
            pcall(function()
                speakerSignal:FireServer()
            end)
        end
        
        notify("Speaker", "SPEAKER DROPPED! Triggering sound...", 2, "warning")
        
        task.wait(0.6) -- Sandaling hintay pagkatapos ma-drop
        
        -- ==========================================
        -- STEP 3: FIRE ANG PROMPT PARA TUMUNOG
        -- ==========================================
        local speakerModel = speakerFolder and speakerFolder:FindFirstChild("SPEAKER")
        local foundPrompt = false
        
        if speakerModel then
            for _, obj in pairs(speakerModel:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    obj.HoldDuration = 0
                    obj.RequiresLineOfSight = false
                    obj.MaxActivationDistance = 50
                    
                    fireproximityprompt(obj)
                    foundPrompt = true
                    break
                end
            end
        end
        
        if foundPrompt then
            notify("Success", "🔥 SPEAKER TRIGGERED SUCCESSFULLY!", 3, "success")
        else
            notify("Warning", "Speaker dropped, but prompt not found nearby.", 3, "warning")
        end
    end)
end)


--[[
if _G.NextCoinIndex == nil then _G.NextCoinIndex = 1 end

S2Tab.createCustomButton("Auto Collect Coins & Submit", "Teleport to collect coins in batches and submit", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart then 
            notify("Error", "Character not found!", 3, "error")
            return 
        end
        
        -- Mga Target Locations
        local carouselCFrame = CFrame.new(-1284.86865, -141.74498, -1096.00964)
        local escalatorCFrame = CFrame.new(-1160.70581, -149.304581, -1011.77954, 0.991296649, -7.29874339e-09, 0.131647274, 8.19504553e-09, 1, -6.26657481e-09, -0.131647274, 7.29089011e-09, 0.991296649)
        
        -- INSTANT TELEPORT ENGINE
        local function instantTeleport(targetCFrame)
            rootPart.CFrame = targetCFrame
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            task.wait(0.1) 
        end
        
        -- 1. Ipunin ang lahat ng barya
        local allCoins = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") and obj.Parent then
                table.insert(allCoins, obj)
            end
        end
        
        local totalCoinsFound = #allCoins
        
        -- Check kung may barya pa ba
        if totalCoinsFound == 0 then
            notify("Info", "Walang barya na nahanap sa mapa.", 2, "info")
            return
        end
        
        if _G.NextCoinIndex > totalCoinsFound then
            _G.NextCoinIndex = 1 -- Reset kapag naubos na lahat
        end
        
        local coinsCollectedThisBatch = 0
        local maxPerBatch = 5
        
        notify("Coins", "Starting collection (Batch " .. math.ceil(_G.NextCoinIndex / maxPerBatch) .. ")...", 2, "info")
        
        -- 2. Kolektahin ang barya (Hanggang 5 barya per pindot)
        while coinsCollectedThisBatch < maxPerBatch and _G.NextCoinIndex <= totalCoinsFound do
            if not rootPart or not rootPart.Parent then break end -- Safety check
            
            local targetCoin = allCoins[_G.NextCoinIndex]
            
            if targetCoin and targetCoin.Parent then
                instantTeleport(targetCoin.CFrame * CFrame.new(0, 1.5, 0))
                
                local prompt = targetCoin:FindFirstChildOfClass("ProximityPrompt") or targetCoin.Parent:FindFirstChildOfClass("ProximityPrompt")
                
                if prompt then
                    prompt.HoldDuration = 0
                    prompt.RequiresLineOfSight = false -- Bypass walls
                    fireproximityprompt(prompt)
                end
                
                coinsCollectedThisBatch = coinsCollectedThisBatch + 1
                task.wait(0.3) -- Bilis ng transition
            end
            
            _G.NextCoinIndex = _G.NextCoinIndex + 1
        end
        
        -- 3. Deposit sa Carousel at TP sa Escalator
        if coinsCollectedThisBatch > 0 then
            notify("Coins", "Depositing " .. coinsCollectedThisBatch .. " coins...", 2, "info")
            
            instantTeleport(carouselCFrame)
            task.wait(0.2)
            
            -- Fire Deposit Prompt near Carousel
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local target = prompt.Parent
                    if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                        local promptPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                        
                        if (rootPart.Position - promptPos).Magnitude <= 25 then
                            prompt.HoldDuration = 0
                            prompt.RequiresLineOfSight = false
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
            
            -- Teleport agad sa Safe Escalator
            task.wait(0.2)
            rootPart.CFrame = escalatorCFrame
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            notify("Success", "⚡ Deposited " .. coinsCollectedThisBatch .. " coins! Teleported to Safe Escalator.", 3, "success")
        else
            notify("Warning", "Walang na-collect na barya.", 2, "warning")
        end
    end)
end)
--]]

-- ====================================================================
-- GLOBAL VARIABLES & HTTP LOADER
-- ====================================================================
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local recordedFrames = {}
local isPlayingPath = false
local isWaitingForChase = false

-- FUNCTION: Tagabalik ng Table patungong CFrame
local function tableToCFrame(tbl)
    return CFrame.new(unpack(tbl))
end

-- AUTO-LOAD VIA GITHUB HTTPGET
task.spawn(function()
    local githubUrl = "https://raw.githubusercontent.com/Moymoy21/Main-Iyongofficial/refs/heads/main/IOHUB_PureMacro.lua"
    
    local success, rawData = pcall(function()
        return game:HttpGet(githubUrl)
    end)
    
    if success and rawData then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(rawData)
        end)
        
        if decodeSuccess and data then
            recordedFrames = {}
            for _, tbl in ipairs(data) do
                table.insert(recordedFrames, tableToCFrame(tbl))
            end
            
            notify("GITHUB", "Connected (" .. tostring(#recordedFrames) .. " frames)", 3, "success")
        else
            notify("GITHUB", "❌ GITHUB DATA IS BROKEN", 5, "error")
        end
    else
        notify("GITHUB", "❌ Failed to connect to GitHub!", 5, "error")
    end
end)

-- ========================================================
-- COMBINED BUTTON: PLAYBACK CHASE 1 & AUTO SKIP CHASE 2
-- ========================================================
S2Tab.createCustomButton("Auto Chase 1 and 2", "Run Chase 1, TP to Elevator, wait 1m 30s, and touch", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end
    
    -- Kung pinindot ulit habang tumatakbo o naghihintay, i-cancel
    if isPlayingPath or isWaitingForChase then
        isPlayingPath = false
        isWaitingForChase = false
        notify("Playback", "🛑 Cancelled Auto Chase.", 3, "alarm") -- Pinalitan ng alarm
        return
    end
    
    -- Tiyakin na may frames na nakuha mula sa GitHub
    if #recordedFrames == 0 then
        notify("Error", "😭 GitHub data is missing or not loaded yet.", 4, "error")
        return
    end
    
    isPlayingPath = true
    notify("Playback", "🟢 CHASE 1 STARTED", 3, "success")
    
    task.spawn(function()
        -- ==========================================
        -- [STEP 1: RUN THE CHASE 1 MOVEMENTS]
        -- ==========================================
        for i, targetCFrame in ipairs(recordedFrames) do
            if not isPlayingPath or not rootPart or not rootPart.Parent then break end
            
            rootPart.CFrame = targetCFrame
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            RunService.Heartbeat:Wait() 
        end
        
        isPlayingPath = false -- Tapos na ang chase 1
        
        -- Check kung kinansela habang tumatakbo
        if not rootPart or not rootPart.Parent then return end 
        
        -- ==========================================
        -- [STEP 2: INSTANT TELEPORT TO ELEVATOR]
        -- ==========================================
        task.wait(0.2) 
        
        local elevatorCFrame = CFrame.new(-3913.4397, -254.866745, -1104.35205, 0.335298121, 2.62250865e-09, 0.942112088, 4.56615246e-10, 1, -2.94615798e-09, -0.942112088, 1.41802392e-09, 0.335298121)
        
        rootPart.CFrame = elevatorCFrame
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
        
        -- ==========================================
        -- [STEP 3: WAIT 1 MINUTE AND 30 SECONDS]
        -- ==========================================
        isWaitingForChase = true
        -- Pinalitan ng "alarm" para lumabas ang dilaw na icon at text
        notify("Wait for Chasing End", "⚠️ Stay still for 1m 33s...", 80, "alarm") 
        
        -- 90 seconds countdown (1 min 30 secs)
        local waitTime = 80
        local startTime = os.clock()
        
        while (os.clock() - startTime) < waitTime do
            if not isWaitingForChase or not rootPart or not rootPart.Parent then 
                notify("Playback", "🛑 Waiting cancelled.", 3, "error")
                return 
            end
            task.wait(1)
        end
        
        isWaitingForChase = false
        
        -- ==========================================
        -- [STEP 4: FIRE TOUCH INTEREST ON ELEVATOR]
        -- ==========================================
        notify("Success", "⏳ Time's up! Triggering Elevator...", 3, "info")
        
        local section25 = workspace:FindFirstChild("Section2.5")
        local chaseSequence = section25 and section25:FindFirstChild("ChaseSequence")
        local secondChase = chaseSequence and chaseSequence:FindFirstChild("SecondChaseStuff")
        local elevatorHit = secondChase and secondChase:FindFirstChild("ElevatorHit")

        if elevatorHit and elevatorHit:IsA("BasePart") then
            -- Fire TouchInterest
            firetouchinterest(elevatorHit, rootPart, 0)
            task.wait(0.1)
            firetouchinterest(elevatorHit, rootPart, 1)
            
            notify("Success", "🔥 Elevator Hit Triggered! Chase Complete.", 4, "success")
        else
            notify("Error", "❌ ElevatorHit part not found in Section2.5!", 4, "error")
        end
    end)
end)



-- ====================================================================
-- AUTO CLOSE ELEVATOR (QUICKTIME SPAM TOGGLE)
-- ====================================================================
local ToggleQuickTimeSpam = false

S2Tab.createToggle("Auto Close the Elevator", "Automatically spam tap to close the elevator", function(state)
    ToggleQuickTimeSpam = state
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    if ToggleQuickTimeSpam then
        notify("QuickTime", "🟢 Auto Close ENABLED", 2, "success")
        
        -- Background loop para i-spam ang remote habang naka-on ang toggle
        task.spawn(function()
            local function getPacketFunc()
                local packages = replicatedStorage:FindFirstChild("Packages")
                local packet = packages and packages:FindFirstChild("Packet")
                return packet and packet:FindFirstChild("PacketFunction")
            end

            local packetFunc = getPacketFunc()
            
            while ToggleQuickTimeSpam do
                -- Dynamic fallback kung sakaling mag-reload o mawala ang remote
                if not packetFunc or not packetFunc.Parent then
                    packetFunc = getPacketFunc()
                end

                if packetFunc and packetFunc:IsA("RemoteFunction") then
                    pcall(function()
                        packetFunc:InvokeServer(
                            0,
                            {
                                ["__args"] = {},
                                ["__tree"] = {
                                    [1] = "QuickTimeService",
                                    [2] = "Clicked",
                                },
                                ["__callType"] = 0,
                            }
                        )
                    end)
                end
                
                -- Bilis ng pag-spam (0.05 seconds para mabilis masalo ng laro)
                task.wait(0.05)
            end
        end)
    else
        notify("QuickTime", "🔴 Auto Close DISABLED", 2, "info")
    end
end)


S2MiniTab.createCustomButton("Auto Fix Car", "Automatically Collect and Submit Car Items", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    notify("Car Fix", "🚀 Starting Car Fix Cycle...", 2, "info")

    task.spawn(function()
        -- [[ 1. DYNAMIC VEHICLE PATH FINDER ]]
        local vehiclePath = nil
        local target = workspace:FindFirstChild("CarFixObjective", true)
        if target and target:FindFirstChild("Vehicle") and target.Vehicle:FindFirstChild("Builder") then
            vehiclePath = target.Vehicle.Builder
        end
        
        -- Fallback kung sakaling hindi gumana ang recursive search
        if not vehiclePath then
            local success, res = pcall(function()
                return workspace.Section2["5"].ChihiroMinigame.CarFixObjective.Vehicle.Builder
            end)
            if success then vehiclePath = res end
        end

        if not vehiclePath then
            notify("Critical Error", "Car Fix Vehicle not found in Workspace!", 3, "error")
            return -- I-stop nalang kung wala yung kotse
        end

        -- [[ 2. DATA CONFIGURATION ]]
        local wheelWorkflow = {
            { name = "Gulong 1 (RR)", itemPos = Vector3.new(-2144.361, -98.017, 1629.158), carCFrame = CFrame.new(-1924.67114, -95.532135, 1607.20874), pName = "RR" },
            { name = "Gulong 2 (FR)", itemPos = Vector3.new(-1968.292, -98.022, 1626.370), carCFrame = CFrame.new(-1912.37439, -95.5321503, 1606.59827), pName = "FR" },
            { name = "Gulong 3 (RL)", itemPos = Vector3.new(-1870.036, -95.532, 1504.396), carCFrame = CFrame.new(-1912.37634, -95.5321426, 1597.0343), pName = "RL" },
            { name = "Gulong 4 (FL)", itemPos = Vector3.new(-1958.030, -98.019, 1510.578), carCFrame = CFrame.new(-1924.20239, -95.5321426, 1596.77112), pName = "FL" }
        }

        local mainPartsWorkflow = {
            { name = "V8 Engine", pos = Vector3.new(-1977.489, -97.527, 1559.782) },
            { name = "Steering Wheel", pos = Vector3.new(-2045.800, -98.076, 1562.678) },
            { name = "Gas Can 1", pos = Vector3.new(-1922.088, -97.451, 1630.484) },
            { name = "Gas Can 2", pos = Vector3.new(-1942.218, -97.447, 1512.191) },
            { name = "Gas Can 3", pos = Vector3.new(-2035.270, -97.446, 1569.895) }
        }

        -- [[ 3. BYPASS & NOCLIP LOOP ]]
        local stepConn
        stepConn = game:GetService("RunService").Stepped:Connect(function()
            local charRef = player.Character
            if charRef then
                for _, part in pairs(charRef:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)

        -- [[ 4. HELPER FUNCTIONS ]]
        local function collectItemAt(pos, name)
            rootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            task.wait(0.5)
            
            -- Safe Scan for Prompts
            pcall(function()
                for _, obj in pairs(workspace:GetPartBoundsInBox(CFrame.new(pos), Vector3.new(15, 15, 15))) do
                    local p = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                    if p then
                        p.HoldDuration = 0
                        p.RequiresLineOfSight = false -- Bypass walls
                        fireproximityprompt(p)
                    end
                end
            end)
            task.wait(0.3)
        end

        local function equipTool(toolName)
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChild(toolName)
                if tool then
                    humanoid:EquipTool(tool)
                    task.wait(0.2)
                    return true
                end
            end
            if player.Character:FindFirstChild(toolName) then return true end
            return false
        end

        -- [[ 5. RUNNING THE WORKFLOW ]]

        -- STEP A: Apat na Gulong (RR, FR, RL, FL)
        for i, step in ipairs(wheelWorkflow) do
            if not rootPart or not rootPart.Parent then break end
            
            notify("Car Fix", "Kukuha ng " .. step.name .. "...", 1.5, "info")
            collectItemAt(step.itemPos, step.name)
            
            notify("Car Fix", "Ikakabit ang " .. step.name .. "...", 1.5, "info")
            rootPart.CFrame = step.carCFrame
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            task.wait(0.4)
            
            equipTool("Car Wheel")
            
            local targetPart = vehiclePath[step.pName] or vehiclePath:FindFirstChild(step.pName)
            local prompt = targetPart and targetPart:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                prompt.HoldDuration = 0
                prompt.RequiresLineOfSight = false
                fireproximityprompt(prompt)
            end
            task.wait(0.4)
        end

        -- STEP B: Engine at Steering Wheel (Main Prompt)
        for i = 1, 2 do
            if not rootPart or not rootPart.Parent then break end
            
            local step = mainPartsWorkflow[i]
            notify("Car Fix", "Kukuha ng " .. step.name .. "...", 1.5, "info")
            collectItemAt(step.pos, step.name)
            
            notify("Car Fix", "Ikakabit ang " .. step.name .. "...", 1.5, "info")
            rootPart.CFrame = CFrame.new(-1918.0, -94.5, 1602.0)
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            task.wait(0.4)
            
            equipTool(step.name)
            
            local mainPart = vehiclePath.Main or vehiclePath:FindFirstChild("Main")
            local mainPrompt = mainPart and mainPart:FindFirstChildOfClass("ProximityPrompt")
            if mainPrompt then
                mainPrompt.HoldDuration = 0
                mainPrompt.RequiresLineOfSight = false
                fireproximityprompt(mainPrompt)
            end
            task.wait(0.4)
        end

        -- STEP C: Tatlong Gas Cans (Main Prompt)
        for i = 3, 5 do
            if not rootPart or not rootPart.Parent then break end
            
            local step = mainPartsWorkflow[i]
            notify("Car Fix", "Kukuha ng " .. step.name .. "...", 1.5, "info")
            collectItemAt(step.pos, step.name)
            
            notify("Car Fix", "Ibubuhos ang " .. step.name .. "...", 1.5, "info")
            rootPart.CFrame = CFrame.new(-1918.0, -94.5, 1602.0)
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Anti-fling
            task.wait(0.4)
            
            equipTool("Gas Can")
            
            local mainPart = vehiclePath.Main or vehiclePath:FindFirstChild("Main")
            local mainPrompt = mainPart and mainPart:FindFirstChildOfClass("ProximityPrompt")
            if mainPrompt then
                mainPrompt.HoldDuration = 0
                mainPrompt.RequiresLineOfSight = false
                fireproximityprompt(mainPrompt)
            end
            task.wait(0.4)
        end

        -- [[ 6. CLEAN UP ]]
        if stepConn then stepConn:Disconnect() end
        if rootPart and rootPart.Parent then
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.CFrame = CFrame.new(-1918.0, -94.5, 1602.0) -- Mananatiling nakatayo sa kotse sa dulo
        end
        
        notify("Success", "🎉 CAR FIXED AND FILLED!", 4, "success")
    end)
end)


-- ====================================================================
-- TRIVIA AUTO-ANSWER & AUTO-CHAT (FIXED & RE-EXECUTABLE)
-- ====================================================================
_G.ToggleAutoAnswer = false
_G.ToggleAutoChat = false

local replicatedStorage = game:GetService("ReplicatedStorage")
local textChatService = game:GetService("TextChatService")

-- [[ SHARED AUTO CHAT FUNCTION ]]
local function autoChat(message)
    pcall(function()
        if textChatService and textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local textChannels = textChatService:FindFirstChild("TextChannels")
            local generalChannel = textChannels and textChannels:FindFirstChild("RBXGeneral")
            if generalChannel then
                generalChannel:SendAsync(message)
            else
                local foundChannel = textChatService:FindFirstChild("RBXGeneral", true)
                if foundChannel then
                    foundChannel:SendAsync(message)
                end
            end
        else
            local chatEvent = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and replicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
            if chatEvent then
                chatEvent:FireServer(message, "All")
            end
        end
    end)
end


-- ====================================================================
-- TOGGLE 1: AUTO ANSWER (FIRE SERVER)
-- ====================================================================
S2MiniTab.createToggle("Trivia Auto-Answer", "Automatically Fire/Click Correct Answer on Remote.", function(state)
    _G.ToggleAutoAnswer = state
    if state then
        notify("Trivia", "🟢 Auto-Answer ENABLED", 2, "success")
    else
        notify("Trivia", "🔴 Auto-Answer DISABLED", 2, "info")
    end
end)


-- ====================================================================
-- TOGGLE 2: AUTO CHAT ANSWER
-- ====================================================================
S2MiniTab.createToggle("Trivia Auto-Chat Answer", "Automatically Send Correct Answer to Chat.", function(state)
    _G.ToggleAutoChat = state
    if state then
        notify("Trivia", "🟢 Auto-Chat Answer ENABLED", 2, "success")
    else
        notify("Trivia", "🔴 Auto-Chat Answer DISABLED", 2, "info")
    end
end)


-- ====================================================================
-- CORE TRIVIA LISTENER (FIXED MULTIPLE CONNECTION BUG)
-- ====================================================================
task.spawn(function()
    while task.wait(1) do
        local triviaPath = workspace:FindFirstChild("Section2.5") 
            and workspace["Section2.5"]:FindFirstChild("ChihiroMinigame") 
            and workspace["Section2.5"].ChihiroMinigame:FindFirstChild("Trivia")
            
        if triviaPath and triviaPath:FindFirstChild("Signal") then
            local triviaEvent = triviaPath.Signal
            
            -- 🆕 Titingnan kung yung event ba ay nagbago (e.g., nag-reload ang minigame)
            -- o kung wala pa tayong connection.
            if _G.CurrentTriviaEvent ~= triviaEvent then
                -- Burahin ang lumang connection kung meron man
                if _G.GlobalTriviaConn then
                    _G.GlobalTriviaConn:Disconnect()
                end
                _G.CurrentTriviaEvent = triviaEvent
                
                -- Gumawa ng bagong connection
                _G.GlobalTriviaConn = triviaEvent.OnClientEvent:Connect(function(param1, questionText, choices, param4)
                    -- Kung parehong patay ang toggles, huwag na magtuloy
                    if not _G.ToggleAutoAnswer and not _G.ToggleAutoChat then return end
                    if type(choices) ~= "table" then return end
                    
                    local chosenIndex = nil
                    local detectedAnswerName = ""
                    
                    -- SMARTER MATCHING LOGIC
                    for index, choiceValue in ipairs(choices) do
                        local cleanChoice = string.lower(tostring(choiceValue))
                        
                        -- 1. Para kay Hiachi Masashige
                        if string.find(cleanChoice, "hiachi") and string.find(cleanChoice, "masashige") then
                            if not string.find(cleanChoice, "shizu") and not string.find(cleanChoice, "megumi") then
                                chosenIndex = index
                                detectedAnswerName = choiceValue
                                break
                            end
                        
                        -- 2. Para sa "Me"
                        elseif cleanChoice == "me" then
                            chosenIndex = index
                            detectedAnswerName = choiceValue
                            break
                            
                        -- 3. Para sa ibang choices
                        else
                            local targetKeywords = {
                                "cherry blossom",
                                "torii gate",
                                "evil god",
                                "kiiroibara cult",
                                "a komainu",
                                "enzukai",
                                "a brush"
                            }
                            
                            local isMatched = false
                            for _, kw in ipairs(targetKeywords) do
                                if cleanChoice == kw then
                                    isMatched = true
                                    break
                                end
                            end
                            
                            if isMatched then
                                chosenIndex = index
                                detectedAnswerName = choiceValue
                                break
                            end
                        end
                    end
                    
                    if not chosenIndex then 
                        notify("Trivia", "❌ Walang match sa choices!", 2, "error")
                        return 
                    end
                    
                    -- 2-Second Delay bago umaksyon
                    task.wait(2.0)
                    
                    -- A. Kung naka-on ang Auto Answer (Fire Server)
                    if _G.ToggleAutoAnswer then
                        pcall(function()
                            triviaEvent:FireServer(chosenIndex, 1)
                            triviaEvent:FireServer(detectedAnswerName)
                            triviaEvent:FireServer(detectedAnswerName, chosenIndex)
                            triviaEvent:FireServer(1, chosenIndex)
                        end)
                        notify("Trivia", "Answer Sent: " .. tostring(detectedAnswerName), 2, "success")
                    end
                    
                    -- B. Kung naka-on ang Auto Chat Answer
                    if _G.ToggleAutoChat then
                        local formattedChat = "Answer: " .. tostring(detectedAnswerName)
                        autoChat(formattedChat)
                    end
                end)
            end
        end
    end
end)


S3Tab.createCustomButton("Auto Bless", "Get Ink/Orchid/Water/Bless automatically", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end
    
    notify("Auto Bless", "🚀 Starting sequence...", 2, "info")

    task.spawn(function()
        local toolName = "Ink" 
        local TweenService = game:GetService("TweenService")
        
        -- Checker kung hawak o nasa bag na ang Ink
        local function hasInk()
            local inCharacter = character:FindFirstChild(toolName)
            local inBackpack = player.Backpack:FindFirstChild(toolName)
            return (inCharacter or inBackpack)
        end

        -- Pag-equip ng Ink
        local function forceEquipInk()
            if character:FindFirstChild(toolName) then return end
            local tool = player.Backpack:FindFirstChild(toolName)
            if tool then
                humanoid:EquipTool(tool)
                task.wait(0.3)
            end
        end

        -- Tanggalin ang hawak na bowl/items para hindi ma-block ang Orchid prompt
        local function unequipAllTools()
            humanoid:UnequipTools()
            task.wait(0.3)
        end

        -- MAS MABILIS NA TWEEN ENGINE (Naka-set sa speed 250)
        local function tweenTo(targetCFrame)
            if not rootPart then return end
            local distance = (rootPart.Position - targetCFrame.Position).Magnitude
            local speed = 250 
            local duration = distance / speed
            
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
            
            tween:Play()
            tween.Completed:Wait()
            
            -- Anti-Fling
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            task.wait(0.4) -- Hinto saglit para siguradong tanggap ng server ang posisyon mo
        end

        -- [[ STEP ROUTINE WITH PERFECT SYNC ]]
        local drawSteps = {
            {name = "Paintstation A (Get Ink)", cf = CFrame.new(105.733383, -429.446381, 9308.95117)},
            {name = "Mix Orchid", cf = nil}, -- Dynamic na kukunin ang CFrame sa ibaba
            {name = "Mix Water", cf = CFrame.new(93.5755463, -429.446381, 9342.38672)},
            {name = "Bless the Ink", cf = CFrame.new(-36.5126572, -428.145172, 9298.2168)},
            {name = "Paintstation A (Start Draw)", cf = CFrame.new(105.499695, -429.446381, 9308.87793)}
        }

        for index, step in ipairs(drawSteps) do
            if not rootPart or not rootPart.Parent then break end
            
            -- [[ DETAILED CHECK KUNG ORCHID STEP NA ]]
            if step.name == "Mix Orchid" then
                unequipAllTools()
                
                local success, orchidModel = pcall(function()
                    return workspace.Section3.PaintPuzzle.Ingredients.Orchid
                end)
                
                if success and orchidModel then
                    local orchidPosition = orchidModel:GetPivot().Position
                    local targetCFrame = CFrame.new(orchidPosition.X, -430.609894, orchidPosition.Z)
                    
                    notify("Auto Bless", "Orchid: Mixing...", 1.5, "info")
                    tweenTo(targetCFrame)
                    task.wait(0.3)
                    
                    local prompt = orchidModel:FindFirstChildOfClass("ProximityPrompt") or orchidModel:FindFirstChild("ProximityPrompt")
                    if prompt then
                        task.spawn(function() fireproximityprompt(prompt) end)
                        task.wait(prompt.HoldDuration + 0.5)
                    else
                        for _, p in pairs(workspace:GetDescendants()) do
                            if p:IsA("ProximityPrompt") and p.Enabled and p.Parent and p.Parent.Name == "Orchid" then
                                task.spawn(function() fireproximityprompt(p) end)
                                task.wait(p.HoldDuration + 0.5)
                                break
                            end
                        end
                    end
                else
                    notify("Error", "❌ CAN'T FIND THE ORCHID!", 3, "error")
                end
            else
                -- STANDARD STEP (Get Ink, Water, Bless, Draw)
                tweenTo(step.cf)
                
                notify("Auto Bless", "Status: " .. step.name, 1.5, "info")
                
                -- [[ SPECIAL RETRY LOGIC PARA SA UNANG STEP (GET INK) ]]
                if index == 1 then
                    local inkRetries = 0
                    while not hasInk() and inkRetries < 5 do
                        inkRetries = inkRetries + 1
                        
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                                local target = prompt.Parent
                                if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                                    local targetPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                                    local distance = (rootPart.Position - targetPos).Magnitude
                                    
                                    if distance <= 15 and target.Name ~= "Orchid" then
                                        task.spawn(function() fireproximityprompt(prompt) end)
                                        task.wait(prompt.HoldDuration + 0.5) -- Oras para pumasok ang tool sa bag
                                        break
                                    end
                                end
                            end
                        end
                        
                        if not hasInk() then task.wait(0.5) end
                    end
                else
                    -- STANDARD SCANNER PARA SA IBANG STATIONS (Water, Bless, Draw)
                    if index > 1 then forceEquipInk() end
                    
                    for _, prompt in pairs(workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            local target = prompt.Parent
                            if target and (target:IsA("BasePart") or target:IsA("Attachment")) then
                                local targetPos = target:IsA("Attachment") and target.WorldPosition or target.Position
                                local distance = (rootPart.Position - targetPos).Magnitude
                                
                                if distance <= 15 and target.Name ~= "Orchid" then
                                    task.spawn(function() fireproximityprompt(prompt) end)
                                    task.wait(prompt.HoldDuration + 0.3)
                                    break
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.5) 
        end

        notify("Success", "🎨✨ YOU CAN START AUTO DRAW NOW", 4, "success")
    end)
end)

S3Tab.createCustomButton("Auto Draw", "Automatically Draw Base What You Are Currently Location", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local HttpService = game:GetService("HttpService")
    
    local paintPuzzle = workspace.Section3.PaintPuzzle
    -- Ginamit ang iyong mismong mga GitHub link para sa JSON data packet structures
    local stations = {
        {Name = "PaintStation_A", JsonUrl = "https://raw.githubusercontent.com/Moymoy21/TESTSCRIPT/refs/heads/main/TheMimic_PaintStation_A.json"},
        {Name = "PaintStation_B", JsonUrl = "https://raw.githubusercontent.com/Moymoy21/TESTSCRIPT/refs/heads/main/TheMimic_PaintStation_B.json"},
        {Name = "PaintStation_C", JsonUrl = "https://raw.githubusercontent.com/Moymoy21/TESTSCRIPT/refs/heads/main/TheMimic_PaintStation_C.json"},
        {Name = "PaintStation_D", JsonUrl = "https://raw.githubusercontent.com/Moymoy21/TESTSCRIPT/refs/heads/main/TheMimic_PaintStation_D.json"}
    }
    
    local closestStation = nil
    local shortestDistance = math.huge
    
    -- LOOP CHECKER: Hinahanap kung aling station ang pinakamalapit sa iyong pwesto
    for _, station in ipairs(stations) do
        local part = paintPuzzle:FindFirstChild(station.Name) and paintPuzzle[station.Name]:FindFirstChild("Pad")
        if part then
            local distance = (rootPart.Position - part.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestStation = station
            end
        end
    end
    
    -- EXECUTION ENGINE FOR ONLINE JSON PACKETS
    if closestStation and shortestDistance < 50 then
        notify("Auto Draw", "📍 Malapit ka sa: " .. closestStation.Name .. ". Nag-da-download ng packet...", 2, "info")
        
        local success, err = pcall(function()
            -- 1. Hinihila ang text data mula sa raw link mo
            local rawJsonData = game:HttpGet(closestStation.JsonUrl)
            
            if not rawJsonData or rawJsonData == "" then
                error("Blangko o walang nakuha mula sa GitHub link!")
            end
            
            -- 2. Kino-convert ang JSON text patungong mababasang Lua table matrix
            local parsedPayloads = HttpService:JSONDecode(rawJsonData)
            
            if not parsedPayloads then
                error("Korap o hindi mabasa ang JSON format!")
            end
            
            -- 3. Tinuturo ang eksaktong remote ng pinakamalapit na painting pad
            local targetRemote = paintPuzzle[closestStation.Name].Pad.Controls.Draw
            _G.AutoDrawEnabled = true
            
            -- 4. Isa-isang pina-fire ang mga nakuhang points
            task.spawn(function()
                notify("Auto Draw", "⚡ Nagsisimula nang iguhit ang data...", 2, "success")
                for _, segment in ipairs(parsedPayloads) do
                    if not _G.AutoDrawEnabled then break end
                    
                    local reconstructedArgs = {}
                    for _, argData in ipairs(segment) do
                        if argData.type == "CFrame" then
                            table.insert(reconstructedArgs, CFrame.new(unpack(argData.value)))
                        elseif argData.type == "Vector2" then
                            table.insert(reconstructedArgs, Vector2.new(argData.X, argData.Y))
                        elseif argData.type == "nil" then
                            table.insert(reconstructedArgs, nil)
                        else
                            table.insert(reconstructedArgs, argData.value)
                        end
                    end
                    
      
                    targetRemote:FireServer(unpack(reconstructedArgs))
                end
                notify("Success", "Tapos nang iguhit ang " .. closestStation.Name .. " nang perpekto!", 4, "success")
            end)
        end)
        
        if not success then
            notify("Error", "❌ Nagka-error sa pag-draw: " .. tostring(err), 4, "error")
        end
    else
        notify("Warning", "❌ Malayo ka sa kahit anong Paint Station! Lumapit ka muna.", 4, "alarm")
    end
end)


-- ====================================================================
-- CYCLE PAINTSTATION BUTTON (Isang click kada lipat: A -> B -> C -> D)
-- ====================================================================
local paintIndex = 1
local paintStations = {
    {letter = "A", name = "PaintStation A", cf = CFrame.new(105.499695, -429.446381, 9308.87793)},
    {letter = "B", name = "PaintStation B", cf = CFrame.new(73.4825668, -430.113983, 9490.88184)},
    {letter = "C", name = "PaintStation C", cf = CFrame.new(-141.955887, -430.113983, 9491.11816)},
    {letter = "D", name = "PaintStation D", cf = CFrame.new(-173.364304, -430.113983, 9491.08398)}
}

S3Tab.createCustomButton("Cycle Paintstation", "Teleport for Every Paintstation Location", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then 
        notify("Error", "Walang Character o HRP!", 2, "error")
        return 
    end

    -- Kunin ang kasalukuyang station base sa index
    local station = paintStations[paintIndex]

    -- Teleport sa kasalukuyang station (May Anti-Fling)
    rootPart.CFrame = station.cf
    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    notify("Paintstation", "🎨 Lumipat sa: " .. station.name, 1.5, "info")
    task.wait(0.2)

    -- I-trigger ang ProximityPrompt kung meron man (Gamitan ng pcall para di mag-crash)
    pcall(function()
        local promptPath = workspace:FindFirstChild("Section3") and workspace.Section3:FindFirstChild("PaintPuzzle")
        if promptPath then
            local targetStation = promptPath:FindFirstChild("PaintStation_" .. station.letter)
            if targetStation and targetStation:FindFirstChild("Pad") then
                local prompt = targetStation.Pad:FindFirstChild("Draw")
                if prompt and prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                    fireproximityprompt(prompt)
                end
            end
        end
    end)
    
    task.wait(0.2)
    
    -- Siguruhing i-pcall din ang executePixelStationDraw para hindi maputol ang index increment kapag nagka-error
    pcall(function()
        executePixelStationDraw(station.letter)
    end)

    -- I-akyat ang index para sa susunod na click
    paintIndex = paintIndex + 1
    if paintIndex > #paintStations then
        paintIndex = 1
        notify("Cycle Reset", "Umulit na sa PaintStation A!", 2, "success")
    end
end)


-- ====================================================================
-- 2. AUTO SUBMIT PILLAR BUTTON (Auto Held + Teleport to 4 Pillars)
-- ====================================================================
local isPillarSubmitRunning = false

S3Tab.createCustomButton("Auto Submit Pillar", "Auto-held drawing tool at teleport sa 4 pillars.", function()
    -- 🆕 Kung tumatakbo na, i-stop natin
    if isPillarSubmitRunning then
        isPillarSubmitRunning = false
        notify("Auto Pillar", "🛑 Stopping Auto Submit...", 2, "alarm")
        return
    end

    isPillarSubmitRunning = true

    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then 
        isPillarSubmitRunning = false
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    local pillars = {
        {name = "Pillar A", cf = CFrame.new(137.126053, -424.783478, 9257.35059, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)},
        {name = "Pillar B", cf = CFrame.new(-207.579758, -424.186523, 9249.00391, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)},
        {name = "Pillar C", cf = CFrame.new(-207.573715, -424.33197, 9552.47461, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)},
        {name = "Pillar D", cf = CFrame.new(137.130341, -424.574371, 9552.47656, -1.76429749e-05, -0.00451683998, -0.999989808, 0.00390645117, 0.999982178, -0.00451687444, 0.99999243, -0.00390649121, 0)}
    }

    local function getActiveDrawingTool()
        local toolName = "Drawing"
        local tool = character:FindFirstChild(toolName)
        if not tool and localPlayer:FindFirstChild("Backpack") then
            local bpTool = localPlayer.Backpack:FindFirstChild(toolName)
            if bpTool then
                humanoid:EquipTool(bpTool)
                task.wait(0.3)
                tool = character:FindFirstChild(toolName)
            end
        end
        return tool
    end

    task.spawn(function()
        notify("Auto Pillar", "🏛️ Nagsisimula na sa 4 Pillars...", 2, "info")

        for i, pillar in ipairs(pillars) do
            -- Check kung kinansela o namatay
            if not isPillarSubmitRunning or not rootPart or not rootPart.Parent then break end

            rootPart.CFrame = pillar.cf
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            
            notify("Auto Pillar", "Pinupuntahan ang " .. pillar.name, 1, "info")
            task.wait(0.3)

            if not isPillarSubmitRunning then break end

            -- Auto-held drawing tool action habang nasa pillar
            local drawingTool = getActiveDrawingTool()
            if drawingTool then
                pcall(function()
                    drawingTool:Activate()
                end)
            end
            
            task.wait(0.8)
        end

        if isPillarSubmitRunning then
            notify("Success", "✨ Natapos na ang Auto Submit sa lahat ng pillars", 3, "success")
        end
        
        isPillarSubmitRunning = false
    end)
end)



S3Tab.createCustomButton("Auto Exit Quest", "Submit ink, wait, claim bow, wait, and auto board the vehicle", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not rootPart or not humanoid then 
            notify("Error", "Character not found!", 3, "error")
            return 
        end
        
        local TweenService = game:GetService("TweenService")
        local toolName = "Ink"
        
        -- [[ 1. AUTO EQUIP INK ENGINE BEFORE START ]]
        if not character:FindFirstChild(toolName) then
            local tool = player.Backpack:FindFirstChild(toolName)
            if tool then
                humanoid:EquipTool(tool)
                task.wait(0.2)
            end
        end

        -- LIGTAS NA TWEEN ENGINE (May built-in Anti-Stuck at No-Clip)
        local function tweenTo(targetCFrame, enableNoClip)
            if not rootPart then return end
            
            local connection
            if enableNoClip then
                connection = game:GetService("RunService").Stepped:Connect(function()
                    if character then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end

            local distance = (rootPart.Position - targetCFrame.Position).Magnitude
            local speed = 250 
            local duration = distance / speed
            
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
            
            tween:Play()
            tween.Completed:Wait()
            
            if connection then 
                connection:Disconnect() 
            end
            
            -- I-reset ang bilis para rehistradong nakatayo ka sa eksaktong coordinate
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            task.wait(0.4) 
        end

        -- ========================================================
        -- STEP 1: TWEEN TO BUDDHA & SUBMIT INK
        -- ========================================================
        notify("Exit Quest", "Teleporting to submit Ink...", 2, "info")
        local submitInkCF = CFrame.new(-36.5126572, -428.145172, 9298.2168)
        tweenTo(submitInkCF, false) 
        
        local successInk, inkPrompt = pcall(function()
            return workspace.Section3.PaintPuzzle.Ingredients.PlaceInkHere.ProximityPrompt
        end)
        
        if successInk and inkPrompt and inkPrompt:IsA("ProximityPrompt") then
            inkPrompt.HoldDuration = 0
            task.spawn(function() fireproximityprompt(inkPrompt) end)
        end
        
        notify("Exit Quest", "Submitted Ink! Waiting 6 seconds...", 6, "info")
        task.wait(6.0)

        -- ========================================================
        -- STEP 2: TWEEN TO CLAIM BOW & FIRE PROMPT
        -- ========================================================
        notify("Exit Quest", "Teleporting to claim Bow...", 2, "info")
        local claimBowCF = CFrame.new(-33.8734093, -429.471313, 9482.53125)
        tweenTo(claimBowCF, false)
        
        local successBow, bowPrompt = pcall(function()
            return workspace.Section3.BowPuzzle.MagicBow.MagicArrow.ProximityPrompt
        end)
        
        if successBow and bowPrompt and bowPrompt:IsA("ProximityPrompt") then
            bowPrompt.HoldDuration = 0
            task.spawn(function() fireproximityprompt(bowPrompt) end)
        end
        
        notify("Exit Quest", "Claimed Bow! Waiting 6 seconds...", 6, "info")
        task.wait(6.0)

        -- ========================================================
        -- STEP 3: TWEEN TO GATE (PWERSAHANG NO-CLIP)
        -- ========================================================
        notify("Exit Quest", "Passing through Gate (No-Clip)...", 2, "info")
        local gateCF = CFrame.new(-35.0819931, -431.704712, 9195.42969, -0.998364747, 0, 0.0571646355, 0, 1, 0, -0.0571646355, 0, -0.998364747)
        
        tweenTo(gateCF, true) 
        
        notify("Exit Quest", "Passed Gate! Waiting 12 seconds...", 12, "info")
        task.wait(12.0) 

        -- ========================================================
        -- STEP 4: TWEEN TO CAR AND BOARD VEHICLE
        -- ========================================================
        notify("Exit Quest", "Boarding Vehicle...", 2, "info")
        local carCF = CFrame.new(71.8169327, -431.12738, 9146.96191)
        tweenTo(carCF, true) 
        
        local successCar, carPrompt = pcall(function()
            return workspace.Section3.Car.collision.ProximityPrompt
        end)
        
        if successCar and carPrompt and carPrompt:IsA("ProximityPrompt") then
            carPrompt.HoldDuration = 0
            task.spawn(function() fireproximityprompt(carPrompt) end)
        end

        notify("Success", "📣 AUTO CLAIM AND GO TO CAR FINISHED", 4, "success")
    end)
end)

if _G.CurrentCivilianBatch == nil then
    _G.CurrentCivilianBatch = 1
end

S4Tab.createCustomButton("Help Civilians", "Teleport under NPC safely, fire prompts, and end at Refuge", function()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not rootPart or not humanoid then 
            notify("Error", "Character not found!", 3, "error")
            return 
        end
        
        local section4 = workspace:FindFirstChild("Section4")
        local rescue = section4 and section4:FindFirstChild("Rescue")
        local npcsFolder = rescue and rescue:FindFirstChild("NPCs")
        local refugeLocation = CFrame.new(-97.4970551, -1.30489147, -2337.78174)
        
        if not npcsFolder then 
            notify("Error", "NPCs folder not found in Section 4!", 3, "error")
            return
        end
        
        -- Kunin ang mga kasalukuyang live NPCs sa folder
        local allCivilians = {}
        for _, child in pairs(npcsFolder:GetChildren()) do
            if child.Name == "Pose" then
                table.insert(allCivilians, child)
            end
        end
        
        local perBatch = 3
        local startIndex = ((_G.CurrentCivilianBatch - 1) * perBatch) + 1
        local endIndex = startIndex + (perBatch - 1)
        
        if startIndex > #allCivilians then
            _G.CurrentCivilianBatch = 1
            notify("Civilian", "Batch Counter Reset to 1", 2, "info")
            return
        end
        
        notify("Civilian", "Starting rescue for Batch " .. _G.CurrentCivilianBatch .. "...", 2, "info")
        
        -- I-activate ang PlatformStand para iwas fall animation glitch
        humanoid.PlatformStand = true
        
        -- Alisin ang lumang body velocity kung meron man
        local existingBV = rootPart:FindFirstChild("CivilianFlyVelocity")
        if existingBV then existingBV:Destroy() end
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "CivilianFlyVelocity"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = rootPart
        
        local rescueCount = 0
        for index = startIndex, endIndex do
            local npc = allCivilians[index]
            if not npc or not rootPart or not rootPart.Parent then break end
            
            local targetCFrame = npc:IsA("BasePart") and npc.CFrame or npc:IsA("Model") and npc:GetPivot()
            
            if targetCFrame then
                rescueCount = rescueCount + 1
                
                -- 1. Posisyon sa ilalim ng NPC (nakahiga at nakatingin paitaas)
                local npcPos = targetCFrame.Position
                local underPosition = npcPos - Vector3.new(0, 4, 0)
                
                rootPart.CFrame = CFrame.lookAt(underPosition, npcPos + Vector3.new(0, 5, 0))
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                
                task.wait(0.3) -- Mag-abang sandali para mag-load ang prompt sa paligid
                
                -- 2. Direktang hanapin ang ProximityPrompt
                local targetPrompt = nil
                
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                if hrp then
                    targetPrompt = hrp:FindFirstChildWhichIsA("ProximityPrompt")
                end
                
                if not targetPrompt then
                    targetPrompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                end
                
                if not targetPrompt then
                    for _, desc in pairs(npc:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") then
                            targetPrompt = desc
                            break
                        end
                    end
                end
                
                -- 3. I-fire ang nakitang ProximityPrompt nang paulit-ulit
                if targetPrompt then
                    pcall(function()
                        targetPrompt.HoldDuration = 0
                        targetPrompt.RequiresLineOfSight = false
                        for i = 1, 4 do
                            fireproximityprompt(targetPrompt)
                            task.wait(0.08)
                        end
                    end)
                end
                
                task.wait(0.4) -- Pahinga bago lumipat sa susunod na NPC ng batch
            end
        end
        
        -- 4. Pagkatapos makuha ang batch ng 3, diretsong lipad sa Refuge
        if rescueCount > 0 and rootPart and rootPart.Parent then
            rootPart.CFrame = refugeLocation
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            task.wait(1.5) -- Oras para ma-detect ng Refuge zone
            
            -- Linisin ang fly state pagdating sa Refuge
            if rootPart:FindFirstChild("CivilianFlyVelocity") then
                rootPart.CivilianFlyVelocity:Destroy()
            end
            humanoid.PlatformStand = false
            rootPart.Anchored = false
        end
        
        -- I-advance ang batch counter para sa susunod na click ng button
        if (endIndex < #allCivilians) then
            _G.CurrentCivilianBatch = _G.CurrentCivilianBatch + 1
        else
            _G.CurrentCivilianBatch = 1
        end
        
        notify("Success", "✨ Helped " .. rescueCount .. " Civilians!", 3, "success")
    end)
end)

-- ====================================================================
-- ENZUKAI-RYU ESP TOGGLE
-- ====================================================================
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Variables para sa ESP Tracker at Connections
local enzukaiEspFolder = nil
local enzukaiEspConnection = nil
local enzukaiHighlightTracker = {}

S4Tab.createToggle("Enzukai-Ryu ESP", "Highlights Enzukai-Ryu boss with ESP and name tag", function(state)
    local folderName = "EnzukaiESPFolder"
    
    if state then
        -- ===== STATE IS TRUE (TOGGLE ON) =====
        if not Workspace:FindFirstChild(folderName) then
            enzukaiEspFolder = Instance.new("Folder")
            enzukaiEspFolder.Name = folderName
            enzukaiEspFolder.Parent = Workspace
        else
            enzukaiEspFolder = Workspace[folderName]
        end
        
        local function createEnzukaiESP(targetModel)
            if not targetModel or not enzukaiEspFolder then return end
            if targetModel:FindFirstChild("EnzukaiHighlight") then return end
            
            -- Highlight effect
            local highlight = Instance.new("Highlight")
            highlight.Name = "EnzukaiHighlight"
            highlight.Adornee = targetModel
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.4
            highlight.OutlineTransparency = 0
            highlight.Parent = enzukaiEspFolder
            
            enzukaiHighlightTracker[targetModel] = highlight

            -- Billboard Name Tag
            local head = targetModel:FindFirstChild("Head") or targetModel:FindFirstChild("HumanoidRootPart") or targetModel.PrimaryPart
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "EnzukaiBillboard"
                billboard.Size = UDim2.new(0, 160, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = head
                billboard.Parent = enzukaiEspFolder

                local textLabel = Instance.new("TextLabel", billboard)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = "ENZUKAI RYU"
                textLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextStrokeTransparency = 0
            end
        end
        
        -- I-scan ang kasalukuyang naroon
        local section4 = Workspace:FindFirstChild("Section4")
        local bossMonster = section4 and section4:FindFirstChild("BossMonster")
        local enzukai = bossMonster and bossMonster:FindFirstChild("EnzukaiRyu")
        if enzukai then 
            createEnzukaiESP(enzukai) 
        end
        
        -- Dynamic listener kung sakaling mag-spawn
        if bossMonster then
            enzukaiEspConnection = bossMonster.ChildAdded:Connect(function(child)
                if child.Name == "EnzukaiRyu" then
                    task.wait(0.5)
                    createEnzukaiESP(child)
                end
            end)
        end
        
        notify("ESP Active", "🔥 Enzukai-Ryu ESP: ON", 3, "success")
    else
        -- ===== STATE IS FALSE (TOGGLE OFF) =====
        if enzukaiEspConnection then
            enzukaiEspConnection:Disconnect()
            enzukaiEspConnection = nil
        end
        
        for model, highlight in pairs(enzukaiHighlightTracker) do
            if highlight then highlight:Destroy() end
        end
        table.clear(enzukaiHighlightTracker)
        
        if enzukaiEspFolder then
            enzukaiEspFolder:Destroy()
            enzukaiEspFolder = nil
        end
        
        notify("ESP Status", "⚪ Enzukai-Ryu ESP: OFF", 2, "info")
    end
end)


-- ====================================================================
-- WEAKPOINTS ESP TOGGLE
-- ====================================================================
local coreGui = game:GetService("CoreGui")
local weakPointsFolder = nil
local espTracker = {} 
local folderConnection = nil 

local targetEyes = {
    ["EyeA"] = true, ["EyeB"] = true, ["EyeC"] = true, ["EyeD"] = true, ["EyeE"] = true
}

local function getWeakPointsFolder()
    local section4 = workspace:FindFirstChild("Section4")
    local weakPoints = section4 and section4:FindFirstChild("WeakPoints")
    return weakPoints and weakPoints:FindFirstChild("Points")
end

local function createEyeESP(part)
    if not part:IsA("BasePart") or espTracker[part] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "IOHUB_EyeESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 100) 
    highlight.FillTransparency = 0.4 
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
    highlight.OutlineTransparency = 0 
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
    highlight.Adornee = part
    highlight.Parent = coreGui 
    
    espTracker[part] = highlight
end

local function checkWeakPoint(weakPoint)
    if weakPoint.Name == "EnzukaiWeakPoint" then
        for _, child in pairs(weakPoint:GetChildren()) do
            if targetEyes[child.Name] then
                createEyeESP(child)
            end
        end
    end
end

S4Tab.createToggle("WeakPoints ESP", "Highlights EyeA-EyeE inside all EnzukaiWeakPoints", function(state)
    if state then
        -- ===== STATE IS TRUE (TOGGLE ON) =====
        weakPointsFolder = getWeakPointsFolder()
        if not weakPointsFolder then 
            notify("ESP Error", "❌ Section 4 Workspace Folder Didn't Load", 3, "error")
            return 
        end
        
        -- 1. I-scan lahat ng EnzukaiWeakPoint na nandyan na
        for _, child in pairs(weakPointsFolder:GetChildren()) do
            checkWeakPoint(child)
        end
        
        -- 2. I-on ang dynamic listener para sa mga bagong spawn
        folderConnection = weakPointsFolder.ChildAdded:Connect(function(child)
            task.wait(0.1) 
            checkWeakPoint(child)
        end)
        
        notify("ESP Active", "👁️ Boss WeakPoints ESP: ON", 3, "success")
    else
        -- ===== STATE IS FALSE (TOGGLE OFF) =====
        -- 1. Patayin ang event listener
        if folderConnection then
            folderConnection:Disconnect()
            folderConnection = nil
        end
        
        -- 2. Burahin lahat ng nakakabit na neon highlights
        for part, highlight in pairs(espTracker) do
            if highlight then highlight:Destroy() end
        end
        table.clear(espTracker)
        
        notify("ESP Status", "⚪ Boss WeakPoints ESP: OFF", 2, "info")
    end
end)


-- ====================================================================
-- SECTION 4: SMART AUTO FARM (WEAKPOINTS & BOSS LOCK) + AUTO ROTATE
-- ====================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Kunin ang Custom Camera Controller ng laro
local Controllers = nil
pcall(function()
    Controllers = require(ReplicatedStorage.Client.Controllers)
end)

_G.S4AutoActive = false
_G.S4LoopThread = nil
_G.S4NoclipConn = nil
_G.S4PhysicsConn = nil
_G.S4BossState = nil
_G.PurgeCFrame = CFrame.new(-97.4970551, -1.30489147, -2337.78174) -- Safe spot

_G.S4CurrentMode = "Idle"
_G.S4TargetCFrame = nil
_G.S4TargetLookPos = nil -- 🆕 Para sa camera rotation
_G.S4LastMode = ""       -- 🆕 Para hindi mag-spam ang notif
_G.S4LastTargetName = "" -- 🆕 Para hindi mag-spam ang notif

-- ==========================================
-- CLEANUP & FIREBOW
-- ==========================================
local function cleanupS4(teleportToSafe)
    _G.S4AutoActive = false
    _G.S4CurrentMode = "Idle"
    _G.S4TargetCFrame = nil
    _G.S4TargetLookPos = nil
    _G.S4LastMode = ""
    _G.S4LastTargetName = ""
    
    if _G.S4NoclipConn then _G.S4NoclipConn:Disconnect(); _G.S4NoclipConn = nil end
    if _G.S4PhysicsConn then _G.S4PhysicsConn:Disconnect(); _G.S4PhysicsConn = nil end
    
    local char = player.Character
    if char then
        local rp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if rp then
            local bv = rp:FindFirstChild("CustomFlyVelocity")
            if bv then bv:Destroy() end
            
            if teleportToSafe then
                rp.CFrame = _G.PurgeCFrame
                rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        if hum then 
            hum.PlatformStand = false 
            hum:ChangeState(Enum.HumanoidStateType.Landed)
        end
    end
    
    if _G.S4LoopThread then 
        if coroutine.running() ~= _G.S4LoopThread then
            task.cancel(_G.S4LoopThread) 
        end
        _G.S4LoopThread = nil 
    end
    
    _G.S4BossState = nil
end

local function fireBow(targetPart, chargeTime)
    chargeTime = chargeTime or 0
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local backpack = player.Backpack
    if not rootPart or not humanoid or not targetPart then return end

    local bow = character:FindFirstChild("SpiritBow") or backpack:FindFirstChild("SpiritBow")
    if bow and bow.Parent == backpack then
        humanoid:EquipTool(bow)
        task.wait(0.2)
    end

    local remote = nil
    if bow then
        remote = bow:FindFirstChild("RemoteEvent", true) or bow:FindFirstChild("Remote", true)
    end
    if not remote then
        remote = Workspace:FindFirstChild("SpiritBow", true) and Workspace.SpiritBow:FindFirstChild("RemoteEvent", true)
    end

    if remote and _G.S4AutoActive then
        local lv = (targetPart.Position - rootPart.Position).Unit
        remote:FireServer(0, false, lv)
        task.wait(chargeTime)
        if _G.S4AutoActive then
            remote:FireServer(0, true, lv)
        end
    end
end

-- ==========================================
-- MAIN BUTTON & LOGIC
-- ==========================================
S4Tab.createCustomButton("Auto Eyes and Enzukai-Ryu", "Dynamic Eye Lock, 0.8s Bow Hold sa Boss. Auto-Safe pag pinatay.", function()
    if _G.S4AutoActive then
        cleanupS4(true)
        notify("S4 Auto Farm", "🔴 Stopped & Returned to Safe Spot", 2, "error")
        return
    end

    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then 
        notify("Error", "No Character Found", 3, "error")
        return 
    end

    cleanupS4(false) 
    _G.S4AutoActive = true
    notify("S4 Auto Farm", "🟢 Started", 2, "success")

    _G.S4NoclipConn = RunService.Stepped:Connect(function()
        if not _G.S4AutoActive then return end
        local charRef = player.Character
        if charRef then
            for _, part in pairs(charRef:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    _G.S4PhysicsConn = RunService.RenderStepped:Connect(function()
        if not _G.S4AutoActive then return end
        local charRef = player.Character
        local rp = charRef and charRef:FindFirstChild("HumanoidRootPart")
        local hum = charRef and charRef:FindFirstChildOfClass("Humanoid")
        if not rp or not hum then return end

        -- Movement logic (Teleport lock)
        if _G.S4CurrentMode ~= "Idle" and _G.S4TargetCFrame then
            rp.CFrame = _G.S4TargetCFrame
            rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            if _G.S4CurrentMode == "Boss" then
                hum.PlatformStand = false
                local bv = rp:FindFirstChild("CustomFlyVelocity")
                if bv then bv:Destroy() end
            elseif _G.S4CurrentMode == "Eye" then
                hum.PlatformStand = true
                local bv = rp:FindFirstChild("CustomFlyVelocity")
                if not bv then
                    bv = Instance.new("BodyVelocity")
                    bv.Name = "CustomFlyVelocity"
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = rp
                end
            end
        else
            hum.PlatformStand = false
            local bv = rp:FindFirstChild("CustomFlyVelocity")
            if bv then bv:Destroy() end
        end

        -- 🆕 CAMERA ENFORCE ROTATION
        if _G.S4TargetLookPos and Controllers and Controllers.camera then
            local cam = workspace.CurrentCamera
            if cam then
                local targetCFrame = CFrame.lookAt(cam.CFrame.Position, _G.S4TargetLookPos)
                local x, y, _ = targetCFrame:ToOrientation()
                pcall(function()
                    Controllers.camera:Enforce(Vector2.new(math.deg(x), math.deg(y)))
                end)
            end
        end
    end)

    _G.S4LoopThread = task.spawn(function()
        while _G.S4AutoActive do
            pcall(function()
                local charRef = player.Character
                local rp = charRef and charRef:FindFirstChild("HumanoidRootPart")
                if not rp or not _G.S4AutoActive then return end

                local mainGui = player.PlayerGui:FindFirstChild("S4")
                if not mainGui or not mainGui.Enabled then
                    _G.S4CurrentMode = "Idle"
                    _G.S4TargetLookPos = nil
                    
                    if _G.S4LastMode ~= "Idle" then
                        notify("S4 Auto Farm", "💤 GUI Closed - Idle", 2, "warning")
                        _G.S4LastMode = "Idle"
                        _G.S4LastTargetName = ""
                    end
                    task.wait(0.3)
                    return
                end

                local frame = mainGui:FindFirstChild("Frame")
                local isBossPhase = frame and frame.Visible

                if isBossPhase then
                    -- ==========================================
                    -- BOSS LOCK (0.8s BOW HOLD)
                    -- ==========================================
                    local section4 = Workspace:FindFirstChild("Section4")
                    local bossMonster = section4 and section4:FindFirstChild("BossMonster")
                    local boss = bossMonster and bossMonster:FindFirstChild("EnzukaiRyu")

                    if boss and boss:FindFirstChild("HumanoidRootPart") then
                        local bRoot = boss.HumanoidRootPart
                        local bossHum = boss:FindFirstChildOfClass("Humanoid")
                        local currentState = boss:GetAttribute("State")
                        local headHitbox = boss:FindFirstChild("HeadHitBox")

                        if _G.S4BossState == nil then _G.S4BossState = currentState end

                        if currentState ~= _G.S4BossState then
                            notify("S4 Auto Farm", "⚠️ Boss State Changed! Going to Safe Spot...", 3, "alarm")
                            _G.S4BossState = nil
                            _G.S4CurrentMode = "Idle"
                            _G.S4TargetLookPos = nil
                            rp.CFrame = _G.PurgeCFrame
                            rp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                            
                            while _G.S4AutoActive do
                                local s4g = player.PlayerGui:FindFirstChild("S4")
                                local f = s4g and s4g:FindFirstChild("Frame")
                                if not s4g or not s4g.Enabled or not (f and f.Visible) then break end
                                task.wait(0.1)
                            end
                            return
                        end

                        _G.S4CurrentMode = "Boss"
                        _G.S4TargetCFrame = bRoot.CFrame - Vector3.new(0, 30, 0)
                        
                        if headHitbox then
                            _G.S4TargetLookPos = headHitbox.Position -- 🆕 Target para sa Camera

                            -- Notify kapag nag-umpisa mag-lock sa Boss
                            if _G.S4LastMode ~= "Boss" or _G.S4LastTargetName ~= "EnzukaiRyu" then
                                notify("S4 Auto Farm", "🎯 Target: EnzukaiRyu (Boss Phase)", 2, "info")
                                _G.S4LastMode = "Boss"
                                _G.S4LastTargetName = "EnzukaiRyu"
                            end

                            -- 0.8s HOLD TIME SA BOSS
                            fireBow(headHitbox, 0.8) 
                            
                            local initialHP = bossHum and bossHum.Health or 0
                            local timeout = 0
                            while _G.S4AutoActive and boss and boss.Parent do
                                if bossHum and bossHum.Health < initialHP then
                                    break
                                end
                                task.wait(0.03)
                                timeout = timeout + 0.03
                                if timeout >= 0.8 then
                                    break
                                end
                            end
                        end
                    else
                        _G.S4CurrentMode = "Idle"
                        _G.S4TargetLookPos = nil
                        if _G.S4LastMode ~= "Idle" then
                            notify("S4 Auto Farm", "🔍 Waiting for Boss to spawn...", 2, "warning")
                            _G.S4LastMode = "Idle"
                            _G.S4LastTargetName = ""
                        end
                    end
                    task.wait(0.1)

                else
                    -- ==========================================
                    -- EYE LOCK (DYNAMIC CFrame)
                    -- ==========================================
                    _G.S4BossState = nil

                    local points = Workspace:FindFirstChild("Section4")
                                  and Workspace.Section4:FindFirstChild("WeakPoints")
                                  and Workspace.Section4.WeakPoints:FindFirstChild("Points")
                    
                    local activeWeakPoint = nil
                    local targetHitbox = nil
                    local targetEyeLetter = nil

                    if points then
                        for _, wp in ipairs(points:GetChildren()) do
                            for _, letter in ipairs({"A", "B", "C", "D", "E"}) do
                                local eye = wp:FindFirstChild("Eye" .. letter)
                                local hitbox = wp:FindFirstChild("HitBox" .. letter)
                                if eye and hitbox and eye:IsA("BasePart") and eye.Transparency < 1 then
                                    activeWeakPoint = wp
                                    targetHitbox = hitbox
                                    targetEyeLetter = letter
                                    break
                                end
                            end
                            if activeWeakPoint then break end
                        end
                    end

                    if activeWeakPoint and targetHitbox then
                        _G.S4CurrentMode = "Eye"
                        
                        local wpPivot = activeWeakPoint:GetPivot()
                        
                        -- Old Offset
                        local adjustedPosition = wpPivot.Position + Vector3.new(0, -15, 0) + (wpPivot.LookVector * -10) + (wpPivot.RightVector * 28)
                        
                        _G.S4TargetCFrame = CFrame.lookAt(adjustedPosition, targetHitbox.Position)
                        _G.S4TargetLookPos = targetHitbox.Position -- 🆕 Target para sa Camera

                        -- Notify kapag nagpalit ng Eye target
                        if _G.S4LastMode ~= "Eye" or _G.S4LastTargetName ~= targetEyeLetter then
                            notify("S4 Auto Farm", "👁️ Target: Eye " .. targetEyeLetter, 2, "info")
                            _G.S4LastMode = "Eye"
                            _G.S4LastTargetName = targetEyeLetter
                        end

                        task.wait(0.15)

                        if _G.S4AutoActive and _G.S4CurrentMode == "Eye" then
                            fireBow(targetHitbox, 0.1) 

                            local timeout = 0
                            while _G.S4AutoActive and targetHitbox and targetHitbox.Parent do
                                local parentWP = targetHitbox.Parent
                                local eyeCheck = parentWP:FindFirstChild("Eye" .. targetHitbox.Name:gsub("HitBox", ""))
                                if eyeCheck and eyeCheck.Transparency >= 1 then
                                    break
                                end
                                task.wait(0.03)
                                timeout = timeout + 0.03
                                if timeout >= 0.8 then
                                    break
                                end
                            end
                        end
                        task.wait(0.05)
                    else
                        _G.S4CurrentMode = "Idle"
                        _G.S4TargetLookPos = nil
                        if _G.S4LastMode ~= "Idle" then
                            notify("S4 Auto Farm", "🔍 Searching for open eyes...", 2, "warning")
                            _G.S4LastMode = "Idle"
                            _G.S4LastTargetName = ""
                        end
                        task.wait(0.1)
                    end
                end
            end)

            if not _G.S4AutoActive then break end
            task.wait(0.01) 
        end
    end)
end)


-- ====================================================================
-- SECTION 4: KILL 3 MONSTERS + AUTO SPIRITBOW ATTACK (WITH AUTO LOOK)
-- ====================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

-- Kunin ang Custom Camera Controller
local Controllers = nil
pcall(function()
    Controllers = require(ReplicatedStorage.Client.Controllers)
end)

local isKill3MonstersActive = false
local bossLoopConn = nil
local noclipConn = nil
local attackLoopConn = nil

_G.CurrentTargetMonster = nil
_G.S4KillLookPos = nil
_G.S4LastKillTarget = ""

S4Tab.createCustomButton("Auto Kill Rin, Tsukiya, Kyogi", "Lock on their Back and Auto Hit (Requires Health <= 30%)", function()
    -- ==========================================
    -- STOP LOGIC (Kung naka-ON na)
    -- ==========================================
    if isKill3MonstersActive then
        isKill3MonstersActive = false
        
        if bossLoopConn then bossLoopConn:Disconnect() bossLoopConn = nil end
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        if attackLoopConn then task.cancel(attackLoopConn) attackLoopConn = nil end
        _G.CurrentTargetMonster = nil
        _G.S4KillLookPos = nil
        _G.S4LastKillTarget = ""
        
        notify("Auto Kill", "🔴 Kill 3 Monsters: OFF", 2, "error")
        return
    end
    
    -- ==========================================
    -- START LOGIC (Health Condition Check - 30% Below)
    -- ==========================================
    local s4Gui = localPlayer.PlayerGui:FindFirstChild("S4")
    local healthFront = s4Gui and s4Gui:FindFirstChild("Health") and s4Gui.Health:FindFirstChild("Front")
    
    if not healthFront then
        notify("Auto Kill", "❌ Cannot start: Health UI not found", 2, "error")
        return
    end

    -- ✅ INAYOS: Ginawang math.min para makuha yung totoong health scale
    local currentHealthScale = math.min(healthFront.Size.X.Scale, healthFront.Size.Y.Scale)
    
    -- Papayagan lang kung 30% (0.3) pababa ang health bar
    if currentHealthScale > 0.3 then
        notify("Auto Kill", "❌ Cannot start: Health is above 30%", 2, "error")
        return
    end
    
    -- Kapag pasado sa condition, dito palang mag-o-ON
    isKill3MonstersActive = true
    notify("Auto Kill", "🟢 Kill 3 Monsters: ON", 2, "success")
    
    local lastPosition = Vector3.new(0, 0, 0)
    local timeStationary = 0
    local defaultDistance = 25
    local currentDistance = defaultDistance
    
    -- [[ 1. BUILT-IN NOCLIP LOOP ]]
    noclipConn = RunService.Stepped:Connect(function()
        if not isKill3MonstersActive then return end
        local character = localPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    -- [[ 2. MAIN BACK-LOCK, SMART SWITCHING & AUTO LOOK LOOP ]]
    bossLoopConn = RunService.RenderStepped:Connect(function()
        if not isKill3MonstersActive then return end
        
        local character = localPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local section4 = Workspace:FindFirstChild("Section4")
        local targetMonster = nil
        
        if section4 then
            local m2 = section4:FindFirstChild("Monster2")
            local m3 = section4:FindFirstChild("Monster3")
            local m4 = section4:FindFirstChild("Monster4")
            
            local rin2 = m2 and m2:FindFirstChild("Rin2")
            local tsukiya2 = m4 and m4:FindFirstChild("Tsukiya2")
            local tenome2 = m3 and m3:FindFirstChild("Tenome2")
            
            local function isAlive(monster)
                if not monster then return false end
                local hum = monster:FindFirstChildOfClass("Humanoid")
                local root = monster:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    return true
                end
                return false
            end
            
            if isAlive(rin2) then
                targetMonster = rin2
            elseif isAlive(tsukiya2) then
                targetMonster = tsukiya2
            elseif isAlive(tenome2) then
                targetMonster = tenome2
            else
                targetMonster = rin2 or tsukiya2 or tenome2
            end
        end
        
        _G.CurrentTargetMonster = targetMonster
        
        if targetMonster and targetMonster:FindFirstChild("HumanoidRootPart") then
            -- Notify kapag nagpalit ng target
            if _G.S4LastKillTarget ~= targetMonster.Name then
                notify("Auto Kill", "🎯 Target Switched: " .. targetMonster.Name, 2, "info")
                _G.S4LastKillTarget = targetMonster.Name
            end

            local monsterRoot = targetMonster.HumanoidRootPart
            local monsterHumanoid = targetMonster:FindFirstChildOfClass("Humanoid")
            
            local deathPrompt = targetMonster:FindFirstChildWhichIsA("ProximityPrompt", true) 
                             or targetMonster:FindFirstChild("ProximityPrompt", true)
            
            local distanceMoved = (monsterRoot.Position - lastPosition).Magnitude
            
            if (monsterHumanoid and monsterHumanoid.Health <= 0) or (deathPrompt and deathPrompt.Enabled) or (distanceMoved < 0.2) then
                timeStationary = timeStationary + 0.016
            else
                timeStationary = 0
                currentDistance = defaultDistance 
                lastPosition = monsterRoot.Position
            end
            
            if timeStationary >= 5.0 or (deathPrompt and deathPrompt.Enabled) then
                currentDistance = 0
            end
            
            if currentDistance == 0 then
                rootPart.CFrame = monsterRoot.CFrame
            else
                rootPart.CFrame = monsterRoot.CFrame * CFrame.new(0, 2, currentDistance)
            end
            
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            -- Update Look Position (Nakatutok sa Hitbox ng kalaban)
            local hitbox = targetMonster:FindFirstChild("Hitbox")
            if hitbox then
                _G.S4KillLookPos = hitbox.Position
            else
                _G.S4KillLookPos = monsterRoot.Position
            end

            if deathPrompt and deathPrompt.Enabled then
                deathPrompt.HoldDuration = 0
                fireproximityprompt(deathPrompt)
            end
        else
            _G.S4KillLookPos = nil
        end

        -- 🆕 CAMERA ENFORCE ROTATION
        if _G.S4KillLookPos and Controllers and Controllers.camera then
            local cam = Workspace.CurrentCamera
            if cam then
                local targetCFrame = CFrame.lookAt(cam.CFrame.Position, _G.S4KillLookPos)
                local x, y, _ = targetCFrame:ToOrientation()
                pcall(function()
                    Controllers.camera:Enforce(Vector2.new(math.deg(x), math.deg(y)))
                end)
            end
        end
    end)
    
    -- [[ 3. SPIRITBOW AUTO ATTACK LOOP ]]
    attackLoopConn = task.spawn(function()
        while isKill3MonstersActive do
            pcall(function()
                local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local backpack = localPlayer.Backpack
                
                if not isKill3MonstersActive then return end
                
                local targetMonster = _G.CurrentTargetMonster
                if targetMonster and targetMonster:FindFirstChild("Hitbox") and rootPart then
                    local hitbox = targetMonster.Hitbox
                    local monsterHumanoid = targetMonster:FindFirstChildOfClass("Humanoid")
                    
                    if monsterHumanoid and monsterHumanoid.Health > 0 then
                        local spiritBowTool = character:FindFirstChild("SpiritBow") or backpack:FindFirstChild("SpiritBow")
                        if spiritBowTool and spiritBowTool.Parent == backpack and humanoid then
                            humanoid:EquipTool(spiritBowTool)
                            task.wait(0.3)
                        end
                        
                        if not isKill3MonstersActive then return end
                        
                        local remote = nil
                        if spiritBowTool then
                            remote = spiritBowTool:FindFirstChild("RemoteEvent", true) or spiritBowTool:FindFirstChild("Remote", true)
                        end
                        if not remote then
                            remote = Workspace:FindFirstChild("SpiritBow", true) and Workspace.SpiritBow:FindFirstChild("RemoteEvent", true)
                        end
                        
                        local targetLookVector = (hitbox.Position - rootPart.Position).Unit
                        
                        if remote and isKill3MonstersActive then
                            remote:FireServer(0, false, targetLookVector)
                            task.wait(0)
                            
                            if not isKill3MonstersActive then return end
                            
                            remote:FireServer(0, true, targetLookVector)
                        end
                    end
                end
            end)
            
            if not isKill3MonstersActive then break end
            task.wait(1.0)
        end
    end)
end)


S5StartTab.createCustomButton("Trigger Cinematic", "Triggers the Final Form Intro Cinematic", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not rootPart then 
        notify("Error", "Character not found!", 3, "error")
        return 
    end

    -- Safe Pathing para sa IntroTrigger
    local section5 = workspace:FindFirstChild("Section5")
    local finalForm = section5 and section5:FindFirstChild("FinalForm")
    local introTrigger = finalForm and finalForm:FindFirstChild("IntroTrigger")

    if introTrigger and introTrigger:IsA("BasePart") then
        -- Fire Touch Interest (0 = Touch, 1 = Untouch)
        pcall(function()
            firetouchinterest(introTrigger, rootPart, 0)
            task.wait(0.1)
            firetouchinterest(introTrigger, rootPart, 1)
        end)
        
        notify("Cinematic", "🎬 Intro Trigger Touched!", 2, "success")
    else
        notify("Error", "❌ IntroTrigger not found! Make sure you are in Section 5.", 3, "error")
    end
end)



-- ====================================================================
-- BUTTON: DELETE WEAKPOINTS CUBE (SECTION 5)
-- ====================================================================
S5Tab.createCustomButton("Delete Weakpoints Cube", "Removes all 'Cube' MeshParts inside Section 5 Weakpoints", function()
    -- Hanapin ang Points folder
    local section5 = workspace:FindFirstChild("Section5")
    local points = section5 and section5:FindFirstChild("WeakPoints") and section5.WeakPoints:FindFirstChild("Points")
    
    if points then
        local deletedCount = 0
        
        -- I-scan lahat ng descendants (kahit nakabaon pa)
        for _, obj in ipairs(points:GetDescendants()) do
            if obj.Name == "Cube" and obj:IsA("BasePart") then
                obj:Destroy()
                deletedCount = deletedCount + 1
            end
        end
        
        -- Notification feedback
        if deletedCount > 0 then
            notify("S5 Helper", "🗑️ Deleted " .. deletedCount .. " Cube(s)!", 2, "success")
        else
            notify("S5 Helper", "❌ No Cubes found to delete.", 2, "info")
        end
    else
        notify("S5 Helper", "❌ Section 5 Points not found!", 2, "error")
    end
end)




-- ====================================================================
-- WEAKPOINTS ESP TOGGLE (SECTION 5) - Self-Contained (No UI Conflict)
-- ====================================================================
S5StartTab.createToggle("WeakPoints ESP", "Highlights EyeA-EyeE inside all EnzukaiWeakPoints", function(state)
    -- ==========================================
    -- MGA VARIABLES NA NASA LOOB LANG NG STATE
    -- ==========================================
    local s5CoreGui = game:GetService("CoreGui")
    local s5TargetEyes = { ["EyeA"] = true, ["EyeB"] = true, ["EyeC"] = true, ["EyeD"] = true, ["EyeE"] = true }
    
    -- Gagamit tayo ng _G para ma-access natin ito kapag pinatay (OFF) yung toggle
    if state then
        -- ==========================================
        -- TOGGLE ON
        -- ==========================================
        _G.S5_EspTracker = {}
        
        local function createS5EyeESP(part)
            if not part:IsA("BasePart") or _G.S5_EspTracker[part] then return end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "IOHUB_EyeESP_S5"
            highlight.FillColor = Color3.fromRGB(255, 0, 100) 
            highlight.FillTransparency = 0.4 
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
            highlight.OutlineTransparency = 0 
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
            highlight.Adornee = part
            highlight.Parent = s5CoreGui 
            
            _G.S5_EspTracker[part] = highlight
        end

        local function checkS5WeakPoint(weakPoint)
            if weakPoint.Name == "EnzukaiWeakPoint" then
                for _, child in pairs(weakPoint:GetChildren()) do
                    if s5TargetEyes[child.Name] then
                        createS5EyeESP(child)
                    end
                end
            end
        end

        local function scanAndConnect()
            local section5 = workspace:FindFirstChild("Section5")
            local weakPoints = section5 and section5:FindFirstChild("WeakPoints")
            local points = weakPoints and weakPoints:FindFirstChild("Points")

            if not points then 
                notify("ESP Error", "Section 5 Points not loaded yet!", 3, "error")
                return 
            end

            -- 1. I-scan lahat ng nandyan na
            for _, child in pairs(points:GetChildren()) do
                checkS5WeakPoint(child)
            end
            
            -- 2. I-connect ang dynamic listener
            _G.S5_EspConn = points.ChildAdded:Connect(function(child)
                task.wait(0.1) 
                checkS5WeakPoint(child)
            end)

            notify("ESP Active", "👁️ S5 WeakPoints ESP: ON", 3, "success")
        end

        -- Kung hindi pa naka-load, mag-hintay ng 3 seconds bago mag-scan ulit
        local s5Section = workspace:FindFirstChild("Section5")
        if s5Section and s5Section:FindFirstChild("WeakPoints") and s5Section.WeakPoints:FindFirstChild("Points") then
            scanAndConnect()
        else
            notify("ESP Loader", "Waiting for Section 5 to load...", 2, "info")
            task.spawn(function()
                task.wait(2) -- Bigyan ng 2 seconds para mag-load
                if _G.S5_EspConn == nil then -- Check kung hindi pa na-ooverwrite
                    scanAndConnect()
                end
            end)
        end
        
    else
        -- ==========================================
        -- TOGGLE OFF
        -- ==========================================
        -- 1. Disconnect ang listener
        if _G.S5_EspConn then
            _G.S5_EspConn:Disconnect()
            _G.S5_EspConn = nil
        end
        
        -- 2. Burahin lahat ng highlights
        if _G.S5_EspTracker then
            for part, highlight in pairs(_G.S5_EspTracker) do
                if highlight then highlight:Destroy() end
            end
            _G.S5_EspTracker = nil
        end
        
        notify("ESP Status", "⚪ S5 WeakPoints ESP: OFF", 2, "info")
    end
end)


-- ====================================================================
-- SECTION 5: ENZUKAI RYUJIN HELPERS (TOGGLES) - AUTO TAB ONLY
-- ====================================================================
local safeSpotS5 = CFrame.new(51.451, 4.826, -0.192)
local isSlamActive = false
local isSlamActiveFinal = false

-- Shared Helper Functions
local function tpSafeS5()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        hrp.CFrame = safeSpotS5
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        local bv = hrp:FindFirstChild("CustomFlyVelocity")
        if bv then bv:Destroy() end
        if hum then hum.PlatformStand = false end
    end
end

local function isFinalFormActiveS5()
    local s5Gui = localPlayer.PlayerGui:FindFirstChild("S5")
    local frame = s5Gui and s5Gui:FindFirstChild("Frame")
    return frame and frame.Visible
end

local function fireBowS5(targetPart, chargeTime, isEyesToggle)
    chargeTime = chargeTime or 0.1
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local backpack = localPlayer.Backpack
    if not rootPart or not humanoid or not targetPart then return end

    local bow = character:FindFirstChild("SpiritBow") or backpack:FindFirstChild("SpiritBow")
    if bow and bow.Parent == backpack then
        humanoid:EquipTool(bow)
        task.wait(0.3)
    end

    local remote = nil
    if bow then
        remote = bow:FindFirstChild("RemoteEvent", true) or bow:FindFirstChild("Remote", true)
    end
    if not remote then
        remote = workspace:FindFirstChild("SpiritBow", true) and workspace.SpiritBow:FindFirstChild("RemoteEvent", true)
    end

    local isActive = isEyesToggle and _G.S5EyesActive or _G.S5FinalActive

    if remote and isActive then
        local lv = (targetPart.Position - rootPart.Position).Unit
        remote:FireServer(0, false, lv)
        task.wait(chargeTime)
        if isActive then
            remote:FireServer(0, true, lv)
        end
    end
end

-- Global states
_G.S5YaxisActive = false
_G.S5LaserActive = false
_G.S5EyesActive = false
_G.S5FinalActive = false

-- ==========================================
-- TOGGLE 1: Y-Axis Safe Spot
-- ==========================================
local yaxisThread = nil
S5Tab.createToggle("Slam Auto Safe Spot", "Teleport to Safe Spot if boss Y >= 85", function(state)
    _G.S5YaxisActive = state
    if state then
        notify("S5 Helper", "Slam Safe Spot: ON", 2, "success")
        yaxisThread = task.spawn(function()
            while _G.S5YaxisActive do
                task.wait() 
                local section5 = workspace:FindFirstChild("Section5")
                local finalForm = section5 and section5:FindFirstChild("FinalForm")
                local boss = finalForm and finalForm:FindFirstChild("EnzukaiRyujin")
                local headHitBox = boss and boss:FindFirstChild("HeadHitBox")
                
                if headHitBox and headHitBox:IsA("BasePart") then
                    if headHitBox.Position.Y >= 85 then
                        tpSafeS5()
                        task.wait(1) 
                    end
                end
            end
        end)
    else
        notify("S5 Helper", "Slam Safe Spot: OFF", 2, "info")
        if yaxisThread then task.cancel(yaxisThread) yaxisThread = nil end
    end
end)

-- ==========================================
-- TOGGLE 2: Disable Laser Touch
-- ==========================================
local laserThread = nil
S5StartTab.createToggle("Disable Laser Touch", "Destroys TouchInterest on Eyeball Laser", function(state)
    _G.S5LaserActive = state
    if state then
        notify("S5 Helper", "Laser Disabler: ON", 2, "success")
        laserThread = task.spawn(function()
            while _G.S5LaserActive do
                task.wait(0.1)
                local section5 = workspace:FindFirstChild("Section5")
                local finalForm = section5 and section5:FindFirstChild("FinalForm")
                local moves = finalForm and finalForm:FindFirstChild("Moves")
                local eyeballLaser = moves and moves:FindFirstChild("EyeballLaser")
                local eyeball = eyeballLaser and eyeballLaser:FindFirstChild("Eyeball")
                local laserBeam = eyeball and eyeball:FindFirstChild("LaserBeam")
                
                if laserBeam then
                    laserBeam.CanTouch = false
                    local ti = laserBeam:FindFirstChildOfClass("TouchInterest")
                    if ti then ti:Destroy() end
                    local biggerHitBox = laserBeam:FindFirstChild("BiggerHitBox")
                    if biggerHitBox then
                        biggerHitBox.CanTouch = false
                        local ti2 = biggerHitBox:FindFirstChildOfClass("TouchInterest")
                        if ti2 then ti2:Destroy() end
                    end
                end
            end
        end)
    else
        notify("S5 Helper", "Laser Disabler: OFF", 2, "info")
        if laserThread then task.cancel(laserThread) laserThread = nil end
    end
end)

-- ==========================================
-- TOGGLE 3: Auto Attack Eyes (Weakpoints) - LIVE TRACKING
-- ==========================================
local eyesThread = nil
local eyesPhysicsConn = nil
local eyesNoclipConn = nil
local currentTargetHitbox = nil -- 🆕 Instance, hindi CFrame
local currentWeakPoint = nil    -- 🆕 Instance
_G.S5CurrentEyeTarget = "" 

S5Tab.createToggle("Auto Attack Eyes", "Floats and auto-attacks open weakpoints", function(state)
    _G.S5EyesActive = state
    if state then
        notify("S5 Helper", "Auto Attack Eyes: ON", 2, "success")
        _G.S5CurrentEyeTarget = ""
        currentTargetHitbox = nil
        currentWeakPoint = nil
        
        -- Y-Axis Watcher (Slam Checker)
        task.spawn(function()
            while _G.S5EyesActive do
                local section5 = workspace:FindFirstChild("Section5")
                local finalForm = section5 and section5:FindFirstChild("FinalForm")
                local boss = finalForm and finalForm:FindFirstChild("EnzukaiRyujin")
                local headHitBox = boss and boss:FindFirstChild("HeadHitBox")
                
                if headHitBox and headHitBox.Position.Y >= 85 then
                    if not isSlamActive then
                        isSlamActive = true
                        notify("Boss Slam", "Trigger! Waiting 4s at Safe Spot...", 3, "warning")
                        task.wait(3.5)
                        isSlamActive = false
                    end
                end
                task.wait(0.05)
            end
        end)

        -- 🆕 PHYSICS & LIVE CAMERA LOOP (Every Frame)
        eyesPhysicsConn = RunService.RenderStepped:Connect(function()
            if not _G.S5EyesActive then return end
            if isFinalFormActiveS5() then return end

            local charRef = localPlayer.Character
            local rp = charRef and charRef:FindFirstChild("HumanoidRootPart")
            local h = charRef and charRef:FindFirstChildOfClass("Humanoid")
            if not rp or not h then return end

            h.PlatformStand = true
            local bv = rp:FindFirstChild("CustomFlyVelocity")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "CustomFlyVelocity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = rp
            end

            -- ✅ LIVE TRACKING: Kinukuha ang position ng hitbox EVERY FRAME
            if currentTargetHitbox and currentTargetHitbox.Parent and currentWeakPoint and currentWeakPoint.Parent and not isSlamActive then
                local targetPos = currentTargetHitbox.Position
                local wpPivot = currentWeakPoint:GetPivot()
                
                local yOffset = -20 
                if targetPos.Y >= 5 then
                    yOffset = 50 
                end
                local rightOffset = 38
                
                local adjustedPosition = Vector3.new(
                    wpPivot.Position.X + (wpPivot.LookVector * -10).X + (wpPivot.RightVector * rightOffset).X,
                    targetPos.Y + yOffset,
                    wpPivot.Position.Z + (wpPivot.LookVector * -10).Z + (wpPivot.RightVector * rightOffset).Z
                )
                
                -- ✅ Live Body Aim
                rp.CFrame = CFrame.lookAt(adjustedPosition, targetPos)
                rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                -- ✅ Live Camera Focus
                if Controllers and Controllers.camera then
                    local cam = workspace.CurrentCamera
                    if cam then
                        local lookCFrame = CFrame.lookAt(cam.CFrame.Position, targetPos)
                        local x, y, _ = lookCFrame:ToOrientation()
                        pcall(function() Controllers.camera:Enforce(Vector2.new(math.deg(x), math.deg(y))) end)
                    end
                end
            else
                -- Walang target o naka-slam: float sa safe spot
                rp.CFrame = CFrame.new(safeSpotS5.Position + Vector3.new(0, 5, 0))
                rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)

        -- Noclip Loop
        eyesNoclipConn = RunService.Stepped:Connect(function()
            if not _G.S5EyesActive then return end
            local c = localPlayer.Character
            if c then
                for _, part in pairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)

        -- 🆕 MAIN ATTACK LOOP (May Live Target Check)
        eyesThread = task.spawn(function()
            while _G.S5EyesActive do
                local charRef = localPlayer.Character
                if not charRef or not charRef:FindFirstChildOfClass("Humanoid") or charRef:FindFirstChildOfClass("Humanoid").Health <= 0 then
                    currentTargetHitbox = nil
                    currentWeakPoint = nil
                    localPlayer.CharacterAdded:Wait()
                    task.wait(1)
                    continue
                end

                if isSlamActive or isFinalFormActiveS5() then
                    currentTargetHitbox = nil
                    currentWeakPoint = nil
                    task.wait(0.2)
                    continue
                end

                -- Kung wala pang target o patay na yung target, maghanap ng bago
                if not currentTargetHitbox or not currentTargetHitbox.Parent or not currentWeakPoint or not currentWeakPoint.Parent then
                    currentTargetHitbox = nil
                    currentWeakPoint = nil
                    
                    local section5 = workspace:FindFirstChild("Section5")
                    local points = section5 and section5:FindFirstChild("WeakPoints") and section5.WeakPoints:FindFirstChild("Points")
                    local eyeLetter = nil
                    
                    if points then
                        for _, wp in ipairs(points:GetChildren()) do
                            if not wp:IsA("Model") then continue end
                            for _, letter in ipairs({"A", "B", "C", "D", "E"}) do
                                local eye = wp:FindFirstChild("Eye" .. letter)
                                local hitbox = wp:FindFirstChild("HitBox" .. letter)
                                
                                if eye and hitbox and eye:IsA("BasePart") and eye.Transparency < 1 then
                                    currentWeakPoint = wp
                                    currentTargetHitbox = hitbox
                                    eyeLetter = letter
                                    
                                    local wpPos = wp:GetPivot().Position
                                    local targetName = "Eye " .. tostring(eyeLetter) .. " @ (" .. math.floor(wpPos.X) .. ", " .. math.floor(wpPos.Z) .. ")"
                                    if _G.S5CurrentEyeTarget ~= targetName then
                                        notify("Auto Eyes", "🎯 Locked: " .. targetName, 2, "info")
                                        _G.S5CurrentEyeTarget = targetName
                                    end
                                    break
                                end
                            end
                            if currentTargetHitbox then break end
                        end
                    end
                    
                    if not currentTargetHitbox then
                        _G.S5CurrentEyeTarget = ""
                        task.wait(0.5)
                        continue
                    end
                    
                    -- Bigyan ng time ang physics loop na maiposisyon ka
                    task.wait(0.2)
                end

                -- Kapag may target, mag-fire
                if currentTargetHitbox and currentTargetHitbox.Parent then
                    if _G.S5EyesActive then
                        fireBowS5(currentTargetHitbox, 0.1, true) 

                        local timeout = 0
                        while _G.S5EyesActive and currentTargetHitbox and currentTargetHitbox.Parent do
                            if isFinalFormActiveS5() or isSlamActive then break end 
                            local parentWP = currentTargetHitbox.Parent
                            local eyeCheck = parentWP:FindFirstChild("Eye" .. currentTargetHitbox.Name:gsub("HitBox", ""))
                            
                            -- ✅ KAPAG PATAY NA ANG MATA, BREAK AGAD PARA LUMIPAT
                            if eyeCheck and eyeCheck.Transparency >= 1 then 
                                currentTargetHitbox = nil
                                currentWeakPoint = nil
                                break 
                            end
                            
                            task.wait(0.03)
                            timeout = timeout + 0.03
                            if timeout >= 0.8 then break end
                        end
                    end
                    task.wait(0.05)
                end
            end
        end)
    else
        notify("S5 Helper", "Auto Attack Eyes: OFF", 2, "info")
        if eyesPhysicsConn then eyesPhysicsConn:Disconnect(); eyesPhysicsConn = nil end
        if eyesNoclipConn then eyesNoclipConn:Disconnect(); eyesNoclipConn = nil end
        if eyesThread then task.cancel(eyesThread); eyesThread = nil end
        currentTargetHitbox = nil
        currentWeakPoint = nil
        _G.S5CurrentEyeTarget = ""
        tpSafeS5()
    end
end)

-- ==========================================
-- TOGGLE 4: Auto Hit Final Form (Auto Tab)
-- ==========================================
local finalThread = nil
local finalPhysicsConn = nil

S5Tab.createToggle("Auto Hit when SUPERCHARGE", "Locks on boss side and attacks. Avoids slam.", function(state)
    _G.S5FinalActive = state
    if state then
        notify("S5 Helper", "Auto Hit Final Form: ON", 2, "success")
        
        finalPhysicsConn = RunService.RenderStepped:Connect(function()
            if not _G.S5FinalActive then return end
            local charRef = localPlayer.Character
            local rp = charRef and charRef:FindFirstChild("HumanoidRootPart")
            local h = charRef and charRef:FindFirstChildOfClass("Humanoid")
            if not rp or not h then return end

            if isFinalFormActiveS5() then
                local section5 = workspace:FindFirstChild("Section5")
                local finalForm = section5 and section5:FindFirstChild("FinalForm")
                local boss = finalForm and finalForm:FindFirstChild("EnzukaiRyujin")
                local headHitBox = boss and boss:FindFirstChild("HeadHitBox")

                if headHitBox then
                    h.PlatformStand = true
                    local bv = rp:FindFirstChild("CustomFlyVelocity")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "CustomFlyVelocity"
                        bv.Velocity = Vector3.new(0, 0, 0)
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Parent = rp
                    end
                    rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                    if headHitBox.Position.Y >= 85 then
                        if not isSlamActiveFinal then
                            isSlamActiveFinal = true
                            notify("Final Form", "Slam detected! Hiding at Safe Spot...", 3, "warning")
                            task.spawn(function()
                                task.wait(4)
                                isSlamActiveFinal = false
                            end)
                        end
                    end

                    if isSlamActiveFinal then
                        rp.CFrame = CFrame.new(safeSpotS5.Position + Vector3.new(0, 5, 0))
                    else
                        local sideOffset = (headHitBox.Size.X * 0.5) + 15
                        local targetPos = headHitBox.Position + headHitBox.CFrame.RightVector * sideOffset
                        rp.CFrame = CFrame.new(targetPos, headHitBox.Position)
                        
                        if Controllers and Controllers.camera then
                            local cam = workspace.CurrentCamera
                            if cam then
                                local lookCFrame = CFrame.lookAt(cam.CFrame.Position, headHitBox.Position)
                                local x, y, _ = lookCFrame:ToOrientation()
                                pcall(function() Controllers.camera:Enforce(Vector2.new(math.deg(x), math.deg(y))) end)
                            end
                        end
                    end
                end
            else
                if not _G.S5EyesActive then
                    h.PlatformStand = false
                    local bv = rp:FindFirstChild("CustomFlyVelocity")
                    if bv then bv:Destroy() end
                end
            end
        end)

        finalThread = task.spawn(function()
            while _G.S5FinalActive do
                if isFinalFormActiveS5() then
                    local section5 = workspace:FindFirstChild("Section5")
                    local finalForm = section5 and section5:FindFirstChild("FinalForm")
                    local boss = finalForm and finalForm:FindFirstChild("EnzukaiRyujin")
                    local headHitBox = boss and boss:FindFirstChild("HeadHitBox")

                    if headHitBox then
                        if not isSlamActiveFinal then
                            local character = localPlayer.Character
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                            local backpack = localPlayer.Backpack
                            
                            if humanoid and rootPart then
                                local bow = character:FindFirstChild("SpiritBow") or backpack:FindFirstChild("SpiritBow")
                                if bow and bow.Parent == backpack then
                                    humanoid:EquipTool(bow)
                                    task.wait(0.3)
                                end
                                
                                local remote = nil
                                if bow then
                                    remote = bow:FindFirstChild("RemoteEvent", true) or bow:FindFirstChild("Remote", true)
                                end
                                if not remote then
                                    remote = workspace:FindFirstChild("SpiritBow", true) and workspace.SpiritBow:FindFirstChild("RemoteEvent", true)
                                end
                                
                                if remote then
                                    local targetLookVector = (headHitBox.Position - rootPart.Position).Unit
                                    remote:FireServer(0, false, targetLookVector)
                                    task.wait(0) 
                                    remote:FireServer(0, true, targetLookVector)
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        notify("S5 Helper", "Auto Hit Final Form: OFF", 2, "info")
        if finalPhysicsConn then finalPhysicsConn:Disconnect(); finalPhysicsConn = nil end
        if finalThread then task.cancel(finalThread); finalThread = nil end
        tpSafeS5()
    end
end)



-- ============================================================
-- SECTION 5 TOGGLE: Final Form Lock (Manual Tab) - Fully Self-Contained
-- ============================================================
S5ManualTab.createToggle("Safe Spot X Auto Hit when SUPERCHARGE", "Lock and Auto Hit When SuperCharge. Auto-teleport to safe spot when OFF.", function(state)
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local safeSpot = CFrame.new(-115.310, 5.000, 22.195)

    -- 🆕 LOCAL Controllers (Hindi na aasa sa labas)
    local Controllers = nil
    pcall(function()
        Controllers = require(game:GetService("ReplicatedStorage").Client.Controllers)
    end)

    if not rootPart or not humanoid then 
        notify("Error", "No Character Found", 3, "error")
        return 
    end

    -- ==========================================
    -- LOCAL AUTO-HIT FUNCTIONS (Nasa loob na)
    -- ==========================================
    local s5AutoHitActive = false
    local s5AutoHitThread = nil

    local function stopS5AutoHitLocal()
        s5AutoHitActive = false
        if s5AutoHitThread then task.cancel(s5AutoHitThread); s5AutoHitThread = nil end
    end

    local function startS5AutoHitLocal()
        if s5AutoHitActive then return end
        s5AutoHitActive = true
        s5AutoHitThread = task.spawn(function()
            while s5AutoHitActive do
                pcall(function()
                    local character = player.Character or player.CharacterAdded:Wait()
                    local humanoid2 = character:FindFirstChildOfClass("Humanoid")
                    local rootPart2 = character:FindFirstChild("HumanoidRootPart")
                    local backpack = player.Backpack
                    if not s5AutoHitActive then return end

                    local spiritBowTool = character:FindFirstChild("SpiritBow") or backpack:FindFirstChild("SpiritBow")
                    if spiritBowTool and spiritBowTool.Parent == backpack and humanoid2 then
                        humanoid2:EquipTool(spiritBowTool)
                        task.wait(0.3)
                    end
                    if not s5AutoHitActive then return end

                    local remote = nil
                    if spiritBowTool then
                        remote = spiritBowTool:FindFirstChild("RemoteEvent", true) or spiritBowTool:FindFirstChild("Remote", true)
                    end
                    if not remote then
                        remote = Workspace:FindFirstChild("SpiritBow", true) and Workspace.SpiritBow:FindFirstChild("RemoteEvent", true)
                    end

                    local targetLookVector = nil
                    local section5 = Workspace:FindFirstChild("Section5")
                    local finalForm = section5 and section5:FindFirstChild("FinalForm")
                    local enzukai = finalForm and finalForm:FindFirstChild("EnzukaiRyujin")
                    local headHitbox = enzukai and enzukai:FindFirstChild("HeadHitBox")

                    if headHitbox and headHitbox:IsA("BasePart") and rootPart2 then
                        targetLookVector = (headHitbox.Position - rootPart2.Position).Unit
                    else
                        local cam = Workspace.CurrentCamera
                        if cam then targetLookVector = cam.CFrame.LookVector end
                    end

                    if remote and targetLookVector and s5AutoHitActive then
                        remote:FireServer(0, false, targetLookVector)
                        task.wait(0)
                        if not s5AutoHitActive then return end
                        remote:FireServer(0, true, targetLookVector)
                    end
                end)
                if not s5AutoHitActive then break end
                task.wait(0.5)
            end
        end)
    end

    -- ==========================================
    -- TOGGLE OFF
    -- ==========================================
    if not state then
        if _G.S5BossLoopConn then _G.S5BossLoopConn:Disconnect(); _G.S5BossLoopConn = nil end
        if _G.S5NoclipConn then _G.S5NoclipConn:Disconnect(); _G.S5NoclipConn = nil end
        stopS5AutoHitLocal()

        local charRef = player.Character
        if charRef then
            local rpRef = charRef:FindFirstChild("HumanoidRootPart")
            local humRef = charRef:FindFirstChildOfClass("Humanoid")
            if rpRef then
                local oldV = rpRef:FindFirstChild("CustomFlyVelocity")
                if oldV then oldV:Destroy() end
                rpRef.CFrame = safeSpot
                rpRef.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            if humRef then humRef.PlatformStand = false end
        end
        
        notify("S5 Final Form", "⏹️ Stopped & Returned to Safe Spot", 3, "error")
        return
    end

    -- ==========================================
    -- TOGGLE ON
    -- ==========================================
    if _G.S5BossLoopConn then _G.S5BossLoopConn:Disconnect(); _G.S5BossLoopConn = nil end
    if _G.S5NoclipConn then _G.S5NoclipConn:Disconnect(); _G.S5NoclipConn = nil end
    stopS5AutoHitLocal()

    humanoid.PlatformStand = false
    local oldV = rootPart:FindFirstChild("CustomFlyVelocity")
    if oldV then oldV:Destroy() end

    local initFrame = player.PlayerGui:FindFirstChild("S5") and player.PlayerGui.S5:FindFirstChild("Frame")
    local wasVisible = initFrame and initFrame.Visible or false
    if not wasVisible then
        rootPart.CFrame = safeSpot
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end

    -- Noclip
    _G.S5NoclipConn = RunService.Stepped:Connect(function()
        local charRef = player.Character
        if charRef then
            for _, part in pairs(charRef:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    -- Main loop
    _G.S5BossLoopConn = RunService.RenderStepped:Connect(function()
        local charRef = player.Character
        local rp = charRef and charRef:FindFirstChild("HumanoidRootPart")
        local hum = charRef and charRef:FindFirstChildOfClass("Humanoid")
        if not rp or not hum then return end

        local frame = player.PlayerGui:FindFirstChild("S5") and player.PlayerGui.S5:FindFirstChild("Frame")
        local isVisible = frame and frame.Visible or false

        hum.PlatformStand = true
        local bv = rp:FindFirstChild("CustomFlyVelocity")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "CustomFlyVelocity"
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = rp
        end
        rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        if isVisible then
            if not wasVisible then
                wasVisible = true
                startS5AutoHitLocal()
                notify("S5 Final Form", "🔒 Locked on Boss", 2, "success")
            end

            local section5 = Workspace:FindFirstChild("Section5")
            local finalForm = section5 and section5:FindFirstChild("FinalForm")
            local enzukai = finalForm and finalForm:FindFirstChild("EnzukaiRyujin")
            local headHitbox = enzukai and enzukai:FindFirstChild("HeadHitBox")

            if headHitbox and headHitbox:IsA("BasePart") then
                local sideOffset = (headHitbox.Size.X * 0.5) + 15
                local targetPos = headHitbox.Position + headHitbox.CFrame.RightVector * sideOffset
                rp.CFrame = CFrame.new(targetPos, headHitbox.Position)
                rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                if Controllers and Controllers.camera then
                    local cam = Workspace.CurrentCamera
                    if cam then
                        local targetCFrame = CFrame.lookAt(cam.CFrame.Position, headHitbox.Position)
                        local x, y, _ = targetCFrame:ToOrientation()
                        pcall(function()
                            Controllers.camera:Enforce(Vector2.new(math.deg(x), math.deg(y)))
                        end)
                    end
                end
            end
        else
            if wasVisible then
                wasVisible = false
                stopS5AutoHitLocal()
                notify("S5 Final Form", "🛡️ Safe Spot - Manual Aim Mode", 2, "info")
            end
            
            rp.CFrame = safeSpot
            rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)

    notify("S5 Final Form", "✅ Activated - Manual Aim Ready", 2, "success")
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







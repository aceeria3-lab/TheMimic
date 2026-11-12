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

-- ==================== CANDY CONFIG & FORMATTING ====================
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

loadCandyConfig()

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

local MainTab = {}
CreateHeaderDropdown("Main", "Egao", "bulb")(MainTab)

local S1QuickTab = {}
CreateHeaderDropdown("Section 1", "Quick", "layout")(S1QuickTab)

local S1Tab = {}
CreateHeaderDropdown("Section 1", "The Neighborhood", "layout")(S1Tab)

local S2QuickTab = {}
CreateHeaderDropdown("Section 2", "Quick", "layout")(S2QuickTab)

local S2Tab = {}
CreateHeaderDropdown("Section 2", "The School", "layout")(S2Tab)

local S3QuickTab = {}
CreateHeaderDropdown("Section 3", "Quick", "layout")(S3QuickTab)

local S3Tab = {}
CreateHeaderDropdown("Section 3", "The Forest", "layout")(S3Tab)

local S4QuickTab = {}
CreateHeaderDropdown("Section 4", "Quick", "layout")(S4QuickTab)

local S4Tab = {}
CreateHeaderDropdown("Section 4", "Sector E-7 Cave", "layout")(S4Tab)

local S4LabTab = {}
CreateHeaderDropdown("Section 4", "Sector E-7 Lab", "layout")(S4LabTab)

local S5QuickTab = {}
CreateHeaderDropdown("Section 5", "Quick", "layout")(S5QuickTab)

local S5DSTab = {}
CreateHeaderDropdown("Section 5", "Sector E-7 Downstairs", "layout")(S5DSTab)

local S5StairsTab = {}
CreateHeaderDropdown("Section 5", "Sector E-7 Basement", "layout")(S5StairsTab)


local GamePlayTab = {}
CreateHeaderDropdown("Setting", "Game Play", "")(GamePlayTab)

local GraphicsTab = {}
CreateHeaderDropdown("Setting", "Graphics", "")(GraphicsTab)

local GlobalChatTab = {}
CreateHeaderDropdown("Global Chat", "Global Chat", "message-square")(GlobalChatTab)


switchTab("Main")


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
            -- 🛑 KAPAG NAKA-OFF, WAG MAG-SCAN
            if not _G.YenDetectActive then return "-" end 

            local yenFolder = workspace:FindFirstChild("Yen")
            if yenFolder then
                local count = 0
                for _, child in ipairs(yenFolder:GetChildren()) do
                    if child.Name == "YenCoin" then
                        count = count + 1
                    end
                end
                return count
            end
            return 0
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

-- TOGGLE: YEN ESP (Highlight + Name)
YenTab.createToggle("Yen ESP", "Highlights scattered Yen items", function(state)
    _G.YenESP_Active = state
    local container = getContainer(YenContainerName)
    local COLOR = Color3.fromRGB(255, 215, 0) -- Gold
    
    local function getYenFolder()
        return Workspace:FindFirstChild("Yen")
    end

    if state then
        local folder = getYenFolder()
        if folder then
            for _, yen in ipairs(folder:GetChildren()) do
                addYenESPModel(yen, container, COLOR)
            end
        end

        task.spawn(function()
            while _G.YenESP_Active do
                task.wait(1)
                if not _G.YenESP_Active then break end
                local f = getYenFolder()
                if f then
                    for _, yen in ipairs(f:GetChildren()) do
                        addYenESPModel(yen, container, COLOR)
                    end
                end
            end
        end)

        notify("Success", "Yen ESP: ON", 2, "success")
    else
        local folder = getYenFolder()
        if folder then
            for _, yen in ipairs(folder:GetChildren()) do
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
        local emptyScans = 0 -- Counter para malaman kung wala nang Yen

        while _G.IsCollectingYen do
            local found = false
            
            local char = Player.Character or localPlayer.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            local yenFolder = Workspace:FindFirstChild("Yen")

            if rootPart and yenFolder then
                for _, child in ipairs(yenFolder:GetChildren()) do
                    if not _G.IsCollectingYen then break end
                    
                    local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
                    
                    if prompt and prompt.Enabled then
                        found = true
                        emptyScans = 0 -- May nahanap, i-reset ang counter
                        
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
            
            -- [BAGONG LOGIC] KUSANG MAG-STOP KAPAG WALA NANG YEN
            if not found then
                emptyScans = emptyScans + 1
                
                -- Kung 3 beses na walang nahanap (mga 3 seconds), tuluyan nang i-stop
                if emptyScans >= 2 then
                    _G.IsCollectingYen = false -- Isara ang loop
                    notify("IOHUB", "Auto Collect: Stopped (No Yen Found)", 2, "warning")
                    break -- Lumabas sa loop nang tuluyan
                else
                    task.wait(1) -- Maghintay muna ng 1 segundo bago mag-scan ulit
                end
            end
        end
    end)
end)




-- 1. ANG RECTANGLE STATUS
MainTab.createOneRectangle({
    Icon = "rbxassetid://137621887926054", -- Palitan mo ng Image ID ng Egao kung meron ka
    Title = "EGAO",
    GetValue = function()
        local egaoRig = workspace:FindFirstChild("EgaoEventRig", true)
        if egaoRig then
            return "Spawned!", Color3.fromRGB(100, 220, 150) -- Green
        else
            return "Not Spawned Check Other", Color3.fromRGB(255, 100, 100) -- Red
        end
    end,
})

-- 2. TOGGLE AUTO CHECK & LOOK
local autoCheckEgaoActive = false
local egaoLookConn = nil
local egaoNotified = false

MainTab.createToggle("Auto Look Egao", "Detects Egao and locks camera to it", function(state)
    autoCheckEgaoActive = state
    egaoNotified = false

    if not state then
        if egaoLookConn then
            egaoLookConn:Disconnect()
            egaoLookConn = nil
        end
        return
    end

    notify("Info", "Auto Check Egao: ON", 2, "info")

    egaoLookConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not autoCheckEgaoActive then return end

        local player = game.Players.LocalPlayer
        local char = player.Character
        local cam = workspace.CurrentCamera
        local egaoRig = workspace:FindFirstChild("EgaoEventRig", true)

        if egaoRig and char and char:FindFirstChild("HumanoidRootPart") and cam then
            -- Notify once kapag na-detect
            if not egaoNotified then
                egaoNotified = true
                notify("Success", "Egao Detected!", 3, "success")
            end

            local hrp = char.HumanoidRootPart
            local targetPart = egaoRig:FindFirstChild("HumanoidRootPart") or egaoRig:FindFirstChildWhichIsA("BasePart")
            
            if targetPart then
                local targetPos = targetPart.Position
                -- I-look yung character sa Egao (Y-axis lang para hindi bumaliktad)
                hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                -- I-look yung camera sa Egao
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPos)
            end
        end
    end)
end)

-- 3. TELEPORT SPAWN LOCATION CYCLE BUTTON
local spawnLocations = {
    {Name = "Spawn Location 1", CF = CFrame.new(22.914, 7.016, -50.395)},
    {Name = "Spawn Location 2", CF = CFrame.new(-3517.833, 8.000, 268.412)},
    {Name = "Spawn Location 3", CF = CFrame.new(-3374.083, -300.761, 4633.671)}
}

local currentSpawnIndex = 1

MainTab.createCustomButton("Teleport Egao SpawnLocation", "Click to cycle through 3 spawns", function()
    local target = spawnLocations[currentSpawnIndex]
    local player = game.Players.LocalPlayer
    local char = player.Character

    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = target.CF
        task.wait(0.1)
        
        -- Fire TouchInterest (para sa mga invisible triggers sa spawn)
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc.Name == "TouchInterest" and desc.Parent and desc.Parent:IsA("BasePart") then
                local part = desc.Parent
                if (part.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                    firetouchinterest(char.HumanoidRootPart, part, 0)
                    firetouchinterest(char.HumanoidRootPart, part, 1)
                end
            end
        end

        notify("Success", "Teleported to " .. target.Name, 2, "success")
    else
        notify("Error", "Character not found!", 2, "error")
    end

    -- I-cycle yung index (1 -> 2 -> 3 -> 1)
    currentSpawnIndex = currentSpawnIndex + 1
    if currentSpawnIndex > #spawnLocations then
        currentSpawnIndex = 1
    end
end)


-- ====================================================================
-- ESP EGAO SPAWNS (Main Tab - Visible Red Edition)
-- ====================================================================
local egaoOriginalData = {} -- Para ma-save ang orihinal na Transparency at Color

MainTab.createToggle("ESP EgaoSpawns", "Makes EgaoSpawns visible (Red) and highlights them", function(state)
    _G.EgaoSpawnsESP_Active = state

    local CoreGui   = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")
    
    local container = CoreGui:FindFirstChild("IOHUB_Egao_ESP")
    if not container then
        container = Instance.new("Folder")
        container.Name = "IOHUB_Egao_ESP"
        container.Parent = CoreGui
    end

    if state then
        notify("Success", "EgaoSpawns ESP: ON", 2, "success")

        task.spawn(function()
            while _G.EgaoSpawnsESP_Active do
                local egaoFolder = Workspace:FindFirstChild("EgaoSpawns")

                if egaoFolder then
                    for _, child in ipairs(egaoFolder:GetChildren()) do
                        -- Check kung Part (BasePart) ang laman ng folder
                        if child:IsA("BasePart") then
                            
                            -- 1. Gawing Visible (Transparency 0.9) at Kulay Pula
                            if not egaoOriginalData[child] then
                                -- I-save muna ang original bago baguhin
                                egaoOriginalData[child] = {
                                    Transparency = child.Transparency,
                                    Color = child.Color
                                }
                            end
                            
                            child.Transparency = 0.5
                            child.Color = Color3.fromRGB(255, 0, 0) -- ColorBrick Red

                            -- 2. Highlight (Pula rin para consistent)
                            if not child:FindFirstChild("Egao_HL") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "Egao_HL"
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                                hl.FillTransparency = 0.5
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.OutlineTransparency = 0
                                hl.Parent = child
                            end

                            -- 3. Name Tag (Billboard)
                            local exists = false
                            for _, bb in ipairs(container:GetChildren()) do
                                if bb:IsA("BillboardGui") and bb.Adornee == child then
                                    exists = true
                                    break
                                end
                            end

                            if not exists then
                                local bb = Instance.new("BillboardGui")
                                bb.Size = UDim2.new(0, 150, 0, 24)
                                bb.AlwaysOnTop = true
                                bb.ExtentsOffset = Vector3.new(0, 2, 0)
                                bb.Adornee = child
                                bb.Parent = container

                                local lbl = Instance.new("TextLabel")
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Text = "EgaoSpawns" 
                                lbl.TextColor3 = Color3.fromRGB(255, 50, 50)
                                lbl.TextSize = 14
                                lbl.Font = Enum.Font.SourceSansBold
                                lbl.TextStrokeTransparency = 0
                                lbl.Parent = bb
                            end
                        end
                    end
                end
                task.wait(1) -- Refresh rate
            end
        end)
    else
        -- Cleanup kapag OFF
        for part, data in pairs(egaoOriginalData) do
            if part and part.Parent then
                -- Ibalik sa dating transparent at kulay
                part.Transparency = data.Transparency
                part.Color = data.Color

                -- Alisin ang highlight
                local hl = part:FindFirstChild("Egao_HL")
                if hl then pcall(function() hl:Destroy() end) end
            end
        end
        
        egaoOriginalData = {} -- I-reset ang memory
        container:ClearAllChildren()
        notify("Info", "EgaoSpawns ESP: OFF", 2, "info")
    end
end)


-- ====================================================================
-- EGAO ESP (Main Tab - Green Highlight & Red Label)
-- ====================================================================
MainTab.createToggle("ESP Egao", "Show Egao Highlights and Name", function(state)
    _G.EgaoESPActive = state

    if state then
        notify("Success", "Egao ESP: ON", 2, "success")

        task.spawn(function()
            while _G.EgaoESPActive do
                pcall(function()
                    -- Hanapin ang Egao Rig
                    local egaoRig = workspace:FindFirstChild("EgaoEventRig", true)
                    
                    if egaoRig then
                        -- 1. Green Highlight
                        if not egaoRig:FindFirstChild("Egao_UltraESP") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Egao_UltraESP"
                            highlight.Adornee = egaoRig
                            highlight.FillColor = Color3.fromRGB(0, 255, 50)
                            highlight.FillTransparency = 0.2
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineTransparency = 0
                            highlight.Parent = egaoRig
                        end
                        
                        -- 2. Text Label sa Ulo ("[ EGAO ]")
                        local targetPart = egaoRig:FindFirstChild("Head") 
                            or egaoRig:FindFirstChild("HumanoidRootPart") 
                            or egaoRig:FindFirstChildWhichIsA("BasePart")
                            
                        if targetPart and not targetPart:FindFirstChild("Egao_LabelGui") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "Egao_LabelGui"
                            billboard.Size = UDim2.new(0, 100, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = targetPart
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.Text = "[ EGAO ]"
                            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            textLabel.TextScaled = true
                            textLabel.Font = Enum.Font.SourceSansBold
                            textLabel.TextStrokeTransparency = 0
                            textLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
                            textLabel.Parent = billboard
                        end
                    end
                end)
                task.wait(1) -- Refresh rate kada segundo
            end
        end)
    else
        notify("Info", "Egao ESP: OFF", 2, "info")
        
        -- Agad na linisin pagka-OFF
        local egaoRig = workspace:FindFirstChild("EgaoEventRig", true)
        if egaoRig then
            local hl = egaoRig:FindFirstChild("Egao_UltraESP")
            if hl then pcall(function() hl:Destroy() end) end
            
            -- Hanapin ang label kahit saang part nakakabit
            local lbl = egaoRig:FindFirstChild("Egao_LabelGui", true)
            if lbl then pcall(function() lbl:Destroy() end) end
        end
    end
end)













S1QuickTab.createCustomButton("Open Gate and School", "", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")


    local function safeFirePrompt(prompt)
        if not prompt then return false end
        local success, err = pcall(function()
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50 
            task.wait(0.1)
            
            fireproximityprompt(prompt)
            
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance
        end)
        
        if not success then
            warn("Prompt Error: " .. tostring(err))
        end
        return true
    end


    notify("Stage 1/2", "Going to Gate...", 2)

    character:PivotTo(CFrame.new(124.809, 7.052, 273.595))
    task.wait(1) 

    local gatePrompt = Workspace:FindFirstChild("Section1")
        and Workspace.Section1:FindFirstChild("SchoolGatePart")
        and Workspace.Section1.SchoolGatePart:FindFirstChild("Gate")
        and Workspace.Section1.SchoolGatePart.Gate:FindFirstChild("Chain")
        and Workspace.Section1.SchoolGatePart.Gate.Chain:FindFirstChild("PromptPart")
        and Workspace.Section1.SchoolGatePart.Gate.Chain.PromptPart:FindFirstChild("ProximityPrompt")

    if gatePrompt then
        for i = 1, 4 do
            notify("Unlocking Gate", "Firing chain prompt: (" .. i .. "/4)", 1)
            safeFirePrompt(gatePrompt)
            task.wait(0.4) 
        end
        notify("Stage 1 Success", "Gate Unlocked", 1.5)
    else
        notify("Stage 1 Failed", "Gate Prompt Not Found", 3)
    end
    task.wait(1.5)


    notify("Stage 2/2", "Going to School Door...", 2)
    character:PivotTo(CFrame.new(174.551, 7.541, 329.988))
    task.wait(1)

    local doorPrompt = Workspace:FindFirstChild("Section2")
        and Workspace.Section2:FindFirstChild("School")
        and Workspace.Section2.School:FindFirstChild("Doors")
        and Workspace.Section2.School.Doors:FindFirstChild("MainDoors")
        and Workspace.Section2.School.Doors.MainDoors:FindFirstChild("EntireDoor")
        and Workspace.Section2.School.Doors.MainDoors.EntireDoor:FindFirstChild("Door")
        and Workspace.Section2.School.Doors.MainDoors.EntireDoor.Door:FindFirstChild("PROXPART")
        and Workspace.Section2.School.Doors.MainDoors.EntireDoor.Door.PROXPART:FindFirstChild("ProximityPrompt")

    if doorPrompt then
        safeFirePrompt(doorPrompt)
        notify("Stage 2 Success", "Main School Door is now open!", 2)
    else
        notify("Stage 2 Failed", "Door School Prompt Not Found", 3)
    end
    
    notify("Success", "Fully Complete", 2)
end)



S1Tab.createToggle("Auto Kill All Street Gata", "Auto-fire Grunts within 30 studs (no teleport)", function(state)
    _G.GataAutoFireActive = state

    if not state then
        notify("Info", "Gata Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer
    local DETECT_RADIUS = 5000 

    notify("Success", "Gata Auto-Fire", 3, "success")

    task.spawn(function()
        while _G.GataAutoFireActive do
            task.wait(0.1)
            if not _G.GataAutoFireActive then break end

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local gruntsFolder = Workspace:FindFirstChild("Section1")
                    and Workspace.Section1:FindFirstChild("Grunts")

                if gruntsFolder then
                    for _, gataObj in ipairs(gruntsFolder:GetChildren()) do
                        if not _G.GataAutoFireActive then break end

                        if gataObj:IsA("Model") then

                            local part = gataObj:FindFirstChild("Hitbox")
                                or gataObj:FindFirstChild("HumanoidRootPart")
                                or gataObj:FindFirstChildWhichIsA("BasePart", true)

                            if part then
                                local dist = (part.Position - hrp.Position).Magnitude


                                if dist <= DETECT_RADIUS then
             
                                    for _, desc in ipairs(gataObj:GetDescendants()) do
                                        if not _G.GataAutoFireActive then break end

                                        if desc:IsA("RemoteEvent") then
                                            pcall(function()
                                                desc:FireServer()
                                                desc:FireServer("Damage", 100)
                                                desc:FireServer("Kill")
                                                desc:FireServer(true)
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)


-- ====================================================================
-- ESP DEAD CIVILIANS (Section 1)
-- ====================================================================
S1Tab.createToggle("ESP DeadCivilians", "Highlight all dead civilians in Section 1", function(state)
    _G.DeadCiviliansESP_Active = state

    local CoreGui   = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")
    
    local container = CoreGui:FindFirstChild("IOHUB_DeadCiv_ESP")
    if not container then
        container = Instance.new("Folder")
        container.Name = "IOHUB_DeadCiv_ESP"
        container.Parent = CoreGui
    end

    if state then
        notify("Success", "Dead Civilians ESP: ON", 2, "success")

        task.spawn(function()
            while _G.DeadCiviliansESP_Active do
                local deadFolder = Workspace:FindFirstChild("Section1")
                    and Workspace.Section1:FindFirstChild("DeadCivilians")

                if deadFolder then
                    for _, civ in ipairs(deadFolder:GetChildren()) do
                        if civ:IsA("Model") then
                            -- 1. Highlight (Kulay Gray/Abuhin para mukhang patay)
                            if not civ:FindFirstChild("DeadCiv_HL") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "DeadCiv_HL"
                                hl.FillColor = Color3.fromRGB(200, 200, 200)
                                hl.FillTransparency = 0.5
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.Parent = civ
                            end

                            -- 2. Name Tag (Billboard)
                            local anchor = civ.PrimaryPart 
                                or civ:FindFirstChild("HumanoidRootPart") 
                                or civ:FindFirstChildWhichIsA("BasePart")

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
                                    bb.Size = UDim2.new(0, 150, 0, 24)
                                    bb.AlwaysOnTop = true
                                    bb.ExtentsOffset = Vector3.new(0, 2, 0)
                                    bb.Adornee = anchor
                                    bb.Parent = container

                                    local lbl = Instance.new("TextLabel")
                                    lbl.Size = UDim2.new(1, 0, 1, 0)
                                    lbl.BackgroundTransparency = 1
                                    lbl.Text = civ.Name
                                    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                                    lbl.TextSize = 14
                                    lbl.Font = Enum.Font.SourceSansBold
                                    lbl.TextStrokeTransparency = 0
                                    lbl.Parent = bb
                                end
                            end
                        end
                    end
                end
                task.wait(1) -- Refresh rate
            end
        end)
    else
        -- Cleanup kapag OFF
        local deadFolder = Workspace:FindFirstChild("Section1")
            and Workspace.Section1:FindFirstChild("DeadCivilians")

        if deadFolder then
            for _, civ in ipairs(deadFolder:GetChildren()) do
                local hl = civ:FindFirstChild("DeadCiv_HL")
                if hl then pcall(function() hl:Destroy() end) end
            end
        end
        
        container:ClearAllChildren()
        notify("Info", "Dead Civilians ESP: OFF", 2, "info")
    end
end)






S1Tab.createCustomButton("Interact Civilians", "", function()
        local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Siguraduhing umiiral ang folder ng mga civilian bago mag-umpisa
    local deadCiviliansFolder = Workspace:FindFirstChild("Section1") 
        and Workspace.Section1:FindFirstChild("DeadCivilians")

    if not deadCiviliansFolder then
        notify("Error", "Not Found DeadCivilians folder!", 3)
        return
    end

    -- Ang iyong mga eksaktong ligtas na CFrame listahan
    local civiliansCFrame = {
        CFrame.new(82.2101974, 7.01562452, 229.03598, 0.999974549, 1.60358249e-09, -0.00713643711, -1.60001368e-09, 1, 5.05793407e-10, 0.00713643711, -4.94362107e-10, 0.999974549),
        CFrame.new(29.5840073, 7.05437136, -87.9759293, 0.999974549, 7.98299926e-10, -0.00713643711, -7.60655594e-10, 1, 5.27766053e-09, 0.00713643711, -5.27209787e-09, 0.999974549),
        CFrame.new(-182.772629, 7.01562452, 73.8156357, 0.0309865493, 1.37417135e-08, 0.999519825, -2.71963851e-09, 1, -1.36640024e-08, -0.999519825, -2.29493224e-09, 0.0309865493),
        CFrame.new(225.873566, 7.03801394, -84.7873001, 0.999954641, 6.97570335e-10, 0.00952569582, -9.66604463e-10, 1, 2.82383912e-08, -0.00952569582, -2.82463173e-08, 0.999954641),
        CFrame.new(-3.58142662, 7.01562452, -176.386215, -0.992575169, -1.97492529e-08, -0.121632636, -1.93827052e-08, 1, -4.19672697e-09, 0.121632636, -1.80799731e-09, -0.992575169),
        CFrame.new(80.6713104, 7.0411253, 149.687668, -0.997461557, 1.115201e-08, -0.0712069646, 1.04766196e-08, 1, 9.85837101e-09, 0.0712069646, 9.08733799e-09, -0.997461557)
    }

    -- Helper function para hanapin ang ProximityPrompt na pinakamalapit sa posisyon ng player
    local function getClosestPrompt()
        local closestPrompt = nil
        local shortestDistance = math.huge

        for _, civilian in ipairs(deadCiviliansFolder:GetChildren()) do
            local hrp = civilian:FindFirstChild("HumanoidRootPart")
            local prompt = hrp and hrp:FindFirstChildOfClass("ProximityPrompt")
            
            if prompt and hrp then
                local distance = (humanoidRootPart.Position - hrp.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPrompt = prompt
                end
            end
        end
        return closestPrompt
    end

    notify("Script Started", "Teleporting to DeadCivilians", 3)

    -- Loop sa iyong 6 na safe CFrames
    for i, targetCFrame in ipairs(civiliansCFrame) do
        -- 1. I-teleport ang player gamit ang iyong ligtas na coordinate
        humanoidRootPart.CFrame = targetCFrame
        task.wait(0.4) -- Delay para siguradong naka-load ang lapag at hindi mahulog

        -- 2. Hanapin ang pinakamalapit na ProximityPrompt sa posisyong ito
        local prompt = getClosestPrompt()

        if prompt then
            -- 3. I-bypass ang mga posibleng restriction ng prompt (para sa nakahigang civilian)
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50 -- Tinaasan para sigurado kahit may kaunting distansya
            task.wait(0.1)

            -- 4. Trigger ang Proximity Prompt at mag-notify sa gilid ng screen
            fireproximityprompt(prompt)
            notify("Interacting", "Civilian [" .. i .. "/" .. #civiliansCFrame .. "]", 1.5)

            -- 5. Ibalik sa dati ang properties ng prompt (iwas anti-cheat flag)
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance

            -- 6. Maghintay ng 2 segundo bago lumipat sa kasunod
            task.wait(2)
        else
            notify("Warning", "No Prompt on Spot #" .. i, 2)
            task.wait(1)
        end
    end

    notify("Success", "Done Interact", 4)
    
    
    
    
    
end)

S1Tab.createCustomButton("Teleport to Mika", "", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = CFrame.new(-260.086, 7.016, -299.436)
    end
end)

S1Tab.createCustomButton("Interact Hideo", "Teleports to Hideo and claims", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Ginamit natin yung magandang custom notify mo imbes na StarterGui:SetCore
    notify("Teleporting", "Going to Hideo...", 1.5)
    
    -- PivotTo gamit ang character
    character:PivotTo(CFrame.new(107.692, 7.064, 269.127))
    task.wait(1) -- Pinahaba natin nang konti para sure na naka-register sa server

    -- Pathing logic (Tama ito)
    local hideoScene = Workspace:FindFirstChild("Section1") and Workspace.Section1:FindFirstChild("HideoScene")
    local hideo2 = hideoScene and hideoScene:FindFirstChild("Hideo2")
    local hrp = hideo2 and hideo2:FindFirstChild("HumanoidRootPart")
    local prompt = hrp and hrp:FindFirstChildOfClass("ProximityPrompt")

    if prompt then
        local success, err = pcall(function()
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50 
            task.wait(0.1)

            fireproximityprompt(prompt)
            
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance
        end)

        if success then
            notify("Success", "Interacted on Hideo!", 2)
        else
            notify("Error", "Failed to fire prompt: " .. tostring(err), 3)
        end
    else
        notify("Error", "Hideo Prompt not Found", 3)
    end
end)

S1Tab.createCustomButton("Get BoltCutter", "Teleports to Truck and grabs the BoltCutter", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Safe prompt firing function
    local function safeFirePrompt(prompt)
        if not prompt then return false end
        local success, err = pcall(function()
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50 
            task.wait(0.1)
            
            fireproximityprompt(prompt)
            
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance
        end)
        
        if not success then
            warn("Prompt Error: " .. tostring(err))
        end
        return true
    end

    notify("BoltCutter", "Going to BoltCutter...", 2)
    
    -- Teleport gamit ang PivotTo
    character:PivotTo(CFrame.new(202.509, 7.060, 109.554))
    task.wait(1) -- Importante ang 1 second wait para ma-register ng server ang position

    -- Pathing para hanapin ang BoltCutter
    local boltPrompt = Workspace:FindFirstChild("Section1")
        and Workspace.Section1:FindFirstChild("SchoolGatePart")
        and Workspace.Section1.SchoolGatePart:FindFirstChild("Truck")
        and Workspace.Section1.SchoolGatePart.Truck:FindFirstChild("BoltCutter")
        and Workspace.Section1.SchoolGatePart.Truck.BoltCutter:FindFirstChild("Main")
        and Workspace.Section1.SchoolGatePart.Truck.BoltCutter.Main:FindFirstChild("ProximityPrompt")

    -- Fire the prompt
    if boltPrompt then
        safeFirePrompt(boltPrompt)
        notify("Success", "Got the BoltCutter!", 3)
    else
        notify("Failed", "BoltCutter prompt not found!", 3)
    end
end)


S2QuickTab.createCustomButton("Open Diary & Complete", "Teleports to Locker, reads Diary, and Auto Completes", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Safe Prompt Function (may pcall para hindi mag-crash)
    local function safeFirePrompt(prompt)
        if not prompt then return false end
        local success, err = pcall(function()
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50 
            task.wait(0.1)
            
            fireproximityprompt(prompt)
            
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance
        end)
        return success
    end

    -- =========================================================================
    -- STAGE 1: Teleport sa Locker at Buksan
    -- =========================================================================
    notify("Stage 1/3", "Going to Locker...", 2)
    character:PivotTo(CFrame.new(143.386, 20.483, 503.915))
    task.wait(1) -- 1 second wait para sure na naka-register sa server

    local lockerPrompt = Workspace:FindFirstChild("Section2")
        and Workspace.Section2:FindFirstChild("MAINOBJECTIVE")
        and Workspace.Section2.MAINOBJECTIVE:FindFirstChild("Locker")
        and Workspace.Section2.MAINOBJECTIVE.Locker:FindFirstChild("LockerDoor")
        and Workspace.Section2.MAINOBJECTIVE.Locker.LockerDoor:FindFirstChild("ProximityPart")
        and Workspace.Section2.MAINOBJECTIVE.Locker.LockerDoor.ProximityPart:FindFirstChild("ProximityPrompt")

    if lockerPrompt then
        safeFirePrompt(lockerPrompt)
        notify("Stage 1", "Opened the Locker!", 1.5)
    else
        notify("Warning", "Locker prompt not found!", 2)
    end
    task.wait(1.5)

    -- =========================================================================
    -- STAGE 2: I-fire ang Red Diary Prompt
    -- =========================================================================
    notify("Stage 2/3", "Reading the Diary...", 2)
    
    local diaryPrompt = Workspace:FindFirstChild("Section2")
        and Workspace.Section2:FindFirstChild("MAINOBJECTIVE")
        and Workspace.Section2.MAINOBJECTIVE:FindFirstChild("Diary")
        and Workspace.Section2.MAINOBJECTIVE.Diary:FindFirstChild("ProximityPrompt")

    if diaryPrompt then
        safeFirePrompt(diaryPrompt)
        notify("Stage 2", "Readed the Diary!", 1.5)
    else
        notify("Error", "Diary prompt not found!", 3)
    end
    task.wait(2) -- Bigyan ng 2 seconds para lumabas yung Diary UI sa screen

    -- =========================================================================
    -- STAGE 3: Auto Complete Diary (Yung Remote Event)
    -- =========================================================================
    notify("Stage 3/3", "Auto-completing Diary...", 2)
    
    local Packet = ReplicatedStorage:FindFirstChild("modules") and ReplicatedStorage.modules:FindFirstChild("Packet")
    local Reliable = Packet and Packet:FindFirstChild("Reliable")

    if Reliable then
        local success = pcall(function()
            -- Mag-fire ng event 5 beses para siguradong pumapasok
            for i = 1, 5 do
                firesignal(Reliable.OnClientEvent, "Section2/DiaryComplete")
                task.wait(0.2)
            end
        end)
        
        if success then
            notify("Success", "Diary Completed!", 3)
        else
            notify("Error", "Failed to fire DiaryComplete event.", 3)
        end
    else
        notify("Error", "Reliable Event not found!", 3)
    end
end)


S2QuickTab.createCustomButton("Auto AkariSpider", "Kills all spiders and opens the exit gate", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    -- Global variable thread configuration to allow safe interlocking cancellations
    if _G.SpiderKillLoopActive then
        notify("Auto Spider", "Stopping the current spider loop...", 2)
        _G.SpiderKillLoopActive = false
        task.wait(0.5)
    end
    
    _G.SpiderKillLoopActive = true
    _G.EradicatedSpidersTable = {} 

    -- Safe Prompt Function
    local function safeFirePrompt(prompt)
        if not prompt then return false end
        local success, err = pcall(function()
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50
            task.wait(0.05)
            
            fireproximityprompt(prompt)
            
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance
        end)
        return success
    end

    -- Verify Section 2 target spiders directory folder path structure
    local spidersFolder = Workspace:FindFirstChild("Section2")
        and Workspace.Section2:FindFirstChild("MAINOBJECTIVE2")
        and Workspace.Section2.MAINOBJECTIVE2:FindFirstChild("Spiders")
        
    if not spidersFolder then
        notify("Error", "Section 2 Spiders folder not found or not loaded yet!", 3, "error")
        return
    end

    notify("Sniper Live", "Hyper-Spam Sniper active. Commencing room sweep...", 3)

    -- =========================================================================
    -- PHASE 1: POINT-BLANK SPIDER ERADICATION SWEEP LOOP
    -- =========================================================================
    task.spawn(function()
        while _G.SpiderKillLoopActive do
            if not character or not character.Parent or not character:FindFirstChild("HumanoidRootPart") then break end
            
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            local targetSpiderModel = nil
            local targetCFrame = nil
            local remainingSpiderTargetsCount = 0
            
            -- SCANNER LOOP
            local currentSpidersList = spidersFolder:GetChildren()
            
            for _, spiderObj in ipairs(currentSpidersList) do
                if spiderObj:IsA("Model") and not _G.EradicatedSpidersTable[spiderObj] then
                    local validPart = spiderObj:FindFirstChild("Hitbox") or spiderObj:FindFirstChild("HumanoidRootPart") or spiderObj:FindFirstChildWhichIsA("BasePart", true)
                    if validPart and validPart.Parent then
                        remainingSpiderTargetsCount = remainingSpiderTargetsCount + 1
                        if not targetSpiderModel then
                            targetSpiderModel = spiderObj
                            targetCFrame = validPart.CFrame 
                        end
                    end
                end
            end
            
            -- INTERLOCK ESCAPE GATEWAY
            if remainingSpiderTargetsCount == 0 or not targetSpiderModel or not _G.SpiderKillLoopActive then
                notify("Area Cleared", "All spiders eliminated! Transitioning to Exit Gate...", 2)
                break
            end
            
            -- TRIGGER ATK PHASE
            if targetSpiderModel and targetCFrame and _G.SpiderKillLoopActive then
                if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
                task.wait(0.01)
                
                local safeSnapCFrame = targetCFrame * CFrame.new(0, -4, 0)
                character:PivotTo(safeSnapCFrame)
                task.wait(0.15) 

                -- HEARTBEAT GLUE LAYER
                local isLockingActive = true
                local lockConnection
                lockConnection = RunService.Heartbeat:Connect(function()
                    if isLockingActive and character:FindFirstChild("HumanoidRootPart") and _G.SpiderKillLoopActive then
                        character:PivotTo(safeSnapCFrame) 
                        character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) 
                    end
                end)

                notify("Target Captured", "Spamming damage data to: " .. targetSpiderModel.Name, 1)

                -- TIMED 2-SECOND HYPER-SPAM COOLDOWN WINDOW
                local startTime = os.clock()
                while _G.SpiderKillLoopActive and (os.clock() - startTime < 2.0) do
                    if not targetSpiderModel or not targetSpiderModel.Parent then break end
                    
                    pcall(function()
                        for _, insideDescendant in ipairs(targetSpiderModel:GetDescendants()) do
                            if insideDescendant:IsA("RemoteEvent") then
                                insideDescendant:FireServer()
                                insideDescendant:FireServer("Damage", 100)
                                insideDescendant:FireServer("Kill")
                                insideDescendant:FireServer(true)
                            end
                        end
                    end)
                    task.wait(0.1)
                end

                -- Disconnect heartbeat
                isLockingActive = false
                if lockConnection then lockConnection:Disconnect() end
                
                _G.EradicatedSpidersTable[targetSpiderModel] = true
                task.wait(0.05) 
            end
        end

        -- =========================================================================
        -- PHASE 2: AUTOMATIC FINAL TELEPORT & RELIABLE TIMED EXIT PROMPT CHECK
        -- =========================================================================
        if _G.SpiderKillLoopActive then
            notify("Exit Phase", "Teleporting directly to School Exit Gate...", 2)
            
            if character:FindFirstChild("Humanoid") then 
                pcall(function() character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) 
            end
            task.wait(0.02)
            
            local exitDoorCFrame = CFrame.new(174.953, 7.586, 513.158)
            character:PivotTo(exitDoorCFrame)
            task.wait(0.3)

            -- TIMED DELAY UPGRADE: Forced 2-second delay
            for secondsLeft = 2, 1, -1 do
                if not _G.SpiderKillLoopActive then break end
                notify("Syncing Map", "Enforcing server synchronization: " .. secondsLeft .. "s...", 1)
                task.wait(1)
            end

            notify("Searching Prompt", "Scanning directory tree for Exit ProximityPrompt...", 1.5)
            
            -- Simplified Recursive Lookup
            local exitPrompt = nil
            local scanAttempts = 0
            
            while not exitPrompt and scanAttempts < 30 and _G.SpiderKillLoopActive do
                scanAttempts = scanAttempts + 1
                
                local doorFolder = Workspace:FindFirstChild("Section2")
                    and Workspace.Section2:FindFirstChild("School")
                    and Workspace.Section2.School:FindFirstChild("Doors")
                    and Workspace.Section2.School.Doors:FindFirstChild("ExitDoor")
                
                if doorFolder then
                    local proxPart = doorFolder:FindFirstChild("ProxPart")
                    exitPrompt = proxPart and proxPart:FindFirstChildOfClass("ProximityPrompt")
                end
                
                if not exitPrompt then
                    local fallbackExit = Workspace:FindFirstChild("ExitDoor", true)
                    exitPrompt = fallbackExit and fallbackExit:FindFirstChildWhichIsA("ProximityPrompt", true)
                end
                
                if not exitPrompt then 
                    task.wait(0.1)
                end
            end

            if exitPrompt then
                safeFirePrompt(exitPrompt)
                notify("Mission Completed", "Exit Door activated successfully! Section 2 cleared.", 4, "success")
            else
                notify("Streaming Failure", "Exit Door prompt failed to stream into the Workspace cache!", 4, "error")
            end
        end
        
        _G.SpiderKillLoopActive = false -- Reset flag
    end)
end)



S2QuickTab.createToggle("Akari ESP X SafeZone", "Show Akari (All variants) & Teleport to SafeZone if near", function(state)
    local CoreGui = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local akariConnection = nil
    
    -- Container para sa mga BillboardGUI natin
    local espContainer = CoreGui:FindFirstChild("IOHUB_AkariUnifiedContainer")
    if not espContainer then
        espContainer = Instance.new("Folder")
        espContainer.Name = "IOHUB_AkariUnifiedContainer"
        espContainer.Parent = CoreGui
    end

    -- Function para maglagay ng Highlight at Name Tag
    local function applyModelESP(model, isRage, isNightmare)
        if not model or not model:IsA("Model") then return end
        
        local tagIdentifier = "AkariESP_" .. model.Name .. "_" .. tostring(model:GetPivot().Position)
        if espContainer:FindFirstChild(tagIdentifier) then return end

        -- 1. Highlight
        local highlight = model:FindFirstChild("AkariHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "AkariHighlight"
            highlight.FillColor = isRage and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 0, 100)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = model
        end

        -- 2. Billboard (Name Tag)
        local targetPart = model:FindFirstChild("Hitbox") or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if targetPart then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = tagIdentifier
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
            billboard.Adornee = targetPart
            billboard.Parent = espContainer
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            
            local displayName = "Akari"
            if isNightmare and isRage then displayName = "Akari (Nightmare Rage)"
            elseif isNightmare then displayName = "Akari (Nightmare)"
            elseif isRage then displayName = "Akari (Rage)"
            else displayName = "Akari (Normal)" end

            label.Text = displayName
            label.TextColor3 = isRage and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 0, 100)
            label.TextSize = 20
            label.Font = Enum.Font.SourceSansBold
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.TextStrokeTransparency = 0
            label.Parent = billboard
        end
    end

    -- Function para i-scan lahat ng variants ni Akari
    local function scanAkariFolders()
        local s2 = Workspace:FindFirstChild("Section2")
        if not s2 then return end

        local monsterFolder = s2:FindFirstChild("Monster")
        local rageFolder = s2:FindFirstChild("Rage")

        local normalAkari = monsterFolder and monsterFolder:FindFirstChild("Akari")
        local normalAkariRage = rageFolder and rageFolder:FindFirstChild("AkariRage")
        local nmAkari = monsterFolder and monsterFolder:FindFirstChild("AkariNM")
        local nmAkariRage = rageFolder and rageFolder:FindFirstChild("AkariRageNM")

        if normalAkari and normalAkari:IsA("Model") then applyModelESP(normalAkari, false, false) end
        if normalAkariRage and normalAkariRage:IsA("Model") then applyModelESP(normalAkariRage, true, false) end
        if nmAkari and nmAkari:IsA("Model") then applyModelESP(nmAkari, false, true) end
        if nmAkariRage and nmAkariRage:IsA("Model") then applyModelESP(nmAkariRage, true, true) end
    end

    -- =========================================================================
    -- STATE EVALUATION (ON / OFF SWITCHES)
    -- =========================================================================
    if state then
        -- ===== [TOGGLE ON] =====
        scanAkariFolders()

        -- Listener para sa mga bagong spawn
        if not akariConnection then
            akariConnection = Workspace.DescendantAdded:Connect(function(descendant)
                task.spawn(function()
                    pcall(function()
                        if descendant:IsA("Model") then
                            if descendant.Name == "Akari" then applyModelESP(descendant, false, false)
                            elseif descendant.Name == "AkariRage" then applyModelESP(descendant, true, false)
                            elseif descendant.Name == "AkariNM" then applyModelESP(descendant, false, true)
                            elseif descendant.Name == "AkariRageNM" then applyModelESP(descendant, true, true)
                            end
                        end
                    end)
                end)
            end)
        end

        -- SafeZone Radar Engine
        if not _G.RadarThreadActive then
            _G.RadarThreadActive = true
            task.spawn(function()
                local safeZoneCFrame = CFrame.new(174.887, 9.931, 368.043)
                local safetyDistanceThreshold = 25

                while _G.RadarThreadActive do
                    task.wait(0.15)
                    
                    local character = player.Character
                    local currentHRP = character and character:FindFirstChild("HumanoidRootPart")
                    
                    local s2 = Workspace:FindFirstChild("Section2")
                    local monsterFolder = s2 and s2:FindFirstChild("Monster")
                    local rageFolder = s2 and s2:FindFirstChild("Rage")
                    
                    local threatModel = (monsterFolder and monsterFolder:FindFirstChild("Akari")) 
                        or (rageFolder and rageFolder:FindFirstChild("AkariRage"))
                        or (monsterFolder and monsterFolder:FindFirstChild("AkariNM"))
                        or (rageFolder and rageFolder:FindFirstChild("AkariRageNM"))
                    
                    local threatPart = threatModel and (threatModel:FindFirstChild("Hitbox") or threatModel:FindFirstChild("HumanoidRootPart") or threatModel:FindFirstChildWhichIsA("BasePart"))
                    
                    if threatPart and currentHRP then
                        local distance = (currentHRP.Position - threatPart.Position).Magnitude
                        
                        if distance <= safetyDistanceThreshold then
                            -- I-OFF ANG AUTO AKARI SPIDER LOOP PARA HINDI MAGPATULOY ANG PAG-ATAKE
                            _G.SpiderKillLoopActive = false 
                            
                            notify("🚨 DANGER DETECTED", threatModel.Name .. " is within " .. math.floor(distance) .. " studs! Teleporting to SafeZone!", 3, "error")
                            
                            -- Safe Teleport gamit ang PivotTo
                            character:PivotTo(safeZoneCFrame)
                            task.wait(2.5) -- Cooldown buffer
                        end
                    end
                end
            end)
        end

        notify("ESP & RADAR", "Akari ESP & SafeZone Radar: ON", 2, "success")
    else
        -- ===== [TOGGLE OFF] =====
        if akariConnection then
            akariConnection:Disconnect()
            akariConnection = nil
        end
        
        _G.RadarThreadActive = false
        
        -- Linisin ang mga Highlights
        for _, desc in ipairs(Workspace:GetDescendants()) do
            if desc.Name == "AkariHighlight" then
                desc:Destroy()
            end
        end
        
        if espContainer then
            espContainer:ClearAllChildren()
        end
        
        notify("ESP & RADAR", "Akari ESP and SafeZone Radar: OFF", 2, "info")
    end
end)





-- 3) Bandage Picked Up
S2Tab.createCustomButton("Bandage Picked Up", "", function()
    fireReliable("Section2/BandagePickedUp", "Bandage Picked Up")
    notify("Success", "Bandage Picked Up sent", 2, "success")
end)


-- Hideo Healed
S2Tab.createCustomButton("Hideo Healed", "", function()
    fireReliable("Section2/HideoHealed", "Hideo Healed")
end)

S2Tab.createToggle("Auto Kill All School Gata", "Auto-fire Grunt RemoteEvents within 30 studs", function(state)
    _G.GruntsAutoFireActive = state

    if not state then
        notify("Info", "Grunt Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer
    local DETECT_RADIUS = 5000

    notify("Success", "Grunt Auto-Fire", 3, "success")

    task.spawn(function()
        while _G.GruntsAutoFireActive do
            task.wait(0.1)
            if not _G.GruntsAutoFireActive then break end

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local gruntsFolder = Workspace:FindFirstChild("Section2")
                    and Workspace.Section2:FindFirstChild("Grunts")

                if gruntsFolder then
                    for _, gruntObj in ipairs(gruntsFolder:GetChildren()) do
                        if not _G.GruntsAutoFireActive then break end

                        if gruntObj:IsA("Model") then
                            local hitbox = gruntObj:FindFirstChild("Hitbox")
                                or gruntObj:FindFirstChild("HumanoidRootPart")
                                or gruntObj:FindFirstChildWhichIsA("BasePart", true)

                            if hitbox then
                                local dist = (hitbox.Position - hrp.Position).Magnitude

                                if dist <= DETECT_RADIUS then
                                    -- Hanapin ang RemoteEvent sa loob ng Grunt
                                    local remote = gruntObj:FindFirstChild("RemoteEvent")
                                    
                                    if remote then
                                        pcall(function()
                                            remote:FireServer()
                                            remote:FireServer("Damage", 100)
                                            remote:FireServer("Kill")
                                            remote:FireServer(true)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)



S2Tab.createToggle("Auto Bypass RoomDoor", "Auto-fire nearby doors within 12 studs", function(state)
    _G.RoomDoorBypassActive = state

    if not state then
        notify("Info", "RoomDoor Bypass: OFF", 2, "info")
        return
    end

    local player = game.Players.LocalPlayer
    local MAX_DIST = 3
    local SCAN_WAIT = 0.4

    notify("Success", "RoomDoor Bypass: ON (5 studs)", 3, "success")

    task.spawn(function()
        while _G.RoomDoorBypassActive do
            task.wait(SCAN_WAIT)
            if not _G.RoomDoorBypassActive then break end

            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local classRoomDoors = workspace:FindFirstChild("Section2")
                and workspace.Section2:FindFirstChild("School")
                and workspace.Section2.School:FindFirstChild("Doors")
                and workspace.Section2.School.Doors:FindFirstChild("ClassRoomDoors")

            if not classRoomDoors then
                continue
            end

            local fired = 0

            for _, door in ipairs(classRoomDoors:GetChildren()) do
                if not _G.RoomDoorBypassActive then break end

                local pos = getObjectPos(door)
                if pos then
                    local dist = (pos - root.Position).Magnitude
                    if dist <= MAX_DIST then
                        fireReliable("Section2/RoomADoorSkillCheckDone", "Room Door", door)
                        fired = fired + 1
                    end
                end
            end

            if fired > 0 then
                notify("Success", "Bypassed " .. fired .. " nearby door(s)", 2, "success")
            end
        end

        notify("Info", "RoomDoor Bypass: OFF", 2, "info")
    end)
end)



-- ====================================================================
-- ESP AKARI SPIDER TOGGLE
-- ====================================================================
S2Tab.createToggle("ESP AkariSpider", "Toggle Visual Highlights for all AkariSpiders", function(state)
    _G.AkariSpiderEspEnabled = state

    task.spawn(function()
        while _G.AkariSpiderEspEnabled do
            local spidersFolder = workspace:FindFirstChild("Section2")
                and workspace.Section2:FindFirstChild("MAINOBJECTIVE2")
                and workspace.Section2.MAINOBJECTIVE2:FindFirstChild("Spiders")

            if spidersFolder then
                for _, spiderObj in ipairs(spidersFolder:GetChildren()) do
                    if spiderObj:IsA("Model") then
                        if not spiderObj:FindFirstChild("AkariSpider_Highlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "AkariSpider_Highlight"
                            highlight.Adornee = spiderObj
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = spiderObj
                        end
                    end
                end
            end
            task.wait(1)
        end

        local spidersFolder = workspace:FindFirstChild("Section2")
            and workspace.Section2:FindFirstChild("MAINOBJECTIVE2")
            and workspace.Section2.MAINOBJECTIVE2:FindFirstChild("Spiders")

        if spidersFolder then
            for _, spiderObj in ipairs(spidersFolder:GetChildren()) do
                if spiderObj:IsA("Model") then
                    local hl = spiderObj:FindFirstChild("AkariSpider_Highlight")
                    if hl then hl:Destroy() end
                end
            end
        end
    end)
end)



S3QuickTab.createCustomButton("Contact IJO", "Teleport to Ijo, wait 3s, and back to SafeZone", function()
    local Players = game:GetService("Players")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    -- Ang iyong mga eksaktong CFrame coordinates
    local ijoCFrame = CFrame.new(-3392.948, 8.000, 763.995)
    local section3SafeZone = CFrame.new(-3584.720, 8.000, 247.522)

    -- Helper para sa safe teleport
    local function safeTeleport(targetCFrame)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
            task.wait(0.05)
        end
        character:PivotTo(targetCFrame)
    end

    -- =========================================================================
    -- STAGE 1: Teleport kay Contact Ijo
    -- =========================================================================
    notify("Stage 1/2", "Papunta na kay Contact Ijo...", 2, "info")
    
    safeTeleport(ijoCFrame)

    -- =========================================================================
    -- STAGE 2: Maghintay ng 3 Segundo (Interaction/Quest trigger window)
    -- =========================================================================
    for i = 3, 1, -1 do
        notify("Waiting...", "Nasa tapat ni Ijo. Babalik sa SafeZone sa loob ng " .. i .. "s...", 1, "warning")
        task.wait(1)
    end

    -- =========================================================================
    -- STAGE 3: Awtomatikong Pagbalik sa SafeZone
    -- =========================================================================
    notify("Stage 2/2", "Bumabalik na sa SafeZone...", 1.5, "info")
    
    safeTeleport(section3SafeZone)
    
    notify("Mission Complete", "Naka-secure na sa SafeZone!", 3, "success")
end)



S3QuickTab.createToggle("Mizuno ESP X SafeZone", "Show Mizuno (Normal & NM) & Teleport to SafeZone if near", function(state)
    local CoreGui = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    
    local player = Players.LocalPlayer
    
    local section3Connection = nil
    
    -- Container para sa mga BillboardGUI
    local espContainer = CoreGui:FindFirstChild("IOHUB_Section3Container")
    if not espContainer then
        espContainer = Instance.new("Folder")
        espContainer.Name = "IOHUB_Section3Container"
        espContainer.Parent = CoreGui
    end

    -- Function para maglagay ng Highlight at Name Tag
    local function applyModelESP(model, isNightmare)
        if not model or not model:IsA("Model") then return end
        
        local tagIdentifier = "MizunoESP_" .. model.Name .. "_" .. tostring(model:GetPivot().Position)
        if espContainer:FindFirstChild(tagIdentifier) then return end

        -- 1. Highlight
        local highlight = model:FindFirstChild("MizunoHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "MizunoHighlight"
            highlight.FillColor = isNightmare and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(0, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = model
        end

        -- 2. Billboard (Name Tag)
        local targetPart = model:FindFirstChild("Hitbox") or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
        if targetPart then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = tagIdentifier
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
            billboard.Adornee = targetPart
            billboard.Parent = espContainer
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = isNightmare and "Mizuno (Nightmare)" or "Mizuno"
            label.TextColor3 = isNightmare and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(0, 255, 255)
            label.TextSize = 20
            label.Font = Enum.Font.SourceSansBold
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.TextStrokeTransparency = 0
            label.Parent = billboard
        end
    end

    -- Function para i-scan ang folder
    local function scanMizunoFolder()
        local monsterFolder = Workspace:FindFirstChild("Section3") and Workspace.Section3:FindFirstChild("Monster")
        if not monsterFolder then return end

        local normalMizuno = monsterFolder:FindFirstChild("Mizuno")
        local nmMizuno = monsterFolder:FindFirstChild("MizunoNM")

        if normalMizuno and normalMizuno:IsA("Model") then applyModelESP(normalMizuno, false) end
        if nmMizuno and nmMizuno:IsA("Model") then applyModelESP(nmMizuno, true) end
    end

    -- =========================================================================
    -- STATE CONTROL (ON / OFF SWITCHES)
    -- =========================================================================
    if state then
        -- ===== [TOGGLE ON] =====
        scanMizunoFolder()

        if not section3Connection then
            section3Connection = Workspace.DescendantAdded:Connect(function(descendant)
                task.spawn(function()
                    pcall(function()
                        if descendant:IsA("Model") then
                            if descendant.Name == "Mizuno" then
                                applyModelESP(descendant, false)
                            elseif descendant.Name == "MizunoNM" then
                                applyModelESP(descendant, true)
                            end
                        end
                    end)
                end)
            end)
        end

        -- Radar Engine
        if not _G.Section3RadarActive then
            _G.Section3RadarActive = true
            task.spawn(function()
                local section3SafeZone = CFrame.new(-3584.720, 8.000, 247.522)
                local safetyDistanceThreshold = 25 

                while _G.Section3RadarActive do
                    task.wait(0.15)
                    
                    local character = player.Character
                    local currentHRP = character and character:FindFirstChild("HumanoidRootPart")
                    
                    local monsterFolder = Workspace:FindFirstChild("Section3") and Workspace.Section3:FindFirstChild("Monster")
                    local liveMizuno = monsterFolder and (monsterFolder:FindFirstChild("Mizuno") or monsterFolder:FindFirstChild("MizunoNM"))
                    
                    -- [INAYOS] Yung typo na 'liveMuzino' ay ginawang 'liveMizuno'
                    local threatPart = liveMizuno and (liveMizuno:FindFirstChild("Hitbox") or liveMizuno:FindFirstChild("HumanoidRootPart") or liveMizuno:FindFirstChildWhichIsA("BasePart"))
                    
                    if threatPart and currentHRP and character.Parent then
                        local distance = (currentHRP.Position - threatPart.Position).Magnitude
                        
                        if distance <= safetyDistanceThreshold then
                            local threatName = liveMizuno.Name == "MizunoNM" and "Mizuno (Nightmare)" or "Mizuno"
                            
                            -- Papatayin nito ang Auto Restore Power loop kapag may banta
                            _G.Section3RestoreActive = false
                            
                            notify("🚨 MIZUNO DETECTED", threatName .. " is within " .. math.floor(distance) .. " studs! Teleporting to SafeZone!", 3, "error")
                            
                            -- [INAYOS] Ginamit ang PivotTo para safe
                            character:PivotTo(section3SafeZone)
                            task.wait(2.5) 
                        end
                    end
                end
            end)
        end

        notify("RADAR ACTIVE", "Mizuno ESP & SafeZone Radar: ON", 2, "success")
    else
        -- ===== [TOGGLE OFF] =====
        if section3Connection then
            section3Connection:Disconnect()
            section3Connection = nil
        end
        
        _G.Section3RadarActive = false
        
        -- Alisin ang mga Highlight
        for _, desc in ipairs(Workspace:GetDescendants()) do
            if desc.Name == "MizunoHighlight" then
                desc:Destroy()
            end
        end
        
        if espContainer then
            espContainer:ClearAllChildren()
        end
        
        notify("RADAR OFF", "Mizuno ESP and Radar: OFF", 2, "info")
    end
end)


S3QuickTab.createCustomButton("Auto Restore Power", "Instant Teleport to All Power Circuit and Finish MiniGame", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    _G.Section3RestoreActive = false
    task.wait(0.15) -- [PRESERVED]
    _G.Section3RestoreActive = true

    local function safeFirePrompt(prompt)
        if prompt then
            pcall(function()
                prompt.RequiresLineOfSight = false
                prompt.MaxActivationDistance = 50
                task.wait(0.05) -- [PRESERVED]
                fireproximityprompt(prompt)
            end)
        end
        return true
    end

    local circuitsFolder = Workspace:FindFirstChild("Section3")
        and Workspace.Section3:FindFirstChild("OBJECTIVE")
        and Workspace.Section3.OBJECTIVE:FindFirstChild("Circuits")

    if not circuitsFolder then
        notify("Error", "Circuits folder not found in Section 3!", 4, "error")
        _G.Section3RestoreActive = false
        return
    end

    local CobaltEvent = ReplicatedStorage:FindFirstChild("modules")
        and ReplicatedStorage.modules:FindFirstChild("Packet")
        and ReplicatedStorage.modules.Packet:FindFirstChild("Reliable")

    if not CobaltEvent then
        notify("Critical Error", "Cobalt Packet Remote Event path not found!", 4, "error")
        _G.Section3RestoreActive = false
        return
    end

    local circuitPositions = {
        CFrame.new(-3230.88599, 8.51531696, 681.428955, 0.948552489, 0, 0.316619992, 0, 1, 0, -0.316619992, 0, 0.948552489),
        CFrame.new(-3594.27295, 8.64291477, 786.69104, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247),
        CFrame.new(-3513.80835, 8.46253777, 554.146118, -0.949462295, 0, 0.313881457, 0, 1, 0, -0.313881457, 0, -0.949462295),
        CFrame.new(-3153.30762, 8.55415249, 484.829102, 0, 0, 1, 0, 1, -0, -1, 0, 0),
        CFrame.new(-3388.81348, 8.52897835, 582.247437, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07),
        CFrame.new(-3699.98584, 8.54430199, 618.209167, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247),
        CFrame.new(-3389.471, 8.000, 788.887)
    }

    local function getClosestCircuitPrompt()
        local closestPrompt = nil
        local closestCircuitModel = nil
        local shortestDistance = math.huge
        
        local currentHRP = character:FindFirstChild("HumanoidRootPart")
        if not currentHRP then return nil, nil end

        for _, obj in ipairs(circuitsFolder:GetChildren()) do
            local promptPart = obj:FindFirstChild("PromptPart")
            local prompt = promptPart and promptPart:FindFirstChildOfClass("ProximityPrompt")
            
            if prompt and promptPart then
                local distance = (currentHRP.Position - promptPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPrompt = prompt
                    closestCircuitModel = obj
                end
            end
        end
        return closestPrompt, closestCircuitModel
    end

    notify("Farm Started", "Executing fast Cobalt sequence for all 6 circuits...", 3, "info")

    for index, targetCFrame in ipairs(circuitPositions) do
        -- Auto-cancel kapag nag-trigger ang SafeZone Radar
        if not _G.Section3RestoreActive then break end
        
        notify("Progress", "Teleporting to Circuit [" .. index .. "/6]...", 1, "info")
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
        
        task.wait(0.01) -- [PRESERVED]
        
        -- Ginamit ang PivotTo pero pinanatili ang exact rotation mo
        character:PivotTo(targetCFrame)
        
        task.wait(0.3) -- [PRESERVED]

        if not _G.Section3RestoreActive then break end

        local prompt, circuitModel = getClosestCircuitPrompt()

        if prompt and circuitModel then
            safeFirePrompt(prompt)
            task.wait(0.15) -- [PRESERVED]

            for round = 1, 3 do
                if not _G.Section3RestoreActive then break end
                pcall(function()
                    CobaltEvent:FireServer("Section3/CircuitRoundComplete", circuitModel)
                end)
                task.wait(0.05) -- [PRESERVED]
            end
            
            task.wait(0.2) -- [PRESERVED]
        else
            notify("Warning", "Circuit prompt not found at Spot #" .. index, 1, "warning")
        end
    end

    -- Mag-notify base sa kung natapos ba o nakansela
    if _G.Section3RestoreActive then
        notify("Success", "All circuits successfully restored without tweens!", 4, "success")
    else
        notify("Cancelled", "Auto Restore interrupted by SafeZone Radar!", 3, "warning")
    end
    
    _G.Section3RestoreActive = false -- Isara ang flag pagkatapos
end)


S3QuickTab.createCustomButton("Exit to Forest", "Teleports to the exit sequence", function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    -- Helper function para sa safe teleport
    local function safeTeleport(targetCFrame)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
            task.wait(0.05) -- Sandaling wait para i-bypass ang physics locking
        end
        character:PivotTo(targetCFrame)
    end

    notify("Exit Sequence", "Teleporting to Door Destination...", 2, "info")
    local doorDest = CFrame.new(-3389.251, 8.000, 761.373)
    safeTeleport(doorDest)
    
    task.wait(1.5) -- [PRESERVED] Eksaktong wait time mo

    notify("Exit Sequence", "Teleporting to End Destination...", 2, "info")
    local endDest = CFrame.new(-3392.523, 7.675, 890.753)
    safeTeleport(endDest)

    notify("Success", "Successfully teleported to all exit destinations!", 3, "success")
end)




-- ====================================================================
-- ESP CIRCUITS TOGGLE
-- ====================================================================
S3Tab.createToggle("ESP Circuits", "Toggle Visual Highlights for Power Circuits", function(state)
    _G.CircuitsEspEnabled = state

    task.spawn(function()
        while _G.CircuitsEspEnabled do
            local circuitsFolder = workspace:FindFirstChild("Section3")
                and workspace.Section3:FindFirstChild("OBJECTIVE")
                and workspace.Section3.OBJECTIVE:FindFirstChild("Circuits")

            if circuitsFolder then
                for _, circuitObj in ipairs(circuitsFolder:GetChildren()) do
                    if circuitObj:IsA("Model") or circuitObj:IsA("BasePart") then
                        if not circuitObj:FindFirstChild("Circuit_Highlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "Circuit_Highlight"
                            highlight.Adornee = circuitObj
                            highlight.FillColor = Color3.fromRGB(255, 255, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = circuitObj
                        end
                    end
                end
            end
            task.wait(1)
        end

        local circuitsFolder = workspace:FindFirstChild("Section3")
            and workspace.Section3:FindFirstChild("OBJECTIVE")
            and workspace.Section3.OBJECTIVE:FindFirstChild("Circuits")

        if circuitsFolder then
            for _, circuitObj in ipairs(circuitsFolder:GetChildren()) do
                local hl = circuitObj:FindFirstChild("Circuit_Highlight")
                if hl then hl:Destroy() end
            end
        end
    end)
end)




S4QuickTab.createCustomButton("Get ID & Open Gate", "Teleports to ID Card and opens the Lab Gate", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    -- Safe Prompt Function
    local function safeFirePrompt(prompt)
        if not prompt then return false end
        pcall(function()
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50
            task.wait(0.1) -- [PRESERVED]
            
            fireproximityprompt(prompt)
            
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance
        end)
        return true
    end

    -- Safe Teleport Function
    local function safeTeleport(targetCFrame)
        if humanoid then
            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
        task.wait(0.02) -- [PRESERVED]
        character:PivotTo(targetCFrame)
        
        -- I-reset ang velocity para hindi mag-slide o mahulog
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
    end

    notify("Entrance", "Starting ID & Gate sequence...", 2, "info")

    -- =========================================================================
    -- STEP 1: Get ID Card
    -- =========================================================================
    notify("Step 1/2", "Teleporting to ID Card...", 1.5, "info")
    safeTeleport(CFrame.new(-3375.321, -299.782, 4686.612))
    task.wait(0.5) -- [PRESERVED]

    local idPrompt = Workspace:FindFirstChild("Section4")
        and Workspace.Section4:FindFirstChild("Lab")
        and Workspace.Section4.Lab:FindFirstChild("Floor1")
        and Workspace.Section4.Lab.Floor1:FindFirstChild("Entrance")
        and Workspace.Section4.Lab.Floor1.Entrance:FindFirstChild("IDCARD")
        and Workspace.Section4.Lab.Floor1.Entrance.IDCARD:FindFirstChild("ProximityPrompt")

    if idPrompt then
        safeFirePrompt(idPrompt)
        notify("Success", "ID Card picked up!", 1.5, "success")
    else
        notify("Warning", "ID Card prompt not found! Proceeding...", 2, "warning")
    end
    task.wait(1) -- [PRESERVED]

    -- =========================================================================
    -- STEP 2: Open Lab Gate
    -- =========================================================================
    notify("Step 2/2", "Teleporting to Lab Gate...", 1.5, "info")
    safeTeleport(CFrame.new(-3378.124, -300.218, 4662.547))
    task.wait(0.5) -- [PRESERVED]

    local gatePrompt = Workspace:FindFirstChild("Section4")
        and Workspace.Section4:FindFirstChild("Lab")
        and Workspace.Section4.Lab:FindFirstChild("Floor1")
        and Workspace.Section4.Lab.Floor1:FindFirstChild("Entrance")
        and Workspace.Section4.Lab.Floor1.Entrance:FindFirstChild("SFXPart")
        and Workspace.Section4.Lab.Floor1.Entrance.SFXPart:FindFirstChild("ProximityPrompt")

    if gatePrompt then
        safeFirePrompt(gatePrompt)
        notify("Success", "Lab Gate opened!", 1.5, "success")
    else
        notify("Warning", "Gate prompt not found!", 2, "warning")
    end

    notify("Complete", "ID Card acquired and Lab Gate opened!", 3, "success")
end)







S4QuickTab.createCustomButton("Auto Valves", "Automates fast valve loops cleanly and moves to Contain", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    _G.CleanseRoomActive = false
    task.wait(0.15)
    _G.CleanseRoomActive = true
    _G.ClearedValves = {} -- [INAYOS] Gagamitin na natin ang mismong object bilang key, hindi yung name
    _G.HogoThreatDetected = false

    local function forceDexFire(prompt)
        if not prompt then return false end
        pcall(function()
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50
            
            prompt:InputHoldBegin()
            task.wait(0.01)
            prompt:InputHoldEnd()
            
            fireproximityprompt(prompt)
        end)
        return true
    end

    local cleanseFolder = Workspace:FindFirstChild("Section4")
        and Workspace.Section4:FindFirstChild("Lab")
        and Workspace.Section4.Lab:FindFirstChild("CleanseRoomObjective")

    if not cleanseFolder then
        notify("Critical Error", "CleanseRoomObjective folder not found!", 4, "error")
        _G.CleanseRoomActive = false
        return
    end

    notify("Valves Farm", "Initializing fast Valve automation...", 3, "info")
    task.wait(0.2)

    local valvesFolder = cleanseFolder:FindFirstChild("Valves")
    if valvesFolder then
        while _G.CleanseRoomActive do
            if _G.HogoThreatDetected then
                notify("Emergency Abort", "Automation killed due to immediate threat presence!", 3, "warning")
                break
            end

            local currentValvesList = valvesFolder:GetChildren()
            local targetValve = nil
            local remainingUncleanedCount = 0
            
            -- [INAYOS] Pag-scan: Ginagamit na natin yung object (obj) imbes na pangalan (obj.Name)
            for _, obj in ipairs(currentValvesList) do
                if obj:IsA("Model") and not _G.ClearedValves[obj] then
                    remainingUncleanedCount = remainingUncleanedCount + 1
                    if not targetValve then
                        targetValve = obj 
                    end
                end
            end
            
            if remainingUncleanedCount == 0 or not targetValve or not _G.CleanseRoomActive then
                break
            end
            
            if targetValve and _G.CleanseRoomActive then
                notify("Valve Locked", "Snapping coordinates to: " .. targetValve.Name, 1.5, "info")
                
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
                task.wait(0.01)
                
                local freshPivot = targetValve:GetPivot()
                character:PivotTo(freshPivot)
                task.wait(0.3)

                -- Heartbeat Glue Layer
                local isLockingActive = true
                local lockConnection
                lockConnection = RunService.Heartbeat:Connect(function()
                    if isLockingActive and character:FindFirstChild("HumanoidRootPart") and _G.CleanseRoomActive and not _G.HogoThreatDetected then
                        character:PivotTo(freshPivot) 
                        character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) 
                    else
                        if lockConnection then lockConnection:Disconnect() end
                    end
                end)

                -- FAST RAPID-FIRE WINDOW
                notify("Fast Spam", "Rapid firing prompts inside " .. targetValve.Name, 1.5, "info")
                local startTime = os.clock()
                
                while _G.CleanseRoomActive and not _G.HogoThreatDetected and (os.clock() - startTime < 2.0) do
                    if not targetValve or not targetValve.Parent then break end
                    
                    local firedAny = false
                    for _, descendant in ipairs(targetValve:GetDescendants()) do
                        if descendant:IsA("ProximityPrompt") then
                            forceDexFire(descendant)
                            firedAny = true
                        end
                    end
                    
                    -- [INAYOS] Binagalan nang konti para hindi mag-spam ng sobra sa server
                    if firedAny then
                        task.wait(0.1) 
                    else
                        task.wait(0.05)
                    end
                end

                isLockingActive = false
                if lockConnection then lockConnection:Disconnect() end
                
                if _G.HogoThreatDetected then break end

                -- [PINAKA-MAHALAGANG INAYOS] 
                -- Itinatala natin yung mismong 'targetValve' object, hindi yung pangalan niya.
                -- Para kahit "Valve" pangalan niya, alam ng script na tapos na siya at lilipat na sa susunod.
                _G.ClearedValves[targetValve] = true
                notify("Valve Logged", "Successfully cleared " .. targetValve.Name, 1.5, "success")
                
                for secondsLeft = 2, 1, -1 do
                    if not _G.CleanseRoomActive or _G.HogoThreatDetected then break end
                    notify("Transition", "Moving to next valve in " .. secondsLeft .. "s...", 1, "info")
                    task.wait(1)
                end
            end
        end
    end

    if _G.CleanseRoomActive and not _G.HogoThreatDetected then
        notify("Valves Clear", "Teleporting to Contain location...", 2.5, "info")
        task.wait(0.5)

        local containCFrame = CFrame.new(-3441.648, -299.855, 4378.025)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
        task.wait(0.02)
        
        character:PivotTo(containCFrame)
        notify("Success", "Arrived safely at the Contain zone!", 4, "success")
    end
    
    _G.CleanseRoomActive = false
end)




S4QuickTab.createCustomButton("Auto Terminals", "Bypasses all shape terminals instantly and moves to Contain", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    _G.CleanseRoomActive = false
    task.wait(0.15)
    _G.CleanseRoomActive = true
    _G.ClearedTerminalsMemory = {} 

    local function forceDexFire(prompt)
        if not prompt then return false end
        pcall(function()
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50
            
            prompt:InputHoldBegin()
            task.wait(0.02)
            prompt:InputHoldEnd()
            
            fireproximityprompt(prompt)
        end)
        return true
    end

    local CobaltEvent = ReplicatedStorage:FindFirstChild("modules")
        and ReplicatedStorage.modules:FindFirstChild("Packet")
        and ReplicatedStorage.modules.Packet:FindFirstChild("Reliable")

    if not CobaltEvent then
        notify("Critical Error", "Cobalt Packet route not found!", 4, "error")
        _G.CleanseRoomActive = false
        return
    end

    local cleanseFolder = Workspace:FindFirstChild("Section4")
        and Workspace.Section4:FindFirstChild("Lab")
        and Workspace.Section4.Lab:FindFirstChild("CleanseRoomObjective")

    if not cleanseFolder then
        notify("Critical Error", "CleanseRoomObjective folder not found!", 4, "error")
        _G.CleanseRoomActive = false
        return
    end

    notify("Terminals Farm", "Initializing Shape Terminals network scan...", 3, "info")
    task.wait(0.5)

    local shapeTerminalsFolder = cleanseFolder:FindFirstChild("ShapeTerminals")
    if shapeTerminalsFolder then
        while _G.CleanseRoomActive do
            local currentTerminalsList = shapeTerminalsFolder:GetChildren()
            local targetTerminalUnit = nil
            local activeUncleanedCount = 0
            
            for _, obj in ipairs(currentTerminalsList) do
                if obj:IsA("Model") and (obj.Name == "Terminal" or string.find(obj.Name:lower(), "terminal")) and not _G.ClearedTerminalsMemory[obj] then
                    activeUncleanedCount = activeUncleanedCount + 1
                    if not targetTerminalUnit then
                        targetTerminalUnit = obj
                    end
                end
            end
            
            if activeUncleanedCount == 0 or not targetTerminalUnit or not _G.CleanseRoomActive then
                notify("Terminals Clear", "All loaded terminals successfully processed!", 2, "success")
                break
            end
            
            if targetTerminalUnit and _G.CleanseRoomActive then
                local promptPart = targetTerminalUnit:FindFirstChild("PromptPart") or targetTerminalUnit:FindFirstChildWhichIsA("BasePart", true)
                local terminalPrompt = targetTerminalUnit:FindFirstChildWhichIsA("ProximityPrompt", true)

                if promptPart then
                    notify("Terminal Lock", "Snapping to: " .. targetTerminalUnit.Name, 1.5, "info")
                    
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
                    task.wait(0.01)
                    
                    local targetCFrame = promptPart.CFrame * CFrame.new(0, 0, -1)
                    character:PivotTo(targetCFrame)
                    task.wait(0.6) 

                    if terminalPrompt then
                        forceDexFire(terminalPrompt)
                        task.wait(0.4) 
                    end

                    notify("Bypassing", "Injecting 2x RoundComplete packets...", 1, "info")
                    pcall(function()
                        CobaltEvent:FireServer("ShapeTerminal/RoundComplete", targetTerminalUnit)
                        task.wait(0.25)
                        CobaltEvent:FireServer("ShapeTerminal/RoundComplete", targetTerminalUnit)
                        task.wait(0.25)
                    end)

                    -- RELEASE AT FORCE WALK SIMULATION
                    pcall(function()
                        -- 1. I-fire ang server release
                        CobaltEvent:FireServer("ShapeTerminal/Release", targetTerminalUnit)
                        
                        -- 2. Ibaon ang camera forcefully (Client-side)
                        local camera = Workspace.CurrentCamera
                        if camera then
                            camera.CameraType = Enum.CameraType.Custom
                            if humanoid then camera.CameraSubject = humanoid end
                        end
                        
                        -- 3. FAKE WALK SIMULATION (Para maramdaman ng laro na umalis ka)
                        if humanoid then
                            -- Pilitin umatras ng 2 seconds (simulated key press)
                            humanoid:Move(targetCFrame.LookVector * -10, true) 
                            task.wait(0.2)
                            humanoid:Move(Vector3.new(0,0,0), true) -- Pahintuin
                            
                            -- Force Humanoid state to running/freefall just to break the camera lock loop
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                        
                        -- 4. Teleport atras ng konti para tuluyang mag-break
                        character:PivotTo(targetCFrame * CFrame.new(0, 0, 5))
                    end)
                    
                    notify("POV Restored", "Terminal camera lock bypassed!", 1, "success")
                    
                    _G.ClearedTerminalsMemory[targetTerminalUnit] = true
                    task.wait(0.6) 
                else
                    _G.ClearedTerminalsMemory[targetTerminalUnit] = true
                    task.wait(0.1)
                end
            end
        end
    end

    if _G.CleanseRoomActive then
        notify("Quest Finished", "All sectors completed! Teleporting to Contain location...", 2.5, "info")
        task.wait(0.5)

        local containCFrame = CFrame.new(-3441.648, -299.855, 4378.025)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
        task.wait(0.02)
        
        character:PivotTo(containCFrame)
        notify("Success", "Arrived safely at the Contain zone!", 4, "success")
    end
    
    _G.CleanseRoomActive = false
end)






S4QuickTab.createCustomButton("Exit to Lab", "Teleports to exit position and fires the ProximityPrompt", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    -- Hanapin ang ProximityPrompt gamit ang path
    local exitPart = Workspace:FindFirstChild("Section4")
        and Workspace.Section4:FindFirstChild("Lab")
        and Workspace.Section4.Lab:FindFirstChild("ExitToStairs")
        and Workspace.Section4.Lab.ExitToStairs:FindFirstChild("EXIT")
        and Workspace.Section4.Lab.ExitToStairs.EXIT:FindFirstChild("ProxPart")

    local prompt = exitPart and exitPart:FindFirstChild("ProximityPrompt")

    if not prompt then
        notify("Error", "Exit ProximityPrompt not found!", 4, "error")
        return
    end

    notify("Teleporting", "Teleporting to Exit to Stairs...", 2, "info")

    -- Target CFrame
    local targetPosition = CFrame.new(-3467.400, -299.855, 4349.562)
    
    -- Safe Teleport (PivotTo + Jump state)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        task.wait(0.05)
    end
    
    character:PivotTo(targetPosition)
    
    -- Tanggalin ang velocity para hindi ma-fling
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
    
    task.wait(0.3) -- [PRESERVED]

    -- I-fire ang prompt safely
    pcall(function()
        local originalRequiresLineOfSight = prompt.RequiresLineOfSight
        local originalMaxDistance = prompt.MaxActivationDistance
        
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 50
        task.wait(0.05) -- [PRESERVED]

        fireproximityprompt(prompt)
        
        -- Ibalik sa dati ang prompt properties
        prompt.RequiresLineOfSight = originalRequiresLineOfSight
        prompt.MaxActivationDistance = originalMaxDistance
    end)

    notify("Success", "Exit prompt triggered!", 2, "success")
    task.wait(0.5) -- [PRESERVED]

    notify("Complete", "Successfully used Exit to Stairs!", 3, "success")
end)


S4Tab.createOneRectangle({
    Icon = "rbxassetid://127032800584061", -- Palitan mo ng tamang Image ID kung meron ka
    Title = "CODE (Make Sure Open the Gate)",
    GetValue = function()
        -- Hanapin yung RandomNumber label sa sticky note
        local codeGui = workspace:FindFirstChild("Section4")
            and workspace.Section4:FindFirstChild("Lab")
            and workspace.Section4.Lab:FindFirstChild("Floor1")
            and workspace.Section4.Lab.Floor1:FindFirstChild("Objective")
            and workspace.Section4.Lab.Floor1.Objective:FindFirstChild("StickyNote")
            and workspace.Section4.Lab.Floor1.Objective.StickyNote:FindFirstChild("PASSWORD")
            and workspace.Section4.Lab.Floor1.Objective.StickyNote.PASSWORD:FindFirstChild("SurfaceGui")
            and workspace.Section4.Lab.Floor1.Objective.StickyNote.PASSWORD.SurfaceGui:FindFirstChild("RandomNumber")

        if codeGui then
            local codeText = nil
            
            -- Kunin yung text/value
            if codeGui:IsA("TextLabel") or codeGui:IsA("TextButton") then
                codeText = codeGui.Text
            elseif codeGui:IsA("StringValue") then
                codeText = codeGui.Value
            else
                local ok, t = pcall(function() return codeGui.Text end)
                if ok and t then codeText = t end
            end




            -- I-display kung may laman
            if codeText and codeText ~= "" then
                return "" .. tostring(codeText), Color3.fromRGB(100, 220, 150) -- Green
            else
                return "Waiting for code...", Color3.fromRGB(255, 200, 80) -- Dilaw
            end
        else
            return "Not Found", Color3.fromRGB(255, 100, 100) -- Pula
        end
    end,
})


-- ====================================================================
-- SECTION 4 BUTTONS
-- ====================================================================

S4Tab.createCustomButton("Submit Code", "", function()
    local codeGui = workspace:FindFirstChild("Section4")
        and workspace.Section4:FindFirstChild("Lab")
        and workspace.Section4.Lab:FindFirstChild("Floor1")
        and workspace.Section4.Lab.Floor1:FindFirstChild("Objective")
        and workspace.Section4.Lab.Floor1.Objective:FindFirstChild("StickyNote")
        and workspace.Section4.Lab.Floor1.Objective.StickyNote:FindFirstChild("PASSWORD")
        and workspace.Section4.Lab.Floor1.Objective.StickyNote.PASSWORD:FindFirstChild("SurfaceGui")
        and workspace.Section4.Lab.Floor1.Objective.StickyNote.PASSWORD.SurfaceGui:FindFirstChild("RandomNumber")

    if not codeGui then
        notify("Error", "StickyNote code not found!", 3, "error")
        return
    end

    local code = nil
    if codeGui:IsA("TextLabel") or codeGui:IsA("TextButton") then
        code = codeGui.Text
    elseif codeGui:IsA("StringValue") then
        code = codeGui.Value
    else
        local ok, t = pcall(function() return codeGui.Text end)
        if ok and t then code = t end
    end

    if not code or code == "" then
        notify("Error", "Code is empty!", 3, "error")
        return
    end

    fireReliable("Section4/LaptopSubmit", "Submit Code", code)
    notify("Success", "Submitted code: " .. code, 3, "success")
end)


S4Tab.createCustomButton("C4 Bomb Part 1", "Teleports to Objective 2 and fires nearby prompts", function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    -- Table para i-track kung alin yung mga na-fire na natin para hindi maulit
    local firedPrompts = {}

    -- Function para mag-scan at mag-fire ng malapit na prompts
    local function fireNearbyPrompts(radius)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return 0 end

        local firedCount = 0
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") and not firedPrompts[descendant] then
                local promptParent = descendant.Parent
                
                if promptParent and promptParent:IsA("BasePart") then
                    local distance = (hrp.Position - promptParent.Position).Magnitude
                    
                    if distance <= radius then
                        -- Bypass at Fire
                        descendant.RequiresLineOfSight = false
                        descendant.MaxActivationDistance = 50
                        
                        pcall(function()
                            fireproximityprompt(descendant)
                        end)
                        
                        firedPrompts[descendant] = true
                        firedCount = firedCount + 1
                        task.wait(0.2) 
                    end
                end
            end
        end
        return firedCount
    end

    -- =====================================================================
    -- STEP 1: Teleport sa Objective 2
    -- =====================================================================
    notify("C4 Part 1", "Teleporting to Objective 2...", 2, "info")
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    task.wait(0.01)
    
    -- Base sa screenshot mo kanina: Pos: X: -3764.9, Y: 16.7, Z: 1807.5
    local targetPos = CFrame.new(-3764.9, 16.7, 1807.5)
    character:PivotTo(targetPos)
    
    -- Bigyan ng 1 segundo para mag-load yung C4 prompts sa paligid
    task.wait(1)

    -- =====================================================================
    -- STEP 2: Fire Nearby Prompts
    -- =====================================================================
    notify("C4 Part 1", "Firing nearby prompts...", 1.5, "warning")
    
    -- Gagamit tayo ng 50 studs radius. Kung may hindi na-fire, pwede mong taasan ng 70 o 100.
    local count = fireNearbyPrompts(50) 
    
    if count > 0 then
        notify("C4 Part 1 Complete", "Successfully fired " .. count .. " prompts!", 3, "success")
    else
        notify("C4 Part 1 Warning", "No prompts found nearby. Baka hindi pa nag-load.", 3, "warning")
    end
end)

S4Tab.createCustomButton("C4 Bomb Part 2", "Teleports, tweens, and Rapid Fires prompts at both posts", function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    -- Function para sa smooth na paggalaw
    local function tweenTo(targetCFrame, duration)
        local tweenCFrame = Instance.new("CFrameValue")
        tweenCFrame.Value = character:GetPivot()
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(tweenCFrame, tweenInfo, {Value = targetCFrame})
        
        local connection
        connection = tweenCFrame:GetPropertyChangedSignal("Value"):Connect(function()
            if character and character.Parent then
                character:PivotTo(tweenCFrame.Value)
            end
        end)
        
        tween:Play()
        tween.Completed:Wait()
        connection:Disconnect()
        tweenCFrame:Destroy()
    end

    -- Rapid Fire Function (Tumatakbo ng 3 segundo bawat tawag)
    local function rapidFireNearby(radius, duration)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return 0 end

        local startTime = os.clock()
        local totalFired = 0

        while (os.clock() - startTime) < duration do
            for _, descendant in ipairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                    local promptParent = descendant.Parent
                    
                    if promptParent and promptParent:IsA("BasePart") then
                        local distance = (hrp.Position - promptParent.Position).Magnitude
                        
                        if distance <= radius then
                            descendant.RequiresLineOfSight = false
                            descendant.MaxActivationDistance = 50
                            pcall(function() fireproximityprompt(descendant) end)
                        end
                    end
                end
            end
            task.wait(0.1) -- Fast scan rate
        end
        return totalFired
    end

    -- =====================================================================
    -- STEP 1: Starting Point
    -- =====================================================================
    notify("C4 Part 2", "Teleporting to Starting Point...", 2, "info")
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    task.wait(0.01)
    
    character:PivotTo(CFrame.new(-4154.744, 106.991, 2445.279))

    notify("Waiting", "Waiting 2 seconds...", 2, "warning")
    task.wait(2)

    -- =====================================================================
    -- STEP 2: Post 1 & Rapid Fire
    -- =====================================================================
    notify("C4 Part 2", "Tweening to Post 1...", 1.5, "info")
    tweenTo(CFrame.new(-4156.733, 106.991, 2555.174), 1.5)
    
    notify("Rapid Fire", "Rapid firing at Post 1 (3s)...", 1.5, "warning")
    rapidFireNearby(50, 3) -- 50 radius, 3 seconds
    notify("Post 1", "Done firing at Post 1.", 1.5, "success")

    -- =====================================================================
    -- STEP 3: Post 2 & Rapid Fire
    -- =====================================================================
    task.wait(0.5)
    notify("C4 Part 2", "Tweening to Post 2...", 1.5, "info")
    tweenTo(CFrame.new(-4131.794, 106.991, 2557.087), 1)
    
    notify("Rapid Fire", "Rapid firing at Post 2 (3s)...", 1.5, "warning")
    rapidFireNearby(50, 3) -- 50 radius, 3 seconds
    notify("Post 2", "Done firing at Post 2.", 1.5, "success")

    notify("C4 Complete", "All posts nuked with Rapid Fire!", 3, "success")
end)




-- ====================================================================
-- VHS GLITCH BLOCKER (S4Tab)
-- ====================================================================
S4Tab.createToggle("Disable VHS Glitch", "Blocks VHS_effect from showing while toggle is ON", function(state)
    _G.DisableVHSActive = state

    if state then
        notify("Success", "VHS Blocker: ON", 2, "success")

        -- Simulan ang monitor loop
        task.spawn(function()
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            
            while _G.DisableVHSActive do
                -- Check kung naka-open/naka-enable ang VHS_effect
                if playerGui then
                    local vhs = playerGui:FindFirstChild("VHS_effect")
                    if vhs and vhs:IsA("ScreenGui") and vhs.Enabled == true then
                        vhs.Enabled = false -- I-disable agad
                    end
                end
                task.wait(0.5) -- Check kada kalahating segundo
            end
        end)
    else
        -- WALANG GAGAWIN SA GUI. Hahayaan lang siyang mag-open kung gusto niya.
        notify("Info", "VHS Blocker: OFF", 2, "info")
    end
end)

S4Tab.createToggle("ESP BoulderSeal", "ESP Model: Section4.Lab.Floor1.Objective2.C4Explode.BoulderSeal", function(state)
    _G.BoulderESP_Active = state
    local container = getContainer("IOHUB_Boulder_ESP")
    local COLOR = Color3.fromRGB(255, 150, 0)

    local function getTarget()
        return Workspace:FindFirstChild("Section4")
            and Workspace.Section4:FindFirstChild("Lab")
            and Workspace.Section4.Lab:FindFirstChild("Floor1")
            and Workspace.Section4.Lab.Floor1:FindFirstChild("Objective2")
            and Workspace.Section4.Lab.Floor1.Objective2:FindFirstChild("C4Explode")
            and Workspace.Section4.Lab.Floor1.Objective2.C4Explode:FindFirstChild("BoulderSeal")
    end

    if state then
        addESPModel(getTarget(), container, COLOR)

        task.spawn(function()
            while _G.BoulderESP_Active do
                task.wait(1)
                if not _G.BoulderESP_Active then break end
                addESPModel(getTarget(), container, COLOR)
            end
        end)

        notify("Success", "BoulderSeal ESP: ON", 2, "success")
    else
        removeESPFromModel(getTarget())
        container:ClearAllChildren()
        notify("Info", "BoulderSeal ESP: OFF", 2, "info")
    end
end)

-- ====================================================================
-- AUTO KILL MUKI (Section 4, 30 studs, no teleport)
-- ====================================================================
S4Tab.createToggle("Auto Kill Cave Gata", "Auto-fire Muki models within 30 studs", function(state)
    _G.MukiAutoFireActive = state

    if not state then
        notify("Info", "Muki Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer
    local DETECT_RADIUS = 1000

    notify("Success", "Muki Auto-Fire", 3, "success")

    task.spawn(function()
        while _G.MukiAutoFireActive do
            task.wait(0.1)
            if not _G.MukiAutoFireActive then break end

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                -- Path base sa request mo
                local mukiFolder = Workspace:FindFirstChild("Section4")
                    and Workspace.Section4:FindFirstChild("Lab")
                    and Workspace.Section4.Lab:FindFirstChild("Floor1")
                    and Workspace.Section4.Lab.Floor1:FindFirstChild("Objective2")
                    and Workspace.Section4.Lab.Floor1.Objective2:FindFirstChild("MukiSpawn")

                if mukiFolder then
                    for _, mukiObj in ipairs(mukiFolder:GetChildren()) do
                        if not _G.MukiAutoFireActive then break end

                        -- Targetin lang ang mga Models (Muki at Muki2), laktawan ang 'Ammo' folder
                        if mukiObj:IsA("Model") then
                            local hitbox = mukiObj:FindFirstChild("Hitbox")
                                or mukiObj:FindFirstChildWhichIsA("BasePart", true)

                            if hitbox then
                                local dist = (hitbox.Position - hrp.Position).Magnitude

                                if dist <= DETECT_RADIUS then
                                    -- Hanapin ang RemoteEvent sa loob ng Muki at i-fire
                                    local remote = mukiObj:FindFirstChild("RemoteEvent")
                                    
                                    if remote then
                                        pcall(function()
                                            remote:FireServer()
                                            remote:FireServer("Damage", 100)
                                            remote:FireServer("Kill")
                                            remote:FireServer(true)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)




S4Tab.createCustomButton("Exit to Leave Area", "Teleports to checkpoint, tweens to final exit", function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if not character or not character.Parent then return end

    -- Helper Function para sa smooth tween
    local function tweenCharacter(targetCFrame, duration, char)
        local tweenCFrame = Instance.new("CFrameValue")
        tweenCFrame.Value = char:GetPivot()
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(tweenCFrame, tweenInfo, {Value = targetCFrame})
        
        local connection
        connection = tweenCFrame:GetPropertyChangedSignal("Value"):Connect(function()
            if char and char.Parent then
                char:PivotTo(tweenCFrame.Value)
            end
        end)
        
        tween:Play()
        tween.Completed:Wait()
        
        connection:Disconnect()
        tweenCFrame:Destroy()
    end

    -- Mga Coordinates
    local firstCFrame = CFrame.new(-3399.695, -296.495, 4288.083)
    local secondCFrame = CFrame.new(-3361.422, -300.115, 4517.947)

    -- =====================================================================
    -- STEP 1: Teleport sa Checkpoint
    -- =====================================================================
    notify("Leave Area", "Teleporting to Checkpoint...", 2, "info")
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    task.wait(0.05)
    
    character:PivotTo(firstCFrame)
    task.wait(0.5) -- Hintayin mag-settle sa server

    -- =====================================================================
    -- STEP 2: Tween (Simulated Walk) papunta sa Final Exit
    -- =====================================================================
    notify("Leave Area", "Simulating Walk (3 seconds)...", 2, "warning")
    
    -- 3 seconds na smooth na pag-slide (Tween)
    tweenCharacter(secondCFrame, 3, character)

    -- =====================================================================
    -- STEP 3: Failsafe at Finish
    -- =====================================================================
    task.wait(0.2)
    if character and character.Parent then
        character:PivotTo(secondCFrame)
    end

    notify("Leave Area", "Successfully left the area!", 3, "success")
end)



S4LabTab.createToggle("HogoGuntai Esp X SafeZone", "ESP & Auto Safespot for HogoGuntai", function(state)
    _G.HogoGuntaiESP_Active = state
    local container = getContainer("IOHUB_HogoGuntai_ESP")
    local COLOR = Color3.fromRGB(255, 0, 0)
    
    local player = game:GetService("Players").LocalPlayer

    -- Function para hanapin si HogoGuntai
    local function getTarget()
        return Workspace:FindFirstChild("Section4")
            and Workspace.Section4:FindFirstChild("Monster")
            and Workspace.Section4.Monster:FindFirstChild("HogoGuntai")
    end

    if state then
        -- 1. Initial ESP Application
        addESPModel(getTarget(), container, COLOR)

        -- 2. ESP Refresh Loop
        task.spawn(function()
            while _G.HogoGuntaiESP_Active do
                task.wait(1)
                if not _G.HogoGuntaiESP_Active then break end
                addESPModel(getTarget(), container, COLOR)
            end
        end)

        -- 3. AUTO SAFESPOT RADAR LOOP
        task.spawn(function()
            -- Ito yung 2nd CFrame galing sa Leave button mo
            local safeSpotCFrame = CFrame.new(-3361.422, -300.115, 4517.947)
            local safetyDistanceThreshold = 25 -- 25 studs radius

            while _G.HogoGuntaiESP_Active do
                task.wait(0.15)
                
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                local target = getTarget()
                
                if target and hrp then
                    -- Hanapin kung saan pwedeng i-base yung distance (Hitbox, HRP, o kahit anong BasePart)
                    local targetPart = target:FindFirstChild("HumanoidRootPart") 
                        or target:FindFirstChild("Hitbox") 
                        or target:FindFirstChildWhichIsA("BasePart", true)
                    
                    if targetPart then
                        local distance = (hrp.Position - targetPart.Position).Magnitude
                        
                        -- Kapag lumapit sa loob ng 25 studs
                        if distance <= safetyDistanceThreshold then
                            notify("🚨 DANGER DETECTED", "HogoGuntai is within " .. math.floor(distance) .. " studs! Teleporting to SafeSpot!", 3, "error")
                            
                            -- Safe Teleport (PivotTo + Jump State)
                            if character:FindFirstChild("Humanoid") then
                                pcall(function() 
                                    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) 
                                end)
                            end
                            task.wait(0.05)
                            
                            character:PivotTo(safeSpotCFrame)
                            
                            -- 2.5 seconds na cooldown para hindi mag-spam ang teleport kung nandun pa rin siya
                            task.wait(2.5) 
                        end
                    end
                end
            end
        end)

        notify("Success", "HogoGuntai ESP & Safespot: ON", 2, "success")
    else
        -- Kapag pinatay yung toggle, linisin lahat
        removeESPFromModel(getTarget())
        container:ClearAllChildren()
        notify("Info", "HogoGuntai ESP & Safespot: OFF", 2, "info")
    end
end)

S4LabTab.createToggle("ESP Valves", "ESP Folder: Section4.Lab.CleanseRoomObjective.Valves", function(state)
    _G.ValvesESP_Active = state
    local container = getContainer("IOHUB_Valves_ESP")
    local COLOR = Color3.fromRGB(0, 255, 0)

    local function getTarget()
        return Workspace:FindFirstChild("Section4")
            and Workspace.Section4:FindFirstChild("Lab")
            and Workspace.Section4.Lab:FindFirstChild("CleanseRoomObjective")
            and Workspace.Section4.Lab.CleanseRoomObjective:FindFirstChild("Valves")
    end

    if state then
        addESPFolder(getTarget(), container, COLOR)

        task.spawn(function()
            while _G.ValvesESP_Active do
                task.wait(1)
                if not _G.ValvesESP_Active then break end
                addESPFolder(getTarget(), container, COLOR)
            end
        end)

        notify("Success", "Valves ESP: ON", 2, "success")
    else
        removeESPFromFolder(getTarget())
        container:ClearAllChildren()
        notify("Info", "Valves ESP: OFF", 2, "info")
    end
end)


S4LabTab.createToggle("ESP ShapeTerminals", "ESP Folder: Section4.Lab.CleanseRoomObjective.ShapeTerminals", function(state)
    _G.TerminalsESP_Active = state
    local container = getContainer("IOHUB_Terminals_ESP")
    local COLOR = Color3.fromRGB(0, 180, 255)

    local function getTarget()
        return Workspace:FindFirstChild("Section4")
            and Workspace.Section4:FindFirstChild("Lab")
            and Workspace.Section4.Lab:FindFirstChild("CleanseRoomObjective")
            and Workspace.Section4.Lab.CleanseRoomObjective:FindFirstChild("ShapeTerminals")
    end

    if state then
        addESPFolder(getTarget(), container, COLOR)

        task.spawn(function()
            while _G.TerminalsESP_Active do
                task.wait(1)
                if not _G.TerminalsESP_Active then break end
                addESPFolder(getTarget(), container, COLOR)
            end
        end)

        notify("Success", "ShapeTerminals ESP: ON", 2, "success")
    else
        removeESPFromFolder(getTarget())
        container:ClearAllChildren()
        notify("Info", "ShapeTerminals ESP: OFF", 2, "info")
    end
end) 


-- ====================================================================
-- AUTO KILL HOGO (S1Tab Version)
-- ====================================================================
S4LabTab.createToggle("Auto Shoot Hogo", "Auto-fire HogoGuntai GunHitboxes (Section 4)", function(state)
    _G.HogoAutoActive = state

    if not state then
        notify("Info", "Hogo Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer

    notify("Success", "Hogo Auto-Fire: ON", 3, "success")

    task.spawn(function()
        while _G.HogoAutoActive do
            task.wait(0.1)
            if not _G.HogoAutoActive then break end

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                local section4 = Workspace:FindFirstChild("Section4")
                local monster = section4 and section4:FindFirstChild("Monster")
                local hogo = monster and monster:FindFirstChild("HogoGuntai")
                
                if hogo then
                    local gunHitboxes = hogo:FindFirstChild("GunHitboxes")
                    if gunHitboxes then
                        -- I-loop lahat ng parts (kasama ang [2], [3], [4], Hitbox)
                        for _, hitbox in ipairs(gunHitboxes:GetChildren()) do
                            if not _G.HogoAutoActive then break end
                            
                            local remote = hitbox:FindFirstChild("RemoteEvent")
                            if remote and remote:IsA("RemoteEvent") then
                                pcall(function()
                                    remote:FireServer()
                                    remote:FireServer("Damage", 100)
                                    remote:FireServer("Kill")
                                    remote:FireServer(true)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end)


S4LabTab.createCustomButton("Lockdown Skill Check Hit", "", function()
    fireReliable("Section4/LockdownSkillCheckHit", "Lockdown Skill Check Hit")
    notify("Success", "Lockdown Skill Check Hit", 2, "success")
end)


S5QuickTab.createCustomButton("Main Switch & Fix WireBox", "Teleport, switch ON, fix boxes, switch OFF/Complete", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    if not character or not character.Parent then return end

    local function safeFirePrompt(prompt)
        if not prompt then return false end
        pcall(function()
            local originalRequiresLineOfSight = prompt.RequiresLineOfSight
            local originalMaxDistance = prompt.MaxActivationDistance
            
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 50
            task.wait(0.05)
            
            fireproximityprompt(prompt)
            
            prompt.RequiresLineOfSight = originalRequiresLineOfSight
            prompt.MaxActivationDistance = originalMaxDistance
        end)
        return true
    end

    -- Get Cobalt Event
    local CobaltEvent = ReplicatedStorage:FindFirstChild("modules")
        and ReplicatedStorage.modules:FindFirstChild("Packet")
        and ReplicatedStorage.modules.Packet:FindFirstChild("Reliable")

    if not CobaltEvent then
        notify("Critical Error", "Cobalt Packet route not found!", 4, "error")
        return
    end

    -- Variable para i-cache natin yung prompt para magamit sa Step 1 at Step 3
    local cachedSwitchPrompt = nil

    -- =====================================================================
    -- STEP 1: Teleport AND Fire Main Switch (Turn On)
    -- =====================================================================
    notify("Stage 1/3", "Teleporting & Triggering Main Switch...", 2, "info")
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    task.wait(0.01)
    
    local switchCFrame = CFrame.new(-2037.31445, -353.530029, 4641.99805)
    character:PivotTo(switchCFrame)
    task.wait(0.3) -- Hintayin mag-load ang paligid

    local powerSwitchModel = Workspace:FindFirstChild("Section5")
        and Workspace.Section5:FindFirstChild("MainObjective")
        and Workspace.Section5.MainObjective:FindFirstChild("PowerSwitch")

    if powerSwitchModel then
        cachedSwitchPrompt = powerSwitchModel:FindFirstChild("RootPart")
            and powerSwitchModel.RootPart:FindFirstChildOfClass("ProximityPrompt")
            or powerSwitchModel:FindFirstChildWhichIsA("ProximityPrompt", true)

        if cachedSwitchPrompt then
            safeFirePrompt(cachedSwitchPrompt)
            notify("Switch ON", "Main Switch fired! Waiting 1 second...", 1.5, "success")
        else
            notify("Warning", "Switch prompt not found!", 3, "warning")
        end
    else
        notify("Error", "PowerSwitch path not found!", 3, "error")
    end

    task.wait(1.0) -- [BAGONG DAGDAG] Eksaktong 1 segundo na paghihintay

    -- =====================================================================
    -- STEP 2: Fix All WireBoxes Silently
    -- =====================================================================
    notify("Stage 2/3", "Bypassing all WireBoxes silently...", 2, "info")
    
    local boxesFolder = Workspace:FindFirstChild("Section5")
        and Workspace.Section5:FindFirstChild("MainObjective")
        and Workspace.Section5.MainObjective:FindFirstChild("Boxes")

    if boxesFolder then
        local wireBoxesList = boxesFolder:GetChildren()
        
        for index, targetBox in ipairs(wireBoxesList) do
            if targetBox.Name == "WireBox" or targetBox:IsA("Model") then
                pcall(function()
                    CobaltEvent:FireServer("Section5/WireBoxClaim", targetBox)
                    CobaltEvent:FireServer("Section5/WireBoxComplete", targetBox)
                    CobaltEvent:FireServer("Section5/WireBoxRelease", targetBox)
                end)
                
            end
        end
        notify("WireBoxes", "All WireBoxes fixed!", 2, "success")
    else
        notify("Warning", "Boxes folder not found!", 3, "warning")
    end

    task.wait(0.5) -- [BAGONG DAGDAG] Eksaktong 0.5 segundo na paghihintay

    -- =====================================================================
    -- STEP 3: Fire Main Switch Again (Complete)
    -- =====================================================================
    notify("Stage 3/3", "Firing Main Switch again to complete...", 2, "info")
    
    if cachedSwitchPrompt and cachedSwitchPrompt.Parent then
        safeFirePrompt(cachedSwitchPrompt)
        notify("Success", "Main Switch sequence fully completed!", 3, "success")
    else
        -- Fallback kung sakaling nawala yung cached prompt, hahanapin natin ulit
        local finalSwitchPrompt = powerSwitchModel and powerSwitchModel:FindFirstChildWhichIsA("ProximityPrompt", true)
        if finalSwitchPrompt then
            safeFirePrompt(finalSwitchPrompt)
            notify("Success", "Main Switch sequence completed (fallback)!", 3, "success")
        else
            notify("Error", "Failed to fire Main Switch again!", 3, "error")
        end
    end
end)

-- ====================================================================
-- AUTO KILL FLESHBLOCK (Gamit ang S1Tab UI)
-- ====================================================================
S5DSTab.createToggle("Auto Shoot FleshBlock", "Auto-fire FleshBlock/Block sa buong Workspace", function(state)
    _G.FleshBlockAutoActive = state

    if not state then
        notify("Info", "FleshBlock Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer

    notify("Success", "FleshBlock Auto-Fire: ON", 3, "success")

    task.spawn(function()
        while _G.FleshBlockAutoActive do
            task.wait(0.1)
            if not _G.FleshBlockAutoActive then break end

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Iscan ang Workspace para sa Block/FleshBlock
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not _G.FleshBlockAutoActive then break end
                    
                    if (obj.Name == "Block" or obj.Name == "FleshBlock") and obj:IsA("Model") then
                        local body = obj:FindFirstChild("body")
                        
                        if body then
                            local remote = body:FindFirstChildOfClass("RemoteEvent")
                            
                            if remote then
                                pcall(function()
                                    remote:FireServer()
                                    remote:FireServer("Damage", 100)
                                    remote:FireServer("Kill")
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end)


-- ====================================================================
-- AUTO KILL MUKI / HOGOGUNTAI (Gamit ang S1Tab UI)
-- ====================================================================
S5DSTab.createToggle("Auto Shoot Muki", "Auto-fire HogoGuntai / Monster", function(state)
    _G.MukiAutoActive = state

    if not state then
        notify("Info", "Muki Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer

    notify("Success", "Muki Auto-Fire: ON", 3, "success")

    task.spawn(function()
        while _G.MukiAutoActive do
            task.wait(0.1)
            if not _G.MukiAutoActive then break end

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Hanapin ang Monster folder sa Workspace (kahit saan)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not _G.MukiAutoActive then break end
                    
                    -- Kung HogoGuntai ang pangalan o nasa loob ng Monster folder
                    if obj.Name == "HogoGuntai" or (obj.Name == "Monster" and obj:IsA("Folder")) then
                        local remote = obj:FindFirstChildOfClass("RemoteEvent") 
                            or obj:FindFirstChildWhichIsA("RemoteEvent", true)
                        
                        if remote then
                            pcall(function()
                                remote:FireServer()
                                remote:FireServer("Damage", 100)
                                remote:FireServer("Kill")
                            end)
                        end
                    end
                end
            end
        end
    end)
end) 




S5StairsTab.createToggle("ESP Baigai", "Highlight Section5.Monster.Baigai", function(state)
    _G.BaigaiESP_Active = state
    local CoreGui = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")
    
    local container = CoreGui:FindFirstChild("IOHUB_Baigai_ESP")
    if not container then
        container = Instance.new("Folder")
        container.Name = "IOHUB_Baigai_ESP"
        container.Parent = CoreGui
    end

    local function addESPModel(model, container, color)
        if not model or not container then return end
        color = color or Color3.fromRGB(180, 0, 255)
        
        if not (model:IsA("Model") or model:IsA("BasePart")) then return end

        -- Highlight
        if not model:FindFirstChild("IOHUB_Baigai_HL") then
            local hl = Instance.new("Highlight")
            hl.Name = "IOHUB_Baigai_HL"
            hl.FillColor = color
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.Parent = model
        end

        -- Anchor para sa Name
        local anchor = model:IsA("BasePart") and model or (model.PrimaryPart or model:FindFirstChild("Hitbox") or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart"))
        
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
                bb.ExtentsOffset = Vector3.new(0, 3, 0)
                bb.Adornee = anchor
                bb.Parent = container

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = "Baigai"
                lbl.TextColor3 = color
                lbl.TextSize = 16
                lbl.Font = Enum.Font.SourceSansBold
                lbl.TextStrokeTransparency = 0
                lbl.Parent = bb
            end
        end
    end

    local function getTarget()
        return Workspace:FindFirstChild("Section5")
            and Workspace.Section5:FindFirstChild("Monster")
            and Workspace.Section5.Monster:FindFirstChild("Baigai")
    end

    if state then
        addESPModel(getTarget(), container, Color3.fromRGB(180, 0, 255))
        
        task.spawn(function()
            while _G.BaigaiESP_Active do
                task.wait(1)
                if not _G.BaigaiESP_Active then break end
                addESPModel(getTarget(), container, Color3.fromRGB(180, 0, 255))
            end
        end)
        
        notify("Success", "Baigai ESP: ON", 2, "success")
    else
        local target = getTarget()
        if target then
            local hl = target:FindFirstChild("IOHUB_Baigai_HL")
            if hl then pcall(function() hl:Destroy() end) end
        end
        container:ClearAllChildren()
        notify("Info", "Baigai ESP: OFF", 2, "info")
    end
end)


-- ====================================================================
-- ESP WIREBOX TOGGLE
-- ====================================================================
S5StairsTab.createToggle("ESP Wireboxes", "Toggle Visual Highlights for Wireboxes", function(state)
    _G.WireboxesEspEnabled = state

    -- Helper para sa paglilinis para hindi paulit-ulit ang code
    local function clearWireboxESP()
        local boxesFolder = workspace:FindFirstChild("Section5")
            and workspace.Section5:FindFirstChild("MainObjective")
            and workspace.Section5.MainObjective:FindFirstChild("Boxes")

        if boxesFolder then
            for _, boxObj in ipairs(boxesFolder:GetChildren()) do
                local hl = boxObj:FindFirstChild("WireBox_Highlight")
                if hl then pcall(function() hl:Destroy() end) end
                
                -- Linisin din ang billboard name tag kung meron
                local bb = boxObj:FindFirstChild("WireBox_Name")
                if bb then pcall(function() bb:Destroy() end) end
            end
        end
    end

    if state then
        notify("Success", "Wireboxes ESP: ON", 2, "success")

        task.spawn(function()
            while _G.WireboxesEspEnabled do
                local boxesFolder = workspace:FindFirstChild("Section5")
                    and workspace.Section5:FindFirstChild("MainObjective")
                    and workspace.Section5.MainObjective:FindFirstChild("Boxes")
                    
                if boxesFolder then
                    for _, boxObj in ipairs(boxesFolder:GetChildren()) do
                        if boxObj.Name == "WireBox" or boxObj:IsA("Model") then
                            -- 1. Highlight (Asul)
                            if not boxObj:FindFirstChild("WireBox_Highlight") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "WireBox_Highlight"
                                highlight.Adornee = boxObj
                                highlight.FillColor = Color3.fromRGB(0, 150, 255)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.Parent = boxObj
                            end

                            -- 2. Name Tag (Billboard)
                            local anchor = boxObj.PrimaryPart or boxObj:FindFirstChildWhichIsA("BasePart")
                            if anchor and not boxObj:FindFirstChild("WireBox_Name") then
                                local bb = Instance.new("BillboardGui")
                                bb.Name = "WireBox_Name"
                                bb.Size = UDim2.new(0, 100, 0, 24)
                                bb.AlwaysOnTop = true
                                bb.ExtentsOffset = Vector3.new(0, 2, 0)
                                bb.Adornee = anchor
                                bb.Parent = boxObj

                                local lbl = Instance.new("TextLabel")
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Text = "WireBox"
                                lbl.TextColor3 = Color3.fromRGB(0, 150, 255)
                                lbl.TextSize = 14
                                lbl.Font = Enum.Font.SourceSansBold
                                lbl.TextStrokeTransparency = 0
                                lbl.Parent = bb
                            end
                        end
                    end
                end
                task.wait(1) -- I-refresh kada 1 segundo
            end
        end)
    else
        -- Agad na linisin pagka-OFF
        clearWireboxESP()
        notify("Info", "Wireboxes ESP: OFF", 2, "info")
    end
end)


 -- ====================================================================
-- AUTO STAMINA BOOST (MainTab)
-- ====================================================================
local autoStaminaActive = false

GamePlayTab.createToggle("Auto Stamina Boost", "Continuously boosts stamina while ON", function(state)
    autoStaminaActive = state

    if not state then
        notify("Info", "Auto Stamina Boost: OFF", 2, "info")
        return
    end

    notify("Success", "Auto Stamina Boost: ON", 2, "success")

    task.spawn(function()
        while autoStaminaActive do
            local ok, err = pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                local modules = RS:FindFirstChild("modules")
                local packet = modules and modules:FindFirstChild("Packet")
                local reliable = packet and packet:FindFirstChild("Reliable")

                if reliable then
                    -- Ginagamit natin ang firesignal base sa Cobalt code mo
                    firesignal(reliable.OnClientEvent, "Section1/StaminaBoost")
                    
                    -- NOTE: Kung hindi gumagana ang firesignal sa live game, 
                    -- palitan mo ito ng: reliable:FireServer("Section1/StaminaBoost")
                else
                    error("Reliable Event not found!")
                end
            end)

            -- Kung may error (tulad ng nawala yung Reliable), i-off na agad
            if not ok and autoStaminaActive then
                notify("Error", "Stamina Error: " .. tostring(err), 3, "error")
                autoStaminaActive = false
                break
            end

            task.wait(1) -- Mag-bo-boost kada 1 segundo
        end
    end)
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

-- [FIXED] Direct API Fetch para makuha ang tamang pangalan (The Mimic, etc.)
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
        
        -- ✅ PINALIT: Pinaliit ang padding sa 4 (dating 6)
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

        -- ✅ BAGO: Auto-detect kung Image ID/URL ang tinype sa textbox
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

-- BAGONG DAGDAG: Main Gradient
local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
})
mainGrad.Rotation = 90
mainGrad.Parent = main

-- ❌ TINANGGAL NATIN YUNG AddBorder(main, ...) para hindi na lumabas yung makapal na border sa gilid

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







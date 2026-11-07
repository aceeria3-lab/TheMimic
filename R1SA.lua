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


----------------------------------------------------
-- ICON LOADER
----------------------------------------------------
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

----------------------------------------------------
-- MAIN SCREEN GUI
----------------------------------------------------
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



----------------------------------------------------
-- MAIN CONTAINER WINDOW
----------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 350)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Pure Dark/Black
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

----------------------------------------------------
-- FLOATING TOGGLE IMAGE BUTTON
----------------------------------------------------
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "MenuToggleButton"
toggleButton.Size = UDim2.new(0, 68, 0, 68)
toggleButton.Position = UDim2.new(0, 20, 0.5, -34)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://139934599708171"
toggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Active = true
toggleButton.Parent = screenGui

----------------------------------------------------
-- DRAGGING FEATURE
----------------------------------------------------
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

----------------------------------------------------
-- TOP WINDOW CONTROL DOTS
----------------------------------------------------
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
-- TOGGLE LOGIC
----------------------------------------------------
local isMenuOpen = false
local isTweening = false

local function minimizeToButton()
    if isTweening then return end
    isTweening = true

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

toggleButton.MouseButton1Click:Connect(function()
    if isMenuOpen then minimizeToButton() else openMenu() end
end)

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
-- GINAWANG ScrollingFrame ANG SIDEBAR PARA MA-SCROLL
local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, -70) -- Inayos ang height para pantay sa content
sidebar.Position = UDim2.new(0, 10, 0, 50) -- Inayos ang Y pos para pantay sa content
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

-- AUTO-UPDATE CANVAS SIZE PARA MAKAPAG-SCROLL
uiListSide:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sidebar.CanvasSize = UDim2.new(0, 0, 0, uiListSide.AbsoluteContentSize.Y)
end)

-- INAYOS ANG CONTENT FRAME PARA TUMPAK SA SIDEBAR
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -190, 1, -70) -- Binagay ang height at lapad
contentFrame.Position = UDim2.new(0, 180, 0, 50) -- Binagay ang Y pos (50)
contentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
contentFrame.BackgroundTransparency = 0.4
contentFrame.Parent = mainFrame

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
            btnElements.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            if btnElements.Stroke then btnElements.Stroke.Enabled = true end
            pages[name].Visible = true
        else
            btnElements.Button.BackgroundTransparency = 1
            btnElements.Icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
            btnElements.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            if btnElements.Stroke then btnElements.Stroke.Enabled = false end
            pages[name].Visible = false
        end
    end
    activeTab = tabName
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


----------------------------------------------------
-- CUSTOM TOP RIGHT NOTIFICATION SYSTEM (Black Theme)
----------------------------------------------------
local TweenService = TweenService or game:GetService("TweenService")

-- Icon + color preset per notification type
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
    warning = {
        image     = getIcon("warning") or "rbxassetid://10734898355",
        iconColor = Color3.fromRGB(255, 200, 80),
        boxColor  = Color3.fromRGB(45, 38, 20),
        barColor  = Color3.fromRGB(255, 200, 80),
    },
    info = {
        image     = getIcon("info") or "rbxassetid://10734896206",
        iconColor = Color3.fromRGB(100, 180, 255),
        boxColor  = Color3.fromRGB(20, 30, 45),
        barColor  = Color3.fromRGB(100, 180, 255),
    },
}

-- Auto-detect type mula sa title + subtitle, o explicit override
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

    -- Icon Box (color depende sa type)
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

    -- Title
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

    -- Subtitle
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

    -- Progress Bar
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

    -- Slide in
    notif.Position = UDim2.new(0, 300, 0, 0)
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(barFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    -- Fade out (kasama na icon + bar para malinis)
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


----------------------------------------------------
-- CUSTOM ACTION BUTTON
----------------------------------------------------
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
    
    -- Hover Effect
    actionBtn.MouseEnter:Connect(function()
        TweenService:Create(actionBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
    end)
    actionBtn.MouseLeave:Connect(function()
        TweenService:Create(actionBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)

    actionBtn.Parent = targetPage
    return actionBtn
end

----------------------------------------------------
-- CUSTOM TOGGLE
----------------------------------------------------
local function createneToggle(pageName, title, description, callback, customParent)
    local targetPage = customParent or pages[pageName]
    if not targetPage then return end

    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 40) 
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Dark gray
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

----------------------------------------------------
-- NEW SLIDER
----------------------------------------------------
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
    container.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- Darker container
    container.BackgroundTransparency = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local function createCube(posX, cfg)
        local cube = Instance.new("Frame")
        cube.Size = UDim2.new(0.48, 0, 1, -10)
        cube.Position = UDim2.new(posX, 0, 0, 5)
        cube.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Dark gray
        cube.BorderSizePixel = 0
        cube.Parent = container
        Instance.new("UICorner", cube).CornerRadius = UDim.new(0, 6)
        
        local ib = Instance.new("Frame")
        ib.Size = UDim2.new(0, 36, 0, 36)
        ib.Position = UDim2.new(0, 10, 0.5, -18)
        ib.BackgroundTransparency = 1 
        ib.Parent = cube
        
        local ic = Instance.new("ImageLabel")
        ic.Size = UDim2.new(0, 28, 0, 28)
        ic.Position = UDim2.new(0.5, -14, 0.5, -14)
        ic.BackgroundTransparency = 1
        ic.Image = cfg.Icon or ""
        ic.Parent = ib
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, -55, 0, 14)
        tl.Position = UDim2.new(0, 55, 0, 10)
        tl.BackgroundTransparency = 1
        tl.Text = cfg.Label or ""
        tl.TextColor3 = Color3.fromRGB(160, 170, 180)
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 11
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.Parent = cube
        
        local vl = Instance.new("TextLabel")
        vl.Size = UDim2.new(1, -55, 0, 20)
        vl.Position = UDim2.new(0, 55, 0, 26)
        vl.BackgroundTransparency = 1
        vl.Text = "0"
        vl.TextColor3 = Color3.fromRGB(255, 255, 255)
        vl.Font = Enum.Font.GothamBold
        vl.TextSize = 16
        vl.TextXAlignment = Enum.TextXAlignment.Left
        vl.Parent = cube
        return vl
    end

    local leftVal = createCube(0.01, opts.Left or {})
    local rightVal = createCube(0.51, opts.Right or {})

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


local function CreateHeaderDropdown(pageName, title, iconName)
    return function(HD)
        local targetPage = pages[pageName]
        if not targetPage then return end

        local container = Instance.new("Frame")
        container.Name = title .. "DropdownGroup"
        container.Size = UDim2.new(1, 0, 0, 0)
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Very dark black
        container.BackgroundTransparency = 0
        container.Parent = targetPage

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = container

        local containerStroke = Instance.new("UIStroke")
        containerStroke.Color = Color3.fromRGB(40, 40, 40) -- Dark gray stroke
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
        end)

        local function createDivider()
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 1)
            div.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark divider
            div.BackgroundTransparency = 0.5
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

        -- Palitan ito sa loob ng HD.createDropdown:
local overlay = Instance.new("TextButton")
overlay.Name = "DropdownOverlay"
-- ITO ANG BINAGO (Pantay na sa contentFrame):
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

-- Palitan din ito para mag-slide siya papasok sa tamang pwesto:
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
            createneToggle(pageName, t, d, c, contentArea)
        end
        
        HD.createCustomButton = function(t, d, c, isLocked)
            createDivider()
            createCustomButton(pageName, t, d, c, isLocked, contentArea)
        end
        
        HD.createDoubleCube = function(opts)
            createDivider()
            createDoubleCubeUI(contentArea, opts)
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



-- ====================================================================
-- ESP HELPERS
-- ====================================================================
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

    -- Highlight
    if not model:FindFirstChild("IOHUB_ESP_HL") then
        local hl = Instance.new("Highlight")
        hl.Name = "IOHUB_ESP_HL"
        hl.FillColor = color
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.Parent = model
    end

    -- Anchor para sa name billboard
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
        -- Dedup check by Adornee
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





-- Gumawa ng bagong tab para sa testing
createSidebarTab("Main", "test-tube")


-- Gumawa ng bagong tab para sa testing
createSidebarTab("Section 1", "test-tube")


-- Gumawa ng bagong tab para sa testing
createSidebarTab("Section 2", "test-tube")

-- Gumawa ng bagong tab para sa testing
createSidebarTab("Section 3", "test-tube")

-- Gumawa ng bagong tab para sa testing
createSidebarTab("Section 4", "test-tube")

-- Gumawa ng bagong tab para sa testing
createSidebarTab("Section 5", "test-tube")


local MainTab = {}
CreateHeaderDropdown("Main", "Egao", "layout")(MainTab)


local YenTab = {}
CreateHeaderDropdown("Main", "Yen", "layout")(YenTab)

local S1Tab = {}
CreateHeaderDropdown("Section 1", "The Neighborhood", "layout")(S1Tab)

local TestTab = {}
CreateHeaderDropdown("Section 2", "The School", "layout")(TestTab)

local S3Tab = {}
CreateHeaderDropdown("Section 3", "The Forest", "layout")(S3Tab)


local S4Tab = {}
CreateHeaderDropdown("Section 4", "Sector E-7 Cave", "layout")(S4Tab)

local S4LabTab = {}
CreateHeaderDropdown("Section 4", "Sector E-7 Lab", "layout")(S4LabTab)

local S5StairsTab = {}
CreateHeaderDropdown("Section 5", "Sector E-7 Basement", "layout")(S5StairsTab)



--[[ 

TestTab.createCustomButton("Grab Bandage", "", function()
    local prompt = workspace:FindFirstChild("Section2")
         and workspace.Section2:FindFirstChild("Items")
         and workspace.Section2.Items:FindFirstChild("Bandage")
         and workspace.Section2.Items.Bandage:FindFirstChild("Handle")
         and workspace.Section2.Items.Bandage.Handle:FindFirstChildOfClass("ProximityPrompt")
           firePrompt(prompt, "Bandage Prompt")
 end)

 --]]



-- 3) Bandage Picked Up
TestTab.createCustomButton("Bandage Picked Up", "", function()
    fireReliable("Section2/BandagePickedUp", "Bandage Picked Up")
    notify("Success", "Bandage Picked Up sent", 2, "success")
end)


-- Hideo Healed
TestTab.createCustomButton("Hideo Healed", "", function()
    fireReliable("Section2/HideoHealed", "Hideo Healed")
end)




TestTab.createToggle("Auto Bypass RoomDoor", "Auto-fire nearby doors within 12 studs", function(state)
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
-- UNIFIED ESP: ALL AKARI VERSIONS (NORMAL & NIGHTMARE)
-- ====================================================================
local CoreGui   = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Players   = game:GetService("Players")

local player = Players.LocalPlayer
local akariConnection = nil

TestTab.createToggle("Akari & Akari(Rage) Esp", "Show ESP Name Location of Monster", function(state)
    local espContainer = CoreGui:FindFirstChild("IOHUB_AkariUnifiedContainer")
    if not espContainer then
        espContainer = Instance.new("Folder")
        espContainer.Name = "IOHUB_AkariUnifiedContainer"
        espContainer.Parent = CoreGui
    end

    local function applyModelESP(model, isRage, isNightmare)
        if not model or not model:IsA("Model") then return end

        local tagIdentifier = "AkariESP_" .. model.Name .. "_" .. tostring(model:GetPivot().Position)
        if espContainer:FindFirstChild(tagIdentifier) then return end

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

        local targetPart = model:FindFirstChild("Hitbox")
            or model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChildWhichIsA("BasePart")
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
            if isNightmare and isRage then
                displayName = "Akari (Nightmare Rage)"
            elseif isNightmare then
                displayName = "Akari (Nightmare)"
            elseif isRage then
                displayName = "Akari (Rage)"
            else
                displayName = "Akari (Normal)"
            end

            label.Text = displayName
            label.TextColor3 = isRage and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 0, 100)
            label.TextSize = 20
            label.Font = Enum.Font.SourceSansBold
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.TextStrokeTransparency = 0
            label.Parent = billboard
        end
    end

    local function scanAkariFolders()
        local s2 = Workspace:FindFirstChild("Section2")
        if not s2 then return end

        local monsterFolder = s2:FindFirstChild("Monster")
        local rageFolder    = s2:FindFirstChild("Rage")

        local normalAkari     = monsterFolder and monsterFolder:FindFirstChild("Akari")
        local normalAkariRage = rageFolder    and rageFolder:FindFirstChild("AkariRage")
        local nmAkari         = monsterFolder and monsterFolder:FindFirstChild("AkariNM")
        local nmAkariRage     = rageFolder    and rageFolder:FindFirstChild("AkariRageNM")

        if normalAkari     and normalAkari:IsA("Model")     then applyModelESP(normalAkari,     false, false) end
        if normalAkariRage and normalAkariRage:IsA("Model") then applyModelESP(normalAkariRage, true,  false) end
        if nmAkari         and nmAkari:IsA("Model")         then applyModelESP(nmAkari,         false, true)  end
        if nmAkariRage     and nmAkariRage:IsA("Model")     then applyModelESP(nmAkariRage,     true,  true)  end
    end

    if state then
        scanAkariFolders()

        if not akariConnection then
            akariConnection = Workspace.DescendantAdded:Connect(function(descendant)
                task.spawn(function()
                    pcall(function()
                        if descendant:IsA("Model") then
                            if descendant.Name == "Akari"        then applyModelESP(descendant, false, false)
                            elseif descendant.Name == "AkariRage"  then applyModelESP(descendant, true,  false)
                            elseif descendant.Name == "AkariNM"    then applyModelESP(descendant, false, true)
                            elseif descendant.Name == "AkariRageNM" then applyModelESP(descendant, true,  true)
                            end
                        end
                    end)
                end)
            end)
        end

        notify("Success", "All Akari ESP: ON", 3, "success")
    else
        if akariConnection then
            akariConnection:Disconnect()
            akariConnection = nil
        end

        for _, desc in ipairs(Workspace:GetDescendants()) do
            if desc.Name == "AkariHighlight" then
                desc:Destroy()
            end
        end

        if espContainer then
            espContainer:ClearAllChildren()
        end

        notify("Info", "Akari ESP: OFF", 2, "info")
    end
end)


-- ====================================================================
-- ESP AKARI SPIDER TOGGLE
-- ====================================================================
TestTab.createToggle("ESP AkariSpider", "Toggle Visual Highlights for all AkariSpiders", function(state)
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


TestTab.createToggle("Auto AkariSpider", "Auto-fire spiders within 30 studs (no teleport)", function(state)
    _G.SpiderAutoFireActive = state

    if not state then
        notify("Info", "Spider Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer
    local DETECT_RADIUS = 30

    notify("Success", "Spider Auto-Fire", 3, "success")

    task.spawn(function()
        while _G.SpiderAutoFireActive do
            task.wait(0.1)
            if not _G.SpiderAutoFireActive then break end

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local spidersFolder = Workspace:FindFirstChild("Section2")
                    and Workspace.Section2:FindFirstChild("MAINOBJECTIVE2")
                    and Workspace.Section2.MAINOBJECTIVE2:FindFirstChild("Spiders")

                if spidersFolder then
                    for _, spiderObj in ipairs(spidersFolder:GetChildren()) do
                        if not _G.SpiderAutoFireActive then break end

                        if spiderObj:IsA("Model") then
                            local part = spiderObj:FindFirstChild("Hitbox")
                                or spiderObj:FindFirstChild("HumanoidRootPart")
                                or spiderObj:FindFirstChildWhichIsA("BasePart", true)

                            if part then
                                local dist = (part.Position - hrp.Position).Magnitude

                                if dist <= DETECT_RADIUS then
                                    -- RemoteEvent only
                                    for _, desc in ipairs(spiderObj:GetDescendants()) do
                                        if not _G.SpiderAutoFireActive then break end

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




S4LabTab.createToggle("ESP HogoGuntai", "ESP Model: Section4.Monster.HogoGuntai", function(state)
    _G.HogoGuntaiESP_Active = state
    local container = getContainer("IOHUB_HogoGuntai_ESP")
    local COLOR = Color3.fromRGB(255, 0, 0)

    local function getTarget()
        return Workspace:FindFirstChild("Section4")
            and Workspace.Section4:FindFirstChild("Monster")
            and Workspace.Section4.Monster:FindFirstChild("HogoGuntai")
    end

    if state then
        addESPModel(getTarget(), container, COLOR)

        task.spawn(function()
            while _G.HogoGuntaiESP_Active do
                task.wait(1)
                if not _G.HogoGuntaiESP_Active then break end
                addESPModel(getTarget(), container, COLOR)
            end
        end)

        notify("Success", "HogoGuntai ESP: ON", 2, "success")
    else
        removeESPFromModel(getTarget())
        container:ClearAllChildren()
        notify("Info", "HogoGuntai ESP: OFF", 2, "info")
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


--[[

-- 2. Locked Custom Button (Yung may lock icon)
TestTab.createCustomButton("Auto AkariSpider", "", function()
    -- Halimbawa:
notify("Locked", "Gorilla King got Spectral", 4)
end, true)


TestTab.createToggle("Test Toggle", "", function(state)


end)

-- 4. Slider
TestTab.createSlider("Test Slider", 0, 5000, 0, function(val)
    

end)

-- Example 1: Walang default na naka-select
TestTab.createDropdown("Pick to delete", {"Config 1", "Config 2", "Config 3"}, nil, function(selected)
    

end)

-- Example 2: May default na naka-select ("Forest Bat" at "JB Guitar")
TestTab.createDropdown("Use weapons", {"Forest Bat", "Cricket's Banjo", "JB Guitar", "Sword", "Bow"}, {"Forest Bat", "JB Guitar"}, function(selected)
    

end)

-- 6. Text Box
TestTab.createTextBox("Test TextBox", "Type here...", function(text)


end)

-- 7. Styled Buttons (Gold at Red)
TestTab.createStyledButton("Gold Button", "Save", "gold", function()
    -- Halimbawa:
notify("Save", "Gorilla King got Spectral", 4)
end)

TestTab.createStyledButton("Red Button", "Delete", "red", function()
    -- Halimbawa:
notify("Delete", "Gorilla King got Spectral", 4)
end)

-- 8. Double Cube (Yung stats)
TestTab.createDoubleCube({
    Left = { Icon = "rbxthumb://type=Asset&id=139170523934512&w=150&h=150", Label = "STAT 1", GetValue = function() return 150 end },
    Right = { Icon = "rbxthumb://type=Asset&id=129912519134128&w=150&h=150", Label = "STAT 2", GetValue = function() return 300 end },
})

-- ]]



-- ====================================================================
-- SECTION 3 MIZUNO & MIZUNO NM ESP (ESP ONLY)
-- ====================================================================
local CoreGui   = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Players   = game:GetService("Players")

local player = Players.LocalPlayer
local section3Connection = nil

S3Tab.createToggle("Mizuno Box & Name ESP", "Highlights Mizuno (Normal & NM)", function(state)
    local espContainer = CoreGui:FindFirstChild("IOHUB_Section3Container")
    if not espContainer then
        espContainer = Instance.new("Folder")
        espContainer.Name = "IOHUB_Section3Container"
        espContainer.Parent = CoreGui
    end

    local function applyModelESP(model, isNightmare)
        if not model or not model:IsA("Model") then return end

        local tagIdentifier = "MizunoESP_" .. model.Name .. "_" .. tostring(model:GetPivot().Position)
        if espContainer:FindFirstChild(tagIdentifier) then return end

        -- 1. Buong Katawan Highlight
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

        -- 2. Hitbox / HumanoidRootPart para sa Name Tag
        local targetPart = model:FindFirstChild("Hitbox")
            or model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChildWhichIsA("BasePart")
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

    local function scanMizunoFolder()
        local monsterFolder = Workspace:FindFirstChild("Section3") and Workspace.Section3:FindFirstChild("Monster")
        if not monsterFolder then return end

        local normalMizuno = monsterFolder:FindFirstChild("Mizuno")
        local nmMizuno     = monsterFolder:FindFirstChild("MizunoNM")

        if normalMizuno and normalMizuno:IsA("Model") then applyModelESP(normalMizuno, false) end
        if nmMizuno     and nmMizuno:IsA("Model")     then applyModelESP(nmMizuno, true)      end
    end

    if state then
        scanMizunoFolder()

        if not section3Connection then
            section3Connection = Workspace.DescendantAdded:Connect(function(descendant)
                task.spawn(function()
                    pcall(function()
                        if descendant:IsA("Model") then
                            if descendant.Name == "Mizuno"   then applyModelESP(descendant, false)
                            elseif descendant.Name == "MizunoNM" then applyModelESP(descendant, true)
                            end
                        end
                    end)
                end)
            end)
        end

        notify("Success", "Mizuno ESP: ON", 3, "success")
    else
        if section3Connection then
            section3Connection:Disconnect()
            section3Connection = nil
        end

        for _, desc in ipairs(Workspace:GetDescendants()) do
            if desc.Name == "MizunoHighlight" then
                desc:Destroy()
            end
        end

        if espContainer then
            espContainer:ClearAllChildren()
        end

        notify("Info", "Mizuno ESP: OFF", 2, "info")
    end
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



-- ====================================================================
-- AUTO FIX CIRCUIT (Complete + Released + Teleport up to escape GUI)
-- ====================================================================
S3Tab.createToggle("Auto Fix Circuit", "Complete + Released + teleport up 15 studs to close GUI", function(state)
    _G.CircuitFixActive = state

    if not state then
        notify("Info", "Circuit Auto-Fix: OFF", 2, "info")
        return
    end

    local player = game.Players.LocalPlayer
    local RS     = game:GetService("ReplicatedStorage")
    local PPS    = game:GetService("ProximityPromptService")

    local CobaltEvent = RS:FindFirstChild("modules")
        and RS.modules:FindFirstChild("Packet")
        and RS.modules.Packet:FindFirstChild("Reliable")

    if not CobaltEvent then
        notify("Error", "Reliable not found", 3, "error")
        _G.CircuitFixActive = false
        return
    end

    local lastPrompt = nil
    local conn = PPS.PromptTriggered:Connect(function(p)
        local cf = workspace:FindFirstChild("Section3")
            and workspace.Section3:FindFirstChild("OBJECTIVE")
            and workspace.Section3.OBJECTIVE:FindFirstChild("Circuits")
        if cf and p:IsDescendantOf(cf) then
            lastPrompt = p
        end
    end)

    notify("Success", "Circuit Auto-Fix: ON", 3, "success")

    task.spawn(function()
        local processed = nil

        while _G.CircuitFixActive do
            task.wait(0.1)
            if not _G.CircuitFixActive then break end

            local gui = player:FindFirstChild("PlayerGui")
                and player.PlayerGui:FindFirstChild("CircuitsMinigame")

            if gui and processed ~= gui and lastPrompt and lastPrompt.Parent then
                local circuit    = lastPrompt.Parent.Parent
                local promptPart = lastPrompt.Parent

                -- 1) COMPLETE (x5 para sure)
                for i = 1, 5 do
                    if not _G.CircuitFixActive then break end
                    pcall(function()
                        CobaltEvent:FireServer("Section3/CircuitRoundComplete", circuit)
                    end)
                    task.wait(0.05)
                end
                task.wait(0.3)

            

         

                -- 4) TELEPORT UP 15 STUDS — para mawala ang GUI nang kusa
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = root.CFrame + Vector3.new(0, 15, 0)
                end

                processed = gui
                notify("Success", "Done: " .. circuit.Name, 2, "success")
                lastPrompt = nil

            elseif not gui then
                -- GUI closed → ready for next circuit
                processed = nil
            end
        end

        if conn then
            conn:Disconnect()
            conn = nil
        end
        notify("Info", "Circuit Auto-Fix: OFF", 2, "info")
    end)
end)



-- ====================================================================
-- AUTO TERMINAL (nearest only, 3x RoundComplete + Release)
-- ====================================================================
S4LabTab.createCustomButton("Auto Terminal (Nearest)", "", function()
    local player = game.Players.LocalPlayer
    local RS     = game:GetService("ReplicatedStorage")

    local CobaltEvent = RS:FindFirstChild("modules")
        and RS.modules:FindFirstChild("Packet")
        and RS.modules.Packet:FindFirstChild("Reliable")

    if not CobaltEvent then
        notify("Error", "Cobalt remote not found", 3, "error")
        return
    end

    local shapeFolder = workspace:FindFirstChild("Section4")
        and workspace.Section4:FindFirstChild("Lab")
        and workspace.Section4.Lab:FindFirstChild("CleanseRoomObjective")
        and workspace.Section4.Lab.CleanseRoomObjective:FindFirstChild("ShapeTerminals")

    if not shapeFolder then
        notify("Error", "ShapeTerminals folder not found", 3, "error")
        return
    end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        notify("Error", "No HumanoidRootPart", 3, "error")
        return
    end

    -- Hanapin pinakamalapit na terminal (Model na may PromptPart)
    local closest, closestDist = nil, math.huge
    for _, obj in ipairs(shapeFolder:GetChildren()) do
        if obj:IsA("Model") then
            local pp = obj:FindFirstChild("PromptPart")
                or obj:FindFirstChildWhichIsA("BasePart", true)
            if pp then
                local d = (pp.Position - root.Position).Magnitude
                if d < closestDist then
                    closestDist = d
                    closest      = obj
                end
            end
        end
    end

    if not closest then
        notify("Error", "No terminal found in folder", 3, "error")
        return
    end

    notify("Info", "Target: " .. closest.Name .. " (" .. math.floor(closestDist) .. " studs)", 2, "info")

    -- 1) RoundComplete x3 (0.2s gap)
    for i = 1, 3 do
        pcall(function()
            CobaltEvent:FireServer("ShapeTerminal/RoundComplete", closest)
        end)
        task.wait(0.2)
    end

    -- 2) Wait bago mag-release para ma-process ng server
    task.wait(0.3)

    -- 3) Release
    pcall(function()
        CobaltEvent:FireServer("ShapeTerminal/Release", closest)
    end)

    notify("Success", "Released: " .. closest.Name .. " (" .. math.floor(closestDist) .. " studs)", 3, "success")
end)


S4LabTab.createCustomButton("Lockdown Skill Check Hit", "", function()
    fireReliable("Section4/LockdownSkillCheckHit", "Lockdown Skill Check Hit")
    notify("Success", "Lockdown Skill Check Hit", 2, "success")
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
-- BUTTON: HYPER-SPEED SILENT WIREBOX INJECTOR
-- ====================================================================
S5StairsTab.createCustomButton("Auto Fix Wirebox", "", function()
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Grab the verified Cobalt Module Event directly from memory
    local CobaltEvent = ReplicatedStorage:FindFirstChild("modules")
        and ReplicatedStorage.modules:FindFirstChild("Packet")
        and ReplicatedStorage.modules.Packet:FindFirstChild("Reliable")

    if not CobaltEvent then
        notify("Error", "Cobalt Packet route not found!", 4, "error")
        return
    end

    local boxesFolder = Workspace:FindFirstChild("Section5")
        and Workspace.Section5:FindFirstChild("MainObjective")
        and Workspace.Section5.MainObjective:FindFirstChild("Boxes")

    if not boxesFolder then
        notify("Error", "Boxes folder not loaded!", 4, "error")
        return
    end

    local wireBoxesList = boxesFolder:GetChildren()
    notify("Info", "Launching packet extraction on " .. tostring(#wireBoxesList) .. " wireboxes...", 2, "info")

    -- LIGHTNING EXECUTION LOOP (Puro remote packets)
    for index, targetBox in ipairs(wireBoxesList) do
        if targetBox.Name == "WireBox" or targetBox:IsA("Model") then
            pcall(function()
                -- 1. Angkinin ang device sa server
                CobaltEvent:FireServer("Section5/WireBoxClaim", targetBox)
                
                -- 2. Solusyunan agad ang machine engine
                CobaltEvent:FireServer("Section5/WireBoxComplete", targetBox)
                
                -- 3. Isara at patayin ang UI overlay layer screen block
                CobaltEvent:FireServer("Section5/WireBoxRelease", targetBox)
            end)
        end
    end

    notify("Success", "All wireboxes bypassed silently!", 4, "success")
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
-- AUTO KILL GATA (Range-only, No Teleport, 30 studs)
-- ====================================================================
S1Tab.createToggle("Auto Kill All Gata", "Auto-fire Grunts within 30 studs (no teleport)", function(state)
    _G.GataAutoFireActive = state

    if not state then
        notify("Info", "Gata Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer
    local DETECT_RADIUS = 1000 

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
                            -- Hanapin ang Hitbox o BasePart ng Grunt
                            local part = gataObj:FindFirstChild("Hitbox")
                                or gataObj:FindFirstChild("HumanoidRootPart")
                                or gataObj:FindFirstChildWhichIsA("BasePart", true)

                            if part then
                                local dist = (part.Position - hrp.Position).Magnitude

                                -- Kapag pasok sa 30 studs radius
                                if dist <= DETECT_RADIUS then
                                    -- I-fire lahat ng RemoteEvent sa loob ng Grunt
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


-- ====================================================================
-- ESP EGAO SPAWNS (Main Tab - Visible Red Edition)
-- ====================================================================
local egaoOriginalData = {} -- Para ma-save ang orihinal na Transparency at Color

MainTab.createToggle("ESP Egao Spawns", "Makes EgaoSpawns visible (Red) and highlights them", function(state)
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
                            
                            child.Transparency = 0.9
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



-- ====================================================================
-- AUTO LOOK TO EGAO (Main Tab)
-- ====================================================================
local RunService = game:GetService("RunService")

MainTab.createToggle("Auto Look Egao", "Locks camera and character to face EgaoEventRig", function(state)
    _G.EgaoLookActive = state

    -- I-disconnect ang lumang connection kung mayroon man
    if _G.EgaoLookConnection then
        _G.EgaoLookConnection:Disconnect()
        _G.EgaoLookConnection = nil
    end

    if not state then
        notify("Info", "Auto Look to Egao: OFF", 2, "info")
        return
    end

    notify("Success", "Auto Look to Egao: ON", 2, "success")

    -- Simulan ang per-frame camera and character lock
    _G.EgaoLookConnection = RunService.RenderStepped:Connect(function()
        if not _G.EgaoLookActive then return end

        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            local camera = workspace.CurrentCamera

            if char and char:FindFirstChild("HumanoidRootPart") and camera then
                local hrp = char.HumanoidRootPart
                local currentPos = hrp.Position
                
                local egaoRig = workspace:FindFirstChild("EgaoEventRig", true)
                
                if egaoRig then
                    local targetPart = egaoRig:FindFirstChild("HumanoidRootPart") 
                        or egaoRig:FindFirstChild("Head") 
                        or egaoRig:FindFirstChildWhichIsA("BasePart")
                    
                    if targetPart then
                        local targetPos = targetPart.Position
                        
                        -- 1. Character Rotation (Nakaturo ang katawan sa Egao)
                        local hrpTargetPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
                        hrp.CFrame = CFrame.lookAt(currentPos, hrpTargetPos)
                        
                        -- 2. Camera Rotation (Nakaturo ang camera sa Egao)
                        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPos)
                    end
                end
            end
        end)
    end)
end)


-- ====================================================================
-- ESP YEN (Gold Highlight + Name + Distance Tracker)
-- ====================================================================
local YenContainerName = "IOHUB_Yen_ESP"

-- Custom helper specifically for Yen (para maging "💰 Yen" ang text at mabilis hanapin)
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
            lbl.Text = "💰 Yen" -- Default text
            lbl.TextColor3 = color
            lbl.TextSize = 14
            lbl.Font = Enum.Font.SourceSansBold
            lbl.TextStrokeTransparency = 0
            lbl.Parent = bb
        end
    end
end

-- ====================================================================
-- TOGGLE 1: YEN ESP (Highlight + Name)
-- ====================================================================
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
        -- Cleanup
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


-- ====================================================================
-- TOGGLE 2: YEN SHOW STUDS (Distance Tracker)
-- ====================================================================
YenTab.createToggle("Yen Show Studs", "Shows live distance (studs) for every Yen", function(state)
    _G.YenDistance_Active = state
    local container = getContainer(YenContainerName)

    if state then
        notify("Success", "Yen Studs Tracker: ON", 2, "success")

        task.spawn(function()
            while _G.YenDistance_Active do
                task.wait(0.1)
                if not _G.YenDistance_Active then break end
                
                -- Kung naka-OFF ang Yen ESP, wag na mag-update
                if not _G.YenESP_Active then continue end 

                local myChar = player.Character
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
        -- Ibalik sa normal text ("💰 Yen") kapag pinatay ang Studs
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

MainTab.createToggle("DayTime/Morning", "Toggles full brightness / removes darkness and red atmosphere", function(state)
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

MainTab.createToggle("Anti-Lag / Low Graphics", "Boosts FPS by disabling shadows, particles, and heavy textures", function(state)
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



-- ====================================================================
-- AUTO KILL GRUNTS (Section 2, 30 studs, no teleport)
-- ====================================================================
TestTab.createToggle("Auto Kill All Grunts", "Auto-fire Grunt RemoteEvents within 30 studs", function(state)
    _G.GruntsAutoFireActive = state

    if not state then
        notify("Info", "Grunt Auto-Fire: OFF", 2, "info")
        return
    end

    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player    = Players.LocalPlayer
    local DETECT_RADIUS = 1000

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




-- Ilipat sa Test UI tab para makita agad
switchTab("Main")

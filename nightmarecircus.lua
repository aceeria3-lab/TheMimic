local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer

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
-- NOTIFICATION SYSTEM
----------------------------------------------------
local function showNotification(message)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 220, 0, 40)
    notifFrame.Position = UDim2.new(1, -235, 1, -60)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notifFrame.BackgroundTransparency = 0.2
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 999
    notifFrame.Parent = screenGui

    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 8)
    nCorner.Parent = notifFrame

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Color3.fromRGB(150, 30, 50)
    nStroke.Thickness = 1
    nStroke.Parent = notifFrame

    local nText = Instance.new("TextLabel")
    nText.Size = UDim2.new(1, 0, 1, 0)
    nText.BackgroundTransparency = 1
    nText.Text = message
    nText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nText.Font = Enum.Font.GothamBold
    nText.TextSize = 11
    nText.ZIndex = 1000
    nText.Parent = notifFrame

    task.delay(2, function()
        local tw = TweenService:Create(notifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        tw:Play()
        TweenService:Create(nText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        tw.Completed:Connect(function() notifFrame:Destroy() end)
    end)
end

----------------------------------------------------
-- MAIN CONTAINER WINDOW
----------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 350)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local uiListSide = Instance.new("UIListLayout")
uiListSide.Padding = UDim.new(0, 8)
uiListSide.SortOrder = Enum.SortOrder.LayoutOrder
uiListSide.Parent = sidebar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -195, 1, -55)
contentFrame.Position = UDim2.new(0, 180, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
    scrollPage.Size = UDim2.new(1, -10, 1, -15)
    scrollPage.Position = UDim2.new(0, 5, 0, 10)
    scrollPage.BackgroundTransparency = 1
    scrollPage.BorderSizePixel = 0
    scrollPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollPage.ScrollBarThickness = 2
    scrollPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollPage.Visible = false
    scrollPage.Parent = contentFrame

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

local function createSidebarTab(name, iconSource, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.LayoutOrder = order

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
-- NOTIFY HELPER
----------------------------------------------------
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

----------------------------------------------------
-- CUSTOM ACTION BUTTON (May Lock Feature na)
----------------------------------------------------
local function createCustomButton(pageName, title, description, callback, order, isLocked)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = title .. "_CustomRectangle"
    actionBtn.Size = UDim2.new(0.92, 0, 0, 55)
    actionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    actionBtn.BackgroundTransparency = 0.4
    actionBtn.Text = ""
    actionBtn.AutoButtonColor = not isLocked
    actionBtn.LayoutOrder = order or 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = actionBtn

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = actionBtn

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
    titleLabel.Position = UDim2.new(0, 0, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = isLocked and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = actionBtn

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 24)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = isLocked and Color3.fromRGB(90, 90, 90) or Color3.fromRGB(150, 150, 150)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = actionBtn

    if isLocked then
        -- 🔒 LOCK ICON
        local lockIcon = Instance.new("ImageLabel")
        lockIcon.Name = "LockIcon"
        lockIcon.Size = UDim2.new(0, 24, 0, 24)
        lockIcon.Position = UDim2.new(1, -30, 0.5, -12)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = "rbxassetid://6031090990" -- Padlock icon
        lockIcon.ImageColor3 = Color3.fromRGB(200, 50, 50)
        lockIcon.Parent = actionBtn
        
        actionBtn.MouseButton1Click:Connect(function()
            notify("IOHUB", "Feature Locked", 2)
        end)
    else
        -- MOUSE CLICK ICON (Normal)
        local mouseIcon = Instance.new("ImageLabel")
        mouseIcon.Name = "MousePointerIcon"
        mouseIcon.Size = UDim2.new(0, 22, 0, 22)
        mouseIcon.Position = UDim2.new(1, -25, 0.5, -11)
        mouseIcon.BackgroundTransparency = 1
        mouseIcon.Image = "rbxassetid://10734896206"
        mouseIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        mouseIcon.Parent = actionBtn

        actionBtn.MouseButton1Click:Connect(function()
            mouseIcon.ImageColor3 = Color3.fromRGB(255, 100, 120)
            task.wait(0.1)
            mouseIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
            if callback then callback() end
        end)
    end

    actionBtn.Parent = targetPage
    return actionBtn
end

----------------------------------------------------
-- CUSTOM TOGGLE
----------------------------------------------------
local function createneToggle(pageName, title, description, callback, order)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.92, 0, 0, 55)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = ""
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    indicator.Parent = toggleBtn
    
    local enabled = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        else
            TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
        if callback then callback(enabled) end
    end)
    
    toggleBtn.Parent = row
    row.Parent = targetPage
end

----------------------------------------------------
-- SECTION HEADER
----------------------------------------------------
local function createSectionHeader(pageName, text, order)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local header = Instance.new("TextLabel")
    header.Name = text:gsub("%s", "") .. "Header"
    header:SetAttribute("SectionHeader", true)
    header.Size = UDim2.new(0.92, 0, 0, 20)
    header.BackgroundTransparency = 1
    header.Text = text
    header.TextColor3 = Color3.fromRGB(200, 200, 200)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 12
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.LayoutOrder = order or 0
    header.Parent = targetPage
    return header
end

----------------------------------------------------
-- TAB CREATION
----------------------------------------------------
createSidebarTab("Section 1", "circle-play", 1)
createSidebarTab("Section 2", "circle-play", 2)
createSidebarTab("Section 3", "circle-play", 3)
createSidebarTab("Global Chat", "rbxassetid://83881670383280", 4)

----------------------------------------------------
-- SECTION 1: MINI GAMES
----------------------------------------------------
createSectionHeader("Section 1", "Startup", 1)

local isDunkRunning = false
local isStrikeRunning = false 
local isBalloonRunning = false
local ronnieSafetyEnabled = false 
local isSafeSpotCooldown = false

local SAFE_CFRAME = CFrame.new(-134.730, 14.750, 251.264)
local CUTSCENE_CFRAME = CFrame.new(-127.980, 14.887, 180.732)

local function findProxPart()
    local s1 = workspace:FindFirstChild("Section1")
    local games = s1 and s1:FindFirstChild("Games")
    local booth = games and games:FindFirstChild("DunkBooth")
    return booth and booth:FindFirstChild("ProxPart")
end

-- 🔥 SKIP SECTION 1
createCustomButton("Section 1", "Skip Section 1", "Teleport to Section 2 entrance", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    notify("IOHUB", "Skipping Section 1...", 2)
    hrp.CFrame = CFrame.new(1804.395, -61.124, 4507.125)
    hrp.Velocity = Vector3.new(0, 0, 0)
end, 1)

-- TRIGGER CUTSCENE
createCustomButton("Section 1", "Trigger Cutscene", "Touch Cutscene Part then Teleport to Safe Spot & Skip", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if isDunkRunning then isDunkRunning = false end
    if isStrikeRunning then isStrikeRunning = false end

    notify("IOHUB", "Triggering Cutscene...", 2)
    hrp.CFrame = CUTSCENE_CFRAME
    hrp.Velocity = Vector3.new(0, 0, 0)
    task.wait(0.2) 
    hrp.CFrame = SAFE_CFRAME
    hrp.Velocity = Vector3.new(0, 0, 0)
    task.wait(0.1)

    local RS = game:GetService("ReplicatedStorage")
    local modules = RS:FindFirstChild("modules")
    local packet = modules and modules:FindFirstChild("Packet")
    local reliable = packet and packet:FindFirstChild("Reliable")

    if reliable then
        pcall(function() reliable:FireServer("Section1/RonnieIntroSkip") end)
        notify("IOHUB", "Cutscene Skipped!", 3)
    else
        notify("IOHUB", "Reliable event not found!", 3)
    end
end, 2)

-- RONNIE ESP & SAFE SPOT TOGGLE
createneToggle("Section 1", "Ronnie ESP & Safe Spot", "Highlight Ronnie & teleport if near", function(state)
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
end, 3)

-- ============ CARNIVAL GAMES (LOCKED) ============
createSectionHeader("Section 1", "Carnival Games", 4)

-- AUTO DUNK (Locked)
createCustomButton("Section 1", "Auto Dunk", "Teleport and Finish", function() end, 5, true)

-- AUTO BALLOON (Locked)
createCustomButton("Section 1", "Auto Balloon", "Teleport and Finish", function() end, 6, true)

-- AUTO STRIKE (Locked)
createCustomButton("Section 1", "Auto High Strike", "Teleport and Finish", function() end, 7, true)

-- AUTO STRIKE (Locked)
createCustomButton("Section 1", "Auto Golf", "Fire Prompt Once, then 3x Tapping Cycles", function() end, 8, true)

-- AUTO STRIKE (Locked)
createCustomButton("Section 1", "Auto Ring", "Fire Prompt Once, then 3x Tapping Cycles", function() end, 9, true)

-- AUTO STRIKE (Locked)
createCustomButton("Section 1", "Auto Whack", "Fire Prompt Once, then 3x Tapping Cycles", function() end, 10, true)

-- AUTO STRIKE (Locked)
createCustomButton("Section 1", "Auto Basketball", "Fire Prompt Once, then 3x Tapping Cycles", function() end, 11, true)

-- Heartbeat loop para sa Ronnie Auto Safe Spot
RunService.Heartbeat:Connect(function()
    if not ronnieSafetyEnabled or isSafeSpotCooldown or isEyeRelicRunning then return end
    
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s1 = workspace:FindFirstChild("Section1")
    local monster = s1 and s1:FindFirstChild("Monster")
    local ronnie = monster and monster:FindFirstChild("Ronnie")

    if ronnie then
        local ronniePart = ronnie:FindFirstChild("HumanoidRootPart") or ronnie:FindFirstChildWhichIsA("BasePart")
        if ronniePart and (ronniePart.Position - hrp.Position).Magnitude <= 25 then
            isSafeSpotCooldown = true
            notify("IOHUB", "Ronnie Near! Safe Spot.", 2)
            hrp.CFrame = SAFE_CFRAME
            hrp.Velocity = Vector3.new(0, 0, 0)
            task.delay(3, function() isSafeSpotCooldown = false end)
        end
    end
end)


----------------------------------------------------
-- SECTION 2: RELICS & PUZZLES
----------------------------------------------------
local isDimitraESP = false
local isDimitraCooldown = false
local SECTION2_SAFE_CFRAME = CFrame.new(1768.864, -37.218, 4478.665)
local isEyeRelicRunning = false

-- ============ STARTUP ============
createSectionHeader("Section 2", "Startup", 1)

-- DIMITRA ESP & SAFE ZONE TOGGLE
createneToggle("Section 2", "ESP & Safe Zone Dimitra", "Highlight Dimitra & teleport if near", function(state)
    isDimitraESP = state
    notify("IOHUB", "Dimitra Safety: " .. (state and "ON" or "OFF"), 2)
    
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
            
            local s2 = workspace:FindFirstChild("Section2")
            local monster = s2 and s2:FindFirstChild("Monster")
            local dimitra = monster and monster:FindFirstChild("Dimitra")
            if dimitra then
                local hl = dimitra:FindFirstChild("DimitraESP_Highlight")
                if hl then hl:Destroy() end
            end
        end)
    end
end, 2)

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
            notify("IOHUB", "Dimitra Near! Safe Spot.", 2)
            hrp.CFrame = SECTION2_SAFE_CFRAME
            hrp.Velocity = Vector3.new(0, 0, 0)
            task.delay(3, function() isDimitraCooldown = false end)
        end
    end
end)

-- ============ RELIC ============
createSectionHeader("Section 2", "Relic", 3)

local function executeRelicFlow(puzzleFolderName, remoteName, relicDisplayName)
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s2 = workspace:FindFirstChild("Section2")
    local mainObj = s2 and s2:FindFirstChild("MainObjective")
    local puzzleFolder = mainObj and mainObj:FindFirstChild(puzzleFolderName)
    local promptPart = puzzleFolder and puzzleFolder:FindFirstChild("PromptPart")
    local prompt = promptPart and (promptPart:FindFirstChildOfClass("ProximityPrompt") or promptPart:FindFirstChild("ProximityPrompt"))

    if not promptPart or not prompt then
        notify("IOHUB", relicDisplayName .. " Prompt not found!", 3)
        return
    end

    notify("IOHUB", "Teleporting to " .. relicDisplayName .. "...", 2)
    hrp.CFrame = promptPart.CFrame + Vector3.new(0, 3, 0)
    hrp.Velocity = Vector3.new(0, 0, 0)
    task.wait(0.2)

    local realHold = prompt.HoldDuration > 0 and prompt.HoldDuration or 0.5
    notify("IOHUB", string.format("Holding %s Prompt %.2fs...", relicDisplayName, realHold), 2)
    
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

    notify("IOHUB", "Waiting for server...", 2)
    task.wait(0.4) 

    local RS = game:GetService("ReplicatedStorage")
    local modules = RS:FindFirstChild("modules")
    local reliable = modules and modules:FindFirstChild("Packet") and modules.Packet:FindFirstChild("Reliable")
    
    if reliable then
        notify("IOHUB", "Bypassing " .. relicDisplayName .. "...", 2)
        pcall(function() reliable:FireServer(remoteName) end)
    else
        notify("IOHUB", "Reliable module not found!", 3)
    end

    task.wait(0.3)

    notify("IOHUB", "Escaping to Section 2 Safe Spot...", 2)
    hrp.CFrame = SECTION2_SAFE_CFRAME
    hrp.Velocity = Vector3.new(0, 0, 0)
end

-- STAR RELIC
createCustomButton("Section 2", "Auto Star Relic", "Teleport, Fire Prompt, Bypass Star Puzzle", function()
    executeRelicFlow("Puzzle1", "Section2/StarPuzzleComplete", "Star Relic")
end, 4)

-- MOON RELIC
createCustomButton("Section 2", "Auto Moon Relic", "Teleport, Fire Prompt, Bypass Moon Puzzle", function()
    executeRelicFlow("Puzzle3", "Section2/MoonPuzzleComplete", "Moon Relic")
end, 5)

-- FATE RELIC
createCustomButton("Section 2", "Auto Fate Relic", "Teleport, Fire Prompt, Bypass Fate Puzzle", function()
    executeRelicFlow("Puzzle4", "Section2/TarotPuzzleComplete", "Fate Relic")
end, 6)

createCustomButton("Section 2", "Teleport to Eye Room", "Direct Teleport To Eye Room", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    notify("IOHUB", "Skipping Section 1...", 2)
    hrp.CFrame = CFrame.new(1804.395, -61.124, 4507.125)
    hrp.Velocity = Vector3.new(0, 0, 0)
end, 7)


-- AUTO EYE RELIC (Naka-Toggle, Eksaktong Logic mo)
createneToggle("Section 2", "Auto Eye Relic (Nightmare Circus)", "Auto Scan & Solve Eye Puzzle", function(state)
    isEyeRelicRunning = state
    
    if state then
        notify("IOHUB", "Auto Eye Relic: ON", 2)
        
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
                                notify("IOHUB", "Hint Detected: Eye "..i, 1.5)
                            end
                        end
                    end
                end
                
                -- COMPLETE DETECTION
                if not newHintFound and #currentSequence >= 2 and not sequenceComplete then
                    if tick() - lastHintTime >= 2 then
                        sequenceComplete = true
                        
                        if not isExecuting then
                            isExecuting = true
                            task.spawn(function()
                                local batch = {}
                                for _, h in ipairs(currentSequence) do table.insert(batch, h) end
                                currentSequence = {}
                                
                                notify("IOHUB", "Executing Sequence...", 2)
                                
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
        notify("IOHUB", "Auto Eye Relic: OFF", 2)
    end
end, 8)


-- AUTO EYE RELIC (The Hollow - Reverted Logic)
createneToggle("Section 2", "Auto Eye Relic (The Hollow)", "Auto Scan & Solve Eye Puzzle", function(state)
    isEyeRelicRunning = state
    
    if state then
        notify("IOHUB", "Auto Eye Relic (The Hollow): ON", 2)
        
        task.spawn(function()
            local StatueCFrames = {
                [1] = CFrame.new(1826.129, -55.500, 4514.970),
                [2] = CFrame.new(1818.718, -55.050, 4520.048),
                [3] = CFrame.new(1811.461, -55.050, 4525.177),
                [4] = CFrame.new(1805.225, -55.050, 4529.687)
            }
            
            -- 🔥 REVERSED MAPPING PARA SA THE HOLLOW
            -- Mirror 1 = Eye 4, Mirror 2 = Eye 3, etc.
            local mirrorToEyeMap = {
                [1] = 4,
                [2] = 3,
                [3] = 2,
                [4] = 1
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
                                notify("IOHUB", "Hint Detected: Mirror "..i, 1.5)
                            end
                        end
                    end
                end
                
                -- COMPLETE DETECTION
                if not newHintFound and #currentSequence >= 2 and not sequenceComplete then
                    if tick() - lastHintTime >= 2 then
                        sequenceComplete = true
                        
                        if not isExecuting then
                            isExecuting = true
                            task.spawn(function()
                                local batch = {}
                                for _, h in ipairs(currentSequence) do table.insert(batch, h) end
                                currentSequence = {}
                                
                                notify("IOHUB", "Executing Sequence...", 2)
                                
                                for _, mirrorIdx in ipairs(batch) do
                                    if not isEyeRelicRunning then break end
                                    
                                    -- 🔥 DITO NILALAGAY YUNG CONVERSION
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
        notify("IOHUB", "Auto Eye Relic: OFF", 2)
    end
end, 9)


-- ============ BLESSING ============
createSectionHeader("Section 2", "Blessing", 10)

createCustomButton("Section 2", "Crystal Ball Wish", "Teleport & Fire Prompt (with Fallback)", function()
    local ch = localPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local s2 = workspace:FindFirstChild("Section2")
    local mainObj = s2 and s2:FindFirstChild("MainObjective")
    local crystalWish = mainObj and mainObj:FindFirstChild("CrystalBallWish")
    local promptPart = crystalWish and crystalWish:FindFirstChild("PromptPart")
    local prompt = promptPart and (promptPart:FindFirstChildOfClass("ProximityPrompt") or promptPart:FindFirstChild("ProximityPrompt"))

    if promptPart and prompt then
        notify("IOHUB", "Teleporting to Crystal Ball Wish...", 2)
        hrp.CFrame = promptPart.CFrame + Vector3.new(0, 3, 0)
        hrp.Velocity = Vector3.new(0, 0, 0)
        task.wait(0.2)

        local realHold = prompt.HoldDuration > 0 and prompt.HoldDuration or 0.1
        notify("IOHUB", "Firing Crystal Ball Prompt...", 2)
        
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
        notify("IOHUB", "Crystal Ball Wish Done!", 3)
    else
        notify("IOHUB", "Prompt not found! Using Fallback CFrame...", 2)
        hrp.CFrame = SECTION2_SAFE_CFRAME
        hrp.Velocity = Vector3.new(0, 0, 0)
        task.wait(0.5)
        notify("IOHUB", "Teleported to Fallback Location.", 3)
    end
end, 11)


----------------------------------------------------
-- SECTION 3: BOSS FIGHT (Ragebait + Bunny Priority)
----------------------------------------------------
createSectionHeader("Section 3", "Boss Fight", 1)

local isSafeSpotEnabled = false
local isDashing = false
local isAutoBunny = false
local isClaimingBunny = false
local hasNotifiedBossDead = false
local isKillingBoss = false

-- Safe Spot Coordinate mo
local SAFE_SPOT = CFrame.new(2380.165, 205.233, 5131.306)

-- 1. Auto Safe Spot Toggle
createneToggle("Section 3", "Auto Safe Spot", "Keep teleporting back to safe spot", function(state)
    isSafeSpotEnabled = state
    if state then 
        hasNotifiedBossDead = false
        notify("IOHUB", "Safe Spot: ON", 2) 
    else 
        notify("IOHUB", "Safe Spot: OFF", 2) 
    end
end, 2)

-- 2. Sugod (Ragebait) Button
createCustomButton("Section 3", "Sugod sa Boss", "Teleport 15 studs behind boss, hit (x1), then return to Safe Spot", function()
    if isDashing then return end 
    
    local section3 = workspace:FindFirstChild("Section3")
    local boss = section3 and section3:FindFirstChild("DimitraBOSS")
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if boss and hrp then
        local bossPart = boss:FindFirstChild("Hitbox") or boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChildWhichIsA("BasePart")
        if bossPart then
            isDashing = true
            notify("IOHUB", "Sugod! (Dashing)", 2)
            
            -- 1. Teleport sa likod ng boss (15 studs)
            local targetPos = bossPart.CFrame * CFrame.new(0, 3, 15).Position
            hrp.CFrame = CFrame.lookAt(targetPos, bossPart.Position)
            hrp.Velocity = Vector3.new(0, 0, 0)
            
            -- 2. Equip Axe
            local backpack = localPlayer:FindFirstChild("Backpack")
            local axe = backpack and backpack:FindFirstChild("MagicAxe")
            if not axe then axe = char:FindFirstChild("MagicAxe") end
            if axe and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid:EquipTool(axe)
            end

            local modules = game:GetService("ReplicatedStorage"):FindFirstChild("modules")
            local reliable = modules and modules:FindFirstChild("Packet") and modules.Packet:FindFirstChild("Reliable")
            
            task.spawn(function()
                -- Latency fix (0.25s) para pumasok ang damage
                task.wait(0.25) 
                
                -- 3. Fire Event (X1 LANG - Walang loop)
                if reliable then
                    pcall(function() reliable:FireServer("MagicAxe/SwingHit") end)
                end
                
                -- 4. Balik agad sa Safe Spot
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
end, 3)

-- 3. Auto Collect Bunny Toggle
createneToggle("Section 3", "Auto Collect Bunny", "Claim Bunny whenever spawned", function(state)
    isAutoBunny = state
    if state then notify("IOHUB", "Auto Bunny: ON", 2) else notify("IOHUB", "Auto Bunny: OFF", 2) end
end, 4)

-- 4. Instant Kill Custom Button
createCustomButton("Section 3", "Instant Kill Boss (Solo)", "Directly set Dimitra's health to 0", function()
    if isKillingBoss then return end
    
    local section3 = workspace:FindFirstChild("Section3")
    local boss = section3 and section3:FindFirstChild("DimitraBOSS")
    
    if boss then
        local bossHum = boss:FindFirstChildOfClass("Humanoid")
        if bossHum and bossHum.Health > 0 then
            isKillingBoss = true
            notify("IOHUB", "Instant Killing Boss...", 2)
            
            pcall(function()
                bossHum.Health = 0
                bossHum:ChangeState(Enum.HumanoidStateType.Dead)
            end)
            
            task.wait(1)
            isKillingBoss = false
        else
            notify("IOHUB", "Boss already dead!", 2)
        end
    else
        notify("IOHUB", "Boss not found!", 2)
    end
end, 5)

-- MAIN LOOP (Boss Death Check > Bunny Priority > Safe Spot)
RunService.Heartbeat:Connect(function()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- ========================================================
    -- 1. DIREKTANG HEALTH CHECK (Kapag 0 na, tigil agad)
    -- ========================================================
    local s3 = workspace:FindFirstChild("Section3")
    local boss = s3 and s3:FindFirstChild("DimitraBOSS")
    local bossHum = boss and boss:FindFirstChild("Humanoid")
    
    if bossHum and bossHum.Health <= 1 then
        if isSafeSpotEnabled then
            isSafeSpotEnabled = false
            if not hasNotifiedBossDead then
                notify("IOHUB", "Boss Health is 0! Safe Spot Auto-OFF", 3)
                hasNotifiedBossDead = true
            end
        end
        return
    end

    -- ========================================================
    -- 2. BUNNY PRIORITY CHECK (Mas matalinong pag-hanap)
    -- ========================================================
    -- Hahanapin muna sa workspace, tapos sa workspace.Section3, tapos deep search
    local bunnySpawn = workspace:FindFirstChild("BunnySpawn") 
        or (workspace:FindFirstChild("Section3") and workspace.Section3:FindFirstChild("BunnySpawn"))
    
    if not bunnySpawn then
        bunnySpawn = workspace:FindFirstChild("BunnySpawn", true) -- Deep search
    end

    if bunnySpawn then
        local bunnyRoot = bunnySpawn:FindFirstChild("RootPart") or bunnySpawn:FindFirstChildWhichIsA("BasePart")
        local bunnyPrompt = bunnySpawn:FindFirstChildWhichIsA("ProximityPrompt", true)

        if isAutoBunny and bunnyRoot and bunnyPrompt and not isClaimingBunny then
            isClaimingBunny = true
            
            task.spawn(function()
                pcall(function()
                    notify("IOHUB", "Claiming Bunny!", 2)
                    -- Teleport sa Bunny
                    hrp.CFrame = bunnyRoot.CFrame + Vector3.new(0, 3, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    task.wait(0.3) -- Hintayin ang server na i-register ang pwesto

                    local oldLOS = bunnyPrompt.RequiresLineOfSight
                    local oldDist = bunnyPrompt.MaxActivationDistance
                    bunnyPrompt.RequiresLineOfSight = false
                    bunnyPrompt.MaxActivationDistance = 100

                    -- Pindutin ang prompt
                    pcall(function() bunnyPrompt:InputHoldBegin() end)
                    task.wait(0.5)
                    pcall(function() bunnyPrompt:InputHoldEnd() end)
                    
                    if typeof(fireproximityprompt) == "function" then 
                        pcall(function() fireproximityprompt(bunnyPrompt) end)
                    end

                    bunnyPrompt.RequiresLineOfSight = oldLOS
                    bunnyPrompt.MaxActivationDistance = oldDist
                end)
                
                -- Mag-antay ng konti bago hayaang gumana ulit ang Safe Spot
                task.wait(0.5)
                isClaimingBunny = false
            end)
            return -- Pag may bunny, hihinto muna ang Safe Spot
        end
    end

    -- ========================================================
    -- 3. SAFE SPOT LOGIC
    -- ========================================================
    if isSafeSpotEnabled and not isDashing and not isClaimingBunny then
        if (hrp.Position - SAFE_SPOT.Position).Magnitude > 1 then
            hrp.CFrame = SAFE_SPOT
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

----------------------------------------------------
-- GLOBAL CHAT TAB
----------------------------------------------------
----------------------------------------------------
-- GLOBAL CHAT TAB (Perfect Fit, Auto-Image, Compact)
----------------------------------------------------
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

    local GameName = "Unknown Game"
    task.spawn(function()
        local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
        if ok and info and info.Name then GameName = info.Name end
    end)

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
        local backdrop = Instance.new("TextButton")
        backdrop.Size = UDim2.new(1, 0, 1, 0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency = 0.5
        backdrop.Text = ""
        backdrop.AutoButtonColor = false
        backdrop.ZIndex = 500
        backdrop.Parent = screenGui

        local dialog = Instance.new("Frame")
        dialog.Size = UDim2.new(0, 290, 0, 270)
        dialog.Position = UDim2.new(0.5, -145, 0.5, -135)
        dialog.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        dialog.BorderSizePixel = 0
        dialog.ZIndex = 501
        dialog.ClipsDescendants = true
        dialog.Parent = screenGui
        Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 12)
        local dStroke = Instance.new("UIStroke")
        dStroke.Color = Color3.fromRGB(88, 101, 242)
        dStroke.Thickness = 1.5
        dStroke.Transparency = 0.3
        dStroke.Parent = dialog

        local banner = Instance.new("Frame")
        banner.Size = UDim2.new(1, 0, 0, 52)
        banner.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        banner.BorderSizePixel = 0
        banner.ZIndex = 502
        banner.Parent = dialog
        local bGrad = Instance.new("UIGradient")
        bGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 255)),
        }
        bGrad.Rotation = 45
        bGrad.Parent = banner

        local closeX = Instance.new("TextButton")
        closeX.Size = UDim2.fromOffset(22, 22)
        closeX.Position = UDim2.new(1, -30, 0, 8)
        closeX.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        closeX.BackgroundTransparency = 0.85
        closeX.Text = "X"
        closeX.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeX.Font = Enum.Font.GothamBold
        closeX.TextSize = 11
        closeX.AutoButtonColor = true
        closeX.ZIndex = 504
        closeX.Parent = dialog
        Instance.new("UICorner", closeX).CornerRadius = UDim.new(1, 0)

        local avatar = Instance.new("ImageLabel")
        avatar.Size = UDim2.fromOffset(58, 58)
        avatar.Position = UDim2.new(0.5, -29, 0, 22)
        avatar.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
        avatar.BorderSizePixel = 0
        avatar.Image = ""
        avatar.ZIndex = 503
        avatar.Parent = dialog
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
        local aStroke = Instance.new("UIStroke")
        aStroke.Color = Color3.fromRGB(25, 25, 30)
        aStroke.Thickness = 3
        aStroke.Parent = avatar

        if data.userId and data.userId > 0 then
            task.spawn(function()
                local ok, url = pcall(P.GetUserThumbnailAsync, P, data.userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                if ok and url and avatar.Parent then avatar.Image = url end
            end)
        end

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -28, 0, 20)
        nameLbl.Position = UDim2.new(0, 14, 0, 84)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "@" .. tostring(data.name or "?")
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 15
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.ZIndex = 504
        nameLbl.Parent = dialog
        local nGrad = Instance.new("UIGradient")
        nGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100)),
        }
        nGrad.Parent = nameLbl

        local gameLbl = Instance.new("TextLabel")
        gameLbl.Size = UDim2.new(1, -28, 0, 14)
        gameLbl.Position = UDim2.new(0, 14, 0, 106)
        gameLbl.BackgroundTransparency = 1
        gameLbl.Text = "🎮 " .. tostring(data.gameName or "Unknown Game")
        gameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        gameLbl.Font = Enum.Font.GothamMedium
        gameLbl.TextSize = 11
        gameLbl.TextXAlignment = Enum.TextXAlignment.Center
        gameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        gameLbl.ZIndex = 504
        gameLbl.Parent = dialog
        local gGrad = Instance.new("UIGradient")
        gGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255)),
        }
        gGrad.Parent = gameLbl

        local infoCard = Instance.new("Frame")
        infoCard.Size = UDim2.new(1, -28, 0, 68)
        infoCard.Position = UDim2.new(0, 14, 0, 126)
        infoCard.BackgroundColor3 = Color3.fromRGB(35, 36, 44)
        infoCard.BorderSizePixel = 0
        infoCard.ZIndex = 502
        infoCard.Parent = dialog
        Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 6)
        local icStroke = Instance.new("UIStroke")
        icStroke.Color = Color3.fromRGB(60, 62, 70)
        icStroke.Thickness = 1
        icStroke.Transparency = 0.5
        icStroke.Parent = infoCard
        local icPad = Instance.new("UIPadding")
        icPad.PaddingTop = UDim.new(0, 6)
        icPad.PaddingLeft = UDim.new(0, 10)
        icPad.PaddingRight = UDim.new(0, 10)
        icPad.Parent = infoCard
        local icLayout = Instance.new("UIListLayout")
        icLayout.Padding = UDim.new(0, 2)
        icLayout.SortOrder = Enum.SortOrder.LayoutOrder
        icLayout.Parent = infoCard

        local function infoRow(labelText, valueText, order)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 10)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = Color3.fromRGB(140, 145, 155)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 9
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.LayoutOrder = order
            lbl.ZIndex = 503
            lbl.Parent = infoCard

            local val = Instance.new("TextLabel")
            val.Size = UDim2.new(1, 0, 0, 12)
            val.BackgroundTransparency = 1
            val.Text = tostring(valueText or "N/A")
            val.TextColor3 = Color3.fromRGB(230, 232, 235)
            val.Font = Enum.Font.Gotham
            val.TextSize = 10
            val.TextXAlignment = Enum.TextXAlignment.Left
            val.TextTruncate = Enum.TextTruncate.AtEnd
            val.LayoutOrder = order + 1
            val.ZIndex = 503
            val.Parent = infoCard
        end

        infoRow("GAME NAME", tostring(data.gameName or "Unknown Game"), 1)
        infoRow("JOB ID", data.jobId and tostring(data.jobId) or "Not Available", 3)

        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -28, 0, 30)
        btnRow.Position = UDim2.new(0, 14, 0, 202)
        btnRow.BackgroundTransparency = 1
        btnRow.ZIndex = 504
        btnRow.Parent = dialog
        local brLayout = Instance.new("UIListLayout")
        brLayout.FillDirection = Enum.FillDirection.Horizontal
        brLayout.Padding = UDim.new(0, 8)
        brLayout.SortOrder = Enum.SortOrder.LayoutOrder
        brLayout.Parent = btnRow

        local function closeDialog()
            if backdrop and backdrop.Parent then backdrop:Destroy() end
            if dialog and dialog.Parent then dialog:Destroy() end
        end

        local joinBtn = Instance.new("TextButton")
        joinBtn.Size = UDim2.new(0.5, -4, 1, 0)
        joinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        joinBtn.Text = "Join Game"
        joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinBtn.Font = Enum.Font.GothamBold
        joinBtn.TextSize = 12
        joinBtn.LayoutOrder = 1
        joinBtn.AutoButtonColor = true
        joinBtn.ZIndex = 505
        joinBtn.Parent = btnRow
        Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 6)

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0.5, -4, 1, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(60, 63, 70)
        closeBtn.Text = "Close"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 12
        closeBtn.LayoutOrder = 2
        closeBtn.AutoButtonColor = true
        closeBtn.ZIndex = 505
        closeBtn.Parent = btnRow
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

        closeX.MouseButton1Click:Connect(closeDialog)
        backdrop.MouseButton1Click:Connect(closeDialog)
        closeBtn.MouseButton1Click:Connect(closeDialog)

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
        local others = {}
        for _, info in pairs(self.Online or {}) do
            table.insert(others, info)
        end
        table.sort(others, function(a, b) return (a.n or "") < (b.n or "") end)
        showOnlinePlayersDialog(others)
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

            if isEveryoneMsg and not mine then
                ShowMentionPopup("@everyone mentioned you", "@"..un..": "..raw:sub(1, 60), Color3.fromRGB(255, 180, 50))
            end
            if replyToMe then
                local preview
                if msgImageUrl ~= "" then
                    preview = "📷 Sent you an image"
                elseif raw ~= "" then
                    preview = '"'..raw:sub(1, 60)..'"'
                else
                    preview = "Replied to your message"
                end
                ShowMentionPopup("@"..un.." replied to your message!", preview, Color3.fromRGB(88, 101, 242))
            end
        end

        local wrap=self:_o({"Frame",{
            Size=UDim2.new(1,-2,0,0),AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=self.Order
        }},self.List)

        local row=self:_o({"Frame",{
            Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundColor3=mine and Color3.fromRGB(44,46,56) or Color3.fromRGB(40,42,47),
            BorderSizePixel=0
        }},wrap)
        self:_o({"UICorner",{CornerRadius=UDim.new(0,6)}},row)
        local stroke=Instance.new("UIStroke")
        stroke.Color=mine and Color3.fromRGB(88,101,242) or Color3.fromRGB(55,58,65)
        stroke.Thickness=1
        stroke.Transparency=mine and 0.55 or 0.4
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

        -- ✅ PINALIT: TextSize 12 (dating 13)
        local userLabel = self:_o({"TextButton",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="@"..un,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=12,AutoButtonColor=false,LayoutOrder=1}},leftHeader)
        local uGrad = Instance.new("UIGradient")
        uGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100))}
        uGrad.Parent = userLabel
        userLabel.MouseButton1Click:Connect(OpenProfilePopup)

        self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="|",TextColor3=Color3.fromRGB(150,150,150),Font=Enum.Font.Gotham,TextSize=12,LayoutOrder=2}},leftHeader)

        -- ✅ PINALIT: TextSize 12 (dating 13)
        local gameLabel = self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=gName,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=12,LayoutOrder=3,TextTruncate=Enum.TextTruncate.AtEnd}},leftHeader)
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
    BackgroundColor3=Color3.fromRGB(30,31,34),BorderSizePixel=0,ClipsDescendants=true
}},container)
self.Main=main
-- Pinalitan natin ng 12 para kapareho ng CornerRadius ng contentFrame
self:_o({"UICorner",{CornerRadius=UDim.new(0,12)}},main)

-- ❌ TINANGGAL NATIN YUNG AddBorder(main, ...) para hindi na lumabas yung makapal na border sa gilid

        local top=self:_o({"Frame",{
            Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,40),
            BackgroundColor3=Color3.fromRGB(40,42,48),BorderSizePixel=0
        }},main)
        self:_o({"Frame",{Position=UDim2.new(0,0,1,-6),Size=UDim2.new(1,0,0,6),BackgroundColor3=Color3.fromRGB(40,42,48),BorderSizePixel=0}},top)

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

        local bottom=self:_o({"Frame",{
            AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,48),
            BackgroundColor3=Color3.fromRGB(40,42,48),BorderSizePixel=0
        }},main)
        self:_o({"Frame",{Size=UDim2.new(1,0,0,6),BackgroundColor3=Color3.fromRGB(40,42,48),BorderSizePixel=0}},bottom)

        -- ✅ PINALIT: Input box pinalaki, at tinanggal ang imageBtn
        local input=self:_o({"TextBox",{
            Position=UDim2.fromOffset(6,8),Size=UDim2.new(1,-72,0,30),
            BackgroundColor3=Color3.fromRGB(50,53,60),
            BorderSizePixel=0,ClearTextOnFocus=false,MultiLine=false,Text="",PlaceholderText="Message or Image ID...",
            PlaceholderColor3=Color3.fromRGB(120,125,135),TextColor3=Color3.fromRGB(230,232,235),
            Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center
        }},bottom)
        self.Input=input
        self:_o({"UICorner",{CornerRadius=UDim.new(0,6)}},input)
        self:_o({"UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,6)}},input)
        AddBorder(input,Color3.fromRGB(0,0,0),Color3.fromRGB(60,65,75),1,1.2)

        local send=self:_o({"ImageButton",{
            AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-6,0,8),Size=UDim2.fromOffset(60,30),
            BackgroundColor3=Color3.fromRGB(88,101,242),BorderSizePixel=0,Image=I.send,ImageColor3=Color3.new(1,1,1),
            ScaleType=Enum.ScaleType.Fit,AutoButtonColor=false
        }},bottom)
        self.SendBtn=send
        self:_o({"UICorner",{CornerRadius=UDim.new(0,6)}},send)
        AddBorder(send,Color3.fromRGB(0,0,0),Color3.fromRGB(120,140,255),1,1.4)
        BindBorder(send,1.4,2.2,2.8)
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

switchTab("Section 1")
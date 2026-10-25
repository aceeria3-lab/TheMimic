local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

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

    if tabName == "Lanterns" and _G.RefreshLanternsFunc then
        _G.RefreshLanternsFunc()
    end
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
-- CUSTOM BUTTON
----------------------------------------------------
local function createCustomButton(pageName, title, description, callback)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = title .. "_CustomRectangle"
    actionBtn.Size = UDim2.new(0.92, 0, 0, 55)
    actionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    actionBtn.BackgroundTransparency = 0.4
    actionBtn.Text = ""
    actionBtn.AutoButtonColor = true

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
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = actionBtn

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.75, 0, 0, 32)
    descLabel.Position = UDim2.new(0, 0, 0, 24)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = actionBtn

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

    actionBtn.Parent = targetPage
end

----------------------------------------------------
-- CHAPTER CARD CREATOR
----------------------------------------------------
local function createChapterCard(parentContainer, title, imageId, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 1, 0)
    card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = card

    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(1, 0, 1, 0)
    thumb.BackgroundTransparency = 1
    thumb.Image = "rbxassetid://" .. imageId
    thumb.ScaleType = Enum.ScaleType.Crop
    thumb.Parent = card

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 10)
    thumbCorner.Parent = thumb

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 0.6, 0)
    overlay.Position = UDim2.new(0, 0, 0.4, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.4
    overlay.BorderSizePixel = 0
    overlay.Parent = card

    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 10)
    overlayCorner.Parent = overlay

    local overlayGradient = Instance.new("UIGradient")
    overlayGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    overlayGradient.Parent = overlay

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 30)
    titleLbl.Position = UDim2.new(0, 10, 1, -35)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextWrapped = true
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextYAlignment = Enum.TextYAlignment.Bottom
    titleLbl.ZIndex = 2
    titleLbl.Parent = card

    card.Parent = parentContainer
end

----------------------------------------------------
-- SAVE SLOTS LOGIC & FIXES
----------------------------------------------------
local DEFAULT_LOAD_ICON = "rbxassetid://11989922054"
local LOAD_BG_COLOR = Color3.fromRGB(40, 200, 64)

local function getValidImage(imageObj)
    if not imageObj then return "" end
    local function isGood(img)
        return img and img ~= "" and img ~= "rbxassetid://0" and img ~= "rbxasset://0"
    end
    if imageObj:IsA("ImageLabel") or imageObj:IsA("ImageButton") then
        if isGood(imageObj.Image) then return imageObj.Image end
    end
    for _, desc in ipairs(imageObj:GetDescendants()) do
        if desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
            if isGood(desc.Image) then return desc.Image end
        end
    end
    return ""
end

local function clickGuiButton(button)
    if not button then return false end
    if getconnections then
        for _, sigName in ipairs({"MouseButton1Click", "Activated"}) do
            local sig = button[sigName]
            if sig then
                local ok, conns = pcall(getconnections, sig)
                if ok and type(conns) == "table" and #conns > 0 then
                    for _, conn in ipairs(conns) do pcall(function() conn:Fire() end) end
                    return true
                end
            end
        end
    end
    return false
end

local function createAccurateSaveCard(pageName, slotIndex, titleText, timeText, imageId, loadImage, saveButton, order)
    local targetPage = pages[pageName]
    if not targetPage then return end

    local card = Instance.new("TextButton")
    card.Name = "SaveCard_" .. slotIndex
    card:SetAttribute("SaveCard", true)
    card.Size = UDim2.new(0.92, 0, 0, 70)
    card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    card.BorderSizePixel = 0
    card.Text = ""
    card.AutoButtonColor = true
    card.LayoutOrder = order
    card.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = card

    if imageId and imageId ~= "" then
        local thumb = Instance.new("ImageLabel")
        thumb.Size = UDim2.new(1, 0, 1, 0)
        thumb.BackgroundTransparency = 1
        thumb.Image = imageId
        thumb.ScaleType = Enum.ScaleType.Crop
        thumb.Parent = card

        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(0, 10)
        thumbCorner.Parent = thumb
    end

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.4
    overlay.BorderSizePixel = 0
    overlay.Parent = card

    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 10)
    overlayCorner.Parent = overlay

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    gradient.Parent = overlay

    local slotBadge = Instance.new("TextLabel")
    slotBadge.Size = UDim2.new(0, 22, 0, 18)
    slotBadge.Position = UDim2.new(0, 10, 0, 8)
    slotBadge.BackgroundColor3 = Color3.fromRGB(150, 30, 50)
    slotBadge.BackgroundTransparency = 0.1
    slotBadge.Text = tostring(slotIndex)
    slotBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
    slotBadge.Font = Enum.Font.GothamBold
    slotBadge.TextSize = 11
    slotBadge.ZIndex = 3
    local slotCorner = Instance.new("UICorner")
    slotCorner.CornerRadius = UDim.new(0, 4)
    slotCorner.Parent = slotBadge
    slotBadge.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 0, 22)
    titleLbl.Position = UDim2.new(0, 15, 0, 28)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText or ("Slot " .. slotIndex)
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 2
    titleLbl.Parent = card

    if timeText and timeText ~= "" then
        local timeLbl = Instance.new("TextLabel")
        timeLbl.Size = UDim2.new(1, -80, 0, 14)
        timeLbl.Position = UDim2.new(0, 15, 1, -18)
        timeLbl.BackgroundTransparency = 1
        timeLbl.Text = timeText
        timeLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        timeLbl.Font = Enum.Font.Gotham
        timeLbl.TextSize = 10
        timeLbl.TextXAlignment = Enum.TextXAlignment.Left
        timeLbl.ZIndex = 2
        timeLbl.Parent = card
    end

    local finalLoadIcon = loadImage
    if not finalLoadIcon or finalLoadIcon == "" then
        finalLoadIcon = DEFAULT_LOAD_ICON
    end

    local loadBtn = Instance.new("ImageButton")
    loadBtn.Name = "LoadImageButton"
    loadBtn.Size = UDim2.new(0, 65, 0, 30)
    loadBtn.Position = UDim2.new(1, -80, 0.5, -15)
    loadBtn.BackgroundColor3 = LOAD_BG_COLOR
    loadBtn.BackgroundTransparency = 0
    loadBtn.Image = finalLoadIcon
    loadBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    loadBtn.ScaleType = Enum.ScaleType.Stretch
    loadBtn.ZIndex = 3
    loadBtn.Active = true
    loadBtn.AutoButtonColor = true

    local loadCorner = Instance.new("UICorner")
    loadCorner.CornerRadius = UDim.new(0, 6)
    loadCorner.Parent = loadBtn

    local loadOverlay = Instance.new("TextLabel")
    loadOverlay.Size = UDim2.new(1, 0, 1, 0)
    loadOverlay.BackgroundTransparency = 1
    loadOverlay.Text = "LOAD"
    loadOverlay.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadOverlay.Font = Enum.Font.GothamBold
    loadOverlay.TextSize = 10
    loadOverlay.TextStrokeTransparency = 0.2
    loadOverlay.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    loadOverlay.ZIndex = 4
    loadOverlay.Parent = loadBtn

    loadBtn.Parent = card

    local isLoading = false
    local function handleLoad()
        if isLoading then return end
        isLoading = true
        loadOverlay.Text = "..."
        loadBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)

        task.wait(0.35)

        local rs = game:GetService("ReplicatedStorage")
        local mimicSaveSync = rs:FindFirstChild("MimicSaveSync")
        local success = false

        if mimicSaveSync and mimicSaveSync:IsA("RemoteEvent") then
            success = pcall(function()
                mimicSaveSync:FireServer(slotIndex - 1, 1)
            end)
        end

        if not success and saveButton then
            success = clickGuiButton(saveButton)
        end

        task.wait(0.6)
        loadOverlay.Text = "LOAD"
        loadBtn.BackgroundColor3 = LOAD_BG_COLOR
        isLoading = false

        if success then
            notify("IOHUB", "Loading: " .. (titleText or ("Slot " .. slotIndex)), 2)
        else
            notify("IOHUB", "Load failed", 2)
        end
    end

    loadBtn.MouseButton1Click:Connect(handleLoad)
    card.MouseButton1Click:Connect(handleLoad)

    card.Parent = targetPage
end

----------------------------------------------------
-- REFRESH SAVE SLOTS
----------------------------------------------------
local function getSavesHolder()
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local savePanel = playerGui:FindFirstChild("SavePanel")
    if not savePanel then return nil end

    local holder  = savePanel:FindFirstChild("Holder")
    local g1      = holder    and holder:FindFirstChild("Group")
    local m1      = g1        and g1:FindFirstChild("Main")
    local m2      = m1        and m1:FindFirstChild("Main")
    local g2      = m2        and m2:FindFirstChild("Group")
    local list    = g2        and g2:FindFirstChild("List")
    local saves   = list      and list:FindFirstChild("Saves")
    return saves and saves:FindFirstChild("Holder")
end

local function refreshSaveSlots()
    local playPage = pages["Saves"]
    if not playPage then return end

    for _, child in ipairs(playPage:GetChildren()) do
        if child:GetAttribute("SaveCard") or child.Name == "SaveHeader" then
            child:Destroy()
        end
    end

    local savesHolder = getSavesHolder()

    local saveHeader = Instance.new("TextLabel")
    saveHeader.Name = "SaveHeader"
    saveHeader:SetAttribute("SaveHeader", true)
    saveHeader.Size = UDim2.new(0.92, 0, 0, 20)
    saveHeader.BackgroundTransparency = 1
    saveHeader.Text = "SAVE SLOTS"
    saveHeader.TextColor3 = Color3.fromRGB(200, 200, 200)
    saveHeader.Font = Enum.Font.GothamBold
    saveHeader.TextSize = 12
    saveHeader.TextXAlignment = Enum.TextXAlignment.Left
    saveHeader.LayoutOrder = 0
    saveHeader.Parent = playPage

    if not savesHolder then
        for i = 1, 3 do
            createAccurateSaveCard("Saves", i, "Save Slot " .. i, "Open Save Menu to refresh", "", "", nil, i)
        end
        return
    end

    local panels = {}
    for _, child in ipairs(savesHolder:GetChildren()) do
        if child.Name == "Panel" and child:IsA("GuiObject") then
            table.insert(panels, child)
        end
    end
    table.sort(panels, function(a, b)
        return (a.LayoutOrder or 0) < (b.LayoutOrder or 0)
    end)

    local slotIndex = 0
    for _, panel in ipairs(panels) do
        slotIndex = slotIndex + 1
        local innerHolder = panel:FindFirstChild("Holder")
        if innerHolder then
            local titleObj  = innerHolder:FindFirstChild("Title")
            local lastObj   = innerHolder:FindFirstChild("Last")
            local sketchObj = innerHolder:FindFirstChild("Sketch")
            local saveObj   = innerHolder:FindFirstChild("SAVE")

            local titleText = (titleObj and titleObj:IsA("TextLabel") and titleObj.Text) or ("Slot " .. slotIndex)
            local timeText  = (lastObj  and lastObj:IsA("TextLabel")  and lastObj.Text)  or ""
            local imageId   = getValidImage(sketchObj)

            local loadImage = ""
            if saveObj then
                local loadSketch = saveObj:FindFirstChild("Sketch")
                loadImage = getValidImage(loadSketch)
            end

            if imageId == "" then imageId = "rbxassetid://127880323915555" end

            createAccurateSaveCard("Saves", slotIndex, titleText, timeText, imageId, loadImage, saveObj, slotIndex)
        end
    end
end

----------------------------------------------------
-- BOOTSTRAP SAVE SLOTS
----------------------------------------------------
task.spawn(function()
    task.wait(1)
    refreshSaveSlots()

    local playerGui = localPlayer:WaitForChild("PlayerGui", 15)
    if not playerGui then return end

    task.spawn(function()
        local savePanel = playerGui:WaitForChild("SavePanel", 60)
        if not savePanel then return end

        savePanel.DescendantAdded:Connect(function()
            task.wait(0.5)
            refreshSaveSlots()
        end)

        while task.wait(2) do
            local holder = getSavesHolder()
            if holder and #holder:GetChildren() > 0 then
                local needsRefresh = false
                for _, c in ipairs(holder:GetChildren()) do
                    if c.Name == "Panel" then needsRefresh = true break end
                end
                if needsRefresh then refreshSaveSlots() end
            end
        end
    end)
end)

----------------------------------------------------
-- TAB CREATION
----------------------------------------------------
createSidebarTab("Saves",       "circle-play", 1)
createSidebarTab("Lanterns",    "rbxassetid://103871245626488",        2)
createSidebarTab("Supported",   "book-open",   3)
createSidebarTab("Info",        "circle-info", 4)
createSidebarTab("Global Chat", "rbxassetid://83881670383280", 5)

----------------------------------------------------
-- LANTERNS TAB SETUP
----------------------------------------------------
local RARITY_WEIGHTS = {
    ["Mythical"] = 1,
    ["Legendary"] = 2,
    ["Rare"] = 3,
    ["Uncommon"] = 4,
    ["Common"] = 5,
}

local function GetRarityFromColor(color)
    if not color then return "Common", Color3.fromRGB(255, 255, 255) end
    local function isClose(c, r, g, b)
        return math.abs(c.R - (r/255)) < 0.05 and math.abs(c.G - (g/255)) < 0.05 and math.abs(c.B - (b/255)) < 0.05
    end
    if isClose(color, 210, 61, 61)   then return "Mythical", color end
    if isClose(color, 255, 226, 60)  then return "Legendary", color end
    if isClose(color, 170, 170, 255) then return "Rare", color end
    if isClose(color, 124, 170, 107) then return "Uncommon", color end
    if isClose(color, 255, 255, 255) then return "Common", color end
    return "Common", Color3.fromRGB(255, 255, 255)
end

local function safeGetNilInstances()
    if getnilinstances then
        local ok, res = pcall(getnilinstances)
        if ok then return res end
    end
    return {}
end

local function GetEquippedInfo()
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return {} end
    local invGui = playerGui:FindFirstChild("Inventory")
    if not invGui then return {} end
    local equipped = invGui:FindFirstChild("Equipped")
    if not equipped then return {} end
    local quick = equipped:FindFirstChild("Quick")
    if not quick then return {} end

    local padded = quick:FindFirstChild("Padded")
    local nameL  = padded and padded:FindFirstChild("ItemName")
    local keyL   = padded and padded:FindFirstChild("Key")
    local iconL  = quick:FindFirstChild("ItemIcon")
    return {
        Name  = nameL  and nameL.Text  or nil,
        Key   = keyL   and keyL.Text   or nil,
        Image = iconL  and iconL.Image or nil,
    }
end

local function FindByDebugId(name, debugId)
    if not debugId or debugId == "" then return nil end
    for _, obj in pairs(safeGetNilInstances()) do
        if obj.Name == name then
            local ok, id = pcall(function() return obj:GetDebugId() end)
            if ok and id == debugId then return obj end
        end
    end
    return nil
end

local function FindByObjectValue(name)
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local invGui = playerGui:FindFirstChild("Inventory")
    local quick = invGui and invGui:FindFirstChild("Equipped") and invGui.Equipped:FindFirstChild("Quick")
    if not quick then return nil end

    local roots = { quick, quick.Parent }
    for _, root in ipairs(roots) do
        if root then
            for _, obj in pairs(root:GetDescendants()) do
                if obj:IsA("ObjectValue") and obj.Value and obj.Value.Name == name then
                    return obj.Value
                end
            end
        end
    end
    return nil
end

local function FindInCharacterOrBackpack(name)
    local char = localPlayer.Character
    if char then
        for _, obj in pairs(char:GetChildren()) do
            if obj.Name == name then return obj end
        end
    end
    local bp = localPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, obj in pairs(bp:GetChildren()) do
            if obj.Name == name then return obj end
        end
    end
    return nil
end

local function FindByGetNilFallback(name)
    local matches = {}
    for _, obj in pairs(safeGetNilInstances()) do
        if obj.Name == name then table.insert(matches, obj) end
    end
    for _, obj in ipairs(matches) do
        local ok, id = pcall(function() return obj:GetDebugId() end)
        if ok and type(id) == "string" and id:sub(1, 2) == "1_" then return obj end
    end
    return matches[1]
end

local function GetEquippedInstance(name)
    if not name or name == "" then return nil end
    local debugId = GetEquippedInfo().Key
    return FindByDebugId(name, debugId) or FindByObjectValue(name) 
        or FindInCharacterOrBackpack(name) or FindByGetNilFallback(name)
end

local lanternPage = pages["Lanterns"]
for _, child in ipairs(lanternPage:GetChildren()) do
    if child:IsA("UIListLayout") then child:Destroy() end
end

local GridFrame = Instance.new("ScrollingFrame")
GridFrame.Size = UDim2.new(1, -10, 1, -10)
GridFrame.Position = UDim2.new(0.5, 0, 0, 5)
GridFrame.AnchorPoint = Vector2.new(0.5, 0)
GridFrame.BackgroundTransparency = 1
GridFrame.BorderSizePixel = 0
GridFrame.ScrollBarThickness = 4
GridFrame.ScrollBarImageColor3 = Color3.fromRGB(130, 100, 255)
GridFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
GridFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always 
GridFrame.Parent = lanternPage

local GridPadding = Instance.new("UIPadding")
GridPadding.PaddingTop = UDim.new(0, 5)
GridPadding.PaddingBottom = UDim.new(0, 10)
GridPadding.Parent = GridFrame

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0.3, 0, 0, 130)
GridLayout.CellPadding = UDim2.new(0.03, 0, 0, 6)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
GridLayout.Parent = GridFrame

local function CreateCard(lanternName, imageId, isEquipped, orderNum, rarity, rarityColor, onClick)
    local card = Instance.new("Frame")
    card.Size             = UDim2.new(1, 0, 1, 0)
    card.BackgroundColor3 = isEquipped and Color3.fromRGB(40, 50, 40) or Color3.fromRGB(35, 30, 50)
    card.BorderSizePixel  = 0
    card.LayoutOrder      = orderNum
    card.Parent           = GridFrame
    
    local cCorner = Instance.new("UICorner", card)
    cCorner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = isEquipped and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    
    local grad = Instance.new("UIGradient", card)
    grad.Rotation = 90
    grad.Color = isEquipped and ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 60, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 35, 30))
    }) or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 35, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 30))
    })

    local rankLbl = Instance.new("TextLabel")
    rankLbl.Size = UDim2.new(0, 20, 0, 10)
    rankLbl.Position = UDim2.new(0, 3, 0, 3)
    rankLbl.BackgroundTransparency = 1
    rankLbl.Text = "#" .. orderNum
    rankLbl.TextColor3 = rarityColor
    rankLbl.Font = Enum.Font.GothamBlack
    rankLbl.TextSize = 9
    rankLbl.TextXAlignment = Enum.TextXAlignment.Left
    rankLbl.ZIndex = 2
    rankLbl.Parent = card

    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.new(0, 40, 0, 10)
    badge.Position = UDim2.new(1, -43, 0, 3)
    badge.BackgroundColor3 = isEquipped and Color3.fromRGB(100, 200, 100) or rarityColor
    badge.Text = isEquipped and "ACTIVE" or string.upper(rarity)
    
    if isEquipped or rarity == "Legendary" or rarity == "Common" or rarity == "Uncommon" then
        badge.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        badge.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    badge.Font = Enum.Font.GothamBlack
    badge.TextSize = 7
    badge.ZIndex = 2
    badge.Parent = card
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 3)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 45, 0, 45)
    img.Position = UDim2.new(0.5, -22.5, 0, 18)
    img.BackgroundTransparency = 1
    img.Image = imageId
    img.ZIndex = 1
    img.Parent = card

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -4, 0, 25)
    nameLbl.Position = UDim2.new(0, 2, 0, 65)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = lanternName
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 9
    nameLbl.TextWrapped = true
    nameLbl.TextXAlignment = Enum.TextXAlignment.Center
    nameLbl.ZIndex = 2
    nameLbl.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 20)
    btn.Position = UDim2.new(0, 4, 1, -24)
    btn.BackgroundColor3 = isEquipped and Color3.fromRGB(60, 60, 70) or Color3.fromRGB(110, 70, 220)
    btn.Text = isEquipped and "Equipped" or "Equip"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 8
    btn.ZIndex = 2
    btn.Active = true
    btn.AutoButtonColor = true
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    if not isEquipped then
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 90, 255)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 70, 220)}):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            btn.Text = "..."
            btn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            task.spawn(onClick)
        end)
    else
        btn.Active = false
    end
end

local allLanterns = {}

local function CollectAllLanterns()
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return {} end
    local InventoryGui = playerGui:FindFirstChild("Inventory")
    if not InventoryGui then return {} end
    local ScrollingFrame = InventoryGui:FindFirstChild("Inventory") and InventoryGui.Inventory:FindFirstChild("Skins") and InventoryGui.Inventory.Skins:FindFirstChild("ScrollingFrame")
    if not ScrollingFrame then return {} end

    local found, seen = {}, {}
    local function grab()
        for _, item in ipairs(ScrollingFrame:GetChildren()) do
            if item.Name == "Item" then
                local padded = item:FindFirstChild("Padded")
                local nameL  = padded and padded:FindFirstChild("ItemName")
                local icon   = item:FindFirstChild("ItemIcon")
                local stroke = item:FindFirstChild("Stroke")
                
                if nameL and icon and nameL.Text ~= "" and not seen[nameL.Text] then
                    seen[nameL.Text] = true
                    local rarityName, rarityColor = GetRarityFromColor(stroke and stroke.Color)
                    table.insert(found, { 
                        Name = nameL.Text, 
                        Image = icon.Image,
                        Rarity = rarityName,
                        RarityColor = rarityColor
                    })
                end
            end
        end
    end
    
    local origPos = ScrollingFrame.CanvasPosition
    grab()
    local canvasY = ScrollingFrame.AbsoluteCanvasSize.Y
    local windowY = ScrollingFrame.AbsoluteWindowSize.Y
    if canvasY > windowY + 10 then
        local step = math.max(windowY * 0.7, 60)
        local y = 0
        while y < canvasY do
            ScrollingFrame.CanvasPosition = Vector2.new(0, y)
            task.wait(0.04)
            grab()
            y = y + step
        end
        ScrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, canvasY - windowY))
        task.wait(0.04)
        grab()
        ScrollingFrame.CanvasPosition = origPos
    end
    return found
end

local function BuildGrid()
    for _, c in ipairs(GridFrame:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end

    local equippedName = GetEquippedInfo().Name
    local count = 0

    if #allLanterns == 0 then
        local refreshBtn = Instance.new("TextButton")
        refreshBtn.Size = UDim2.new(1, 0, 0, 40)
        refreshBtn.BackgroundColor3 = Color3.fromRGB(110, 70, 220)
        refreshBtn.Text = "No Lanterns Found (Open Inventory First then Click Here)"
        refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        refreshBtn.Font = Enum.Font.GothamBold
        refreshBtn.TextSize = 12
        refreshBtn.Parent = GridFrame
        Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)
        
        refreshBtn.MouseButton1Click:Connect(function()
            allLanterns = CollectAllLanterns()
            table.sort(allLanterns, function(a, b) 
                local wa, wb = RARITY_WEIGHTS[a.Rarity] or 99, RARITY_WEIGHTS[b.Rarity] or 99
                if wa == wb then return a.Name < b.Name end
                return wa < wb 
            end)
            BuildGrid()
        end)
        return
    end

    for i, l in ipairs(allLanterns) do
        count += 1
        local isEquipped = (l.Name == equippedName)
        
        CreateCard(l.Name, l.Image, isEquipped, count, l.Rarity, l.RarityColor, function()
            local info = GetEquippedInfo()
            local curInst = nil
            if info.Name then
                curInst = GetEquippedInstance(info.Name)
            end

            local char = localPlayer.Character
            if char then
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then pcall(function() humanoid:UnequipTools() end) end
            end
            task.wait(0.25)

            local rs = game:GetService("ReplicatedStorage")
            local invFunc = rs:FindFirstChild("Inventory") and rs.Inventory:FindFirstChild("Network") and rs.Inventory.Network:FindFirstChild("Function")
            
            if invFunc then
                pcall(function()
                    invFunc:InvokeServer(3, curInst, l.Name)
                end)
                notify("IOHUB", "Equipped: " .. l.Name, 2)
            else
                notify("IOHUB", "Remote not found!", 2)
            end
            
            task.wait(1)
            BuildGrid()
        end)
    end

    GridFrame.CanvasSize = UDim2.new(0, 0, 0, GridLayout.AbsoluteContentSize.Y + 20)
end

local function RefreshLanterns()
    allLanterns = CollectAllLanterns()
    table.sort(allLanterns, function(a, b) 
        local weightA = RARITY_WEIGHTS[a.Rarity] or 99
        local weightB = RARITY_WEIGHTS[b.Rarity] or 99
        if weightA == weightB then return a.Name < b.Name end
        return weightA < weightB 
    end)
    BuildGrid()
end

_G.RefreshLanternsFunc = RefreshLanterns

task.spawn(function()
    task.wait(3) 
    RefreshLanterns()
end)

----------------------------------------------------
-- CHAPTERS TAB GRID SETUP
----------------------------------------------------
local chaptersPage = pages["Supported"]
for _, child in ipairs(chaptersPage:GetChildren()) do
    if child:IsA("UIListLayout") then
        child:Destroy()
    end
end

local pagePadding = Instance.new("UIPadding")
pagePadding.PaddingLeft = UDim.new(0, 8)
pagePadding.PaddingRight = UDim.new(0, 8)
pagePadding.PaddingTop = UDim.new(0, 5)
pagePadding.PaddingBottom = UDim.new(0, 15)
pagePadding.Parent = chaptersPage

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0.46, 0, 0, 95)
gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 10)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.Parent = chaptersPage

gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    chaptersPage.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 30)
end)

local chapterData = {
    {Name = "RAGE 1",      ID = "127880323915555"},
    {Name = "JELOUSY 4",   ID = "89069859547700"},
    {Name = "JELOUSY 3",   ID = "15962751408"},
    {Name = "JELOUSY 2",   ID = "13217337524"},
    {Name = "CONTROL 1",   ID = "13029336825"},
    {Name = "CONTROL 2",   ID = "13029337769"},
    {Name = "CONTROL 3",   ID = "13217332728"},
    {Name = "CONTROL 4",   ID = "13217333204"},
    {Name = "THE WITCH TRIAL",     ID = "7111233875"},
    {Name = "HOLLOWEEN TRIAL",     ID = "130375120896303"}
}

for i, data in ipairs(chapterData) do
    createChapterCard(chaptersPage, data.Name, data.ID, i)
end

createCustomButton("Info", "Discord", "Join to Our Discord Server", function()
    local link = "https://discord.gg/p46UenVJNj"
    if setclipboard then setclipboard(link) elseif toclipboard then toclipboard(link) end
    StarterGui:SetCore("SendNotification", {
        Title = "IOHUB Link",
        Text = "🔗 Discord Invite link copied to clipboard!",
        Duration = 2
    })
end)

----------------------------------------------------
-- GLOBAL CHAT TAB (v7 - Compact + No Join Spam)
----------------------------------------------------
do
    local chatPage = pages["Global Chat"]
    for _, c in ipairs(chatPage:GetChildren()) do
        if c:IsA("UIListLayout") then c:Destroy() end
    end
    chatPage.ScrollingEnabled = false
    chatPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    chatPage.ScrollBarThickness = 0

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
        PopupReady = false,   -- NEW: para hindi mag-spam sa join
    }

    -------------------------------------------------
    -- ROBLOX ASSET NORMALIZER
    -------------------------------------------------
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

    -------------------------------------------------
    -- CLIPBOARD
    -------------------------------------------------
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

    -------------------------------------------------
    -- MENTION POPUP
    -------------------------------------------------
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

    -------------------------------------------------
    -- FACEBOOK-STYLE PROFILE (COMPACT 290x270)
    -------------------------------------------------
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
        dialog.Size = UDim2.new(0, 290, 0, 270)                        -- ← COMPACT
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
        banner.Size = UDim2.new(1, 0, 0, 52)                            -- ← shorter
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
        avatar.Size = UDim2.fromOffset(58, 58)                          -- ← 58x58 (was 90)
        avatar.Position = UDim2.new(0.5, -29, 0, 22)                    -- ← center, overlaps banner
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
        nameLbl.Position = UDim2.new(0, 14, 0, 84)                      -- ← was 142
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "@" .. tostring(data.name or "?")
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 15                                           -- ← was 18
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
        gameLbl.Position = UDim2.new(0, 14, 0, 106)                     -- ← was 170
        gameLbl.BackgroundTransparency = 1
        gameLbl.Text = "🎮 " .. tostring(data.gameName or "Unknown Game")
        gameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        gameLbl.Font = Enum.Font.GothamMedium
        gameLbl.TextSize = 11                                           -- ← was 12
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

        -- Info card (compact)
        local infoCard = Instance.new("Frame")
        infoCard.Size = UDim2.new(1, -28, 0, 68)                        -- ← 68 (was 96)
        infoCard.Position = UDim2.new(0, 14, 0, 126)                    -- ← was 200
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
        icPad.PaddingTop = UDim.new(0, 6)                               -- ← was 10
        icPad.PaddingLeft = UDim.new(0, 10)
        icPad.PaddingRight = UDim.new(0, 10)
        icPad.Parent = infoCard
        local icLayout = Instance.new("UIListLayout")
        icLayout.Padding = UDim.new(0, 2)                               -- ← was 4
        icLayout.SortOrder = Enum.SortOrder.LayoutOrder
        icLayout.Parent = infoCard

        local function infoRow(labelText, valueText, order)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 10)                           -- ← was 12
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = Color3.fromRGB(140, 145, 155)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 9                                            -- ← was 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.LayoutOrder = order
            lbl.ZIndex = 503
            lbl.Parent = infoCard

            local val = Instance.new("TextLabel")
            val.Size = UDim2.new(1, 0, 0, 12)                           -- ← was 16
            val.BackgroundTransparency = 1
            val.Text = tostring(valueText or "N/A")
            val.TextColor3 = Color3.fromRGB(230, 232, 235)
            val.Font = Enum.Font.Gotham
            val.TextSize = 10                                           -- ← was 12
            val.TextXAlignment = Enum.TextXAlignment.Left
            val.TextTruncate = Enum.TextTruncate.AtEnd
            val.LayoutOrder = order + 1
            val.ZIndex = 503
            val.Parent = infoCard
        end

        infoRow("GAME NAME", tostring(data.gameName or "Unknown Game"), 1)
        infoRow("JOB ID", data.jobId and tostring(data.jobId) or "Not Available", 3)

        -- Buttons row (compact)
        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -28, 0, 30)                          -- ← 30 (was 36)
        btnRow.Position = UDim2.new(0, 14, 0, 202)                      -- ← was 312
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
        joinBtn.TextSize = 12                                           -- ← was 13
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

    -------------------------------------------------
    -- IMAGE FULL VIEW
    -------------------------------------------------
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

    -------------------------------------------------
    -- IMAGE URL DIALOG (COMPACT 300x300)
    -------------------------------------------------
    local function showImageUrlDialog()
        local backdrop = Instance.new("TextButton")
        backdrop.Size = UDim2.new(1, 0, 1, 0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency = 0.5
        backdrop.Text = ""
        backdrop.AutoButtonColor = false
        backdrop.ZIndex = 500
        backdrop.Parent = screenGui

        local dialog = Instance.new("Frame")
        dialog.Size = UDim2.new(0, 300, 0, 300)                        -- ← COMPACT
        dialog.Position = UDim2.new(0.5, -150, 0.5, -150)
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

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -56, 0, 22)
        title.Position = UDim2.new(0, 14, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "Send Roblox Image"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 15
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 502
        title.Parent = dialog

        local closeX = Instance.new("TextButton")
        closeX.Size = UDim2.fromOffset(22, 22)
        closeX.Position = UDim2.new(1, -32, 0, 10)
        closeX.BackgroundColor3 = Color3.fromRGB(60, 62, 70)
        closeX.Text = "X"
        closeX.TextColor3 = Color3.fromRGB(230, 230, 230)
        closeX.Font = Enum.Font.GothamBold
        closeX.TextSize = 11
        closeX.AutoButtonColor = true
        closeX.ZIndex = 502
        closeX.Parent = dialog
        Instance.new("UICorner", closeX).CornerRadius = UDim.new(0, 5)

        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(1, -28, 0, 20)
        hint.Position = UDim2.new(0, 14, 0, 34)
        hint.BackgroundTransparency = 1
        hint.Text = "Roblox asset ID or URL lang"
        hint.TextColor3 = Color3.fromRGB(160, 165, 175)
        hint.Font = Enum.Font.Gotham
        hint.TextSize = 10
        hint.TextWrapped = true
        hint.TextXAlignment = Enum.TextXAlignment.Left
        hint.TextYAlignment = Enum.TextYAlignment.Top
        hint.ZIndex = 502
        hint.Parent = dialog

        local urlBox = Instance.new("TextBox")
        urlBox.Size = UDim2.new(1, -28, 0, 28)
        urlBox.Position = UDim2.new(0, 14, 0, 58)
        urlBox.BackgroundColor3 = Color3.fromRGB(45, 47, 54)
        urlBox.BorderSizePixel = 0
        urlBox.Text = ""
        urlBox.PlaceholderText = "rbxassetid://1234567890"
        urlBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 125)
        urlBox.TextColor3 = Color3.fromRGB(230, 232, 235)
        urlBox.Font = Enum.Font.Gotham
        urlBox.TextSize = 11
        urlBox.TextXAlignment = Enum.TextXAlignment.Left
        urlBox.ClearTextOnFocus = false
        urlBox.ZIndex = 502
        urlBox.Parent = dialog
        Instance.new("UICorner", urlBox).CornerRadius = UDim.new(0, 6)
        local uPad = Instance.new("UIPadding")
        uPad.PaddingLeft = UDim.new(0, 10)
        uPad.PaddingRight = UDim.new(0, 10)
        uPad.Parent = urlBox

        local previewBox = Instance.new("Frame")
        previewBox.Size = UDim2.new(1, -28, 0, 90)                     -- ← 90 (was 130)
        previewBox.Position = UDim2.new(0, 14, 0, 92)
        previewBox.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        previewBox.BorderSizePixel = 0
        previewBox.ZIndex = 502
        previewBox.Parent = dialog
        Instance.new("UICorner", previewBox).CornerRadius = UDim.new(0, 6)
        local pbStroke = Instance.new("UIStroke")
        pbStroke.Color = Color3.fromRGB(50, 52, 60)
        pbStroke.Thickness = 1
        pbStroke.Parent = previewBox

        local previewImg = Instance.new("ImageLabel")
        previewImg.Size = UDim2.new(1, -8, 1, -8)
        previewImg.Position = UDim2.new(0, 4, 0, 4)
        previewImg.BackgroundTransparency = 1
        previewImg.Image = ""
        previewImg.ScaleType = Enum.ScaleType.Fit
        previewImg.ZIndex = 503
        previewImg.Parent = previewBox

        local previewHint = Instance.new("TextLabel")
        previewHint.Size = UDim2.new(1, 0, 1, 0)
        previewHint.BackgroundTransparency = 1
        previewHint.Text = "Preview dito"
        previewHint.TextColor3 = Color3.fromRGB(100, 105, 115)
        previewHint.Font = Enum.Font.Gotham
        previewHint.TextSize = 10
        previewHint.ZIndex = 503
        previewHint.Parent = previewBox

        local pasteBtn = Instance.new("TextButton")
        pasteBtn.Size = UDim2.new(1, -28, 0, 22)
        pasteBtn.Position = UDim2.new(0, 14, 0, 188)
        pasteBtn.BackgroundColor3 = Color3.fromRGB(50, 52, 60)
        pasteBtn.Text = "📋  Paste from clipboard"
        pasteBtn.TextColor3 = Color3.fromRGB(200, 205, 215)
        pasteBtn.Font = Enum.Font.GothamMedium
        pasteBtn.TextSize = 10
        pasteBtn.AutoButtonColor = true
        pasteBtn.ZIndex = 502
        pasteBtn.Parent = dialog
        Instance.new("UICorner", pasteBtn).CornerRadius = UDim.new(0, 5)

        local function updatePreview()
            local normalized = normalizeRobloxAsset(urlBox.Text)
            if normalized then
                previewImg.Image = normalized
                previewHint.Visible = false
                pbStroke.Color = Color3.fromRGB(88, 101, 242)
                pbStroke.Transparency = 0.3
            else
                previewImg.Image = ""
                previewHint.Visible = true
                if urlBox.Text == "" then
                    previewHint.Text = "Preview dito"
                    previewHint.TextColor3 = Color3.fromRGB(100, 105, 115)
                    pbStroke.Color = Color3.fromRGB(50, 52, 60)
                    pbStroke.Transparency = 0
                else
                    previewHint.Text = "❌ Invalid Roblox asset ID"
                    previewHint.TextColor3 = Color3.fromRGB(237, 100, 100)
                    pbStroke.Color = Color3.fromRGB(237, 100, 100)
                    pbStroke.Transparency = 0.3
                end
            end
        end

        urlBox:GetPropertyChangedSignal("Text"):Connect(updatePreview)

        task.spawn(function()
            local clip = getClipboardText()
            if clip ~= "" then
                local normalized = normalizeRobloxAsset(clip)
                if normalized then
                    local id = normalized:match("rbxassetid://(%d+)")
                    urlBox.Text = id or clip
                end
            end
        end)

        pasteBtn.MouseButton1Click:Connect(function()
            local clip = getClipboardText()
            if clip == "" then return end
            local normalized = normalizeRobloxAsset(clip)
            if normalized then
                local id = normalized:match("rbxassetid://(%d+)")
                urlBox.Text = id or clip
            else
                urlBox.Text = clip
            end
        end)

        local function destroy()
            if backdrop and backdrop.Parent then backdrop:Destroy() end
            if dialog and dialog.Parent then dialog:Destroy() end
        end
        closeX.MouseButton1Click:Connect(destroy)
        backdrop.MouseButton1Click:Connect(destroy)

        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -28, 0, 28)                          -- ← 28 (was 34)
        btnRow.Position = UDim2.new(0, 14, 1, -40)                      -- ← bottom 40
        btnRow.BackgroundTransparency = 1
        btnRow.ZIndex = 502
        btnRow.Parent = dialog
        local bLayout = Instance.new("UIListLayout")
        bLayout.FillDirection = Enum.FillDirection.Horizontal
        bLayout.Padding = UDim.new(0, 6)
        bLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        bLayout.SortOrder = Enum.SortOrder.LayoutOrder
        bLayout.Parent = btnRow

        local sendBtn = Instance.new("TextButton")
        sendBtn.Size = UDim2.new(0, 90, 1, 0)
        sendBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        sendBtn.Text = "Send"
        sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sendBtn.Font = Enum.Font.GothamBold
        sendBtn.TextSize = 11
        sendBtn.LayoutOrder = 1
        sendBtn.AutoButtonColor = true
        sendBtn.ZIndex = 503
        sendBtn.Parent = btnRow
        Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 5)

        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Size = UDim2.new(0, 90, 1, 0)
        cancelBtn.BackgroundColor3 = Color3.fromRGB(60, 63, 70)
        cancelBtn.Text = "Cancel"
        cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelBtn.Font = Enum.Font.GothamBold
        cancelBtn.TextSize = 11
        cancelBtn.LayoutOrder = 2
        cancelBtn.AutoButtonColor = true
        cancelBtn.ZIndex = 503
        cancelBtn.Parent = btnRow
        Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 5)
        cancelBtn.MouseButton1Click:Connect(destroy)

        local function trySend()
            if not normalizeRobloxAsset(urlBox.Text) then
                notify("Invalid Input", "Roblox asset ID lang ang tinatanggap.")
                return
            end
            if S:SendImage(urlBox.Text) then destroy() end
        end

        sendBtn.MouseButton1Click:Connect(trySend)
        urlBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then trySend() end
        end)
    end

    -------------------------------------------------
    -- ONLINE PLAYERS LIST
    -------------------------------------------------
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

    -------------------------------------------------
    -- HTTP + UTILS
    -------------------------------------------------
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

    -------------------------------------------------
    -- NEW MESSAGE
    -------------------------------------------------
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

-- ═══ POPUPS: only after initial history load ═══
if self.PopupReady then
    local isEveryoneMsg = raw:lower():find("@everyone", 1, true) ~= nil
    local replyTargetUid = tonumber(d.replyToUserId or 0) or 0
    local replyToMe = (replyTargetUid > 0 and replyTargetUid == L.UserId)

    if isEveryoneMsg and not mine then
        ShowMentionPopup("@everyone mentioned you", "@"..un..": "..raw:sub(1, 60), Color3.fromRGB(255, 180, 50))
    end
    if replyToMe then
        -- ✅ GAMITIN ANG `raw` (bagong reply), HINDI `d.replyText` (quoted)
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
        self:_o({"UIPadding",{
            PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6),
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

        local av = self:_o({"ImageButton",{
            Size=UDim2.fromOffset(36,36),BackgroundColor3=Color3.fromRGB(47,49,54),BorderSizePixel=0,Image="",LayoutOrder=1,
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

        local contentColumn = self:_o({"Frame",{Size=UDim2.new(1,-44,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=2}},mainContainer)
        self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Vertical,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder}},contentColumn)

        local headerRow = self:_o({"Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,LayoutOrder=1}},contentColumn)
        local leftHeader = self:_o({"Frame",{Size=UDim2.new(1,-50,1,0),BackgroundTransparency=1}},headerRow)
        self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center}},leftHeader)

        local userLabel = self:_o({"TextButton",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="@"..un,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,LayoutOrder=1}},leftHeader)
        local uGrad = Instance.new("UIGradient")
        uGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100))}
        uGrad.Parent = userLabel
        userLabel.MouseButton1Click:Connect(OpenProfilePopup)

        self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="|",TextColor3=Color3.fromRGB(150,150,150),Font=Enum.Font.Gotham,TextSize=13,LayoutOrder=2}},leftHeader)

        local gameLabel = self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=gName,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,LayoutOrder=3,TextTruncate=Enum.TextTruncate.AtEnd}},leftHeader)
        local gGrad = Instance.new("UIGradient")
        gGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))}
        gGrad.Parent = gameLabel

        local rightHeader = self:_o({"Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.fromOffset(50,22),BackgroundTransparency=1}},headerRow)
        self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Center}},rightHeader)

        local replyBtn = self:_o({"ImageButton",{Size=UDim2.fromOffset(14,14),BackgroundTransparency=1,Image=I.reply,ImageColor3=Color3.fromRGB(130,135,145),AutoButtonColor=false,LayoutOrder=1}},rightHeader)
        replyBtn.MouseButton1Click:Connect(function()
            self:SetReply({Id=id,Username=un,DisplayName=un,Text=raw,UserId=uid})
        end)
        replyBtn.MouseEnter:Connect(function() replyBtn.ImageColor3=Color3.fromRGB(88,150,255) end)
        replyBtn.MouseLeave:Connect(function() replyBtn.ImageColor3=Color3.fromRGB(130,135,145) end)

        self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=RelTime(ts),TextColor3=Color3.fromRGB(120,125,135),Font=Enum.Font.Gotham,TextSize=10,LayoutOrder=2}},rightHeader)

        local txt=self:_o({"TextLabel",{
            Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,
            Text=raw,TextColor3=Color3.fromRGB(235,235,235),Font=Enum.Font.GothamBold,TextSize=14,
            TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,LayoutOrder=2
        }},contentColumn)
        local chatStroke = Instance.new("UIStroke")
        chatStroke.Color = Color3.fromRGB(0, 0, 0)
        chatStroke.Thickness = 1.2
        chatStroke.Transparency = 0.3
        chatStroke.Parent = txt

        if msgImageUrl ~= "" then
            local imgBtn = Instance.new("ImageButton")
            imgBtn.Size = UDim2.new(1, 0, 0, 170)
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
        self.PopupReady = false    -- ═══ reset bawat init ═══

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
        self:_o({"UICorner",{CornerRadius=UDim.new(0,8)}},main)
        AddBorder(main,Color3.fromRGB(0,0,0),Color3.fromRGB(60,65,75),1,1.5)

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

        local input=self:_o({"TextBox",{
            Position=UDim2.fromOffset(6,8),Size=UDim2.new(1,-118,0,30),
            BackgroundColor3=Color3.fromRGB(50,53,60),
            BorderSizePixel=0,ClearTextOnFocus=false,MultiLine=false,Text="",PlaceholderText="Message...",
            PlaceholderColor3=Color3.fromRGB(120,125,135),TextColor3=Color3.fromRGB(230,232,235),
            Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center
        }},bottom)
        self.Input=input
        self:_o({"UICorner",{CornerRadius=UDim.new(0,6)}},input)
        self:_o({"UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,6)}},input)
        AddBorder(input,Color3.fromRGB(0,0,0),Color3.fromRGB(60,65,75),1,1.2)

        local imageBtn = Instance.new("TextButton")
        imageBtn.Name = "ImageButton"
        imageBtn.Size = UDim2.new(0, 30, 0, 30)
        imageBtn.Position = UDim2.new(1, -74, 0, 8)
        imageBtn.AnchorPoint = Vector2.new(1, 0)
        imageBtn.BackgroundColor3 = Color3.fromRGB(60, 63, 70)
        imageBtn.BorderSizePixel = 0
        imageBtn.Text = "+"
        imageBtn.Font = Enum.Font.GothamBold
        imageBtn.TextSize = 22
        imageBtn.TextColor3 = Color3.fromRGB(150, 180, 255)
        imageBtn.AutoButtonColor = false
        imageBtn.Parent = bottom
        Instance.new("UICorner", imageBtn).CornerRadius = UDim.new(0, 6)
        AddBorder(imageBtn, Color3.fromRGB(0, 0, 0), Color3.fromRGB(60, 65, 75), 1, 1.2)
        BindBorder(imageBtn, 1.2, 2, 2.6)
        imageBtn.MouseButton1Click:Connect(function()
            showImageUrlDialog()
        end)

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
            pcall(function() self:_loadChat(true) end)   -- initial history load (walang popup)
            task.wait(0.5)                               -- wait ng kaunti
            self.PopupReady = true                       -- ✅ saka lang mag-a-allow ng popup
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

switchTab("Saves")

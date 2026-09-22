local RunService = game:GetService("RunService")

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local HttpService = cloneref(game:GetService("HttpService"))

local WindUI

do
	local ok, result = pcall(function()
		return require("./src/Init")
	end)

	if ok then
		WindUI = result
	else
		if cloneref(game:GetService("RunService")):IsStudio() then
			WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
		else
			WindUI =
				loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
		end
	end
end


function createPopup()
	return WindUI:Popup({
		Title = "Welcome to the WindUI!",
		Icon = "bird",
		Content = "Hello!",
		Buttons = {
			{
				Title = "Hahaha",
				Icon = "bird",
				Variant = "Tertiary",
			},
			{
				Title = "Hahaha",
				Icon = "bird",
				Variant = "Tertiary",
			},
			{
				Title = "Hahaha",
				Icon = "bird",
				Variant = "Tertiary",
			},
		},
	})
end

-- */  Window  /* --
local Window = WindUI:CreateWindow({
	Title = "IOHUB",
	--Author = "by .ftgs • Footagesus",
	Folder = "ftgshub",
	Icon = "solar:folder-2-bold-duotone",
	--Theme = "Mellowsi",
	--IconSize = 22*2,
	NewElements = true,
	--Size = UDim2.fromOffset(700,700),

	HideSearchBar = false,

	OpenButton = {
		Title = "IOHUB", -- can be changed
		CornerRadius = UDim.new(1, 0), -- fully rounded
		StrokeThickness = 3, -- removing outline
		Enabled = true, -- enable or disable openbutton
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.5,

		Color = ColorSequence.new( -- gradient
			Color3.fromHex("#30FF6A"),
			Color3.fromHex("#e7ff2f")
		),
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac", -- Default or Mac
	},
})



-- */  Colors  /* --
local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

















-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- State Variables
local isCollectingCandy = false
local isAutoBurning = false
local safeSpot = CFrame.new(-354.800, -19.969, -167.623)

-- AI Detection based on 15 Studs Distance
local function checkAIproximity()
    local gameAI = Workspace:FindFirstChild("GameAI")
    if gameAI then
        local ai = gameAI:FindFirstChild("AI")
        local char = player.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if ai and rootPart then
            local aiPos = nil
            if ai:IsA("Model") and ai.PrimaryPart then
                aiPos = ai.PrimaryPart.Position
            elseif ai:IsA("BasePart") then
                aiPos = ai.Position
            else
                local part = ai:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    aiPos = part.Position
                end
            end
            
            if aiPos then
                local distance = (rootPart.Position - aiPos).Magnitude
                if distance <= 15 then
                    return true
                end
            end
        end
    end
    return false
end

-- Teleport to Safe Spot
local function teleportToSafeSpot()
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = safeSpot
    end
end

local Tabs = {
HalloweenTab = Window:Tab({
       Title = "Halloween Trials",
     Icon = "ghost",
    Border = true,
   }),
}

-- this is for auto select tab 
-- when script is loaded if not
-- the right panel is empty
task.defer(function()
	Tabs.HalloweenTab:Select()
end)

Tabs.HalloweenTab:Paragraph({
    Title = "PLACE 1",
    Desc = ""
})

-- 3. BUTTON TAB ELEMENTS
local AutoCandy
AutoCandy = Tabs.HalloweenTab:Button({
	Title = "Collect Candy",
	Icon = "mouse",
	Callback = function()
		
		AutoCandy:Highlight()
		
		     if isCollectingCandy then return end
        isCollectingCandy = true

        task.spawn(function()
            local char = player.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")

            for _, desc in ipairs(Workspace:GetDescendants()) do
                if not isCollectingCandy then break end
                
                if checkAIproximity() then
                    teleportToSafeSpot()
                    break
                end
                
                if desc:IsA("ProximityPrompt") then
                    if desc.ActionText == "Collect" and desc.ObjectText == "Candy" then
                        local parentPart = desc.Parent
                        if parentPart and rootPart then
                            if parentPart:IsA("BasePart") then
                                rootPart.CFrame = parentPart.CFrame + Vector3.new(0, 3, 0)
                            elseif parentPart:IsA("Model") and parentPart.PrimaryPart then
                                rootPart.CFrame = parentPart.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                            end
                            
                            task.wait(0.2)
                            fireproximityprompt(desc)
                            task.wait(0.3)
                        end
                    end
                end
            end

            isCollectingCandy = false
        end)
		
		
		
	end,
})



local AutoBurn
	AutoBurn = Tabs.HalloweenTab:Button({
		Title = "Collect and Burn Item",
		Icon = "mouse",
		Callback = function()
			
			AutoBurn:Highlight()
			
			  if isAutoBurning then return end
        isAutoBurning = true

        task.spawn(function()
            while isAutoBurning do
                if checkAIproximity() then
                    teleportToSafeSpot()
                    break
                end

                -- Find GrabItem ProximityPrompt
                local gameInfo = Workspace:FindFirstChild("GameInfo")
                local puzzleItems = gameInfo and gameInfo:FindFirstChild("PuzzleItems")
                local grabItem = puzzleItems and puzzleItems:FindFirstChild("GrabItem")
                local grabPrompt = grabItem and grabItem:FindFirstChild("ProximityPrompt")

                if grabPrompt and grabPrompt:IsA("ProximityPrompt") then
                    local parentPart = grabPrompt.Parent
                    local char = player.Character
                    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                    if parentPart and parentPart:IsA("BasePart") and rootPart then
                        rootPart.CFrame = parentPart.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.2)
                    end
                    fireproximityprompt(grabPrompt)
                    task.wait(0.5)
                else
                    break
                end

                if checkAIproximity() then
                    teleportToSafeSpot()
                    break
                end

                -- Find Burner ProximityPrompt
                local map = Workspace:FindFirstChild("Map")
                local well = map and map:FindFirstChild("Well")
                local burner = well and well:FindFirstChild("Burner")
                local burnerPrompt = burner and burner:FindFirstChild("ProximityPrompt")

                if burnerPrompt and burnerPrompt:IsA("ProximityPrompt") then
                    local parentPart = burnerPrompt.Parent
                    local char = player.Character
                    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                    if parentPart and parentPart:IsA("BasePart") and rootPart then
                        rootPart.CFrame = parentPart.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.2)
                    end
                    fireproximityprompt(burnerPrompt)
                    task.wait(0.5)
                else
                    break
                end
            end

            isAutoBurning = false
        end)
			
			
			
			
		end,
})



-- ==================== AI ESP + AUTO SAFE SPOT TOGGLE ====================
local aiHighlight = nil
local safeSpot = CFrame.new(-354.800, -19.969, -167.623)

-- AI Detection based on 15 Studs Distance
local function checkAIproximity()
    local gameAI = Workspace:FindFirstChild("GameAI")
    if gameAI then
        local ai = gameAI:FindFirstChild("AI")
        local player = Players.LocalPlayer
        local char = player.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if ai and rootPart then
            local aiPos = nil
            if ai:IsA("Model") and ai.PrimaryPart then
                aiPos = ai.PrimaryPart.Position
            elseif ai:IsA("BasePart") then
                aiPos = ai.Position
            else
                local part = ai:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    aiPos = part.Position
                end
            end
            
            if aiPos then
                local distance = (rootPart.Position - aiPos).Magnitude
                if distance <= 15 then
                    return true
                end
            end
        end
    end
    return false
end

-- Teleport to Safe Spot
local function teleportToSafeSpot()
    local player = Players.LocalPlayer
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = safeSpot
    end
end

Tabs.HalloweenTab:Toggle({
	Title = "ESP & Auto Safe Spot",
	Desc = "Highlights AI Monster and Auto Safe Zone",
	Value = false,
	Callback = function(state)
		_G.AIEspSafeSpotActive = state
		
		if state then
			task.spawn(function()
				while _G.AIEspSafeSpotActive do
					local ai = Workspace:FindFirstChild("GameAI") and Workspace.GameAI:FindFirstChild("AI")
					
					if ai then
						-- Auto Safe Spot kapag lumapit sa loob ng 15 studs
						if checkAIproximity() then
							teleportToSafeSpot()
						end

						-- ESP Highlight Logic
						if not aiHighlight or aiHighlight.Parent ~= ai then
							if aiHighlight then aiHighlight:Destroy() end
							aiHighlight = Instance.new("Highlight")
							aiHighlight.Name = "AIEspHighlight"
							aiHighlight.FillColor = Color3.fromRGB(255, 0, 0)
							aiHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							aiHighlight.FillTransparency = 0.4
							aiHighlight.Parent = ai
						end
					else
						if aiHighlight then
							aiHighlight:Destroy()
							aiHighlight = nil
						end
					end
					
					task.wait(0.1)
				end
			end)
		else
			-- Linisin ang Highlight kapag pinatay ang toggle
			if aiHighlight then
				aiHighlight:Destroy()
				aiHighlight = nil
			end
		end
	end,
})



Tabs.HalloweenTab:Space()


-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local isAutoCandles = false
local noCandlesSpot = CFrame.new(306.784, 312.507, -109.373)

-- Teleport function para sa walang mahanap na candles
local function teleportToNoCandlesSpot()
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = noCandlesSpot
    end
end



Tabs.HalloweenTab:Paragraph({
    Title = "PLACE 2",
    Desc = ""
})



-- Auto Candles Toggle
Tabs.HalloweenTab:Toggle({
    Title = "Auto Candles",
    Desc = "Automatically Light the Candles",
    Value = false,
    Callback = function(state)
        isAutoCandles = state

        if isAutoCandles then
            task.spawn(function()
                while isAutoCandles do
                    local char = player.Character
                    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                    
                    local candlesFolder = Workspace:FindFirstChild("Candles")
                    local targetPrompt = nil

                    -- Hanapin ang unang ProximityPrompt na Enabled at tugma ang text
                    if candlesFolder and rootPart then
                        for _, desc in ipairs(candlesFolder:GetDescendants()) do
                            if not isAutoCandles then break end

                            if desc:IsA("ProximityPrompt") then
                                -- Siguraduhing Enabled ito at tugma ang Action/Object text
                                if desc.Enabled == true and desc.ActionText == "Light" and desc.ObjectText == "Candle" then
                                    targetPrompt = desc
                                    break -- Nahanap na ang unang enabled prompt
                                end
                            end
                        end
                    end

                    -- Kung nakahanap ng enabled prompt, puntahan at i-fire
                    if targetPrompt and targetPrompt.Enabled == true then
                        local parentPart = targetPrompt.Parent

                        if parentPart and rootPart then
                            -- Teleport sa pwesto ng candle part
                            if parentPart:IsA("BasePart") then
                                rootPart.CFrame = parentPart.CFrame + Vector3.new(0, 3, 0)
                            elseif parentPart:IsA("Model") and parentPart.PrimaryPart then
                                rootPart.CFrame = parentPart.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                            end

                            task.wait(0.2)

                            -- I-fire ang prompt kung enabled pa rin
                            if targetPrompt.Enabled == true then
                                fireproximityprompt(targetPrompt)
                            end
                            
                            task.wait(0.4) -- Saglit na antay bago maghanap ng susunod
                        else
                            task.wait(0.5)
                        end
                    else
                        -- Kung walang makitang enabled candles, mag-teleport sa fallback CFrame at mag-antay
                        teleportToNoCandlesSpot()
                        task.wait(1)
                    end
                end
            end)
        end
    end,
})


-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- State Variables
local safeSpot = CFrame.new(306.784, 312.507, -109.373)

-- AI Detection based on 15 Studs Distance
local function checkAIproximity()
    local gameAI = Workspace:FindFirstChild("GameAI")
    if gameAI then
        local ai = gameAI:FindFirstChild("AI")
        local char = player.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        
        if ai and rootPart then
            local aiPos = nil
            if ai:IsA("Model") and ai.PrimaryPart then
                aiPos = ai.PrimaryPart.Position
            elseif ai:IsA("BasePart") then
                aiPos = ai.Position
            else
                local part = ai:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    aiPos = part.Position
                end
            end
            
            if aiPos then
                local distance = (rootPart.Position - aiPos).Magnitude
                if distance <= 15 then
                    return true
                end
            end
        end
    end
    return false
end

-- Teleport to Safe Spot
local function teleportToSafeSpot()
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = safeSpot
    end
end


-- ==================== AI ESP + AUTO SAFE SPOT TOGGLE ====================
local aiHighlight = nil

Tabs.HalloweenTab:Toggle({
	Title = "ESP & Auto Safe Spot",
	Desc = "Highlights AI Monster and Auto Safe Zone",
	Value = false,
	Callback = function(state)
		_G.AIEspSafeSpotActive = state
		
		if state then
			task.spawn(function()
				while _G.AIEspSafeSpotActive do
					local ai = Workspace:FindFirstChild("GameAI") and Workspace.GameAI:FindFirstChild("AI")
					
					if ai then
						-- Auto Safe Spot kapag lumapit sa loob ng 15 studs
						if checkAIproximity() then
							teleportToSafeSpot()
						end

						-- ESP Highlight Logic
						if not aiHighlight or aiHighlight.Parent ~= ai then
							if aiHighlight then aiHighlight:Destroy() end
							aiHighlight = Instance.new("Highlight")
							aiHighlight.Name = "AIEspHighlight"
							aiHighlight.FillColor = Color3.fromRGB(255, 0, 0)
							aiHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							aiHighlight.FillTransparency = 0.4
							aiHighlight.Parent = ai
						end
					else
						if aiHighlight then
							aiHighlight:Destroy()
							aiHighlight = nil
						end
					end
					
					task.wait(0.1)
				end
			end)
		else
			-- Linisin ang Highlight kapag pinatay ang toggle
			if aiHighlight then
				aiHighlight:Destroy()
				aiHighlight = nil
			end
		end
	end,
})

Tabs.HalloweenTab:Space()





-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Global Variables
local safeSpot = CFrame.new(100.617, 37.097, 240.080)
local espEnabled = false
local monsterHighlights = {}
local isAutoMakingPotion = false

-- ==================== GENERAL FUNCTIONS ====================

local function teleportToSafeSpot()
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = safeSpot
    end
end

local function checkMonstersProximity(threshold)
    local aiFolder = Workspace:FindFirstChild("AI")
    if not aiFolder then return false end

    local monsterNames = {"Big Silly", "Kabocha", "Skintist"}
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end

    for _, name in ipairs(monsterNames) do
        local monster = aiFolder:FindFirstChild(name)
        if monster then
            local mPos = nil
            if monster:IsA("Model") and monster.PrimaryPart then
                mPos = monster.PrimaryPart.Position
            elseif monster:IsA("BasePart") then
                mPos = monster.Position
            else
                local part = monster:FindFirstChildWhichIsA("BasePart", true)
                if part then mPos = part.Position end
            end

            if mPos then
                local distance = (rootPart.Position - mPos).Magnitude
                if distance <= (threshold or 20) then
                    return true
                end
            end
        end
    end
    return false
end

local function submitToCauldron()
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    local cauldronMain = Workspace:FindFirstChild("MainObjective")
        and Workspace.MainObjective:FindFirstChild("Cauldron")
        and Workspace.MainObjective.Cauldron:FindFirstChild("Main")
    
    local cauldronPrompt = cauldronMain and cauldronMain:FindFirstChild("ProximityPrompt")

    if cauldronMain and rootPart then
        if cauldronMain:IsA("BasePart") then
            rootPart.CFrame = cauldronMain.CFrame + Vector3.new(0, 3, 0)
        elseif cauldronMain:IsA("Model") and cauldronMain.PrimaryPart then
            rootPart.CFrame = cauldronMain.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
        end
        task.wait(0.4)
    end

    if cauldronPrompt then
        fireproximityprompt(cauldronPrompt)
        task.wait(0.3)
    end
end


Tabs.HalloweenTab:Paragraph({
    Title = "PLACE 3",
    Desc = ""
})


-- ==================== 1. AI ESP + AUTO SAFE SPOT LOGIC ====================

Tabs.HalloweenTab:Toggle({
	Title = "ESP 3 & SafeSpot",
	Desc = "Highlights Monster and Auto Safe Zone",
	Value = false,
	Callback = function(state)
		espEnabled = state
		
		if not espEnabled then
			for _, h in pairs(monsterHighlights) do
				if h then h:Destroy() end
			end
			monsterHighlights = {}
		end
	end,
})



-- Iisang Background Loop para sa ESP at Auto Safe Spot
RunService.RenderStepped:Connect(function()
    if espEnabled then
        if checkMonstersProximity(20) then
            teleportToSafeSpot()
        end

        local aiFolder = Workspace:FindFirstChild("AI")
        if aiFolder then
            local monsterNames = {"Big Silly", "Kabocha", "Skintist"}
            for _, name in ipairs(monsterNames) do
                local monster = aiFolder:FindFirstChild(name)
                if monster then
                    if not monsterHighlights[name] or monsterHighlights[name].Parent ~= monster then
                        if monsterHighlights[name] then monsterHighlights[name]:Destroy() end
                        local hl = Instance.new("Highlight")
                        hl.Name = name .. "_ESP"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.4
                        hl.Parent = monster
                        monsterHighlights[name] = hl
                    end
                else
                    if monsterHighlights[name] then
                        monsterHighlights[name]:Destroy()
                        monsterHighlights[name] = nil
                    end
                end
            end
        end
    end
end)


-- ==================== 2. INDIVIDUAL COLLECT & SUBMIT ====================

local function collectAndSubmitSingle(folderPath, promptName)
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local targetFolder = Workspace
    for _, part in ipairs(folderPath) do
        targetFolder = targetFolder and targetFolder:FindFirstChild(part)
    end

    if targetFolder then
        for _, item in ipairs(targetFolder:GetChildren()) do
            if checkMonstersProximity(20) then
                teleportToSafeSpot()
                return
            end

            local prompt = item:FindFirstChild(promptName, true)
            if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local parentPart = prompt.Parent
                if parentPart then
                    if parentPart:IsA("BasePart") then
                        rootPart.CFrame = parentPart.CFrame + Vector3.new(0, 3, 0)
                    elseif parentPart:IsA("Model") and parentPart.PrimaryPart then
                        rootPart.CFrame = parentPart.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                    end

                    task.wait(0.25)
                    if checkMonstersProximity(20) then
                        teleportToSafeSpot()
                        return
                    end

                    fireproximityprompt(prompt)
                    task.wait(0.3)
                    
                    teleportToSafeSpot()
                    task.wait(0.3)
                    submitToCauldron()
                    break
                end
            end
        end
    end
end

local BatButton
BatButton = Tabs.HalloweenTab:Button({
	Title = "Collect & Submit Bat",
	Icon = "mouse",
	Callback = function()
		BatButton:Highlight()
		collectAndSubmitSingle({"MainObjective", "Ingredients", "Bats"}, "ProximityPrompt")
	end,
})


local EyeButton
EyeButton = Tabs.HalloweenTab:Button({
	Title = "Collect & Submit Eye",
	Icon = "mouse",
	Callback = function()
		EyeButton:Highlight()
		collectAndSubmitSingle({"MainObjective", "Ingredients", "Eyes"}, "ProximityPrompt")
	end,
})


local RoseButton
RoseButton = Tabs.HalloweenTab:Button({
	Title = "Collect & Submit Rose",
	Icon = "mouse",
	Callback = function()
		RoseButton:Highlight()
		collectAndSubmitSingle({"MainObjective", "Ingredients", "Roses"}, "ProximityPrompt")
	end,
})


local SnakeButton
SnakeButton = Tabs.HalloweenTab:Button({
	Title = "Collect & Submit Snake",
	Icon = "mouse",
	Callback = function()
		SnakeButton:Highlight()
		collectAndSubmitSingle({"MainObjective", "Ingredients", "Snakes"}, "ProximityPrompt")
	end,
})



-- ==================== 3. AUTO MAKE POTION ====================



local function collectSpecificItemsWithSafeSpot(folderPath, promptName, targetCount)
    local collected = 0
    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local targetFolder = Workspace
    for _, part in ipairs(folderPath) do
        targetFolder = targetFolder and targetFolder:FindFirstChild(part)
    end

    if targetFolder then
        for _, item in ipairs(targetFolder:GetChildren()) do
            if collected >= targetCount or not isAutoMakingPotion then break end

            if checkMonstersProximity(20) then
                teleportToSafeSpot()
                task.wait(1)
                return 
            end

            local prompt = item:FindFirstChild(promptName, true)
            if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local parentPart = prompt.Parent
                if parentPart then
                    if parentPart:IsA("BasePart") then
                        rootPart.CFrame = parentPart.CFrame + Vector3.new(0, 10, 0)
                    elseif parentPart:IsA("Model") and parentPart.PrimaryPart then
                        rootPart.CFrame = parentPart.PrimaryPart.CFrame + Vector3.new(0, 10, 0)
                    end

                    task.wait(0.25)
                    
                    if checkMonstersProximity(20) then
                        teleportToSafeSpot()
                        task.wait(1)
                        return
                    end

                    fireproximityprompt(prompt)
                    collected = collected + 1
                    task.wait(0.3)
                end
            end
        end
    end
end

local function runAutoMakePotion()
    
    task.spawn(function()
        -- Isang beses lang tatakbo ang buong sequence tapos hihinto na kusa
        if isAutoMakingPotion then
            if not checkMonstersProximity(20) then
                collectSpecificItemsWithSafeSpot({"MainObjective", "Ingredients", "Eyes"}, "ProximityPrompt", 2)
            end
            
            if isAutoMakingPotion and not checkMonstersProximity(20) then
                collectSpecificItemsWithSafeSpot({"MainObjective", "Ingredients", "Bats"}, "ProximityPrompt", 2)
            end
            
            if isAutoMakingPotion and not checkMonstersProximity(20) then
                collectSpecificItemsWithSafeSpot({"MainObjective", "Ingredients", "Roses"}, "ProximityPrompt", 3)
            end
            
            if isAutoMakingPotion and not checkMonstersProximity(20) then
                collectSpecificItemsWithSafeSpot({"MainObjective", "Ingredients", "Snakes"}, "ProximityPrompt", 1)
            end

            if isAutoMakingPotion then
                submitToCauldron()
                task.wait(0.5)

                teleportToSafeSpot()
                task.wait(1)
            end
        end

        
        isAutoMakingPotion = false
        
    end)
end

local MakePotionButton
MakePotionButton = Tabs.HalloweenTab:Button({
	Title = "Auto Make Potion",
	Icon = "mouse",
	Callback = function()
		MakePotionButton:Highlight()
		isAutoMakingPotion = not isAutoMakingPotion
		
		if isAutoMakingPotion then
			runAutoMakePotion()
		else
			
		end
	end,
})

Tabs.HalloweenTab:Space()


















-- Player Section --

local Tabs = {
	PlayerTab = Window:Tab({
		Title = "Player",
		Icon = "user-round-cog",
	}),
}


-- ====================================================================
-- PLAYER ESP TOGGLE (UPDATED WITH DISTANCE & CLEAN UI)
-- ====================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerEspConnection = nil
local renderConnection = nil
local activeBillboards = {}

Tabs.PlayerTab:Toggle({
	Title = "Player ESP",
	Desc = "Highlights other players with distance info",
	Value = false,
	Callback = function(state)
	     -- tanggalin ang lahat ng ESP
		local function clearESP()
			if playerEspConnection then
				playerEspConnection:Disconnect()
				playerEspConnection = nil
			end
			if renderConnection then
				renderConnection:Disconnect()
				renderConnection = nil
			end

			-- Linisin ang highlights at billboards
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character then
					local hl = p.Character:FindFirstChild("PlayerEspHighlight")
					if hl then hl:Destroy() end
				end
			end

			for _, gui in pairs(activeBillboards) do
				if gui then gui:Destroy() end
			end
			activeBillboards = {}
		end

		if state then
	     -- toggle on
			local function setupPlayerESP(targetPlayer)
				if targetPlayer == localPlayer then return end
				
				local function addESP(char)
					if not char then return end
					local tagIdentifier = "PlayerESP_" .. targetPlayer.Name
					
		
					if CoreGui:FindFirstChild(tagIdentifier) then
						CoreGui[tagIdentifier]:Destroy()
					end

					-- highlight para sa buong katawan
					local highlight = char:FindFirstChild("PlayerEspHighlight")
					if not highlight then
						highlight = Instance.new("Highlight")
						highlight.Name = "PlayerEspHighlight"
						highlight.FillColor = Color3.fromRGB(255, 50, 50) -- Reddish tone
						highlight.FillTransparency = 0.5
						highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						highlight.OutlineTransparency = 0
						highlight.Parent = char
					end

					-- name and studs
					local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
					if head then
						local billboard = Instance.new("BillboardGui")
						billboard.Name = tagIdentifier
						billboard.Size = UDim2.new(0, 200, 0, 40)
						billboard.AlwaysOnTop = true
						billboard.ExtentsOffset = Vector3.new(0, 2.8, 0)
						billboard.Adornee = head
						billboard.Parent = CoreGui
						
						local label = Instance.new("TextLabel")
						label.Name = "InfoLabel"
						label.Size = UDim2.new(1, 0, 1, 0)
						label.BackgroundTransparency = 1
						label.TextColor3 = Color3.fromRGB(255, 255, 255)
						label.TextSize = 13
						label.Font = Enum.Font.GothamBold
						label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						label.TextStrokeTransparency = 0.3
						label.Parent = billboard

						activeBillboards[targetPlayer.Name] = {Gui = billboard, Label = label, TargetChar = char}
					end
				end

				if targetPlayer.Character then
					addESP(targetPlayer.Character)
				end
				
				targetPlayer.CharacterAdded:Connect(function(char)
					if state then
						task.wait(1)
						addESP(char)
					end
				end)
			end

			for _, p in ipairs(Players:GetPlayers()) do
				setupPlayerESP(p)
			end

			playerEspConnection = Players.PlayerAdded:Connect(function(p)
				setupPlayerESP(p)
			end)

		-- real time update 
			renderConnection = RunService.RenderStepped:Connect(function()
				local localChar = localPlayer.Character
				local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")

				for name, data in pairs(activeBillboards) do
					local char = data.TargetChar
					local label = data.Label
					local gui = data.Gui

					if char and char:FindFirstChild("HumanoidRootPart") and localHrp then
						local hrp = char.HumanoidRootPart
						local distance = math.floor((hrp.Position - localHrp.Position).Magnitude)
						label.Text = string.format("%s | %d studs", name, distance)
					else
						if gui then gui.Enabled = false end
					end
				end
			end)

		else
		-- toggle off
			clearESP()
		end
	end,
})


Tabs.PlayerTab:Space()

-- ====================================================================
-- NOCLIP TOGGLE (PLAYER TAB)
-- ====================================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local noclipConnection = nil

Tabs.PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls and obstacles",
    Value = false,
    Callback = function(state)
        if state then
            -- ===== [TOGGLE ON] =====
            if noclipConnection then
                noclipConnection:Disconnect()
            end

            noclipConnection = RunService.Stepped:Connect(function()
                local character = player.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            -- ===== [TOGGLE OFF] =====
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            local character = player.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

Tabs.PlayerTab:Space()









-- Settings Section --

local Tabs = {
	SettingTab = Window:Tab({
		Title = "Setting",
		Icon = "cog",
	}),
}

local Keybind = Tabs.SettingTab:Keybind({
    Title = "UI Keybind",
    Desc = "Keybind to open ui",
    Value = "Z", -- Pinalitaning Z ang default key[span_1](start_span)[span_1](end_span)
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])[span_2](start_span)[span_2](end_span)
    end,
})

-- I-lock ito para hindi na mabago ng user
Keybind:Lock()

Tabs.SettingTab:Space()

-- ====================================================================
-- ANTI-LAG / LOW GRAPHICS TOGGLE (WINDUI VERSION)
-- ====================================================================
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local antilagConnection = nil
local originalSettings = {}

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end)
end

Tabs.SettingTab:Toggle({
    Title = "Anti-Lag / Low Graphics",
    Desc = "Boosts FPS by disabling shadows, particles, and heavy textures",
    Value = false,
    Callback = function(state)
        if state then
            -- ===== [TOGGLE ON] =====
            

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
                    v.Material = Enum.Material.Plastic
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

            
        else
            -- ===== [TOGGLE OFF] =====
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
            
        end
    end,
})

Tabs.SettingTab:Space()



-- ====================================================================
-- DAYTIME / MORNING TOGGLE (SETTING TAB)
-- ====================================================================
local Lighting = game:GetService("Lighting")

Tabs.SettingTab:Toggle({
    Title = "DayTime/Morning",
    Desc = "Leave to the Darkness",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                -- ===== [TOGGLE ON: Gawing Tanghali] =====
                Lighting.ClockTime = 14
                Lighting.Brightness = 3
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
                Lighting.Ambient = Color3.fromRGB(150, 150, 150)
                Lighting.GlobalShadows = false
                
                for _, child in ipairs(Lighting:GetChildren()) do
                    if child:IsA("Atmosphere") then
                        child.Density = 0
                        child.Haze = 0
                        child.Color = Color3.fromRGB(255, 255, 255)
                        child.Decay = Color3.fromRGB(255, 255, 255)
                    elseif child:IsA("ColorCorrectionEffect") then
                        child.TintColor = Color3.fromRGB(255, 255, 255)
                        child.Saturation = 0.1
                        child.Contrast = 0.1
                    elseif child:IsA("Sky") then
                        child.StarCount = 0
                    end
                end
            else
                -- ===== [TOGGLE OFF: Ibalik sa Normal/Gabi] =====
                Lighting.ClockTime = 0
                Lighting.Brightness = 1
                Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
                Lighting.Ambient = Color3.fromRGB(70, 70, 70)
                Lighting.GlobalShadows = true
                
                for _, child in ipairs(Lighting:GetChildren()) do
                    if child:IsA("Atmosphere") then
                        child.Density = 0.35 -- O i-adjust ayon sa default ng laro
                        child.Haze = 0
                        child.Color = Color3.fromRGB(199, 199, 199)
                        child.Decay = Color3.fromRGB(106, 112, 125)
                    elseif child:IsA("ColorCorrectionEffect") then
                        child.TintColor = Color3.fromRGB(255, 255, 255)
                        child.Saturation = 0
                        child.Contrast = 0
                    elseif child:IsA("Sky") then
                        child.StarCount = 3000
                    end
                end
            end
        end)
    end,
})

Tabs.SettingTab:Space()



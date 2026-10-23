-- v3
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



				loadstring(game:HttpGet("https://raw.githubusercontent.com/aceeria3-lab/WINDUIIOHUB/refs/heads/main/dist/main2.lua"))()



		end



	end



end















local Window = WindUI:CreateWindow({



    Title = "IOHUB",



    Folder = "IOHUB",



    Icon = "rbxassetid://139934599708171",



    IconSize = 35,



    



    NewElements = true,



    HideSearchBar = false,







    OpenButton = {



        Title = "IOHUB",



        CornerRadius = UDim.new(1, 0),



        StrokeThickness = 3,



        Enabled = true,



        Draggable = true,



        OnlyMobile = false,



        Scale = 0.8,



        Color = ColorSequence.new(



            Color3.fromHex("#30FF6A"),



            Color3.fromHex("#e7ff2f")



        ),



    },



    Topbar = {



        Height = 44,



        ButtonsType = "Mac",



    },



})















-- */  Colors  /* --



local Purple = Color3.fromHex("#7775F2")



local Yellow = Color3.fromHex("#ECA201")



local Green = Color3.fromHex("#10C550")



local Grey = Color3.fromHex("#83889E")



local Blue = Color3.fromHex("#257AF7")



local Red = Color3.fromHex("#EF4F1D")





local Tabs = {
WitchTab = Window:Tab({
       Title = "Main",
     Icon = "ghost",
    Border = true,
   }),
}


Tabs.WitchTab:Select()


Tabs.WitchTab:Paragraph({
    Title = "Place 1",
    Desc = ""
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ============================================
-- PALITAN MO LANG ITO (X, Y, Z coordinates)
-- ============================================
local TARGET_CFRAME = CFrame.new(2528.027, 18.671, -1182.394)



-- ============================================

local instantTP
instantTP = Tabs.WitchTab:Button({
    Title = "Instant Finish this Section",
    Icon = "mouse",
    Callback = function()
        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        hrp.CFrame = TARGET_CFRAME
    end,
})

Tabs.WitchTab:Space()


Tabs.WitchTab:Paragraph({
    Title = "Place 2",
    Desc = ""
})


local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ============================================
-- PALITAN MO LANG ITO (X, Y, Z coordinates)
-- ============================================
local TARGET_CFRAME = CFrame.new(-442.14444, 38.0705185, -1456.81738)



-- ============================================

local instantTP2
instantTP2 = Tabs.WitchTab:Button({
    Title = "Instant Finish this Section",
    Icon = "mouse",
    Callback = function()
        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        hrp.CFrame = TARGET_CFRAME
    end,
})

Tabs.WitchTab:Space()



Tabs.WitchTab:Paragraph({
    Title = "Place 3",
    Desc = ""
})


local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ============================================
-- PALITAN MO LANG ITO (X, Y, Z coordinates)
-- ============================================
local TARGET_CFRAME = CFrame.new(2689.094, 7.062, 644.912)



-- ============================================

local instantTP3
instantTP3 = Tabs.WitchTab:Button({
    Title = "Instant Finish this Section",
    Icon = "mouse",
    Callback = function()
        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        hrp.CFrame = TARGET_CFRAME
    end,
})

Tabs.WitchTab:Space()


local Tabs = {
ESPTab = Window:Tab({
       Title = "ESP",
     Icon = "eye",
    Border = true,
   }),
}




local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- ============================================
-- ESP CONFIG
-- ============================================
local ESP_CONFIGS = {
    AI = {
        color = Color3.fromRGB(255, 50, 50),
        enabled = false,
        tag = "ESP_AI",
        finder = function()
            local list = {}
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name == "AI" and obj:IsA("Model") then
                    table.insert(list, obj)
                end
            end
            return list
        end,
    },
    Butterfly = {
        color = Color3.fromRGB(50, 255, 50),
        enabled = false,
        tag = "ESP_Butterfly",
        finder = function()
            local list = {}
            for _, name in ipairs({"Butterfly Spirit", "Butterfly Spirit2"}) do
                local obj = Workspace:FindFirstChild(name)
                if obj and obj:IsA("Model") then
                    table.insert(list, obj)
                end
            end
            return list
        end,
    },
    Monster = {
        color = Color3.fromRGB(50, 100, 255),
        enabled = false,
        tag = "ESP_Monster",
        finder = function()
            local list = {}
            local folder = Workspace:FindFirstChild("GameAI")
            if not folder then return list end
            for _, name in ipairs({"Futao", "Mote"}) do
                local obj = folder:FindFirstChild(name)
                if obj and obj:IsA("Model") then
                    table.insert(list, obj)
                end
            end
            return list
        end,
    },
    CrawlSama = {
        color = Color3.fromRGB(255, 150, 0),  -- orange
        enabled = false,
        tag = "ESP_CrawlSama",
        finder = function()
            local list = {}
            for _, name in ipairs({"CrawlAI", "SamaAI"}) do
                local obj = Workspace:FindFirstChild(name)
                if obj and obj:IsA("Model") then
                    table.insert(list, obj)
                end
            end
            return list
        end,
    },
}

-- ============================================
-- HELPER: Kunin ang BasePart ng Model
-- ============================================
local function getAdornee(model)
    if model:IsA("BasePart") then return model end
    return model.PrimaryPart
        or model:FindFirstChildWhichIsA("BasePart")
        or model:FindFirstChildWhichIsA("BasePart", true)
end

-- ============================================
-- CREATE ESP (Highlight + Name Label)
-- ============================================
local function createESP(model, cfg)
    if not model or not model:IsDescendantOf(Workspace) then return end
    if Players.LocalPlayer.Character
        and model:IsDescendantOf(Players.LocalPlayer.Character) then
        return
    end

    local hl = Instance.new("Highlight")
    hl.Name = cfg.tag
    hl.Adornee = model
    hl.FillColor = cfg.color
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = model

    local adornee = getAdornee(model)
    if adornee then
        local bb = Instance.new("BillboardGui")
        bb.Name = cfg.tag .. "_Label"
        bb.Adornee = adornee
        bb.Size = UDim2.new(0, 160, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = adornee

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = model.Name
        label.TextColor3 = cfg.color
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = bb
    end
end

-- ============================================
-- APPLY / CLEANUP ESP
-- ============================================
local function clearESP(tag)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj.Name == tag or obj.Name == tag .. "_Label")
            and (obj:IsA("Highlight") or obj:IsA("BillboardGui")) then
            obj:Destroy()
        end
    end
end

local function applyESP(key)
    local cfg = ESP_CONFIGS[key]
    clearESP(cfg.tag)
    if not cfg.enabled then return end

    for _, model in ipairs(cfg.finder()) do
        createESP(model, cfg)
    end
end

-- ============================================
-- AUTO-REFRESH (bagong spawn)
-- ============================================
local refreshDebounce = false
Workspace.DescendantAdded:Connect(function()
    if refreshDebounce then return end
    refreshDebounce = true
    task.wait(0.5)
    refreshDebounce = false

    for key, cfg in pairs(ESP_CONFIGS) do
        if cfg.enabled then
            applyESP(key)
        end
    end
end)

-- ============================================
-- TOGGLE 1: AI (4 models sa Workspace)
-- ============================================
Tabs.ESPTab:Toggle({
    Title = "ESP AI",
    Desc = "Highlights all 'AI' models in Workspace",
    Value = false,
    Callback = function(state)
        ESP_CONFIGS.AI.enabled = state
        applyESP("AI")
    end,
})

-- ============================================
-- TOGGLE 2: Butterfly Spirit & Butterfly Spirit2
-- ============================================
Tabs.ESPTab:Toggle({
    Title = "ESP Butterfly Spirit",
    Desc = "Highlights Butterfly Spirit & Butterfly Spirit2",
    Value = false,
    Callback = function(state)
        ESP_CONFIGS.Butterfly.enabled = state
        applyESP("Butterfly")
    end,
})



-- ============================================
-- TOGGLE 4: CrawlAI & SamaAI
-- ============================================
Tabs.ESPTab:Toggle({
    Title = "ESP CrawlAI & SamaAI",
    Desc = "Highlights CrawlAI & SamaAI in Workspace",
    Value = false,
    Callback = function(state)
        ESP_CONFIGS.CrawlSama.enabled = state
        applyESP("CrawlSama")
    end,
})




-- ============================================
-- TOGGLE 3: Futao & Mote (Workspace.GameAI)
-- ============================================
Tabs.ESPTab:Toggle({
    Title = "ESP GameAI Monsters",
    Desc = "Highlights Futao & Mote in Workspace.GameAI",
    Value = false,
    Callback = function(state)
        ESP_CONFIGS.Monster.enabled = state
        applyESP("Monster")
    end,
})






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
	Flag = "PlayerEsp",
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
						highlight.FillColor = Color3.fromRGB(255, 50, 50)
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
	Flag = "Noclip",
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


local isEnabled = false

Tabs.PlayerTab:Toggle({
	Title = "Instant Prompt",
	Desc = "Make the Prompt Becomes One Tap",
	Flag = "InstantPrompt",
Value = false,
	Callback = function(state)
		isEnabled = state
		
		-- Function para baguhin ang hold duration ng mga prompt
		local function updatePrompts()
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") then
					if isEnabled then
						-- Ginagawa itong 0 para ma-tap agad nang walang hintayan
						descendant.HoldDuration = 0
					else
						-- Pwede mong ibalik sa default (halimbawa ay 0.5 o kung ano man ang orig)
						-- O kaya ay hayaan na lang kung may sarili silang duration
					end
				end
			end
		end

		updatePrompts()
		
		-- Opsyonal: Para ma-detect din ang mga bagong mag-a-appear na prompt sa laro
		if isEnabled then
			workspace.DescendantAdded:Connect(function(descendant)
				if isEnabled and descendant:IsA("ProximityPrompt") then
					descendant.HoldDuration = 0
				end
			end)
		end
	end,
})













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





		-- ====================================================================
-- WINDUI TABS SETUP
-- ====================================================================
local Tabs = {
	ChatTab = Window:Tab({
		Title = "Global Chat",
		Icon  = "message-square", 
	}),
}

if not Tabs.ChatTab then return end

--[[ GLOBAL CHAT SCRIPT (PROFILE POPUP WITH CLOSE) ]]
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
	info="rbxassetid://124560466474914", 	
	reply="rbxassetid://109788633497028", 	
	send="rbxassetid://127751956873796", 	
	x="rbxassetid://110786993356448", 	
	minus="rbxassetid://118026365011536", 	
	hash="rbxassetid://82890331678520", 	
	shield="rbxassetid://110987169760162", 	
	["message-square"]="rbxassetid://83881670383280", 	
	user="rbxassetid://81589895647169", 
}

local C = { 	
	DB="https://global-chat-bb7ef-default-rtdb.asia-southeast1.firebasedatabase.app", 	
	Poll=1.5, 	
	Max=180, 	
	History=40, 	
	Cool=1.2, 	
	PresTTL=20, 
}

local S = { 	
	Main=nil, Input=nil, List=nil, Status=nil, ReplyBar=nil, ReplyLabel=nil, 	
	Msgs={}, Seen={}, LastCount=0, LastSend=0, Order=0, 	
	Alive=false, Mode="global", PrivTarget=nil, Online={}, DMList={}, ReplyTo=nil,
	OnlineCount = 1
}

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
	local ok,r=pcall(H.JSONEncode,H,v) 	
	return ok and r or "{}" 
end 

local function Dec(v) 	
	local ok,r=pcall(H.JSONDecode,H,v) 	
	return ok and r or nil 
end 

local function Url(v) return H:UrlEncode(tostring(v)) end 

local function Tw(o,t,p) 	
	return TS:Create(o,TweenInfo.new(t or 0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p) 
end 

local function AddBorder(obj,ic,oc,it,ot) 	
	local o=Instance.new("UIStroke") 	
	o.Name="OuterStroke" 	
	o.Color=oc or Color3.fromRGB(88,101,242) 	
	o.Thickness=ot or 1.5 	
	o.ApplyStrokeMode=Enum.ApplyStrokeMode.Border 	
	o.Parent=obj 	
	local i=Instance.new("UIStroke") 	
	i.Name="InnerStroke" 	
	i.Color=ic or Color3.fromRGB(0,0,0) 	
	i.Thickness=it or 1 	
	i.ApplyStrokeMode=Enum.ApplyStrokeMode.Border 	
	i.Parent=obj 	
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
	local s=os.clock() 	
	self._ns=s 	
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

	-- PLAYER ICON
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

    -- ⚠️ PROFILE POPUP (MAY CLOSE BUTTON NA)
    local function OpenProfilePopup()
        local placeIdText = msgPlaceId and tostring(msgPlaceId) or "Not Available"
        local jobIdText = msgJobId and tostring(msgJobId) or "Not Available"
        
        local profileContent = string.format(
            "Name: @%s\nGame: %s\nPlace ID: %s\nJob ID: %s",
            un, gName, placeIdText, jobIdText
        )

        local dialog -- Declare muna natin para magamit sa loob ng Callback
        
        dialog = Window:Dialog({
            Title = "Player Profile",
            Content = profileContent,
            Icon = "user",
            Buttons = {
                {
                    Title = "Join Game",
                    Icon = "log-in",
                    Variant = "Primary",
                    Callback = function()
                        if msgPlaceId and msgJobId and jobIdText ~= "Not Available" then
                            local success, err = pcall(function()
                                TeleportService:TeleportToPlaceInstance(tonumber(msgPlaceId), tostring(msgJobId), L)
                            end)
                            if not success then
                                Window:Notify({Title = "Teleport Failed", Content = "Executor blocked the teleport.", Icon = "alert-triangle"})
                            end
                        elseif msgPlaceId then
                            local success, err = pcall(function()
                                TeleportService:Teleport(tonumber(msgPlaceId), L)
                            end)
                            if not success then
                                Window:Notify({Title = "Teleport Failed", Content = "Could not join the game.", Icon = "alert-triangle"})
                            end
                        else
                            Window:Notify({Title = "Cannot Join", Content = "This message is old.", Icon = "alert-triangle"})
                        end
                    end
                },
                {
                    Title = "Close",
                    Icon = "x",
                    Variant = "Secondary", -- Kulay gray/puti para pang-close
                    Callback = function()
                        dialog:Close() -- Ito yung magsasara sa popup
                    end
                }
            }
        })
    end

    -- Click listener sa avatar
    av.MouseButton1Click:Connect(OpenProfilePopup)

	-- CONTENT COLUMN
	local contentColumn = self:_o({"Frame",{Size=UDim2.new(1,-44,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=2}},mainContainer)
	self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Vertical,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder}},contentColumn)

	-- HEADER ROW
	local headerRow = self:_o({"Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,LayoutOrder=1}},contentColumn)
	local leftHeader = self:_o({"Frame",{Size=UDim2.new(1,-50,1,0),BackgroundTransparency=1}},headerRow)
	self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center}},leftHeader)

	-- Username Gradient
	local userLabel = self:_o({"TextButton",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="@"..un,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=false,LayoutOrder=1}},leftHeader)
	local uGrad = Instance.new("UIGradient")
	uGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100))} 
	uGrad.Parent = userLabel
	
    -- Click listener sa username
    userLabel.MouseButton1Click:Connect(OpenProfilePopup)

	-- Divider
	self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="|",TextColor3=Color3.fromRGB(150,150,150),Font=Enum.Font.Gotham,TextSize=13,LayoutOrder=2}},leftHeader)

	-- Game Name Gradient
	local gameLabel = self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=gName,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,LayoutOrder=3,TextTruncate=Enum.TextTruncate.AtEnd}},leftHeader)
	local gGrad = Instance.new("UIGradient")
	gGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))} 
	gGrad.Parent = gameLabel

	-- Right Header (Time & Reply)
	local rightHeader = self:_o({"Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.fromOffset(50,22),BackgroundTransparency=1}},headerRow)
	self:_o({"UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Center}},rightHeader)

	-- Reply Button
	local replyBtn = self:_o({"ImageButton",{Size=UDim2.fromOffset(14,14),BackgroundTransparency=1,Image=I.reply,ImageColor3=Color3.fromRGB(130,135,145),AutoButtonColor=false,LayoutOrder=1}},rightHeader)
	replyBtn.MouseButton1Click:Connect(function() self:SetReply({Id=id,Username=un,DisplayName=un,Text=raw,UserId=uid}) end)
	replyBtn.MouseEnter:Connect(function() replyBtn.ImageColor3=Color3.fromRGB(88,150,255) end)
	replyBtn.MouseLeave:Connect(function() replyBtn.ImageColor3=Color3.fromRGB(130,135,145) end)

	-- Time
	self:_o({"TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=RelTime(ts),TextColor3=Color3.fromRGB(120,125,135),Font=Enum.Font.Gotham,TextSize=10,LayoutOrder=2}},rightHeader)

	-- MESSAGE TEXT (BOLD + STROKE)
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
	local body,err=Http({Url=path,Method="GET",Headers={["Content-Type"]="application/json"}}) 	
	if not body or body=="" or body=="null" then return end 	
	local data=Dec(body) 	
	if type(data)~="table" then return end 	
	local list={} 	
	for k,v in pairs(data) do 		
		if type(v)=="table" then 			
			v._key=tostring(k) 			
			v.Id=tostring(k) 			
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
		self.LastCount=#list 		
		self:_bottom() 	
	else 		
		if #list>self.LastCount then 			
			for i=self.LastCount+1,#list do 				
				self:NewMessage(list[i]) 			
			end 			
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
		sender=L.Name, 		
		Username=L.Name, 		
		DisplayName=L.DisplayName, 		
		msg=text, 		
		Text=text, 		
		userId=L.UserId, 		
		UserId=L.UserId, 		
		time=os.time(), 		
		timestamp=os.time(),
		gameName=GameName,
		JobId=game.JobId,     
		PlaceId=game.PlaceId  
	} 	
	if self.ReplyTo then 		
		body.replyUser=fmtName(self.ReplyTo.DisplayName,self.ReplyTo.Username) 		
		body.replyText=tostring(self.ReplyTo.Text or ""):sub(1,40) 		
		body.replyTo=self.ReplyTo.Id 	
	end 	
	
	local path=self:_base().."/public_chat.json" 	
	local ok=false 	
	local res=select(1,Http({ 		
		Url=path, 		
		Method="POST", 		
		Headers={["Content-Type"]="application/json"}, 		
		Body=Enc(body), 	
	})) 	
	if res then ok=true end 	
	
	if not ok then 		
		local id=tostring(L.UserId).."_"..tostring(os.time()).."_"..tostring(math.random(10000,99999)) 		
		res=select(1,Http({ 			
			Url=path:gsub("%.json$","").."/"..Url(id)..".json", 			
			Method="PUT", 			
			Headers={["Content-Type"]="application/json"}, 			
			Body=Enc(body), 		
		})) 		
		ok=res~=nil 	
	end 	
	if not ok then 		
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
			Method="PUT", 			
			Headers={["Content-Type"]="application/json"}, 			
			Body=Enc({t=os.time(),n=L.Name,d=L.DisplayName}), 		
		}) 	
	end) 
end 

function S:_cleanIfAlone() 	
	local body=select(1,Http({Url=self:_base().."/presence.json",Method="GET",Headers={["Content-Type"]="application/json"}})) 	
	if not body or body=="" or body=="null" then 		
		pcall(function() Http({Url=self:_base().."/public_chat.json",Method="DELETE"}) end) 		
		self:Clear() 		
		return true 	
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
				self.Online[tostring(uid)]={n=tostring(v.n or "?"),d=tostring(v.d or v.n or "?"),t=v.t} 			
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
		self:Clear() 		
		return true 	
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
						alone=false 						
						break 					
					end 				
				end 			
			end 		
		end 		
		if alone then 			
			Http({Url=self:_base().."/public_chat.json",Method="DELETE"}) 		
		end 	
	end) 	
	if self.Main then pcall(function() self.Main:Destroy() end) end 	
	self.Main=nil 
end 

function S:Init() 	
	if self.Alive and self.Main then return self end 	
	self:Destroy() 	
	self.Alive=true 	
	
	local container = Tabs.ChatTab.ContainerFrame
	local old = container:FindFirstChild("GlobalChatEmbedded")
	if old then old:Destroy() end
	
	local main=self:_o({"Frame",{ 		
		Name="GlobalChatEmbedded",
		Size=UDim2.new(1,-10,1,-10), 
		Position=UDim2.new(0,5,0,5),
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
	
	-- ACTIVE NOW LABEL (Gradient, Malaki)
	local state=self:_o({"TextLabel",{ 		
		Position=UDim2.fromOffset(12,10),Size=UDim2.new(1,-24,0,20),BackgroundTransparency=1, 		
		Text="● Active Now (1)",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left 	
	}},top) 	
	local statusGrad = Instance.new("UIGradient")
	statusGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),   
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 150, 255)), 
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))  
	}
	statusGrad.Parent = state
	self.Status = state
	
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
	rI.Position=UDim2.fromOffset(6,5) 	
	rI.Parent=replyBar 	
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
		Position=UDim2.fromOffset(6,8),Size=UDim2.new(1,-78,0,30),BackgroundColor3=Color3.fromRGB(50,53,60), 		
		BorderSizePixel=0,ClearTextOnFocus=false,MultiLine=false,Text="",PlaceholderText="Message...", 		
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

-- SERVER FULL HANDLER
TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage, placeId, teleportOptions)
    if player == L then
        if teleportResult == Enum.TeleportResult.GameFull then
            Window:Notify({
                Title = "Server Is Full",
                Content = "Cannot join the server. Please try again later.",
                Icon = "alert-triangle",
                Duration = 5
            })
        elseif teleportResult == Enum.TeleportResult.Fail then
            Window:Notify({
                Title = "Teleport Failed",
                Content = tostring(errorMessage),
                Icon = "x-circle"
            })
        end
    end
end)

-- AUTO START
task.spawn(function()
	task.wait(0.5)
	S:Init()
end) 
	























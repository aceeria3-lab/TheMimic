
local currentId = game.PlaceId
local function boot(msg, url)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "IOHUB", Text = msg, Duration = 3})
    loadstring(game:HttpGet(url))()
end

-- Listahan ng lahat ng Control Place IDs
local controlIds = {
    6296321810, -- C1 P1
    6301638949, -- C1 P2
    6373539583, -- C2 P1
    7251865082,
7251866503,
7251867155,
7251867574,
    6485055338,
  6485055836,
6485056556,
    6688734180,
6688734313,
6688734395,
6479231833,
6480994221,
    6406571212, -- C2 P2
    6425178683, -- C2 P3
    6472459099, -- C3 P1
    6682163754, -- C3 P2
    6682164423, -- C3 P3
    7265396387, -- C4 P1
    7265396805, -- C4 P2
    7265397072, -- C4 P3
    7265397848, -- C4 P4 
    7618863566 -- JIGOKU
}

local halloweenIds = {

7633631103,
7633631351,
7633631511
}

local thewitchtrialsids = {

7068951438,
7068738088,
7068951914,
7068739000,
7068952294,
7068740106,
}


-- =========================================================================
-- PLACE ID DATABASE MATRIX
-- =========================================================================
if currentId == 128715637193371 then 
    boot("Rage Book 3 Chapter 1", "https://raw.githubusercontent.com/aceeria3-lab/TheMimic/refs/heads/main/RageV2.lua")



elseif currentId == 91058462594174 then 
    boot("[SA] Rage Book 3 Chapter 1", "https://raw.githubusercontent.com/aceeria3-lab/TheMimic/refs/heads/main/R1SA.lua")

elseif currentId == 96354063422506 then 
    boot("Jelousy Book 2 Chapter 4", "https://raw.githubusercontent.com/Moymoy21/IOHUB/refs/heads/main/b2c4v2.txt")
    
    elseif currentId == 15962819441 then 
    boot("Jelousy Book 2 Chapter 3", "https://raw.githubusercontent.com/Moymoy21/IOHUB/refs/heads/main/b2c3.txt")
    
    elseif currentId == 13489800654 then 
    boot("Jelousy Book 2 Chapter 2", "https://raw.githubusercontent.com/Moymoy21/IOHUB/refs/heads/main/b2c2.txt")
    
-- Kapag ang na-detect ay alinman sa Control Place IDs
elseif table.find(controlIds, currentId) then
    boot("Control Book All Chapters", "https://raw.githubusercontent.com/Moymoy21/IOHUB/refs/heads/main/control.txt")
    
    elseif table.find(halloweenIds, currentId) then
    boot("Halloween Trials", "https://raw.githubusercontent.com/aceeria3-lab/TheMimic/refs/heads/main/HalloweenTrials.lua")

elseif table.find(thewitchtrialsids, currentId) then
    boot("The Witch Trials", "https://raw.githubusercontent.com/aceeria3-lab/TheMimic/refs/heads/main/TheWitchTrials.lua")


elseif currentId == 11126398230 then 
    boot("Nightmare Circus", "https://raw.githubusercontent.com/aceeria3-lab/TheMimic/refs/heads/main/nightmarecircus.lua")
    
elseif currentId == 16750505007 then 
    boot("The Mimic X Ken Carson", "https://raw.githubusercontent.com/aceeria3-lab/TheMimic/refs/heads/main/xcarson.lua")


-- =========================================================================
-- DEFAULT HUB FALLBACK (Dito papatak kapag hindi tugma ang Place ID)
-- =========================================================================
else 
    boot("Loading Default Loader...", "https://raw.githubusercontent.com/aceeria3-lab/TheMimic/refs/heads/main/mainlobby.lua")
end

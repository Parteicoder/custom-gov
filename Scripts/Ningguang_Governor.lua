-- Ningguang Governor Lua Script
-- Goal: Allow Ningguang to be assigned to City-States and apply custom effects

print("[Custom-Gov] Ningguang Governor script loaded");

-- Configuration
local NINGGUANG_GOVERNOR_TYPE = "GOVERNOR_NINGGUANG";

-- Helper function to check if a governor is Ningguang
function IsNingguang(governorType)
    return governorType == NINGGUANG_GOVERNOR_TYPE;
end

-- Event: When a Governor is assigned
-- This is a simplified version. Real implementation needs proper GameEvents.
function OnGovernorAssigned(playerID, governorID, cityID)
    -- TODO: Add proper checks here
    -- For now we just print debug info
    print("[Custom-Gov] Governor assigned - Player: " .. tostring(playerID) .. ", Governor: " .. tostring(governorID) .. ", City: " .. tostring(cityID));
end

-- Register the event (this may need adjustment depending on Civ 6 version)
-- Events.GovernorAssigned.Add(OnGovernorAssigned);

print("[Custom-Gov] Ningguang script initialized");
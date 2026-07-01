-- Ningguang Governor - City-State Support
-- Allows Ningguang to be assigned to City-States and applies custom effects

print("[Custom-Gov] Ningguang script loaded");

local NINGGUANG_TYPE = "GOVERNOR_NINGGUANG";

-- Check if the assigned governor is Ningguang
function IsNingguang(governorType)
    return governorType == NINGGUANG_TYPE;
end

-- Main function when a Governor is assigned
function OnGovernorAssigned(playerID, governorType, cityID)
    if not IsNingguang(governorType) then
        return;
    end

    print("[Custom-Gov] Ningguang assigned to city ID: " .. tostring(cityID));

    -- TODO: Add check if the city is a City-State
    -- TODO: Add influence bonus or other effects
end

-- Register the event
Events.GovernorAssigned.Add(OnGovernorAssigned);

print("[Custom-Gov] Ningguang City-State script initialized");
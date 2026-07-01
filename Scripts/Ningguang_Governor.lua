-- Ningguang Governor - City-State Effects

print("[Custom-Gov] Ningguang script with City-State effects loaded");

local NINGGUANG_TYPE = "GOVERNOR_NINGGUANG";

-- Check if governor is Ningguang
function IsNingguang(governorType)
    return governorType == NINGGUANG_TYPE;
end

-- Main assignment function
function OnGovernorAssigned(playerID, governorType, cityID)
    if not IsNingguang(governorType) then
        return;
    end

    print("[Custom-Gov] Ningguang assigned!");

    -- TODO: Add proper City-State detection
    -- For now we apply bonuses globally as placeholder

    -- Example: Give Influence and Gold when Ningguang is assigned
    -- This is a simplified version
    Players[playerID]:GetInfluence():ChangeInfluencePoints(50);
    Players[playerID]:GetTreasury():ChangeGoldBalance(100);

    print("[Custom-Gov] Applied placeholder bonuses for Ningguang");
end

Events.GovernorAssigned.Add(OnGovernorAssigned);

print("[Custom-Gov] Ningguang City-State effects initialized");
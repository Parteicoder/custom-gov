-- Ningguang Governor - Per-Turn City-State Bonuses

print("[Custom-Gov] Ningguang with per-turn effects loaded");

local NINGGUANG_TYPE = "GOVERNOR_NINGGUANG";
local ningguangAssignments = {}; -- Track where Ningguang is assigned

-- Check if governor is Ningguang
function IsNingguang(governorType)
    return governorType == NINGGUANG_TYPE;
end

-- Main assignment handler
function OnGovernorAssigned(playerID, governorType, cityID)
    if not IsNingguang(governorType) then
        return;
    end

    ningguangAssignments[playerID] = cityID;
    print("[Custom-Gov] Ningguang assigned to city ID: " .. tostring(cityID));

    -- One-time bonus
    Players[playerID]:GetInfluence():ChangeInfluencePoints(75);
    Players[playerID]:GetTreasury():ChangeGoldBalance(150);
end

-- Per-turn bonus
function OnPlayerTurnStarted(playerID)
    local assignedCity = ningguangAssignments[playerID];
    if assignedCity then
        -- Give small per-turn bonus
        Players[playerID]:GetInfluence():ChangeInfluencePoints(3);
        Players[playerID]:GetTreasury():ChangeGoldBalance(8);
        print("[Custom-Gov] Ningguang per-turn bonus applied");
    end
end

Events.GovernorAssigned.Add(OnGovernorAssigned);
Events.PlayerTurnStarted.Add(OnPlayerTurnStarted);

print("[Custom-Gov] Ningguang per-turn system initialized");
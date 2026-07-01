-- Ningguang Governor - Attempt at broader foreign city support

print("[Custom-Gov] Ningguang foreign city support loaded");

local NINGGUANG_TYPE = "GOVERNOR_NINGGUANG";
local ningguangAssignments = {};

-- Check if governor is Ningguang
function IsNingguang(governorType)
    return governorType == NINGGUANG_TYPE;
end

function OnGovernorAssigned(playerID, governorType, cityID)
    if not IsNingguang(governorType) then
        return;
    end

    ningguangAssignments[playerID] = cityID;
    print("[Custom-Gov] Ningguang assigned to city ID: " .. tostring(cityID));

    -- Apply different bonuses based on city type (simplified)
    local pCity = CityManager.GetCity(playerID, cityID);

    if pCity then
        if pCity:IsCityState() then
            -- City-State bonuses
            Players[playerID]:GetInfluence():ChangeInfluencePoints(75);
            Players[playerID]:GetTreasury():ChangeGoldBalance(150);
            print("[Custom-Gov] Applied City-State bonuses");
        else
            -- Normal foreign city (placeholder)
            Players[playerID]:GetTreasury():ChangeGoldBalance(50);
            print("[Custom-Gov] Applied foreign city placeholder bonus");
        end
    end
end

function OnPlayerTurnStarted(playerID)
    if ningguangAssignments[playerID] then
        -- Small per-turn bonus
        Players[playerID]:GetTreasury():ChangeGoldBalance(5);
        print("[Custom-Gov] Ningguang per-turn bonus");
    end
end

Events.GovernorAssigned.Add(OnGovernorAssigned);
Events.PlayerTurnStarted.Add(OnPlayerTurnStarted);

print("[Custom-Gov] Ningguang foreign city script initialized");
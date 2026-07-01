-- Ningguang Governor - Experimental Foreign City Support

print("[Custom-Gov] Ningguang experimental foreign city script loaded");

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
    print("[Custom-Gov] Ningguang assigned to city: " .. tostring(cityID));

    -- Apply different effects based on city type
    local pCity = CityManager.GetCity(playerID, cityID);

    if pCity then
        if pCity:IsCityState() then
            -- Strong City-State bonuses
            Players[playerID]:GetInfluence():ChangeInfluencePoints(100);
            Players[playerID]:GetTreasury():ChangeGoldBalance(200);
            print("[Custom-Gov] Strong City-State bonuses applied");
        else
            -- Foreign player city (experimental)
            Players[playerID]:GetTreasury():ChangeGoldBalance(75);
            print("[Custom-Gov] Foreign city bonus applied (experimental)");
        end
    end
end

function OnPlayerTurnStarted(playerID)
    if ningguangAssignments[playerID] then
        -- Small per-turn bonus
        Players[playerID]:GetTreasury():ChangeGoldBalance(6);
        print("[Custom-Gov] Ningguang per-turn bonus");
    end
end

Events.GovernorAssigned.Add(OnGovernorAssigned);
Events.PlayerTurnStarted.Add(OnPlayerTurnStarted);

print("[Custom-Gov] Ningguang experimental script ready");
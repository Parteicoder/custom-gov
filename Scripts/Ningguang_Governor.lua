-- Ningguang Governor - Enhanced Foreign City Support (Experimental)

print("[Custom-Gov] Ningguang enhanced foreign city script loaded");

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

    local pCity = CityManager.GetCity(playerID, cityID);

    if pCity then
        if pCity:IsCityState() then
            -- Strong City-State bonuses
            Players[playerID]:GetInfluence():ChangeInfluencePoints(100);
            Players[playerID]:GetTreasury():ChangeGoldBalance(200);
            print("[Custom-Gov] Strong City-State bonuses applied");
        else
            -- Foreign player city (experimental - inspired by Wuthering Waves mod)
            -- Give yield copy effect (simplified)
            Players[playerID]:GetTreasury():ChangeGoldBalance(100);
            Players[playerID]:GetInfluence():ChangeInfluencePoints(30);
            print("[Custom-Gov] Foreign city bonus applied (yield copy style)");
        end
    end
end

function OnPlayerTurnStarted(playerID)
    if ningguangAssignments[playerID] then
        -- Per-turn bonus
        Players[playerID]:GetTreasury():ChangeGoldBalance(8);
        print("[Custom-Gov] Ningguang per-turn bonus");
    end
end

Events.GovernorAssigned.Add(OnGovernorAssigned);
Events.PlayerTurnStarted.Add(OnPlayerTurnStarted);

print("[Custom-Gov] Ningguang enhanced script ready");
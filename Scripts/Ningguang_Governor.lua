-- Ningguang Governor - Accurate City-State Detection

print("[Custom-Gov] Ningguang with accurate detection loaded");

local NINGGUANG_TYPE = "GOVERNOR_NINGGUANG";
local ningguangCityState = {}; -- playerID -> cityID

-- Check if governor is Ningguang
function IsNingguang(governorType)
    return governorType == NINGGUANG_TYPE;
end

function OnGovernorAssigned(playerID, governorType, cityID)
    if not IsNingguang(governorType) then
        return;
    end

    -- Check if the city actually exists and is a City-State
    local pCity = CityManager.GetCity(playerID, cityID);
    if pCity and pCity:IsCityState() then
        ningguangCityState[playerID] = cityID;

        print("[Custom-Gov] Ningguang assigned to City-State ID: " .. tostring(cityID));

        -- One-time bonuses
        Players[playerID]:GetInfluence():ChangeInfluencePoints(75);
        Players[playerID]:GetTreasury():ChangeGoldBalance(150);
    else
        print("[Custom-Gov] Assigned city is NOT a City-State");
        ningguangCityState[playerID] = nil;
    end
end

function OnPlayerTurnStarted(playerID)
    if ningguangCityState[playerID] then
        -- Per-turn bonuses only if still assigned to a City-State
        Players[playerID]:GetInfluence():ChangeInfluencePoints(3);
        Players[playerID]:GetTreasury():ChangeGoldBalance(8);
        print("[Custom-Gov] Ningguang per-turn bonus applied");
    end
end

Events.GovernorAssigned.Add(OnGovernorAssigned);
Events.PlayerTurnStarted.Add(OnPlayerTurnStarted);

print("[Custom-Gov] Accurate City-State system initialized");
-- Ningguang Governor - Improved City-State Support

print("[Custom-Gov] Ningguang advanced script loaded");

local NINGGUANG_TYPE = "GOVERNOR_NINGGUANG";

-- Check if governor is Ningguang
function IsNingguang(governorType)
    return governorType == NINGGUANG_TYPE;
end

-- Check if a city is a City-State
function IsCityState(cityID)
    local pCity = CityManager.GetCity(playerID, cityID);
    if pCity then
        return pCity:IsCityState();
    end
    return false;
end

-- Main assignment handler
function OnGovernorAssigned(playerID, governorType, cityID)
    if not IsNingguang(governorType) then
        return;
    end

    print("[Custom-Gov] Ningguang assigned to city: " .. tostring(cityID));

    if IsCityState(cityID) then
        print("[Custom-Gov] Assigned to a City-State!");

        -- Give one-time bonus
        Players[playerID]:GetInfluence():ChangeInfluencePoints(75);
        Players[playerID]:GetTreasury():ChangeGoldBalance(150);

        -- TODO: Add per-turn bonus here later
    else
        print("[Custom-Gov] Not a City-State");
    end
end

Events.GovernorAssigned.Add(OnGovernorAssigned);

print("[Custom-Gov] Ningguang script fully initialized");
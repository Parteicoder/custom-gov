-- Custom Governor - Keqing
-- Gameplay script for Liyue trade population siphon.
-- Keqing's base governor promotion increases the chance that an outgoing
-- international trade route pulls 1 population from the target city into the
-- origin city. Ningguang can act as a tag-team partner and add political unrest.

include("GameCapabilities");

local KEQING_GOVERNOR_TYPE:string = "GOVERNOR_KEQING";
local KEQING_BASE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_KEQING_BASE";
local NINGGUANG_GOVERNOR_TYPE:string = "GOVERNOR_NINGGUANG";
local NINGGUANG_BASE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_NINGGUANG_BASE";
local LIYUE_LEADER_TRAIT:string = "TRAIT_LEADER_KEQING_THE_DRIVING_THUNDER";
local POPULATION_SIPHON_CHANCE:number = 35;
local TAG_TEAM_POPULATION_SIPHON_CHANCE:number = 50;
local NINGGUANG_TARGET_LOYALTY_PRESSURE:number = -5;
local LAST_ROUTE_PROPERTY_PREFIX:string = "CUSTOM_GOV_KEQING_LAST_POP_SIPHON_";

function CustomGov_HasGovernorPromotion(playerID:number, governorType:string, promotionType:string)
    local pPlayer = Players[playerID];
    if pPlayer == nil then return false; end

    -- This add-on is intended to build on Keqing/Liyue mechanics from the
    -- Liyue and Inazuma Pack. Keep the script scoped to that leader trait.
    if not HasTrait(LIYUE_LEADER_TRAIT, playerID) then return false; end

    local governorInfo = GameInfo.Governors[governorType];
    local promotionInfo = GameInfo.GovernorPromotions[promotionType];
    if governorInfo == nil or promotionInfo == nil then return false; end

    local playerGovernors = pPlayer:GetGovernors();
    if playerGovernors == nil then return false; end

    local hasAnyGovernor:boolean, governorList:table = playerGovernors:GetGovernorList();
    if not hasAnyGovernor or governorList == nil then return false; end

    for _, governor in ipairs(governorList) do
        if governor:GetType() == governorInfo.Index and governor:HasPromotion(promotionInfo.Index) then
            return true;
        end
    end

    return false;
end

function CustomGov_HasKeqingBasePromotion(playerID:number)
    return CustomGov_HasGovernorPromotion(playerID, KEQING_GOVERNOR_TYPE, KEQING_BASE_PROMOTION_TYPE);
end

function CustomGov_HasNingguangBasePromotion(playerID:number)
    return CustomGov_HasGovernorPromotion(playerID, NINGGUANG_GOVERNOR_TYPE, NINGGUANG_BASE_PROMOTION_TYPE);
end

function CustomGov_GetCity(playerID:number, cityID:number)
    local pPlayer = Players[playerID];
    if pPlayer == nil then return nil; end

    local pCities = pPlayer:GetCities();
    if pCities == nil then return nil; end

    return pCities:FindID(cityID);
end

function CustomGov_ApplyNingguangTradeUnrest(pTargetCity:table, targetCityID:number)
    if pTargetCity == nil then return; end

    -- Civ VI exposes a reliable city loyalty mutator. Direct amenity mutation is
    -- much less stable in gameplay Lua, so this models falling satisfaction as
    -- political unrest in the target city.
    if pTargetCity.ChangeLoyalty ~= nil then
        pTargetCity:ChangeLoyalty(NINGGUANG_TARGET_LOYALTY_PRESSURE);
        print("CustomGov Ningguang: target city " .. tostring(targetCityID) .. " lost " .. tostring(math.abs(NINGGUANG_TARGET_LOYALTY_PRESSURE)) .. " loyalty from trade unrest");
    end
end

function CustomGov_TrySiphonPopulation(playerID:number, originPlayerID:number, originCityID:number, targetPlayerID:number, targetCityID:number)
    -- Only routes owned by the origin player should trigger this add-on effect.
    if playerID ~= originPlayerID then return; end

    -- Internal routes should not steal population.
    if originPlayerID == targetPlayerID then return; end

    if not CustomGov_HasKeqingBasePromotion(originPlayerID) then return; end

    local pOriginCity = CustomGov_GetCity(originPlayerID, originCityID);
    local pTargetCity = CustomGov_GetCity(targetPlayerID, targetCityID);
    if pOriginCity == nil or pTargetCity == nil then return; end

    -- Never destroy a city by draining its last citizen.
    if pTargetCity:GetPopulation() <= 1 then return; end

    -- Avoid double-firing if Civ VI emits the trade-route activity event more
    -- than once for the same origin/target pair on the same turn.
    local currentTurn:number = Game.GetCurrentGameTurn();
    local routeKey:string = LAST_ROUTE_PROPERTY_PREFIX .. tostring(originPlayerID) .. "_" .. tostring(originCityID) .. "_" .. tostring(targetPlayerID) .. "_" .. tostring(targetCityID);
    local lastTriggerTurn = pOriginCity:GetProperty(routeKey);
    if lastTriggerTurn == currentTurn then return; end
    pOriginCity:SetProperty(routeKey, currentTurn);

    local hasNingguangTagTeam:boolean = CustomGov_HasNingguangBasePromotion(originPlayerID);
    local siphonChance:number = POPULATION_SIPHON_CHANCE;
    if hasNingguangTagTeam then
        siphonChance = TAG_TEAM_POPULATION_SIPHON_CHANCE;
    end

    local roll:number = Game.GetRandNum(100, "CustomGov Keqing trade population siphon");
    if roll >= siphonChance then return; end

    pTargetCity:ChangePopulation(-1);
    pOriginCity:ChangePopulation(1);

    print("CustomGov Keqing: trade route siphoned 1 population from target city " .. tostring(targetCityID) .. " to origin city " .. tostring(originCityID));

    if hasNingguangTagTeam then
        CustomGov_ApplyNingguangTradeUnrest(pTargetCity, targetCityID);
    end
end

Events.TradeRouteActivityChanged.Add(CustomGov_TrySiphonPopulation);

-- Custom Governor - Keqing
-- Gameplay script for Liyue trade population siphon.
-- Keqing's base governor promotion increases the chance that an outgoing
-- international trade route pulls 1 population from the target city into the
-- origin city.

include("GameCapabilities");

local KEQING_GOVERNOR_TYPE:string = "GOVERNOR_KEQING";
local KEQING_BASE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_KEQING_BASE";
local LIYUE_LEADER_TRAIT:string = "TRAIT_LEADER_KEQING_THE_DRIVING_THUNDER";
local POPULATION_SIPHON_CHANCE:number = 35;
local LAST_ROUTE_PROPERTY_PREFIX:string = "CUSTOM_GOV_KEQING_LAST_POP_SIPHON_";

function CustomGov_HasKeqingBasePromotion(playerID:number)
    local pPlayer = Players[playerID];
    if pPlayer == nil then return false; end

    -- This add-on is intended to build on Keqing/Liyue mechanics from the
    -- Liyue and Inazuma Pack. Keep the script scoped to that leader trait.
    if not HasTrait(LIYUE_LEADER_TRAIT, playerID) then return false; end

    local governorInfo = GameInfo.Governors[KEQING_GOVERNOR_TYPE];
    local promotionInfo = GameInfo.GovernorPromotions[KEQING_BASE_PROMOTION_TYPE];
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

function CustomGov_GetCity(playerID:number, cityID:number)
    local pPlayer = Players[playerID];
    if pPlayer == nil then return nil; end

    local pCities = pPlayer:GetCities();
    if pCities == nil then return nil; end

    return pCities:FindID(cityID);
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

    local roll:number = Game.GetRandNum(100, "CustomGov Keqing trade population siphon");
    if roll >= POPULATION_SIPHON_CHANCE then return; end

    pTargetCity:ChangePopulation(-1);
    pOriginCity:ChangePopulation(1);

    print("CustomGov Keqing: trade route siphoned 1 population from target city " .. tostring(targetCityID) .. " to origin city " .. tostring(originCityID));
end

Events.TradeRouteActivityChanged.Add(CustomGov_TrySiphonPopulation);

-- Custom Governor - Keqing
-- Gameplay script for Liyue trade population siphon.
-- Keqing's governor tree improves Liyue's international trade routes.
-- Ningguang acts as a tag-team partner and turns successful population siphons
-- into political and economic pressure.

include("GameCapabilities");

local KEQING_GOVERNOR_TYPE:string = "GOVERNOR_KEQING";
local NINGGUANG_GOVERNOR_TYPE:string = "GOVERNOR_NINGGUANG";

local KEQING_BASE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_KEQING_BASE";
local KEQING_ADMINISTRATION_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_KEQING_1";
local KEQING_PLANNING_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_KEQING_2";
local KEQING_DECREE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_KEQING_3A";
local KEQING_ORDER_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_KEQING_3B";

local NINGGUANG_BASE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_NINGGUANG_BASE";
local NINGGUANG_PRESSURE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_NINGGUANG_1";
local NINGGUANG_INFLUENCE_PROMOTION_TYPE:string = "GOVERNOR_PROMOTION_NINGGUANG_2";

local LIYUE_LEADER_TRAIT:string = "TRAIT_LEADER_KEQING_THE_DRIVING_THUNDER";
local BASE_POPULATION_SIPHON_CHANCE:number = 35;
local KEQING_PLANNING_CHANCE_BONUS:number = 15;
local NINGGUANG_TAG_TEAM_CHANCE_BONUS:number = 15;
local KEQING_ADMINISTRATION_PRODUCTION:number = 25;
local KEQING_ADMINISTRATION_GOLD:number = 50;
local KEQING_DECREE_SCIENCE:number = 30;
local KEQING_DECREE_CULTURE:number = 30;
local KEQING_ORDER_ORIGIN_LOYALTY:number = 3;
local KEQING_ORDER_TARGET_LOYALTY:number = -3;
local NINGGUANG_TARGET_LOYALTY_PRESSURE:number = -5;
local NINGGUANG_PRESSURE_GOLD:number = 75;
local NINGGUANG_INFLUENCE_EXTRA_LOYALTY_PRESSURE:number = -5;
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

function CustomGov_GetCity(playerID:number, cityID:number)
    local pPlayer = Players[playerID];
    if pPlayer == nil then return nil; end

    local pCities = pPlayer:GetCities();
    if pCities == nil then return nil; end

    return pCities:FindID(cityID);
end

function CustomGov_ChangeCityLoyalty(pCity:table, amount:number)
    if pCity ~= nil and pCity.ChangeLoyalty ~= nil then
        pCity:ChangeLoyalty(amount);
    end
end

function CustomGov_AddGold(playerID:number, amount:number)
    local pPlayer = Players[playerID];
    if pPlayer == nil then return; end

    local pTreasury = pPlayer:GetTreasury();
    if pTreasury ~= nil then
        pTreasury:ChangeGoldBalance(amount);
    end
end

function CustomGov_AddProduction(pCity:table, amount:number)
    if pCity == nil or pCity.GetBuildQueue == nil then return; end

    local pBuildQueue = pCity:GetBuildQueue();
    if pBuildQueue ~= nil then
        pBuildQueue:AddProgress(amount);
    end
end

function CustomGov_AddResearchAndCulture(playerID:number, scienceAmount:number, cultureAmount:number)
    local pPlayer = Players[playerID];
    if pPlayer == nil then return; end

    local pTechs = pPlayer:GetTechs();
    if pTechs ~= nil and pTechs.ChangeCurrentResearchProgress ~= nil then
        pTechs:ChangeCurrentResearchProgress(scienceAmount);
    end

    local pCulture = pPlayer:GetCulture();
    if pCulture ~= nil and pCulture.ChangeCurrentCulturalProgress ~= nil then
        pCulture:ChangeCurrentCulturalProgress(cultureAmount);
    end
end

function CustomGov_ApplyNingguangTradeUnrest(pTargetCity:table, targetCityID:number, hasNingguangInfluence:boolean)
    if pTargetCity == nil then return; end

    -- Civ VI exposes a reliable city loyalty mutator. Direct amenity mutation is
    -- much less stable in gameplay Lua, so this models falling satisfaction as
    -- political unrest in the target city.
    CustomGov_ChangeCityLoyalty(pTargetCity, NINGGUANG_TARGET_LOYALTY_PRESSURE);
    print("CustomGov Ningguang: target city " .. tostring(targetCityID) .. " lost " .. tostring(math.abs(NINGGUANG_TARGET_LOYALTY_PRESSURE)) .. " loyalty from trade unrest");

    if hasNingguangInfluence then
        CustomGov_ChangeCityLoyalty(pTargetCity, NINGGUANG_INFLUENCE_EXTRA_LOYALTY_PRESSURE);
        print("CustomGov Ningguang: political influence applied extra loyalty pressure to target city " .. tostring(targetCityID));
    end
end

function CustomGov_TrySiphonPopulation(playerID:number, originPlayerID:number, originCityID:number, targetPlayerID:number, targetCityID:number)
    -- Only routes owned by the origin player should trigger this add-on effect.
    if playerID ~= originPlayerID then return; end

    -- Internal routes should not steal population.
    if originPlayerID == targetPlayerID then return; end

    if not CustomGov_HasGovernorPromotion(originPlayerID, KEQING_GOVERNOR_TYPE, KEQING_BASE_PROMOTION_TYPE) then return; end

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

    local hasKeqingAdministration:boolean = CustomGov_HasGovernorPromotion(originPlayerID, KEQING_GOVERNOR_TYPE, KEQING_ADMINISTRATION_PROMOTION_TYPE);
    local hasKeqingPlanning:boolean = CustomGov_HasGovernorPromotion(originPlayerID, KEQING_GOVERNOR_TYPE, KEQING_PLANNING_PROMOTION_TYPE);
    local hasKeqingDecree:boolean = CustomGov_HasGovernorPromotion(originPlayerID, KEQING_GOVERNOR_TYPE, KEQING_DECREE_PROMOTION_TYPE);
    local hasKeqingOrder:boolean = CustomGov_HasGovernorPromotion(originPlayerID, KEQING_GOVERNOR_TYPE, KEQING_ORDER_PROMOTION_TYPE);
    local hasNingguangTagTeam:boolean = CustomGov_HasGovernorPromotion(originPlayerID, NINGGUANG_GOVERNOR_TYPE, NINGGUANG_BASE_PROMOTION_TYPE);
    local hasNingguangPressure:boolean = CustomGov_HasGovernorPromotion(originPlayerID, NINGGUANG_GOVERNOR_TYPE, NINGGUANG_PRESSURE_PROMOTION_TYPE);
    local hasNingguangInfluence:boolean = CustomGov_HasGovernorPromotion(originPlayerID, NINGGUANG_GOVERNOR_TYPE, NINGGUANG_INFLUENCE_PROMOTION_TYPE);

    local siphonChance:number = BASE_POPULATION_SIPHON_CHANCE;
    if hasKeqingPlanning then
        siphonChance = siphonChance + KEQING_PLANNING_CHANCE_BONUS;
    end
    if hasNingguangTagTeam then
        siphonChance = siphonChance + NINGGUANG_TAG_TEAM_CHANCE_BONUS;
    end

    local roll:number = Game.GetRandNum(100, "CustomGov Keqing trade population siphon");
    if roll >= siphonChance then return; end

    pTargetCity:ChangePopulation(-1);
    pOriginCity:ChangePopulation(1);

    print("CustomGov Keqing: trade route siphoned 1 population from target city " .. tostring(targetCityID) .. " to origin city " .. tostring(originCityID));

    if hasKeqingAdministration then
        CustomGov_AddProduction(pOriginCity, KEQING_ADMINISTRATION_PRODUCTION);
        CustomGov_AddGold(originPlayerID, KEQING_ADMINISTRATION_GOLD);
        print("CustomGov Keqing: administration converted trade growth into production and gold");
    end

    if hasKeqingDecree then
        CustomGov_AddResearchAndCulture(originPlayerID, KEQING_DECREE_SCIENCE, KEQING_DECREE_CULTURE);
        print("CustomGov Keqing: decree converted trade intelligence into science and culture");
    end

    if hasKeqingOrder then
        CustomGov_ChangeCityLoyalty(pOriginCity, KEQING_ORDER_ORIGIN_LOYALTY);
        CustomGov_ChangeCityLoyalty(pTargetCity, KEQING_ORDER_TARGET_LOYALTY);
        print("CustomGov Keqing: Qixing order stabilized origin city and pressured target city");
    end

    if hasNingguangTagTeam then
        CustomGov_ApplyNingguangTradeUnrest(pTargetCity, targetCityID, hasNingguangInfluence);
    end

    if hasNingguangPressure then
        CustomGov_AddGold(originPlayerID, NINGGUANG_PRESSURE_GOLD);
        print("CustomGov Ningguang: economic pressure produced additional gold");
    end
end

Events.TradeRouteActivityChanged.Add(CustomGov_TrySiphonPopulation);

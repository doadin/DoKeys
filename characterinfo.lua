local GetRealmName = _G.GetRealmName
local UnitName = _G.UnitName
local GetOwnedKeystoneChallengeMapID = _G.C_MythicPlus.GetOwnedKeystoneChallengeMapID
local GetOwnedKeystoneLevel = _G.C_MythicPlus.GetOwnedKeystoneLevel
local GetAverageItemLevel = _G.GetAverageItemLevel
local CreateFrame = _G.CreateFrame
local C_ChallengeMode = _G.C_ChallengeMode
local C_ChatInfo = _G.C_ChatInfo
local C_MythicPlus = _G.C_MythicPlus
local C_PlayerInfo = _G.C_PlayerInfo
local isGuildMember = _G.IsInGuild
local UnitClass = _G.UnitClass
local UnitLevel = _G.UnitLevel
local C_Covenants = _G.C_Covenants
local tinsert = _G.tinsert
local LibDeflate = _G.LibStub:GetLibrary("LibDeflate")
local AceSerializer = _G.LibStub:GetLibrary("AceSerializer-3.0")

local date = _G.date
local time = _G.time
local GetCurrentRegion = _G.GetCurrentRegion
local GetServerTime = _G.GetServerTime
local difftime = _G.difftime
local wipe = _G.wipe
local strsplit = _G.strsplit
local GetGuildInfo = _G.GetGuildInfo

local DoKeysCurrentMaxLevel = _G.GetMaxLevelForExpansionLevel(_G.GetMaximumExpansionLevel())

local DoKeysDBFrame = CreateFrame("FRAME") --PLAYER_ENTERING_WORLD: isInitialLogin, isReloadingUi
DoKeysDBFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
DoKeysDBFrame:RegisterEvent("ADDON_LOADED")
DoKeysDBFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
DoKeysDBFrame:RegisterEvent("PLAYER_GUILD_UPDATE")

local DoKeysKeyStoneTrackingFrame = CreateFrame("FRAME")
DoKeysKeyStoneTrackingFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
DoKeysKeyStoneTrackingFrame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")
DoKeysKeyStoneTrackingFrame:RegisterEvent("BAG_UPDATE")
DoKeysKeyStoneTrackingFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")

local DoKeysKeyStoneWeeklyBestFrame = CreateFrame("FRAME")
DoKeysKeyStoneWeeklyBestFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
DoKeysKeyStoneWeeklyBestFrame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")

local DoKeysResetFrame = CreateFrame("FRAME")
DoKeysResetFrame:RegisterEvent("PLAYER_LOGIN")
DoKeysResetFrame:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")

local DoKeysGearFrame = CreateFrame("FRAME")
DoKeysGearFrame:RegisterEvent("BAG_UPDATE")
DoKeysGearFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")

local DoKeysTrackGuildKeysFrame = CreateFrame("FRAME", "DoKeysTrackGuildKeysFrame")
DoKeysTrackGuildKeysFrame:RegisterEvent("CHAT_MSG_ADDON")

local DoKeysRequestAKKMGuildKeysFrame = CreateFrame("FRAME")
DoKeysRequestAKKMGuildKeysFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
DoKeysRequestAKKMGuildKeysFrame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")
DoKeysRequestAKKMGuildKeysFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")

local UpdateSeasonBestsFrame = CreateFrame("FRAME")
UpdateSeasonBestsFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
UpdateSeasonBestsFrame:RegisterEvent("LOADING_SCREEN_DISABLED")

local UpdateCovenantFrame = CreateFrame("FRAME")
UpdateCovenantFrame:RegisterEvent("COVENANT_CHOSEN")

local C_MythicPlusEventFrame = CreateFrame("FRAME")
C_MythicPlusEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
C_MythicPlusEventFrame:RegisterEvent("PLAYER_LOGIN")

local RequestPartyKeysFrame = CreateFrame("FRAME")
RequestPartyKeysFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
RequestPartyKeysFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")

local TrackPartyKeysFrame = CreateFrame("FRAME")
TrackPartyKeysFrame:RegisterEvent("CHAT_MSG_ADDON")

local TrackBNETKeysFrame = CreateFrame("FRAME")
TrackBNETKeysFrame:RegisterEvent("BN_CHAT_MSG_ADDON")

local FindAddonUsersFrame = CreateFrame("FRAME")
FindAddonUsersFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
FindAddonUsersFrame:RegisterEvent("BN_FRIEND_INFO_CHANGED")
FindAddonUsersFrame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
FindAddonUsersFrame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")

local TrackKeyChangeFrame = CreateFrame("FRAME")
TrackKeyChangeFrame:RegisterEvent("CHALLENGE_MODE_START")
TrackKeyChangeFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
TrackKeyChangeFrame:RegisterEvent("ITEM_CHANGED")

local TrackNumRunsCompletedFrame = CreateFrame("FRAME")
TrackNumRunsCompletedFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")

local realmName = GetRealmName()

local playerName = UnitName("player")
local isAstralKeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("AstralKeys")
local isKeystoneManagerRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("KeystoneManager")
local DokeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("DoKeys")
local Covenantstable = {
    [0] = "None",
    [1] = "Kyrian",
    [2] = "Venthyr",
    [3] = "NightFae",
    [4] = "Necrolord"
}
local DoKeysPartyKeys = {}
local realmgroupid
do
    for i = 1, #connectionData do
        local lookforrealm = string.find(connectionData[i], tostring(GetRealmID()))
        if lookforrealm ~= nil then
            realmgroupid = strsplit(",", connectionData[i])
            break
        else
            realmgroupid = 0
        end
    end
end

local function SetupDB(_, event, one, _)
    C_MythicPlus.RequestRewards()
    if event == "ADDON_LOADED" and one == "DoKeys" then
        if _G.DoCharacters then
        else
            _G.DoCharacters = {}
        end
        if _G.DoCharacters[realmgroupid] then
        else
            _G.DoCharacters[realmgroupid] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"]  = {}
        end
    end
    if event == "PLAYER_ENTERING_WORLD" then
        if _G.DoCharacters then
        else
            _G.DoCharacters = {}
        end
        if _G.DoCharacters[realmgroupid] then
        else
            _G.DoCharacters[realmgroupid] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"]  = {}
        end
        local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel() --avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].avgItemLevel = avgItemLevel or 0
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].avgItemLevelEquipped = avgItemLevelEquipped or 0
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].avgItemLevelPvp = avgItemLevelPvp or 0
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].name = UnitName("player")
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].realm = GetRealmName()
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].level = UnitLevel("player")
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].class = select(2,UnitClass("player"))
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].covenant = Covenantstable[C_Covenants.GetActiveCovenantID()]
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentKeyLevel = GetOwnedKeystoneLevel() or 0
        local currentkeymapid = GetOwnedKeystoneChallengeMapID()
        local name = ""
        if type(currentkeymapid) == "number" then
            name = currentkeymapid and C_ChallengeMode.GetMapUIInfo(currentkeymapid)
        end
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentKeyInstance = name or ""
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyChestRewardLevel = C_MythicPlus.GetWeeklyChestRewardLevel() or 0
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].currentkeymapid = currentkeymapid or 0
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].weeklyCount = _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].weeklyCount or 0
        local data = C_PlayerInfo.GetPlayerMythicPlusRatingSummary("player")
        local seasonScore = data and data.currentSeasonScore
        if seasonScore and seasonScore >= 0 then
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].currentSeasonScore = seasonScore
        end
        for Bag = 0, NUM_BAG_SLOTS do
            for Slot = 1, GetContainerNumSlots(Bag) do
                local ID = GetContainerItemID(Bag, Slot)
                if (ID and ID == 187786) then
                    local ItemLink = GetContainerItemLink(Bag, Slot)
                    local _,_,three = strsplit("|",ItemLink)
                    local TWKeyName,TWKeyID,TWKeyInstance,TWKeyLevel,TWKeyAffix1,TWKeyAffix2,TWKeyAffix3,TWKeyAffix4 = strsplit(":",ItemLink)
                    if type(TWKeyInstance) == "string" and TWKeyInstance ~= "nil" and TWKeyInstance ~= "" then
                        local TWKeyInstanceName = C_ChallengeMode.GetMapUIInfo(TWKeyInstance)
                        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyInstanceName = TWKeyInstanceName
                    else
                        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyInstanceName = ""
                    end
                    if type(TWKeyLevel) == "string" and TWKeyLevel ~= "nil" and TWKeyLevel ~= "" then
                        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyLevel = tonumber(TWKeyLevel)
                    else
                        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyLevel = 0
                    end
                    if type(TWKeyInstance) == "string" and TWKeyInstance ~= "nil" and TWKeyInstance ~= "" then
                        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyID = tonumber(TWKeyInstance)
                    else
                        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyID = 0
                    end
                    if type(TWKeyAffix1) == "string" and TWKeyAffix1 ~= "nil" and TWKeyAffix1 ~= "" then
                        _G.DoCharacters.CurrentTWKeyAffix1 = tonumber(TWKeyAffix1)
                    else
                        _G.DoCharacters.CurrentTWKeyAffix1 = 0
                    end
                    if type(TWKeyAffix2) == "string" and TWKeyAffix2 ~= "nil" and TWKeyAffix2 ~= "" then
                        _G.DoCharacters.CurrentTWKeyAffix2 = tonumber(TWKeyAffix2)
                    else
                        _G.DoCharacters.CurrentTWKeyAffix2 = 0
                    end
                    if type(TWKeyAffix3) == "string" and TWKeyAffix3 ~= "nil" and TWKeyAffix3 ~= "" then
                        _G.DoCharacters.CurrentTWKeyAffix3 = tonumber(TWKeyAffix3)
                    else
                        _G.DoCharacters.CurrentTWKeyAffix3 = 0
                    end
                    if type(TWKeyAffix4) == "string" and TWKeyAffix4 ~= "nil" and TWKeyAffix4 ~= "" then
                        TWKeyAffix4 = strsplit("[",TWKeyAffix4)
                        _G.DoCharacters.CurrentTWKeyAffix4 = tonumber(TWKeyAffix4)
                    else
                        _G.DoCharacters.CurrentTWKeyAffix4 = 0
                    end
                end
            end
        end
    end
    if event == "LOADING_SCREEN_DISABLED" then
        local maps = C_ChallengeMode.GetMapTable()
        local best = _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest or 0
        for i = 1, #maps do
            local durationSec, weeklyLevel, completionDate, affixIDs, members = C_MythicPlus.GetWeeklyBestForMap(maps[i])
            if (not weeklyLevel) then
                weeklyLevel = 0
            end
            if weeklyLevel and weeklyLevel > best then
                best = weeklyLevel
            end

            local affixScores, bestOverAllScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(maps[i])
            local name
            if maps[i] then
                name = C_ChallengeMode.GetMapUIInfo(maps[i])
            end
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name] = {}
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"] = {}
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"] = {}
            if type(affixScores) == "table" then
                for mapid,affix in pairs(affixScores) do
                    if affix.name then
                        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name] = {}
                        tinsert(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name], 1, affix.level)
                    end
                    if affix.overTime then
                        tinsert(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name], 2, "")
                    else
                        tinsert(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name], 2, "+")
                    end
                end
                if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][1] then
                else
                    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][1] = 0
                end
                if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][1] then
                else
                    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][1] = 0
                end
                if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][2] then
                else
                    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][2] = ""
                end
                if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][2] then
                else
                    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][2] = ""
                end
            end
        end
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest = best
    end
    if (event == "PLAYER_ENTERING_WORLD" or event == "LOADING_SCREEN_DISABLED" or event == "PLAYER_GUILD_UPDATE") then
        if _G.DoCharacters then
        else
            _G.DoCharacters = {}
        end
        if _G.DoCharacters[realmgroupid] then
        else
            _G.DoCharacters[realmgroupid] = {}
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] = {}
        end
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].GuildName = isGuildMember() and GetGuildInfo("player") or "false"
    end
    if isAstralKeysRegistered then
    else
        C_ChatInfo.RegisterAddonMessagePrefix("AstralKeys")
    end
    if isKeystoneManagerRegistered then
    else
        C_ChatInfo.RegisterAddonMessagePrefix("KeystoneManager")
    end
    if DokeysRegistered then
    else
        C_ChatInfo.RegisterAddonMessagePrefix("DoKeys")
    end
end

local function UpdateCovenant(_, event, covenantID)
    if not covenantID then
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].covenant = Covenantstable[C_Covenants.GetActiveCovenantID()]
    else
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].covenant = Covenantstable[covenantID]
    end
end

--local lasttimesendupdatekeys
local function UpdateKeyStone(_, _)
    if not type(UnitLevel("player") == "number") or (UnitLevel("player") < DoKeysCurrentMaxLevel) then return end
    local currentkeymapid = GetOwnedKeystoneChallengeMapID()
    local name
    local keylevel
    if type(currentkeymapid) == "number" then
        name = currentkeymapid and C_ChallengeMode.GetMapUIInfo(currentkeymapid)
        keylevel = GetOwnedKeystoneLevel()
    end
    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentKeyInstance = name or ""
    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentKeyLevel = GetOwnedKeystoneLevel() or 0
    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].currentkeymapid = currentkeymapid or 0
    for Bag = 0, NUM_BAG_SLOTS do
        for Slot = 1, GetContainerNumSlots(Bag) do
            local ID = GetContainerItemID(Bag, Slot)
            if (ID and ID == 187786) then
                local ItemLink = GetContainerItemLink(Bag, Slot)
                local _,_,three = strsplit("|",ItemLink)
                local TWKeyName,TWKeyID,TWKeyInstance,TWKeyLevel,TWKeyAffix1,TWKeyAffix2,TWKeyAffix3,TWKeyAffix4 = strsplit(":",ItemLink)
                if type(TWKeyInstance) == "string" and TWKeyInstance ~= "nil" and TWKeyInstance ~= "" then
                    local TWKeyInstanceName = C_ChallengeMode.GetMapUIInfo(TWKeyInstance)
                    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyInstanceName = TWKeyInstanceName
                end
                if type(TWKeyLevel) == "string" and TWKeyLevel ~= "nil" and TWKeyLevel ~= "" then
                    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentTWKeyLevel = TWKeyLevel
                end
            end
        end
    end
    --if type(lasttimesendupdatekeys) == "number" and (_G.GetTime() - lasttimesendupdatekeys < 60) then
    --    return
    --end
    local isAstralKeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("AstralKeys")
    if isAstralKeysRegistered and isGuildMember() then
        if _G.DoCharacters[realmgroupid][UnitName("player")  .. "-" .. GetRealmName()].class and _G.DoCharacters[realmgroupid][UnitName("player")  .. "-" .. GetRealmName()].WeeklyBest and _G.DoCharacters.Week then
            C_ChatInfo.SendAddonMessage('AstralKeys', 'updateV8 ' .. UnitName("player") .. "-" .. GetRealmName() .. ":" .. (_G.DoCharacters[realmgroupid][UnitName("player")  .. "-" .. GetRealmName()].class) .. ":" .. (currentkeymapid or 0) .. ":" .. (GetOwnedKeystoneLevel() or 0) .. ":" .. (_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest or 0) .. ":" .. _G.DoCharacters.Week .. ":" .. "1", 'GUILD')
        end
    end

    local DokeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("DoKeys")
    if DokeysRegistered and isGuildMember() then
        if _G.DoCharacters[realmgroupid][UnitName("player")  .. "-" .. GetRealmName()].class and _G.DoCharacters[realmgroupid][UnitName("player")  .. "-" .. GetRealmName()].WeeklyBest and _G.DoCharacters.Week then
            C_ChatInfo.SendAddonMessage('DoKeys', 'updateV8 ' .. UnitName("player") .. "-" .. GetRealmName() .. ":" .. (_G.DoCharacters[realmgroupid][UnitName("player")  .. "-" .. GetRealmName()].class) .. ":" .. (currentkeymapid or 0) .. ":" .. (GetOwnedKeystoneLevel() or 0) .. ":" .. (_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest or 0) .. ":" .. _G.DoCharacters.Week .. ":" .. "1", 'GUILD')
        end
    end
    --lasttimesendupdatekeys = _G.GetTime()
end

local function UpdateGear()
    local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel() --avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp
    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].avgItemLevel = avgItemLevel or 0
    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].avgItemLevelEquipped = avgItemLevelEquipped or 0
    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].avgItemLevelPvp = avgItemLevelPvp or 0
end

local function UpdateWeeklyBest(_, event, one, _, three)
    local timed
    if event == "MYTHIC_PLUS_NEW_WEEKLY_RECORD" then
        local name
        if one then
            name = one and C_ChallengeMode.GetMapUIInfo(one)
        end
        local _, _, _, _, keystoneUpgradeLevels, _ = C_ChallengeMode.GetCompletionInfo()
        local weeklybest = _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest or 0
        if weeklybest <= three then
            if keystoneUpgradeLevels == 3 then
                timed = "+++"
            elseif keystoneUpgradeLevels == 2 then
                timed = "++"
            elseif keystoneUpgradeLevels == 1 then
                timed = "+"
            elseif keystoneUpgradeLevels == 0 then -- or onTime = false
                timed = "Not In Time"
            end
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBestInstanceName = name
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBestLevel = three
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBestLevelTimed = timed
        end
        local best = _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest or 0
        if best < three then
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest = three
        end
        local isAstralKeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("AstralKeys")
        if isAstralKeysRegistered and isGuildMember() then
            C_ChatInfo.SendAddonMessage('AstralKeys', 'updateWeekly ' .. three, 'GUILD')
        end
        local DokeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("DoKeys")
        if DokeysRegistered and isGuildMember() then
            C_ChatInfo.SendAddonMessage('DoKeys', 'updateWeekly ' .. three, 'GUILD')
        end
    end
end

local function UpdateSeasonBests(_, event)
    local maps = C_ChallengeMode.GetMapTable()
    if realmgroupid == nil then
        return
    end
    if UnitName("player") == nil then
        return
    end
    for i = 1, #maps do
        local affixScores, bestOverAllScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(maps[i])
        local name = C_ChallengeMode.GetMapUIInfo(maps[i])
        if type(affixScores) ~= "table" then
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name] = {}
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"] = {}
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"] = {}
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][1] = 0
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][1] = 0
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][2] = ""
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][2] = ""
        end

        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name] = {}
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"] = {}
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"] = {}
        if type(affixScores) == "table" then
            for mapid,affix in pairs(affixScores) do
                if affix.name then
                    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name] = {}
                    tinsert(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name], 1, affix.level)
                end
                if affix.overTime then
                    tinsert(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name], 2, "")
                else
                    tinsert(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name][affix.name], 2, "+")
                end
            end
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][1] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][1] = 0
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][1] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][1] = 0
        end

        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][2] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Tyrannical"][2] = ""
        end
        if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][2] then
        else
            _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"]["seasonbests"][name]["Fortified"][2] = ""
        end
    end
end

local function CompressAndEncode(input)
	local compressed = LibDeflate:CompressDeflate(AceSerializer:Serialize(input))
	return LibDeflate:EncodeForWoWAddonChannel(compressed)
end

local function DecompressAndDecode(input)
    local decoded = LibDeflate:DecodeForWoWAddonChannel(input)
    if decoded == "request" then
        return decoded
    end
    local success, deserialized = decoded and AceSerializer:Deserialize(LibDeflate:DecompressDeflate(decoded))
    if not success then
        print('There was issue with receiving guild keys, please report this to Addon Author.')
    end
    return deserialized
end

local function RequestGuildKeys(_, event)
    if event == "LOADING_SCREEN_DISABLED" or event == "MYTHIC_PLUS_NEW_WEEKLY_RECORD" or event == "CHALLENGE_MODE_COMPLETED" or event == "GUILD_ROSTER_UPDATE" then
        local isAstralKeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("AstralKeys")
        local isKeystoneManagerRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("KeystoneManager")
        local DokeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("DoKeys")
        if isAstralKeysRegistered then
            C_ChatInfo.SendAddonMessage('AstralKeys', 'request', 'GUILD')
        end
        if isKeystoneManagerRegistered then
            C_ChatInfo.SendAddonMessage('KeystoneManager', 'request', 'GUILD')
        end
        if DokeysRegistered then
            C_ChatInfo.SendAddonMessage('DoKeys', 'request', 'GUILD')
        end
    end
end

--local lasttimesendkeys
local function SendGuildKeys(style, prefix)
    if style == "AstralKeys" then
        local testtable = {}
        local AstralKeysi = 0
        for key, value in pairs(_G.DoCharacters[realmgroupid]) do
            AstralKeysi = AstralKeysi+1
            tinsert(testtable,AstralKeysi,value)
        end
        for i=1,#testtable do
            local needtoremove = false
            if not testtable[i].level then
                needtoremove = true
            end
            if not testtable[i].name  then
                needtoremove = true
            end
            if not testtable[i].realm  then
                needtoremove = true
            end
            if not testtable[i].class then
                needtoremove = true
            end
            if not testtable[i]["mythicplus"]["keystone"].currentkeymapid then
                needtoremove = true
            end
            if not testtable[i]["mythicplus"]["keystone"].CurrentKeyLevel then
                needtoremove = true
            end
            if not testtable[i]["mythicplus"]["keystone"].WeeklyBest then
                needtoremove = true
            end
            if needtoremove then
                table.remove(testtable,i)
            end
        end
        local text = ""
        if prefix == "AstralKeys" then
            while testtable[1] do
                text = "sync5 "
                for i=1,4 do
                    if testtable[i] then
                        if testtable[i].level == 60 then
                            text = text .. testtable[i].name .. "-" .. testtable[i].realm .. ":" .. testtable[i].class .. ":" .. testtable[i]["mythicplus"]["keystone"].currentkeymapid .. ":" .. testtable[i]["mythicplus"]["keystone"].CurrentKeyLevel .. ":" .. testtable[i]["mythicplus"]["keystone"].WeeklyBest .. ":" .. _G.DoCharacters.Week .. ":1" .. "_"
                        end
                    end
                    table.remove(testtable, i)
                end
                local isAstralKeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("AstralKeys")
                if isAstralKeysRegistered then
                    C_ChatInfo.SendAddonMessage("AstralKeys", text, "GUILD")
                end
            end
        end
        if prefix == "DoKeys" then
            while testtable[1] do
                text = "sync5 "
                for i=1,4 do
                    if testtable[i] then
                        if testtable[i].level == 60 then
                            text = text .. testtable[i].name .. "-" .. testtable[i].realm .. ":" .. testtable[i].class .. ":" .. testtable[i]["mythicplus"]["keystone"].currentkeymapid .. ":" .. testtable[i]["mythicplus"]["keystone"].CurrentKeyLevel .. ":" .. testtable[i]["mythicplus"]["keystone"].WeeklyBest .. ":" .. _G.DoCharacters.Week .. ":1" .. ":" .. testtable[i].avgItemLevelEquipped .. "_"
                        end
                    end
                    table.remove(testtable, i)
                end
                local DokeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("DoKeys")
                if DokeysRegistered then
                    C_ChatInfo.SendAddonMessage("DoKeys", text, 'GUILD')
                end
            end
        end
    end
    if style == "KeystoneManager" then
        local KeystoneManagerSendTable
        local GuildName = GetGuildInfo()
        if GuildName == nil then return end
        for CharacterName, Data in pairs(_G.DoCharacters[realmgroupid]) do
            local NameRealm = CharacterName  .. "-" .. _G.DoCharacters[realmgroupid]
            --["Mickdonalds-Malorne"] = {
            --    ["mapId"] = 376,
            --    ["class"] = "WARRIOR",
            --    ["mapName"] = "The Necrotic Wake",
            --    ["weeklyBest"] = 0,
            --    ["week"] = 257,
            --    ["name"] = "Mickdonalds-Malorne",
            --    ["shortName"] = "Mickdonalds",
            --    ["level"] = 0,
            --    ["guild"] = "The Bad and the Ugly",
            --    ["timestamp"] = 1,
            --},
            KeystoneManagerSendTable[NameRealm] = {
                ["mapId"] = Data.mythicplus.keystone.currentkeymapid,
                ["class"] = Data.class,
                ["mapName"] = Data.mythicplus.keystone.CurrentKeyInstance,
                ["weeklyBest"] = Data.mythicplus.keystone.WeeklyBestLevel,
                ["week"] = _G.DoCharacters.Week,
                ["name"] = NameRealm,
                ["shortName"] = Data.name,
                ["level"] = Data.level,
                ["guild"] = GuildName,
                ["timestamp"] = 1,
            }

        end
        local isKeystoneManagerRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("KeystoneManager")
        if isKeystoneManagerRegistered then
            local KeystoneManagerDataToSend = CompressAndEncode(KeystoneManagerSendTable)
            C_ChatInfo.SendAddonMessage("KeystoneManager", KeystoneManagerDataToSend, 'GUILD')
        end
    end
    lasttimesendkeys = _G.GetTime()
end

local function TrackGuildKeys(_, event, prefix, text, channel, sender, _, _, _, _, _)
    --if (prefix ~= "AstralKeys" or prefix ~= "KeystoneManager" or prefix ~= "DoKeys") then print(prefix, " not our prefix") return end
    local Player,PlayerRealm  = UnitName("player"), GetRealmName()
    if Player and PlayerRealm then
        if sender == Player .. "-" .. PlayerRealm then
            --print("got message from us?")
            return
        end
    end
    if sender == Player then
        --print("got message from us?")
        return
    end
    --_G.C_GuildInfo.GuildRoster()
    --local numberofguildMembers = _G.GetNumGuildMembers()
    --if numberofguildMembers <=0 then return end
    --for i=1,_G.GetNumGuildMembers() do
    --    local name, rank = _G.GetGuildRosterInfo(i)
    --    SendersGuildSame = false
    --    if name == sender then
    --        SendersGuildSame = true
    --        --return
    --    end
    --end
    local GuildName = GetGuildInfo("player")
    if not GuildName then return end
    local method = ""
    if text then
        method = text:match('%w+')
    end
    if prefix == "AstralKeys" then
        if text == "request" then
            SendGuildKeys("AstralKeys", "AstralKeys")
        end
        if method == "sync5" and channel == "GUILD" then --Handle received syncs
            local _, NewText2 = strsplit(" ",text) -- NewText = type Newtext2 = 6 Player Units
            if NewText2 then
                local AstralCharacterTable = {strsplit("_",NewText2)}
                for i,data in pairs(AstralCharacterTable) do
                    if data then
                        local NameRealm,Class,KeyMapID,KeyLevel,WeeklyBest,Week,ID = strsplit(":",data)
                        if tonumber(Week) ~= tonumber(_G.DoCharacters.Week) then return end
                        local lName , lRealm = strsplit("-",NameRealm)
                        local bName , bRealm = UnitName("player"), GetRealmName()
                        if _G.DoCharacters then
                        else
                            return
                        end
                        if _G.DoCharacters[realmgroupid] then
                        else
                            return
                        end
                        if _G.DoCharacters[realmgroupid][lName .. "-" .. lRealm] then
                        else
                            if lName == bName and lRealm == bRealm then
                            else
                                if NameRealm and Class and KeyMapID and KeyLevel and WeeklyBest and Week and ID then
                                    if type(_G.DoKeysGuild) ~= "table" then
                                        _G.DoKeysGuild = {}
                                    end
                                    if type(_G.DoKeysGuild[realmgroupid]) ~= "table" then
                                        _G.DoKeysGuild[realmgroupid] = {}
                                    end
                                    if type(_G.DoKeysGuild[realmgroupid][GuildName]) ~= "table" then
                                        _G.DoKeysGuild[realmgroupid][GuildName] = {}
                                    end
                                    if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]) ~= "table" then
                                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm] = {}
                                    end
                                    if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]) ~= "table" then
                                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"] = {}
                                    end
                                    if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"]) ~= "table" then
                                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
                                    end
                                    -- Add Data
                                    local guildkeyname
                                    if KeyMapID then
                                        guildkeyname = C_ChallengeMode.GetMapUIInfo(KeyMapID) or ""
                                    end
                                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyLevel = tonumber(KeyLevel)
                                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
                                    if (tonumber(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest) or 0) <= tonumber(WeeklyBest) then
                                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = tonumber(WeeklyBest)
                                    end
                                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].Week = Week
                                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].Class = Class
                                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].name = NameRealm
                                end
                            end
                        end
                    end
                end
            end
        end
        if method == "updateWeekly" and channel == "GUILD" then --Handle new weekly best from characters
            local _,WeeklyBest = strsplit(" ", text)
            local NameRealm = sender
            if not WeeklyBest then
                return
            end
            if type(_G.DoKeysGuild) ~= "table" then
                _G.DoKeysGuild = {}
            end
            if type(_G.DoKeysGuild[realmgroupid]) ~= "table" then
                _G.DoKeysGuild[realmgroupid] = {}
            end
            if type(_G.DoKeysGuild[realmgroupid][GuildName]) ~= "table" then
                _G.DoKeysGuild[realmgroupid][GuildName] = {}
            end
            if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]) ~= "table" then
                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm] = {}
            end
            if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]) ~= "table" then
                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"] = {}
            end
            if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"]) ~= "table" then
                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
            end
            if (tonumber(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest) or 0) <= tonumber(WeeklyBest) then
                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = tonumber(WeeklyBest)
            end
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].name = NameRealm
        end
        if method == "updateV8" and channel == "GUILD" then
            local _,KeyData = strsplit(" ", text)
            local NameRealm, Class, KeyInstance, KeyLevel, weeklyBest, week, random = strsplit(":",KeyData)
            if tonumber(week) ~= tonumber(_G.DoCharacters.Week) then return end
            if type(KeyData) ~= "string" then
                return
            end
            if type(GuildName) ~= "string" then
                return
            end
            if type(NameRealm) ~= "string" then
                return
            end
            --for GuildNameList in pairs(_G.DoKeysGuild) do
                --if GuildNameList == GuildName then
                if type(_G.DoKeysGuild) ~= "table" then
                    _G.DoKeysGuild = {}
                end
                if type(_G.DoKeysGuild[realmgroupid]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
                end
                --end
            --end
            local guildkeyname
            if KeyInstance then
                guildkeyname = C_ChallengeMode.GetMapUIInfo(KeyInstance) or ""
            end
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyLevel = tonumber(KeyLevel)
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
            if (tonumber(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest) or 0) <= tonumber(weeklyBest) then
                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = tonumber(weeklyBest)
            end
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].Class = Class
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].name = NameRealm
        end
    end
    if prefix == "KeystoneManager" then
        local request = DecompressAndDecode(text) --table
        if type(request) ~= 'table' then return end
        if request.command == 'updateKeys' then
            if type(request.data) ~= 'table' then return end
            for name, keyInfo in pairs(request.data) do
                if tonumber(keyInfo.week) ~= tonumber(_G.DoCharacters.Week) then return end
                if type(_G.DoKeysGuild) ~= "table" then
                    _G.DoKeysGuild = {}
                end
                if type(_G.DoKeysGuild[realmgroupid]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]["keystone"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]["keystone"] = {}
                end
                local guildkeyname
                if keyInfo.mapId then
                    guildkeyname = C_ChallengeMode.GetMapUIInfo(keyInfo.mapId)  or ""
                end
                _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]["keystone"].CurrentKeyLevel = tonumber(keyInfo.level)
                _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
                if (tonumber(_G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]["keystone"].WeeklyBest) or 0) <= tonumber(keyInfo.weeklyBest) then
                    _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]["keystone"].WeeklyBest = tonumber(keyInfo.weeklyBest)
                end
                _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name]["mythicplus"]["keystone"].Week = keyInfo.week
                _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name].Class = keyInfo.class
                _G.DoKeysGuild[realmgroupid][GuildName][keyInfo.name].name = keyInfo.name
            end
        end
        if request.command == 'request' then
            SendGuildKeys("KeystoneManager")
        end
    end
    if prefix == "DoKeys" then
        if text == "request" then
            SendGuildKeys("AstralKeys", "DoKeys")
        end
        if method == "sync5" and channel == "GUILD" then --Handle received syncs
            local _, NewText2 = strsplit(" ",text) -- NewText = type Newtext2 = 6 Player Units
            if NewText2 then
                local AstralCharacterTable = {strsplit("_",NewText2)}
                for i,data in pairs(AstralCharacterTable) do
                    if data then
                        local NameRealm,Class,KeyMapID,KeyLevel,WeeklyBest,Week,TS,AIL = strsplit(":",data)
                        if tonumber(Week) ~= tonumber(_G.DoCharacters.Week) then return end
                        if NameRealm and Class and KeyMapID and KeyLevel and WeeklyBest and Week then
                            if type(_G.DoKeysGuild) ~= "table" then
                                _G.DoKeysGuild = {}
                            end
                            if type(_G.DoKeysGuild[realmgroupid]) ~= "table" then
                                _G.DoKeysGuild[realmgroupid] = {}
                            end
                            if type(_G.DoKeysGuild[realmgroupid][GuildName]) ~= "table" then
                                _G.DoKeysGuild[realmgroupid][GuildName] = {}
                            end
                            if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]) ~= "table" then
                                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm] = {}
                            end
                            if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]) ~= "table" then
                                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"] = {}
                            end
                            if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"]) ~= "table" then
                                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
                            end
                        else
                            return
                        end
                        local guildkeyname
                        if KeyMapID then
                            guildkeyname = C_ChallengeMode.GetMapUIInfo(KeyMapID)  or ""
                        end
                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyLevel = tonumber(KeyLevel)
                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
                        if (tonumber(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest) or 0) <= tonumber(WeeklyBest) then
                            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = tonumber(WeeklyBest)
                        end
                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].Week = Week
                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].Class = Class
                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].name = NameRealm
                        _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].avgItemLevelEquipped = AIL and tonumber(AIL) or 0
                    end
                end
            end
        end
        if method == "updateWeekly" and channel == "GUILD" then
            local _,WeeklyBest = strsplit(" ", text)
            local NameRealm = sender
            if not WeeklyBest then
                return
            end
            --for GuildNameList in pairs(_G.DoKeysGuild) do
                --if GuildNameList == GuildName then
                if type(_G.DoKeysGuild) ~= "table" then
                    _G.DoKeysGuild = {}
                end
                if type(_G.DoKeysGuild[realmgroupid]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
                end
                --end
            --end
            if (tonumber(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest) or 0) <= tonumber(WeeklyBest) then
                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = tonumber(WeeklyBest)
            end
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].name = NameRealm
        end
        if method == "updateV8" and channel == "GUILD" then
            local _,KeyData = strsplit(" ", text)
            local NameRealm, Class, KeyInstance, KeyLevel, weeklyBest, week, random = strsplit(":",KeyData)
            if tonumber(week) ~= tonumber(_G.DoCharacters.Week) then return end
            if type(KeyData) ~= "string" then
                return
            end
            if type(GuildName) ~= "string" then
                return
            end
            if type(NameRealm) ~= "string" then
                return
            end
            --for GuildNameList in pairs(_G.DoKeysGuild) do
                --if GuildNameList == GuildName then
                if type(_G.DoKeysGuild) ~= "table" then
                    _G.DoKeysGuild = {}
                end
                if type(_G.DoKeysGuild[realmgroupid]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"] = {}
                end
                if type(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"]) ~= "table" then
                    _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
                end
                --end
            --end
            local guildkeyname
            if KeyInstance then
                guildkeyname = C_ChallengeMode.GetMapUIInfo(KeyInstance)  or ""
            end
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyLevel = tonumber(KeyLevel)
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
            if (tonumber(_G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest) or 0) <= tonumber(weeklyBest) then
                _G.DoKeysGuild[realmgroupid][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = tonumber(weeklyBest)
            end
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].Class = Class
            _G.DoKeysGuild[realmgroupid][GuildName][NameRealm].name = NameRealm
        end
    end
end

local function FindAddonUsers(_, event, one)
    if not one then
        for i=1,_G.BNGetNumFriends() do
            local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
            if accountInfo and accountInfo.gameAccountInfo.wowProjectID == 1 then
                _G.BNSendGameData(accountInfo.gameAccountInfo.gameAccountID, "AstralKeys", "BNet_query ping")
                _G.BNSendGameData(accountInfo.gameAccountInfo.gameAccountID, "DoKeys", "BNet_query ping")
            end
        end
    else
        local accountInfo = C_BattleNet.GetFriendAccountInfo(one)
        if accountInfo and accountInfo.gameAccountInfo.wowProjectID == 1 then
            _G.BNSendGameData(accountInfo.gameAccountInfo.gameAccountID, "AstralKeys", "BNet_query ping")
            _G.BNSendGameData(accountInfo.gameAccountInfo.gameAccountID, "DoKeys", "BNet_query ping")
        end
    end
end

local function TrackBNETFriends(_, event, prefix, text, channel, senderID)
    if type(_G.DoKeysBNETFriendsKeys) ~= "table" then
        _G.DoKeysBNETFriendsKeys = {}
    end
    local method,KeyData = strsplit(" ", text)
    if prefix == "AstralKeys" or prefix == "DoKeys" then
        if method == "BNet_query" and KeyData == "response" then
            --send AK a responce so it thinks we have AK
            local accountInfo
            for i=1,_G.BNGetNumFriends() do
                accountInfo = C_BattleNet.GetAccountInfoByID(i)
                if accountInfo and accountInfo.gameAccountInfo.gameAccountID == senderID then
                    break
                end
            end
            local btag = accountInfo and accountInfo.isBattleTagFriend and accountInfo.battleTag
            if accountInfo.isFriend or accountInfo.isBattleTagFriend then
                if type(_G.DoKeysBNETFriendsKeys[btag]) ~= "table" then
                    _G.DoKeysBNETFriendsKeys[btag] = {isBattleTagFriend = accountInfo.isBattleTagFriend, hasAK = (prefix == "AstralKeys" and true) or false, hasDoKeys = (prefix == "DoKeys" and true) or false}
                else
                    _G.DoKeysBNETFriendsKeys[btag].isBattleTagFriend = accountInfo.isBattleTagFriend
                    _G.DoKeysBNETFriendsKeys[btag].hasAK = (prefix == "AstralKeys" and true) or false
                    _G.DoKeysBNETFriendsKeys[btag].hasDoKeys = (prefix == "DoKeys" and true) or false
                end
            end
        end
        if method == "BNet_query" and KeyData == "ping" then
            --send AK a responce so it thinks we have AK
            _G.BNSendGameData(senderID, prefix, "BNet_query response")
            local testtable = {}
            local AstralKeysi = 0
            for key, value in pairs(_G.DoCharacters[realmgroupid]) do
                AstralKeysi = AstralKeysi+1
                tinsert(testtable,AstralKeysi,value)
            end
            for i=1,#testtable do
                local needtoremove = false
                if not testtable[i].level then
                    needtoremove = true
                end
                if not testtable[i].name  then
                    needtoremove = true
                end
                if not testtable[i].realm  then
                    needtoremove = true
                end
                if not testtable[i].class then
                    needtoremove = true
                end
                if not testtable[i]["mythicplus"]["keystone"].currentkeymapid then
                    needtoremove = true
                end
                if not testtable[i]["mythicplus"]["keystone"].CurrentKeyLevel then
                    needtoremove = true
                end
                if not testtable[i]["mythicplus"]["keystone"].WeeklyBest then
                    needtoremove = true
                end
                if needtoremove then
                    table.remove(testtable,i)
                end
            end
            local text = ""
            while testtable[1] do
                text = "sync4 "
                for i=1,4 do
                    if testtable[i] then
                        if testtable[i].level == 60 then
                            text = text .. testtable[i].name .. "-" .. testtable[i].realm .. ":" .. testtable[i].class .. ":" .. testtable[i]["mythicplus"]["keystone"].currentkeymapid .. ":" .. testtable[i]["mythicplus"]["keystone"].CurrentKeyLevel .. ":" .. testtable[i]["mythicplus"]["keystone"].WeeklyBest .. ":" .. _G.DoCharacters.Week .. ":1" .. "_"
                        end
                    end
                    table.remove(testtable, i)
                end
                _G.BNSendGameData(senderID, prefix, text)
            end
        end
        if method == "sync4" then
            local accountInfo
            for i=1,_G.BNGetNumFriends() do
                accountInfo = C_BattleNet.GetAccountInfoByID(i)
                if accountInfo and accountInfo.gameAccountInfo.gameAccountID == senderID then
                    break
                end
            end
            local btag = accountInfo and accountInfo.isBattleTagFriend and accountInfo.battleTag
            local _, NewText2 = strsplit(" ",text)
            local AstralCharacterTable = {strsplit("_",NewText2)}
            for i,data in pairs(AstralCharacterTable) do
                local NameRealm, class, KeyInstanceID, KeyLevel, Week = strsplit(":",data)
                if not NameRealm or NameRealm == "" then return end
                if accountInfo.isFriend or accountInfo.isBattleTagFriend then
                    if type(_G.DoKeysBNETFriendsKeys[btag]) ~= "table" then
                        _G.DoKeysBNETFriendsKeys[btag] = {}
                    end
                    _G.DoKeysBNETFriendsKeys[btag][NameRealm] = {KeyInstanceID = KeyInstanceID and KeyInstanceID, KeyLevel = KeyLevel and KeyLevel, Week = Week and Week, KeyInstance = KeyInstanceID and C_ChallengeMode.GetMapUIInfo(KeyInstanceID), class = class and class}
                end
            end
        end
    end
    --print(event, prefix, text, channel, senderID)
end

local function TrackPartyKeys(_, event, prefix, text, channel, sender, _, _, _, _, _)
    local method = ""
    if text then
        method = text:match('%w+')
    end
    if prefix == "DoKeys" then
        if text == "PartyRequest" then
            local bName , bRealm = UnitName("player"), GetRealmName()
            C_ChatInfo.SendAddonMessage("DoKeys","PARTYKEY" .. " " .. tostring(UnitName("player")) .. "-" .. tostring(GetRealmName()) .. ":" .. tostring(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].currentkeymapid) .. ":" .. tostring(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].CurrentKeyLevel) .. ":" .. tostring(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest), "PARTY")
        end
        if method == "PARTYKEY" then
            local _,KeyData = strsplit(" ", text)
            local NameRealm, KeyInstanceID, KeyLevel, weeklyBest = strsplit(":",KeyData)
            if type(_G.DoKeysPartyKeys) ~= "table" then
                _G.DoKeysPartyKeys = {}
            end
            _G.DoKeysPartyKeys[NameRealm] = {KeyInstanceID = KeyInstanceID, KeyLevel = KeyLevel, weeklyBest = weeklyBest, KeyInstance = KeyInstanceID and C_ChallengeMode.GetMapUIInfo(KeyInstanceID)}
        end
    end
end

local initializeTime = {}
initializeTime[1] = 1500390000 -- US Tuesday at reset
initializeTime[2] = 1500447600 -- EU Wednesday at reset
initializeTime[3] = 1500505200 -- CN Thursday at reset
initializeTime[4] = 0

local function DoWeeklyKeyReset()
    if not type(_G.DoCharacters == "table") then
        return
    end
    if not type(_G.DoCharacters[realmgroupid] == "table") then
        return
    end
    for _, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
        if type(v == "table") then
           for k, v in pairs(v) do
              if k == "mythicplus" then
                 for k, v in pairs(v) do
                    if k == "keystone" then
                        v.WeeklyBest =  0
                        v.WeeklyBestInstanceName =  ""
                        v.WeeklyBestLevel =  0
                        v.WeeklyBestLevelTimed =  ""
                        v.CurrentKeyLevel = 0
                        v.CurrentKeyInstance = ""
                        v.CurrentTWKeyLevel = 0
                        v.CurrentTWKeyInstanceName = ""
                        v.CurrentTWKeyID = 0
                        v.weeklyCount = 0
                    end
                 end
              end
           end
        end
    end
    if type(_G.DoKeysGuild) == "table" then
        wipe(_G.DoKeysGuild)
    end
    if type(_G.DoKeysBNETFriendsKeys) == "table" then
        wipe(_G.DoKeysBNETFriendsKeys)
    end
end

local function DoSeasonReset()
    for _, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
        if type(v == "table") then
            for k, v in pairs(v) do
                if k == "mythicplus" then
                    for k, v in pairs(v) do
                        if k == "keystone" then
                            wipe(v["seasonbests"])
                        end
                    end
                end
            end
        end
    end
    UpdateSeasonBests()
end

local function DataResetTime()
    local region = GetCurrentRegion()
    local serverTime = GetServerTime()
    local d = date('*t', serverTime)
    local hourOffset = math.modf(difftime(serverTime, time(date('!*t', serverTime))))/3600
    local minOffset = 0 --luacheck: ignore 321
    local hours
    local days
    if region ~= 3 then -- Not EU
       hours = 15 + (d.isdst and 1 or 0) + hourOffset
       if d.wday > 2 then
          if d.wday == 3 then
             days = (d.hour < hours and 0 or 7)
          else
             days = 10 - d.wday
          end
       else
          days = 3 - d.wday
       end
    else -- EU
       hours = 7 + (d.isdst and 1 or 0) + hourOffset
       if d.wday > 3 then
          if d.wday == 4 then
             days = (d.hour < hours and 0 or 7)
          else
             days = 11 - d.wday
          end
       else
          days = 4 - d.wday
       end
    end
    local resttime = (((days * 24 + hours) * 60 + minOffset) * 60) + serverTime - d.hour*3600 - d.min*60 - d.sec
    return resttime
 end

local function Reset()
    if not _G.DoCharacters.init_time then
        _G.DoCharacters.init_time = DataResetTime()
    end
    if not _G.DoCharacters.init_season or _G.DoCharacters.init_season < 1 then
        _G.DoCharacters.init_season = C_MythicPlus.GetCurrentSeason()
    end
    local region = GetCurrentRegion()
    local currentTime = GetServerTime()
    local d = date('*t', currentTime)
    local hourOffset = math.modf(difftime(currentTime, time(date('!*t', currentTime))))/3600
    if region ~= 3 then -- Non EU
        _G.DoCharacters.Week = math.floor((GetServerTime() - initializeTime[1]) / 604800)
    else
        _G.DoCharacters.Week = math.floor((GetServerTime() - initializeTime[2]) / 604800)
    end

    if currentTime > _G.DoCharacters.init_time then
        DoWeeklyKeyReset()
        _G.DoCharacters.init_time = DataResetTime()
    end
    if d.wday == 3 and d.hour < (16 + hourOffset + (d.isdst and 1 or 0)) and region ~= 3 then
        local frame = CreateFrame('FRAME')
        frame.elapsed = 0
        frame.first = true
        frame.interval = 60 - d.sec

        frame:SetScript('OnUpdate', function(self, elapsed)
            self.elapsed = self.elapsed + elapsed
            if self.elapsed > self.interval then
                if self.first then
                    self.interval = 60
                    self.first = false
                end

                if time(date('*t', GetServerTime())) > _G.DoCharacters.init_time then
                    DoWeeklyKeyReset()
                end
                self.elapsed = 0
            end
            end)
    elseif d.wday == 4 and d.hour < (7 + hourOffset + (d.isdst and 1 or 0)) and region == 3 then
        local frame = CreateFrame('FRAME')
        frame.elapsed = 0
        frame.first = true
        frame.interval = 60 - d.sec

        frame:SetScript('OnUpdate', function(self, elapsed)
            self.elapsed = self.elapsed + elapsed
            if self.elapsed > self.interval then
                if self.first then
                    self.interval = 60
                    self.first = false
                end

                if time(date('*t', GetServerTime())) > _G.DoCharacters.init_time then
                    DoWeeklyKeyReset()
                end
                self.elapsed = 0
            end
        end)
    end
    if _G.DoCharacters.init_season and C_MythicPlus.GetCurrentSeason() >= 1 and (C_MythicPlus.GetCurrentSeason() ~= _G.DoCharacters.init_season) then
        DoSeasonReset()
        _G.DoCharacters.init_season = C_MythicPlus.GetCurrentSeason()
    end
end

local function UpdateC_MythicPlusEvent(_, event, covenantID)
    if event == "PLAYER_ENTERING_WORLD" then
        C_MythicPlus.RequestMapInfo()
        C_MythicPlus.RequestRewards()
    end
    if event == "PLAYER_LOGIN" then
        C_MythicPlus.RequestMapInfo()
        C_MythicPlus.RequestRewards()
        C_MythicPlus.RequestCurrentAffixes()
    end
end

local function OnTooltipSetUnit(self)
    local _, unit = self:GetUnit()
    if not unit then return end
    local isPlayer = _G.UnitIsPlayer(unit)
    local unitName, unitRealm = UnitName(unit)
    local nameRealm
    local found = false
    if not isPlayer then return end
    if not unitRealm then
        unitRealm = GetRealmName()
    end
    if not (unitName and unitRealm) then return end
    if unitName and unitRealm then
       nameRealm = unitName .. "-" .. unitRealm
    end
    if type(_G.DoKeysGuild) == "table" then
        for guildnametable,playernametable in pairs(_G.DoKeysGuild) do
            for playername in pairs(playernametable) do
                if playername == nameRealm then
                    found = true
                    _G.GameTooltip:AddLine("DoKeys:" , 1, 1, 0)
                    _G.GameTooltip:AddLine("Current Key: " .. tostring(_G.DoKeysGuild[guildnametable][playername]["mythicplus"]["keystone"].CurrentKeyInstance or "") .. " " .. tostring(_G.DoKeysGuild[guildnametable][playername]["mythicplus"]["keystone"].CurrentKeyLevel or ""), 1, 1, 1)
                    _G.GameTooltip:Show()
                end
            end
        end
    end
    if found then return end
    if type(_G.DoKeysPartyKeys) == "table" then
        for playername,keydata in pairs(_G.DoKeysPartyKeys) do
            if (playername) == nameRealm then
                _G.GameTooltip:AddLine("DoKeys:" , 1, 1, 0)
                _G.GameTooltip:AddLine("Current Key: " .. tostring(keydata.KeyInstanceID and C_ChallengeMode.GetMapUIInfo(keydata.KeyInstanceID) or "") .. " " .. tostring(keydata.KeyLevel or ""), 1, 1, 1)
                _G.GameTooltip:Show()
            end
        end
    end
end

_G.GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

local lastrunpartyrequest
--local lastrunpartyrequesttimer
local function RequestPartyKeys(_, event)
    if event == "GROUP_ROSTER_UPDATE" then
        lastrunpartyrequest = _G.GetTime()
    end
    --if _G.GetTime() - lastrunpartyrequest < 1 then
        --if type(lastrunpartyrequesttimer) == "table" and lastrunpartyrequesttimer._remainingIterations >= 1 then
        --    return
        --elseif type(lastrunpartyrequesttimer) == "table" and lastrunpartyrequesttimer._remainingIterations == 0 then
        --    lastrunpartyrequesttimer = _G.C_Timer.NewTimer(2.5, function() RequestPartyKeys() end)
        --else
        --    lastrunpartyrequesttimer:Cancel()
        --    lastrunpartyrequesttimer = _G.C_Timer.NewTimer(2.5, function() RequestPartyKeys() end)
        --end
        --return
    --end
    --C_ChatInfo.SendAddonMessage("DoKeys", "PartyRequest", "PARTY")
    local nummembers = _G.GetNumGroupMembers()
    if nummembers == 0 then
        if type(DoKeysPartyKeys) == "table" then
            wipe(DoKeysPartyKeys)
        end
    end

    if nummembers > 0 then
        C_ChatInfo.SendAddonMessage("DoKeys", "PartyRequest", "PARTY")
        local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")
        for i=1,_G.GetNumGroupMembers() do
            local sentRequest = openRaidLib and openRaidLib.RequestAllData()
            --local unitID = unit..i
            --local unitInfo = openRaidLib and openRaidLib.GetUnitInfo(unitID and unitId)
            --local unitName, level, mapID, challengeMapID, classID, rating, mythicPlusMapID, classIconTexture, iconTexCoords, mapName, inMyParty, isOnline, isGuildMember = _G.unpack(unitTable)
            local allUnitsInfo = openRaidLib and openRaidLib.GetAllUnitsInfo()
            for unitname, unitInfo in pairs(allUnitsInfo) do
                local specId = unitInfo.specId
                local specName = unitInfo.specName
                local role = unitInfo.role
                local renown = unitInfo.renown
                local covenantId = unitInfo.covenantId
                local talents = unitInfo.talents
                local pvpTalents = unitInfo.pvpTalents
                local conduits = unitInfo.conduits
                local class = unitInfo.class
                local classId = unitInfo.classId
                local className = unitInfo.className
                local unitName = unitInfo.name
                local unitNameFull = unitInfo.nameFull
                local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(unitname, true)
                if type(_G.DoKeysPartyKeys) ~= "table" then
                    _G.DoKeysPartyKeys = {}
                end
                if type(_G.DoKeysPartyKeys[unitNameFull]) ~= "table" then
                    _G.DoKeysPartyKeys[unitNameFull] = {}
                end
                if keystoneInfo.level and tonumber(keystoneInfo.level) > 0 then
                    _G.DoKeysPartyKeys[unitNameFull] = {KeyInstanceID = keystoneInfo.mythicPlusMapID, KeyLevel = keystoneInfo.level, KeyInstance = keystoneInfo.mythicPlusMapID and C_ChallengeMode.GetMapUIInfo(keystoneInfo.mythicPlusMapID)}
                end
           end
            --_G.DoKeysPartyKeys[NameRealm] = {KeyInstanceID = KeyInstanceID, KeyLevel = KeyLevel, weeklyBest = weeklyBest, KeyInstance = C_ChallengeMode.GetMapUIInfo(KeyInstanceID)}
        end
    end
end

local OldKeyMapid
local OldKeyLevel
local OldTWKeyMapid
local OldTWKeyLevel
local function TrackKeyChange(_, event, prevItem, newItem)
    if event == "CHALLENGE_MODE_START" then
        OldKeyMapid = GetOwnedKeystoneChallengeMapID()
        OldKeyLevel = GetOwnedKeystoneLevel()
        --print("OldKeyMapid: ", OldKeyMapid)
        --print("OldKeyLevel: ", OldKeyLevel)
        for Bag = 0, NUM_BAG_SLOTS do
            for Slot = 1, GetContainerNumSlots(Bag) do
                local ID = GetContainerItemID(Bag, Slot)
                if (ID and ID == 187786) then
                    local ItemLink = GetContainerItemLink(Bag, Slot)
                    local _,_,three = strsplit("|",ItemLink)
                    _,OldTWKeyMapid,_,OldTWKeyLevel = strsplit(":",ItemLink)
                    break
                end
            end
        end
    end
    if event == "CHALLENGE_MODE_COMPLETED" then
        --for Bag = 0, NUM_BAG_SLOTS do
        --    for Slot = 1, GetContainerNumSlots(Bag) do
        --        local ID = GetContainerItemID(Bag, Slot)
        --        if (ID and ID == 180653) then
        --            local ItemLink = GetContainerItemLink(Bag, Slot)
        --            local _,_,three = strsplit("|",ItemLink)
        --            local NewKeyMapid
        --            local NewKeyLevel
        --            _,_,NewKeyMapid,NewKeyLevel = strsplit(":",ItemLink)
        --            NewKeyMapid = tonumber(NewKeyMapid)
        --            NewKeyLevel = tonumber(NewKeyLevel)
        --            if tonumber(OldKeyMapid) ~= tonumber(NewKeyMapid) and tonumber(OldKeyLevel) ~= tonumber(NewKeyLevel) then
        --                --print("Should Send New Key!")
        --                SendChatMessage("New-Key: " .. DoKeysCreateLink( {currentkeymapid = NewKeyMapid, CurrentKeyLevel = NewKeyLevel, CurrentKeyInstance = NewKeyMapid and C_ChallengeMode.GetMapUIInfo(NewKeyMapid) or ""} ,"normal"), "PARTY")
        --            end
        --            break
        --        end
        --    end
        --end
        C_Timer.After(10, function()
            --print("OldKeyMapid: ", OldKeyMapid, "GetOwnedKeystoneChallengeMapID: ", GetOwnedKeystoneChallengeMapID())
            --print("OldKeyLevel: ", OldKeyLevel, "GetOwnedKeystoneLevel: ", GetOwnedKeystoneLevel())
            --if OldKeyMapid ~= GetOwnedKeystoneChallengeMapID() then
            --    print("old map id is not new map id")
            --end
            --if OldKeyLevel ~= GetOwnedKeystoneLevel()then
            --    print("old key level is not new key level")
            --end
            if tonumber(OldKeyMapid) ~= tonumber(GetOwnedKeystoneChallengeMapID()) and tonumber(OldKeyLevel) ~= tonumber(GetOwnedKeystoneLevel()) then
                --print("Should Send New Key!")
                --SendChatMessage("New Key: " .. DoKeysCreateLink(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"],"normal"), "PARTY")
                SendChatMessage("New Key: " .. DoKeysCreateLink( {currentkeymapid = GetOwnedKeystoneChallengeMapID(), CurrentKeyLevel = GetOwnedKeystoneLevel(), CurrentKeyInstance = GetOwnedKeystoneChallengeMapID() and C_ChallengeMode.GetMapUIInfo(GetOwnedKeystoneChallengeMapID()) or ""} ,"normal"), "PARTY")
            end

            --for Bag = 0, NUM_BAG_SLOTS do
            --    for Slot = 1, GetContainerNumSlots(Bag) do
            --        local ID = GetContainerItemID(Bag, Slot)
            --        if (ID and ID == 180653) then
            --            local ItemLink = GetContainerItemLink(Bag, Slot)
            --            local _,_,three = strsplit("|",ItemLink)
            --            local NewKeyMapid
            --            local NewKeyLevel
            --            _,_,NewKeyMapid,NewKeyLevel = strsplit(":",ItemLink)
            --            NewKeyMapid = tonumber(NewKeyMapid)
            --            NewKeyLevel = tonumber(NewKeyLevel)
            --            if tonumber(OldKeyMapid) ~= tonumber(NewKeyMapid) and tonumber(OldKeyLevel) ~= tonumber(NewKeyLevel) then
            --                --print("Should Send New Key!")
            --                SendChatMessage("New Key: " .. DoKeysCreateLink( {currentkeymapid = NewKeyMapid, CurrentKeyLevel = NewKeyLevel, CurrentKeyInstance = NewKeyMapid and C_ChallengeMode.GetMapUIInfo(NewKeyMapid) or ""} ,"normal"), "PARTY")
            --            end
            --            break
            --        end
            --    end
            --end

            for Bag = 0, NUM_BAG_SLOTS do
                for Slot = 1, GetContainerNumSlots(Bag) do
                    local ID = GetContainerItemID(Bag, Slot)
                    if (ID and ID == 187786) then
                        local ItemLink = GetContainerItemLink(Bag, Slot)
                        local _,_,three = strsplit("|",ItemLink)
                        local NewTWKeyMapid
                        local NewTWKeyLevel
                        _,NewTWKeyMapid,_,NewTWKeyLevel = strsplit(":",ItemLink)
                        if tonumber(OldTWKeyMapid) ~= tonumber(NewTWKeyMapid) and tonumber(OldTWKeyLevel) ~= tonumber(NewTWKeyLevel) then
                            SendChatMessage("New Key: " .. DoKeysCreateLink(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"],"tw"), "PARTY")
                        end
                        break
                    end
                end
            end
        end)
    end
    --
    --"DevTools_Dump(|cffa335ee|Hitem:180653::::::::60:257::::6:17:166:18:17:19:9:20:11:21:3:22:131:::::|h[Mythic Keystone]|h|r)"
    if event == "ITEM_CHANGED" then
        --local _,olditemid = string.split(":",prevItem)
        local _,newitemid = string.split(":",newItem)
        if newitemid == "180653" then
            SendChatMessage("Re-Rolled Key To: " .. DoKeysCreateLink( {currentkeymapid = GetOwnedKeystoneChallengeMapID(), CurrentKeyLevel = GetOwnedKeystoneLevel(), CurrentKeyInstance = GetOwnedKeystoneChallengeMapID() and C_ChallengeMode.GetMapUIInfo(GetOwnedKeystoneChallengeMapID()) or ""} ,"normal"), "PARTY")
            --print("Re-Rolled Key To: " .. DoKeysCreateLink( {currentkeymapid = GetOwnedKeystoneChallengeMapID(), CurrentKeyLevel = GetOwnedKeystoneLevel(), CurrentKeyInstance = GetOwnedKeystoneChallengeMapID() and C_ChallengeMode.GetMapUIInfo(GetOwnedKeystoneChallengeMapID()) or ""}))
        end
    end
end

local function TrackNumRunsCompleted()
    if _G.DoCharacters then
    else
        _G.DoCharacters = {}
    end
    if _G.DoCharacters[realmgroupid] then
    else
        _G.DoCharacters[realmgroupid] = {}
    end
    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] then
    else
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()] = {}
    end
    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"] then
    else
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"] = {}
    end
    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"] then
    else
        _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"] = {}
    end
    _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].weeklyCount = (_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].weeklyCount or 0) + 1
end

-- Friend's list Hooking
do
    for i = 1, 5 do
		local textString = FriendsTooltip:CreateFontString('FriendsTooltipDoKeysInfo' .. i, 'ARTWORK', 'FriendsFont_Small')
		textString:SetJustifyH('LEFT')
		textString:SetSize(168, 0)
		textString:SetTextColor(0.486, 0.518, 0.541)
	end
	local OnEnter, OnHide
    local lastrunonenter
	function OnEnter(self)
        if type(lastrunonenter) == "number" then
            local diff = _G.GetTime() - lastrunonenter
            if diff < 1 then return end
        end
		if not self.id then return end -- Friend Groups adds fake units with no ide for group heeaders
		if not FriendsTooltip.maxWidth then return end -- Why? Who knows

		local left = FRIENDS_TOOLTIP_MAX_WIDTH - FRIENDS_TOOLTIP_MARGIN_WIDTH - FriendsTooltipDoKeysInfo1:GetWidth()
		local stringShown = false

		for gameIndex = 1, C_BattleNet.GetFriendNumGameAccounts(self.id) do
			if gameIndex > FRIENDS_TOOLTIP_MAX_GAME_ACCOUNTS then break end -- Blizzard only wrote lines for 5 game indices
			local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(self.id, gameIndex)
            local accountInfo = C_BattleNet.GetFriendAccountInfo(self.id)
			local characterNameString = _G['FriendsTooltipGameAccount' .. gameIndex .. 'Name']
			local gameInfoString = _G['FriendsTooltipGameAccount' .. gameIndex .. 'Info']
			local doKeyString = _G['FriendsTooltipDoKeysInfo' .. gameIndex]

			if (gameAccountInfo) and (gameAccountInfo.clientProgram == BNET_CLIENT_WOW) and (gameAccountInfo.wowProjectID == 1) then -- They are playing retail WoW
				if gameAccountInfo.gameAccountID then
					local realmName
					if gameAccountInfo.realmName then
						realmName = gameAccountInfo.realmName
					elseif gameAccountInfo.realmDisplayName then
						realmName = gameAccountInfo.realmDisplayName:gsub('%s+', '')
					elseif gameAccountInfo.richPresence and gameAccountInfo.richPresence:find('-') then
						realmName = gameAccountInfo.richPresence:sub(gameAccountInfo.richPresence:find('-') + 1, -1):gsub('%s+', '') -- Character - Realm Name stripped down to RealmName
					else
						-- I really don't know what is going on with their API....
					end
					if realmName then
						local fullName = gameAccountInfo.characterName .. '-' .. realmName
                        local btag = accountInfo and accountInfo.isBattleTagFriend and accountInfo.battleTag
						if _G.DoKeysBNETFriendsKeys and _G.DoKeysBNETFriendsKeys[btag] and _G.DoKeysBNETFriendsKeys[btag][fullName] then
							local keyLevel, dungeonID = _G.DoKeysBNETFriendsKeys[btag][fullName].KeyLevel or 0, _G.DoKeysBNETFriendsKeys[btag][fullName].KeyInstance or ""
                            if keyLevel and tonumber(keyLevel) > 0 then
							    doKeyString:SetWordWrap(false)
							    doKeyString:SetFormattedText("|cffffd200Current Keystone|r\n%d - %s", keyLevel, dungeonID)
							    doKeyString:SetWordWrap(true)
							    doKeyString:SetPoint('TOP', characterNameString, 'BOTTOM', 3, -4)
							    gameInfoString:SetPoint('TOP', doKeyString, 'BOTTOM', 0, 0)
							    doKeyString:Show()
							    stringShown = true
							    FriendsTooltip.height = FriendsTooltip:GetHeight() + doKeyString:GetStringHeight() + 8
							    FriendsTooltip.maxWidth = max(FriendsTooltip.maxWidth, doKeyString:GetStringWidth() + left)
                            else
                                doKeyString:SetText('')
                                doKeyString:Hide()
                                gameInfoString:SetPoint('TOP', characterNameString, 'BOTTOM', 0, -4)
                            end
						else
							doKeyString:SetText('')
							doKeyString:Hide()
							gameInfoString:SetPoint('TOP', characterNameString, 'BOTTOM', 0, -4)
						end
					end
				end
			else
				doKeyString:SetText('')
				doKeyString:Hide()
			end
		end
		--FriendsTooltip:SetWidth(min(FRIENDS_TOOLTIP_MAX_WIDTH, FriendsTooltip.maxWidth + FRIENDS_TOOLTIP_MARGIN_WIDTH))
		--FriendsTooltip:SetHeight(FriendsTooltip.height + (stringShown and 0 or (FRIENDS_TOOLTIP_MARGIN_WIDTH + 8)))
        lastrunonenter = _G.GetTime()
	end

	function OnHide()

	end

	local buttons = FriendsListFrameScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		local oldOnEnter = button.OnEnter
		function button:OnEnter()
			oldOnEnter(self)
			OnEnter(self)
		end
		button:HookScript("OnEnter", OnEnter)
	end

	FriendsTooltip:HookScript('OnHide', OnHide)
	--FriendsTooltip:HookScript('OnShow', OnEnter)
end


DoKeysTrackGuildKeysFrame:SetScript("OnEvent", TrackGuildKeys)
DoKeysRequestAKKMGuildKeysFrame:SetScript("OnEvent", RequestGuildKeys)
DoKeysResetFrame:SetScript("OnEvent", Reset)
DoKeysKeyStoneWeeklyBestFrame:SetScript("OnEvent", UpdateWeeklyBest)
DoKeysKeyStoneTrackingFrame:SetScript("OnEvent", UpdateKeyStone)
DoKeysDBFrame:SetScript("OnEvent", SetupDB)
DoKeysGearFrame:SetScript("OnEvent", UpdateGear)
UpdateSeasonBestsFrame:SetScript("OnEvent", UpdateSeasonBests)
UpdateCovenantFrame:SetScript("OnEvent", UpdateCovenant)
C_MythicPlusEventFrame:SetScript("OnEvent", UpdateC_MythicPlusEvent)
RequestPartyKeysFrame:SetScript("OnEvent", RequestPartyKeys)
TrackPartyKeysFrame:SetScript("OnEvent", TrackPartyKeys)
TrackBNETKeysFrame:SetScript("OnEvent", TrackBNETFriends)
FindAddonUsersFrame:SetScript("OnEvent", FindAddonUsers)
TrackKeyChangeFrame:SetScript("OnEvent", TrackKeyChange)
TrackNumRunsCompletedFrame:SetScript("OnEvent", TrackNumRunsCompleted)
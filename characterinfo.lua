--luacheck: no max line length
--luacheck: no redefined

local GetRealmName = _G.GetRealmName
local UnitName = _G.UnitName
local GetOwnedKeystoneChallengeMapID = _G.C_MythicPlus.GetOwnedKeystoneChallengeMapID
local GetOwnedKeystoneLevel = _G.C_MythicPlus.GetOwnedKeystoneLevel
local GetAverageItemLevel = _G.GetAverageItemLevel
local CreateFrame = _G.CreateFrame
local C_ChallengeMode = _G.C_ChallengeMode
local C_MythicPlus = _G.C_MythicPlus
local C_PlayerInfo = _G.C_PlayerInfo
--local isGuildMember = _G.IsInGuild()
local UnitLevel = _G.UnitLevel
local UnitClass = _G.UnitClass

local date = _G.date
local time = _G.time
local GetCurrentRegion = _G.GetCurrentRegion
local GetServerTime = _G.GetServerTime
local difftime = _G.difftime
--local wipe = _G.wipe
--local strsplit = _G.strsplit
--local GetGuildInfo = _G.GetGuildInfo

local DoKeysDBFrame = CreateFrame("FRAME") --PLAYER_ENTERING_WORLD: isInitialLogin, isReloadingUi
DoKeysDBFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
DoKeysDBFrame:RegisterEvent("ADDON_LOADED")
DoKeysDBFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
--DoKeysDBFrame:RegisterEvent("PLAYER_LOGIN")

local DoKeysKeyStoneTrackingFrame = CreateFrame("FRAME")
DoKeysKeyStoneTrackingFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
DoKeysKeyStoneTrackingFrame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")
DoKeysKeyStoneTrackingFrame:RegisterEvent("BAG_UPDATE")

local DoKeysKeyStoneWeeklyBestFrame = CreateFrame("FRAME")
DoKeysKeyStoneWeeklyBestFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
DoKeysKeyStoneWeeklyBestFrame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")

local DoKeysResetFrame = CreateFrame("FRAME")
DoKeysResetFrame:RegisterEvent("PLAYER_LOGIN")

local DoKeysGearFrame = CreateFrame("FRAME")
DoKeysGearFrame:RegisterEvent("BAG_UPDATE")

--local DoKeysTrackGuildKeysFrame = CreateFrame("FRAME", "DoKeysTrackGuildKeysFrame")
--DoKeysTrackGuildKeysFrame:RegisterEvent("CHAT_MSG_ADDON")

--_G.DoCharacters = {}

local realmName = GetRealmName()
--local GuildName
--if isGuildMember then
--    GuildName = GetGuildInfo("player")
--end
--local playerName = UnitName("player")

--local function checktable(table)
--    --print(type(table))
--    if type(table == "table") then
--        return true
--    else
--        error()
--        return false
--    end
--end

local function SetupDB(_, event, one, _)
    --ADDON_LOADED
    --SAVED_VARIABLES_TOO_LARGE
    --SPELLS_CHANGED
    --PLAYER_LOGIN
    --PLAYER_ENTERING_WORLD
    if event == "ADDON_LOADED" and one == "DoKeys" then
        if _G.DoCharacters then -- luacheck: ignore
        else
            _G.DoCharacters = {}
        end
        if _G.DoCharacters[realmName] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName][UnitName("player")] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] = {}
        end
        --if isGuildMember then
        --    if _G.DoCharacters[realmName][GuildName] then
        --    else
        --        _G.DoCharacters[realmName][GuildName] = {}
        --    end
        --end
    end
    --local DoCharacters = _G.DoCharacters
    if event == "PLAYER_ENTERING_WORLD" then
        if _G.DoCharacters then -- luacheck: ignore
        else
            _G.DoCharacters = {}
        end
        if _G.DoCharacters[realmName] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName][UnitName("player")] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] then -- luacheck: ignore
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] = {}
        end
        --if isGuildMember then
        --    if _G.DoCharacters[realmName][GuildName] then
        --    else
        --        _G.DoCharacters[realmName][GuildName] = {}
        --    end
        --end

        local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel() --avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp
        _G.DoCharacters[realmName][UnitName("player")].avgItemLevel = avgItemLevel or 0
        _G.DoCharacters[realmName][UnitName("player")].avgItemLevelEquipped = avgItemLevelEquipped or 0
        _G.DoCharacters[realmName][UnitName("player")].avgItemLevelPvp = avgItemLevelPvp or 0
        _G.DoCharacters[realmName][UnitName("player")].name = UnitName("player")
        _G.DoCharacters[realmName][UnitName("player")].level = UnitLevel("player")
        _G.DoCharacters[realmName][UnitName("player")].class = select(2,UnitClass("player"))
        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].CurrentKeyLevel = GetOwnedKeystoneLevel() or 0
        local currentkeymapid = GetOwnedKeystoneChallengeMapID()
        local name = ""
        if type(currentkeymapid) == "number" then
            name = C_ChallengeMode.GetMapUIInfo(currentkeymapid)
        end
        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].CurrentKeyInstance = name or ""
        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyChestRewardLevel = C_MythicPlus.GetWeeklyChestRewardLevel() or 0
        local data = C_PlayerInfo.GetPlayerMythicPlusRatingSummary("player")
        local seasonScore = data and data.currentSeasonScore
        if seasonScore and seasonScore > 0 then
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].currentSeasonScore = seasonScore
        end
    end
    if event == "LOADING_SCREEN_DISABLED" then
        local maps = C_ChallengeMode.GetMapTable()
        local best = _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest or 0
        for i = 1, #maps do
            local _, weeklyLevel, _, _, _ = C_MythicPlus.GetWeeklyBestForMap(maps[i])
            --print(durationSec, weeklyLevel, completionDate, affixIDs, members)
            if (not weeklyLevel) then
                weeklyLevel = 0
            end
            if weeklyLevel and weeklyLevel > best then
                best = weeklyLevel
            end
        end
        --Resets Before KeyExpire
        --local runs = C_MythicPlus.GetRunHistory()
        --local weeklyLevel = 0
        --print(type(runs))
        --for k,v in pairs(runs) do
        --    print(k,v)
        --    for key,value in pairs(v) do
        --        print(key,value)
        --        if key == "level" then
        --            --print(value)
        --            if value > weeklyLevel then
        --                weeklyLevel = value
        --            end
        --        end
        --    end
        --end
        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest = best
    end
end

local function UpdateKeyStone(_, _)

    local currentkeymapid = GetOwnedKeystoneChallengeMapID()
    local name = ""
    if type(currentkeymapid) == "number" then
        name = C_ChallengeMode.GetMapUIInfo(currentkeymapid)
    end
    _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].CurrentKeyInstance = name or ""
    _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].CurrentKeyLevel = GetOwnedKeystoneLevel() or 0

    --CHALLENGE_MODE_COMPLETED
    --mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()
    --C_MythicPlus.IsWeeklyRewardAvailable()
    --MYTHIC_PLUS_NEW_WEEKLY_RECORD = mapChallengeModeID,completionMilliseconds, level
end

local function UpdateGear()
    local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel() --avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp
    _G.DoCharacters[realmName][UnitName("player")].avgItemLevel = avgItemLevel or 0
    _G.DoCharacters[realmName][UnitName("player")].avgItemLevelEquipped = avgItemLevelEquipped or 0
    _G.DoCharacters[realmName][UnitName("player")].avgItemLevelPvp = avgItemLevelPvp or 0
end

local function UpdateWeeklyBest(_, event, one, _, three)

    local timed

    --if event == "CHALLENGE_MODE_COMPLETED" then
    --    local mapChallengeModeID, level, _, _, keystoneUpgradeLevels, _ = C_ChallengeMode.GetCompletionInfo()
    --    local name = ""
    --    if type(mapChallengeModeID) == "number" then
    --        name = C_ChallengeMode.GetMapUIInfo(mapChallengeModeID)
    --    end
    --    local weeklybest = _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest or 0
    --    if weeklybest <= level then
    --        if keystoneUpgradeLevels == 3 then
    --            timed = "+++"
    --        elseif keystoneUpgradeLevels == 2 then
    --            timed = "++"
    --        elseif keystoneUpgradeLevels == 1 then
    --            timed = "+"
    --        elseif keystoneUpgradeLevels == 0 then -- or onTime = false
    --            timed = "Not In Time"
    --        end
    --        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBestInstanceName = name
    --        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBestLevel = level
    --        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBestLevelTimed = timed
    --        local maps = C_ChallengeMode.GetMapTable()
    --        local best = _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest or 0
    --        for i = 1, #maps do
    --            local durationSec, weeklyLevel, completionDate, affixIDs, members = C_MythicPlus.GetWeeklyBestForMap(maps[i])
    --            --print(durationSec, weeklyLevel, completionDate, affixIDs, members)
    --            if (not weeklyLevel) then
    --                weeklyLevel = 0
    --            end
    --            if weeklyLevel and weeklyLevel > best then
    --                best = weeklyLevel
    --            end
    --        end
    --        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest = best
    --    end
    --end

    if event == "MYTHIC_PLUS_NEW_WEEKLY_RECORD" then
        local name = C_ChallengeMode.GetMapUIInfo(one)
        local _, _, _, _, keystoneUpgradeLevels, _ = C_ChallengeMode.GetCompletionInfo()
        local weeklybest = _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest or 0
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
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBestInstanceName = name
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBestLevel = three
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBestLevelTimed = timed
        end
        local best = _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest or 0
        if best < three then
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest = three
        end
    end

    --CHALLENGE_MODE_COMPLETED
    --mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()
    --C_MythicPlus.IsWeeklyRewardAvailable()
    --MYTHIC_PLUS_NEW_WEEKLY_RECORD = mapChallengeModeID,completionMilliseconds, level
    --JAILERS_TOWER_LEVEL_UPDATE
end

--local function CompressAndEncode(input)
--	local compressed = LibDeflate:CompressDeflate(self:Serialize(input));
--	return LibDeflate:EncodeForWoWAddonChannel(compressed);
--end
--
--local function DecompressAndDecode(input)
--	local decoded = LibDeflate:DecodeForWoWAddonChannel(input);
--	local success, deserialized = self:Deserialize(LibDeflate:DecompressDeflate(decoded));
--	if not success then
--		KeystoneManager:Print('There was issue with receiving guild keys, please report this to Addon Author.')
--	end
--	return deserialized;
--end

--if type(_G.ThisShouldNeverExistsWhatareYouDoing) == "table" then
--    print("This works")
--end

--local function TrackGuildKeys(_, _, prefix, text, _, _, _, _, _, _, _)
--    --self, event, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID
--    --local name, rank, rankIndex, level, class, zone, note,  officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, isSoREligible, standingID = GetGuildRosterInfo(index)
--    --CHAT_MSG_ADDON: prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID
--    -- sync5: text: Character Name-Realm,Class,KeyMapID,KeyLevel,WeekltBest,Week
--    -- request: text: request channel:  GUILD sender:  CurrentPlayer-Realm target:  CurrentPlayer-Realm
--
--    --_G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest
--    --if isGuildMember then
--        --RegisterAstralKeys = C_ChatInfo.RegisterAddonMessagePrefix("AstralKeys")
--        --RegisterKeystoneManager = C_ChatInfo.RegisterAddonMessagePrefix("KeystoneManager")
--        --if not RegisterAstralKeys and not RegisterKeystoneManager then
--        --    print("Error Registering Addon Prefixes")
--        --    return
--        --end
--        --for i = 1, GetNumGuildMembers() do
--        --    local name, _, _, level, _, _, _,  _, online, _, _, _, _, isMobile = GetGuildRosterInfo(i)
--        --end
--    --end
--    if prefix == "AstralKeys" then
--        --print("prefix: ", prefix, "text: ", text, "channel: ", channel, "sender: ", sender, "target: ", target, "zoneChannelID: ", zoneChannelID, "localID: ", localID, "name: ", name, "instanceID: ", instanceID)
--        --for word in string.gmatch(text, '([^:]+)') do
--        --    print(word)
--        --end
--
--        if text == "request" or text == "updateV8" or strsplit(" ", text) == "updateWeekly" then
--            return
--        end
--
--        if text then
--            local _, NewText2 = strsplit(" ",text) -- NewText = type Newtext2 = 5 Player Units
--            if NewText2 then
--                local one = strsplit("_",NewText2)
--                if one then
--                    local NameRealm,Class,KeyMapID,KeyLevel,WeeklyBest,Week = strsplit(":",NewText2)
--                    --setupdb
--                    --if #_G.DoCharacters[realmName] <= 0 then
--                    --    _G.DoCharacters[realmName][GuildName] = {}
--                    --end
--                    for GuildNameList in pairs(_G.DoCharacters[realmName]) do
--                        if GuildNameList == GuildName then
--                            --print("match for guild moving on")
--                            if #_G.DoCharacters[realmName][GuildName] <= 0 then
--                                --print("guild table empty setting up...")
--                                _G.DoCharacters[realmName][GuildName][NameRealm] = {}
--                                _G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"] = {}
--                                _G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
--                            else
--                                for k,_ in pairs(_G.DoCharacters[realmName][GuildName]) do
--                                    if not k or not k == NameRealm then
--                                        --print("no match in guild table for character setting up...")
--                                        _G.DoCharacters[realmName][GuildName][NameRealm] = {}
--                                        _G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"] = {}
--                                        _G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
--                                    end
--                                end
--                            end
--                        else
--                            --_G.DoCharacters[realmName][GuildName] = {}
--                            --_G.DoCharacters[realmName][GuildName][NameRealm] = {}
--                            --_G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"] = {}
--                            --_G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"]["keystone"] = {}
--                        end
--                    end
--                    -- Add Data
--                    --local guildkeyname = C_ChallengeMode.GetMapUIInfo(KeyMapID)
--                    --_G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyLevel = KeyLevel
--                    --_G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
--                    --_G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = WeeklyBest
--                    --_G.DoCharacters[realmName][GuildName][NameRealm]["mythicplus"]["keystone"].Week = Week
--                    --_G.DoCharacters[realmName][GuildName][NameRealm].Class = Class
--                    --print("characterName: ", NameRealm)
--                    --print("Class: ", Class)
--                    --print("KeyMapID: ", KeyMapID)
--                    --print("KeyLevel: ", KeyLevel)
--                    --print("WeekltBest: ", WeekltBest)
--                    --print("Week: ", Week)
--                end
--            end
--        end
--
--    end
--    --GUILD_ROSTER_UPDATE
--    --GUILD_MOTD
--    --CHAT_MSG_GUILD
--    --CHAT_MSG_ADDON
--end

local initializeTime = {}
initializeTime[1] = 1500390000 -- US Tuesday at reset
initializeTime[2] = 1500447600 -- EU Wednesday at reset
initializeTime[3] = 1500505200 -- CN Thursday at reset
initializeTime[4] = 0

local function DoWeeklyKeyReset()
    if not type(_G.DoCharacters == "table") then
        return
    end
    if not type(_G.DoCharacters[realmName] == "table") then
        return
    end
    --Wipe Characters
    for _, v in pairs(_G.DoCharacters[realmName]) do -- luacheck: ignore 423
        if type(v == "table") then
           for k, v in pairs(v) do
              if k == "mythicplus" then
                 for k, v in pairs(v) do
                    if k == "keystone" then
                        v.WeeklyBest =  0
                        v.CurrentKeyLevel = 0
                        v.CurrentKeyInstance = ""
                        --v.CurrentKeyLevel = _G.C_MythicPlus.GetOwnedKeystoneLevel() or 0
                        --local currentkeymapid = GetOwnedKeystoneChallengeMapID()
                        --local name
                        --if currentkeymapid then
                        --    name = C_ChallengeMode.GetMapUIInfo(currentkeymapid)
                        --end
                        --v.CurrentKeyInstance = name or ""
                    end
                 end
              end
           end
        end
    end
    --Wipe Current Guild Doesn't Account for Characters with different guild then current characters
    --if isGuildMember then
    --    if _G.DoCharacters[realmName][GuildName] and type(_G.DoCharacters[realmName][GuildName]) == "table" then
    --        wipe(_G.DoCharacters[realmName][GuildName])
    --    end
    --end
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

    local time = (((days * 24 + hours) * 60 + minOffset) * 60) + serverTime - d.hour*3600 - d.min*60 - d.sec

    -- TODO
    -- ADD DST Check for time before returning!!!
    return time
 end

local function Reset()
    if not _G.DoCharacters.init_time then
        _G.DoCharacters.init_time = DataResetTime()
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
end

--DoKeysTrackGuildKeysFrame:SetScript("OnEvent", TrackGuildKeys)
DoKeysResetFrame:SetScript("OnEvent", Reset)
DoKeysKeyStoneWeeklyBestFrame:SetScript("OnEvent", UpdateWeeklyBest)
DoKeysKeyStoneTrackingFrame:SetScript("OnEvent", UpdateKeyStone)
DoKeysDBFrame:SetScript("OnEvent", SetupDB)
DoKeysGearFrame:SetScript("OnEvent", UpdateGear)
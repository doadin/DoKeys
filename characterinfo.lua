--luacheck: no max line length
--luacheck: no redefined

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
local isGuildMember = _G.IsInGuild()
local UnitClass = _G.UnitClass
local UnitLevel = _G.UnitLevel

local date = _G.date
local time = _G.time
local GetCurrentRegion = _G.GetCurrentRegion
local GetServerTime = _G.GetServerTime
local difftime = _G.difftime
local wipe = _G.wipe
local strsplit = _G.strsplit
local GetGuildInfo = _G.GetGuildInfo

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

local DoKeysTrackGuildKeysFrame = CreateFrame("FRAME", "DoKeysTrackGuildKeysFrame")
DoKeysTrackGuildKeysFrame:RegisterEvent("CHAT_MSG_ADDON")

local DoKeysRequestAKKMGuildKeysFrame = CreateFrame("FRAME")
DoKeysRequestAKKMGuildKeysFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
DoKeysRequestAKKMGuildKeysFrame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")
DoKeysRequestAKKMGuildKeysFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")

local realmName = GetRealmName()
local GuildName
if isGuildMember then
    GuildName = GetGuildInfo("player")
end
local playerName = UnitName("player")
local isAstralKeysRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("AstralKeys")
local isKeystoneManagerRegistered = C_ChatInfo.IsAddonMessagePrefixRegistered("KeystoneManager")

local function checktable(table)
    --print(type(table))
    if type(table == "table") then
        return true
    else
        error()
        return false
    end
 end

local function SetupDB(_, event, one, _)
    --ADDON_LOADED
    --SAVED_VARIABLES_TOO_LARGE
    --SPELLS_CHANGED
    --PLAYER_LOGIN
    --PLAYER_ENTERING_WORLD
    C_MythicPlus.RequestRewards()
    if event == "ADDON_LOADED" and one == "DoKeys" then
        if _G.DoCharacters then
        else
            _G.DoCharacters = {}
        end
        if _G.DoCharacters[realmName] then
        else
            _G.DoCharacters[realmName] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")] then
        else
            _G.DoCharacters[realmName][UnitName("player")] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] then
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] then
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] = {}
        end
        if isGuildMember then
            if _G.DoKeysGuild then
            else
                _G.DoKeysGuild = {}
            end
            if _G.DoKeysGuild[GuildName] then
            else
                _G.DoKeysGuild[GuildName] = {}
            end
        end
    end
    if event == "PLAYER_ENTERING_WORLD" then
        if _G.DoCharacters then
        else
            _G.DoCharacters = {}
        end
        if _G.DoCharacters[realmName] then
        else
            _G.DoCharacters[realmName] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")] then
        else
            _G.DoCharacters[realmName][UnitName("player")] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] then
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"] = {}
        end
        if _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] then
        else
            _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"] = {}
        end
        if isGuildMember then
            if _G.DoKeysGuild then
            else
                _G.DoKeysGuild = {}
            end
            if _G.DoKeysGuild[GuildName] then
            else
                _G.DoKeysGuild[GuildName] = {}
            end
        end

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
            local durationSec, weeklyLevel, completionDate, affixIDs, members = C_MythicPlus.GetWeeklyBestForMap(maps[i])
            if (not weeklyLevel) then
                weeklyLevel = 0
            end
            if weeklyLevel and weeklyLevel > best then
                best = weeklyLevel
            end
        end
        _G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"].WeeklyBest = best
    end
    if isAstralKeysRegistered then
    else
        C_ChatInfo.RegisterAddonMessagePrefix("AstralKeys")
    end
    if isKeystoneManagerRegistered then
    else
        C_ChatInfo.RegisterAddonMessagePrefix("KeystoneManager")
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
end

local function UpdateGear()
    local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel() --avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp
    _G.DoCharacters[realmName][UnitName("player")].avgItemLevel = avgItemLevel or 0
    _G.DoCharacters[realmName][UnitName("player")].avgItemLevelEquipped = avgItemLevelEquipped or 0
    _G.DoCharacters[realmName][UnitName("player")].avgItemLevelPvp = avgItemLevelPvp or 0
end

local function UpdateWeeklyBest(_, event, one, _, three)
    local timed
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
        if isAstralKeysRegistered then
            C_ChatInfo.SendAddonMessage('AstralKeys', 'updateWeekly ' .. three, 'GUILD')
        end
    end
end

local function CompressAndEncode(input)
    local compressed = LibDeflate:CompressDeflate(self:Serialize(input));
    return LibDeflate:EncodeForWoWAddonChannel(compressed);
end

local function DecompressAndDecode(input)
    --local decoded = LibDeflate:DecodeForWoWAddonChannel(input);
    --local success, deserialized = self:Deserialize(LibDeflate:DecompressDeflate(decoded));
    --if not success then
    --	KeystoneManager:Print('There was issue with receiving guild keys, please report this to Addon Author.')
    --end
    --return deserialized;
    local LibDeflate = LibStub:GetLibrary("LibDeflate")
    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0")
    local decoded = LibDeflate:DecodeForWoWAddonChannel(input);
    local success, deserialized = AceSerializer:Deserialize(LibDeflate:DecompressDeflate(decoded));
    if not success then
        print('There was issue with receiving guild keys, please report this to Addon Author.')
    end
    return deserialized;
    --local LibDeflate = LibStub:GetLibrary("LibDeflate")
    --local decoded = LibDeflate:DecodeForWoWAddonChannel(input)
    --return decoded
end

local function RequestGuildKeys(_, event)
    --local now = GetTime();
    --if now - lastRequested < 5 then
    --	KeystoneManager:Print('Can only request guild keys once per 5 seconds');
    --	return;
    --end
    --lastRequested = now;
    --self:SendCommMessage(self.MessagePrefix, 'request', 'GUILD');
    --self:SendCommand('request');
    if event == "LOADING_SCREEN_DISABLED" or event == "MYTHIC_PLUS_NEW_WEEKLY_RECORD" or event == "CHALLENGE_MODE_COMPLETED" then
        if isAstralKeysRegistered then
            C_ChatInfo.SendAddonMessage('AstralKeys', 'request', 'GUILD')
        end
        if isKeystoneManagerRegistered then
            C_ChatInfo.SendAddonMessage('KeystoneManager', 'request', 'GUILD')
        end
    end
end

local function TrackGuildKeys(_, _, prefix, text, channel, sender, _, _, _, _, _)
    --self, event, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID
    --local name, rank, rankIndex, level, class, zone, note,  officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, isSoREligible, standingID = GetGuildRosterInfo(index)
    -- CHAT_MSG_ADDON: prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID
    -- sync5: prefix:"AstralKeys" text: Character Name-Realm,Class,KeyMapID,KeyLevel,WeekltBest,Week
    -- request: prefix:"AstralKeys" text: request channel:  GUILD sender:  CurrentPlayer-Realm target:  CurrentPlayer-Realm
    -- updateWeekly: prefix:"AstralKeys" text: "updateWeekly" + " " + new weekly best channel: channel sender: sender-realm
    --    C_ChatInfo.SendAddonMessage('AstralKeys', 'request', 'GUILD')
    --    C_ChatInfo.SendAddonMessage('KeystoneManager', 'request', 'GUILD')
    if not isGuildMember then
        return
    end
    local method = text:match('%w+');
    if prefix == "AstralKeys" then
        if text == "request" or strsplit(" ", text) == "updateV8" then
            return
        end
        if method == "sync5" then --Handle received syncs
            local _, NewText2 = strsplit(" ",text) -- NewText = type Newtext2 = 6 Player Units
            if NewText2 then
                local AstralCharacterTable = {strsplit("_",NewText2)}
                for i,data in pairs(AstralCharacterTable) do
                    if data then
                        local NameRealm,Class,KeyMapID,KeyLevel,WeeklyBest,Week = strsplit(":",data)
                        if not NameRealm or not Class or not KeyMapID or not KeyLevel or not WeeklyBest or not Week then
                            return
                        end
                        for GuildNameList in pairs(_G.DoKeysGuild) do
                            if GuildNameList == GuildName then
                                if _G.DoKeysGuild then
                                else
                                    _G.DoKeysGuild = {}
                                end
                                if _G.DoKeysGuild[GuildName] then
                                else
                                    _G.DoKeysGuild[GuildName] = {}
                                end
                                if _G.DoKeysGuild[GuildName][NameRealm] then
                                else
                                    _G.DoKeysGuild[GuildName][NameRealm] = {}
                                end
                                if _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"] then
                                else
                                    _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"] = {}
                                end
                                if _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"] then
                                else
                                    _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"] = {}
                                end
                            end
                        end
                        -- Add Data
                        local guildkeyname = C_ChallengeMode.GetMapUIInfo(KeyMapID)
                        _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyLevel = KeyLevel
                        _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
                        _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = WeeklyBest
                        _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].Week = Week
                        _G.DoKeysGuild[GuildName][NameRealm].Class = Class
                        _G.DoKeysGuild[GuildName][NameRealm].name = NameRealm
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
            for GuildNameList in pairs(_G.DoKeysGuild) do
                if GuildNameList == GuildName then
                    if _G.DoKeysGuild then
                    else
                        _G.DoKeysGuild = {}
                    end
                    if _G.DoKeysGuild[GuildName] then
                    else
                        _G.DoKeysGuild[GuildName] = {}
                    end
                    if _G.DoKeysGuild[GuildName][NameRealm] then
                    else
                        _G.DoKeysGuild[GuildName][NameRealm] = {}
                    end
                    if _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"] then
                    else
                        _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"] = {}
                    end
                    if _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"] then
                    else
                        _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"] = {}
                    end
                end
            end
            -- Add Data
            _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].WeeklyBest = WeeklyBest
            _G.DoKeysGuild[GuildName][NameRealm].name = NameRealm
        end
    end
    if prefix == "KeystoneManager" then
        local request = DecompressAndDecode(text) --table
        if type(request) ~= 'table' then return end
        if request.command == 'updateKeys' then
            if type(request.data) ~= 'table' then return end
            for name, keyInfo in pairs(request.data) do
                --local keyInfo = {
                --    name       = playerName,
                --    shortName  = KeystoneManager:NameWithoutRealm(playerName),
                --    class      = 'MAGE',
                --    weeklyBest = 0,
                --    mapId      = mapId,
                --    timestamp  = timestamp,
                --    week       = week,
                --    mapName    = KeystoneManager.mapNames[mapId],
                --    level      = level,
                --    guild      = self.CurrentGuild
                --}
                for GuildNameList in pairs(_G.DoKeysGuild) do
                    if GuildNameList == GuildName then
                        if _G.DoKeysGuild then
                        else
                            _G.DoKeysGuild = {}
                        end
                        if _G.DoKeysGuild[GuildName] then
                        else
                            _G.DoKeysGuild[GuildName] = {}
                        end
                        if _G.DoKeysGuild[GuildName][keyInfo.name] then
                        else
                            _G.DoKeysGuild[GuildName][keyInfo.name] = {}
                        end
                        if _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"] then
                        else
                            _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"] = {}
                        end
                        if _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"]["keystone"] then
                        else
                            _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"]["keystone"] = {}
                        end
                    end
                end
                -- Add Data
                local guildkeyname = C_ChallengeMode.GetMapUIInfo(keyInfo.mapId)
                _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"]["keystone"].CurrentKeyLevel = keyInfo.level
                _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"]["keystone"].CurrentKeyInstance = guildkeyname
                _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"]["keystone"].WeeklyBest = keyInfo.weeklyBest
                _G.DoKeysGuild[GuildName][keyInfo.name]["mythicplus"]["keystone"].Week = keyInfo.week
                _G.DoKeysGuild[GuildName][keyInfo.name].Class = keyInfo.class
                _G.DoKeysGuild[GuildName][keyInfo.name].name = keyInfo.name
            end
        end
    end
    --GUILD_ROSTER_UPDATE
    --GUILD_MOTD
    --CHAT_MSG_GUILD
    --CHAT_MSG_ADDON
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
                    end
                 end
              end
           end
        end
    end
    wipe(_G.DoKeysGuild)
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

DoKeysTrackGuildKeysFrame:SetScript("OnEvent", TrackGuildKeys)
DoKeysRequestAKKMGuildKeysFrame:SetScript("OnEvent", RequestGuildKeys)
DoKeysResetFrame:SetScript("OnEvent", Reset)
DoKeysKeyStoneWeeklyBestFrame:SetScript("OnEvent", UpdateWeeklyBest)
DoKeysKeyStoneTrackingFrame:SetScript("OnEvent", UpdateKeyStone)
DoKeysDBFrame:SetScript("OnEvent", SetupDB)
DoKeysGearFrame:SetScript("OnEvent", UpdateGear)
--luacheck: no max line length
--luacheck: no redefined

local DoKeys = _G.DoKeys

local BNSendWhisper = _G.BNSendWhisper
local SendChatMessage = _G.SendChatMessage
local CreateFrame = _G.CreateFrame
local realm = _G.GetRealmName()
local UnitName = _G.UnitName

local frame = CreateFrame("FRAME", "DoKeys")
frame:RegisterEvent("CHAT_MSG_GUILD")
frame:RegisterEvent("CHAT_MSG_OFFICER")
frame:RegisterEvent("CHAT_MSG_PARTY")
frame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:RegisterEvent("CHAT_MSG_BN_WHISPER")

local mas = {"!allkeys"}
local mastwo = {"!allhelp"}
local masfour = {"!dookies"}
local masfive = {"!keys"}


local firsttwokeys = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "keys")
local firsttwohelp = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "help")
table.insert(mas,firsttwokeys)
table.insert(mastwo,firsttwohelp)

local mastw = {"!alltwkeys"}

local firsttwotwkeys = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "twkeys")
table.insert(mastw,firsttwotwkeys)

local lastrunguildkeys
local lastrunofficerkeys
local lastrunpartykeys
local lastrunwhisperkeys
local lastrunbnwhisperkeys

local lastrunguildhelp
local lastrunofficerhelp
local lastrunpartyhelp
local lastrunwhisperhelp
local lastrunbnwhisperhelp

local lastrunguilddookies
local lastrunpartydookies

local DoKeysCurrentMaxLevel = _G.GetMaxLevelForExpansionLevel(_G.GetMaximumExpansionLevel())

--local mapidname = {
--	["De Other Side"] = 1679,
--	["Halls of Atonement"] = 1663,
--	["Mists of Tirna Scithe"] = 1669,
--	["Plaguefall"] = 1674,
--	["Sanguine Depths"] = 1675,
--	["Spires Of Ascension"] = 1693,
--	["The Necrotic Wake"] = 1666,
--	["Theater of Pain"] = 1683,
--}

local function CreateLink(data,keytype)
    --name, description, filedataid = C_ChallengeMode.GetAffixInfo(affixID)
    --C_MythicPlus.GetCurrentAffixes()
    --[1]={
    --  id=9,
    --  seasonID=0
    --},
    --[2]={
    --  id=7,
    --  seasonID=0
    --},
    --[3]={
    --  id=13,
    --  seasonID=0
    --},
    --[4]={
    --  id=128,
    --  seasonID=6
    --}
	-- '|cffa335ee|Hkeystone:180653:244:2:10:0:0:0|h[Keystone: Atal'dazar (2)]|h|r'
    local AffixTable = C_MythicPlus.GetCurrentAffixes()
    local link
    if keytype == "normal" or "both" then
	    if type(data) == "table" then
            if data.currentkeymapid and data.CurrentKeyLevel and data.CurrentKeyInstance and data.CurrentKeyLevel and type(AffixTable) == "table" then
                if data.CurrentKeyLevel <= 3 then
	                link = string.format(
	                	'|cffa335ee|Hkeystone:180653:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.currentkeymapid or 0, --data.mapId
	                	data.CurrentKeyLevel, --data.level
                        AffixTable[1].id or 0,
	                	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	                	data.CurrentKeyLevel --data.level
	                )
                end
                if data.CurrentKeyLevel >= 4 and data.CurrentKeyLevel <= 6 then
	                link = string.format(
	                	'|cffa335ee|Hkeystone:180653:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.currentkeymapid or 0, --data.mapId
	                	data.CurrentKeyLevel, --data.level
                        AffixTable[1].id or 0,
                        AffixTable[2].id or 0,
	                	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	                	data.CurrentKeyLevel --data.level
	                )
                end
                if data.CurrentKeyLevel >= 7 and data.CurrentKeyLevel <= 10 then
	                link = string.format(
	                	'|cffa335ee|Hkeystone:180653:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.currentkeymapid or 0, --data.mapId
	                	data.CurrentKeyLevel, --data.level
                        AffixTable[1].id or 0,
                        AffixTable[2].id or 0,
                        AffixTable[3].id or 0,
	                	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	                	data.CurrentKeyLevel --data.level
	                )
                end
                if data.CurrentKeyLevel >= 10 then
	                link = string.format(
	                	'|cffa335ee|Hkeystone:180653:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.currentkeymapid or 0, --data.mapId
	                	data.CurrentKeyLevel, --data.level
                        AffixTable[1].id or 0,
                        AffixTable[2].id or 0,
                        AffixTable[3].id or 0,
                        AffixTable[4].id or 0,
	                	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	                	data.CurrentKeyLevel --data.level
	                )
                end
            end
	    else
	    	link = "None"
	    end
    end
    local twlink
    if keytype == "tw" or "both" then
	    if type(data) == "table" then
            if not data.CurrentTWKeyLevel then return end
            if tonumber(data.CurrentTWKeyLevel) <= 3 then
	            twlink = string.format(
	            	'|cffa335ee|Hkeystone:187786:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	            	data.CurrentTWKeyID or 0, --data.mapId
	            	data.CurrentTWKeyLevel, --data.level
                    _G.DoCharacters.CurrentTWKeyAffix1 or 0,
	            	data.CurrentTWKeyInstanceName, --data.mapNamePlain or data.mapName
	            	data.CurrentTWKeyLevel --data.level
	            )
            end
            if tonumber(data.CurrentTWKeyLevel)>= 4 and data.CurrentKeyLevel <= 6 then
	            twlink = string.format(
	            	'|cffa335ee|Hkeystone:187786:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	            	data.CurrentTWKeyID or 0, --data.mapId
	            	data.CurrentTWKeyLevel, --data.level
                    _G.DoCharacters.CurrentTWKeyAffix1 or 0,
                    _G.DoCharacters.CurrentTWKeyAffix2 or 0,
	            	data.CurrentTWKeyInstanceName, --data.mapNamePlain or data.mapName
	            	data.CurrentTWKeyLevel --data.level
	            )
            end
            if tonumber(data.CurrentTWKeyLevel) >= 7 and data.CurrentKeyLevel <= 10 then
	            twlink = string.format(
	            	'|cffa335ee|Hkeystone:187786:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	            	data.CurrentTWKeyID or 0, --data.mapId
	            	data.CurrentTWKeyLevel, --data.level
                    _G.DoCharacters.CurrentTWKeyAffix1 or 0,
                    _G.DoCharacters.CurrentTWKeyAffix2 or 0,
                    _G.DoCharacters.CurrentTWKeyAffix3 or 0,
	            	data.CurrentTWKeyInstanceName, --data.mapNamePlain or data.mapName
	            	data.CurrentTWKeyLevel --data.level
	            )
            end
            if tonumber(data.CurrentTWKeyLevel) >= 10 then
	            twlink = string.format(
	            	'|cffa335ee|Hkeystone:187786:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	            	data.CurrentTWKeyID or 0, --data.mapId
	            	data.CurrentTWKeyLevel, --data.level
                    _G.DoCharacters.CurrentTWKeyAffix1 or 0,
                    _G.DoCharacters.CurrentTWKeyAffix2 or 0,
                    _G.DoCharacters.CurrentTWKeyAffix3 or 0,
                    _G.DoCharacters.CurrentTWKeyAffix4 or 0,
	            	data.CurrentTWKeyInstanceName, --data.mapNamePlain or data.mapName
	            	data.CurrentTWKeyLevel --data.level
	            )
            end
	    else
	    	twlink = "None"
	    end
    end
    if keytype == "normal" then
        return link
    end
    if keytype == "tw" then
        return link
    end
    if keytype == "both" then
	    return link .. " & " ..  twlink
    end
end

local function FindCovenant(data)
    local character
    local GetRealmName = _G.GetRealmName
    local realmName = GetRealmName()
    if type(data) =="table" then
        character = data
    else
        character = _G.DoCharacters[realmName][UnitName("player")]
    end
    local covenant
    if data.covenant and type(data.covenant) == "string" then
        covenant = character.covenant
    else
        covenant = ""
    end
    return covenant
end

local function MessageHandler(_, event, msg, sender, _, _, _, _, _, _, _, _, _, _, bnSenderID, _, _, _, _)
    local now = _G.GetTime()
    local GetRealmName = _G.GetRealmName
    local realmName = GetRealmName()
    --text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
    --text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
    --print(msg)
    if not msg then return end
    if type(msg) == "string" then
        msg = string.lower(msg)
    end
    if msg ~= nil then -- if message ~= nil then
        for i=1,#mas do
            if string.match(msg,mas[i]) then
                if event == "CHAT_MSG_GUILD" then
                    if type(lastrunguildkeys) == "number" then
                        local diff = now - lastrunguildkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v), "GUILD")
                        end
                    end
                    lastrunguildkeys = _G.GetTime()
                elseif event == "CHAT_MSG_OFFICER" then
                    if type(lastrunofficerkeys) == "number" then
                        local diff = now - lastrunofficerkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v), "OFFICER")
                        end
                    end
                    lastrunofficerkeys = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartykeys) == "number" then
                        local diff = now - lastrunpartykeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v), "PARTY")
                        end
                    end
                    lastrunpartykeys = _G.GetTime()
                --elseif event == "CHAT_MSG_WHISPER" then
                --    if type(lastrunwhisperkeys) == "number" then
                --        local diff = now - lastrunwhisperkeys
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        if v.level == DoKeysCurrentMaxLevel then
                --            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal"), "WHISPER")
                --        end
                --    end
                --    lastrunwhisperkeys = _G.GetTime()
                --elseif event == "CHAT_MSG_BN_WHISPER" then
                --    if type(lastrunbnwhisperkeys) == "number" then
                --        local diff = now - lastrunbnwhisperkeys
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        local message = k .. " " .. v["mythicplus"]["keystone"].WeeklyBest
                --        if v.level == DoKeysCurrentMaxLevel then
                --            BNSendWhisper(bnSenderID, message)
                --        end
                --    end
                --    lastrunbnwhisperkeys = _G.GetTime()
                end
            end
        end
    end

    --local db = LibStub("AceDB-3.0"):GetNamespace("DoKeysDB", true)
    --db.profile.minimap
    --db.profile.chat.respondkeys
    --if db ~= nil and db.profile.chat.respondkeys and msg ~= nil then -- if message ~= nil then
    if msg ~= nil then -- if message ~= nil then
        for i=1,#masfive do
            if string.match(msg,masfive[i]) then
                if event == "CHAT_MSG_GUILD" then
                    if type(lastrunguildkeys) == "number" then
                        local diff = now - lastrunguildkeys
                        if diff < 10 then
                            return
                        end
                    end

                    if _G.DoCharacters[realmName][UnitName("player")].level == DoKeysCurrentMaxLevel then
                        SendChatMessage(CreateLink(_G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"],"both") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")]), "GUILD")
                    end

                    lastrunguildkeys = _G.GetTime()
                elseif event == "CHAT_MSG_OFFICER" then
                    if type(lastrunofficerkeys) == "number" then
                        local diff = now - lastrunofficerkeys
                        if diff < 10 then
                            return
                        end
                    end

                    if _G.DoCharacters[realmName][UnitName("player")].level == DoKeysCurrentMaxLevel then
                        SendChatMessage(CreateLink(_G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"],"both") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")]), "OFFICER")
                    end

                    lastrunofficerkeys = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartykeys) == "number" then
                        local diff = now - lastrunpartykeys
                        if diff < 10 then
                            return
                        end
                    end

                    if _G.DoCharacters[realmName][UnitName("player")].level == DoKeysCurrentMaxLevel then
                        SendChatMessage(CreateLink(_G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"],"both") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")]), "PARTY")
                    end

                    lastrunpartykeys = _G.GetTime()
                --elseif event == "CHAT_MSG_WHISPER" then
                --    if type(lastrunwhisperkeys) == "number" then
                --        local diff = now - lastrunwhisperkeys
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        if v.level == DoKeysCurrentMaxLevel then
                --            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal"), "WHISPER")
                --        end
                --    end
                --    lastrunwhisperkeys = _G.GetTime()
                --elseif event == "CHAT_MSG_BN_WHISPER" then
                --    if type(lastrunbnwhisperkeys) == "number" then
                --        local diff = now - lastrunbnwhisperkeys
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        local message = k .. " " .. v["mythicplus"]["keystone"].WeeklyBest
                --        if v.level == DoKeysCurrentMaxLevel then
                --            BNSendWhisper(bnSenderID, message)
                --        end
                --    end
                --    lastrunbnwhisperkeys = _G.GetTime()
                end
            end
        end
    end

    if msg ~= nil then
        for i=1,#mastwo do
            if string.match(msg,mastwo[i]) then
                if event == "CHAT_MSG_GUILD" then
                    if type(lastrunguildhelp) == "number" then
                        local diff = now - lastrunguildhelp
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest .. " " .. v["mythicplus"]["keystone"].WeeklyBestLevelTimed, "GUILD")
                        end
                    end
                    lastrunguildhelp = _G.GetTime()
                elseif event == "CHAT_MSG_OFFICER" then
                    if type(lastrunofficerhelp) == "number" then
                        local diff = now - lastrunofficerhelp
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest .. " " .. v["mythicplus"]["keystone"].WeeklyBestLevelTimed, "OFFICER")
                        end
                    end
                    lastrunofficerhelp = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartyhelp) == "number" then
                        local diff = now - lastrunpartyhelp
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest .. " " .. v["mythicplus"]["keystone"].WeeklyBestLevelTimed, "PARTY")
                        end
                    end
                    lastrunpartyhelp = _G.GetTime()
                --elseif event == "CHAT_MSG_WHISPER" then
                --    if type(lastrunwhisperhelp) == "number" then
                --        local diff = now - lastrunwhisperhelp
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        if v.level == DoKeysCurrentMaxLevel then
                --            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, "WHISPER", "Common", sender)
                --        end
                --    end
                --    lastrunwhisperhelp = _G.GetTime()
                --elseif event == "CHAT_MSG_BN_WHISPER" then
                --    if type(lastrunbnwhisperhelp) == "number" then
                --        local diff = now - lastrunbnwhisperhelp
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    --text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        local message = k .. " " .. v["mythicplus"]["keystone"].WeeklyBest
                --        --bnSenderID
                --        --BNSendWhisper(bnetAccountID, message)
                --        if v.level == DoKeysCurrentMaxLevel then
                --            BNSendWhisper(bnSenderID, message)
                --        end
                --    end
                --    lastrunbnwhisperhelp = _G.GetTime()
                end
            end
        end
    end
    if msg ~= nil then -- if message ~= nil then
        for i=1,#mastw do
            if string.match(msg,mastw[i]) then
                if event == "CHAT_MSG_GUILD" then
                    if type(lastrunguildkeys) == "number" then
                        local diff = now - lastrunguildkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"tw") .. " " .. FindCovenant(v), "GUILD")
                        end
                    end
                    lastrunguildkeys = _G.GetTime()
                elseif event == "CHAT_MSG_OFFICER" then
                    if type(lastrunofficerkeys) == "number" then
                        local diff = now - lastrunofficerkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"tw") .. " " .. FindCovenant(v), "OFFICER")
                        end
                    end
                    lastrunofficerkeys = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartykeys) == "number" then
                        local diff = now - lastrunpartykeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"tw") .. " " .. FindCovenant(v), "PARTY")
                        end
                    end
                    lastrunpartykeys = _G.GetTime()
                --elseif event == "CHAT_MSG_WHISPER" then
                --    if type(lastrunwhisperkeys) == "number" then
                --        local diff = now - lastrunwhisperkeys
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        if v.level == DoKeysCurrentMaxLevel then
                --            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"tw"), "WHISPER")
                --        end
                --    end
                --    lastrunwhisperkeys = _G.GetTime()
                --elseif event == "CHAT_MSG_BN_WHISPER" then
                --    if type(lastrunbnwhisperkeys) == "number" then
                --        local diff = now - lastrunbnwhisperkeys
                --        if diff < 10 then
                --            return
                --        end
                --    end
                --    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                --        local message = k .. " " .. v["mythicplus"]["keystone"].WeeklyBest
                --        if v.level == DoKeysCurrentMaxLevel then
                --            BNSendWhisper(bnSenderID, message)
                --        end
                --    end
                --    lastrunbnwhisperkeys = _G.GetTime()
                end
            end
        end
    end
    if msg ~= nil then
        for i=1,#masfour do
            if string.match(msg,masfour[i]) then
                if event == "CHAT_MSG_GUILD" then
                    if type(lastrunguilddookies) == "number" then
                        local diff = now - lastrunguilddookies
                        if diff < 10 then
                            return
                        end
                    end
                    SendChatMessage("~“. _^_ ”~", "GUILD")
                    SendChatMessage("~“ (____) ”~", "GUILD")
                    SendChatMessage("~“(______) ”~", "GUILD")
                    SendChatMessage("“ (________) ”~", "GUILD")
                    SendChatMessage("(____________) ”    ", "GUILD")
                    lastrunguilddookies = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartydookies) == "number" then
                        local diff = now - lastrunpartydookies
                        if diff < 10 then
                            return
                        end
                    end
                    SendChatMessage("~“. _^_ ”~", "PARTY")
                    SendChatMessage("~“ (____) ”~", "PARTY")
                    SendChatMessage("~“(______) ”~", "PARTY")
                    SendChatMessage("“ (________) ”~", "PARTY")
                    SendChatMessage("(____________) ”    ", "PARTY")
                    lastrunpartydookies = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    SendChatMessage("~“. _^_ ”~", "WHISPER", "Common", sender)
                    SendChatMessage("~“ (____) ”~", "WHISPER", "Common", sender)
                    SendChatMessage("~“(______) ”~", "WHISPER", "Common", sender)
                    SendChatMessage("“ (________) ”~", "WHISPER", "Common", sender)
                    SendChatMessage("(____________) ”    ", "WHISPER", "Common", sender)
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    --text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
                    BNSendWhisper(bnSenderID, "~“. _^_ ”~")
                    BNSendWhisper(bnSenderID, "~“ (____) ”~")
                    BNSendWhisper(bnSenderID, "~“(______) ”~")
                    BNSendWhisper(bnSenderID, "“ (________) ”~")
                    BNSendWhisper(bnSenderID, "(____________) ”    ")
                end
            end
        end
    end
end

frame:SetScript("OnEvent", MessageHandler)
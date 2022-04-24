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
local mastw = {"!alltwkeys"}


local firsttwokeys
local firsttwohelp
local firsttwotwkeys

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

local function CreateLink(data,keytype)
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
    if keytype == "normal" and type(link) == "string" then
        return link
    end
    if keytype == "tw" and type(link) == "string" then
        return twlink
    end
    if keytype == "both" and type(link) == "string" and type(twlink) == "string" then
	    return link .. " & " ..  twlink
    elseif type(link) == "string" then
        return link
    elseif type(twlink) == "string" then
        return twlink
    else
        return "Error In Key Link"
    end
    return "Error In Key Link"
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
    if type(covenant) ~= "string" then
        covenant = ""
    end
    return covenant
end

local function MessageHandler(_, event, msg, sender, _, _, _, _, _, _, _, _, _, _, bnSenderID, _, _, _, _)

    if type(mas) ~= "table" then
        mas = {}
    end
    if type(mastwo) ~= "table" then
        mastwo = {}
    end
    if type(mastw) ~= "table" then
        mastw = {}
    end
    firsttwokeys = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "keys")
    firsttwohelp = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "help")
    firsttwotwkeys = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "twkeys")
    table.insert(mas,firsttwokeys)
    table.insert(mastwo,firsttwohelp)
    table.insert(mastw,firsttwotwkeys)

    local now = _G.GetTime()
    local GetRealmName = _G.GetRealmName
    local realmName = GetRealmName()
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(CreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(FindCovenant(v)) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v), "GUILD")
                            else
                                print("type CreateLink is: ", type(CreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
                                print("type FindCovenant is: ", type(FindCovenant(v)), "Please report this to DoKeys Author")
                            end
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(CreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(FindCovenant(v)) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v), "OFFICER")
                            else
                                print("type CreateLink is: ", type(CreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
                                print("type FindCovenant is: ", type(FindCovenant(v)), "Please report this to DoKeys Author")
                            end
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(CreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(FindCovenant(v)) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v), "PARTY")
                            else
                                print("type CreateLink is: ", type(CreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
                                print("type FindCovenant is: ", type(FindCovenant(v)), "Please report this to DoKeys Author")
                            end
                        end
                    end
                    lastrunpartykeys = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    if type(lastrunwhisperkeys) == "number" then
                        local diff = now - lastrunwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(CreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(FindCovenant(v)) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v), "WHISPER", nil, sender)
                            else
                                print("type CreateLink is: ", type(CreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
                                print("type FindCovenant is: ", type(FindCovenant(v)), "Please report this to DoKeys Author")
                            end
                        end
                    end
                    lastrunwhisperkeys = _G.GetTime()
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    if type(lastrunbnwhisperkeys) == "number" then
                        local diff = now - lastrunbnwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        local message = k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(v)
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            BNSendWhisper(bnSenderID, message)
                        end
                    end
                    lastrunbnwhisperkeys = _G.GetTime()
                end
            end
        end
    end
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
                        SendChatMessage(CreateLink(_G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")]), "GUILD")
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
                        SendChatMessage(CreateLink(_G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")]), "OFFICER")
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
                        SendChatMessage(CreateLink(_G.DoCharacters[realmName][UnitName("player")]["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")]), "PARTY")
                    end

                    lastrunpartykeys = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    if type(lastrunwhisperkeys) == "number" then
                        local diff = now - lastrunwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")]), "WHISPER", nil, sender)
                        end
                    end
                    lastrunwhisperkeys = _G.GetTime()
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    if type(lastrunbnwhisperkeys) == "number" then
                        local diff = now - lastrunbnwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        local message = k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal") .. " " .. FindCovenant(_G.DoCharacters[realmName][UnitName("player")])
                        if v.level == DoKeysCurrentMaxLevel then
                            BNSendWhisper(bnSenderID, message)
                        end
                    end
                    lastrunbnwhisperkeys = _G.GetTime()
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest .. " " .. v["mythicplus"]["keystone"].WeeklyBestLevelTimed, "PARTY")
                        end
                    end
                    lastrunpartyhelp = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    if type(lastrunwhisperhelp) == "number" then
                        local diff = now - lastrunwhisperhelp
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest .. " " .. v["mythicplus"]["keystone"].WeeklyBestLevelTimed, "WHISPER", nil, sender)
                        end
                    end
                    lastrunwhisperhelp = _G.GetTime()
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    if type(lastrunbnwhisperhelp) == "number" then
                        local diff = now - lastrunbnwhisperhelp
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        local message = k .. " " .. v["mythicplus"]["keystone"].WeeklyBest .. " " .. v["mythicplus"]["keystone"].WeeklyBestLevelTimed
                        if v.level == DoKeysCurrentMaxLevel then
                            BNSendWhisper(bnSenderID, message)
                        end
                    end
                    lastrunbnwhisperhelp = _G.GetTime()
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
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
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"tw") .. " " .. FindCovenant(v), "PARTY")
                        end
                    end
                    lastrunpartykeys = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    if type(lastrunwhisperkeys) == "number" then
                        local diff = now - lastrunwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"tw") .. " " .. FindCovenant(v), "WHISPER", nil, sender)
                        end
                    end
                    lastrunwhisperkeys = _G.GetTime()
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    if type(lastrunbnwhisperkeys) == "number" then
                        local diff = now - lastrunbnwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        local message = k .. " " .. CreateLink(v["mythicplus"]["keystone"],"tw") .. " " .. FindCovenant(v)
                        if v.level == DoKeysCurrentMaxLevel then
                            BNSendWhisper(bnSenderID, message)
                        end
                    end
                    lastrunbnwhisperkeys = _G.GetTime()
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
                    SendChatMessage("~“. _^_ ”~", "WHISPER", nil, sender)
                    SendChatMessage("~“ (____) ”~", "WHISPER", nil, sender)
                    SendChatMessage("~“(______) ”~", "WHISPER", nil, sender)
                    SendChatMessage("“ (________) ”~", "WHISPER", nil, sender)
                    SendChatMessage("(____________) ”    ", "WHISPER", nil, sender)
                elseif event == "CHAT_MSG_BN_WHISPER" then
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
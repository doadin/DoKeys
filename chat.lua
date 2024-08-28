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

local DoKeysCurrentMaxLevel = 80
local maxVaultLevel = 8

local realmgroupid
for i = 1, #connectionData do
   local lookforrealm = string.find(connectionData[i], tostring(GetRealmID()))
    if lookforrealm ~= nil then
        realmgroupid = strsplit(",", connectionData[i])
        break
    else
        realmgroupid = 0
    end
end

function DoKeysCreateLink(data,keytype)
    local AffixTable = C_MythicPlus.GetCurrentAffixes()
    local link
    if type(data) ~= "table" then
        return "Error In Key Link"
    end
    if keytype == "normal" or "both" then
	    if type(data) == "table" then
            if data.currentkeymapid and data.CurrentKeyLevel and data.CurrentKeyInstance and type(AffixTable) == "table" then
                if data.CurrentKeyLevel <= 4 then
	                link = string.format(
	                	'|cffa335ee|Hkeystone:180653:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.currentkeymapid or 0, --data.mapId
	                	data.CurrentKeyLevel, --data.level
                        AffixTable[1].id or 0,
                        0,
                        0,
                        0,
	                	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	                	data.CurrentKeyLevel --data.level
	                )
                end
                if data.CurrentKeyLevel >= 5 and data.CurrentKeyLevel <= 9 then
	                link = string.format(
	                	'|cffa335ee|Hkeystone:180653:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.currentkeymapid or 0, --data.mapId
	                	data.CurrentKeyLevel, --data.level
                        AffixTable[1].id or 0,
                        AffixTable[2].id or 0,
                        0,
                        0,
	                	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	                	data.CurrentKeyLevel --data.level
	                )
                end
                if data.CurrentKeyLevel >= 10 then --and data.CurrentKeyLevel <= 9 then
	                link = string.format(
	                	'|cffa335ee|Hkeystone:180653:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.currentkeymapid or 0, --data.mapId
	                	data.CurrentKeyLevel, --data.level
                        AffixTable[1].id or 0,
                        AffixTable[2].id or 0,
                        AffixTable[3].id or 0,
                        0,
	                	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	                	data.CurrentKeyLevel --data.level
	                )
                end
                --if data.CurrentKeyLevel >= 10 then
	            --    link = string.format(
	            --    	'|cffa335ee|Hkeystone:180653:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	            --    	data.currentkeymapid or 0, --data.mapId
	            --    	data.CurrentKeyLevel, --data.level
                --        AffixTable[1].id or 0,
                --        AffixTable[2].id or 0,
                --        AffixTable[3].id or 0,
                --        AffixTable[4].id or 0,
	            --    	data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
	            --    	data.CurrentKeyLevel --data.level
	            --    )
                --end
	        else
	    	    link = "None"
            end
	    end
    end
    local twlink
    if keytype == "tw" or "both" then
	    if type(data) == "table" then
            if data.CurrentTWKeyID and data.CurrentTWKeyLevel and data.CurrentTWKeyInstanceName and type(AffixTable) == "table" then
                if tonumber(data.CurrentTWKeyLevel) <= 3 then
	                twlink = string.format(
	                	'|cffa335ee|Hkeystone:187786:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.CurrentTWKeyID or 0, --data.mapId
	                	data.CurrentTWKeyLevel, --data.level
                        _G.DoCharacters.CurrentTWKeyAffix1 or 0,
                        0,
                        0,
                        0,
	                	data.CurrentTWKeyInstanceName, --data.mapNamePlain or data.mapName
	                	data.CurrentTWKeyLevel --data.level
	                )
                end
                if tonumber(data.CurrentTWKeyLevel)>= 4 and data.CurrentKeyLevel <= 6 then
	                twlink = string.format(
	                	'|cffa335ee|Hkeystone:187786:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.CurrentTWKeyID or 0, --data.mapId
	                	data.CurrentTWKeyLevel, --data.level
                        _G.DoCharacters.CurrentTWKeyAffix1 or 0,
                        _G.DoCharacters.CurrentTWKeyAffix2 or 0,
                        0,
                        0,
	                	data.CurrentTWKeyInstanceName, --data.mapNamePlain or data.mapName
	                	data.CurrentTWKeyLevel --data.level
	                )
                end
                if tonumber(data.CurrentTWKeyLevel) >= 7 and data.CurrentKeyLevel <= 10 then
	                twlink = string.format(
	                	'|cffa335ee|Hkeystone:187786:%d:%d:%d:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	                	data.CurrentTWKeyID or 0, --data.mapId
	                	data.CurrentTWKeyLevel, --data.level
                        _G.DoCharacters.CurrentTWKeyAffix1 or 0,
                        _G.DoCharacters.CurrentTWKeyAffix2 or 0,
                        _G.DoCharacters.CurrentTWKeyAffix3 or 0,
                        0,
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
            end
	    else
	    	twlink = "None"
	    end
    end

    if keytype == "normal" and type(link) == "string" and link ~= "" then
        return link
    end
    if keytype == "tw" and type(twlink) == "string" and twlink ~= "" then
        return twlink
    end
    if keytype == "both" and type(link) == "string" and link ~= "" and type(twlink) == "string" and twlink ~= "" then
	    return link .. " & " ..  twlink
    end
    return "Error In Key Link"
end

local function FindCovenant(data)
    local character
    local GetRealmName = _G.GetRealmName
    local realmName = GetRealmName()
    if type(data) ~= "table" then
        return "Error Finding Covenant"
    end
    if type(data) == "table" then
        character = data
    else
        character = _G.DoCharacters[realmgroupid][UnitName("player")]
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"normal"), "GUILD")
                            else
                                print("type DoKeysCreateLink is: ", type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"normal"), "OFFICER")
                            else
                                print("type DoKeysCreateLink is: ", type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
                            end
                        end
                    end
                    lastrunofficerkeys = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartykeys) == "number" then
                        local diff = now - lastrunpartykeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"normal"), "PARTY")
                            else
                                print("type DoKeysCreateLink is: ", type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            if type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")) == "string" and type(k) == "string" then
                                SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"normal"), "WHISPER", nil, sender)
                            else
                                print("type DoKeysCreateLink is: ", type(DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")), "Please report this to DoKeys Author")
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        local message = k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"normal")
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

                    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].level == DoKeysCurrentMaxLevel then
                        SendChatMessage(DoKeysCreateLink(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"],"normal"), "GUILD")
                    end

                    lastrunguildkeys = _G.GetTime()
                elseif event == "CHAT_MSG_OFFICER" then
                    if type(lastrunofficerkeys) == "number" then
                        local diff = now - lastrunofficerkeys
                        if diff < 10 then
                            return
                        end
                    end

                    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].level == DoKeysCurrentMaxLevel then
                        SendChatMessage(DoKeysCreateLink(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"],"normal"), "OFFICER")
                    end

                    lastrunofficerkeys = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartykeys) == "number" then
                        local diff = now - lastrunpartykeys
                        if diff < 10 then
                            return
                        end
                    end

                    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].level == DoKeysCurrentMaxLevel then
                        SendChatMessage(DoKeysCreateLink(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"],"normal"), "PARTY")
                    end

                    lastrunpartykeys = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    if type(lastrunwhisperkeys) == "number" then
                        local diff = now - lastrunwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].level == DoKeysCurrentMaxLevel then
                        SendChatMessage(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].name .. " " .. DoKeysCreateLink(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"],"normal"), "WHISPER", nil, sender)
                    end
                    lastrunwhisperkeys = _G.GetTime()
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    if type(lastrunbnwhisperkeys) == "number" then
                        local diff = now - lastrunbnwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    if _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].level == DoKeysCurrentMaxLevel then
                        local message = _G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()].name .. " " .. DoKeysCreateLink(_G.DoCharacters[realmgroupid][UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"],"normal")
                        BNSendWhisper(bnSenderID, message)
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
                    local count = 0
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            --local weeklybest = v["mythicplus"]["keystone"].WeeklyBest or 0
                            if type(v["mythicplus"]["keystone"].WeeklyBest) ~= "number" then
                                v["mythicplus"]["keystone"].WeeklyBest = 0
                            end
                            if v["mythicplus"]["keystone"].WeeklyBest < maxVaultLevel or (v["mythicplus"]["keystone"].WeeklyBest == 15 and v["mythicplus"]["keystone"].WeeklyBestLevelTimed == "Not In Time" ) then --if tonumber(weeklybest) < 15 then
                                SendChatMessage(k .. " Weekly Best: " .. (v["mythicplus"]["keystone"].WeeklyBest or 0) .. " " .. (v["mythicplus"]["keystone"].WeeklyBestLevelTimed or ""), "GUILD")
                                count = count + 1
                            end
                        end
                    end
                    if count == 0 then
                        SendChatMessage(" Weekly Best: Done", "GUILD")
                    end
                    lastrunguildhelp = _G.GetTime()
                elseif event == "CHAT_MSG_OFFICER" then
                    if type(lastrunofficerhelp) == "number" then
                        local diff = now - lastrunofficerhelp
                        if diff < 10 then
                            return
                        end
                    end
                    local count = 0
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            --local weeklybest = v["mythicplus"]["keystone"].WeeklyBest or 0
                            if type(v["mythicplus"]["keystone"].WeeklyBest) ~= "number" then
                                v["mythicplus"]["keystone"].WeeklyBest = 0
                            end
                            if v["mythicplus"]["keystone"].WeeklyBest < maxVaultLevel or (v["mythicplus"]["keystone"].WeeklyBest == 15 and v["mythicplus"]["keystone"].WeeklyBestLevelTimed == "Not In Time" ) then --if tonumber(weeklybest) < 15 then
                                SendChatMessage(k .. " Weekly Best: " .. (v["mythicplus"]["keystone"].WeeklyBest or 0) .. " " .. (v["mythicplus"]["keystone"].WeeklyBestLevelTimed or ""), "OFFICER")
                                count = count + 1
                            end
                        end
                    end
                    if count == 0 then
                        SendChatMessage(" Weekly Best: Done", "OFFICER")
                    end
                    lastrunofficerhelp = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartyhelp) == "number" then
                        local diff = now - lastrunpartyhelp
                        if diff < 10 then
                            return
                        end
                    end
                    local count = 0
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" then
                            --local weeklybest = v["mythicplus"]["keystone"].WeeklyBest or 0
                            if type(v["mythicplus"]["keystone"].WeeklyBest) ~= "number" then
                                v["mythicplus"]["keystone"].WeeklyBest = 0
                            end
                            if v["mythicplus"]["keystone"].WeeklyBest < maxVaultLevel or (v["mythicplus"]["keystone"].WeeklyBest == 15 and v["mythicplus"]["keystone"].WeeklyBestLevelTimed == "Not In Time" ) then --if tonumber(weeklybest) < 15 then
                                SendChatMessage(k .. " Weekly Best: " .. (v["mythicplus"]["keystone"].WeeklyBest or 0) .. " " .. (v["mythicplus"]["keystone"].WeeklyBestLevelTimed or ""), "PARTY")
                                count = count + 1
                            end
                        end
                    end
                    if count == 0 then
                        SendChatMessage(" Weekly Best: Done", "PARTY")
                    end
                    lastrunpartyhelp = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    if type(lastrunwhisperhelp) == "number" then
                        local diff = now - lastrunwhisperhelp
                        if diff < 10 then
                            return
                        end
                    end
                    local count = 0
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            --local weeklybest = v["mythicplus"]["keystone"].WeeklyBest or 0
                            if type(v["mythicplus"]["keystone"].WeeklyBest) ~= "number" then
                                v["mythicplus"]["keystone"].WeeklyBest = 0
                            end
                            if v["mythicplus"]["keystone"].WeeklyBest < maxVaultLevel or (v["mythicplus"]["keystone"].WeeklyBest == 15 and v["mythicplus"]["keystone"].WeeklyBestLevelTimed == "Not In Time" ) then --if tonumber(weeklybest) < 15 then
                                SendChatMessage(k .. " Weekly Best: " .. (v["mythicplus"]["keystone"].WeeklyBest or 0) .. " " .. (v["mythicplus"]["keystone"].WeeklyBestLevelTimed or ""), "WHISPER", nil, sender)
                                count = count + 1
                            end
                        end
                    end
                    if count == 0 then
                        SendChatMessage(" Weekly Best: Done", "WHISPER", nil, sender)
                    end
                    lastrunwhisperhelp = _G.GetTime()
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    if type(lastrunbnwhisperhelp) == "number" then
                        local diff = now - lastrunbnwhisperhelp
                        if diff < 10 then
                            return
                        end
                    end
                    local count = 0
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        local message = k .. " " .. (v["mythicplus"]["keystone"].WeeklyBest or 0) .. " " .. (v["mythicplus"]["keystone"].WeeklyBestLevelTimed or "")
                        if v.level == DoKeysCurrentMaxLevel then
                            --local weeklybest = v["mythicplus"]["keystone"].WeeklyBest or 0
                            if type(v["mythicplus"]["keystone"].WeeklyBest) ~= "number" then
                                v["mythicplus"]["keystone"].WeeklyBest = 0
                            end
                            if v["mythicplus"]["keystone"].WeeklyBest < maxVaultLevel or (v["mythicplus"]["keystone"].WeeklyBest == 15 and v["mythicplus"]["keystone"].WeeklyBestLevelTimed == "Not In Time" ) then --if tonumber(weeklybest) < 15 then
                                BNSendWhisper(bnSenderID, message)
                                count = count + 1
                            end
                        end
                    end
                    if count == 0 then
                        BNSendWhisper(bnSenderID, " Weekly Best: Done")
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
                            SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"tw"), "GUILD")
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
                            SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"tw"), "OFFICER")
                        end
                    end
                    lastrunofficerkeys = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
                    if type(lastrunpartykeys) == "number" then
                        local diff = now - lastrunpartykeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel and type(k) == "string" and type(v["mythicplus"]["keystone"]) == "table" and type(k) == "string" then
                            SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"tw"), "PARTY")
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        if v.level == DoKeysCurrentMaxLevel then
                            SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"tw"), "WHISPER", nil, sender)
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
                    for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                        local message = k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"tw")
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
                elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
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
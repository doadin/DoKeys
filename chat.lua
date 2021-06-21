--luacheck: no max line length
--luacheck: no redefined

local DoKeys = _G.DoKeys

local BNSendWhisper = _G.BNSendWhisper
local SendChatMessage = _G.SendChatMessage
local CreateFrame = _G.CreateFrame
local realm = _G.GetRealmName
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


local firsttwokeys = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "keys")
local firsttwohelp = string.lower("!" .. string.sub(UnitName("player"),1,2) .. "help")
table.insert(mas,firsttwokeys)
table.insert(mastwo,firsttwohelp)

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

local function MessageHandler(_, event, msg, sender, _, _, _, _, _, _, _, _, _, _, bnSenderID, _, _, _, _)
    local now = _G.GetTime()
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
                    --SendChatMessage(Report,"CHANNEL",nil,chanNumber)
                    --print("got guild message")
                    if type(lastrunguildkeys) == "number" then
                        local diff = now - lastrunguildkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == 60 then
                            SendChatMessage(k .. " " .. DoKeys:CreateLink(v["mythicplus"]["keystone"]), "GUILD")
                        end
                    end
                    lastrunguildkeys = _G.GetTime()
                elseif event == "CHAT_MSG_OFFICER" then
                    --SendChatMessage(Report,"GUILD")
                    --print("got officer message")
                    if type(lastrunofficerkeys) == "number" then
                        local diff = now - lastrunofficerkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == 60 then
                            SendChatMessage(k .. " " .. DoKeys:CreateLink(v["mythicplus"]["keystone"]), "OFFICER")
                        end
                    end
                    lastrunofficerkeys = _G.GetTime()
                elseif event == "CHAT_MSG_PARTY" or "CHAT_MSG_PARTY_LEADER" then
                    --SendChatMessage(Report,"GUILD")
                    --print("got party message")
                    if type(lastrunpartykeys) == "number" then
                        local diff = now - lastrunpartykeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == 60 then
                            SendChatMessage(k .. " " .. DoKeys:CreateLink(v["mythicplus"]["keystone"]), "PARTY")
                        end
                    end
                    lastrunpartykeys = _G.GetTime()
                elseif event == "CHAT_MSG_WHISPER" then
                    --SendChatMessage(Report,"GUILD")
                    --print("got party message")
                    if type(lastrunwhisperkeys) == "number" then
                        local diff = now - lastrunwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        if v.level == 60 then
                            SendChatMessage(k .. " " .. DoKeys:CreateLink(v["mythicplus"]["keystone"]), "WHISPER")
                        end
                    end
                    lastrunwhisperkeys = _G.GetTime()
                elseif event == "CHAT_MSG_BN_WHISPER" then
                    --SendChatMessage(Report,"GUILD")
                    --print("got party message")
                    if type(lastrunbnwhisperkeys) == "number" then
                        local diff = now - lastrunbnwhisperkeys
                        if diff < 10 then
                            return
                        end
                    end
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        local message = k .. " " .. v["mythicplus"]["keystone"].WeeklyBest
                        if v.level == 60 then
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
                        if v.level == 60 then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, "GUILD")
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
                        if v.level == 60 then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, "OFFICER")
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
                        if v.level == 60 then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, "PARTY")
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
                        if v.level == 60 then
                            SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, "WHISPER", "Common", sender)
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
                    --text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
                    for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                        local message = k .. " " .. v["mythicplus"]["keystone"].WeeklyBest
                        --bnSenderID
                        --BNSendWhisper(bnetAccountID, message)
                        if v.level == 60 then
                            BNSendWhisper(bnSenderID, message)
                        end
                    end
                    lastrunbnwhisperhelp = _G.GetTime()
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
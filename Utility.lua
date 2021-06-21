local mapidname = {
    ["De Other Side"] = 1679,
    ["Halls of Atonement"] = 1663,
    ["Mists of Tirna Scithe"] = 1669,
    ["Plaguefall"] = 1674,
    ["Sanguine Depths"] = 1675,
    ["Spires Of Ascension"] = 1693,
    ["The Necrotic Wake"] = 1666,
    ["Theater of Pain"] = 1683,
}

function DoKeys:CreateLink(data)
    -- '|cffa335ee|Hkeystone:180653:244:2:10:0:0:0|h[Keystone: Atal'dazar (2)]|h|r'
    local link
    if string.len(data.CurrentKeyInstance) > 2 then
        local mapedid
        for mapname,id in pairs(mapidname) do
            if mapname == data.CurrentKeyInstance then
                mapedid = id
            end
        end
        link = string.format(
            '|cffa335ee|Hkeystone:180653:%d:%d:10:0:0:0|h[Keystone: %s (%d)]|h|r',
            mapedid or 0, --data.mapId
            data.CurrentKeyLevel, --data.level
            data.CurrentKeyInstance, --data.mapNamePlain or data.mapName
            data.CurrentKeyLevel --data.level
        )
    else
        link = "None"
    end
    return link
end

--ADDON_LOADED
--SAVED_VARIABLES_TOO_LARGE
--SPELLS_CHANGED
--PLAYER_LOGIN
--PLAYER_ENTERING_WORLD


--local DoKeysTestFrame = CreateFrame("FRAME") --PLAYER_ENTERING_WORLD: isInitialLogin, isReloadingUi
--DoKeysTestFrame:RegisterEvent("ADDON_LOADED")
--DoKeysTestFrame:RegisterEvent("SAVED_VARIABLES_TOO_LARGE")
--DoKeysTestFrame:RegisterEvent("SPELLS_CHANGED")
--DoKeysTestFrame:RegisterEvent("PLAYER_LOGIN")
--DoKeysTestFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
--DoKeysTestFrame:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
--DoKeysTestFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
--
--local function EventOrder(_, event)
--	if event == "ADDON_LOADED" then
--		print("ADDON_LOADED")
--	end
--	if event == "SAVED_VARIABLES_TOO_LARGE" then
--		print("SAVED_VARIABLES_TOO_LARGE")
--	end
--	if event == "SPELLS_CHANGED" then
--		print("SPELLS_CHANGED")
--	end
--	if event == "PLAYER_LOGIN" then
--		print("PLAYER_LOGIN")
--	end
--	if event == "PLAYER_ENTERING_WORLD" then
--		print("PLAYER_ENTERING_WORLD")
--	end
--	if event == "CHALLENGE_MODE_MAPS_UPDATE" then
--		print("CHALLENGE_MODE_MAPS_UPDATE")
--	end
--	if event == "LOADING_SCREEN_DISABLED" then
--		print("LOADING_SCREEN_DISABLED")
--	end
--end
--
--
--DoKeysTestFrame:SetScript("OnEvent", EventOrder)

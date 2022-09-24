--luacheck: no max line length

local GetNumGroupMembers = _G.GetNumGroupMembers
--local IsInGroup = _G.IsInGroup
local UnitIsGroupLeader = _G.UnitIsGroupLeader
local UnitName = _G.UnitName
local CreateFrame = _G.CreateFrame
local f = CreateFrame("Frame")
 -- LFG_LIST_APPLICATION_STATUS_UPDATED LFG_LIST_JOINED_GROUP LFG_LIST_APP_INVITE_ACCEPTED LFG_PROPOSAL_SHOW LFG_OFFER_CONTINUE LFG_LIST_VIEW_GROUP LFG_PROPOSAL_UPDATE LFG_PROPOSAL_SUCCEEDED

--local function OnEvent(_, event, one, two, three, four, five, six, seven, eight)
--    if not _G.DoCharacters.whodat or _G.DoCharacters.whodat == false then return end
--    -- PARTY_INVITE_REQUEST = name, isTank, isHealer, isDamage, isNativeRealm, allowMultipleRoles, inviterGUID, questSessionActive
--    -- GROUP_ROSTER_UPDATE = None
--    -- LFG_LIST_JOINED_GROUP = searchResultID, groupName
--    -- GROUP_JOINED = category, partyGUID
--    -- GROUP_FORMED = category, partyGUID
--    --if not IsInGroup then
--    if event == "PARTY_INVITE_REQUEST" then
--        print("Invite Received From: ",one)
--    end
--    --if event == "GROUP_ROSTER_UPDATE" then
--    --    for i = 1, GetNumGroupMembers() do
--    --        local unit = "party" .. i
--    --        local IsLeader = UnitIsGroupLeader(unit)
--    --        if IsLeader then
--    --            print("Leader Of Group: ",UnitName(unit))
--    --            local name, realm = UnitName(unit)
--    --            if name and realm then
--    --                print("Leader Of Group: ", name .. "-" .. realm)
--    --            end
--    --            if name then
--    --                print("Leader Of Group: ", name)
--    --            end
--    --        end
--    --    end
--    --end
--    if event == "LFG_LIST_JOINED_GROUP" then
--        --one GroupID
--        print("Invited To: ", two)
--    end
--    --if event == "GROUP_JOINED" then
--    --    for i = 1, GetNumGroupMembers() do
--    --        local unit = "party" .. i
--    --        local IsLeader = UnitIsGroupLeader(unit)
--    --        if IsLeader then
--    --            --print("Leader Of Group: ",UnitName(unit))
--    --            local name, realm = UnitName(unit)
--    --            if name and not realm then
--    --                print("Leader Of Group: ", name)
--    --            end
--    --            if name and realm then
--    --                print("Leader Of Group: ", name .. "-" .. realm)
--    --            end
--    --        end
--    --    end
--    --    --print("Invite Received From: ",one, two)
--    --end
--    --if event == "GROUP_FORMED" then
--    --    print("GROUP_FORMED: ",one, two)
--    --end
--end
--
--f:RegisterEvent("PARTY_INVITE_REQUEST")
--f:RegisterEvent("GROUP_ROSTER_UPDATE")
--f:RegisterEvent("LFG_LIST_JOINED_GROUP")
--f:RegisterEvent("GROUP_ROSTER_UPDATE")
----f:RegisterEvent("GROUP_JOINED")
----f:RegisterEvent("GROUP_FORMED")
--f:SetScript("OnEvent", OnEvent)


local ff = CreateFrame("Frame")

function InvitedTo(self, event, searchResultID, newStatus, oldStatus, groupName)
    --if oldStatus ~= "invited" then return end
    --print(oldStatus)
    --print(newStatus)
    --print(groupName)
    if not _G.DoCharacters.whodat or _G.DoCharacters.whodat == false then return end
    if oldStatus ~= "invited" and newStatus ~= "inviteaccepted" then return end
    if event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
        local ResultInfo = searchResultID and C_LFGList.GetSearchResultInfo(searchResultID) or {}
        local ActivityFullName = ResultInfo["activityID"] and C_LFGList.GetActivityFullName(ResultInfo["activityID"]) or ""
        local ActivityleaderName = ResultInfo["leaderName"] or ""
        local ActivitygroupName = groupName and groupName or ""
        --if ResultInfo["activityID"] ~= nil then
        --    --print("got ResultInfo[activityID]")
        --    local ActivityFullName = C_LFGList.GetActivityFullName(ResultInfo["activityID"])
        --    print(ActivityFullName)
        --end
        --if ResultInfo["leaderName"] ~= nil then
        --    --print("got ResultInfo[leaderName]")
        --    local ActivityleaderName = ResultInfo["leaderName"]
        --    print(ActivityleaderName)
        --end
        --|cff00ff00green|r
        DEFAULT_CHAT_FRAME:AddMessage("DoKeys: Received Invite to: " ..  ActivitygroupName .. " " .. ActivityFullName .. " By: " .. ActivityleaderName,1,1,0)
    end
end

ff:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
ff:SetScript("OnEvent", InvitedTo)

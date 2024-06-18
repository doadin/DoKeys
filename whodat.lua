--luacheck: no max line length

local CreateFrame = _G.CreateFrame

local ff = CreateFrame("Frame")

local function InvitedTo(self, event, searchResultID, newStatus, oldStatus, groupName)
    if not _G.DoCharacters.whodat or _G.DoCharacters.whodat == false then return end
    if _G.DoCharacters then
    else
        _G.DoCharacters = {}
    end
    if _G.DoCharacters.whodattracker then
    else
        _G.DoCharacters.whodattracker = {}
    end
    --print(event, searchResultID, newStatus, oldStatus, groupName)
    if newStatus == "invited" and groupName ~= "Unknown" then
        local ResultInfo = searchResultID and C_LFGList.GetSearchResultInfo(searchResultID) or {}
        local ActivityFullName = ResultInfo["activityID"] and C_LFGList.GetActivityFullName(ResultInfo["activityID"]) or ""
        local ActivityleaderName = ResultInfo["leaderName"] or ""
        local ActivitygroupName = groupName and groupName or ""
        _G.DoCharacters.whodattracker[searchResultID] = { ActivityFullName = ActivityFullName , ActivitygroupName = ActivitygroupName, ActivityleaderName = ActivityleaderName }
        DEFAULT_CHAT_FRAME:AddMessage("DoKeys: Received Invite To: " ..  _G.DoCharacters.whodattracker[searchResultID].ActivitygroupName .. " " .. _G.DoCharacters.whodattracker[searchResultID].ActivityFullName .. " By: " .. _G.DoCharacters.whodattracker[searchResultID].ActivityleaderName,1,1,0)
        --print("DoKeys: Received Invite To: " ..  _G.DoCharacters.whodattracker[searchResultID].ActivitygroupName .. " " .. _G.DoCharacters.whodattracker[searchResultID].ActivityFullName .. " By: " .. _G.DoCharacters.whodattracker[searchResultID].ActivityleaderName)
    end
    if newStatus == "inviteaccepted" then
        if _G.DoCharacters and _G.DoCharacters.whodattracker and _G.DoCharacters.whodattracker[searchResultID] then
            local ActivityFullName = _G.DoCharacters.whodattracker[searchResultID].ActivityFullName
            local ActivityleaderName = _G.DoCharacters.whodattracker[searchResultID].ActivityleaderName
            local ActivitygroupName = _G.DoCharacters.whodattracker[searchResultID].ActivitygroupName
            DEFAULT_CHAT_FRAME:AddMessage("DoKeys: Accepted Invite To: " ..  ActivitygroupName .. " " .. ActivityFullName .. " By: " .. ActivityleaderName,1,1,0)
            --print("DoKeys: Accepted Invite To: " ..  ActivitygroupName .. " " .. ActivityFullName .. " By: " .. ActivityleaderName)
        end
    end
end

ff:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
ff:SetScript("OnEvent", InvitedTo)


--luacheck: no max line length

local CreateFrame = _G.CreateFrame

local ff = CreateFrame("Frame")

local function InvitedTo(self, event, searchResultID, newStatus, oldStatus, groupName)
    if not _G.DoCharacters.whodat or _G.DoCharacters.whodat == false then return end
    --print(event, searchResultID, newStatus, oldStatus, groupName)
    --name="|Kq92|k", is unknown
    if newStatus == "invited" and groupName ~= "Unknown" then
        local ResultInfo = searchResultID and C_LFGList.GetSearchResultInfo(searchResultID) or {}
        local map = ResultInfo and ResultInfo.leaderDungeonScoreInfo and ResultInfo.leaderDungeonScoreInfo[1].mapName or ""
        local ActivityFullName = ResultInfo["activityIDs"] and C_LFGList.GetActivityFullName(ResultInfo["activityIDs"][1]) or ""
        local ActivityleaderName = ResultInfo and ResultInfo.leaderName or ""
        local ActivitygroupName = ResultInfo and ResultInfo.name or ""
        DEFAULT_CHAT_FRAME:AddMessage("DoKeys: Received Invite To: " ..  ActivitygroupName .. " " .. map .. " By: " .. ActivityleaderName,1,1,0)
        --print("DoKeys: Received Invite To: " ..  _G.DoCharacters.whodattracker[searchResultID].ActivitygroupName .. " " .. _G.DoCharacters.whodattracker[searchResultID].ActivityFullName .. " By: " .. _G.DoCharacters.whodattracker[searchResultID].ActivityleaderName)
    end
    if newStatus == "inviteaccepted" then
        --DevTools_Dump(C_LFGList.GetSearchResultInfo(searchResultID))
        local ResultInfo = searchResultID and C_LFGList.GetSearchResultInfo(searchResultID) or {}
        local map = ResultInfo and ResultInfo.leaderDungeonScoreInfo and ResultInfo.leaderDungeonScoreInfo[1].mapName or ""
        local ActivityFullName = ResultInfo["activityIDs"] and C_LFGList.GetActivityFullName(ResultInfo["activityIDs"][1]) or ""
        local ActivityleaderName = ResultInfo and ResultInfo.leaderName or ""
        local ActivitygroupName = ResultInfo and ResultInfo.name or ""
        DEFAULT_CHAT_FRAME:AddMessage("DoKeys: Accepted Invite To: " ..  ActivitygroupName .. " " .. map .. " By: " .. ActivityleaderName,1,1,0)
        --print("DoKeys: Accepted Invite To: " ..  ActivitygroupName .. " " .. ActivityFullName .. " By: " .. ActivityleaderName)
    end
end

ff:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
ff:SetScript("OnEvent", InvitedTo)


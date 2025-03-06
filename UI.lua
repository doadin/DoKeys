local LibStub = _G.LibStub
local realm = _G.GetRealmName()
local CreateFrame = _G.CreateFrame
local SendChatMessage = _G.SendChatMessage
local GetAddOnMetadata = _G.C_AddOns.GetAddOnMetadata
local DoKeysCurrentMaxLevel = 80
local C_ChallengeMode = _G.C_ChallengeMode
local C_MythicPlus = _G.C_MythicPlus
local tinsert = _G.tinsert
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local realmName = _G.GetRealmName()

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

local StdUi = LibStub("StdUi")

local MainFrame = StdUi:Window(UIParent, 850, 550, 'DoKeys')
MainFrame:SetPoint('CENTER')
MainFrame:Hide()

local SeasonBestsFrame = StdUi:Window(UIParent, 1100, 300, "DoKeys Season Bests")
SeasonBestsFrame:SetPoint('CENTER')
SeasonBestsFrame:Hide()

local SeasonBestsHeading = StdUi:PanelWithTitle(SeasonBestsFrame, 1100, 250, "Player's Season Bests", 25, 16)
StdUi:GlueTop(SeasonBestsHeading, SeasonBestsFrame, 0, -40)

local PlayerHeading = StdUi:PanelWithTitle(MainFrame, 850, 160, "Player's Keys", 25, 16)
StdUi:GlueTop(PlayerHeading, MainFrame, 0, -45)

local function UpdateReward()
    local Rewardheading
    if C_MythicPlus.IsWeeklyRewardAvailable() then
        Rewardheading = StdUi:Label(MainFrame,(_G.UnitName("player") .. " " .. "Has a Weekly M+ Reward Available, Good Luck On Your Loot!"))
        StdUi:GlueTop(Rewardheading, MainFrame, 0, -30)
    else
        if Rewardheading then
            Rewardheading:Hide()
        end
    end
end

local function UpdateNextRewardLevel()
    local NextRewardLevel
    if not _G.DoCharacters or not _G.DoCharacters[realmgroupid] then return end
    local WB = _G.DoCharacters[realmgroupid][_G.UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest or 1
    if WB <= 0 then WB = 1 end
    local hasSeasonData, nextMythicPlusLevel, itemLevel = C_WeeklyRewards.GetNextMythicPlusIncrease(WB)
    if not C_MythicPlus.IsWeeklyRewardAvailable() then
        if nextMythicPlusLevel ~= nil or itemLevel ~= nil then
            NextRewardLevel = StdUi:Label(MainFrame,(_G.UnitName("player") .. "'s " .. "weekly reward from M+ increases at level " .. tostring(nextMythicPlusLevel) .. " to item level " .. tostring(itemLevel)))
            StdUi:GlueTop(NextRewardLevel, MainFrame, 0, -30)
        else
            NextRewardLevel = StdUi:Label(MainFrame,(_G.UnitName("player") .. "'s " .. "weekly reward from M+ is at max!"))
            StdUi:GlueTop(NextRewardLevel, MainFrame, 0, -30)
        end
    end
end

--local UpdateRewardFrame = CreateFrame("Frame")
--UpdateRewardFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
--UpdateRewardFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
--UpdateRewardFrame:SetScript("OnEvent", UpdateReward)

local columnHeaders
do
    local numDayEvents = C_Calendar.GetNumDayEvents(0, C_DateAndTime.GetCurrentCalendarTime().monthDay)
    local found = false
    for i=1,numDayEvents do
        local info = C_Calendar.GetHolidayInfo(0,C_DateAndTime.GetCurrentCalendarTime().monthDay,i)
        if info and info.name == "Timewalking Dungeon Event" then
            found = true
            break
        end
    end
    if found == true then
        columnHeaders = {
            {
                name = 'Name',
                width = 120,
                align = 'LEFT',
                defaultsort = 'dsc',
                sortnext = 3,
                index = 'name',
                format = 'string',
            },
            --{
            --    name = 'Level',
            --    width = 60,
            --    align = 'CENTER',
            --    defaultsort = 'dsc',
            --    index = 'level',
            --    format = 'string',
            --},
            {
                name = 'Weekly Count',
                width = 110,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'weeklyCount',
            },
            {
                name = 'Weekly Best',
                width = 100,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'WeeklyBest',
                format = 'string',
            },
            --{
            --    name = 'Weekly Best Timed',
            --    width = 20,
            --    align = 'CENTER',
            --    defaultsort = 'dsc',
            --    index = 'WeeklyBestLevelTimed',
            --    format = 'string',
            --},
            {
                name = 'Key Level',
                width = 85,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'CurrentKeyLevel',
            },
            {
                name = 'Dungeon',
                width = 160,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'CurrentKeyInstance',
                format = 'string',
            },
            {
                name = 'Avg ILvl',
                width = 75,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'avgItemLevel',
                format = 'string',
            },
            {
                name = 'M+ Score',
                width = 85,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'currentSeasonScore',
                format = 'string',
            },
            {
                name = 'TW Key Level',
                width = 90,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'CurrentTWKeyLevel',
                format = 'string',
            },
            {
                name = 'TW Key Dungeon',
                width = 110,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'CurrentTWKeyInstanceName',
                format = 'string',
            },
        }
    else
        columnHeaders = {
            {
                name = 'Name',
                width = 120,
                align = 'LEFT',
                defaultsort = 'dsc',
                sortnext = 3,
                index = 'name',
                format = 'string',
            },
            --{
            --    name = 'Level',
            --    width = 60,
            --    align = 'CENTER',
            --    defaultsort = 'dsc',
            --    index = 'level',
            --    format = 'string',
            --},
            {
                name = 'Weekly Count',
                width = 110,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'weeklyCount',
            },
            {
                name = 'Weekly Best',
                width = 100,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'WeeklyBest',
                format = 'string',
            },
            --{
            --    name = 'Weekly Best Timed',
            --    width = 20,
            --    align = 'CENTER',
            --    defaultsort = 'dsc',
            --    index = 'WeeklyBestLevelTimed',
            --    format = 'string',
            --},
            {
                name = 'Key Level',
                width = 85,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'CurrentKeyLevel',
            },
            {
                name = 'Dungeon',
                width = 160,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'CurrentKeyInstance',
                format = 'string',
            },
            {
                name = 'Avg ILvl',
                width = 75,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'avgItemLevel',
                format = 'string',
            },
            {
                name = 'M+ Score',
                width = 85,
                align = 'CENTER',
                defaultsort = 'dsc',
                index = 'currentSeasonScore',
                format = 'string',
            },
        }
    end
end

local st = StdUi:ScrollTable(PlayerHeading, columnHeaders, 6)
StdUi:GlueTop(st, PlayerHeading, 0, -50)


--local version, build, date, tocversion = GetBuildInfo()
--if tocversion <= 90207 then
local SeasonBestHeaders = {
    {
        name = 'Name',
        width = 50,
        align = 'LEFT',
        defaultsort = 'dsc',
        index = 'name',
        --format = 'string',
    },
    --{
    --    name = 'ACoE',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'ACoE',
    --    --format = 'string',
    --},
    --{
    --    name = 'CoT',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'CoT',
    --    --format = 'string',
    --},
    --{
    --    name = 'TS',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'TS',
    --    --format = 'string',
    --},
    --{
    --    name = 'TD',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'TD',
    --    --format = 'string',
    --},
    --{
    --    name = 'MoTS',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'MoTS',
    --    --format = 'string',
    --},
    --{
    --    name = 'TNW',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'TNW',
    --    --format = 'string',
    --},
    --{
    --    name = 'SoB',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'SoB',
    --    --format = 'string',
    --},
    --{
    --    name = 'GB',
    --    width = 100,
    --    align = 'RIGHT',
    --    defaultsort = 'dsc',
    --    index = 'GB',
    --    --format = 'string',
    --},
}
for i,mapID in pairs(C_ChallengeMode.GetMapTable()) do
    local index = ""
    if i == 1 then
        index = "one"
    end
    if i == 2 then
        index = "two"
    end
    if i == 3 then
        index = "three"
    end
    if i == 4 then
        index = "four"
    end
    if i == 5 then
        index = "five"
    end
    if i == 6 then
        index = "six"
    end
    if i == 7 then
        index = "seven"
    end
    if i == 8 then
        index = "eight"
    end
    table.insert(SeasonBestHeaders,
    {
        name = C_ChallengeMode.GetMapUIInfo(mapID):gsub("(%a)%a*", "%1"),
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = index,
        --format = 'string',
    }
)
end



local SeasonBestsst = StdUi:ScrollTable(SeasonBestsHeading, SeasonBestHeaders)
StdUi:GlueTop(SeasonBestsst, SeasonBestsHeading, 0, -50)

local ReportHeading = StdUi:Panel(MainFrame, 800, 65)
StdUi:GlueTop(ReportHeading, MainFrame, 0, -210)

local ReportToDropDownitems = {
    {text = "", value = ""}, -- First option
    {text = "Guild", value = "GUILD"}, -- Second option
    {text = "Party", value = "PARTY"}, -- Third option
    {text = "Officer", value = "OFFICER"}, -- Fourth option
}

local ReportToDropDown = StdUi:Dropdown(ReportHeading, 200, 20, ReportToDropDownitems)
ReportToDropDown:SetPoint('CENTER')

StdUi:AddLabel(ReportHeading, ReportToDropDown, "Report Weekly Best To:", "LEFT", 155)

local ReportToButton = StdUi:Button(ReportHeading, 37, 19, "Send")
StdUi:GlueTop(ReportToButton, ReportHeading, -265, -22, 'RIGHT')

local ReportToDropDownValue
ReportToDropDown.OnValueChanged = function(self, value)
    ReportToDropDownValue = value
end

ReportToButton:SetScript('OnClick',
    function()
        if ReportToDropDownValue == "GUILD" or ReportToDropDownValue == "PARTY" or ReportToDropDownValue == "OFFICER" then
            for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                if v.level == DoKeysCurrentMaxLevel then
                    SendChatMessage(k .. " Weekly Best: " .. (v["mythicplus"]["keystone"].WeeklyBest or 0), ReportToDropDownValue)
                end
            end
        end
    end
)


local ReportKeysToDropDownitems = {
    {text = "", value = ""}, -- First option
    {text = "Guild", value = "GUILD"}, -- Second option
    {text = "Party", value = "PARTY"}, -- Third option
    {text = "Officer", value = "OFFICER"}, -- Fourth option
}

local ReportKeysToDropDown = StdUi:Dropdown(ReportHeading, 200, 20, ReportKeysToDropDownitems)
StdUi:GlueBelow(ReportKeysToDropDown, ReportToDropDown, 0, 2)
StdUi:AddLabel(ReportHeading, ReportKeysToDropDown, "Report Your Keys To:", "LEFT", 155)
local ReportKeysToButton = StdUi:Button(ReportHeading, 37, 19, "Send")
StdUi:GlueTop(ReportKeysToButton, ReportHeading, -265, -42, 'RIGHT')
local ReportKeysToDropDownValue
ReportKeysToDropDown.OnValueChanged = function(self, value)
    ReportKeysToDropDownValue = value
end

ReportKeysToButton:SetScript('OnClick',
    function()
        if ReportKeysToDropDownValue == "GUILD" or ReportKeysToDropDownValue == "PARTY" or ReportKeysToDropDownValue == "OFFICER" then
            for k, v in pairs(_G.DoCharacters[realmgroupid]) do -- luacheck: ignore 423
                if v.level == DoKeysCurrentMaxLevel then
                    SendChatMessage(k .. " " .. DoKeysCreateLink(v["mythicplus"]["keystone"],"normal"), ReportKeysToDropDownValue)
                end
            end
        end
    end
)

local GuildcolumnHeaders = {
    {
        name = 'Name',
        width = 100,
        align = 'LEFT',
        defaultsort = 'dsc',
        sortnext = 3,
        index = 'name',
        format = 'string',
    },
    {
        name = 'Weekly Best',
        width = 80,
        align = 'CENTER',
        defaultsort = 'dsc',
        index = 'WeeklyBest',
        format = 'number',
    },
    {
        name = 'Key Level',
        width = 110,
        align = 'CENTER',
        defaultsort = 'dsc',
        index = 'CurrentKeyLevel',
        format = 'number',
    },
    {
        name = 'Dungeon',
        width = 160,
        align = 'CENTER',
        defaultsort = 'dsc',
        index = 'CurrentKeyInstance',
        format = 'string',
    },
    {
        name = 'Avg ILvl',
        width = 75,
        align = 'CENTER',
        defaultsort = 'dsc',
        index = 'AIL',
        format = 'number',
    },
}

local GuildHeading = StdUi:PanelWithTitle(MainFrame, 800, 160, "Guild Member's Keys", 25, 16)
StdUi:GlueTop(GuildHeading, MainFrame, 0, -285)

local Guildst = StdUi:ScrollTable(GuildHeading, GuildcolumnHeaders, 6)
StdUi:GlueTop(Guildst, GuildHeading, 0, -50)

--local AffixIcons = {
--    ["Fortified"] = "Interface\\Icons\\ability_toughness",
--    ["Tyrannical"] = "Interface\\Icons\\achievement_boss_archaedas",
--    ["Bolsering"] = "Interface\\Icons\\ability_warrior_battleshout",
--    ["Bursting"] = "Interface\\Icons\\ability_ironmaidens_whirlofblood",
--    ["Explosive"] = "Interface\\Icons\\spell_fire_felflamering_red",
--    ["Grievous"] = "Interface\\Icons\\ability_backstab",
--    ["Inspiring"] = "Interface\\Icons\\spell_holy_prayerofspirit",
--    ["Necrotic"] = "Interface\\Icons\\spell_deathknight_necroticplague",
--    ["Quaking"] = "Interface\\Icons\\spell_nature_earthquake",
--    ["Raging"] = "Interface\\Icons\\ability_warrior_focusedrage",
--    ["Sanguine"] = "Interface\\Icons\\spell_shadow_bloodboil",
--    ["Spiteful"] = "Interface\\Icons\\spell_holy_prayerofshadowprotection",
--    ["Storming"] = "Interface\\Icons\\spell_nature_cyclone",
--    ["Volcanic"] = "Interface\\Icons\\spell_shaman_lavasurge",
--    ["Tormented"] = "Interface\\Icons\\spell_animamaw_orb",
--}

local AffixHeading = StdUi:PanelWithTitle(MainFrame, 800, 90, "This Week's Affixes", 25, 16)
StdUi:GlueTop(AffixHeading, MainFrame, 0, -450)

local function GetAffixes(_,event, one, two)
    local CurrentAffixes = C_MythicPlus.GetCurrentAffixes()
    if not CurrentAffixes then return end
    if #CurrentAffixes <= 0 then return end
    local AffixOnename, AffixOnedescription, AffixOnefiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[1].id)
    local AffixOne = StdUi:SquareButton(AffixHeading, 32, 32, "")
    AffixOne:SetNormalTexture(AffixOnefiledataid)
    StdUi:GlueTop(AffixOne, AffixHeading, -48, -30)
    AffixOne:SetScript("OnEnter",function()
        GameTooltip:SetOwner(AffixOne, "ANCHOR_BOTTOM",0,-5)
        GameTooltip:SetText(AffixOnename .. ": " .. AffixOnedescription,1,1,1,1)
        GameTooltip:Show()
    end)
    AffixOne:SetScript("OnLeave",function()
        GameTooltip:Hide()
    end)
    local AffixTwoname, AffixTwodescription, AffixTwofiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[2].id)
    local AffixTwo = StdUi:SquareButton(AffixHeading, 32, 32, "")
    AffixTwo:SetNormalTexture(AffixTwofiledataid)
    StdUi:GlueTop(AffixTwo, AffixHeading, -16, -30)
    AffixTwo:SetScript("OnEnter",function()
        GameTooltip:SetOwner(AffixTwo, "ANCHOR_BOTTOM",0,-5)
        GameTooltip:SetText(AffixTwoname .. ": " .. AffixTwodescription,1,1,1,1)
        GameTooltip:Show()
    end)
    AffixTwo:SetScript("OnLeave",function()
        GameTooltip:Hide()
    end)
    local AffixThreename, AffixThreedescription, AffixThreefiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[3].id)
    local AffixThree = StdUi:SquareButton(AffixHeading, 32, 32, "")
    AffixThree:SetNormalTexture(AffixThreefiledataid)
    StdUi:GlueTop(AffixThree, AffixHeading, 16, -30)
    AffixThree:SetScript("OnEnter",function()
        GameTooltip:SetOwner(AffixThree, "ANCHOR_BOTTOM",0,-5)
        GameTooltip:SetText(AffixThreename .. ": " .. AffixThreedescription,1,1,1,1)
        GameTooltip:Show()
    end)
    AffixThree:SetScript("OnLeave",function()
        GameTooltip:Hide()
    end)
    --local AffixFourname, AffixFourdescription, AffixFourfiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[4].id)
    --local AffixFour = StdUi:SquareButton(AffixHeading, 32, 32, "")
    --AffixFour:SetNormalTexture(AffixFourfiledataid)
    --StdUi:GlueTop(AffixFour, AffixHeading, 48, -30)
    --AffixFour:SetScript("OnEnter",function()
    --    GameTooltip:SetOwner(AffixFour, "ANCHOR_BOTTOM",0,-5)
    --    GameTooltip:SetText(AffixFourname .. ": " .. AffixFourdescription,1,1,1,1)
    --    GameTooltip:Show()
    --end)
    --AffixFour:SetScript("OnLeave",function()
    --    GameTooltip:Hide()
    --end)
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
eventframe:SetScript("OnEvent", GetAffixes)

local function GetTable()
    local sttestdata = {}
    local characteri=0
    if not _G.DoCharacters or not _G.DoCharacters[realmgroupid] then return end
    for character,characterinfo in pairs(_G.DoCharacters[realmgroupid]) do
        local charname
        if _G.DoCharacters[realmgroupid][character].realm and _G.DoCharacters[realmgroupid][character].realm == realmName then
            charname = _G.DoCharacters[realmgroupid][character].name
        else
            charname = _G.DoCharacters[realmgroupid][character].name .. "-" .. _G.DoCharacters[realmgroupid][character].realm
        end
        local charlvl
        --if _G.DoCharacters[realmgroupid][character].level and _G.DoCharacters[realmgroupid][character].level ~= 60 then
        --    return
        --end
        tinsert(sttestdata,characteri+1,
            { name = charname,
              --level =_G.DoCharacters[realmgroupid][character].level,
              weeklyCount = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].weeklyCount or 0,
              WeeklyBest = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].WeeklyBest or 0),
              WeeklyBestLevelTimed = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].WeeklyBestLevelTimed or ""),
              CurrentKeyLevel = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].CurrentKeyLevel or 0,
              CurrentKeyInstance = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].CurrentKeyInstance or "",
              avgItemLevel = _G.DoCharacters[realmgroupid][character].avgItemLevel and math.floor(_G.DoCharacters[realmgroupid][character].avgItemLevel) or 0,
              currentSeasonScore = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].currentSeasonScore or 0,
              CurrentTWKeyLevel = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].CurrentTWKeyLevel or 0,
              CurrentTWKeyInstanceName = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].CurrentTWKeyInstanceName or "",
              color = RAID_CLASS_COLORS[_G.DoCharacters[realmgroupid][character].class]
            }
        )
    end
    st:SetData(sttestdata)
    st:Show()
    local guilddata = {}
    local guildi=0
    if type(_G.DoKeysGuild) =="table" then
        for RealmID,GuildName in pairs(_G.DoKeysGuild) do
            for GuildName,characterTable in pairs(GuildName) do
                for characterInfo,character in pairs(characterTable) do
                    local charname, charrealm = strsplit("-",character.name)
                    if charrealm and charrealm == realmName then
                        charname = charname
                    else
                        charname = charname .. "-" .. charrealm
                    end
                    tinsert(guilddata,guildi+1,
                        {name = charname,
                         WeeklyBest = character["mythicplus"]["keystone"].WeeklyBest or 0,
                         CurrentKeyLevel = character["mythicplus"]["keystone"].CurrentKeyLevel or 0,
                         CurrentKeyInstance = character["mythicplus"]["keystone"].CurrentKeyInstance  or "",
                         AIL = character.avgItemLevelEquipped and math.floor(character.avgItemLevelEquipped) or 0,
                         color = RAID_CLASS_COLORS[character.Class]
                        }
                    )
                    --end
                end
            end
        end
     end
    Guildst:SetData(guilddata)
    Guildst:Show()
end

local function SeasonBestsGetTable()
    --local version, build, date, tocversion = GetBuildInfo()
    local SeasonBestsstdata = {}
    local SeasonBesti = 0
    for character,characterinfo in pairs(_G.DoCharacters[realmgroupid]) do
        --local ACoE = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Ara-Kara, City of Echoes"]
        --local CoT = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["City of Threads"]
        --local TS = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["The Stonevault"]
        --local TD = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["The Dawnbreaker"]
        --local MoTS = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]
        --local TNW = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]
        --local SoB = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Siege of Boralus"]
        --local GB = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Grim Batol"]
        local one = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[1])]
        local two = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[2])]
        local three = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[3])]
        local four = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[4])]
        local five = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[5])]
        local six = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[6])]
        local seven = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[7])]
        local eight = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"][C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetMapTable()[8])]
        if _G.DoCharacters[realmgroupid][character].level == DoKeysCurrentMaxLevel
        then
            tinsert(SeasonBestsstdata,SeasonBesti+1,
                { name = _G.DoCharacters[realmgroupid][character].name,
                  one = (one and one[""] and one[""][1] or 0),
                  two = (two and two[""] and two[""][1] or 0),
                  three = (three and three[""] and three[""][1] or 0),
                  four = (four and four[""] and four[""][1] or 0),
                  five = (five and five[""]and five[""][1] or 0),
                  six = (six and six[""] and six[""][1] or 0),
                  seven = (seven and seven[""] and seven[""][1] or 0),
                  eight = (eight and eight[""] and eight[""][1] or 0),
                  color = RAID_CLASS_COLORS[_G.DoCharacters[realmgroupid][character].class]
                }
            )
        end
    end
    --end

    SeasonBestsst:SetData(SeasonBestsstdata)
    SeasonBestsst:Show()
end

local addon = LibStub("AceAddon-3.0"):NewAddon("DoKeys", "AceConsole-3.0")

function DoKeysOnAddonCompartmentClick(_, button)
    if button == "LeftButton" then
        local alt_key = IsAltKeyDown()
        local shift_key = IsShiftKeyDown()
        local control_key = IsControlKeyDown()
        if shift_key then
        elseif alt_key then
        elseif control_key then
        else
            if MainFrame:IsShown() then
                MainFrame:Hide()
            else
                GetTable()
                --UpdateNextRewardLevel()
                --GetAffixes()
                MainFrame:Show()
            end
        end
    end
    if button == "RightButton" then
        if SeasonBestsFrame:IsShown() then
            SeasonBestsFrame:Hide()
        else
            SeasonBestsGetTable()
            SeasonBestsFrame:Show()
        end
    end
end

function addon:OnInitialize()
    local defaults = {
        profile = {
            chat = {
                respondkeys = false,
            },
        },
        global = {
            dorework = true
        }
    }
    self.db = LibStub("AceDB-3.0"):New("DoKeysDB", defaults, true)
    self:RegisterChatCommand("dokeys", "OpenUI")
    if self.db.global.dorework then
        if type(_G.DoCharacters) == "table" then
            wipe(_G.DoCharacters)
        end
        if type(_G.DoKeysGuild) == "table" then
            wipe(_G.DoKeysGuild)
        end
        if type(_G.DoKeysBNETFriendsKeys) == "table" then
            wipe(_G.DoKeysBNETFriendsKeys)
        end
        self.db.global.dorework = false
    end
    addon:SetupOptions()
end

function addon:OpenUI(one, two, three, four)
    if one == "options" or one == "o" then
        InterfaceOptionsFrame_OpenToCategory("DoKeys")
        InterfaceOptionsFrame_OpenToCategory("DoKeys")
    end
    if one == "" then
        if MainFrame:IsShown() then
            MainFrame:Hide()
        else
            GetTable()
            --UpdateNextRewardLevel()
            --GetAffixes()
            MainFrame:Show()
        end
    end
end

function addon:SetupOptions()
    addon.optionspanel = CreateFrame( "Frame", "DoKeysOptionsPanel", UIParent )
    addon.optionspanel.name = "DoKeys"
    --InterfaceOptions_AddCategory(DoKeysOptionsPanel)
	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(DoKeysOptionsPanel)
	else
		local category, layout = Settings.RegisterCanvasLayoutCategory(DoKeysOptionsPanel, DoKeysOptionsPanel.name);
		Settings.RegisterAddOnCategory(category);
		addon.settingsCategory = category
	end

    local whoDatButton = CreateFrame("CheckButton", "DoKeysOptionswhoDatCheck", DoKeysOptionsPanel, "ChatConfigCheckButtonTemplate")
    whoDatButton:SetPoint("TOPLEFT", 25, -10)
    whoDatButton:SetChecked(_G.DoCharacters and _G.DoCharacters.whodat or false)
    DoKeysOptionswhoDatCheck.Text:SetText("Print to Chat LFD Invite Details")
    whoDatButton.tooltip = "Print to Chat LFD Invite Details."
    whoDatButton:SetScript("OnClick",
        function()
            if _G.DoCharacters.whodat then
                _G.DoCharacters.whodat = false
            else
                _G.DoCharacters.whodat = true
            end
        end
    )

end
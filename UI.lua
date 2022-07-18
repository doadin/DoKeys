local LibStub = _G.LibStub
local realm = _G.GetRealmName()
local CreateFrame = _G.CreateFrame
local SendChatMessage = _G.SendChatMessage
local GetAddOnMetadata = _G.GetAddOnMetadata
local DoKeysCurrentMaxLevel = _G.GetMaxLevelForExpansionLevel(_G.GetMaximumExpansionLevel())
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

local MainFrame = StdUi:Window(UIParent, 800, 550, 'DoKeys')
MainFrame:SetPoint('CENTER')
MainFrame:Hide()

local SeasonBestsFrame = StdUi:Window(UIParent, 1100, 300, "DoKeys Season Bests")
SeasonBestsFrame:SetPoint('CENTER')
SeasonBestsFrame:Hide()

local SeasonBestsHeading = StdUi:PanelWithTitle(SeasonBestsFrame, 1100, 250, "Player's Season Bests Tyrannical/Fortified", 25, 16)
StdUi:GlueTop(SeasonBestsHeading, SeasonBestsFrame, 0, -40)

local PlayerHeading = StdUi:PanelWithTitle(MainFrame, 800, 160, "Player's Keys", 25, 16)
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
    local WB = _G.DoCharacters[realmgroupid][_G.UnitName("player") .. "-" .. GetRealmName()]["mythicplus"]["keystone"].WeeklyBest or 1
    local hasSeasonData, nextMythicPlusLevel, itemLevel = C_WeeklyRewards.GetNextMythicPlusIncrease(WB)
    if not C_MythicPlus.IsWeeklyRewardAvailable() then
        if nextMythicPlusLevel and itemLevel then
            NextRewardLevel = StdUi:Label(MainFrame,(_G.UnitName("player") .. "'s " .. "weekly reward from M+ increases at level " .. tostring(nextMythicPlusLevel) .. " to item level " .. tostring(itemLevel)))
            StdUi:GlueTop(NextRewardLevel, MainFrame, 0, -30)
        else
            NextRewardLevel = StdUi:Label(MainFrame,(_G.UnitName("player") .. "'s " .. "weekly reward from M+ is at max!"))
            StdUi:GlueTop(NextRewardLevel, MainFrame, 0, -30)
        end
    end
end

local UpdateRewardFrame = CreateFrame("Frame")
UpdateRewardFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
UpdateRewardFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
UpdateRewardFrame:SetScript("OnEvent", UpdateReward)

local columnHeaders
do
    local numDayEvents = C_Calendar.GetNumDayEvents(0, C_DateAndTime.GetCurrentCalendarTime().monthDay)
    local found = false
    for i=1,numDayEvents do
        local info = C_Calendar.GetHolidayInfo(0,C_DateAndTime.GetCurrentCalendarTime().monthDay,i)
        if info.name == "Timewalking Dungeon Event" then
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
            {
                name = 'Level',
                width = 60,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'level',
                format = 'string',
            },
            {
                name = 'Weekly Best',
                width = 85,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'WeeklyBest',
                format = 'string',
            },
            {
                name = 'Key Level',
                width = 70,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'CurrentKeyLevel',
            },
            {
                name = 'Key Instance',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'CurrentKeyInstance',
                format = 'string',
            },
            {
                name = 'Average Item Level',
                width = 130,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'avgItemLevel',
                format = 'string',
            },
            {
                name = 'M+ Score',
                width = 70,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'currentSeasonScore',
                format = 'string',
            },
            {
                name = 'TW Key Level',
                width = 90,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'CurrentTWKeyLevel',
                format = 'string',
            },
            {
                name = 'TW Key Instance',
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
            {
                name = 'Level',
                width = 60,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'level',
                format = 'string',
            },
            {
                name = 'Weekly Best',
                width = 85,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'WeeklyBest',
                format = 'string',
            },
            {
                name = 'Key Level',
                width = 70,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'CurrentKeyLevel',
            },
            {
                name = 'Key Instance',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'CurrentKeyInstance',
                format = 'string',
            },
            {
                name = 'Average Item Level',
                width = 130,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'avgItemLevel',
                format = 'string',
            },
            {
                name = 'M+ Score',
                width = 70,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'currentSeasonScore',
                format = 'string',
            },
        }
    end
end

local st = StdUi:ScrollTable(PlayerHeading, columnHeaders, 6)
StdUi:GlueTop(st, PlayerHeading, 0, -50)

local SeasonBestHeaders
do
    local version, build, date, tocversion = GetBuildInfo()
    if tocversion <= 90207 then
        SeasonBestHeaders = {
            {
                name = 'Name',
                width = 50,
                align = 'LEFT',
                defaultsort = 'dsc',
                index = 'name',
                --format = 'string',
            },
            {
                name = 'DoS',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'DoS',
                --format = 'string',
            },
            {
                name = 'HoA',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'HoA',
                --format = 'string',
            },
            {
                name = 'MoTS',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'MoTS',
                --format = 'string',
            },
            {
                name = 'PF',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'PF',
                --format = 'string',
            },
            {
                name = 'SD',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'SD',
                --format = 'string',
            },
            {
                name = 'SoA',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'SoA',
                --format = 'string',
            },
            {
                name = 'NW',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'NW',
                --format = 'string',
            },
            {
                name = 'ToP',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'ToP',
                --format = 'string',
            },
            {
                name = 'TazSoW',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'TSoW',
                --format = 'string',
            },
            {
                name = 'TazSG',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'TSG',
                --format = 'string',
            },
        }
    else
        SeasonBestHeaders = {
            {
                name = 'Name',
                width = 50,
                align = 'LEFT',
                defaultsort = 'dsc',
                index = 'name',
                --format = 'string',
            },
            {
                name = 'ID',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'ID',
                --format = 'string',
            },
            {
                name = 'RtKU',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'RtKU',
                --format = 'string',
            },
            {
                name = 'RtKL',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'RtKL',
                --format = 'string',
            },
            {
                name = 'OMW',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'OMW',
                --format = 'string',
            },
            {
                name = 'OMJ',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'OMJ',
                --format = 'string',
            },
            {
                name = 'GD',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'GD',
                --format = 'string',
            },
            {
                name = 'TazSoW',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'TSoW',
                --format = 'string',
            },
            {
                name = 'TazSG',
                width = 100,
                align = 'RIGHT',
                defaultsort = 'dsc',
                index = 'TSG',
                --format = 'string',
            },
        }
    end
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

local ReportToButton = StdUi:Button(ReportHeading, 35, 20, "Send")
StdUi:GlueTop(ReportToButton, ReportHeading, -265, -20, 'RIGHT')

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
local ReportKeysToButton = StdUi:Button(ReportHeading, 35, 20, "Send")
StdUi:GlueTop(ReportKeysToButton, ReportHeading, -265, -40, 'RIGHT')
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
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'WeeklyBest',
        format = 'number',
    },
    {
        name = 'CurrentKeyLevel',
        width = 110,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'CurrentKeyLevel',
        format = 'number',
    },
    {
        name = 'CurrentKeyInstance',
        width = 130,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'CurrentKeyInstance',
        format = 'string',
    },
}

local GuildHeading = StdUi:PanelWithTitle(MainFrame, 800, 160, "Guild Member's Keys", 25, 16)
StdUi:GlueTop(GuildHeading, MainFrame, 0, -285)

local Guildst = StdUi:ScrollTable(GuildHeading, GuildcolumnHeaders, 6)
StdUi:GlueTop(Guildst, GuildHeading, 0, -50)

local AffixIcons = {
    ["Fortified"] = "Interface\\Icons\\ability_toughness",
    ["Tyrannical"] = "Interface\\Icons\\achievement_boss_archaedas",
    ["Bolsering"] = "Interface\\Icons\\ability_warrior_battleshout",
    ["Bursting"] = "Interface\\Icons\\ability_ironmaidens_whirlofblood",
    ["Explosive"] = "Interface\\Icons\\spell_fire_felflamering_red",
    ["Grievous"] = "Interface\\Icons\\ability_backstab",
    ["Inspiring"] = "Interface\\Icons\\spell_holy_prayerofspirit",
    ["Necrotic"] = "Interface\\Icons\\spell_deathknight_necroticplague",
    ["Quaking"] = "Interface\\Icons\\spell_nature_earthquake",
    ["Raging"] = "Interface\\Icons\\ability_warrior_focusedrage",
    ["Sanguine"] = "Interface\\Icons\\spell_shadow_bloodboil",
    ["Spiteful"] = "Interface\\Icons\\spell_holy_prayerofshadowprotection",
    ["Storming"] = "Interface\\Icons\\spell_nature_cyclone",
    ["Volcanic"] = "Interface\\Icons\\spell_shaman_lavasurge",
    ["Tormented"] = "Interface\\Icons\\spell_animamaw_orb",
}

local AffixHeading = StdUi:PanelWithTitle(MainFrame, 800, 90, "This Weeks Affixs", 25, 16)
StdUi:GlueTop(AffixHeading, MainFrame, 0, -450)

local function GetAffixes(_,event, one, two)
    local CurrentAffixes = C_MythicPlus.GetCurrentAffixes()
    if not CurrentAffixes then C_Timer.After(1, GetAffixes) return end
    local AffixOnename, AffixOnedescription, AffixOnefiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[1].id)
    local AffixOne = StdUi:SquareButton(AffixHeading, 32, 32, "")
    AffixOne:SetNormalTexture(AffixOnefiledataid)
    StdUi:GlueTop(AffixOne, AffixHeading, -70, -30)
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
    StdUi:GlueTop(AffixTwo, AffixHeading, -35, -30)
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
    StdUi:GlueTop(AffixThree, AffixHeading, 5, -30)
    AffixThree:SetScript("OnEnter",function()
        GameTooltip:SetOwner(AffixThree, "ANCHOR_BOTTOM",0,-5)
        GameTooltip:SetText(AffixThreename .. ": " .. AffixThreedescription,1,1,1,1)
        GameTooltip:Show()
    end)
    AffixThree:SetScript("OnLeave",function()
        GameTooltip:Hide()
    end)
    local AffixFourname, AffixFourdescription, AffixFourfiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[4].id)
    local AffixFour = StdUi:SquareButton(AffixHeading, 32, 32, "")
    AffixFour:SetNormalTexture(AffixFourfiledataid)
    StdUi:GlueTop(AffixFour, AffixHeading, 40, -30)
    AffixFour:SetScript("OnEnter",function()
        GameTooltip:SetOwner(AffixFour, "ANCHOR_BOTTOM",0,-5)
        GameTooltip:SetText(AffixFourname .. ": " .. AffixFourdescription,1,1,1,1)
        GameTooltip:Show()
    end)
    AffixFour:SetScript("OnLeave",function()
        GameTooltip:Hide()
    end)
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
eventframe:SetScript("OnEvent", GetAffixes)

local function GetTable()
    local sttestdata = {}
    local characteri=0
    for character,characterinfo in pairs(_G.DoCharacters[realmgroupid]) do
        tinsert(sttestdata,characteri+1,
            { name = _G.DoCharacters[realmgroupid][character].name .. "-" .. _G.DoCharacters[realmgroupid][character].realm,
              level =_G.DoCharacters[realmgroupid][character].level,
              WeeklyBest = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].WeeklyBest or 0) .. " " .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].WeeklyBestLevelTimed or ""),
              CurrentKeyLevel = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].CurrentKeyLevel or 0,
              CurrentKeyInstance = _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"].CurrentKeyInstance or "",
              avgItemLevel = _G.DoCharacters[realmgroupid][character].avgItemLevel or 0,
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
                    --if type(character.name) == "string" then
                        tinsert(guilddata,guildi+1,
                            {name = character.name,
                             WeeklyBest = character["mythicplus"]["keystone"].WeeklyBest or 0,
                             CurrentKeyLevel = character["mythicplus"]["keystone"].CurrentKeyLevel or 0,
                             CurrentKeyInstance = character["mythicplus"]["keystone"].CurrentKeyInstance  or "",
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
    local version, build, date, tocversion = GetBuildInfo()
    local SeasonBestsstdata = {}
    local SeasonBesti = 0
    if tocversion <= 90207 then
        for character,characterinfo in pairs(_G.DoCharacters[realmgroupid]) do
            if _G.DoCharacters[realmgroupid][character].level == DoKeysCurrentMaxLevel
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: Streets of Wonder"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: So'leah's Gambit"]
            then
                tinsert(SeasonBestsstdata,SeasonBesti+1,
                    { name = _G.DoCharacters[realmgroupid][character].name,
                      DoS = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Fortified"][1] or 0) ,
                      HoA = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Fortified"][1] or 0) ,
                      MoTS = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Fortified"][1] or 0) ,
                      PF = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Fortified"][1] or 0) ,
                      SD = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Fortified"][1] or 0) ,
                      SoA = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Fortified"][1] or 0) ,
                      NW = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Fortified"][1] or 0) ,
                      ToP = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Fortified"][1] or 0) ,
                      TSoW = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: Streets of Wonder"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: Streets of Wonder"]["Fortified"][1] or 0) ,
                      TSG = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: So'leah's Gambit"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: So'leah's Gambit"]["Fortified"][1] or 0) ,
                      color = RAID_CLASS_COLORS[_G.DoCharacters[realmgroupid][character].class]
                    }
                )
            end
        end
    else
        for character,characterinfo in pairs(_G.DoCharacters[realmgroupid]) do
            if _G.DoCharacters[realmgroupid][character].level == DoKeysCurrentMaxLevel
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Iron Docks"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Return to Karazhan: Upper"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Return to Karazhan: Lower"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Operation: Mechagon - Workshop"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Operation: Mechagon - Junkyard"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Grimrail Depot"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: Streets of Wonder"]
            and _G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: So'leah's Gambit"]
            then
                tinsert(SeasonBestsstdata,SeasonBesti+1,
                    { name = _G.DoCharacters[realmgroupid][character].name,
                      ID = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Iron Docks"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Iron Docks"]["Fortified"][1] or 0) ,
                      RtKU = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Return to Karazhan: Upper"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Return to Karazhan: Upper"]["Fortified"][1] or 0) ,
                      RtKL = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Return to Karazhan: Lower"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Return to Karazhan: Lower"]["Fortified"][1] or 0) ,
                      OMW = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Operation: Mechagon - Workshop"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Operation: Mechagon - Workshop"]["Fortified"][1] or 0) ,
                      OMJ = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Operation: Mechagon - Junkyard"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Operation: Mechagon - Junkyard"]["Fortified"][1] or 0) ,
                      GD = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Grimrail Depot"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Grimrail Depot"]["Fortified"][1] or 0) ,
                      TSoW = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: Streets of Wonder"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: Streets of Wonder"]["Fortified"][1] or 0) ,
                      TSG = (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: So'leah's Gambit"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmgroupid][character]["mythicplus"]["keystone"]["seasonbests"]["Tazavesh: So'leah's Gambit"]["Fortified"][1] or 0) ,
                      color = RAID_CLASS_COLORS[_G.DoCharacters[realmgroupid][character].class]
                    }
                )
            end
        end
    end

    SeasonBestsst:SetData(SeasonBestsstdata)
    SeasonBestsst:Show()
end

local addon = LibStub("AceAddon-3.0"):NewAddon("DoKeys", "AceConsole-3.0")
local DoKeysLDB = LibStub("LibDataBroker-1.1"):NewDataObject("DoKeysLDB", {
type = "launcher",
text = "DoKeys",
icon = "Interface\\Icons\\spell_nature_moonkey",
OnTooltipShow = function(tooltip)
    tooltip:SetText("DoKeys")
    tooltip:AddLine("Left Click To Show Your Character/Guild Info", 1, 1, 1)
    tooltip:AddLine("Right Click To Show Your Characters Season Bests", 1, 1, 1)
    tooltip:Show()
end,
OnClick = function(clickedframe, button)
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
                            UpdateNextRewardLevel()
                            GetAffixes()
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
          end,
    }
)
local LibDBIcon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
    local defaults = {
        profile = {
            minimap = {
                 hide = false,
            },
            chat = {
                respondkeys = false,
            },
        },
        global = {
            dorework = true
        }
    }
    self.db = LibStub("AceDB-3.0"):New("DoKeysDB", defaults, true)
    LibDBIcon:Register("DoKeysIcon", DoKeysLDB, self.db.profile.minimap)
    self:RegisterChatCommand("dokeys", "OpenUI")
    if self.db.profile.minimap.hide then
        LibDBIcon:Hide("DoKeysIcon")
    else
        LibDBIcon:Show("DoKeysIcon")
    end
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
    if one == "toggle minimap" or one == "tm" then
        if self.db.profile.minimap.hide then
            LibDBIcon:Show("DoKeysIcon")
            self.db.profile.minimap.hide = false
        else
            LibDBIcon:Hide("DoKeysIcon")
            self.db.profile.minimap.hide = true
        end
    end
    if one == "options" or one == "o" then
        InterfaceOptionsFrame_OpenToCategory("DoKeys")
        InterfaceOptionsFrame_OpenToCategory("DoKeys")
    end
    if one == "" then
        if MainFrame:IsShown() then
            MainFrame:Hide()
        else
            GetTable()
            UpdateNextRewardLevel()
            GetAffixes()
            MainFrame:Show()
        end
    end
end

function addon:SetupOptions()
    addon.optionspanel = CreateFrame( "Frame", "DoKeysOptionsPanel", UIParent )
    addon.optionspanel.name = "DoKeys"
    InterfaceOptions_AddCategory(DoKeysOptionsPanel)
    local myCheckButton = CreateFrame("CheckButton", "DoKeysOptionsMinimapCheck", DoKeysOptionsPanel, "ChatConfigCheckButtonTemplate")
    myCheckButton:SetPoint("TOPLEFT", 25, -10)
    myCheckButton:SetChecked(not self.db.profile.minimap.hide)
    DoKeysOptionsMinimapCheck.Text:SetText("Show Minimap")
    myCheckButton.tooltip = "Enable or disable showing minimap button."
    myCheckButton:SetScript("OnClick",
        function()
            if self.db.profile.minimap.hide then
                LibDBIcon:Show("DoKeysIcon")
                self.db.profile.minimap.hide = false
            else
                LibDBIcon:Hide("DoKeysIcon")
                self.db.profile.minimap.hide = true
            end
        end
    )
end
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

local StdUi = LibStub("StdUi")

local MainFrame = StdUi:Window(UIParent, 800, 550, 'DoKeys')
MainFrame:SetPoint('CENTER')
MainFrame:Hide()

local SeasonBestsFrame = StdUi:Window(UIParent, 900, 300, "DoKeys Season Bests")
SeasonBestsFrame:SetPoint('CENTER')
SeasonBestsFrame:Hide()

local SeasonBestsHeading = StdUi:PanelWithTitle(SeasonBestsFrame, 900, 250, "Player's Season Bests", 25, 16)
StdUi:GlueTop(SeasonBestsHeading, SeasonBestsFrame, 0, -40)

local PlayerHeading = StdUi:PanelWithTitle(MainFrame, 800, 160, "Player's Keys", 25, 16)
StdUi:GlueTop(PlayerHeading, MainFrame, 0, -40)

local function UpdateReward()
    local Rewardheading
    if C_MythicPlus.IsWeeklyRewardAvailable() then
        Rewardheading = StdUi:Create("Heading")
        Rewardheading:SetText("Weekly Reward Available, Good Luck On your Loot!")
        MainFrame:AddChild(Rewardheading)
    else
        if Rewardheading then
            Rewardheading:Hide()
        end
    end
end

local UpdateRewardFrame = CreateFrame("Frame")
UpdateRewardFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
UpdateRewardFrame:SetScript("OnEvent", UpdateReward)

local columnHeaders = {
    {
        name = 'Name',
        width = 50,
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

local st = StdUi:ScrollTable(PlayerHeading, columnHeaders, 6)
StdUi:GlueTop(st, PlayerHeading, 0, -50)

local SeasonBestHeaders = {
    {
        name = 'Name',
        width = 50,
        align = 'LEFT',
        defaultsort = 'dsc',
        index = 'name',
        --format = 'string',
    },
    {
        name = 'DoS Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'DoS',
        --format = 'string',
    },
    {
        name = 'HoA Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'HoA',
        --format = 'string',
    },
    {
        name = 'MoTS Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'MoTS',
        --format = 'string',
    },
    {
        name = 'PF Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'PF',
        --format = 'string',
    },
    {
        name = 'SD Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'SD',
        --format = 'string',
    },
    {
        name = 'SoA Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'SoA',
        --format = 'string',
    },
    {
        name = 'NW Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'NW',
        --format = 'string',
    },
    {
        name = 'ToP Tyran/Fort',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        index = 'ToP',
        --format = 'string',
    },
}

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
            for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                if v.level == DoKeysCurrentMaxLevel then
                    SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, ReportToDropDownValue)
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
--ReportKeysToDropDown:SetPoint('CENTER')
StdUi:GlueBelow(ReportKeysToDropDown, ReportToDropDown, 0, 2)

StdUi:AddLabel(ReportHeading, ReportKeysToDropDown, "Report Your Keys To:", "LEFT", 155)

local ReportKeysToButton = StdUi:Button(ReportHeading, 35, 20, "Send")
StdUi:GlueTop(ReportKeysToButton, ReportHeading, -265, -40, 'RIGHT')

local ReportKeysToDropDownValue
ReportKeysToDropDown.OnValueChanged = function(self, value)
    ReportKeysToDropDownValue = value
end

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
    if keytype == "normal" then
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
    if keytype == "tw" then
	    if type(data) == "table" then
            if not data.CurrentTWKeyLevel then return end
            if tonumber(data.CurrentTWKeyLevel) <= 3 then
	            link = string.format(
	            	'|cffa335ee|Hkeystone:187786:%d:%d:%d|h[Keystone: %s (%d)]|h|r',
	            	data.CurrentTWKeyID or 0, --data.mapId
	            	data.CurrentTWKeyLevel, --data.level
                    _G.DoCharacters.CurrentTWKeyAffix1 or 0,
	            	data.CurrentTWKeyInstanceName, --data.mapNamePlain or data.mapName
	            	data.CurrentTWKeyLevel --data.level
	            )
            end
            if tonumber(data.CurrentTWKeyLevel)>= 4 and data.CurrentKeyLevel <= 6 then
	            link = string.format(
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
	            link = string.format(
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
	            link = string.format(
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
	    	link = "None"
	    end
    end
	return link
end

ReportKeysToButton:SetScript('OnClick',
    function()
        if ReportKeysToDropDownValue == "GUILD" or ReportKeysToDropDownValue == "PARTY" or ReportKeysToDropDownValue == "OFFICER" then
            for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
                if v.level == DoKeysCurrentMaxLevel then
                    SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"],"normal"), ReportKeysToDropDownValue)
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
    for character,characterinfo in pairs(_G.DoCharacters[realmName]) do
        tinsert(sttestdata,characteri+1,
            { name = _G.DoCharacters[realmName][character].name,
              level =_G.DoCharacters[realmName][character].level,
              WeeklyBest = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].WeeklyBest or 0,
              CurrentKeyLevel = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentKeyLevel or 0,
              CurrentKeyInstance = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentKeyInstance or "",
              avgItemLevel = _G.DoCharacters[realmName][character].avgItemLevel or 0,
              currentSeasonScore = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].currentSeasonScore or 0,
              CurrentTWKeyLevel = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentTWKeyLevel or 0,
              CurrentTWKeyInstanceName = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentTWKeyInstanceName or "",
              color = RAID_CLASS_COLORS[_G.DoCharacters[realmName][character].class]
            }
        )
    end
    st:SetData(sttestdata)
    st:Show()

    local guilddata = {}
    local guildi=0
    if type(_G.DoKeysGuild) =="table" then
        for GuildName,NameRealm in pairs(_G.DoKeysGuild) do
            for character in pairs(NameRealm) do
                tinsert(guilddata,guildi+1,
                    { name = _G.DoKeysGuild[GuildName][character].name,
                      WeeklyBest = _G.DoKeysGuild[GuildName][character]["mythicplus"]["keystone"].WeeklyBest or 0,
                      CurrentKeyLevel = _G.DoKeysGuild[GuildName][character]["mythicplus"]["keystone"].CurrentKeyLevel or 0,
                      CurrentKeyInstance = _G.DoKeysGuild[GuildName][character]["mythicplus"]["keystone"].CurrentKeyInstance  or "",
                      color = RAID_CLASS_COLORS[_G.DoKeysGuild[GuildName][character].Class]
                    }
                )
            end
        end
    end

    Guildst:SetData(guilddata)
    Guildst:Show()
end

local function SeasonBestsGetTable()
    local SeasonBestsstdata = {}
    local SeasonBesti = 0
    for character,characterinfo in pairs(_G.DoCharacters[realmName]) do

        if _G.DoCharacters[realmName][character].level == DoKeysCurrentMaxLevel and _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"] then
            tinsert(SeasonBestsstdata,SeasonBesti+1,
                { name = _G.DoCharacters[realmName][character].name,
                  DoS = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Fortified"][1] or 0) ,
                  HoA = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Fortified"][1] or 0) ,
                  MoTS = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Fortified"][1] or 0) ,
                  PF = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Fortified"][1] or 0) ,
                  SD = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Fortified"][1] or 0) ,
                  SoA = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Fortified"][1] or 0) ,
                  NW = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Fortified"][1] or 0) ,
                  ToP = (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Tyrannical"][1] or 0) .. "/" .. (_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Fortified"][1] or 0) ,
                  color = RAID_CLASS_COLORS[_G.DoCharacters[realmName][character].class]
                }
            )
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
    }
    self.db = LibStub("AceDB-3.0"):New("DoKeysDB", defaults, true)
    LibDBIcon:Register("DoKeysIcon", DoKeysLDB, self.db.profile.minimap)
    self:RegisterChatCommand("dokeys", "OpenUI")
    if self.db.profile.minimap.hide then
        LibDBIcon:Hide("DoKeysIcon")
    else
        LibDBIcon:Show("DoKeysIcon")
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
            MainFrame:Show()
        end
    end
end

function addon:SetupOptions()
    addon.optionspanel = CreateFrame( "Frame", "DoKeysOptionsPanel", UIParent )
    -- Register in the Interface Addon Options GUI
    -- Set the name for the Category for the Options Panel
    addon.optionspanel.name = "DoKeys"
    -- Add the panel to the Interface Options
    InterfaceOptions_AddCategory(DoKeysOptionsPanel)

    ---- Make a child panel
    --addon.optionspanel.childpanel = CreateFrame( "Frame", "MyAddonChild", addon.optionspanel)
    --addon.optionspanel.childpanel.name = "General"
    ---- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
    --addon.optionspanel.childpanel.parent = addon.optionspanel.name
    ---- Add the child to the Interface Options
    --InterfaceOptions_AddCategory(addon.optionspanel.childpanel)

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

    --local myCheckButtonTwo = CreateFrame("CheckButton", "DoKeysOptionsRespondKeysChatCheck", DoKeysOptionsPanel, "ChatConfigCheckButtonTemplate")
    --myCheckButtonTwo:SetPoint("TOPLEFT", 25, -30)
    --myCheckButtonTwo:SetChecked(self.db.profile.chat.respondkeys)
    --DoKeysOptionsRespondKeysChatCheck.Text:SetText("Respond to !keys in chat")
    --myCheckButtonTwo.tooltip = "Enable or disable showing minimap button."
    --myCheckButtonTwo:SetScript("OnClick",
    --  function()
    --    if self.db.profile.chat.respondkeys then
    --        self.db.profile.chat.respondkeys = false
    --    else
    --        self.db.profile.chat.respondkeys = true
    --    end
    --  end
    --)
end
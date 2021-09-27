local realm = _G.GetRealmName()
local CreateFrame = _G.CreateFrame
local SendChatMessage = _G.SendChatMessage
local GetAddOnMetadata = _G.GetAddOnMetadata
local DoKeysCurrentMaxLevel = _G.GetMaxLevelForExpansionLevel(_G.GetMaximumExpansionLevel())

local AceGUI = LibStub("AceGUI-3.0")
-- Create a container frame
local MainFrame = AceGUI:Create("Frame")
--MainFrame:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
MainFrame:SetTitle("DoKeys")
MainFrame:SetStatusText("Dokeys" .. " " .. GetAddOnMetadata("DoKeys", "Version") )
--MainFrame:SetLayout("Fill")  Makes everything in main frame fill the frame
MainFrame:EnableResize(false)
MainFrame:Hide()

-- Create a container frame
local SeasonBestsFrame = AceGUI:Create("Frame")
--MainFrame:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
SeasonBestsFrame:SetTitle("DoKeys Season Bests")
SeasonBestsFrame:SetStatusText("Dokeys" .. " " .. GetAddOnMetadata("DoKeys", "Version") )
--MainFrame:SetLayout("Fill")  Makes everything in main frame fill the frame
SeasonBestsFrame:EnableResize(false)
SeasonBestsFrame:SetWidth(850)
SeasonBestsFrame:SetHeight(300)
SeasonBestsFrame:Hide()

local SeasonBestsHeading = AceGUI:Create("InlineGroup")
SeasonBestsHeading:SetWidth(800)
SeasonBestsHeading:SetHeight(900)
--PlayerHeading:SetFullWidth(true)
SeasonBestsHeading:SetTitle("Player's Season Bests")
SeasonBestsFrame:AddChild(SeasonBestsHeading)

--local SeasonBestsHeading = AceGUI:Create("Label")
----SeasonBestsHeading:SetWidth(800)
----SeasonBestsHeading:SetHeight(900)
----PlayerHeading:SetFullWidth(true)
--SeasonBestsHeading:SetText("Player's Season Bests")
--SeasonBestsFrame:AddChild(SeasonBestsHeading)

local PlayerHeading = AceGUI:Create("InlineGroup")
--PlayerHeading:SetFullWidth(true)
PlayerHeading:SetTitle("Player's Keys")
MainFrame:AddChild(PlayerHeading)

local function UpdateReward()
    local Rewardheading
    if C_MythicPlus.IsWeeklyRewardAvailable() then
        Rewardheading = AceGUI:Create("Heading")
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

--local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
--scrollcontainer:SetFullWidth(true)
----scrollcontainer:SetFullHeight(true) -- probably?
--scrollcontainer:SetLayout("Fill") -- important!
--MainFrame:AddChild(scrollcontainer)

local columnHeaders = {
    {
        name = 'Name',
        width = 50,
        align = 'LEFT',
        defaultsort = 'dsc',
        sortnext = 3,
        --index = 'name',
    },
    {
        name = 'Level',
        width = 60,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'level',
    },
    {
        name = 'Weekly Best',
        width = 80,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'CurrentKeyLevel',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'CurrentKeyInstance',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'Average Item Level',
        width = 120,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'avgItemLevel',
    },
    {
        name = 'Current Season Score',
        width = 120,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'avgItemLevel',
    },
}

local st = AceGUI:Create('lib-st')
st:CreateST(columnHeaders,10,10)
PlayerHeading:AddChild(st)

local SeasonBestHeaders = {
    {
        name = 'Name',
        width = 50,
        align = 'LEFT',
        defaultsort = 'dsc',
        sortnext = 3,
        --index = 'name',
    },
    {
        name = 'DoS Tyran/Fort',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'level',
    },
    {
        name = 'HoA Tyran/Fort',
        width = 80,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'MoTS Tyran/Fort',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'PF Tyran/Fort',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'SD Tyran/Fort',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'avgItemLevel',
    },
    {
        name = 'SoA Tyran/Fort',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'avgItemLevel',
    },
    {
        name = 'NW Tyran/Fort',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'avgItemLevel',
    },
    {
        name = 'ToP Tyran/Fort',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'avgItemLevel',
    },
}

local SeasonBestsst = AceGUI:Create('lib-st')
SeasonBestsst:CreateST(SeasonBestHeaders,10,10)
SeasonBestsFrame:AddChild(SeasonBestsst)

local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
scrollcontainer:SetFullWidth(true)
--scrollcontainer:SetFullHeight(true) -- probably?
scrollcontainer:SetLayout("Flow") -- important!
MainFrame:AddChild(scrollcontainer)

local ReportToDropDownValue
local function GetReportToDropDownValue(this, event, item)
    ReportToDropDownValue = item
end

local ReportToDropDown = AceGUI:Create("Dropdown")
ReportToDropDown:SetWidth(200)
ReportToDropDown:SetHeight(25)
ReportToDropDown:SetList(
    {
        [""] = "",
        ["GUILD"] = "Guild",
        ["PARTY"] = "Party",
        ["OFFICER"] = "Officer",
    }
)
ReportToDropDown:SetCallback("OnValueChanged", GetReportToDropDownValue)
scrollcontainer:AddChild(ReportToDropDown)
ReportToDropDown:SetPoint('LEFT', "$parent", 'LEFT', 0, 0)

local ReportWeeklyBestButton = AceGUI:Create("Button")
ReportWeeklyBestButton:SetWidth(140)
ReportWeeklyBestButton:SetHeight(20)
ReportWeeklyBestButton:SetText("Report Weekly Best")
ReportWeeklyBestButton:SetCallback(
    "OnClick",
    function()
        for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
            if v.level == DoKeysCurrentMaxLevel then
                SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, ReportToDropDownValue)
            end
        end
        --print(ReportToDropDownValue)
    end
)
scrollcontainer:AddChild(ReportWeeklyBestButton)
ReportWeeklyBestButton:SetPoint('RIGHT', "$parent", 'RIGHT', 0, 0)

local function CreateLink(data)
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
	if type(data) == "table" then
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
	else
		link = "None"
	end
	return link
end

local ReportKeyButton = AceGUI:Create("Button")
ReportKeyButton:SetWidth(140)
ReportKeyButton:SetHeight(20)
ReportKeyButton:SetText("Report Keys")
ReportKeyButton:SetCallback(
    "OnClick",
    function()
        for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
            if v.level == DoKeysCurrentMaxLevel then
                SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"]), ReportToDropDownValue)
            end
        end
        --print(ReportToDropDownValue)
    end
)
scrollcontainer:AddChild(ReportKeyButton)
ReportKeyButton:SetPoint('RIGHT', "$parent", 'RIGHT', 0, 0)

--local Guildscrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
--Guildscrollcontainer:SetFullWidth(true)
--Guildscrollcontainer:SetFullHeight(true) -- probably?
--Guildscrollcontainer:SetLayout("Fill") -- important!
--MainFrame:AddChild(Guildscrollcontainer)

local GuildcolumnHeaders = {
    {
        name = 'Name',
        width = 100,
        align = 'LEFT',
        defaultsort = 'dsc',
        sortnext = 3,
        --index = 'name',
    },
    {
        name = 'Weekly Best',
        width = 80,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'CurrentKeyLevel',
        width = 90,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
    {
        name = 'CurrentKeyInstance',
        width = 100,
        align = 'RIGHT',
        defaultsort = 'dsc',
        --index = 'WeeklyBest',
    },
}

local GuildHeading = AceGUI:Create("InlineGroup")
--GuildHeading:SetFullWidth(true)
GuildHeading:SetTitle("Guild Member's Keys")
MainFrame:AddChild(GuildHeading)

local Guildst = AceGUI:Create('lib-st')
Guildst:CreateST(GuildcolumnHeaders,10,10)
GuildHeading:AddChild(Guildst)

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

local AffixHeading = AceGUI:Create("InlineGroup")
AffixHeading:SetLayout("Flow")
AffixHeading:SetFullWidth(true)
AffixHeading:SetTitle("This Weeks Affix's")
MainFrame:AddChild(AffixHeading)
local function GetCurrentAffixes(_,event)
    local CurrentAffixes = C_MythicPlus.GetCurrentAffixes()
    --if not CurrentAffixes then C_Timer.After(1, GetCurrentAffixes) return end
    local AffixOne = AceGUI:Create("Label")
    local AffixOnename, AffixOnedescription, AffixOnefiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[1].id)
    AffixOne:SetImage(AffixOnefiledataid)
    --AffixOne:SetImageSize(32,32)
    --AffixOne:SetWidth(40)
    --AffixOne:SetHeight(40)
    AffixOne:SetText("Level 2+: " .. AffixOnename)
    AffixOne.tooltipText = AffixOnedescription
    AffixHeading:AddChild(AffixOne)

    local AffixTwo = AceGUI:Create("Label")
    local AffixTwoname, AffixTwodescription, AffixTwofiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[2].id)
    AffixTwo:SetImage(AffixTwofiledataid)
    --AffixTwo:SetImageSize(32,32)
    --AffixTwo:SetWidth(40)
    --AffixTwo:SetHeight(40)
    AffixTwo:SetText("Level 4+: " .. AffixTwoname)
    AffixTwo.tooltipText = AffixTwodescription
    AffixHeading:AddChild(AffixTwo)

    local AffixThree = AceGUI:Create("Label")
    local AffixThreename, AffixThreedescription, AffixThreefiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[3].id)
    AffixThree:SetImage(AffixThreefiledataid)
    --AffixThree:SetImageSize(32,32)
    --AffixThree:SetWidth(40)
    --AffixThree:SetHeight(40)
    AffixThree:SetText("Level 7+: " .. AffixThreename)
    AffixThree.tooltipText = AffixThreedescription
    AffixHeading:AddChild(AffixThree)

    local AffixFour = AceGUI:Create("Label")
    local AffixFourname, AffixFourdescription, AffixFourfiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[4].id)
    AffixFour:SetImage(AffixFourfiledataid)
    --AffixFour:SetImageSize(32,32)
    --AffixFour:SetWidth(40)
    --AffixFour:SetHeight(40)
    AffixFour:SetText("Level 10+: " .. AffixFourname)
    AffixFour.tooltipText = AffixFourdescription
    AffixHeading:AddChild(AffixFour)
end

local eventframe = CreateFrame("Frame")
--eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
--eventframe:RegisterEvent("LOADING_SCREEN_DISABLED")
eventframe:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")

eventframe:SetScript("OnEvent", GetCurrentAffixes)

local realmName = GetRealmName()

local function GetTable()
    --local data = {
    --	{
    --		cols = {
    --			{
    --				value = 'Kelebros',
    --				color = RAID_CLASS_COLORS['DRUID'],
    --			},
    --			{
    --				value = '85',
    --			},
    --		},
    --	},
    --	{
    --		cols = {
    --			{
    --				value = 'Humbaba',
    --				color = RAID_CLASS_COLORS['WARLOCK'],
    --			},
    --			{
    --				value = '85',
    --			},
    --		},
    --	},
    --}
        data = {}
        for character,characterinfo in pairs(_G.DoCharacters[realmName]) do
            --print(_G.DoCharacters[realmName][character].name)
            --tinsert(data, {
            --    Name       = _G.DoCharacters[realmName][character].name,
            --    --class      = keyInfo.class,
            --    --weeklyBest = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].WeeklyBest,
            --    --mapName    = keyInfo.mapName,
            --    Level      = _G.DoCharacters[realmName][character].level,
            --    --guild      = keyInfo.guild or currentGuild
            --})
            --works
            --tinsert(data, { ["cols"] = {
            --    {["name"] = _G.DoCharacters[realmName][character].name},
            --    {["level"] = _G.DoCharacters[realmName][character].level},
            --    {["WeeklyBest"] = _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].WeeklyBest},
            --    {["class"] = _G.DoCharacters[realmName][character].class}
            --}
            --})

            --test
            tinsert(data,
                { _G.DoCharacters[realmName][character].name,
                 _G.DoCharacters[realmName][character].level,
                _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].WeeklyBest,
                _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentKeyLevel,
                _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentKeyInstance,
                _G.DoCharacters[realmName][character].avgItemLevel,
                _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].currentSeasonScore or 0,
                --class = _G.DoCharacters[realmName][character].class,
                color = RAID_CLASS_COLORS[_G.DoCharacters[realmName][character].class]
                }
            )
        end
        st.st:SetData(data,true)
        st.st:Show()
        guilddata = {}
        for GuildName,NameRealm in pairs(_G.DoKeysGuild) do
            for character in pairs(NameRealm) do
                tinsert(guilddata,
                    { _G.DoKeysGuild[GuildName][character].name,
                    _G.DoKeysGuild[GuildName][character]["mythicplus"]["keystone"].WeeklyBest,
                    _G.DoKeysGuild[GuildName][character]["mythicplus"]["keystone"].CurrentKeyLevel,
                    _G.DoKeysGuild[GuildName][character]["mythicplus"]["keystone"].CurrentKeyInstance,
                    color = RAID_CLASS_COLORS[_G.DoKeysGuild[GuildName][character].Class]
                    }
                )
            end
        end
        Guildst.st:SetData(guilddata,true)
        Guildst.st:Show()
end

local function SeasonBestsGetTable()
        SeasonBestsstdata = {}
        for character,characterinfo in pairs(_G.DoCharacters[realmName]) do
            --if _G.DoCharacters[realmName][character].name then
            --    tinsert(SeasonBestsstdata,1,_G.DoCharacters[realmName][character].name)
            --end
            if _G.DoCharacters[realmName][character].level < DoKeysCurrentMaxLevel then
            else
                if _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"] then
                    --for instancename,affixweek in pairs(_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]) do
                        --tinsert(SeasonBestsstdata,2,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Fortified"][1])
                        --tinsert(SeasonBestsstdata,3,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Fortified"][1])
                        --tinsert(SeasonBestsstdata,4,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Fortified"][1])
                        --tinsert(SeasonBestsstdata,5,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Fortified"][1])
                        --tinsert(SeasonBestsstdata,6,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Fortified"][1])
                        --tinsert(SeasonBestsstdata,7,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Fortified"][1])
                        --tinsert(SeasonBestsstdata,8,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Fortified"][1])
                        --tinsert(SeasonBestsstdata,9,_G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Fortified"][1])
                    --end
                    tinsert(SeasonBestsstdata,
                        { _G.DoCharacters[realmName][character].name,
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["De Other Side"]["Fortified"][1],
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Halls of Atonement"]["Fortified"][1],
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Mists of Tirna Scithe"]["Fortified"][1],
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Plaguefall"]["Fortified"][1],
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Sanguine Depths"]["Fortified"][1],
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Spires of Ascension"]["Fortified"][1],
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["The Necrotic Wake"]["Fortified"][1],
                        _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Tyrannical"][1] .. "/" .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"]["Theater of Pain"]["Fortified"][1],
                        color = RAID_CLASS_COLORS[_G.DoCharacters[realmName][character].class]
                        }
                    )
                end
            end
        end
        SeasonBestsst.st:SetData(SeasonBestsstdata,true)
        SeasonBestsst.st:SetDisplayRows(12, 12)
        SeasonBestsst.st:Show()
end

local addon = LibStub("AceAddon-3.0"):NewAddon("DoKeys", "AceConsole-3.0")
local DoKeysLDB = LibStub("LibDataBroker-1.1"):NewDataObject("DoKeysLDB", {
type = "data source",
text = "DoKeys",
icon = "Interface\\Icons\\spell_nature_moonkey",
OnClick = function(clickedframe, button)
                if button == "LeftButton" then
                    if MainFrame:IsShown() then
                        MainFrame:Hide()
                    else
                        GetTable()
                        MainFrame:Show()
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
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("DoKeysDB", { profile = { minimap = { hide = false, }, }, })
    icon:Register("DoKeysIcon", DoKeysLDB, self.db.profile.minimap)
    self:RegisterChatCommand("dokeys", "OpenUI")
end

function addon:OpenUI(one, two, three, four)
    --print(one, two, three, four)
    --local AceConsole = LibStub("AceConsole-3.0")
    --print(AceConsole:GetArgs(str, numargs, startpos))
    if one == "toggle minimap" then
        self.db.profile.minimap.hide = not self.db.profile.minimap.hide
        if self.db.profile.minimap.hide then
            icon:Hide("DoKeysIcon")
        else
            icon:Show("DoKeysIcon")
        end
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

--local function OnTooltipSetUnit(self)
--    --local unitName, unit = self:GetUnit()
--    local mouseoverunitname, mouseoverrealm = UnitName("mouseover")
--    local mouseovernamerealm
--    if mouseoverunitname and mouseoverrealm then
--        mouseovernamerealm = mouseoverunitname .. "-" .. mouseoverrealm
--    end
--    local instancename
--
--    for GuildName,NameRealm in pairs(_G.DoKeysGuild) do
--        if NameRealm.name then
--            if mouseovernamerealm == _G.DoKeysGuild[GuildName][NameRealm].name or mouseoverunitname == _G.DoKeysGuild[GuildName][NameRealm].name then
--                if _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance then
--                    instancename = _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance
--                end
--                if instancename and string.len(instancename) > 2 then
--                    GameTooltip:AddLine("Keystone: " .. _G.DoKeysGuild[GuildName][NameRealm]["mythicplus"]["keystone"].CurrentKeyInstance, 1, 1, 1)
--                end
--            end
--        end
--    end
--    for character,characterinfo in pairs(_G.DoCharacters[realmName]) do
--        if mouseovernamerealm == characterinfo.name or mouseoverunitname == characterinfo.name then
--            if _G.DoCharacters[mouseoverrealm][character]["mythicplus"]["keystone"].CurrentKeyInstance then
--                instancename = _G.DoCharacters[mouseoverrealm][character]["mythicplus"]["keystone"].CurrentKeyInstance
--            end
--            if instancename and string.len(instancename) > 2 then
--                GameTooltip:AddLine("Keystone: " .. _G.DoCharacters[mouseoverrealm][character]["mythicplus"]["keystone"].CurrentKeyInstance, 1, 1, 1)
--            end
--        end
--    end
--end
--
--GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

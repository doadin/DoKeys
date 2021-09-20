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

local PlayerHeading = AceGUI:Create("InlineGroup")
--PlayerHeading:SetFullWidth(true)
PlayerHeading:SetTitle("Player's Keys")
MainFrame:AddChild(PlayerHeading)

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

local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
scrollcontainer:SetFullWidth(true)
--scrollcontainer:SetFullHeight(true) -- probably?
scrollcontainer:SetLayout("Flow") -- important!
MainFrame:AddChild(scrollcontainer)

local ReportToDropDownValue
local function GetReportToDropDownValue(this, event, item)
    ReportToDropDownValue = item
end

local ReportButton = AceGUI:Create("Button")
ReportButton:SetWidth(140)
ReportButton:SetHeight(20)
ReportButton:SetText("Report Weekly Best To:")
ReportButton:SetCallback(
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
scrollcontainer:AddChild(ReportButton)
ReportButton:SetPoint('LEFT', "$parent", 'LEFT', 0, 0)


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
ReportToDropDown:SetPoint('RIGHT', "$parent", 'RIGHT', 0, 0)

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
local GetAffixInfoOnce
local function GetCurrentAffixes()
    if not GetAffixInfoOnce then
        local CurrentAffixes = C_MythicPlus.GetCurrentAffixes()
        if not CurrentAffixes then C_Timer.After(1, GetCurrentAffixes) return end
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
        GetAffixInfoOnce = true
    end
end

local eventframe = CreateFrame("Frame")
--eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:RegisterEvent("LOADING_SCREEN_DISABLED")

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
                --if button == "RightButton" then
                --    if GuildFrame:IsShown() then
                --        GuildFrame:Hide()
                --    else
                --        GetTable()
                --        GuildFrame:Show()
                --    end
                --end
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

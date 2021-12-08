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

local AceGUI = LibStub("AceGUI-3.0")

local MainFrame = AceGUI:Create("Frame")
MainFrame:SetTitle("DoKeys")
MainFrame:SetStatusText("Dokeys" .. " " .. GetAddOnMetadata("DoKeys", "Version") )
MainFrame:EnableResize(false)
MainFrame:SetWidth(700)
MainFrame:SetHeight(520)
MainFrame:Hide()

local SeasonBestsFrame = AceGUI:Create("Frame")
SeasonBestsFrame:SetTitle("DoKeys Season Bests")
SeasonBestsFrame:SetStatusText("Dokeys" .. " " .. GetAddOnMetadata("DoKeys", "Version") )
SeasonBestsFrame:EnableResize(false)
SeasonBestsFrame:SetWidth(850)
SeasonBestsFrame:SetHeight(280)
SeasonBestsFrame:Hide()

local SeasonBestsHeading = AceGUI:Create("InlineGroup")
SeasonBestsHeading:SetWidth(820)
SeasonBestsHeading:SetTitle("Player's Season Bests")
SeasonBestsHeading:SetLayout("Flow")
SeasonBestsFrame:AddChild(SeasonBestsHeading)

local PlayerHeading = AceGUI:Create("InlineGroup")
PlayerHeading:SetWidth(670)
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
SeasonBestsHeading:AddChild(SeasonBestsst)

local reportcontainer = AceGUI:Create("SimpleGroup")
reportcontainer:SetWidth(500)
reportcontainer:SetLayout("Flow")
MainFrame:AddChild(reportcontainer)

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
reportcontainer:AddChild(ReportToDropDown)
ReportToDropDown:SetPoint('LEFT', "$parent", 'LEFT', 0, 0)

local ReportWeeklyBestButton = AceGUI:Create("Button")
ReportWeeklyBestButton:SetWidth(140)
ReportWeeklyBestButton:SetHeight(20)
ReportWeeklyBestButton:SetText("Report Weekly Best")
--ReportWeeklyBestButton:SetCallback(
--    "OnClick",
--    function()
--        for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
--            if v.level == DoKeysCurrentMaxLevel then
--                SendChatMessage(k .. " Weekly Best: " .. v["mythicplus"]["keystone"].WeeklyBest, ReportToDropDownValue)
--            end
--        end
--        --print(ReportToDropDownValue)
--    end
--)
reportcontainer:AddChild(ReportWeeklyBestButton)
ReportWeeklyBestButton:SetPoint('RIGHT', "$parent", 'RIGHT', 0, 0)

local ReportKeyButton = AceGUI:Create("Button")
ReportKeyButton:SetWidth(140)
ReportKeyButton:SetHeight(20)
ReportKeyButton:SetText("Report Keys")
--ReportKeyButton:SetCallback(
--    "OnClick",
--    function()
--        for k, v in pairs(_G.DoCharacters[realm]) do -- luacheck: ignore 423
--            if v.level == DoKeysCurrentMaxLevel then
--                SendChatMessage(k .. " " .. CreateLink(v["mythicplus"]["keystone"]), ReportToDropDownValue)
--            end
--        end
--        --print(ReportToDropDownValue)
--    end
--)
reportcontainer:AddChild(ReportKeyButton)
ReportKeyButton:SetPoint('RIGHT', "$parent", 'RIGHT', 0, 0)

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
GuildHeading:SetWidth(420)
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
AffixHeading:SetWidth(480)
AffixHeading:SetTitle("This Weeks Affix's")
MainFrame:AddChild(AffixHeading)

local function GetAffixes(_,event, one, two)

    local AffixOne
    local AffixTwo
    local AffixThree
    local AffixFour
    if event == "PLAYER_ENTERING_WORLD" and one or two then
        --print("Setting up affix UI Icons....")
        if type(AffixOne) ~= "table" then
            AffixOne = AceGUI:Create("Icon")
            AffixOne:SetImageSize(32,32)
            AffixHeading:AddChild(AffixOne)
        end
        if type(AffixTwo) ~= "table" then
            AffixTwo = AceGUI:Create("Icon")
            AffixTwo:SetImageSize(32,32)
            AffixHeading:AddChild(AffixTwo)
        end
        if type(AffixThree) ~= "table" then
            AffixThree = AceGUI:Create("Icon")
            AffixThree:SetImageSize(32,32)
            AffixHeading:AddChild(AffixThree)
        end
        if type(AffixFour) ~= "table" then
            AffixFour = AceGUI:Create("Icon")
            AffixFour:SetImageSize(32,32)
            AffixHeading:AddChild(AffixFour)
        end
    end

    if type(AffixOne) == "table" then
        local CurrentAffixes = C_MythicPlus.GetCurrentAffixes()
        if not CurrentAffixes then C_Timer.After(1, GetAffixes) return end
        local AffixOnename, AffixOnedescription, AffixOnefiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[1].id)
        AffixOne:SetImage(AffixOnefiledataid)
        AffixOne:SetImageSize(32,32)
        AffixOne:SetLabel("Level 2+: " .. AffixOnename)
        AffixOne:SetCallback("OnEnter",function()
            GameTooltip:SetOwner(AffixOne.frame, "ANCHOR_BOTTOM",0,-5)
            GameTooltip:SetText(AffixOnedescription,1,1,1,1)
            GameTooltip:Show()
        end)
        AffixOne:SetCallback("OnLeave",function()
            GameTooltip:Hide()
        end)

        local AffixTwoname, AffixTwodescription, AffixTwofiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[2].id)
        AffixTwo:SetImage(AffixTwofiledataid)
        AffixTwo:SetImageSize(32,32)
        AffixTwo:SetLabel("Level 4+: " .. AffixTwoname)
        AffixTwo:SetCallback("OnEnter",function()
            GameTooltip:SetOwner(AffixTwo.frame, "ANCHOR_BOTTOM",0,-5)
            GameTooltip:SetText(AffixTwodescription,1,1,1,1)
            GameTooltip:Show()
        end)
        AffixTwo:SetCallback("OnLeave",function()
            GameTooltip:Hide()
        end)

        local AffixThreename, AffixThreedescription, AffixThreefiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[3].id)
        AffixThree:SetImage(AffixThreefiledataid)
        AffixThree:SetImageSize(32,32)
        AffixThree:SetLabel("Level 7+: " .. AffixThreename)
        AffixThree:SetCallback("OnEnter",function()
            GameTooltip:SetOwner(AffixThree.frame, "ANCHOR_BOTTOM",0,-5)
            GameTooltip:SetText(AffixThreedescription,1,1,1,1)
            GameTooltip:Show()
        end)
        AffixThree:SetCallback("OnLeave",function()
            GameTooltip:Hide()
        end)

        local AffixFourname, AffixFourdescription, AffixFourfiledataid = C_ChallengeMode.GetAffixInfo(CurrentAffixes[4].id)
        AffixFour:SetImage(AffixFourfiledataid)
        AffixFour:SetImageSize(32,32)
        AffixFour:SetLabel("Level 10+: " .. AffixFourname)
        AffixFour.tooltipText = AffixFourdescription
        AffixFour:SetCallback("OnEnter",function()
            GameTooltip:SetOwner(AffixFour.frame, "ANCHOR_BOTTOM",0,-5)
            GameTooltip:SetText(AffixFourdescription,1,1,1,1)
            GameTooltip:Show()
        end)
        AffixFour:SetCallback("OnLeave",function()
            GameTooltip:Hide()
        end)
    end
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD") --PLAYER_ENTERING_WORLD: isInitialLogin, isReloadingUi
eventframe:SetScript("OnEvent", GetAffixes)

local function GetTable()
    local data
    local guilddata
    data = {}
    for character,characterinfo in pairs(_G.DoCharacters[realmName]) do
        tinsert(data,
            { _G.DoCharacters[realmName][character].name,
             _G.DoCharacters[realmName][character].level,
            _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].WeeklyBest,
            _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentKeyLevel,
            _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].CurrentKeyInstance,
            _G.DoCharacters[realmName][character].avgItemLevel,
            _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].currentSeasonScore or 0,
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
            if _G.DoCharacters[realmName][character].level < DoKeysCurrentMaxLevel then
            else
                if _G.DoCharacters[realmName][character]["mythicplus"]["keystone"]["seasonbests"] then
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
    self.db = LibStub("AceDB-3.0"):New("DoKeysDB", { profile = { minimap = { hide = false, }, }, })
    LibDBIcon:Register("DoKeysIcon", DoKeysLDB, self.db.profile.minimap)
    self:RegisterChatCommand("dokeys", "OpenUI")
end

function addon:OpenUI(one, two, three, four)
    if one == "toggle minimap" then
        self.db.profile.minimap.hide = not self.db.profile.minimap.hide
        if self.db.profile.minimap.hide then
            LibDBIcon:Hide("DoKeysIcon")
        else
            LibDBIcon:Show("DoKeysIcon")
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

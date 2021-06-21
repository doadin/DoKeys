--luacheck: no max line length
--luacheck: no redefined

local CreateFrame = _G.CreateFrame
local LibStub = _G.LibStub
local GetAddOnMetadata = _G.GetAddOnMetadata
local tinsert = _G.tinsert
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")

local AceGUI = LibStub("AceGUI-3.0")
-- Create a container frame
local MainFrame = AceGUI:Create("Frame")
--f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
MainFrame:SetTitle("DoKeys")
MainFrame:SetStatusText("Dokeys" .. " " .. GetAddOnMetadata("DoKeys", "Version") )
MainFrame:SetLayout("Fill")
MainFrame:EnableResize(false)
MainFrame:Hide()

local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
scrollcontainer:SetFullWidth(true)
scrollcontainer:SetFullHeight(true) -- probably?
scrollcontainer:SetLayout("Fill") -- important!

MainFrame:AddChild(scrollcontainer)

--local cleardatabtn = AceGUI:Create("Button")
--cleardatabtn:SetText("Clear Data!")
--cleardatabtn:SetCallback("OnClick", function() print("Click!") end)
--cleardatabtn:SetPoint("BOTTOM")
--MainFrame:AddChild(cleardatabtn)

--local scroll = AceGUI:Create("ScrollFrame")
--scroll:SetLayout("Flow") -- probably?
--scrollcontainer:AddChild(scroll)

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

--local LibST = LibStub('ScrollingTable')
--local st = LibST:CreateST(columnHeaders,12,15)
--lib:CreateST(cols, numRows, rowHeight, highlight, parent, multiselection)
local st = AceGUI:Create('lib-st')
st:CreateST(columnHeaders,12,12)
--st:EnableSelection(true)
--st:SetWidth(470)
--st:SetHeight(700)
scrollcontainer:AddChild(st)

-- Create a button
--local btn = AceGUI:Create("Button")
--btn:SetWidth(170)
--btn:SetText("Button !")
--btn:SetCallback("OnClick", function() print("Click!") end)
---- Add the button to the container
--scroll:AddChild(btn)

local realmName = _G.GetRealmName()

--local function GetTable(_, event, one, _)
--    if event == "ADDON_LOADED" and one == "DoKeys" then
--        for character,characterinfo in pairs(_G.DoCharacters[realmName]) do
--            local characternamelabel = AceGUI:Create("InteractiveLabel")
--            if _G.DoCharacters[realmName][character].level and _G.DoCharacters[realmName][character].level <= 60 then return end
--            if _G.DoCharacters[realmName][character].name then
--                if _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].WeeklyBest then
--                    if _G.DoCharacters[realmName][character].avgItemLevel then
--                        characternamelabel:SetText(_G.DoCharacters[realmName][character].name .. " Weekly Best: " .. _G.DoCharacters[realmName][character]["mythicplus"]["keystone"].WeeklyBest .. " avgItemLevel: " .. _G.DoCharacters[realmName][character].avgItemLevel)
--                    end
--                end
--            end
--            characternamelabel:SetFullWidth(true)
--            scroll:AddChild(characternamelabel)
--        end
--    end
--end
local function GetTable(_, _, _, _)
    --GetTable(_, event, one, _)
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
    --if event == "ADDON_LOADED" and one == "DoKeys" then
        local data = {}
        for character,_ in pairs(_G.DoCharacters[realmName]) do --character,characterinfo
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
        --st.st:SetDisplayCols(st.st.cols)
        --st.st:RegisterEvents(st.st.DefaultEvents)
        --st.st.Show = true
    --end
end

--eventframe:SetScript("OnEvent", GetTable)

local addon = LibStub("AceAddon-3.0"):NewAddon("DoKeys", "AceConsole-3.0")
local DoKeysLDB = LibStub("LibDataBroker-1.1"):NewDataObject("DoKeysLDB", {
type = "data source",
text = "DoKeys",
icon = "Interface\\Icons\\INV_Chest_Cloth_17",
OnClick = function()
    if MainFrame:IsShown() then
        MainFrame:Hide()
    else
        GetTable()
        MainFrame:Show()
    end
end,
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("DoKeysDB", { profile = { minimap = { hide = false, }, }, })
    icon:Register("DoKeysIcon", DoKeysLDB, self.db.profile.minimap)
    self:RegisterChatCommand("dokeys", "OpenUI")
end

function addon:OpenUI(one, _, _, _)
    --OpenUI(one, two, three, four)
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
            MainFrame:Show()
            GetTable()
        end
    end
end

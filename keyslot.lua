local CreateFrame = _G.CreateFrame
local C_ChallengeMode = _G.C_ChallengeMode
local ItemLocation = _G.ItemLocation
local GetContainerNumSlots = _G.GetContainerNumSlots
local GetContainerItemID = _G.GetContainerItemID
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS

local f = CreateFrame("Frame")

local function OnEvent(_, _) --self, event
    local location
    local canUse
    if not C_ChallengeMode.HasSlottedKeystone() then
        for Bag = 0, NUM_BAG_SLOTS do
            for Slot = 1, GetContainerNumSlots(Bag) do
                local ID = GetContainerItemID(Bag, Slot)
                if (ID and ID == 180653) or (ID and ID == 187786) then
                    --return UseContainerItem(Bag, Slot)
                    location = ItemLocation:CreateFromBagAndSlot(Bag, Slot)
                    canUse = C_ChallengeMode.CanUseKeystoneInCurrentMap(location)
                    if canUse then
                        if ID == 180653 then
                            C_ChallengeMode.SlotKeystone()
                        end
                        if ID == 187786 or ID == 180653 then
                            _G.UseContainerItem(Bag, Slot)
                        end
                    end
                end
            end
        end
    end
end

f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
f:SetScript("OnEvent", OnEvent)
--CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN
--CHALLENGE_MODE_KEYSTONE_SLOTTED
--C_ChallengeMode.HasSlottedKeystone() = boolean
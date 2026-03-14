local addonName, addonTable = ...

addonTable.issecretvalue = function(value)
    return issecretvalue and issecretvalue(value) or false
end

addonTable.addonTable.DoKeysCurrentMaxLevel = 90
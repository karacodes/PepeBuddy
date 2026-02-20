local ADDON_NAME, pb = ...
local GetMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local version = (GetMeta and GetMeta(ADDON_NAME, "Version")) or "Unknown"

pb.addonName = ADDON_NAME
pb.displayName = "Pepe Buddy"
pb.preferenceName = ADDON_NAME .. "Preferences"
pb.version = version
pb.minimapIconName = ADDON_NAME .. "MIN"
pb.minimapDBName = ADDON_NAME .. "LDB"

---------------------------------------------------------
-- Addon declaration

PepeBuddy = LibStub('AceAddon-3.0'):NewAddon(pb.addonName, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
PepeBuddy.minimapIcon = LibStub("LibDBIcon-1.0")
---------------------------------------------------------
-- Vars

pb.defaultOptions = {
    profile = {
        disabledInfo = true,
        isMovable = true,
        scale = 1,
        minimapIcon = {
            show = true,
        },
    }
}

pb.options = {
    name = pb.displayName,
    type = "group",
    icon = 1044996,
    inline = false,
    args = {
        authorPull = {
            type = "description",
            width = "full",
            order = 1,
            name = "Author: Lockspanner - Wyrmrest Accord",
        },
        versionPull = {
            type = "description",
            width = "full",
            order = 2,
            name = "Version: " .. version,
        },
        spacer3 = {
            type = "description",
            width = "full",
            order = 3,
            name = "\n\n",
        },
    },
}

function PepeBuddy:OpenSettings()
    if Settings and Settings.OpenToCategory then
        -- Dragonflight+ API
        Settings.OpenToCategory(pb.optionsCategoryID or PepeBuddy.optionsFrame)
    else
        -- Pre-Dragonflight fallback
        InterfaceOptionsFrame_OpenToCategory(pb.optionsCategoryID)
        InterfaceOptionsFrame_OpenToCategory(pb.optionsCategoryID) -- Call twice to ensure it works
    end
end

PepeBuddy.minimapIconDB = LibStub("LibDataBroker-1.1"):NewDataObject(pb.minimapDBName, {
    type = "data source",
    text = "None",
    label =pb.displayName,
    icon = 1044996,
    tocname = pb.addonName,
    OnClick = function()
        PepeBuddy:OpenSettings()
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddDoubleLine("|cffFFFFFFPepe Buddy|r", "|cff33FF99".."Version: " .. pb.version .."|r");
        tooltip:AddLine(" ");
        tooltip:AddLine("Click Pepe will:")
        tooltip:AddLine("|cffC79C6EShift Left-Click:|r |cff33FF99Toggle Pepe Lock.|r")
        tooltip:AddLine("|cffC79C6EMiddle-Click:|r |cff33FF99Open the configuration panel.|r")
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffC79C6EClick Minimap Button:|r |cff33FF99Open the configuration panel.|r")
    end,
})

function PepeBuddy:OnInitialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(pb.addonName, pb.options, {})
    PepeBuddy.db = LibStub("AceDB-3.0"):New(pb.preferenceName, pb.defaultOptions)
    PepeBuddy.optionsFrame, pb.optionsCategoryID = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(pb.addonName, pb.displayName)
    PepeBuddy.minimapIcon:Register(pb.minimapIconName, PepeBuddy.minimapIconDB, PepeBuddy.db.profile.minimapIcon)

    --minimapIcon:Register("PepeBuddyLDBI", PepeBuddy.minimapIconDB, PepeBuddy.db.profile.minimapIcon)
    --if PepeBuddy.db.profile.minimapIcon.hide then
    --    minimapIcon:Hide("PepeBuddyLDBI")
    --else
    --    minimapIcon:Show("PepeBuddyLDBI")
    --end
    --PepeBuddy:Setup()
end

function PepeBuddy:OnEnable()
    -- Called when the addon is enabled
    PepeBuddy:Print(pb.addonName)
end

function PepeBuddy:OnDisable()
    -- Called when the addon is disabled
    PepeBuddy:Print("Disabled!")
end



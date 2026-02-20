local _, pb = ...

local function BuildPepeValues()
    local values = {}
    local pepes = pb.pepes or {}
    for index, pepe in ipairs(pepes) do
        values[index] = pepe.name
    end
    return values
end

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
            name = "Version: " .. pb.version,
        },
        spacer3 = {
            type = "description",
            width = "full",
            order = 3,
            name = "\n\n",
        },
        selectedPepe = {
            type = "select",
            width = "full",
            order = 4,
            name = "Perch Pepe",
            desc = "Choose which Pepe is shown on the perch.",
            values = BuildPepeValues,
            get = function()
                return (PepeBuddy.db and PepeBuddy.db.profile and PepeBuddy.db.profile.selectedPepe) or 1
            end,
            set = function(_, value)
                PepeBuddy:SetPerchPepe(value)
            end,
        },
    },
}

function PepeBuddy:OpenSettings()
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(self.optionsCategoryID or self.optionsFrame)
        return
    end

    if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end
end

function PepeBuddy:SetupOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(pb.addonName, pb.options, {})
    self.optionsFrame, self.optionsCategoryID = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
        pb.addonName,
        pb.displayName
    )
end

function PepeBuddy:SetupMinimapIcon()
    self.minimapIconDB = LibStub("LibDataBroker-1.1"):NewDataObject(pb.minimapDBName, {
        type = "data source",
        text = "None",
        label = pb.displayName,
        icon = 1044996,
        tocname = pb.addonName,
        OnClick = function()
            self:OpenSettings()
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddDoubleLine("|cffFFFFFFPepe Buddy|r", "|cff33FF99Version: " .. pb.version .. "|r")
            tooltip:AddLine(" ")
            tooltip:AddLine("Click Minimap Button:")
            tooltip:AddLine("|cff33FF99Open the configuration panel.|r")
        end,
    })

    self.minimapIcon:Register(pb.minimapIconName, self.minimapIconDB, self.db.profile.minimapIcon)
end

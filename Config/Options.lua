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
    childGroups = "tab",
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
        spacer4 = {
            type = "description",
            width = "full",
            order = 3,
            name = "Pepe can sit on your DPS meter, relax on your chat window, or perch wherever you like. He’ll quietly observe your rotation, witness your wipes, and pretend not to notice that one mechanic you \“definitely could have dodged.\” \n\nCustomize his look with different costumes and let him judge you in style.",
        },
        spacer5 = {
            type = "description",
            width = "full",
            order = 3,
            name = "\n\n",
        },
        settings = {
            name = "Settings",
            type = "group",
            inline = false,
            order = 4,
            args={
                selectedPepeHeader = {
                    type = "header",
                    width = "full",
                    order = 1,
                    name = "Pepe's Costume",
                },
                selectedPepeDesc = {
                    type = "description",
                    width = "full",
                    order = 2,
                    name = "Choose which Pepe is shown on the perch.",
                },
                selectedPepe = {
                    type = "select",
                    width = "full",
                    order = 3,
                    name = "",
                    desc = "Choose which Pepe is shown on the perch.",
                    values = BuildPepeValues,
                    get = function()
                        return PepeBuddy:GetSelectedPepeSetting()
                    end,
                    set = function(_, value)
                        PepeBuddy:SetSelectedPepeSetting(value)
                        PepeBuddy:ApplyPerchState("Options.selectedPepe")
                    end,
                },
                isMovableHeader = {
                    type = "header",
                    width = "full",
                    order = 4,
                    name = "Movable",
                },
                isMovable = {
                    type = "toggle",
                    width = "full",
                    order = 5,
                    name = "Allow dragging Pepe to a new position.",
                    get = function()
                        return PepeBuddy:GetPerchMovable()
                    end,
                    set = function(_, value)
                        PepeBuddy:SetPerchMovable(value)
                    end,
                },
                scaleHeader = {
                    type = "header",
                    width = "full",
                    order = 6,
                    name = "Scale",
                },
                scaleDesc = {
                    type = "description",
                    width = "full",
                    order = 7,
                    name = "Set the display size of Pepe.",
                },
                scale = {
                    type = "range",
                    width = "full",
                    order = 8,
                    name = "",
                    min = 0.05,
                    max = 4,
                    softMin = 0.15,
                    softMax = 3.5,
                    step = 0.05,
                    isPercent = true,
                    get = function()
                        return PepeBuddy:GetPerchScale()
                    end,
                    set = function(_, value)
                        PepeBuddy:SetPerchScale(value)
                    end,
                },
                facingHeader = {
                    type = "header",
                    width = "full",
                    order = 10,
                    name = "Facing",
                },
                facingDesc = {
                    type = "description",
                    width = "full",
                    order = 11,
                    name = "Change the angle that Pepe faces, left to right. Default is center.",
                },
                facing = {
                    type = "range",
                    width = "full",
                    order = 12,
                    name = "",
                    min = -1,
                    max = 1,
                    softMin = -1,
                    softMax = 1,
                    step = 0.05,
                    isPercent = true,
                    get = function()
                        return PepeBuddy:GetPerchFacing()
                    end,
                    set = function(_, value)
                        PepeBuddy:SetPerchFacing(value)
                    end,
                },
                resetPerchHeader = {
                    type = "header",
                    width = "full",
                    order = 13,
                    name = "Reset",
                },
                resetPerchDesc = {
                    type = "description",
                    width = "full",
                    order = 14,
                    name = "Reset Pepe to defaults and move the perch back to screen center.",
                },
                resetPerchButton = {
                    type = "execute",
                    width = "full",
                    order = 15,
                    name = "Reset Pepe to all defaults",
                    func = function()
                        PepeBuddy:ResetPerchToDefaults()
                        local aceConfigRegistry = LibStub("AceConfigRegistry-3.0", true)
                        if aceConfigRegistry then
                            aceConfigRegistry:NotifyChange(pb.addonName)
                        end
                    end,
                },
            }
        },
        --unlocks = {
        --    name = "Secrets",
        --    type = "group",
        --    order = 5,
        --    args={
        --        --comingSoon = {
        --        --    type = "label",
        --        --    width = "full",
        --        --    order = 1,
        --        --    name = "Coming Soon",
        --        --    desc = "List of Pepe Costumes and how to get them, coming soon.",
        --        --},
        --    }
        --}
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

local _, pb = ...

local SETTINGS_LOGO_PATH = "Interface\\AddOns\\PepeBuddy\\Art\\PepeBuddy.png"
local SETTINGS_ICON_PATH = "Interface\\AddOns\\PepeBuddy\\Art\\Icons\\PepeBuddy-Icon2.png"
local SETTINGS_HEADER_HEIGHT = 108
local SETTINGS_HEADER_LOGO_SIZE = 200
local SETTINGS_HEADER_TEXT_GAP = 16
local SETTINGS_HEADER_TOP_OFFSET = 40
local SETTINGS_HEADER_BOTTOM_GAP = 8
local SETTINGS_HEADER_LOGO_TOP_OFFSET = 12
local SETTINGS_SPACER_LINE_HEIGHT = 18

local headerSpacerLines = 14

local function BuildHeaderSpacer()
    return string.rep("\n", headerSpacerLines)
end

local function BuildPepeValues()
    local values = {}
    local pepes = pb.pepes or {}
    for index, pepe in ipairs(pepes) do
        values[index] = pepe.name
    end
    return values
end

local function EnsureOptionsHeader(frame)
    if frame.pepeBuddyHeader then
        return frame.pepeBuddyHeader
    end

    local header = CreateFrame("Frame", nil, frame)
    header:SetHeight(SETTINGS_HEADER_HEIGHT)
    frame.pepeBuddyHeader = header

    local logo = header:CreateTexture(nil, "ARTWORK")
    logo:SetTexture(SETTINGS_LOGO_PATH)
    logo:SetSize(SETTINGS_HEADER_LOGO_SIZE, SETTINGS_HEADER_LOGO_SIZE)
    logo:SetPoint("TOPRIGHT", 0, SETTINGS_HEADER_LOGO_TOP_OFFSET)
    header.logo = logo

    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 0, 0)
    title:SetPoint("RIGHT", logo, "LEFT", -16, 0)
    title:SetJustifyH("LEFT")
    title:SetJustifyV("TOP")
    title:SetText(pb.displayName)
    header.title = title

    local author = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    author:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    author:SetPoint("RIGHT", logo, "LEFT", -16, 0)
    author:SetJustifyH("LEFT")
    author:SetJustifyV("TOP")
    author:SetText("Author: Diabolic Furby (Lockspanner - Wyrmrest Accord)")
    header.author = author

    local version = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -2)
    version:SetPoint("RIGHT", logo, "LEFT", -16, 0)
    version:SetJustifyH("LEFT")
    version:SetJustifyV("TOP")
    version:SetText("Version: " .. pb.version)
    header.version = version

    local description = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    description:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -8)
    description:SetPoint("RIGHT", logo, "LEFT", -16, 0)
    description:SetJustifyH("LEFT")
    description:SetJustifyV("TOP")
    description:SetText(
        "Pepe can sit on your DPS meter, relax on your chat window, or perch wherever you like. "
            .. "He'll quietly observe your rotation, witness your wipes, and pretend not to notice "
            .. "that one mechanic you \"definitely could have dodged.\"\n\n"
            .. "Customize his look with different costumes and let him judge you in style."
    )
    header.description = description

    return header
end

local function LayoutOptionsHeader(frame)
    if not frame or not frame.obj or not frame.obj.content then
        return
    end

    if frame.obj.label then
        frame.obj.label:SetText("")
        frame.obj.label:Hide()
    end

    local header = EnsureOptionsHeader(frame)
    header:ClearAllPoints()
    header:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -SETTINGS_HEADER_TOP_OFFSET)
    header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -SETTINGS_HEADER_TOP_OFFSET)

    local textWidth = math.max(0, header:GetWidth() - SETTINGS_HEADER_LOGO_SIZE - SETTINGS_HEADER_TEXT_GAP)
    header.title:SetWidth(textWidth)
    header.author:SetWidth(textWidth)
    header.version:SetWidth(textWidth)
    header.description:SetWidth(textWidth)

    local textHeight = header.title:GetStringHeight()
        + 6
        + header.author:GetStringHeight()
        + 2
        + header.version:GetStringHeight()
        + 8
        + header.description:GetStringHeight()
    local visibleLogoHeight = math.max(0, SETTINGS_HEADER_LOGO_SIZE - SETTINGS_HEADER_LOGO_TOP_OFFSET)
    local headerHeight = math.max(SETTINGS_HEADER_HEIGHT, visibleLogoHeight, textHeight)
    header:SetHeight(headerHeight)

    local requiredSpacerLines = math.max(
        1,
        math.ceil((SETTINGS_HEADER_TOP_OFFSET + headerHeight + SETTINGS_HEADER_BOTTOM_GAP) / SETTINGS_SPACER_LINE_HEIGHT)
    )
    if requiredSpacerLines ~= headerSpacerLines then
        headerSpacerLines = requiredSpacerLines

        local aceConfigRegistry = LibStub("AceConfigRegistry-3.0", true)
        if aceConfigRegistry then
            aceConfigRegistry:NotifyChange(pb.addonName)
        end
    end

end

pb.options = {
    name = pb.displayName,
    type = "group",
    icon = SETTINGS_ICON_PATH,
    inline = false,
    childGroups = "tab",
    args = {
        headerSpacer = {
            type = "description",
            width = "full",
            order = 1,
            name = BuildHeaderSpacer,
        },
        settings = {
            name = "Settings",
            type = "group",
            inline = false,
            order = 2,
            args = {
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
                minimapIconHeader = {
                    type = "header",
                    width = "full",
                    order = 6,
                    name = "Minimap Button",
                },
                minimapIconHidden = {
                    type = "toggle",
                    width = "full",
                    order = 7,
                    name = "Hide the minimap button.",
                    get = function()
                        return PepeBuddy:GetMinimapIconHidden()
                    end,
                    set = function(_, value)
                        PepeBuddy:SetMinimapIconHidden(value)
                        PepeBuddy:RefreshMinimapIconVisibility()
                    end,
                },
                scaleHeader = {
                    type = "header",
                    width = "full",
                    order = 8,
                    name = "Scale",
                },
                scaleDesc = {
                    type = "description",
                    width = "full",
                    order = 9,
                    name = "Set the display size of Pepe.",
                },
                scale = {
                    type = "range",
                    width = "full",
                    order = 10,
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
                    order = 12,
                    name = "Facing",
                },
                facingDesc = {
                    type = "description",
                    width = "full",
                    order = 13,
                    name = "Change the angle that Pepe faces, left to right. Default is center.",
                },
                facing = {
                    type = "range",
                    width = "full",
                    order = 14,
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
                    order = 15,
                    name = "Reset",
                },
                resetPerchDesc = {
                    type = "description",
                    width = "full",
                    order = 16,
                    name = "Reset Pepe to defaults and move the perch back to screen center.",
                },
                resetPerchButton = {
                    type = "execute",
                    width = "full",
                    order = 17,
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

    self.optionsFrame:HookScript("OnShow", function(frame)
        LayoutOptionsHeader(frame)
    end)
    LayoutOptionsHeader(self.optionsFrame)
end

function PepeBuddy:RefreshMinimapIconVisibility()
    if not self.minimapIcon then
        return
    end

    if self:GetMinimapIconHidden() then
        self.minimapIcon:Hide(pb.minimapIconName)
        return
    end

    self.minimapIcon:Show(pb.minimapIconName)
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
    self:RefreshMinimapIconVisibility()
end

local ADDON_NAME, pb = ...
local GetMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local version = (GetMeta and GetMeta(ADDON_NAME, "Version")) or "Unknown"

pb.addonName = ADDON_NAME
pb.displayName = "Pepe Buddy"
pb.preferenceName = ADDON_NAME .. "Preferences"
pb.version = version
pb.minimapIconName = ADDON_NAME .. "MIN"
pb.minimapDBName = ADDON_NAME .. "LDB"
pb.slashUsage = "Usage: /pb | /pb debug | /pb debug on | /pb debug off"

PepeBuddy = LibStub("AceAddon-3.0"):NewAddon(
    pb.addonName,
    "AceConsole-3.0",
    "AceEvent-3.0",
    "AceTimer-3.0"
)

PepeBuddy.minimapIcon = LibStub("LibDBIcon-1.0")

function PepeBuddy:SetDebugMode(enabled)
    local mode = enabled and true or false
    self:SetSetting("debugMode", mode)

    if self.ApplyPerchDebugStyle then
        self:ApplyPerchDebugStyle()
    end
end

function PepeBuddy:HandleSlashCommand(input)
    local msg = strtrim((input or ""):lower())
    local cmd, arg1 = msg:match("^(%S+)%s*(.*)$")
    cmd = cmd or ""
    arg1 = arg1 or ""

    if cmd == "" then
        self:OpenSettings()
        return
    end

    if cmd == "help" then
        self:Print(pb.slashUsage)
        return
    end

    if cmd == "debug" and arg1 == "" then
        self:SetDebugMode(not self:GetDebugMode())
    elseif cmd == "debug" and arg1 == "on" then
        self:SetDebugMode(true)
    elseif cmd == "debug" and arg1 == "off" then
        self:SetDebugMode(false)
    else
        self:Print(pb.slashUsage)
        return
    end

    self:Print("Debug mode is now " .. (self:GetDebugMode() and "ON" or "OFF"))
end

function PepeBuddy:OnInitialize()
    self:SetupDatabase()
    self:SetupOptions()
    self:SetupMinimapIcon()
    self:RegisterChatCommand("pb", "HandleSlashCommand")
    self:RegisterChatCommand("pepebuddy", "HandleSlashCommand")
    self:InitializePerch()
end

function PepeBuddy:OnEnable()
    if self.perchFrame then
        self.perchFrame:Show()
        if self.ApplyPerchState then
            self:ApplyPerchState("OnEnable")
        end
    end
end

function PepeBuddy:OnDisable()
    if self.perchFrame then
        self.perchFrame:Hide()
    end
end

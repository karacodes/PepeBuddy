local _, pb = ...

pb.defaultOptions = {
    profile = {
        debugMode = false,
        isMovable = true,
        size = 300,
        scale = 1,
        selectedPepe = 1,
        minimapIcon = {
            hide = false,
        },
    },
}

function PepeBuddy:SetupDatabase()
    self.db = LibStub("AceDB-3.0"):New(pb.preferenceName, pb.defaultOptions)
end

function PepeBuddy:GetSettingDefault(key)
    local defaults = pb.defaultOptions and pb.defaultOptions.profile
    if not defaults then
        return nil
    end
    return defaults[key]
end

function PepeBuddy:GetSetting(key)
    if self.db and self.db.profile and self.db.profile[key] ~= nil then
        return self.db.profile[key]
    end
    return self:GetSettingDefault(key)
end

function PepeBuddy:SetSetting(key, value)
    if not (self.db and self.db.profile) then
        return
    end
    self.db.profile[key] = value
end

function PepeBuddy:GetDebugMode()
    return self:GetSetting("debugMode") and true or false
end

function PepeBuddy:GetSelectedPepeSetting()
    return tonumber(self:GetSetting("selectedPepe")) or 1
end

function PepeBuddy:SetSelectedPepeSetting(index)
    local value = tonumber(index) or self:GetSelectedPepeSetting()
    self:SetSetting("selectedPepe", value)
end

function PepeBuddy:GetPerchScaleSetting()
    local value = tonumber(self:GetSetting("scale"))
    if not value then
        value = tonumber(self:GetSettingDefault("scale")) or 1
    end
    return value
end

function PepeBuddy:SetPerchScaleSetting(scale)
    local value = tonumber(scale)
    if not value then
        value = tonumber(self:GetSettingDefault("scale")) or 1
    end
    self:SetSetting("scale", value)
end

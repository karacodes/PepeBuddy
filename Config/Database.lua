local _, pb = ...

pb.defaultOptions = {
    profile = {
        debugMode = false,
        isMovable = true,
        size = 300,
        scale = 1,
        facing = 0,
        selectedPepe = 1,
        perchPosition = nil,
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

function PepeBuddy:GetPerchMovableSetting()
    return self:GetSetting("isMovable") and true or false
end

function PepeBuddy:SetPerchMovableSetting(isMovable)
    self:SetSetting("isMovable", isMovable and true or false)
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

function PepeBuddy:GetPerchFacingSetting()
    local value = tonumber(self:GetSetting("facing"))
    if not value then
        value = tonumber(self:GetSettingDefault("facing")) or 0
    end
    return value
end

function PepeBuddy:SetPerchFacingSetting(facing)
    local value = tonumber(facing)
    if not value then
        value = tonumber(self:GetSettingDefault("facing")) or 0
    end
    self:SetSetting("facing", value)
end

function PepeBuddy:GetPerchPositionSetting()
    local value = self:GetSetting("perchPosition")
    if type(value) ~= "table" then
        return nil
    end

    local x = tonumber(value.x)
    local y = tonumber(value.y)
    if not x or not y then
        return nil
    end

    return {
        x = x,
        y = y,
    }
end

function PepeBuddy:SetPerchPositionSetting(position)
    if type(position) ~= "table" then
        self:SetSetting("perchPosition", nil)
        return
    end

    local x = tonumber(position.x)
    local y = tonumber(position.y)
    if not x or not y then
        self:SetSetting("perchPosition", nil)
        return
    end

    self:SetSetting("perchPosition", {
        x = x,
        y = y,
    })
end

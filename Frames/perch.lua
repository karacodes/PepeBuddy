local _, pb = ...

local perchFrame
local perchModel
local perchIndex = 1

local perchConfig = {
    cam = 0.70,
    zoom = 0.00,
    x = 0.31,
    y = 0.00,
    z = -0.80,
    facing = 0.00,
    alpha = 0.00, -- this affects the player model that pepe is attached to, to keep them hidden
    anim = 0, -- this and the next setting only affects the player model animations not pepe's animations
    paused = true,
}

local function ApplyModelVisual()
    if not perchModel then
        return
    end

    if type(perchModel.SetCamDistanceScale) == "function" then
        perchModel:SetCamDistanceScale(perchConfig.cam)
    end
    if type(perchModel.SetPortraitZoom) == "function" then
        perchModel:SetPortraitZoom(perchConfig.zoom)
    end
    if type(perchModel.SetPosition) == "function" then
        perchModel:SetPosition(perchConfig.x, perchConfig.y, perchConfig.z)
    end
    if type(perchModel.SetFacing) == "function" then
        perchModel:SetFacing(perchConfig.facing)
    end
    if type(perchModel.SetAlpha) == "function" then
        perchModel:SetAlpha(perchConfig.alpha)
    end
    if type(perchModel.SetAnimation) == "function" then
        pcall(perchModel.SetAnimation, perchModel, perchConfig.anim, 0)
    end
    if type(perchModel.SetPaused) == "function" then
        pcall(perchModel.SetPaused, perchModel, perchConfig.paused)
    elseif type(perchModel.FreezeAnimation) == "function" then
        pcall(perchModel.FreezeAnimation, perchModel, perchConfig.paused)
    end
end

local function GetSavedPepeIndex()
    return (PepeBuddy.db and PepeBuddy.db.profile and PepeBuddy.db.profile.selectedPepe) or perchIndex
end

local function CreateFreshModel()
    if not perchFrame then
        return
    end

    if perchModel then
        perchModel:Hide()
    end

    perchModel = CreateFrame("PlayerModel", nil, perchFrame)
    perchModel:SetAllPoints()

    if type(perchModel.ClearModel) == "function" then
        perchModel:ClearModel()
    end
    if type(perchModel.SetUnit) == "function" then
        perchModel:SetUnit("player")
    end
    if type(perchModel.RefreshUnit) == "function" then
        perchModel:RefreshUnit()
    end
    if type(perchModel.Undress) == "function" then
        perchModel:Undress()
    end

    ApplyModelVisual()
end

local function ApplyPepeByIndex(index)
    local pepes = pb.pepes or {}
    if not perchFrame or #pepes == 0 then
        return false
    end

    if index < 1 then
        index = #pepes
    elseif index > #pepes then
        index = 1
    end
    perchIndex = index

    CreateFreshModel()

    local pepe = pepes[perchIndex]
    local applied = false
    if perchModel and type(perchModel.ApplySpellVisualKit) == "function" then
        applied = pcall(perchModel.ApplySpellVisualKit, perchModel, pepe.id, false)
    end
    return applied
end

local function CreatePerchFrame()
    if perchFrame then
        return
    end

    perchFrame = CreateFrame("Frame", "PepeBuddyPerchFrame", UIParent, "BackdropTemplate")
    perchFrame:SetSize(240, 240)
    perchFrame:SetPoint("CENTER", -220, 0)
    perchFrame:SetMovable(true)
    perchFrame:EnableMouse(true)
    perchFrame:RegisterForDrag("LeftButton")
    perchFrame:SetScript("OnDragStart", perchFrame.StartMoving)
    perchFrame:SetScript("OnDragStop", perchFrame.StopMovingOrSizing)
    perchFrame:SetScript("OnShow", function()
        PepeBuddy:SetPerchPepe(GetSavedPepeIndex())
        PepeBuddy:StartPerchRefresh()
    end)
    perchFrame:SetScript("OnHide", function()
        PepeBuddy:StopPerchRefresh()
    end)
    perchFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    perchFrame:SetBackdropColor(0, 0, 0, 0.15)
    perchFrame:SetBackdropBorderColor(0.2, 0.85, 1, 1)
    perchFrame:SetClipsChildren(true)

    ApplyPepeByIndex(perchIndex)
end

function PepeBuddy:InitializePerch()
    CreatePerchFrame()
    self:SetPerchPepe(GetSavedPepeIndex())
    perchFrame:Hide()
    self.perchFrame = perchFrame
end

function PepeBuddy:SetPerchPepe(index, retryCount)
    local pepes = pb.pepes or {}
    if #pepes == 0 then
        return
    end

    local retries = tonumber(retryCount) or 0
    local nextIndex = tonumber(index) or 1
    if nextIndex < 1 then
        nextIndex = #pepes
    elseif nextIndex > #pepes then
        nextIndex = 1
    end

    if self.db and self.db.profile then
        self.db.profile.selectedPepe = nextIndex
    end

    if not perchFrame then
        CreatePerchFrame()
    end

    local applied = ApplyPepeByIndex(nextIndex)
    if not applied and retries < 3 and C_Timer and C_Timer.After then
        C_Timer.After(0.2, function()
            PepeBuddy:SetPerchPepe(nextIndex, retries + 1)
        end)
    end
end

function PepeBuddy:GetSelectedPepe()
    return perchIndex
end

function PepeBuddy:StartPerchRefresh()
    if self._perchRefreshActive then
        return
    end

    self._perchRefreshActive = true
    self._perchRefreshPasses = 0
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPerchRefreshEvent")
    self:RegisterEvent("UNIT_MODEL_CHANGED", "OnPerchRefreshEvent")
end

function PepeBuddy:StopPerchRefresh()
    if not self._perchRefreshActive then
        return
    end

    self._perchRefreshActive = false
    self._perchRefreshPasses = 0
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("UNIT_MODEL_CHANGED")
end

function PepeBuddy:OnPerchRefreshEvent(event, unit)
    if event == "UNIT_MODEL_CHANGED" and unit ~= "player" then
        return
    end
    if not self.perchFrame or not self.perchFrame:IsShown() then
        self:StopPerchRefresh()
        return
    end

    self:SetPerchPepe(GetSavedPepeIndex())
    self._perchRefreshPasses = (self._perchRefreshPasses or 0) + 1

    if self._perchRefreshPasses >= 3 then
        self:StopPerchRefresh()
    end
end

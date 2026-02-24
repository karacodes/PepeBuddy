local _, pb = ...

local perchFrame
local perchHandleFrame
local perchModel
local perchIndex = 1
local PrintPerchBottomCenters

local perchConfig = {
    cam = 0.70,
    zoom = 0.00,
    x = -0.10,
    y = -0.01,
    z = -0.95,
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

-- helper you can call whenever debugMode changes
local function ApplyPerchDebugStyle()
    if not perchFrame then
        return
    end

    if pb.debugMode then
        perchFrame:SetBackdropColor(0, 0, 0, 0.15)
        perchFrame:SetBackdropBorderColor(0.2, 0.85, 1, 1)
    else
        perchFrame:SetBackdropColor(0, 0, 0, 0)
        perchFrame:SetBackdropBorderColor(0, 0, 0, 0)
    end

    if perchHandleFrame then
        perchHandleFrame:SetBackdropColor(0, 0, 0, 0)
        if pb.debugMode then
            perchHandleFrame:SetBackdropBorderColor(0.2, 0.85, 1, 1)
        else
            perchHandleFrame:SetBackdropBorderColor(0, 0, 0, 0)
        end
    end
end

function PepeBuddy:ApplyPerchDebugStyle()
    ApplyPerchDebugStyle()
end

local function UpdatePerchHandleLayout(size)
    if not perchHandleFrame or not perchFrame then
        return
    end

    local handleSize = size * 0.25
    local scale = PepeBuddy:GetPerchScale()
    local yOffset = (40 * scale) - 5

    --perchHandleFrame:ClearAllPoints()
    perchHandleFrame:SetPoint("BOTTOM", perchFrame, "BOTTOM", 0, yOffset)
    perchHandleFrame:SetSize(handleSize, handleSize)
end

local function CreatePerchFrame()
    if perchFrame then
        return
    end

    perchFrame = CreateFrame("Frame", "PepeBuddyPerchFrame", UIParent, "BackdropTemplate")
    local defaultSize = (pb.defaultOptions and pb.defaultOptions.profile and pb.defaultOptions.profile.size) or 200
    local size = defaultSize * PepeBuddy:GetPerchScale()
    perchFrame:SetSize(size, size)
    perchFrame:SetPoint("CENTER", UIParent, "CENTER", -size, 0)
    perchFrame:SetMovable(true)
    perchFrame:EnableMouse(false)
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
    perchFrame:SetBackdropColor(0, 0, 0, 0)
    perchFrame:SetBackdropBorderColor(0, 0, 0, 0)
    perchFrame:SetClipsChildren(true)

    perchHandleFrame = CreateFrame("Frame", nil, perchFrame, "BackdropTemplate")
    UpdatePerchHandleLayout(size)
    perchHandleFrame:EnableMouse(true)
    perchHandleFrame:RegisterForDrag("LeftButton")
    perchHandleFrame:SetScript("OnDragStart", function()
        perchFrame:StartMoving()
    end)
    perchHandleFrame:SetScript("OnDragStop", function()
        perchFrame:StopMovingOrSizing()
        PrintPerchBottomCenters("DragStop")
    end)
    perchHandleFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    perchHandleFrame:SetBackdropColor(0, 0, 0, 0)
    perchHandleFrame:SetBackdropBorderColor(0, 0, 0, 0)

    ApplyPepeByIndex(perchIndex)
    ApplyPerchDebugStyle()
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

function PepeBuddy:GetPerchScale()
    local defaultScale = (pb.defaultOptions and pb.defaultOptions.profile and pb.defaultOptions.profile.scale) or 1
    return (self.db and self.db.profile and self.db.profile.scale) or defaultScale
end

function PepeBuddy:SetPerchScale(scale)
    if (PepeBuddy.db and PepeBuddy.db.profile) then
        local defaultScale = (pb.defaultOptions and pb.defaultOptions.profile and pb.defaultOptions.profile.scale) or 1
        PepeBuddy.db.profile.scale = scale or defaultScale
    end
    PepeBuddy:UpdatePerchSize()
end

local function GetBottomCenterInUIParent(frame)
    if not frame then
        return nil, nil
    end

    local fs = frame:GetEffectiveScale()
    local ps = UIParent:GetEffectiveScale()
    if not fs or fs == 0 then
        fs = 1
    end
    if not ps or ps == 0 then
        ps = 1
    end

    local left = frame:GetLeft()
    local right = frame:GetRight()
    local bottom = frame:GetBottom()
    if not left or not right or not bottom then
        return nil, nil
    end

    left = left * fs / ps
    right = right * fs / ps
    bottom = bottom * fs / ps

    return (left + right) / 2, bottom
end

function PepeBuddy:UpdatePerchSize()
    if not perchFrame then
        return
    end

    local defaultSize = (pb.defaultOptions and pb.defaultOptions.profile and pb.defaultOptions.profile.size) or 200
    local size = defaultSize * self:GetPerchScale()
    local anchorX, anchorY = GetBottomCenterInUIParent(perchHandleFrame)
    if not anchorX then
        anchorX, anchorY = GetBottomCenterInUIParent(perchFrame)
    end

    if perchFrame:GetNumPoints() == 0 then
        perchFrame:SetPoint("CENTER", UIParent, "CENTER", -size, 0)
    end

    perchFrame:SetSize(size, size)
    UpdatePerchHandleLayout(size)
    if anchorX and anchorY then
        local yOffset = (40 * self:GetPerchScale()) - 5
        perchFrame:ClearAllPoints()
        perchFrame:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", anchorX, anchorY - yOffset)
    end
end

function PepeBuddy:ResetPerchToDefaults()
    local defaults = (pb.defaultOptions and pb.defaultOptions.profile) or {}
    local defaultScale = tonumber(defaults.scale) or 1
    local defaultSize = tonumber(defaults.size) or 200
    local defaultSelected = tonumber(defaults.selectedPepe) or 1

    if self.db and self.db.profile then
        self.db.profile.scale = defaultScale
        self.db.profile.selectedPepe = defaultSelected
    end

    if not perchFrame then
        CreatePerchFrame()
    end
    if not perchFrame then
        return
    end

    local size = defaultSize * defaultScale
    perchFrame:ClearAllPoints()
    perchFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    perchFrame:SetSize(size, size)
    UpdatePerchHandleLayout(size)

    self:SetPerchPepe(defaultSelected)
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

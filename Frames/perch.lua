local _, pb = ...

local perchFrame
local perchHandleFrame
local perchModel
local perchIndex = 1
local PrintPerchBottomCenters
local GetBottomCenterInUIParent

local PERCH_LAYOUT = {
    defaultSize = 200,
    handleSizeRatio = 0.25,
    handleYOffsetScale = 40,
    handleYOffsetBase = -5,
    initialPoint = { "CENTER", "CENTER" },
}

local PERCH_STYLE = {
    backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    },
    debugBorder = { 0.2, 0.85, 1, 1 },
    debugBackground = { 0, 0, 0, 0.15 },
    transparent = { 0, 0, 0, 0 },
}

local MODEL_APPLY = {
    retryDelaySeconds = 0.2,
    maxRetries = 3,
}

local debugTraceFlags = {
    modelApply = true,
    anchorMath = true,
}

local pendingPepeRetryTimer = nil
local pendingPepeRetryToken = 0

local function DebugTrace(flag, message, ...)
    if not (PepeBuddy and PepeBuddy.GetDebugMode and PepeBuddy:GetDebugMode()) then
        return
    end
    if not debugTraceFlags[flag] then
        return
    end
    if not PepeBuddy or type(PepeBuddy.Print) ~= "function" then
        return
    end

    PepeBuddy:Print(string.format("[Debug:%s] " .. message, flag, ...))
end

local function GetDefaultPerchSize()
    return tonumber(PepeBuddy:GetSettingDefault("size")) or PERCH_LAYOUT.defaultSize
end

local function ComputePerchSize(scale)
    return GetDefaultPerchSize() * scale
end

local function ComputeHandleLayout(scale, perchSize)
    local handleSize = perchSize * PERCH_LAYOUT.handleSizeRatio
    local yOffset = (PERCH_LAYOUT.handleYOffsetScale * scale) + PERCH_LAYOUT.handleYOffsetBase
    return handleSize, yOffset
end

local function GetHandleYOffset(scale, perchSize)
    local _, yOffset = ComputeHandleLayout(scale, perchSize)
    return yOffset
end

local function ApplyTransparentBackdrop(frame)
    frame:SetBackdrop(PERCH_STYLE.backdrop)
    frame:SetBackdropColor(unpack(PERCH_STYLE.transparent))
    frame:SetBackdropBorderColor(unpack(PERCH_STYLE.transparent))
end

local perchConfig = {
    cam = 0.70,
    zoom = 0.00,
    x = -0.10,
    y = -0.01,
    z = -0.95,
    alpha = 0.00, -- this affects the player model that pepe is attached to, to keep them hidden
    anim = 0, -- this and the next setting only affects the player model animations not pepe's animations
    paused = true,
}

-- Model helpers
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
        perchModel:SetFacing(PepeBuddy:GetPerchFacingSetting())
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

local function NormalizePepeIndex(index, pepes)
    local nextIndex = tonumber(index) or 1
    if nextIndex < 1 then
        nextIndex = #pepes
    elseif nextIndex > #pepes then
        nextIndex = 1
    end
    return nextIndex
end

local function EnsureModelReady()
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
    DebugTrace("modelApply", "EnsureModelReady complete")
end

local function ApplyPepeVisual(pepe)
    local applied = false
    if perchModel and pepe and type(perchModel.ApplySpellVisualKit) == "function" then
        local ok, result = pcall(perchModel.ApplySpellVisualKit, perchModel, pepe.id, false)
        applied = ok and result ~= false
    end
    return applied
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

    EnsureModelReady()

    local pepe = pepes[perchIndex]
    local applied = ApplyPepeVisual(pepe)
    DebugTrace(
        "modelApply",
        "ApplyPepeByIndex index=%d id=%d applied=%s",
        perchIndex,
        pepe.id,
        tostring(applied)
    )
    return applied
end

local function CancelPendingPepeRetry()
    if pendingPepeRetryTimer and PepeBuddy and type(PepeBuddy.CancelTimer) == "function" then
        pcall(PepeBuddy.CancelTimer, PepeBuddy, pendingPepeRetryTimer)
    end
    pendingPepeRetryTimer = nil
end

local function TryApplyPepeWithRetry(index, attempt, token, reason)
    if token ~= pendingPepeRetryToken then
        return false
    end

    local applied = ApplyPepeByIndex(index)
    if applied then
        CancelPendingPepeRetry()
        DebugTrace(
            "modelApply",
            "TryApplyPepeWithRetry success index=%d attempt=%d reason=%s",
            index,
            attempt,
            tostring(reason or "unknown")
        )
        return true
    end

    if attempt >= MODEL_APPLY.maxRetries then
        DebugTrace(
            "modelApply",
            "TryApplyPepeWithRetry failed index=%d attempts=%d reason=%s",
            index,
            attempt,
            tostring(reason or "unknown")
        )
        return false
    end

    if PepeBuddy and type(PepeBuddy.ScheduleTimer) == "function" then
        pendingPepeRetryTimer = PepeBuddy:ScheduleTimer(function()
            pendingPepeRetryTimer = nil
            TryApplyPepeWithRetry(index, attempt + 1, token, reason)
        end, MODEL_APPLY.retryDelaySeconds)
        DebugTrace(
            "modelApply",
            "TryApplyPepeWithRetry scheduled retry index=%d nextAttempt=%d reason=%s",
            index,
            attempt + 1,
            tostring(reason or "unknown")
        )
        return false
    end

    DebugTrace("modelApply", "TryApplyPepeWithRetry has no timer API; giving up")
    return false
end

-- Style helpers
-- helper you can call whenever debugMode changes
local function ApplyPerchDebugStyle()
    if not perchFrame then
        return
    end

    local debugMode = PepeBuddy and PepeBuddy.GetDebugMode and PepeBuddy:GetDebugMode()
    if debugMode then
        perchFrame:SetBackdropColor(unpack(PERCH_STYLE.debugBackground))
        perchFrame:SetBackdropBorderColor(unpack(PERCH_STYLE.debugBorder))
    else
        perchFrame:SetBackdropColor(unpack(PERCH_STYLE.transparent))
        perchFrame:SetBackdropBorderColor(unpack(PERCH_STYLE.transparent))
    end

    if perchHandleFrame then
        perchHandleFrame:SetBackdropColor(unpack(PERCH_STYLE.transparent))
        if debugMode then
            perchHandleFrame:SetBackdropBorderColor(unpack(PERCH_STYLE.debugBorder))
        else
            perchHandleFrame:SetBackdropBorderColor(unpack(PERCH_STYLE.transparent))
        end
    end
end

function PepeBuddy:ApplyPerchDebugStyle()
    ApplyPerchDebugStyle()
end

local function UpdatePerchMovableState()
    if not perchFrame then
        return
    end

    local isMovable = PepeBuddy:GetPerchMovable()
    perchFrame:SetMovable(isMovable)

    if perchHandleFrame then
        perchHandleFrame:EnableMouse(isMovable)
        if isMovable then
            perchHandleFrame:RegisterForDrag("LeftButton")
        else
            perchHandleFrame:RegisterForDrag()
        end
    end
end

-- Layout helpers
local function UpdatePerchHandleLayout(size)
    if not perchHandleFrame or not perchFrame then
        return
    end

    local scale = PepeBuddy:GetPerchScale()
    local handleSize, yOffset = ComputeHandleLayout(scale, size)

    perchHandleFrame:SetPoint("BOTTOM", perchFrame, "BOTTOM", 0, yOffset)
    perchHandleFrame:SetSize(handleSize, handleSize)
end

local function GetCurrentPerchAnchor()
    local anchorX, anchorY = GetBottomCenterInUIParent(perchHandleFrame)
    if not anchorX then
        anchorX, anchorY = GetBottomCenterInUIParent(perchFrame)
    end
    if not anchorX or not anchorY then
        return nil
    end

    return anchorX, anchorY
end

local function SavePerchPosition(reason)
    local anchorX, anchorY = GetCurrentPerchAnchor()
    if not anchorX or not anchorY then
        return
    end

    PepeBuddy:SetPerchPositionSetting({
        x = anchorX,
        y = anchorY,
    })
    DebugTrace(
        "anchorMath",
        "SavePerchPosition reason=%s anchor=(%.2f,%.2f)",
        tostring(reason or "unknown"),
        anchorX,
        anchorY
    )
end

local function RestorePerchPosition(size)
    local position = PepeBuddy:GetPerchPositionSetting()
    if not position then
        return false
    end

    local scale = PepeBuddy:GetPerchScale()
    local yOffset = GetHandleYOffset(scale, size)
    perchFrame:ClearAllPoints()
    perchFrame:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", position.x, position.y - yOffset)
    return true
end

local function EnsurePerchFrameCreated(size)
    if perchFrame then
        return
    end

    perchFrame = CreateFrame("Frame", "PepeBuddyPerchFrame", UIParent, "BackdropTemplate")
    perchFrame:SetSize(size, size)
    if not RestorePerchPosition(size) then
        perchFrame:SetPoint(PERCH_LAYOUT.initialPoint[1], UIParent, PERCH_LAYOUT.initialPoint[2], 0, 0)
    end
    perchFrame:SetMovable(true)
    perchFrame:EnableMouse(false)
    perchFrame:SetScript("OnShow", function()
        PepeBuddy:ApplyPerchState("OnShow")
        PepeBuddy:StartPerchRefresh()
    end)
    perchFrame:SetScript("OnHide", function()
        PepeBuddy:StopPerchRefresh()
    end)
    ApplyTransparentBackdrop(perchFrame)
    perchFrame:SetClipsChildren(true)
end

local function EnsurePerchHandleCreated(size)
    if perchHandleFrame then
        return
    end

    perchHandleFrame = CreateFrame("Frame", nil, perchFrame, "BackdropTemplate")
    UpdatePerchHandleLayout(size)
    perchHandleFrame:EnableMouse(true)
    perchHandleFrame:RegisterForDrag("LeftButton")
    perchHandleFrame:SetScript("OnDragStart", function()
        perchFrame:StartMoving()
    end)
    perchHandleFrame:SetScript("OnDragStop", function()
        perchFrame:StopMovingOrSizing()
        SavePerchPosition("DragStop")
        PrintPerchBottomCenters("DragStop")
    end)
    ApplyTransparentBackdrop(perchHandleFrame)
end

local function CreatePerchFrame()
    if perchFrame then
        return
    end

    local size = ComputePerchSize(PepeBuddy:GetPerchScale())
    EnsurePerchFrameCreated(size)
    EnsurePerchHandleCreated(size)

    ApplyPepeByIndex(perchIndex)
    ApplyPerchDebugStyle()
end

-- State application and public API
function PepeBuddy:ApplyPerchState(reason)
    if not perchFrame then
        CreatePerchFrame()
    end

    self:UpdatePerchMovable()
    self:UpdatePerchSize()
    self:ApplyPerchDebugStyle()
    self:SetPerchPepe(self:GetSelectedPepeSetting())

    DebugTrace("modelApply", "ApplyPerchState reason=%s", tostring(reason or "unknown"))
end

function PepeBuddy:InitializePerch()
    CreatePerchFrame()
    self:ApplyPerchState("InitializePerch")
    perchFrame:Hide()
    self.perchFrame = perchFrame
end

function PepeBuddy:SetPerchPepe(index, reason)
    local pepes = pb.pepes or {}
    if #pepes == 0 then
        return
    end

    local nextIndex = NormalizePepeIndex(index, pepes)

    self:SetSelectedPepeSetting(nextIndex)

    if not perchFrame then
        CreatePerchFrame()
    end

    pendingPepeRetryToken = pendingPepeRetryToken + 1
    local token = pendingPepeRetryToken
    CancelPendingPepeRetry()
    TryApplyPepeWithRetry(nextIndex, 0, token, reason or "SetPerchPepe")
end

function PepeBuddy:GetPerchScale()
    return self:GetPerchScaleSetting()
end

function PepeBuddy:GetPerchMovable()
    return self:GetPerchMovableSetting()
end

function PepeBuddy:SetPerchMovable(isMovable)
    self:SetPerchMovableSetting(isMovable)
    self:UpdatePerchMovable()
    self:ApplyPerchDebugStyle()
end

function PepeBuddy:SetPerchScale(scale)
    self:SetPerchScaleSetting(scale)
    self:UpdatePerchSize()
    self:ApplyPerchDebugStyle()
end

function PepeBuddy:GetPerchFacing()
    return self:GetPerchFacingSetting()
end

function PepeBuddy:SetPerchFacing(facing)
    self:SetPerchFacingSetting(facing)
    self:UpdatePerchFacing()
    self:ApplyPerchDebugStyle()
end

GetBottomCenterInUIParent = function(frame)
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

PrintPerchBottomCenters = function(tag)
    local perchX, perchY = GetBottomCenterInUIParent(perchFrame)
    local handleX, handleY = GetBottomCenterInUIParent(perchHandleFrame)
    DebugTrace(
        "anchorMath",
        "%s perch=(%s,%s) handle=(%s,%s)",
        tag or "event",
        perchX and string.format("%.2f", perchX) or "nil",
        perchY and string.format("%.2f", perchY) or "nil",
        handleX and string.format("%.2f", handleX) or "nil",
        handleY and string.format("%.2f", handleY) or "nil"
    )
end

function PepeBuddy:UpdatePerchFacing()
    if not perchModel then
        return
    end

    if type(perchModel.SetFacing) == "function" then
        perchModel:SetFacing(PepeBuddy:GetPerchFacingSetting())
    end
end

function PepeBuddy:UpdatePerchMovable()
    UpdatePerchMovableState()
end

function PepeBuddy:UpdatePerchSize()
    if not perchFrame then
        return
    end

    local scale = self:GetPerchScale()
    local size = ComputePerchSize(scale)
    local anchorX, anchorY = GetCurrentPerchAnchor()
    DebugTrace(
            "anchorMath",
            "UpdatePerchSize begin scale=%.2f size=%.2f anchor=(%s,%s)",
            scale,
            size,
            anchorX and string.format("%.2f", anchorX) or "nil",
            anchorY and string.format("%.2f", anchorY) or "nil"
    )

    if perchFrame:GetNumPoints() == 0 then
        perchFrame:SetPoint("CENTER", UIParent, "CENTER", -size, 0)
    end

    perchFrame:SetSize(size, size)
    UpdatePerchHandleLayout(size)
    if anchorX and anchorY then
        local yOffset = GetHandleYOffset(scale, size)
        perchFrame:ClearAllPoints()
        perchFrame:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", anchorX, anchorY - yOffset)
        SavePerchPosition("UpdatePerchSize")
    end
    PrintPerchBottomCenters("UpdatePerchSize")
end

function PepeBuddy:ResetPerchToDefaults()
    local defaultMovable = self:GetSettingDefault("isMovable") and true or false
    local defaultScale = tonumber(self:GetSettingDefault("scale")) or 1
    local defaultFacing = tonumber(self:GetSettingDefault("facing")) or 0
    local defaultSelected = tonumber(self:GetSettingDefault("selectedPepe")) or 1

    self:SetPerchMovableSetting(defaultMovable)
    self:SetPerchScaleSetting(defaultScale)
    self:SetPerchFacingSetting(defaultFacing)
    self:SetSelectedPepeSetting(defaultSelected)

    if not perchFrame then
        CreatePerchFrame()
    end
    if not perchFrame then
        return
    end

    local size = ComputePerchSize(defaultScale)
    perchFrame:ClearAllPoints()
    perchFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    perchFrame:SetSize(size, size)
    UpdatePerchHandleLayout(size)
    self:SetPerchPositionSetting(nil)
    self:UpdatePerchMovable()

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
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPerchRefreshEvent")
    self:RegisterEvent("UNIT_MODEL_CHANGED", "OnPerchRefreshEvent")
end

function PepeBuddy:StopPerchRefresh()
    if not self._perchRefreshActive then
        return
    end

    self._perchRefreshActive = false
    CancelPendingPepeRetry()
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

    self:ApplyPerchState("OnPerchRefreshEvent")
end

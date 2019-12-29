-- the keys into the pepe table
local keys = {
	"default",
	"knight",
	"pirate",
	"ninja",
	"viking",
	"scarecrow",
	"traveler",
	"illidari",
	"sucba",
	"tiki",
	"p3p3"
}

-- All of the current different flavors of Pepe!
local pepes = {
	["default"] = 1041861,
	["knight"] = 1131783,
	["pirate"] = 1131795,
	["ninja"] = 1131797,
	["viking"] = 1131798,
	["scarecrow"] = 1246563,
	["traveler"] = 1386540,
	["illidari"] = 1534076,
	["sucba"] = 1859375,
	["tiki"] = 1861550,
	["p3p3"] = 3011956
}

-- total max pepes
local maxPepes = 11
-- model used for the feather poof effect
local feathers = 1045240 --"spells/garrison_orangebird_impact.m2"
-- total time lapsed for the feather poof animation
local timeLapsed = 0
-- default size
local defaultSize = 300
-- debug boolean
local debugging = false

local backdrop = {
	-- path to the background texture
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
	-- path to the border texture
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	-- true to repeat the background texture to fill the frame, false to scale it
	tile = true,
	-- size (width or height) of the square repeating background tiles (in pixels)
	tileSize = 32,
	-- thickness of edge segments and square size of edge corners (in pixels)
	edgeSize = 32,
	-- distance from the edges of the frame to those of the background texture (in pixels)
	insets = {
		left = 11,
		right = 12,
		top = 12,
		bottom = 11
	}
}
--- Frames ---
local mainFrame = CreateFrame("Frame", "PepeMainFrame", UIParent)
mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
mainFrame:SetSize(100, 100)
if debugging then
	mainFrame:SetBackdrop(backdrop)
	mainFrame:SetPoint("Center")
end
mainFrame:SetMovable(true)
mainFrame:SetUserPlaced(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")

local function SetMoveable()
	if IsMovable then
		print("Pepe is unlocked.")
		mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
		mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
	else
		print("Pepe is locked.")
		mainFrame:SetScript("OnDragStart", nil)
		mainFrame:SetScript("OnDragStop", nil)
	end
end

local costumePepeModelFrame = CreateFrame("PlayerModel", "CostumePepe", mainFrame)
costumePepeModelFrame:SetPoint("CENTER", mainFrame, "CENTER")

local defaultPepeModelFrame = CreateFrame("PlayerModel", "DefaultPepe", mainFrame)
defaultPepeModelFrame:SetPoint("CENTER", mainFrame, "CENTER")

local feathersModelFrame = CreateFrame("PlayerModel", "Feathers", mainFrame)
feathersModelFrame:SetPoint("CENTER", mainFrame, "CENTER")
feathersModelFrame:RegisterAllEvents()

local function OnEventHandler(self, event, arg1, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		if CurrentPepe == nil then
			CurrentPepe = "default"
			RestPepe()
		end
		if CurrentSize == nil then
			CurrentSize = defaultSize
		end
		if IsMovable == nil then
			IsMovable = true
		end

		DebugPrint("CurrentPepe: ", CurrentPepe)
		DebugPrint("CurrentSize: ", CurrentSize)

		Setup()
	end
end

local function OnMouseUpHandler(self, button)
	if IsShiftKeyDown() then
		if button == "LeftButton" then
			IsMovable = not IsMovable
			SetMoveable()
		end
	end
	if IsMovable and button == "RightButton"  then
		RotatePepes()
	end
end

local function OnShowHandler(self)
	DebugPrint("Main Frame Shown.")
	SetPepe(CurrentPepe)
end

mainFrame:SetScript("OnMouseUp", OnMouseUpHandler)
mainFrame:SetScript("OnEvent", OnEventHandler)
mainFrame:SetScript("OnShow", OnShowHandler)

--- Event Hanlder for the OnUpdate event for the Feather Poof Model.
-- @param self Feather Poof Model
-- @param elapsed Time elapsed since last call
--
local function FeathersOnUpdate(self, elapsed)
	-- if the model is currently visible
	if (self:IsVisible()) then
		-- add the total time lapsed up.
		timeLapsed = timeLapsed + elapsed
		-- when time lapsed gets to 1.5 seconds then
		if (timeLapsed > 2) then
			-- hide the feather poof model.
			self:Hide()
			-- reset the time lapsed to 0 for the next time it appears.
			timeLapsed = 0
		end
	end
end

feathersModelFrame:SetScript("OnUpdate", FeathersOnUpdate)

---
-- Gets the next key from the key list
function GetNextKey()
	for i,key in ipairs(keys) do
		if (key == CurrentPepe) then
			if ((i+1) > maxPepes) then
				return keys[1]
			else
				return keys[i+1]
			end
		end
	end
end

function Setup()
	-- Set the size of the frame to the last used size.
	SetSize()
	-- setup the costumed pepe.
	costumePepeModelFrame:SetCamera(0)
	costumePepeModelFrame:SetPosition(0,0,0)
	-- setup the default pepe
	defaultPepeModelFrame:SetCamera(1)
	defaultPepeModelFrame:SetPosition(-1,0,0)
	-- set the size for the feathers
	feathersModelFrame:SetCamera(0)
	feathersModelFrame:SetPosition(-0.2,0,0)
	SetPepe(CurrentPepe)
	SetMoveable()
end

function SetSize()
	costumePepeModelFrame:SetSize(CurrentSize, CurrentSize)
	defaultPepeModelFrame:SetSize(CurrentSize, CurrentSize)
	feathersModelFrame:SetSize(CurrentSize, CurrentSize)
	mainFrame:SetSize(CurrentSize/4, CurrentSize/4)
end


--- Sets the current Pepe
-- @param pepeIndex which pepe to set
--
function SetPepe(pepeIndex)
	-- remember the pepeIndex
	CurrentPepe = pepeIndex
	-- gets the pepe model from the pepe table
	local pepe = pepes[pepeIndex]
	if pepeIndex == "default" then
		-- gets the pepe model from the pepe table
		local defaultPepe = pepes["default"]
		-- sets the default Pepe Viewer to the default pepe.
		defaultPepeModelFrame:SetModel(defaultPepe)
	else
		-- gets the pepe model from the pepe table
		local pepe = pepes[pepeIndex]
		-- sets the PepeModel Viewer to the current pepe.
		costumePepeModelFrame:SetModel(pepe)
	end
	-- Shows the model.
	defaultPepeModelFrame:Show()
	costumePepeModelFrame:Show()

	if pepeIndex == "default" then
		defaultPepeModelFrame:SetAlpha(1.0)
		costumePepeModelFrame:SetAlpha(0.0)
	else
		defaultPepeModelFrame:SetAlpha(0.0)
		costumePepeModelFrame:SetAlpha(1.0)
	end
end

--- Shows the Feather Poof Animation
--
function FeatherPoof()
	feathersModelFrame:SetModelByFileID(feathers)
	feathersModelFrame:Show()
end

--- Reshows the pepe model
-- Also causes a feather poof and a chirp.
function ShowPepe()
	SetPepe(CurrentPepe)
	FeatherPoof()
	Chirp()
end

function RotatePepes()
	CurrentPepe = GetNextKey()
	DebugPrint("Pepe Rotated to ",CurrentPepe)
	ShowPepe()
end

function Chirp()
	PlaySound(48236)
end

function RestPepe()
	CurrentPepe = "default"
	IsMovable = true
	mainFrame:SetPoint("CENTER")
	mainFrame:Show()
	SetMoveable()
	ShowPepe()
end


function DebugPrint(...)
	if (debugging) then
		print(...)
	end
end

-------------------
--- Slash Commands
-------------------
SLASH_PEPE1 = "/pepe"
SLASH_PEPESET1 = "/pepeset"
SLASH_PEPERESET1 = "/pepereset"
SLASH_PEPESHOW1 = "/pepeshow"
SLASH_PEPEHIDE1 = "/pepehide"
SLASH_PEPELOCK1 = "/pepelock"

--- Sets the size of pepe
-- @param input the size of the width to set
-- @param EditBox Not used
--
SlashCmdList["PEPESET"] = function(input, EditBox)
	local PS = tonumber(input)
	if PS == nil then
		print("Invalid Input: use /pepeset ###")
	else
		CurrentSize = PS
		SetSize()
	end
end

--- Sets the Pepe model
-- @param input the model to set by key name
-- @param EditBox not used
--
SlashCmdList["PEPE"] = function(input, EditBox)
	local pepeIndex = string.lower(input)
	local pepe = pepes[pepeIndex]
	if pepeIndex == nil or pepe == nil then
		print("PepeBuddy:\n",
			"  use '/pepe <default, knight, ninja, pirate, viking, scarecrow, traveler, illidari, sucba, tiki>' to change the pepe's costume or right click on pepe.\n",
			"  use '/pepeset ###' to set pepe's size.",
			"  use '/pepereset' to reset to the defaults or if pepe flies away!\n",
			"  use '/pepeshow' to show pepe if he has been hidden.\n",
			"  use '/pepehide' to hide pepe.\n",
			"  use '/pepelock' to lock pepe and prevent him from moving or changing costumes.\n"
		)
	else
		CurrentPepe = pepeIndex
		ShowPepe()
	end
end

--- Resets the pepe to the default pepe
SlashCmdList["PEPERESET"] = function()
	RestPepe()
end

--- Show Pepe if he was hidden
SlashCmdList["PEPESHOW"] = function()
	if (mainFrame:IsVisible() == false) then
		mainFrame:Show()
		FeatherPoof()
		Chirp()
	end
end

--- Hides Pepe
SlashCmdList["PEPEHIDE"] = function()
	mainFrame:Hide()
	Chirp()
end

--- Locks and Unlocks Pepe's Moving Frame
SlashCmdList["PEPELOCK"] = function()
	IsMovable = not IsMovable
	SetMoveable()
end

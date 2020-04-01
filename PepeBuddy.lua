local AceGUI = LibStub('AceGUI-3.0')
local minimapIcon = LibStub("LibDBIcon-1.0");
local ADDON_NAME, ADDON_TABLE = ...
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local addoninfo = 'Version: ' .. version

---------------------------------------------------------
-- Addon declaration

PepeBuddy = LibStub('AceAddon-3.0'):NewAddon('PepeBuddy', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

---------------------------------------------------------
-- Vars

PepeBuddy.keys = {
	"default",
	"viking",
	"pirate",
	"knight",
	"ninja",
	"scarecrow",
	"traveler",
	"demonhunter",
	"diver",
	"pepejin",
	"clockwork",
	"greatfather"
}

PepeBuddy.pepesDropdown = {
	["default"] = 'Pepe',
	["viking"] = 'Viking Pepe',
	["pirate"] = 'Pirate Pepe',
	["knight"] = 'Knight Pepe',
	["ninja"] = 'Ninja Pepe',
	["scarecrow"] = "Hallow's End Pepe",
	["traveler"] = 'Traveler Pepe',
	["demonhunter"] = 'Demon Hunter Pepe',
	["diver"] = 'Diver Pepe',
	["pepejin"] = "Pepe'jin",
	["clockwork"] = 'Clockwork Pepe',
	["greatfather"] = 'Greatfather Pepe'
}

PepeBuddy.pepes = {
	['default'] = {
		name = 'Pepe',
		modelId = 1041861,
		icon = 1044996,
		obtainBy = {
			toy = true,
			hiddenQuest = false,
		},
		toyInfo = {
			name = 'Trans-Dimensional Bird Whistle',
			achievementId = 9838,
			itemId = 122293,
			spellId = 181943,
		},
		hiddenQuestInfo = {
		},
	},
	['viking'] = {
		name = 'Viking Pepe',
		modelId = 1131798,
		icon = 669453,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Viking Helmet',
			questId = 39265,
			itemId = 127865,
			spellId = 188226,
		},
	},
	['pirate'] = {
		name = 'Pirate Pepe',
		modelId = 1131795,
		icon = 133168,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Pirate Hat',
			questId = 39268,
			itemId = 127870,
			spellId = 188241,
		},
	},
	['knight'] = {
		name = 'Knight Pepe',
		modelId = 1131783,
		icon = 133833,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {

			name = 'A Tiny Plated Helm',
			questId = 39266,
			itemId = 127869,
			spellId = 188239,
		},
	},
	['ninja'] = {
		name = 'Ninja Pepe',
		modelId = 1131797,
		icon = 133183,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Ninja Shroud',
			questId = 39267,
			itemId = 127867,
			spellId = 188230,
		},
	},
	['scarecrow'] = {
		name = 'Scarecrow Pepe',
		modelId = 1246563,
		icon = 658632,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Scarecrow Costume',
			questId = 39865,
			itemId = 128874,
			spellId = 192472,
			achievementId = 10365,
		},
	},
	['traveler'] = {
		name = 'Traveler Pepe',
		modelId = 1386540,
		icon = 133023,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Pair of Goggles',
			questId = 43695,
			itemId = 139632,
			spellId = 221346,
			achievementId = 10770,
		},
	},
	['demonhunter'] = {
		name = 'Demon Hunter Pepe',
		modelId = 1534076,
		icon = 1612573,
		obtainBy = {
			toy = true,
			hiddenQuest = false,
		},
		toyInfo = {
			name = 'A Tiny Set of Warglaives',
			achievementId = 11772,
			itemId = 147537,
			spellId = 242014,
		},
		hiddenQuestInfo = {
		},
	},
	['diver'] = {
		name = 'Diver Pepe',
		modelId = 1859375,
		icon = 133151,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Diving Helmet',
			questId = 52277,
			itemId = 161451,
			spellId = 275446,
		},
	},
	['pepejin'] = {
		name = "Pepe'jin",
		modelId = 1861550,
		icon = 135462,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Voodoo Mask',
			questId = 52269,
			itemId = 161443,
			spellId = 275369,
		},
	},
	['clockwork'] = {
		name = "Clockwork Pepe",
		modelId = 3011956,
		icon = 348541,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Clockwork Key',
			questId = 56911,
			itemId = 170151,
			spellId = 303990,
		},
	},
	['greatfather'] = {
		name = "Greatfather Pepe",
		modelId = 3209343,
		icon = 1339669,
		obtainBy = {
			toy = false,
			hiddenQuest = true,
		},
		toyInfo = {
		},
		hiddenQuestInfo = {
			name = 'A Tiny Winter Hat',
			questId = 58901,
			itemId = 174865,
			spellId = 316934,
		},
	},
}

local defaultOptions = {
	profile = {
		disabledInfo = true,
		isMovable = true,
		size = 1,
		model = 'default',
		minimapIcon = {
			hide = false,
		},
	}
}

local options = {
	type = 'group',
	name = 'Pepe Buddy',
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
			name = addoninfo,
		},
		spacer3 = {
			type = "description",
			width = "full",
			order = 3,
			name = "\n\n",
		},
		minimapIcon = {
			name = 'Hide mini-map icon',
			type = 'toggle',
			width = 'double',
			order = 4,
			set = function(info, val)
				PepeBuddy.db.profile.minimapIcon.hide = val
				if PepeBuddy.db.profile.minimapIcon.hide then
					minimapIcon:Hide("PepeBuddyLDBI")
				else
					minimapIcon:Show("PepeBuddyLDBI")
				end
			end,
			get = function(info) return PepeBuddy.db.profile.minimapIcon.hide end
		},
		isMovable = {
			name = 'Unlock Pepe',
			desc = 'Makes pepe movable.',
			type = 'toggle',
			width = 'double',
			order = 5,
			set = function(info, val)
				PepeBuddy.db.profile.isMovable = val
			end,
			get = function(info) return PepeBuddy.db.profile.isMovable end
		},
		model = {
			name = 'Which Pepe',
			desc = 'Choose which Pepe you wish to have on your UI.',
			type = 'select',
			values =  PepeBuddy.pepesDropdown,
			sorting = PepeBuddy.keys,
			set = function(info, val)
				PepeBuddy.db.profile.model = val
				PepeBuddy:SetPepe(PepeBuddy.db.profile.model)
			end,
			get = function(info)
				return PepeBuddy.db.profile.model
			end,
			style = 'dropdown',
			width = 'full',
			order = 6,
		},
		size = {
			name = 'Size',
			desc = 'How large Pepe should be in pixels.',
			type = 'range',
			min = 0.5,
			max = 8,
			step = 0.05,
			isPercent = true,
			width = 'double',
			order = 7,
			set = function(info, val)
				PepeBuddy.db.profile.size = val
				PepeBuddy:UpdatePepeSize()
			end,
			get = function(info) return PepeBuddy.db.profile.size end
		},
		reset = {
			name = 'Reset',
			type = 'execute',
			width = 'normal',
			order = 8,
			func = function()
				PepeBuddy:Reset()
			end,
		},
		spacer3 = {
			type = "description",
			width = "full",
			order = 9,
			name = "\n\n",
		},
	},
}


--moreoptions={
--	name = function(info)
--		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
--		itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
--		isCraftingReagent = GetItemInfo(122293)
--		return string.format("Costumes known for %s.", itemLink)
--	end,
--	type = "group",
--	inline = true,
--	args={
--		costume01 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(39265)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188226)
--				local link = GetSpellLink(188226);
--				return string.format("%s is %s.", link, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188226)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 1,
--		},
--		costume02 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(39267)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188230)
--				return string.format("%s is %s.", name, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188230)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 2,
--		},
--		costume03 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(39266)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188239)
--				return string.format("%s is %s.", name, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188239)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 3,
--		},
--		costume04 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(39268)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188241)
--				return string.format("%s is %s.", name, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(188241)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 4,
--		},
--		costume05 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (PlayerHasToy(147537)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				--local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(242014)
--				local itemID, toyName, icon, isFavorite, hasFanfare, itemQuality = C_ToyBox.GetToyInfo(147537)
--				return string.format("%s is %s.", toyName, isKnown)
--			end,
--			image = function(info)
--				--local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(242014)
--				local itemID, toyName, icon, isFavorite, hasFanfare, itemQuality = C_ToyBox.GetToyInfo(147537)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 5,
--		},
--		costume06 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(43695)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(221346)
--				return string.format("%s is %s.", name, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(221346)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 6,
--		},
--		costume07 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(52277)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(275446)
--				return string.format("%s is %s.", name, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(275446)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 7,
--		},
--		costume08 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(52269)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(275369)
--				return string.format("%s is %s.", name, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(275369)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 8,
--		},
--		costume09 = {
--			name = function(info)
--				local isKnown = "|cffFF0000unknown|r"
--				if (IsQuestFlaggedCompleted(56911)) then
--					isKnown = "|cff00FF00known|r"
--				end
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(303990)
--				return string.format("%s is %s.", name, isKnown)
--			end,
--			image = function(info)
--				local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(303990)
--				return icon, 24, 24
--			end,
--			type = 'description',
--			width = 'double',
--			order = 9,
--		},
--	},
--},

PepeBuddy.minimapIconDB = LibStub("LibDataBroker-1.1"):NewDataObject("PepeBuddyLDB", {
	type = "data source",
	text = "None",
	label = "Pepe Buddy",
	icon = PepeBuddy.pepes['default'].icon,
	tocname = "PepeBuddy",
	OnClick = function(self, button)
		if (button == "LeftButton") then
			PepeBuddy:ShowConfig()
		end
	end,
	OnTooltipShow = function(tooltip)
		tooltip:AddDoubleLine("|cffFFFFFFPepe Buddy|r", "|cff33FF99"..addoninfo.."|r");
		tooltip:AddLine(" ");
		tooltip:AddLine("Click Pepe will:")
		tooltip:AddLine("|cffC79C6EShift Left-Click:|r |cff33FF99Toggle Pepe Lock.|r")
		tooltip:AddLine("|cffC79C6EShift Right-Click:|r |cff33FF99Use the Pepe Toy.|r")
		tooltip:AddLine("|cffC79C6EMiddle-Click:|r |cff33FF99Open the configuration panel.|r")
		tooltip:AddLine(" ")
		tooltip:AddLine("|cffC79C6EClick Minimap Button:|r |cff33FF99Open the configuration panel.|r")
	end,
})

---------------------------------------------------------
-- functions

PepeBuddy.DefaultPrint = PepeBuddy.Print
function PepeBuddy:Print(...)
	if PepeBuddy.db.profile.disabledInfo then
		return
	end
	PepeBuddy:DefaultPrint(...)
end

function PepeBuddy:OnInitialize()
	LibStub('AceConfig-3.0'):RegisterOptionsTable('PepeBuddy', options, {'pepebudy', 'pepe'})
	PepeBuddy.db = LibStub('AceDB-3.0'):New('PepeBuddyPreferences', defaultOptions)
	PepeBuddy.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('PepeBuddy', 'Pepe Buddy')
	minimapIcon:Register("PepeBuddyLDBI", PepeBuddy.minimapIconDB, PepeBuddy.db.profile.minimapIcon)
	if PepeBuddy.db.profile.minimapIcon.hide then
		minimapIcon:Hide("PepeBuddyLDBI")
	else
		minimapIcon:Show("PepeBuddyLDBI")
	end
	PepeBuddy:Setup()
end

function PepeBuddy:OnEnable()
	PepeBuddy:RegisterEvent('PLAYER_ENTERING_WORLD')
	PepeBuddy:Print('PepeBuddy Initialized')
	PepeBuddy:ShowPepe()
end

function PepeBuddy:OnDisable()
	-- Called when the addon is disabled
end

function PepeBuddy:Chirp()
	PlaySound(48236)
end

function PepeBuddy:UpdatePepeSize()
	local size = PepeBuddy.db.profile.size * 500
	PepeBuddy.mainFrame:SetSize(size/4, size/4)
	PepeBuddy.pepeModelFrame:SetSize(size, size)
end

function PepeBuddy:ShowPepe()
	PepeBuddy.mainFrame:Show()
	PepeBuddy.pepeModelFrame:Show()
end

function PepeBuddy:SetPepe(pepeKey)
	PepeBuddy.pepeModelFrame:SetModel(PepeBuddy.pepes[pepeKey].modelId)

	if pepeKey == "default" then
		PepeBuddy.pepeModelFrame:SetCamera(1)
		PepeBuddy.pepeModelFrame:SetPosition(-1,0,0)
	else
		PepeBuddy.pepeModelFrame:SetCamera(0)
		PepeBuddy.pepeModelFrame:SetPosition(0,0,0)
	end
	-- setup the default pepe
	PepeBuddy:Chirp()
end

function PepeBuddy:HidePepe()
	PepeBuddy.mainFrame:Hide()
	PepeBuddy.pepeModelFrame:Hide()
end

function PepeBuddy:Reset()
	PepeBuddy.db.profile.isMovable = true
	PepeBuddy.db.profile.size = 1
	PepeBuddy.db.profile.model = "default"
	PepeBuddy.mainFrame:SetPoint("CENTER")
	PepeBuddy.pepeModelFrame:SetPoint("CENTER", PepeBuddy.mainFrame, "CENTER")
	PepeBuddy:SetPepe(PepeBuddy.db.profile.model)
	PepeBuddy:UpdatePepeSize()
	PepeBuddy:ShowPepe()
end

function PepeBuddy:Setup()
	--- Frames ---
	PepeBuddy.mainFrame = CreateFrame("Frame", "PepeBuddyMainFrame", UIParent)
	PepeBuddy.mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	PepeBuddy.mainFrame:SetMovable(true)
	PepeBuddy.mainFrame:SetUserPlaced(true)
	PepeBuddy.mainFrame:SetClampedToScreen(true)
	PepeBuddy.mainFrame:RegisterForDrag("LeftButton")
	PepeBuddy.mainFrame:SetScript("OnMouseUp", OnMouseUpHandler)
	PepeBuddy.mainFrame:SetScript("OnEvent", OnEventHandler)
	PepeBuddy.mainFrame:SetScript("OnShow", OnShowHandler)
	PepeBuddy.mainFrame:SetScript("OnDragStart", function(self)
		if PepeBuddy.db.profile.isMovable then
			PepeBuddy.mainFrame:StartMoving()
		end
	end)
	PepeBuddy.mainFrame:SetScript("OnDragStop", PepeBuddy.mainFrame.StopMovingOrSizing)
	PepeBuddy.mainFrame:EnableMouse(true)

	PepeBuddy.pepeModelFrame = CreateFrame("PlayerModel", "PepeModelFrame", PepeBuddy.mainFrame)

	PepeBuddy.pepeModelFrame:SetPoint("CENTER", PepeBuddy.mainFrame, "CENTER")
	PepeBuddy.pepeModelFrame:SetCamera(1)
	PepeBuddy:SetPepe(PepeBuddy.db.profile.model)
	PepeBuddy:UpdatePepeSize()
	PepeBuddy:ShowPepe()
end

function PepeBuddy:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(PepeBuddy.optionsFrame)
	InterfaceOptionsFrame_OpenToCategory(PepeBuddy.optionsFrame)
end

function PepeBuddy:PLAYER_ENTERING_WORLD()
	PepeBuddy:ShowPepe()
end

function OnEventHandler(self, event, arg1, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		PepeBuddy:ShowPepe()
	end
end

function OnMouseUpHandler(self, button)
	if button == "MiddleButton"  then
		PepeBuddy:ShowConfig()
	end
	if IsShiftKeyDown() then
		if button == "LeftButton" then
			PepeBuddy.db.profile.isMovable = not PepeBuddy.db.profile.isMovable
		end
		if button == "RightButton" then
			if PlayerHasToy(122293) then
				UseToy(122293)
			end
		end
	end
end

function OnShowHandler(self)
	PepeBuddy:Print("Main Frame Shown.")
	PepeBuddy:SetPepe(PepeBuddy.db.profile.model)
end

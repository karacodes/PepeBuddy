local AceGUI = LibStub('AceGUI-3.0')
local minimapIcon = LibStub("LibDBIcon-1.0");
local ADDON_NAME, ADDON_TABLE = ...
local addonName = ADDON_NAME
local GetMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local version = (GetMeta and GetMeta(addonName, "Version")) or "Unknown"
local addoninfo = 'Version: ' .. version

---------------------------------------------------------
-- Addon declaration

PepeBuddy = LibStub('AceAddon-3.0'):NewAddon('PepeBuddy', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

---------------------------------------------------------
-- Vars

local ObtainBy = {
	TOY = "toy",
	HIDDEN_QUEST = "hiddenQuest",
	RENOWN = "renown",
}

local DEBUG_UI = false

PepeBuddy.pepes = {
	['default'] = {
		sort = 1,
		name = 'Pepe',
		modelFileId = 1041861,
		displayId = 59624,
		icon = "Interface\\Icons\\icon_orangebird_toy",
		wowheadUrl = "https://www.wowhead.com/item=122293/trans-dimensional-bird-whistle",
		camera = 0,
		position = { -0.500, 0.000, -0.100 },
		facing = 0.000,
		camDistanceScale = 1.0,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.TOY,
			name = 'Trans-Dimensional Bird Whistle',
			achievementId = 9838,
			itemId = 122293,
			spellId = 181943,
		},
	},
	['viking'] = {
		sort = 2,
		name = 'Viking Pepe',
		modelFileId = 1131798,
		displayId = 1131798,
		icon = "Interface\\Icons\\inv_helm_misc_vikingpartyhat",
		wowheadUrl = "https://www.wowhead.com/item=127865/a-tiny-viking-helmet",
		camera = 0,
		position = { -0.500, 0.016, -0.248 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Viking Helmet',
			questId = 39265,
			itemId = 127865,
			spellId = 188226,
		},
	},
	['pirate'] = {
		sort = 3,
		name = 'Pirate Pepe',
		modelFileId = 1131795,
		displayId = 1131795,
		icon = "Interface\\Icons\\inv_helmet_66",
		wowheadUrl = "https://www.wowhead.com/item=127870/a-tiny-pirate-hat",
		camera = 0,
		position = { -0.500, -0.047, -0.220 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Pirate Hat',
			questId = 39268,
			itemId = 127870,
			spellId = 188241,
		},
	},
	['knight'] = {
		sort = 4,
		name = 'Knight Pepe',
		modelFileId = 1131783,
		displayId = 1131783,
		icon = "Interface\\Icons\\inv_misc_desecrated_platehelm",
		wowheadUrl = "https://www.wowhead.com/item=127869/a-tiny-plated-helm",
		camera = 0,
		position = { -0.500, -0.047, -0.220 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Plated Helm',
			questId = 39266,
			itemId = 127869,
			spellId = 188239,
		},
	},
	['ninja'] = {
		sort = 5,
		name = 'Ninja Pepe',
		modelFileId = 1131797,
		displayId = 1131797,
		icon = "Interface\\Icons\\inv_helmet_87",
		wowheadUrl = "https://www.wowhead.com/item=127867/a-tiny-ninja-shroud",
		camera = 0,
		position = { -0.500, -0.039, -0.275 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Ninja Shroud',
			questId = 39267,
			itemId = 127867,
			spellId = 188230,
		},
	},
	['scarecrow'] = {
		sort = 6,
		name = 'Scarecrow Pepe',
		modelFileId = 1246563,
		displayId = 1246563,
		icon = "Interface\\Icons\\inv_helm_plate_pvpdeathknight_f_01",
		wowheadUrl = "https://www.wowhead.com/item=128874/a-tiny-scarecrow-costume",
		camera = 0,
		position = { -0.500, -0.047, -0.212 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Scarecrow Costume',
			questId = 39865,
			itemId = 128874,
			spellId = 192472,
			achievementId = 10365,
		},
	},
	['traveler'] = {
		sort = 7,
		name = 'Traveler Pepe',
		modelFileId = 1386540,
		displayId = 1386540,
		icon = "Interface\\Icons\\inv_gizmo_newgoggles",
		wowheadUrl = "https://www.wowhead.com/item=139632/a-tiny-pair-of-goggles",
		camera = 0,
		position = { -0.500, -0.031, -0.299 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Pair of Goggles',
			questId = 43695,
			itemId = 139632,
			spellId = 221346,
			achievementId = 10770,
		},
	},
	['demonhunter'] = {
		sort = 8,
		name = 'Demon Hunter Pepe',
		modelFileId = 1534076,
		displayId = 1534076,
		icon = "Interface\\Icons\\ability_demonhunter_chaosstrike",
		wowheadUrl = "https://www.wowhead.com/item=147537/a-tiny-set-of-warglaives",
		camera = 0,
		position = { -0.500, -0.008, -0.346 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.TOY,
			name = 'A Tiny Set of Warglaives',
			achievementId = 11772,
			itemId = 147537,
			spellId = 242014,
		},
	},
	['diver'] = {
		sort = 9,
		name = 'Diver Pepe',
		modelFileId = 1859375,
		displayId = 1859375,
		icon = "Interface\\Icons\\inv_helmet_49",
		wowheadUrl = "https://www.wowhead.com/item=161451/a-tiny-diving-helmet",
		camera = 0,
		position = { -0.500, -0.039, 0.055 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Diving Helmet',
			questId = 52277,
			itemId = 161451,
			spellId = 275446,
		},
	},
	['pepejin'] = {
		sort = 10,
		name = "Pepe'jin",
		modelFileId = 1861550,
		displayId = 86717,
		icon = "Interface\\Icons\\inv_waepon_bow_zulgrub_d_02",
		wowheadUrl = "https://www.wowhead.com/item=161443/a-tiny-voodoo-mask",
		camera = 0,
		position = { -0.500, 0.000, -0.275 },
		facing = 0.000,
		camDistanceScale = 0.550,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Voodoo Mask',
			questId = 52269,
			itemId = 161443,
			spellId = 275369,
		},
	},
	['clockwork'] = {
		sort = 11,
		name = "Clockwork Pepe",
		modelFileId = 3011956,
		displayId = 3011956,
		icon = "Interface\\Icons\\item_elementiumkey",
		wowheadUrl = "https://www.wowhead.com/item=170151/a-tiny-clockwork-key",
		camera = 0,
		position = { -0.500, 0.024, -0.567 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Clockwork Key',
			questId = 56911,
			itemId = 170151,
			spellId = 303990,
		},
	},
	['greatfather'] = {
		sort = 12,
		name = "Greatfather Winter Pepe",
		modelFileId = 3209343,
		displayId = 3209343,
		icon = "Interface\\Icons\\inv_helm_cloth_holiday_christmas_a_03",
		wowheadUrl = "https://www.wowhead.com/item=174865/a-tiny-winter-hat",
		camera = 0,
		position = { -0.500, 0.197, -0.393 },
		facing = 0.000,
		camDistanceScale = 0.500,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = 'A Tiny Winter Hat',
			questId = 58901,
			itemId = 174865,
			spellId = 316934,
		},
	},
	['kyrian'] = {
		sort = 13,
		name = "Kyrian Pepe",
		modelFileId = 3866273,
		displayId = 3866273,
		icon = "Interface\\Icons\\inv_helm_armor_bastioncosmetic_d",
		wowheadUrl = "https://www.wowhead.com/item=186593/a-tiny-pair-of-wings",
		camera = 0,
		position = { -0.500, -0.016, -0.118 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.RENOWN,
			name = "A Tiny Pair of Wings",
			itemId = 186593,
			spellId = 354214,
			renownLevel = 56,
		},
	},
	['necrolord'] = {
		sort = 14,
		name = "Necrolord Pepe",
		modelFileId = 3855982,
		displayId = 3855982,
		icon = "Interface\\Icons\\inv_trinket_maldraxxus_02_green",
		wowheadUrl = "https://www.wowhead.com/item=186524/a-tiny-vial-of-slime",
		camera = 0,
		position = { -0.500, -0.016, -0.118 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.RENOWN,
			name = "A Tiny Vial of Slime",
			itemId = 186524,
			spellId = 354019,
			renownLevel = 56,
		},
	},
	['nightfae'] = {
		sort = 15,
		name = "Night Fae Pepe",
		modelFileId = 3866275,
		displayId = 3866275,
		icon = "Interface\\Icons\\inv_mace_1h_ardenweald_d_01",
		wowheadUrl = "https://www.wowhead.com/item=186473/a-tiny-winter-staff",
		camera = 0,
		position = { -0.500, -0.016, -0.118 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.RENOWN,
			name = "A Tiny Winter Staff",
			itemId = 186473,
			spellId = 353855,
			renownLevel = 56,
		},
	},
	['venthyr'] = {
		sort = 16,
		name = "Venthyr Pepe",
		modelFileId = 3866274,
		displayId = 3866274,
		icon = "Interface\\Icons\\inv_belt_mail_revendreth_d_01",
		wowheadUrl = "https://www.wowhead.com/item=186580/a-tiny-sinstone",
		camera = 0,
		position = { -0.500, -0.016, -0.118 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.RENOWN,
			name = "A Tiny Sinstone",
			itemId = 186580,
			spellId = 354188,
			renownLevel = 56,
		},
	},
	['dragon'] = {
		sort = 17,
		name = "Dragon Pepe",
		modelFileId = 5155018,
		displayId = 5155018,
		icon = "Interface\\Icons\\inv_misc_horn_04",
		wowheadUrl = "https://www.wowhead.com/item=213181/a-tiny-dragon-goblet",
		camera = 0,
		position = { -0.500, -0.031, -0.026 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = "A Tiny Dragon Goblet",
			itemId = 213181,
			spellId = 433944,
		},
	},
	['tuskarr'] = {
		sort = 18,
		name = "Tuskarr Pepe",
		modelFileId = 5155016,
		displayId = 5155016,
		icon = "Interface\\Icons\\inv_helm_armor_tuskarr_b_02",
		wowheadUrl = "https://www.wowhead.com/item=213207/a-tiny-ear-warmer",
		camera = 0,
		position = { -0.500, 0.000, -0.026 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = "A Tiny Ear Warmer",
			itemId = 213207,
			spellId = 433975,
		},
	},
	['explorer'] = {
		sort = 19,
		name = "Explorer Pepe",
		modelFileId = 5155017,
		displayId = 5155017,
		icon = "Interface\\Icons\\inv_helm_armor_explorer_d_01",
		wowheadUrl = "https://www.wowhead.com/item=213202/a-tiny-explorers-hat",
		camera = 0,
		position = { -0.500, -0.016, -0.026 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.HIDDEN_QUEST,
			name = "A Tiny Explorer's Hat",
			itemId = 213202,
			spellId = 433972,
		},
	},
	['plunderlord'] = {
		sort = 20,
		name = "Plunderlord Pepe",
		modelFileId = 5581612,
		displayId = 117609,
		icon = "Interface\\Icons\\inv_armor_pirate_d_01_helm",
		wowheadUrl = "https://www.wowhead.com/item=216907/a-tiny-plumed-tricorne",
		camera = 1,
		position = { -0.500, -0.031, -0.026 },
		facing = 0.000,
		camDistanceScale = 1.450,
		portraitZoom = 0.000,
		acquire = {
			type = ObtainBy.RENOWN,
			name = "A Tiny Plumed Tricorne",
			itemId = 216907,
			spellId = 438055,
			renownLevel = 24,
		},
	},
}

PepeBuddy.keys = {}
PepeBuddy.pepesDropdown = {}
PepeBuddy.viewTweaks = {}
for pepeKey, pepe in pairs(PepeBuddy.pepes) do
	PepeBuddy.pepesDropdown[pepeKey] = pepe.name
	PepeBuddy.keys[#PepeBuddy.keys + 1] = pepeKey
end
table.sort(PepeBuddy.keys, function(a, b)
	local left = PepeBuddy.pepes[a].sort or 0
	local right = PepeBuddy.pepes[b].sort or 0
	return left < right
end)

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
			min = 0.15,
			max = 4,
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
	LibStub('AceConfig-3.0'):RegisterOptionsTable('PepeBuddy', options, {'pepebuddy', 'pepe'})
	PepeBuddy.db = LibStub('AceDB-3.0'):New('PepeBuddyPreferences', defaultOptions)
	PepeBuddy.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('PepeBuddy', 'Pepe Buddy')
	if DEBUG_UI then
		PepeBuddy:RegisterChatCommand("pepedebug", "DebugModel")
		PepeBuddy:RegisterChatCommand("pepeview", "ToggleViewOverlay")
	end
	PepeBuddy:RegisterChatCommand("pepeexport", "ExportViewTweaks")
	minimapIcon:Register("PepeBuddyLDBI", PepeBuddy.minimapIconDB, PepeBuddy.db.profile.minimapIcon)
	if PepeBuddy.db.profile.minimapIcon.hide then
		minimapIcon:Hide("PepeBuddyLDBI")
	else
		minimapIcon:Show("PepeBuddyLDBI")
	end
	PepeBuddy:Setup()
end

function PepeBuddy:OnEnable()
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
	local size =  PepeBuddy.db.profile.size * 500
	PepeBuddy.mainFrame:SetSize(size/1.5, size/1.5)
	if PepeBuddy.baseModelFrame then
		PepeBuddy.baseModelFrame:SetSize(size, size)
	end
	if PepeBuddy.pepeModelFrame then
		PepeBuddy.pepeModelFrame:SetSize(size, size)
	end
end

function PepeBuddy:ShowPepe()
	PepeBuddy.mainFrame:Show()
	if PepeBuddy.baseModelFrame then
		if DEBUG_UI then
			PepeBuddy.baseModelFrame:Show()
		else
			PepeBuddy.baseModelFrame:Hide()
		end
	end
	if PepeBuddy.pepeModelFrame then
		PepeBuddy.pepeModelFrame:Show()
	end
end

function PepeBuddy:SetPepe(pepeKey)
	local pepe = PepeBuddy.pepes[pepeKey] or PepeBuddy.pepes['default']
	local modelFileId = pepe.modelFileId
	local displayId = pepe.displayId
	local defaultPepe = PepeBuddy.pepes['default']
	if (not modelFileId or modelFileId == 0) and defaultPepe then
		modelFileId = defaultPepe.modelFileId
	end
	if (not displayId or displayId == 0) and defaultPepe then
		displayId = defaultPepe.displayId
	end
	if PepeBuddy.pepeModelFrame then
		PepeBuddy.pepeModelFrame:ClearModel()
		local usedDisplayInfo = false
		if displayId and displayId ~= 0 and PepeBuddy.pepeModelFrame.SetDisplayInfo then
			PepeBuddy.pepeModelFrame:SetDisplayInfo(displayId)
			if PepeBuddy.pepeModelFrame.GetDisplayInfo then
				local currentDisplay = PepeBuddy.pepeModelFrame:GetDisplayInfo()
				if currentDisplay and currentDisplay ~= 0 then
					usedDisplayInfo = true
				end
			else
				usedDisplayInfo = true
			end
		end
		local currentModelFileId
		if PepeBuddy.pepeModelFrame.GetModelFileID then
			currentModelFileId = PepeBuddy.pepeModelFrame:GetModelFileID()
		end
		if (not usedDisplayInfo or not currentModelFileId or currentModelFileId == 0) and modelFileId and modelFileId ~= 0 and PepeBuddy.pepeModelFrame.SetModel then
			PepeBuddy.pepeModelFrame:SetModel(modelFileId)
		end
		if PepeBuddy.pepeModelFrame.SetAnimation then
			PepeBuddy.pepeModelFrame:SetAnimation(0)
		end
		if PepeBuddy.pepeModelFrame.SetPortraitZoom then
			PepeBuddy.pepeModelFrame:SetPortraitZoom(0)
		end
		if PepeBuddy.pepeModelFrame.SetCamDistanceScale then
			PepeBuddy.pepeModelFrame:SetCamDistanceScale(1)
		end
		if PepeBuddy.pepeModelFrame.SetFacing then
			PepeBuddy.pepeModelFrame:SetFacing(0)
		end
		PepeBuddy.pepeModelFrame:SetAlpha(1)
	end
	if PepeBuddy.baseModelFrame then
		local basePepe = PepeBuddy.pepes['default']
		local baseDisplayId = basePepe and basePepe.displayId or 0
		local baseModelFileId = basePepe and basePepe.modelFileId or 0
		PepeBuddy.baseModelFrame:ClearModel()
		if baseDisplayId and baseDisplayId ~= 0 and PepeBuddy.baseModelFrame.SetDisplayInfo then
			PepeBuddy.baseModelFrame:SetDisplayInfo(baseDisplayId)
		elseif baseModelFileId and baseModelFileId ~= 0 and PepeBuddy.baseModelFrame.SetModel then
			PepeBuddy.baseModelFrame:SetModel(baseModelFileId)
		end
		PepeBuddy.baseModelFrame:SetAlpha(0.5)
	end
	PepeBuddy:ResetViewTweakFromPepe(pepeKey)
	PepeBuddy:ApplyViewTweaks(pepeKey)
	PepeBuddy:ApplyViewTweaksToFrame(PepeBuddy.baseModelFrame, "default")
	if DEBUG_UI then
		PepeBuddy:UpdateViewOverlay(pepeKey)
	end
	PepeBuddy.minimapIconDB.icon = pepe.icon
	minimapIcon:Refresh("PepeBuddyLDBI")

	PepeBuddy:Chirp()
end

function PepeBuddy:HidePepe()
	PepeBuddy.mainFrame:Hide()
	if PepeBuddy.baseModelFrame then
		PepeBuddy.baseModelFrame:Hide()
	end
	PepeBuddy.pepeModelFrame:Hide()
end

function PepeBuddy:Reset()
	PepeBuddy.db.profile.isMovable = true
	PepeBuddy.db.profile.size = 1
	PepeBuddy.db.profile.model = "default"
	PepeBuddy.mainFrame:ClearAllPoints()
	PepeBuddy.mainFrame:SetPoint("CENTER")
	PepeBuddy.pepeModelFrame:ClearAllPoints()
	PepeBuddy.pepeModelFrame:SetPoint("CENTER", PepeBuddy.mainFrame, "CENTER")
	if PepeBuddy.baseModelFrame then
		PepeBuddy.baseModelFrame:ClearAllPoints()
		PepeBuddy.baseModelFrame:SetPoint("CENTER", PepeBuddy.mainFrame, "CENTER")
	end
	PepeBuddy:SetPepe(PepeBuddy.db.profile.model)
	PepeBuddy:UpdatePepeSize()
	PepeBuddy:ShowPepe()
end

function PepeBuddy:Setup()
	--- Frames ---
	PepeBuddy.mainFrame = CreateFrame("Frame", "PepeBuddyMainFrame", UIParent)
	PepeBuddy.mainFrame:SetMovable(true)
	PepeBuddy.mainFrame:SetUserPlaced(true)
	PepeBuddy.mainFrame:SetClampedToScreen(true)
	PepeBuddy.mainFrame:SetScript("OnShow", function(self)
		PepeBuddy:OnShow(self)
	end)

	PepeBuddy.clickFrame = CreateFrame("Button", "PepeBuddyClickFrame", PepeBuddy.mainFrame)
	PepeBuddy.clickFrame:SetAllPoints(PepeBuddy.mainFrame)
	PepeBuddy.clickFrame:RegisterForClicks("AnyUp")
	PepeBuddy.clickFrame:RegisterForDrag("LeftButton")
	PepeBuddy.clickFrame:EnableMouseWheel(true)
	PepeBuddy.clickFrame:SetScript("OnMouseUp", function(self, button)
		PepeBuddy:OnMouseUp(self, button)
	end)
	PepeBuddy.clickFrame:SetScript("OnDragStart", function(self)
		if PepeBuddy.db.profile.isMovable then
			PepeBuddy.mainFrame:StartMoving()
		end
	end)
	PepeBuddy.clickFrame:SetScript("OnDragStop", function(self)
		PepeBuddy.mainFrame:StopMovingOrSizing()
	end)
	PepeBuddy.clickFrame:SetScript("OnMouseDown", function(self, button)
		PepeBuddy:OnMouseDown(self, button)
	end)
	PepeBuddy.clickFrame:SetScript("OnMouseWheel", function(self, delta)
		PepeBuddy:OnMouseWheel(self, delta)
	end)

	PepeBuddy.baseModelFrame = CreateFrame("PlayerModel", "PepeBuddyBaseModelFrame", PepeBuddy.clickFrame)
	PepeBuddy.baseModelFrame:EnableMouse(false)
	PepeBuddy.baseModelFrame:SetFrameStrata("BACKGROUND")
	PepeBuddy.baseModelFrame:SetFrameLevel(0)

	PepeBuddy.pepeModelFrame = CreateFrame("PlayerModel", "PepeModelFrame", PepeBuddy.clickFrame)
	PepeBuddy.pepeModelFrame:EnableMouse(false)
	PepeBuddy.pepeModelFrame:SetFrameStrata("MEDIUM")
	PepeBuddy.pepeModelFrame:SetFrameLevel(2)

	if DEBUG_UI then
		PepeBuddy:ApplyDebugBorder(PepeBuddy.mainFrame, 1, 0.2, 0.2, 0.8)
		PepeBuddy:ApplyDebugBorder(PepeBuddy.clickFrame, 0.2, 1, 0.2, 0.8)
		PepeBuddy:ApplyDebugBorder(PepeBuddy.pepeModelFrame, 0.2, 0.6, 1, 0.8)
		PepeBuddy:ApplyDebugBorder(PepeBuddy.baseModelFrame, 0.8, 0.8, 0.2, 0.8)
	end

	PepeBuddy.pepeModelFrame:SetPoint("CENTER", PepeBuddy.mainFrame, "CENTER")
	PepeBuddy.baseModelFrame:SetPoint("CENTER", PepeBuddy.mainFrame, "CENTER")
	PepeBuddy:SetPepe(PepeBuddy.db.profile.model)
	PepeBuddy:UpdatePepeSize()
	PepeBuddy:ShowPepe()

	if DEBUG_UI then
		PepeBuddy.viewOverlay = CreateFrame("Frame", "PepeBuddyViewOverlay", PepeBuddy.mainFrame)
		PepeBuddy.viewOverlay:SetPoint("TOPLEFT", PepeBuddy.mainFrame, "TOPLEFT", 6, -6)
		PepeBuddy.viewOverlay:SetPoint("TOPRIGHT", PepeBuddy.mainFrame, "TOPRIGHT", -6, -6)
		PepeBuddy.viewOverlay:SetHeight(80)
		PepeBuddy.viewOverlay:Hide()

		local bg = PepeBuddy.viewOverlay:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(true)
		bg:SetColorTexture(0, 0, 0, 0.6)
		PepeBuddy.viewOverlay.bg = bg

		local text = PepeBuddy.viewOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		text:SetPoint("TOPLEFT", PepeBuddy.viewOverlay, "TOPLEFT", 6, -6)
		text:SetJustifyH("LEFT")
		text:SetJustifyV("TOP")
		text:SetText("")
		PepeBuddy.viewOverlay.text = text
	end
end

function PepeBuddy:ApplyDebugBorder(frame, r, g, b, a)
	if not DEBUG_UI then
		return
	end
	if not frame or frame._pepeDebugBorder then
		return
	end

	local thickness = 2
	local alpha = a or 0.7
	local border = {}
	border.top = frame:CreateTexture(nil, "OVERLAY")
	border.top:SetColorTexture(r, g, b, alpha)
	border.top:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	border.top:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	border.top:SetHeight(thickness)

	border.bottom = frame:CreateTexture(nil, "OVERLAY")
	border.bottom:SetColorTexture(r, g, b, alpha)
	border.bottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
	border.bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	border.bottom:SetHeight(thickness)

	border.left = frame:CreateTexture(nil, "OVERLAY")
	border.left:SetColorTexture(r, g, b, alpha)
	border.left:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	border.left:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
	border.left:SetWidth(thickness)

	border.right = frame:CreateTexture(nil, "OVERLAY")
	border.right:SetColorTexture(r, g, b, alpha)
	border.right:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	border.right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	border.right:SetWidth(thickness)

	frame._pepeDebugBorder = border
end

function PepeBuddy:ShowConfig()
	-- Retail 10.0+ replaced the old Interface Options panel with the new Settings UI.
	-- Try to open the Blizzard category if possible, and always fall back to AceConfig's own window.
	local ACD = LibStub("AceConfigDialog-3.0", true)

	if Settings and Settings.OpenToCategory then
		-- Different clients/patches accept different argument types; try a few.
		pcall(Settings.OpenToCategory, PepeBuddy.optionsFrame)
		pcall(Settings.OpenToCategory, "Pepe Buddy")
		pcall(Settings.OpenToCategory, "PepeBuddy")
	elseif InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(PepeBuddy.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(PepeBuddy.optionsFrame)
	end

	-- Always provide an AceConfig window fallback (works regardless of Blizzard Settings UI changes).
	if ACD and ACD.Open then
		ACD:Open("PepeBuddy")
	end
end

function PepeBuddy:PLAYER_ENTERING_WORLD()
	PepeBuddy:ShowPepe()
end

function PepeBuddy:OnMouseUp(self, button)
	if button == "MiddleButton"  then
		PepeBuddy:ShowConfig()
	end
	if IsShiftKeyDown() then
		if button == "LeftButton" then
			PepeBuddy.db.profile.isMovable = not PepeBuddy.db.profile.isMovable
		end
	end
	PepeBuddy.isRotating = false
end

function PepeBuddy:OnShow(self)
	PepeBuddy:Print("Main Frame Shown.")
	PepeBuddy:SetPepe(PepeBuddy.db.profile.model)
end

function PepeBuddy:OnMouseDown(self, button)
	if DEBUG_UI then
		if button ~= "RightButton" then
			return
		end
		local x, y = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		PepeBuddy.isRotating = true
		PepeBuddy.lastCursorX = x / scale
		PepeBuddy.lastCursorY = y / scale
		self:SetScript("OnUpdate", function()
			PepeBuddy:OnUpdatePan()
		end)
	end
end

function PepeBuddy:OnUpdatePan()
	if not PepeBuddy.isRotating or not PepeBuddy.pepeModelFrame then
		PepeBuddy.clickFrame:SetScript("OnUpdate", nil)
		return
	end
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	x = x / scale
	y = y / scale
	local dx = x - (PepeBuddy.lastCursorX or x)
	local dy = y - (PepeBuddy.lastCursorY or y)
	PepeBuddy.lastCursorX = x
	PepeBuddy.lastCursorY = y

	local tweak = PepeBuddy:GetOrCreateViewTweak(PepeBuddy.db.profile.model)
	tweak.position[2] = (tweak.position[2] or 0) + (dx * 0.01)
	tweak.position[3] = (tweak.position[3] or 0) + (dy * 0.01)

	PepeBuddy:ApplyViewTweaks(PepeBuddy.db.profile.model)
	PepeBuddy:UpdateViewOverlay(PepeBuddy.db.profile.model)
end

function PepeBuddy:OnMouseWheel(self, delta)
	if DEBUG_UI then
		local tweak = PepeBuddy:GetOrCreateViewTweak(PepeBuddy.db.profile.model)
		local step = 0.05
		if IsShiftKeyDown() then
			step = 0.1
		end
		tweak.camDistanceScale = (tweak.camDistanceScale or 1) + (delta * step)
		if tweak.camDistanceScale < 0.1 then
			tweak.camDistanceScale = 0.1
		end
		PepeBuddy:ApplyViewTweaks(PepeBuddy.db.profile.model)
		PepeBuddy:UpdateViewOverlay(PepeBuddy.db.profile.model)

	end
end

function PepeBuddy:DebugModel()
	if not PepeBuddy.pepeModelFrame then
		PepeBuddy:DefaultPrint("Pepe model frame not ready.")
		return
	end

	local displayInfo = "n/a"
	if PepeBuddy.pepeModelFrame.GetDisplayInfo then
		displayInfo = PepeBuddy.pepeModelFrame:GetDisplayInfo()
	end
	local modelFileId = "n/a"
	if PepeBuddy.pepeModelFrame.GetModelFileID then
		modelFileId = PepeBuddy.pepeModelFrame:GetModelFileID()
	end
	local modelPath = "n/a"
	if PepeBuddy.pepeModelFrame.GetModelFile then
		modelPath = PepeBuddy.pepeModelFrame:GetModelFile()
	end

	PepeBuddy:DefaultPrint(("DisplayId: %s Current: %s ModelFileId: %s Model: %s"):format(
			tostring(PepeBuddy.pepes[PepeBuddy.db.profile.model].displayId),
			tostring(displayInfo),
			tostring(PepeBuddy.pepes[PepeBuddy.db.profile.model].modelFileId),
			tostring(modelPath)
	))
end

function PepeBuddy:GetOrCreateViewTweak(pepeKey)
	local tweak = PepeBuddy.viewTweaks[pepeKey]
	if not tweak then
		tweak = {
			camDistanceScale = nil,
			portraitZoom = nil,
			facing = nil,
			position = { 0, 0, 0 },
		}
		PepeBuddy.viewTweaks[pepeKey] = tweak
	end
	if not tweak.position then
		tweak.position = { 0, 0, 0 }
	end
	return tweak
end

function PepeBuddy:ResetViewTweakFromPepe(pepeKey)
	local pepe = PepeBuddy.pepes[pepeKey]
	if not pepe then
		return
	end
	local tweak = {
		facing = pepe.facing,
		camDistanceScale = pepe.camDistanceScale,
		portraitZoom = pepe.portraitZoom,
		position = {
			(pepe.position and pepe.position[1]) or 0,
			(pepe.position and pepe.position[2]) or 0,
			(pepe.position and pepe.position[3]) or 0,
		},
	}
	PepeBuddy.viewTweaks[pepeKey] = tweak
end

function PepeBuddy:ApplyViewTweaks(pepeKey)
	PepeBuddy:ApplyViewTweaksToFrame(PepeBuddy.pepeModelFrame, pepeKey)
end

function PepeBuddy:ApplyViewTweaksToFrame(frame, pepeKey)
	if not frame then
		return
	end
	local pepe = PepeBuddy.pepes[pepeKey]
	local tweak = PepeBuddy.viewTweaks[pepeKey]
	if not tweak and not pepe then
		return
	end
	local camDistanceScale = (tweak and tweak.camDistanceScale) or (pepe and pepe.camDistanceScale) or 1
	local portraitZoom = (tweak and tweak.portraitZoom) or (pepe and pepe.portraitZoom) or 0
	local facing = (tweak and tweak.facing) or (pepe and pepe.facing) or 0
	local position = (tweak and tweak.position) or (pepe and pepe.position) or { 0, 0, 0 }

	if frame.SetCamDistanceScale and camDistanceScale then
		frame:SetCamDistanceScale(camDistanceScale)
	end
	if frame.SetPortraitZoom and portraitZoom then
		frame:SetPortraitZoom(portraitZoom)
	end
	if frame.SetFacing and facing then
		frame:SetFacing(facing)
	end
	if frame.SetPosition and position then
		frame:SetPosition(position[1] or 0, position[2] or 0, position[3] or 0)
	end
end

function PepeBuddy:ToggleViewOverlay()
	if not DEBUG_UI then
		return
	end
	if not PepeBuddy.viewOverlay then
		return
	end
	if PepeBuddy.viewOverlay:IsShown() then
		PepeBuddy.viewOverlay:Hide()
	else
		PepeBuddy.viewOverlay:Show()
		PepeBuddy:UpdateViewOverlay(PepeBuddy.db.profile.model)
	end
end

function PepeBuddy:UpdateViewOverlay(pepeKey)
	if not DEBUG_UI then
		return
	end
	if not PepeBuddy.viewOverlay or not PepeBuddy.viewOverlay.text then
		return
	end
	if not PepeBuddy.viewOverlay:IsShown() then
		return
	end
	local pepe = PepeBuddy.pepes[pepeKey] or PepeBuddy.pepes['default']
	local tweak = PepeBuddy.viewTweaks[pepeKey]
	local position = (tweak and tweak.position) or (pepe and pepe.position) or { 0, 0, 0 }
	local facing = (tweak and tweak.facing) or (pepe and pepe.facing) or 0
	local camDistanceScale = (tweak and tweak.camDistanceScale) or (pepe and pepe.camDistanceScale) or 1
	local portraitZoom = (tweak and tweak.portraitZoom) or (pepe and pepe.portraitZoom) or 0
	local text = ("Pepe: %s\nDisplayId: %s ModelFileId: %s\nFacing: %.3f  CamDist: %.3f  Zoom: %.3f\nPos: %.3f, %.3f, %.3f\nRight-drag: rotate/tilt  Wheel: zoom  Shift+Wheel: faster"):format(
			tostring(pepe.name),
			tostring(pepe.displayId),
			tostring(pepe.modelFileId),
			facing,
			camDistanceScale,
			portraitZoom,
			position[1] or 0,
			position[2] or 0,
			position[3] or 0
	)
	PepeBuddy.viewOverlay.text:SetText(text)
end

function PepeBuddy:ExportViewTweaks()
	local pepeKey = PepeBuddy.db.profile.model
	local pepe = PepeBuddy.pepes[pepeKey] or PepeBuddy.pepes['default']
	local tweak = PepeBuddy.viewTweaks[pepeKey]
	if not tweak then
		PepeBuddy:DefaultPrint("No view tweaks set for " .. tostring(pepeKey))
		return
	end
	local position = tweak.position or { 0, 0, 0 }
	local export = ("camera = 0,\nposition = { %.3f, %.3f, %.3f },\nfacing = %.3f,\ncamDistanceScale = %.3f,\nportraitZoom = %.3f,\ndisplayId = %s,\nmodelFileId = %s,"):format(
			position[1] or 0,
			position[2] or 0,
			position[3] or 0,
			tweak.facing or 0,
			tweak.camDistanceScale or 1,
			tweak.portraitZoom or 0,
			tostring(pepe.displayId),
			tostring(pepe.modelFileId)
	)
	PepeBuddy:DefaultPrint("Export for " .. pepe.name .. ":\n" .. export)
end


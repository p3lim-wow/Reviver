if(select(2, UnitClass('player')) ~= 'DRUID') then return DisableAddOn('Reviver') end

local corpsetip = string.gsub(CORPSE_TOOLTIP, '%%s', '([^ ]+)')

local spells = {
	[GetSpellInfo(20484)] = true, -- Rebirth
	[GetSpellInfo(29166)] = true, -- Innervate
}

local function channelName()
	local _, itype = IsInInstance()
	if(itype == 'pvp' or itype == 'arena') then
		return
	elseif(GetNumRaidMembers() > 0) then
		return 'RAID'
	elseif(GetNumPartyMembers() > 0) then
		return 'PARTY'
	end
end

local function onEvent(self, event, unit, spellName, spellRank, unitName)
	if(unit == 'player' and spells[spellName] and channelName()) then
		if(unitName == UNKNOWN) then
			local _, _, tempName = string.find(GameTooltipTextLeft1:GetText(), corpsetip)
			unitName = tempName
		end

		SendChatMessage(string.format('- Casting %s on %s -', spellName, unitName), channelName())
	end
end

local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', onEvent)
addon:RegisterEvent('UNIT_SPELLCAST_SENT')
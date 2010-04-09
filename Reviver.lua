if(select(2, UnitClass('player')) ~= 'DRUID') then return end

local corpsetip = string.gsub(CORPSE_TOOLTIP, '%%s', '([^ ]+)')

local spells = {
	[GetSpellInfo(20484)] = true, -- Rebirth
	[GetSpellInfo(29166)] = true, -- Innervate
}

local function channelName()
	local _, type = IsInInstance()
	if(type == 'pvp' or type == 'arena') then
		return
	elseif(GetNumRaidMembers() > 0) then
		return 'RAID'
	elseif(GetNumPartyMembers() > 0) then
		return 'PARTY'
	end
end

local addon = CreateFrame('Frame')
addon:RegisterEvent('UNIT_SPELLCAST_SENT')
addon:SetScript('OnEvent', function(self, event, unit, spellName, spellRank, targetName)
	if(unit == 'player' and spells[spellName] and channelName()) then
		if(targetName == UNKNOWN) then
			local _, _, tempName = string.find(GameTooltipTextLeft1:GetText(), corpsetip)
			targetName = tempName
		end

		targetName = string.match(targetName, '(.+)%-(.*)') or targetName

		SendChatMessage(string.format('- Casting %s on %s -', spellName, targetName), channelName())
	end
end)

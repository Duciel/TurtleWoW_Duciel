Duciel = Duciel.main:GetFrame();
Duciel.priest = {};

setmetatable(Duciel.priest, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.priest:SWPain(unit)
	if unit == nil then
		unit = "target"
	end
	
    local spell = "Shadow Word: Pain";
	
    local name, icon, col, line, rank, maxRank = GetTalentInfo(3, 4); -- Improved Shadow Word: Pain
    local swpDuration = 18 + (rank * 3) + 3;
	
	local _, guid = UnitExists(unit);
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + swpDuration < GetTime() then
        Duciel.main:SpellCast(spell);
	end
end

function Duciel.priest:VampEmbrace(unit)
	if unit == nil then
		unit = "target"
	end

    local spell = "Vampiric Embrace";
	
	local vampDuration = 60;
    if UnitName(unit) == "Loatheb" then
        vampDuration = 30;
    end
	
	local _, guid = UnitExists(unit);
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + vampDuration < GetTime() then
        Duciel.main:SpellCast(spell);
    end
end

function Duciel.priest:ShadowDPS(unit, noVamp)
	if unit == nil then
		unit = "target"
	end
	
    if (pfUI.env.UnitChannelInfo("player")) then
        return;
    else
		Duciel.main:ProcessWaitingList();
		Duciel.priest:SWPain(unit);
		if not(noVamp) then
			Duciel.priest:VampEmbrace(unit);
		end
		Duciel.main:SpellCast("Mind Blast", unit);
        Duciel.main:SpellCast("Mind Flay", unit);
	end
end

function Duciel.priest:CancelHealing(spellName, unit, missingHPThreshold, latency)
	if unit == nil then
		unit = "target"
	end
	
	if latency == nil then
		_, _, latency = GetNetStats();
	end
	
    cast, nameSubtext, text, texture, startTime, endTime, isTradeSkill = pfUI.env.UnitCastingInfo("player");
    if (cast) then
        if (endTime <= GetTime()*1000 + latency) then
            local missingHP = UnitHealthMax("target") - UnitHealth("target");
            if (missingHP <= missingHPThreshold) then
                SpellStopCasting();
            end
        end
    else
        Duciel.main:SpellCast(spellName, unit);
    end
end
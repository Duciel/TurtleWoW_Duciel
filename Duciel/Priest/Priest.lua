Duciel = Duciel.main:GetFrame();
Duciel.priest = {};

setmetatable(Duciel.priest, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.priest:SWPain(unit)
    unit = unit or "target";
    name, icon, col, line, rank, maxRank = GetTalentInfo(3, 4); -- Improved Shadow Word: Pain
    swpDuration = 18 + (rank * 3) + 3;
	
    spell = "Shadow Word: Pain";
	if Duciel.main.cooldownTracker[spell] == nil or Duciel.main.cooldownTracker[spell] + swpDuration < GetTime() then
        Duciel.main:SpellCast(spell);
	end
end

function Duciel.priest:VampEmbrace(unit)
    unit = unit or "target"
    if UnitName(unit) == "Loatheb" then
        vampDuration = 30
    else
        vampDuration = 60
    end

    spell = "Vampiric Embrace";
	if Duciel.main.cooldownTracker[spell] == nil or Duciel.main.cooldownTracker[spell] + vampDuration < GetTime() then
        Duciel.main:SpellCast(spell);
    end
end

function Duciel.priest:ShadowDPS(noVamp)
    if (pfUI.env.UnitChannelInfo("player")) then
        return;
    else
		if not(noVamp) then
			Duciel.priest:VampEmbrace();
		end
		Duciel.priest:SWPain();
		Duciel.main:SpellCast("Mind Blast");
        Duciel.main:SpellCast("Mind Flay");
	end
end

function Duciel.priest:CancelHealing(spellName, missingHPThreshold, latency)
	if latency == nil then
		_, _, latency = GetNetStats();
	end
	
    cast, nameSubtext, text, texture, startTime, endTime, isTradeSkill = pfUI.env.UnitCastingInfo("player");
    if (cast) then
        if (endTime <= GetTime()*1000 + latency) then
            missingHP = UnitHealthMax("target") - UnitHealth("target");
            if (missingHP <= missingHPThreshold) then
                SpellStopCasting();
            end
        end
    else
        Duciel.main:SpellCast(spellName);
    end
end
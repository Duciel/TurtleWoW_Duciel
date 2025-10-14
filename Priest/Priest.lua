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
    local swpDuration = 18 + (rank * 3);
	
	-- Eye of Dormant Corruption
	if Duciel.main:FindEquippedItem(55111) ~= nil then
		swpDuration = swpDuration + 3;
	end
	
	local _, guid = UnitExists(unit);
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + swpDuration < GetTime() then
        Duciel.main:SpellCast(spell, unit);
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
        Duciel.main:SpellCast(spell, unit);
    end
end

function Duciel.priest:InnerFire()
	if not(Duciel.main:FindBuff(10952, "player")) then
		Duciel.main:SpellCast("Inner Fire");
	end
end

function Duciel.priest:Shadowform()
	if not(Duciel.main:FindBuff(15473, "player")) then
		Duciel.main:SpellCast("Shadowform");
	end
end

function Duciel.priest:MindBlast(unit)
    local spell = "Mind Blast";
    local name, icon, col, line, rank, maxRank = GetTalentInfo(1, 9); -- Inner Focus
	if (rank == 1 and Duciel.main:GetSpellCooldownByName(spell) == 0) then
		Duciel.main:SpellCast("Inner Focus");
	end
	Duciel.main:SpellCast(spell, unit);
end

function Duciel.priest:ShadowDPS(unit, noVamp)
    if not(pfUI.env.UnitChannelInfo("player")) then
		Duciel.main:ProcessWaitingList();
		Duciel.main:HerbalTea(500);
		Duciel.priest:Shadowform();
        Duciel.priest:InnerFire();
		Duciel.priest:SWPain(unit);
		if not(noVamp) then
			Duciel.priest:VampEmbrace(unit);
		end
		Duciel.priest:MindBlast(unit);
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
            local missingHP = UnitHealthMax(unit) - UnitHealth(unit);
            if (missingHP <= missingHPThreshold) then
                SpellStopCasting();
            end
        end
    else
        Duciel.main:SpellCast(spellName, unit);
    end
end

function Duciel.priest:AutoHeal(spellName, threshold)
	local unit = Duciel.main:AutoHealTarget(threshold);
	Duciel.main:SpellCast(spellName, unit);
end
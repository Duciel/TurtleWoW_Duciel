Duciel = Duciel.main:GetFrame();
Duciel.priest = {};

setmetatable(Duciel.priest, {__index = getfenv(0)});
setfenv(1, getfenv(0));

local renewList = {25315, 10929, 10928, 10927, 6078, 6077}; -- Renew from rank 10 to 5

function Duciel.priest:InnerFire()
	if not(Duciel.main:FindBuff(10952, "player")) then
		Duciel.main:SpellCast("Inner Fire");
	end
end

function Duciel.priest:Shadowform()
    local name, icon, col, line, rank, maxRank = GetTalentInfo(3, 17);
	if rank == 1 then
		if not(Duciel.main:FindBuff(15473, "player")) then
			Duciel.main:SpellCast("Shadowform");
		end
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

function Duciel.priest:MindFlay(unit)
    local name, icon, col, line, rank, maxRank = GetTalentInfo(3, 8);
	if rank == 1 then
		Duciel.main:SpellCast("Mind Flay", unit);
	end
end

function Duciel.priest:Smite(unit)
	if not(Duciel.main:FindBuff(15473, "player")) then
		Duciel.main:SpellCast("Smite", unit);
	end
end

function Duciel.priest:VampEmbrace(unit)
    local name, icon, col, line, rank, maxRank = GetTalentInfo(3, 14);
	if rank == 1 then
		Cursive:Curse("Vampiric Embrace", unit, {refreshtime=0});
	end
end

function Duciel.priest:ShadowDPS(unit, noVamp, noAOE)
    if not(pfUI.env.UnitChannelInfo("player")) then
		Duciel.main:ProcessWaitingList();
		Duciel.main:HerbalTea(500);
		Duciel.priest:Shadowform();
		Duciel.priest:InnerFire();
		if noAOE then
			Cursive:Curse("Shadow Word: Pain", unit, {refreshtime=0});
		else
			Cursive:Multicurse("Shadow Word: Pain", "RAID_MARK", {refreshtime=0});
		end
		if not(noVamp) then
			Duciel.priest:VampEmbrace(unit);
		end
		Duciel.priest:MindBlast(unit);
		Duciel.priest:MindFlay(unit);
		Duciel.priest:Smite(unit);
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

function Duciel.priest:AutoRenew(renew, threshold)
	local unit = Duciel.main:AutoHealTarget(threshold, renewList, renew);
	if unit ~= nil then
		Duciel.main:SpellCast(renew, unit);
	end
end
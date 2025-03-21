Duciel = Duciel.main:GetFrame();
Duciel.priest = {};

setmetatable(Duciel.priest, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Toto()
    print("toto");
end

function SWPain(unit)
    unit = unit or "target";
    name, icon, col, line, rank, maxRank = GetTalentInfo(3, 4); -- Improved Shadow Word: Pain
    swpDuration = 18 + (rank * 3);
    
    if (not(Duciel.main:FindDebuff(10894, unit)) or swpain == nil or swpain < GetTime() - swpDuration) then
        CastSpellByName("Shadow Word: Pain");
        swpain = GetTime();
    end
end

function VampEmbrace(unit)
    unit = unit or "target"
    if UnitName(unit) == "Loatheb" then
        vampDuration = 30
    else
        vampDuration = 60
    end

    if (not(Duciel.main:FindDebuff(15286, unit)) or vampEmbrace == nil or vampEmbrace < GetTime() - vampDuration) then
        CastSpellByName("Vampiric Embrace");
        vampEmbrace = GetTime();
    end
end

function MindFlay()
    if (pfUI.env.UnitChannelInfo("player")) then
        return;
    else
        CastSpellByName("Mind Flay");
    end
end

function shadowDPS()
    VampEmbrace();
    SWPain();
    CastSpellByName("Mind Blast");
    MindFlay();
end

function CancelHealing(spellName, missingHPThreshold, latency)
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
        CastSpellByName(spellName);
    end
end
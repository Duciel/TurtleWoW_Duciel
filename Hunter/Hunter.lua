Duciel = Duciel.main:GetFrame();
Duciel.hunter = {};

setmetatable(Duciel.hunter, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.hunter:SwapAggro()
	local hasPet = HasPetUI();
	
	if hasPet then
		local isPetInCombat = UnitAffectingCombat("pet");
		
		if isPetInCombat then
			local isPlayerInCombat = UnitAffectingCombat("player");
			
			if isPlayerInCombat then
				Duciel.main:SpellCast("Feign Death");
			else
				Duciel.main:SpellCast("Eyes of the Beast");
			end
		else
			CastPetAction(5);
		end
	else
		Duciel.main:SpellCast("Call Pet");
	end
end

function Duciel.hunter:Feign()
	PetPassiveMode();
	Duciel.main:SpellCast("Feign Death");
end

function Duciel.hunter:FeignRegen()
	local isPlayerInCombat = UnitAffectingCombat("player");
	
	if isPlayerInCombat then
		Duciel.main:SpellCast("Feign Death");
	else
		if Duciel.main:CheckMana("player") < 90 and not(Duciel.main:FindBuff(1137, "player")) then
			Duciel.main:UseBagItem(8766); -- Morning Glory Dew
		end
		if Duciel.main:CheckHP("player") < 90 and not(Duciel.main:FindBuff(1131, "player")) then
			Duciel.main:UseBagItem(8952); -- Roasted Quail
		end
	end
end

function Duciel.hunter:SerpentSting(unit)
	local spell = "Serpent Sting";
	if unit == nil then
		unit = "target";
	end
	
	local _, guid = UnitExists(unit);
	
	local unitName = UnitName(unit);
	if Duciel.main:Contains(Duciel.main:GetNatureImmuneList(), unitName) then
		return;
	end
	
	-- Only refresh serpent sting on a target every 15sec
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 15 < GetTime() then
		Duciel.main:SpellCast(spell);
	end
end

function Duciel.hunter:HunterMark(unit)
	local spell = "Hunter's Mark";
	if unit == nil then
		unit = "target";
	end
	
	local _, guid = UnitExists(unit);
	
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 120 < GetTime() then
		Duciel.main:SpellCast(spell);
	end
end

function Duciel.hunter:TrueshotAura()
	if not(Duciel.main:FindBuff(20906, "player")) then
		Duciel.main:SpellCast("Trueshot Aura");
	end
end

function Duciel.hunter:ImmolationTrap(unit)
	if unit == nil then
		unit = "target";
	end
	
	local unitName = UnitName(unit);
	if Duciel.main:Contains(Duciel.main:GetFireImmuneList(), unitName) then
		return;
	end
	
	if Duciel.main:IsInRange(unit, 1) then
		Duciel.main:SpellCast("Immolation Trap");
	end
end

function Duciel.hunter:ExplosiveTrap(unit)
	if unit == nil then
		unit = "target";
	end
	
	local unitName = UnitName(unit);
	if Duciel.main:Contains(Duciel.main:GetFireImmuneList(), unitName) then
		return;
	end
	
	if Duciel.main:IsInRange(unit, 1) then
		Duciel.main:SpellCast("Explosive Trap");
	end
end

function Duciel.hunter:Carve(unit)
	if unit == nil then
		unit = "target";
	end
	
	if Duciel.main:IsInRange(unit, 10, "AoE") then
		Duciel.main:SpellCast("Carve");
	end
end

function Duciel.hunter:MongooseBite(unit)
	local spell = "Mongoose Bite";
	if unit == nil then
		unit = "target";
	end
	
	local _, guid = UnitExists(unit);
	
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 6 < GetTime() then
		Duciel.main:SpellCast(spell);
	end
end

function Duciel.hunter:Cooldowns(unit)
if unit == nil then
		unit = "target"
	end
	
	-- if unit is a worldboss
	if UnitClassification(unit) == "worldboss" then		
		local elapsedFightTime = Duciel.main:ElapsedFightTime();
		
		-- if in combat for more than 10s
		if elapsedFightTime ~= nil and elapsedFightTime > 10 then		
			Duciel.main:SpellCast("Rapid Fire");
			Duciel.main:SpellCast("Blood Fury");
			Duciel.main:JujuFlurry();
			Duciel.main:UseBagItem(61181); -- Potion of Quickness
			Duciel.main:UseTrinket(true, true);
		end
	end
end

function Duciel.hunter:RoarOfFortitude()
	local spell = "Roar of Fortitude";
	
	-- Don't roar if player already has the buff or roar has been used in the last 12sec (in case of buff cap)
	if not(Duciel.main:FindBuff(36535, "player")) and (Duciel.main:GetCooldownTracker(spell) == nil or Duciel.main:GetCooldownTracker(spell) + 12 < GetTime()) then
		if PetHasActionBar() == 1 then
			local startTime, duration, enable = Duciel.main:PetCooldown(spell);
			if duration == 0 then
				Duciel.main:PetCast(spell);
			else
				Duciel.main:SpellCast("Summon Arcane Elemental");
			end
		else
			Duciel.main:SpellCast("Call Pet");
		end
	end
end

function Duciel.hunter:FuriousHowl()
	local spell = "Furious Howl";
	
	-- Don't howl if player already has the buff
	if not(Duciel.main:FindBuff(24597, "player")) then
		if PetHasActionBar() == 1 then
			local startTime, duration, enable = Duciel.main:PetCooldown(spell);
			if duration == 0 then
				Duciel.main:PetCast(spell);
			else
				Duciel.main:SpellCast("Summon Arcane Elemental");
			end
		else
			Duciel.main:SpellCast("Call Pet");
		end
	end
end

function Duciel.hunter:PetRotation()
	local petType = GetPetIcon();
	if petType == "Interface\Ability_Hunter_Pet_Bear" then
		Duciel.hunter:RoarOfFortitude();
	elseif petType == "Interface\Ability_Hunter_Pet_Wolf" then
		Duciel.hunter:FuriousHowl();
	end
end

function Duciel.hunter:MeleeDPS(unit)
	if unit == nil then
		unit = "target";
	end
	
	Duciel.main:HerbalTea(500);
		
	Duciel.hunter:Cooldowns(unit);
	
	Duciel.hunter:ImmolationTrap(unit);
	Duciel.main:SpellCast("Lacerate");
	Duciel.hunter:PetRotation();
	Duciel.hunter:MongooseBite(unit);
	Duciel.hunter:Carve(unit);
	Duciel.main:SpellCast("Wing Clip");
	Duciel.main:SpellCast("Raptor Strike");
end

function Duciel.hunter:MeleeAOE(unit)
	if unit == nil then
		unit = "target";
	end
	
	Duciel.main:HerbalTea(500);
	
	Duciel.hunter:ExplosiveTrap(unit);
	Duciel.hunter:Carve(unit);
	Duciel.hunter:PetRotation();
	Duciel.main:SpellCast("Lacerate");
	Duciel.hunter:MongooseBite(unit);
	Duciel.main:SpellCast("Wing Clip");
	Duciel.main:SpellCast("Raptor Strike");
end

function Duciel.hunter:RangeDPS(unit)
	if unit == nil then
		unit = "target";
	end
	
	Duciel.main:HerbalTea(500);
	
	Duciel.hunter:TrueshotAura();
	
	if Duciel.main:IsInCombat() == false then
		Duciel.hunter:HunterMark(unit);
		Duciel.main:SpellCast("Aimed Shot");
	end
	ST_SafeShot("steady");
	Duciel.hunter:SerpentSting(unit);
	ST_SafeShot("multi");
	Duciel.hunter:PetRotation();
end

function Duciel.hunter:RangeAOE(unit)
	if unit == nil then
		unit = "target";
	end
	
	Duciel.main:HerbalTea(500);
	
	Duciel.main:HerbalTea()
	
	Duciel.hunter:TrueshotAura();
	
	if Duciel.main:IsInCombat() == false then
		Duciel.hunter:HunterMark(unit);
		Duciel.main:SpellCast("Aimed Shot");
	end
	ST_SafeShot("multi");
	ST_SafeShot("steady");
	Duciel.hunter:PetRotation();
	Duciel.hunter:SerpentSting(unit);
end
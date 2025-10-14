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
	
	if guid ~= nil then
		local unitName = UnitName(unit);
		if Duciel.main:Contains(Duciel.main:GetNatureImmuneList(), unitName) then
			return;
		end
	
		-- Only refresh serpent sting on a target every 15sec
		if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 15 < GetTime() then
			Duciel.main:SpellCast(spell, unit);
		end
	end
end

function Duciel.hunter:HunterMark(unit)
	local spell = "Hunter's Mark";
	if unit == nil then
		unit = "target";
	end
	
	local _, guid = UnitExists(unit);
	
	if guid ~= nil then
		if not(Duciel.main:FindDebuff(14325, unit)) and (Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 120 < GetTime()) then
			Duciel.main:SpellCast(spell, unit);
		end
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
	if Duciel.main:IsInRange(unit, 10, "AoE") then
		Duciel.main:SpellCast("Carve");
	end
end

function Duciel.hunter:MongooseBite(unit)
	local spell = "Mongoose Bite";

	if Duciel.main:GetCooldownTracker(spell) == nil or Duciel.main:GetCooldownTracker(spell) + 6 < GetTime() then
		Duciel.main:SpellCast(spell, unit);
	end
end

function Duciel.hunter:AutoCooldowns(unit)
	if unit == nil then
		unit = "target"
	end
	
	-- if unit is a worldboss
	if UnitClassification(unit) == "worldboss" then		
		local elapsedFightTime = Duciel.main:ElapsedFightTime();
		
		-- if in combat for more than 10s
		if elapsedFightTime ~= nil and elapsedFightTime > 10 then		
			Duciel.hunter:Cooldowns();
		end
	end
end

function Duciel.hunter:Cooldowns()
	Duciel.main:JujuFlurry("player"); -- Rapid fire gives juju 5min cooldown so you want to use juju first
	Duciel.main:UseTrinket(true, true);
	Duciel.main:SpellCast("Rapid Fire");
	Duciel.main:SpellCast("Blood Fury");
	Duciel.main:UseBagItem(61181); -- Potion of Quickness
end

function Duciel.hunter:RoarOfFortitude()
	local spell = "Roar of Fortitude";
	
	-- Don't roar if player already has the buff or roar has been used in the last 12sec (in case of buff cap)
	if not(Duciel.main:FindBuff(36535, "player")) and (Duciel.main:GetCooldownTracker(spell) == nil or Duciel.main:GetCooldownTracker(spell) + 12 < GetTime()) then
		local startTime, duration, enable = Duciel.main:PetCooldown(spell);
		if duration == 0 and UnitMana("pet") >= 50 then
			Duciel.main:PetCast(spell);
		else
			Duciel.main:SpellCast("Summon Arcane Elemental");
		end
	end
end

function Duciel.hunter:FuriousHowl()
	local spell = "Furious Howl";
	
	-- Don't howl if player already has the buff
	if not(Duciel.main:FindBuff(24597, "player")) then
		local startTime, duration, enable = Duciel.main:PetCooldown(spell);
		if duration == 0 and UnitMana("pet") >= 50 then
			Duciel.main:PetCast(spell);
		else
			Duciel.main:SpellCast("Summon Arcane Elemental");
		end
	end
end

function Duciel.hunter:PetRotation()
	if PetHasActionBar() == 1 then
		local petType = GetPetIcon();
		if petType == "Interface\\Icons\\Ability_Hunter_Pet_Bear" then
			Duciel.hunter:RoarOfFortitude();
		elseif petType == "Interface\\Icons\\Ability_Hunter_Pet_Wolf" then
			Duciel.hunter:FuriousHowl();
		end
	else
		Duciel.main:SpellCast("Call Pet");
	end
end

function Duciel.hunter:MeleeDPS(unit)
	Duciel.main:HerbalTea(500);
	Duciel.hunter:AutoCooldowns(unit);
	
	Duciel.hunter:ImmolationTrap(unit);
	Duciel.main:SpellCast("Lacerate", unit);
	Duciel.hunter:PetRotation();
	Duciel.hunter:MongooseBite(unit);
	Duciel.hunter:Carve(unit);
	Duciel.main:SpellCast("Wing Clip", unit);
	Duciel.main:SpellCast("Raptor Strike", unit);
end

function Duciel.hunter:MeleeAOE(unit)
	Duciel.main:HerbalTea(500);
	Duciel.hunter:AutoCooldowns(unit);
	
	Duciel.hunter:ExplosiveTrap(unit);
	Duciel.hunter:Carve(unit);
	Duciel.hunter:PetRotation();
	Duciel.main:SpellCast("Lacerate", unit);
	Duciel.hunter:MongooseBite(unit);
	Duciel.main:SpellCast("Wing Clip", unit);
	Duciel.main:SpellCast("Raptor Strike", unit);
end

function Duciel.hunter:RangeDPS(unit)
	Duciel.main:HerbalTea(500);
	Duciel.hunter:AutoCooldowns(unit);
	
	Duciel.hunter:TrueshotAura();
	
	if Duciel.main:IsInCombat() == false then
		Duciel.hunter:HunterMark(unit);
		--Duciel.main:SpellCast("Aimed Shot");
	end
	ST_SafeShot("steady");
	Duciel.hunter:SerpentSting(unit);
	ST_SafeShot("multi");
	Duciel.hunter:HunterMark(unit);
	--Duciel.hunter:PetRotation();
end

function Duciel.hunter:RangeAOE(unit)
	Duciel.main:HerbalTea(500);
	Duciel.hunter:AutoCooldowns(unit);
	
	Duciel.hunter:TrueshotAura();
	
	if Duciel.main:IsInCombat() == false then
		Duciel.hunter:HunterMark(unit);
		--Duciel.main:SpellCast("Aimed Shot");
	end
	ST_SafeShot("multi");
	ST_SafeShot("steady");
	Duciel.hunter:PetRotation();
	Duciel.hunter:HunterMark(unit);
	Duciel.hunter:SerpentSting(unit);
end
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

function Duciel.hunter:ImmolationTrap(unit)
	if unit == nil then
		unit = "target";
	end
	
	if Duciel.main:IsInRange(unit, 1) then
		Duciel.main:SpellCast("Immolation Trap");
	end
end

function Duciel.hunter:ExplosiveTrap(unit)
	if unit == nil then
		unit = "target";
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

function Duciel.hunter:MeleeDPS(unit)
	if unit == nil then
		unit = "target";
	end
	
	Duciel.hunter:ImmolationTrap(unit);
	Duciel.main:SpellCast("Lacerate");
	Duciel.main:SpellCast("Mongoose Bite");
	Duciel.hunter:Carve(unit);
	Duciel.main:SpellCast("Wing Clip");
	Duciel.main:SpellCast("Raptor Strike");
end

function Duciel.hunter:MeleeAOE(unit)
	if unit == nil then
		unit = "target";
	end
	
	Duciel.hunter:ExplosiveTrap(unit);
	Duciel.hunter:Carve(unit);
	Duciel.main:SpellCast("Lacerate");
	Duciel.main:SpellCast("Mongoose Bite");
	Duciel.main:SpellCast("Wing Clip");
	Duciel.main:SpellCast("Raptor Strike");
end
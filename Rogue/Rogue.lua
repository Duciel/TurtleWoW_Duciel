Duciel = Duciel.main:GetFrame();
Duciel.rogue = {};

setmetatable(Duciel.rogue, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.rogue:IsStealthed()
	local stealthArray = {1787, 1786, 1785, 1784};
	
	if Duciel.main:FindBuff(stealthArray, "player") then
		return true;
	else
		return false;
	end
end

function Duciel.rogue:Stealth()
	if not(Duciel.main:IsInCombat()) and not(Duciel.rogue:IsStealthed()) then
		Duciel.main:SpellCast("Stealth");
	end
end

function Duciel.rogue:PickPocket(unit)
	if unit == nil then
		unit = "target"
	end
	
	local spell = "Pick Pocket";
	
	local _, guid = UnitExists(unit);
	
	if Duciel.rogue:IsStealthed() and (Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 300 < GetTime()) then
		Duciel.main:SpellCast(spell, unit);
	end
end

function Duciel.rogue:CheapShot(unit)
	if Duciel.rogue:IsStealthed() then
		Duciel.main:SpellCast("Cheap Shot", unit);
	end
end

function Duciel.rogue:Envenom(unit)
	local combo = GetComboPoints();
	
	if not(Duciel.main:FindBuff(52531, "player")) and combo > 0 then
		Duciel.main:SpellCast("Envenom", unit);
	end
end

function Duciel.rogue:SliceAndDice(unit)
	local combo = GetComboPoints();
	
	if not(Duciel.main:FindBuff(6774, "player")) and combo > 0 then
		Duciel.main:SpellCast("Slice and Dice", unit);
	end
end

function Duciel.rogue:Zamatarr(unit)
	Duciel.rogue:Stealth();
	Duciel.rogue:PickPocket(unit);
	Duciel.rogue:CheapShot(unit);
	if not(Duciel.rogue:IsStealthed()) then
		Duciel.rogue:Envenom(unit);
		Duciel.rogue:SliceAndDice(unit);
		Duciel.main:SpellCast("Noxious Assault", unit);
	end
end
Duciel = Duciel.main:GetFrame();
Duciel.mage = {};

setmetatable(Duciel.mage, {__index = getfenv(0)});
setfenv(1, getfenv(0));


function Duciel.mage:Arcane()
	Duciel.main:SpellCast("Arcane Surge");
	if Duciel.main:GetSpellCooldownByName("Arcane Rupture") == 0 then
		Duciel.main:SpellCast("Arcane Rupture");
	else
		Duciel.main:SpellCast("Arcane Missiles");
	end
end
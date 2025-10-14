Duciel = Duciel.main:GetFrame();
Duciel.mage = {};

setmetatable(Duciel.mage, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.mage:ArcaneRupture(unit)
	if not(Duciel.main:FindDebuff(52502, "player")) then
		Duciel.main:SpellCast("Arcane Rupture", unit);
	end
end

function Duciel.mage:ArcaneSurge(unit)
	if not(Duciel.main:FindDebuff(52502, "player")) then
		Duciel.main:SpellCast("Arcane Surge", unit);
	end
end

function Duciel.mage:Arcane(unit)
	if not(pfUI.env.UnitChannelInfo("player")) then
		Duciel.mage:ArcaneRupture(unit);
		Duciel.mage:ArcaneSurge(unit);
		Duciel.main:SpellCast("Arcane Missiles", unit);
	end
end
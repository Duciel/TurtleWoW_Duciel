Duciel = Duciel.main:GetFrame();
Duciel.mage = {};

setmetatable(Duciel.mage, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.mage:ArcaneRupture(unit)
	if unit == nil then
		unit = "target"
	end
	if UnitName(unit) ~= "Soul Weaver" then
		if not(Duciel.main:FindDebuff(52502, "player")) then
			Duciel.main:SpellCast("Arcane Rupture", unit);
		end
	end
end

function Duciel.mage:ArcaneSurge(unit)
	if unit == nil then
		unit = "target"
	end
	if UnitName(unit) ~= "Soul Weaver" then
		Duciel.main:SpellCast("Arcane Surge", unit);
	end
end

function Duciel.mage:AmpMagic(unit)
	local spell = "Amplify Magic";
	if unit == nil then
		unit = "target"
	end
	
	local _, guid = UnitExists(unit);
	
	if UnitLevel(unit) < 83 and UnitInRaid("player") == 1 then
		if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 600 < GetTime() then
			Duciel.main:SpellCast(spell, unit);
		end
	end
end

function Duciel.mage:Cooldowns()
	local quickness = 61181; -- Potion of Quickness
	
	Duciel.main:JujuFlurry("player");
	Duciel.main:UseBagItem(quickness);
	Duciel.main:UseTrinket(true, true);
	if Duciel.main:GetItemCooldown(quickness) > 0 then
		Duciel.main:SpellCast("Arcane Power");
	end
end

function Duciel.mage:CastAndRun(unit)
	Duciel.mage:ArcaneSurge(unit);
	Duciel.main:SpellCast("Fire Blast", unit);
	Duciel.mage:AmpMagic(unit);
end

function Duciel.mage:Arcane(unit)
	Duciel.mage:ArcaneRupture(unit);
	if not(pfUI.env.UnitChannelInfo("player")) then
		--Duciel.mage:ArcaneSurge(unit);
		Duciel.main:SpellCast("Arcane Missiles", unit);
	end
end
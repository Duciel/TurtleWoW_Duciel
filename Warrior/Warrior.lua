Duciel = Duciel.main:GetFrame();
Duciel.warrior = {};

setmetatable(Duciel.warrior, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.warrior:Sunder(unit)
	spell = "Sunder Armor";
	if unit == nil then
		unit = "target"
	end
	
	-- Apply sunder 
	local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor(unit);

	if (effectiveArmor > 0) then
		local sunderArray = {7386, 7404, 7405, 7406, 8380, 8381, 11596, 11597, 11598, 11599, 11971, 13444, 15502, 15572, 16145, 21081, 24317, 25051, 27991};
		local exposeArray = {8647, 8648, 8649, 8650, 8651, 8652, 11197, 11198, 11199, 11200, 30965, 30996};

		if not(Duciel.main:FindDebuff(sunderArray, unit, 5) or Duciel.main:FindDebuff(exposeArray, unit)) then
			Duciel.main:SpellCast(spell);
			return;
		end
		
		local _, guid = UnitExists(unit);
		local id = tostring(guid) .. spell;
		
		-- Make sure sunders do not drop
		if (Duciel.main:FindDebuff(sunderArray, unit, 5) and Duciel.main.debuffTracker[id] + 27 < GetTime()) then
			Duciel.main:SpellCast(spell);
			return;
		end
	end
end

function Duciel.warrior:Whirlwind(unit)	
	if Duciel.main:IsInRange(unit, 8, "AoE") then
		Duciel.main:SpellCast("Whirlwind", unit);
	end
end

function Duciel.warrior:ThunderClap(unit)
	if Duciel.main:IsInRange(unit, 8, "AoE") then
		Duciel.main:SpellCast("Thunder Clap", unit);
	end
end

function Duciel.warrior:DemoShout(unit)
	spell = "Demoralizing Shout";
	if unit == nil then
		unit = "target"
	end

	local demoArray = {9898, 11556, 11559, 27579};
	local _, guid = UnitExists(unit);
	local id = tostring(guid) .. spell;

	if not(Duciel.main:FindDebuff(demoArray, unit)) and (Duciel.main.debuffTracker[id] == nil or Duciel.main.debuffTracker[id] + 30 < GetTime()) then
		if Duciel.main:IsInRange(unit, 10, "AoE") then
			Duciel.main:SpellCast(spell);
		end
	end
end

function Duciel.warrior:Taunt(unit)
	if unit == nil then
		unit = "target"
	end
	
	if UnitName("targettarget") ~= UnitName("player") then
		Duciel.main:SpellCast("Taunt", unit);
	end
end

function Duciel.warrior:Rend(unit)
	spell = "Rend";
	if unit == nil then
		unit = "target"
	end
	
	local _, guid = UnitExists(unit);
	local id = tostring(guid) .. spell;
	
	if Duciel.main.debuffTracker[id] == nil or Duciel.main.debuffTracker[id] + 21 < GetTime() then
		Duciel.main:SpellCast(spell, unit);
	end
end

function Duciel.warrior:BattleShout()
	if not(Duciel.main:FindBuff(25289, "player")) then
		Duciel.main:SpellCast("Battle Shout");
	end
end

function Duciel.warrior:ChallengingShout()
	local lip = 3387; -- Limited Invulnerability Potion
	
	if (Duciel.main:GetSpellCooldownByName("Challenging Shout") == 0 and UnitMana("player") >= 5) then
		Duciel.main:UseBagItem(lip); 
		if Duciel.main:GetItemCooldown(lip) > 0 then
			Duciel.main:SpellCast("Challenging Shout");
		end
	end
end

function Duciel.warrior:Consumes(spec)
	-- Elixir of the Mongoose
	if not(Duciel.main:FindBuff(17538, "player")) then
		Duciel.main:UseBagItem(13452);
	end
	
	-- Juju Power
	if not(Duciel.main:FindBuff(16323, "player")) then
		Duciel.main:UseBagItem(12451, 1);
	end
	
	-- Winterfall Firewater
	if not(Duciel.main:FindBuff(17038, "player")) then
		Duciel.main:UseBagItem(12820);
	end
	
	if spec == "tank" then
		-- Elixir of Fortitude
		if not(Duciel.main:FindBuff(3593, "player")) then
			Duciel.main:UseBagItem(3825);
		end
		
		-- Elixir of Superior Defense
		if not(Duciel.main:FindBuff(11348, "player")) then
			Duciel.main:UseBagItem(13445);
		end
		
		-- Spirit of Zanza
		if not(Duciel.main:FindBuff(24382, "player")) then
			Duciel.main:UseBagItem(20079);
		end
		
		-- Ground Scorpok Assay
		if not(Duciel.main:FindBuff(10669, "player")) then
			Duciel.main:UseBagItem(8412);
		end
	end
	
	if spec == "dps" then
		-- R.O.I.D.S
		if not(Duciel.main:FindBuff(10667, "player")) then
			Duciel.main:UseBagItem(8410);
		end
	end
	
	-- Power Mushroom (24799) / eating Power Mushroom (24800)
	if not(Duciel.main:FindBuff(24799, "player")) and not(Duciel.main:FindBuff(24800, "player")) then
		Duciel.main:UseBagItem(51720);
	end
end

function Duciel.warrior:FuryDPS(unit, noAOE, noSunder)
	if unit == nil then
		unit = "target"
	end
	
	local rage = UnitMana("player");
	
	local _, _, isZerkActive = GetShapeshiftFormInfo(3)
	if isZerkActive == nil then
		CastShapeshiftForm(3);
	end
	
	Duciel.warrior:BattleShout();
	if not(noSunder) then
		Duciel.warrior:Sunder();
	end
	
	local currentTargetLife = UnitHealth(unit) / UnitHealthMax(unit);
	
	if (UnitClassification("target") == "worldboss" and currentTargetLife <= 0.35) then
		--Duciel.main:UseTrinket(true, true);
		Duciel.main:SpellCast("Death Wish");
	end
	
	if (UnitClassification("target") == "worldboss" and currentTargetLife <= 0.30) then
		Duciel.main:SpellCast("Blood Fury");
	end
	
	Duciel.main:SpellCast("Bloodthirst", unit);
	
	if currentTargetLife <= 0.2 then
		if (UnitClassification(unit) == "worldboss" and rage <= 85) then
			Duciel.main:SpellCast("Bloodrage");
		end
		Duciel.main:SpellCast("Execute", unit);
	end
	
	if not(noAOE) then
		Duciel.warrior:Whirlwind(unit);
	end
		
	Duciel.warrior:Rend(unit);
	Duciel.main:SpellCast("Overpower", unit);

	if rage >= 52 then
		Duciel.warrior:DemoShout(unit);
		Duciel.main:SpellCast("Hamstring", unit);
		Duciel.main:SpellCast("Sunder Armor", unit);
	end

	if Duciel.main:IsNotClipping("Bloodthirst") then
		if rage >= 42 then
			Duciel.main:SpellCast("Heroic Strike");
		end
	end
end

function Duciel.warrior:FuryAOE(unit)
	if unit == nil then
		unit = "target"
	end
	
	local rage = UnitMana("player");
	
	Duciel.warrior:BattleShout();

	Duciel.warrior:Whirlwind(unit);
	
	local currentTargetLife = UnitHealth(unit) / UnitHealthMax(unit);
	
	if currentTargetLife <= 0.2 then
		Duciel.main:SpellCast("Execute", unit);
	else
		Duciel.main:SpellCast("Bloodthirst", unit);
	end

	if Duciel.main:IsNotClipping("Whirlwind") and rage >= 55 then
		Duciel.warrior:DemoShout(unit);
		Duciel.warrior:Sunder(unit);
	end

	if rage >= 45 then
		Duciel.main:SpellCast("Cleave");
	end
end

function Duciel.warrior:FuryProtAOE(unit)
	if unit == nil then
		unit = "target"
	end
	
	local rage = UnitMana("player");

	Duciel.warrior:ThunderClap(unit);

	if rage >= 40 then
		Duciel.main:SpellCast("Cleave");
		
		if rage >= 55 then
			Duciel.warrior:BattleShout();
			Duciel.warrior:DemoShout(unit);
			Duciel.warrior:Sunder(unit);
			if rage >= 75 then
				Duciel.main:SpellCast("Bloodthirst", unit);
			end
		end
	end
end

function Duciel.warrior:FuryProt(unit)
	if unit == nil then
		unit = "target"
	end
	
	local rage = UnitMana("player");
	
	Duciel.main:SpellCast("Bloodthirst", unit);
	Duciel.main:SpellCast("Revenge", unit);

	if Duciel.main:IsNotClipping("Bloodthirst") and rage >= 42 then
		Duciel.main:SpellCast("Heroic Strike", unit);
		
		if rage >= 52 then
			Duciel.warrior:BattleShout();
			Duciel.warrior:DemoShout(unit);
			Duciel.main:SpellCast("Sunder Armor", unit);
		end
	end
end

function Duciel.warrior:DeepProt()
	if unit == nil then
		unit = "target"
	end
	
	local rage = UnitMana("player");
	local _, _, battleStanceActive = GetShapeshiftFormInfo(1);
	local _, _, defensiveStanceActive = GetShapeshiftFormInfo(2);
	local _, _, berserkerStanceActive = GetShapeshiftFormInfo(3);
	
	local currentTargetLife = UnitHealth(unit) / UnitHealthMax(unit);

    if (UnitName(unit) == "Vaelastrasz the Corrupt" and currentTargetLife <= 0.2 and defensiveStanceActive ~= 1) then
		Duciel.main:SpellCast("Execute", unit);
	end

	Duciel.main:SpellCast("Shield Slam", unit);
	Duciel.main:SpellCast("Concussion Blow", unit);
	
	if battleStanceActive == 1 then
		Duciel.main:SpellCast("Overpower", unit);
	else 
		if defensiveStanceActive == 1 then
			Duciel.main:SpellCast("Revenge", unit);
		else 
			Duciel.warrior:Whirlwind(unit);
		end
	end

	if Duciel.main:IsNotClipping("Shield Slam") and Duciel.main:IsNotClipping("Concussion Blow") and rage >= 30 then
		Duciel.warrior:BattleShout();
		Duciel.warrior:DemoShout(unit);
		if battleStanceActive == 1 or defensiveStanceActive == 1 then
			Duciel.warrior:Rend(unit);
		end
		Duciel.main:SpellCast("Sunder Armor", unit);
		
		if rage >= 45 then
			Duciel.main:SpellCast("Heroic Strike");
		end
	end
end

function Duciel.warrior:DeepProtAOE(unit)
	if unit == nil then
		unit = "target"
	end
	
	local rage = UnitMana("player");
	local _, _, battleStanceActive = GetShapeshiftFormInfo(1);
	local _, _, defensiveStanceActive = GetShapeshiftFormInfo(2);
	local _, _, berserkerStanceActive = GetShapeshiftFormInfo(3);
	
	if battleStanceActive == 1 or defensiveStanceActive == 1 then
		Duciel.warrior:ThunderClap(unit);
	else 
		Duciel.warrior:Whirlwind(unit);
	end

	if rage >= 30 then
		Duciel.warrior:BattleShout();
		Duciel.warrior:DemoShout(unit);
		if rage >= 50 then
			Duciel.main:SpellCast("Cleave");
		end
		
		if rage >= 65 then
			Duciel.main:SpellCast("Shield Slam", unit);
			Duciel.main:SpellCast("Concussion Blow", unit);
		end
	end
end

function Duciel.warrior:SingleTarget()
end
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
		
		-- Make sure sunders do not drop
		if (Duciel.main:FindDebuff(sunderArray, unit, 5) and Duciel.main.cooldownTracker[spell] + 27 < GetTime()) then
			Duciel.main:SpellCast(spell);
			return;
		end
	end
end

function Duciel.warrior:DemoShout(unit)
	if unit == nil then
		unit = "target"
	end

	local demoArray = {9898, 11556};

	if not(Duciel.main:FindDebuff(demoArray, unit)) then
		Duciel.main:SpellCast("Demoralizing Shout");
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

function Duciel.warrior:Rend()
	spell = "Rend";
	if Duciel.main.cooldownTracker[spell] == nil or Duciel.main.cooldownTracker[spell] + 21 < GetTime() then
		Duciel.main:SpellCast(spell);
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

function Duciel.warrior:FuryDPS(noAOE, noSunderr)
	local rage = UnitMana("player");
	
	local _, _, isZerkActive = GetShapeshiftFormInfo(3)
	if rage <= 25 and isZerkActive == nil then
		CastShapeshiftForm(3);
	end
	
	Duciel.warrior:BattleShout();
	if not(noSunderr) then
		Duciel.warrior:Sunder();
	end
	--Duciel.warrior:DemoShout();
	
	local currentTargetLife = UnitHealth("target") / UnitHealthMax("target")
	
	if (UnitClassification("target") == "worldboss" and currentTargetLife <= 0.25) then
		Duciel.main:SpellCast("Death Wish");
	end
	
	if currentTargetLife <= 0.2 then
		if UnitClassification("target") == "worldboss" then
			Duciel.main:SpellCast("Blood Fury");
		end
		if (UnitAttackPower("player") > 1785 and rage >= 30 and rage <= 60) then
			Duciel.main:SpellCast("Bloodthirst");
		else
			if (UnitClassification("target") == "worldboss" and rage <= 85) then
				Duciel.main:SpellCast("Bloodrage");
			end
			Duciel.main:SpellCast("Execute");
		end
	end
	
	Duciel.main:SpellCast("Bloodthirst");
	
	--if Duciel.main:IsNotClipping("Bloodthirst") then
		if not(noAOE) then
			Duciel.main:SpellCast("Whirlwind");
		end
		
		--if (Duciel.main:IsNotClipping("Whirlwind") or noAOE) then
			--Duciel.warrior:Rend();
			--Duciel.main:SpellCast("Overpower");

			if rage >= 52 then
				Duciel.main:SpellCast("Hamstring");
				Duciel.main:SpellCast("Sunder Armor");
			end
		--end
	--end

	if rage >= 42 then
		Duciel.main:SpellCast("Heroic Strike");
	end
end

function Duciel.warrior:FuryAOE()
	local rage = UnitMana("player");
	Duciel.warrior:BattleShout();
	--Duciel.warrior:DemoShout();

	Duciel.main:SpellCast("Whirlwind");
	Duciel.main:SpellCast("Execute");
	Duciel.main:SpellCast("Bloodthirst");

	if Duciel.main:IsNotClipping("Whirlwind") and rage >= 55 then
		Duciel.warrior:Sunder();
	end

	if rage >= 45 then
		Duciel.main:SpellCast("Cleave");
	end
end

function Duciel.warrior:FuryProtAOE()
	local rage = UnitMana("player");

	Duciel.main:SpellCast("Thunder Clap");

	if Duciel.main:IsNotClipping("Thunder Clap") and rage >= 40 then
		Duciel.main:SpellCast("Cleave");
		
		if rage >= 55 then
			Duciel.warrior:BattleShout();
			Duciel.warrior:DemoShout();
			Duciel.warrior:Sunder();
			if rage >= 75 then
				Duciel.main:SpellCast("Bloodthirst");
			end
		end
	end
end

function Duciel.warrior:FuryProt()
	local rage = UnitMana("player");

	Duciel.main:SpellCast("Bloodthirst");
	Duciel.main:SpellCast("Revenge");

	if Duciel.main:IsNotClipping("Bloodthirst") and rage >= 42 then
		Duciel.main:SpellCast("Heroic Strike");
		
		if rage >= 52 then
			Duciel.warrior:BattleShout();
			Duciel.warrior:DemoShout();
			Duciel.main:SpellCast("Sunder Armor");
		end
	end
end
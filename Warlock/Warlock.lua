Duciel = Duciel.main:GetFrame();
Duciel.warlock = {};

setmetatable(Duciel.warlock, {__index = getfenv(0)});
setfenv(1, getfenv(0));

local isChannelingDarkHarvest = false;

function Duciel.warlock:GetHaste()
	local haste = Duciel.main:GetHaste();
	
	local name, icon, col, line, rank, maxRank = GetTalentInfo(1, 14);
	
	if maxRank > 0 then
		haste = haste / (1 + ((rank * 3)/100));
	end
	return haste;
end

function Duciel.warlock:CurseOfRecklessness(unit)
    local spell = "Curse of Recklessness";
	if unit == nil then
		unit = "target"
	end
	
	local _, guid = UnitExists(unit);
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 120 < GetTime() then
        Duciel.main:SpellCast(spell, unit);
		
		local name, icon, col, line, rank, maxRank = GetTalentInfo(1, 14);
		if maxRank > 0 then
			Duciel.main:TrackSpellCast("Curse of Agony", unit);
		end
	end
end

function Duciel.warlock:CurseOfShadow(unit)
    local spell = "Curse of Shadow";
	if unit == nil then
		unit = "target"
	end
	
	local _, guid = UnitExists(unit);
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 300 < GetTime() then
        Duciel.main:SpellCast(spell, unit);
		
		local name, icon, col, line, rank, maxRank = GetTalentInfo(1, 14);
		if maxRank > 0 then
			Duciel.main:TrackSpellCast("Curse of Agony", unit);
		end
	end
end

function Duciel.warlock:CurseOfTheElements(unit)
    local spell = "Curse of the Elements";
	if unit == nil then
		unit = "target"
	end
	
	local _, guid = UnitExists(unit);
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 300 < GetTime() then
        Duciel.main:SpellCast(spell, unit);
		
		local name, icon, col, line, rank, maxRank = GetTalentInfo(1, 14);
		if maxRank > 0 then
			Duciel.main:TrackSpellCast("Curse of Agony", unit);
		end
	end
end

function Duciel.warlock:SiphonLife(unit, forceRefresh)
	local spell = "Siphon Life";
	if unit == nil then
		unit = "target";
	end
	
	local _, guid = UnitExists(unit);
	
	local duration = 30 * Duciel.warlock:GetHaste();
	
	if guid ~= nil then	
		if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + duration < GetTime() or forceRefresh == true then
			Duciel.main:SpellCast(spell, unit);
		end
	end
end

function Duciel.warlock:Corruption(unit, forceRefresh)
	local spell = "Corruption";
	if unit == nil then
		unit = "target";
	end
	
	local _, guid = UnitExists(unit);
	
	local duration = 18 * Duciel.warlock:GetHaste();
	
	if guid ~= nil then	
		if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + duration < GetTime() or forceRefresh == true then
			Duciel.main:SpellCast(spell, unit);
		end
	end
end

function Duciel.warlock:Nightfall(unit)
	local spell = "Shadow Bolt";
	if unit == nil then
		unit = "target";
	end
	
	if Duciel.main:FindBuff(17941, "player") then
		if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + 4 < GetTime() then
			Duciel.main:SpellCast(spell, unit);
		end
	end
end

function Duciel.warlock:DarkHarvest(unit)
	local spell = "Dark Harvest";
	if Duciel.main:GetSpellCooldownByName(spell) == 0 then
		Duciel.main:SpellCast(spell, unit);
		if Duciel.main:GetSpellCooldownByName(spell) > 0 then
			isChannelingDarkHarvest = true;
		end
	end
end

function Duciel.warlock:LifeTap()
	if Duciel.main:MissingMana(unit) > 900 then
		Duciel.main:SpellCast("Life Tap");
	end
end

function Duciel.warlock:AssignedCurse(curse, unit)
	if curse == "Curse of the Elements" then
		Duciel.warlock:CurseOfTheElements(unit);
	elseif curse == "Curse of Recklessness" then
		Duciel.warlock:CurseOfRecklessness(unit);
	elseif curse == "Curse of Shadow" then
		Duciel.warlock:CurseOfShadow(unit);
	else
		print("Incorrect curse");
	end
end

function Duciel.warlock:CurseOfAgonyDuration()
	local duration = 24;
	
	-- Eye of Dormant Corruption
	if Duciel.main:FindEquippedItem(55111) ~= nil then
		duration = duration + 3;
	end

	duration = duration * Duciel.warlock:GetHaste();
	
	return duration;
end

function Duciel.warlock:CurseOfAgony(unit, forceRefresh)
    local spell = "Curse of Agony";
	if unit == nil then
		unit = "target";
	end
	
	local _, guid = UnitExists(unit);
	if Duciel.main:GetDebuffTracker(spell, guid) == nil or Duciel.main:GetDebuffTracker(spell, guid) + Duciel.warlock:CurseOfAgonyDuration() < GetTime() or forceRefresh == true then
        Duciel.main:SpellCast(spell, unit);
	end
end

function Duciel.warlock:ForceRefresh(unit)
	Duciel.warlock:CurseOfAgony(unit);
	Duciel.warlock:Corruption(unit);
	Duciel.warlock:SiphonLife(unit);
end

function Duciel.warlock:Cooldowns()
	Duciel.main:JujuFlurry("player");
	Duciel.main:UseTrinket(true, true);
	Duciel.main:UseBagItem(61181); -- Potion of Quickness
end

function Duciel.warlock:Affliction(curse, unit, noAOE)
	local cursive = "multicurse";
	
	if curse == 1 then
		curse = "Curse of Recklessness";
	elseif curse == 2 then
		curse = "Curse of Shadow";
	elseif curse == 3 then
		curse = "Curse of the Elements";
	end
	
	if not(pfUI.env.UnitChannelInfo("player")) or isChannelingDarkHarvest == false then
		isChannelingDarkHarvest = false;
		if noAOE then
			Cursive:Curse(curse, unit, {refreshtime=0});
			Cursive:Curse("Curse of Agony", unit, {refreshtime=0});
			Cursive:Curse("Corruption", unit, {refreshtime=0});
			Cursive:Curse("Siphon Life", unit, {refreshtime=0});
		else
			Cursive:Multicurse(curse, "RAID_MARK", {refreshtime=0});
			Cursive:Multicurse("Curse of Agony", "RAID_MARK", {refreshtime=0});
			Cursive:Multicurse("Corruption", "RAID_MARK", {refreshtime=0});
			Cursive:Multicurse("Siphon Life", "RAID_MARK", {refreshtime=0});
		end
		Duciel.warlock:Nightfall(unit);
		Duciel.warlock:DarkHarvest(unit);
		if not(pfUI.env.UnitChannelInfo("player")) then
			Duciel.main:SpellCast("Drain Soul", unit);
			Duciel.warlock:LifeTap();
		end
	end
end

--precast immolate->racial/trinket/haste pot->curse->sl->corr->dh->ds->corr->curse->ds->sl->ds (if you don't get nightfall proc)
--precast immolate->racial/trinket/haste pot->curse->sl->corr->dh->ds->corr->curse->nightfall sb->sl->ds (if you get nightfall)
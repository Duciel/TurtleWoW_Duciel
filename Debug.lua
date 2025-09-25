Duciel = Duciel.main:GetFrame();
Duciel.debug = {};

setmetatable(Duciel.debug, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.debug:listDebuff(unit)
	if unit == nil or unit == "" then
		unit = "target";
	end
	print("listDebuff : " .. unit);
	print("X : ID (stack) | source | Icon Name");
	
	i = 1;
	icon = UnitDebuff(unit, i);
	
	while(icon ~= nil) do
		icon, stack, _, id = UnitDebuff(unit, i);
		source = "debuff";

		if (icon == nil) then
			icon, stack, id = UnitBuff(unit, i);
			source = "buff";
		end

		if (icon ~= nil) then
			print(i .. " : " .. id .. " (" .. stack .. ") | " .. source .. " | " .. icon);
		end
		i = i + 1;
	end
end

function Duciel.debug:listBuff(unit)
	if unit == nil or unit == "" then
		unit = "target";
	end
	print("listBuff : " .. unit);
	print("X : ID (stack) | Icon Name");
	
	i = 1;
	icon = UnitBuff(unit, i);
	
	while(icon ~= nil) do
		icon, stack, id = UnitBuff(unit, i);

		if (icon ~= nil) then
			print(i .. " : " .. id .. " (" .. stack .. ") | " .. icon);
		end
		i = i + 1;
	end
end

function Duciel.debug:listSpellBook()
	local i = 1; 
	local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
	print("X : Spell Name (Spell Rank)");
	
	while spellName do
		print(i .. " : " .. spellName .. '(' .. spellRank .. ')' );
		i = i + 1;
		spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
	end
end

function Duciel.debug:showWaitingList()
	local waitingList = Duciel.main:GetWaitingList();
	for k, v in pairs(waitingList) do
		local list = waitingList[k];
		local obj = list[1];
		local target = list[2];
		
		print(obj, k, target);
	end
end

function Duciel.debug:dump(o)
	if type(o) == 'table' then
	   local s = '{ ';
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end;
		  s = s .. '['..k..'] = ' .. dump(v) .. ',';
	   end
	   return s .. '} ';
	else
	   return tostring(o);
	end
 end

 function Duciel.debug:print(msg)
	 DEFAULT_CHAT_FRAME:AddMessage(msg);
 end
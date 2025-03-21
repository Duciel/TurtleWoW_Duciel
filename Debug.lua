Duciel = Duciel.main:GetFrame();
Duciel.debug = {};

setmetatable(Duciel.debug, {__index = getfenv(0)});
setfenv(1, getfenv(0));

function Duciel.debug:listDebuff(unit)
	print("listDebuff : " .. unit);
	if unit == nil then
		unit = "target";
	end
	
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
	print("listBuff : " .. unit);
	if unit == nil then
		unit = "target";
	end
	
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
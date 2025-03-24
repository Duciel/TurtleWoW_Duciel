---------- Main functions ----------
SLASH_DCAST1 = '/d_cast'
function SlashCmdList.DCAST(msg, editbox)
	local args = cleanArgs(msg);
	Duciel.main:SpellCast(args[1], args[2]);
end

SLASH_DMCAST1 = '/dm_cast'
function SlashCmdList.DMCAST(msg, editbox)
	local args = cleanArgs(msg);
	Duciel.main:SpellCast(args[1], args[2] or "mouseover");
end

SLASH_DTRINKETCAST1 = '/d_trinketcast'
function SlashCmdList.DTRINKETCAST(msg, editbox)
	local args = cleanArgs(msg);
	Duciel.main:TrinketAndCast(args[1], args[2], args[3], args[4]);
end

SLASH_DUSEITEM1 = '/d_useitem'
function SlashCmdList.DUSEITEM(msg, editbox)
	local args = cleanArgs(msg);
	Duciel.main:UseBagItem(args[1], args[2]);
end





---------- Debug Functions ----------
SLASH_DLISTBUFF1 = '/d_listbuff'
function SlashCmdList.DLISTBUFF(msg, editbox)
	local args = cleanArgs(msg);
	Duciel.debug:listBuff(args[1]);
end

SLASH_DLISTDEBUFF1 = '/d_listdebuff'
function SlashCmdList.DLISTDEBUFF(msg, editbox)
	local args = cleanArgs(msg);
	Duciel.debug:listDebuff(args[1]);
end

SLASH_DLISTSPELLBOOK1 = '/d_listspellbook'
function SlashCmdList.DLISTSPELLBOOK(msg, editbox)
	Duciel.debug:listSpellBook();
end

SLASH_DTEST1 = '/d_test'
function SlashCmdList.DTEST(msg, editbox)
	local args = cleanArgs(msg);
	print(args[1]);
end





---------- Functions ----------
function cleanArgs(msg)
	msg = string.gsub(msg, " *, *", ","); -- Trim the msg
	
	local args = {};
	local _, _, arg, rest = string.find(msg, "([^,]+),(.*)");
	
	if arg == nil then
		args[1] = msg;
	else
		local i = 1;
	
		while rest ~= nil do
			args[i] = arg;
			args[i+1] = rest;
			i = i+1;
			_, _, arg, rest = string.find(rest, "([^,]+),(.*)");
		end
	end

	return args;
end
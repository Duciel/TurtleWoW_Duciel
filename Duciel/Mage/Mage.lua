Duciel = Duciel.main:GetFrame();
Duciel.mage = {};

setmetatable(Duciel.mage, {__index = getfenv(0)});
setfenv(1, getfenv(0));
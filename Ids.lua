--> Data and Types
_G.Ids = {}
export type Id = string
--<
--> Module
local module = {}
module.new = function(prefix : string, id : Id) : Id
	local id = id and prefix..id or tostring(prefix..math.random(1, 1048276))
	if not _G.Ids[id] then
		return id
	end
	repeat
		id = prefix..tostring(math.random(1, 1048276))
	until not _G.Ids[id]
	_G.Ids[id] = true
	return id
end
module.remove = function(id : Id)
	_G.Ids[id] = nil
end
return module
--<
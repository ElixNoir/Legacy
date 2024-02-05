--> Instances
-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--<<
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<
--> Modules
local Ids = require(Modules:WaitForChild("Ids"))
local Items = require(Modules:WaitForChild("Items"))
local Utilities = require(Modules:WaitForChild("Utilities"))
local Settings = require(Modules:WaitForChild("Settings"))
--<
--> Data and Types
_G.Inventories = {}
export type Inventory = {
	Active : {},
	Id : nil,
	Inactive : {},
	Metadata : {}
}
--<
--> Module
local module = {}
module.getActiveAttributes = function(inventory)
	local t = {}
	for _, item in pairs(inventory.Active) do
		for attributeName, attribute in pairs(item.Attributes) do
			t[attributeName] = (t[attributeName] or 0) + attribute
		end
	end
	return t
end
module.getActiveStats = function(inventory)
	local t = {}
	for _, item in pairs(inventory.Active) do
		for statName, stat in pairs(item.Stats) do
			t[statName] = (t[statName] or 0) + stat
		end
	end
	return t
end
module.getDefault = function()
	return {
		Active = {},
		Id = nil,
		Inactive = {},
		Metadata = {}
	}
end
module.new = function(inventory : Inventory, id : Ids.Id) : Inventory
	inventory = inventory or module.getDefault()
	local id = Ids.new("Inventory: ", id or inventory.Id)
	inventory.Id = id
	_G.Inventories[id] = inventory
	return _G.Inventories[id]
end
module.remove = function(inventory : Inventory)
	_G.Inventories[inventory.Id] = nil
	Ids.remove(inventory.Id)
	return
end
return module
--<
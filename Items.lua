--> Instances
-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--<<
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<
--> Modules
local Ids = require(Modules:WaitForChild("Ids"))
local Utilities = require(Modules:WaitForChild("Utilities"))
local Settings = require(Modules:WaitForChild("Settings"))
--<
--> Data and Types
_G.Items = {}
export type Item = {
	Attributes : {},
	Id : nil,
	Metadata : {},
	Properties : {
		Material : string,
		Rarity : string
	},
	References : {
		Model : Model
	},
	["Stats"] : {
		Actuals : {
			Agility : number,
			CriticalChance : number,
			Defense : number,
			Health : number,
			Mana : number,
			Power : number,
			Resistance : number,
			Stamina : number,
			Strength : number,
			Tempo : number
		},
		Components : {
			Agility : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			CriticalChance : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Defense : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			DefenseRegeneration : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Health : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			HealthRegeneration : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Mana : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			ManaRegeneration : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Power : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Resistance : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Stamina : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			StaminaRegeneration : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Strength : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			},
			Tempo : {
				Absolute : number,
				Additive : number,
				Base : number,
				Maximum : number,
				Multiplier : number
			}
		}
	}
}
--<
--> Module
local module = {}
module.getDefault = function()
	return {
		Attributes = {},
		Id = nil,
		Metadata = {},
		Properties = {
			Material = nil,
			Rarity = nil
		},
		References = {
			Model = nil
		},
		["Stats"] = {
			Components = {
				Agility = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				CriticalChance = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Defense = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Experience = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Health = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Mana = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Power = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Resistance = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Stamina = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Strength = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				},
				Tempo = {
					Absolute = 0,
					Additive = 0,
					Base = 0,
					Maximum = 0,
					Multiplier = 0
				}
			}
		}
	}
end
module.new = function(item : Item, id : Ids.Id) : Item
	item = item or module.getDefault()
	local id = Ids.new("Item: ", id or item.Id)
	item.Id = id
	_G.Items[id] = item
	return _G.Items[id]
end
module.remove = function(item : Item)
	_G.Items[item.Id] = nil
	Ids.remove(item.Id)
	return
end
return module
--<
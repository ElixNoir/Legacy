--> Module
local module = {
	Binds = {
		LeftControl = {
			Action = "toggleCanSprint"
		}
	},
	Data = {
		SaveData = false :: boolean
	},
	Entities = {
		
	},
	Files = {
		PlayerChoice = true :: boolean
	},
	Messages = {
		ProximityMaximumDistance = 100 :: number
	},
	Partitions = {
		DefaultSize = 32
	},
	Players = {
		DefaultSpawnCFrame = CFrame.new(Vector3.new(0, -100, 0)) :: CFrame,
		RespawnTime = 5 :: number
	},
	Regions = {
		DefaultSpawn = "Area 1"
	},
	Sounds = {
		Materials = {
			Sounds = {
				Concrete = {
					"rbxassetid://9126746167",
					"rbxassetid://9126746098",
					"rbxassetid://9126745995",
					"rbxassetid://9126745877",
				},
				Fabric = {
					"rbxassetid://9126748130",
					"rbxassetid://9126747861",
					"rbxassetid://9126747720",
					"rbxassetid://9126747529"
				},
				Ground = {
					"rbxassetid://9126744390",
					"rbxassetid://9126744718",
					"rbxassetid://9126744263",
					"rbxassetid://9126744157"
				},
				Mud = {
					"rbxassetid://9126744390",
					"rbxassetid://9126744718",
					"rbxassetid://9126744263",
					"rbxassetid://9126744157"
				}
			},
			Reverberation = {
				Plastic = .2,
				Grass = .7,
				SmoothPlastic = .5,
				Cobblestone = .65,
				Concrete = .7,
				Fabric = .8,
				Wood = .5,
				WoodPlanks = .5,
				Brick = .7,
				Sand = .65,
				Ice = .3,
				Metal = .4,
				Marble = .2,
				Granite = .2
			}
		}
	},
	Structures = {
		
	},
	Tips = {
		Available = {
			"Dark Energy was my favorite game before FE.",
			"Greco Casadesus is, in my opinion, a great composer.",
			"If not loaded within 5 seconds, an error has occurred.",
			"Pressing F9 in Roblox opens an output.",
			"World of Magic was a great game.",
			"This game is in pre-alpha.  Expect errors and missing content!"
		}
	}
}
return module
--<
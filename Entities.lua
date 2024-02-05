--> Instances
-->> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
--<<
local Prefabricated = ReplicatedStorage:WaitForChild("Prefabricated")
local Animations = Prefabricated:WaitForChild("Animations")
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<
--> Modules
local Handlers = require(Modules:WaitForChild("Handlers"))
local Ids = require(Modules:WaitForChild("Ids"))
local Items = require(Modules:WaitForChild("Items"))
local Inventories = require(Modules:WaitForChild("Inventories"))
local Settings = require(Modules:WaitForChild("Settings"))
local Threads = require(Modules:WaitForChild("Threads"))
local Utilities = require(Modules:WaitForChild("Utilities"))
local World = require(Modules:WaitForChild("World"))
--<
--> Data and Types
_G.Entities = {}
local e = {}
export type Entity = {
	Attributes : {
		Charisma : number,
		Constitution : number,
		Dexterity : number,
		Intelligence : number,
		Level : number,
		Luck : number,
		Strength : number,
		Wisdom : number
	},
	Conditions : {
		Blocking : boolean,
		Invulnerable : boolean,
		SpawnProtected : boolean
	},
	History : {
		Attacks : {},
		LastAttack : nil
	},
	Init : {},
	Input : {
		CurrentCameraCFrame : CFrame,
		DirectedCFrame : CFrame,
		PrimaryPartCFrame : CFrame
	},
	Inventory : Inventories.Inventory,
	Metadata : {
		Player : Player,
		Respawn : {
			Time : number
		}
	},
	Model : nil,
	References : {
		Model : Model,
		PantsTemplate : nil,
		ShirtTemplate : nil,
		Scalars : {
			BodyDepthScale : number,
			BodyHeightScale : number,
			BodyProportionScale : number,
			BodyTypeScale : number,
			BodyWidthScale : number,
			HeadScale : number
		}
	},
	["Stats"] : {
		Actuals : {
			Agility : number,
			CriticalChance : number,
			Defense : number,
			Experience : number,
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
			Experience : {
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
	},
	StatusEffects : {
		Burning : false,
		Charging : false,
		Invulnerable : false,
		Protected : false
	},
	Thread : Threads.Thread,
	Type : nil
}
--<
--> Module
local module = {}
module.getDefault = function() : Entity
	return {
		Attributes = {
			Charisma = 0,
			Constitution = 0,
			Dexterity = 0,
			Intelligence = 0,
			Level = 0,
			Luck = 0,
			Strength = 0,
			Wisdom = 0
		},
		Conditions = {
			Blocking = false,
			Invulnerable = false,
			SpawnProtected = false
		},
		History = {
			Attacks = {},
			LastRegion = nil,
			LastAttack = nil
		},
		Init = {},
		Input = {
			CurrentCameraCFrame = CFrame.new(),
			DirectedCFrame = CFrame.new(),
			PrimaryPartCFrame = CFrame.new()
		},
		Inventory = nil,
		Metadata = {},
		Model = nil,
		References = {
			Model = Prefabricated.Rigs.Default,
			PantsTemplate = nil,
			ShirtTemplate = nil,
			Scalars = {
				BodyDepthScale = 1,
				BodyHeightScale = 1,
				BodyProportionScale = 0,
				BodyTypeScale = 0,
				BodyWidthScale = 1,
				HeadScale = 1
			}
		},
		["Stats"] = {
			Actuals = {
				Agility = 0,
				CriticalChance = 0,
				Defense = 0,
				DefenseRegeneration = 0,
				Health = 0,
				HealthRegeneration = 0,
				Mana = 0,
				ManaRegeneration = 0,
				Power = 0,
				Resistance = 0,
				Stamina = 0,
				StaminaRegeneration = 0,
				Strength = 0,
				Tempo = 0
			},
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
		},
		StatusEffects = {
			Burning = false,
			Charging = false,
			Invulnerable = false,
			Protected = false
		},
		Thread = nil,
		Type = nil
	}
end
module.initialize = function(entity : Entity)
	if type(entity) ~= "table" then
		return
	end
	entity.Init = Utilities.Tables.deepCopy(entity)
	entity.Init.Time = time()
	if type(entity.Inventory) ~= "table" then
		entity.Inventory = Inventories.new()
	end
	if type(entity.Thread) ~= "table" then
		entity.Thread = Threads.new()
	end
	entity.applyStatusEffect = function(self : Entity)
		return
	end
	entity.attack = function(self : Entity, attacker : Entity, damage : number)
		if math.max(self.Level, attacker.Level) < 50 or self.StatusEffects.Invulnerable or self.StatusEffects.Protected then
			return
		end
		self:damage(damage)
		table.insert(self.History.Attacks, {AttackerId = attacker.Id, Damage = damage, Time = time()})
		return
	end
	entity.changeAppearance = function(self : Entity)
		if not self.Model then
			return
		end
		local humanoid = self.Model:FindFirstChild("Humanoid")
		local pants = self.Model:FindFirstChild("Pants") :: Pants
		local shirt = self.Model:FindFirstChild("Shirt") :: Shirt
		if not humanoid then
			return
		end
		for scalarName, scalarValue in pairs(self.References.Scalars) do
			local scalar = humanoid:FindFirstChild(scalarName) :: NumberValue
			if not scalar then
				continue
			end
			scalar.Value = scalarValue
		end
		if pants then
			pants.PantsTemplate = self.References.PantsTemplate or ""
		end
		if shirt then
			shirt.ShirtTemplate = self.References.ShirtTemplate or ""
		end
		return
	end
	entity.charge = function(self : Entity)
		self.StatusEffects.Charging = not self.StatusEffects.Charging
		return
	end
	entity.damage = function(self : Entity, damage : number)
		self:setHealth(self.Attributes.Actuals.Health - damage)
		return
	end
	entity.equipItem = function(self : Entity, itemName : string)
		if not self.Model or not itemName then
			return
		end
		local humanoid = self.Model:FindFirstChild("Humanoid")
		local primaryPart = self.Model.PrimaryPart
		local wornItems = self.Model:FindFirstChild("Worn Items")
		if humanoid or not primaryPart or not wornItems then
			return
		end
		local itemFolder = ReplicatedStorage.Prefabricated.Items:FindFirstDescendant(itemName)
		local itemModels = itemFolder:GetChildren()
		for _, itemModel in pairs(itemModels) do
			if not itemModel:IsA("Model") or not itemModel:FindFirstChild("External Welds") then
				continue
			end
			local weldTo = itemModel:GetAttribute("WeldTo")
			local weldToPart = weldTo and self.Model:FindFirstChild(weldTo)
			if not weldToPart then
				continue
			end
			local itemModelClone = itemModel:Clone()
			local externalWelds = itemModelClone:FindFirstChild("External Welds")
			itemModelClone.Parent = wornItems
			if not externalWelds then
				itemModelClone:Destroy()
				continue
			end
			itemModelClone.Name = itemName
			Utilities.Constraints.weldBetweenManually(primaryPart, weldToPart, {C0 = CFrame.new(), C1 = CFrame.new(), Parent = externalWelds})
		end
		return
	end
	entity.kill = function(self : Entity, killer : Entity)
		self:setHealth(0, true)
		for _, record in pairs(self.History.Attacks) do
			local attacker = _G.Entities[record.AttackerId]
			if not attacker then
				continue
			end
			attacker:setExperience(attacker.Attributes.Experience + math.min(1, self.Attributes.Level - attacker.Attributes.Level)) -- finalize
		end
		if self.Model then
			for _, v in pairs(self.Model:GetDescendants()) do
				if v:IsA("Motor6D") then
					local attachment0, attachment1 = Instance.new("Attachment"), Instance.new("Attachment")
					attachment0.CFrame = v.C0
					attachment1.CFrame = v.C1
					attachment0.Parent = v.Part0
					attachment1.Parent = v.Part1
					local ballSocketConstraint = Instance.new("BallSocketConstraint")
					ballSocketConstraint.Attachment0 = attachment0
					ballSocketConstraint.Attachment1 = attachment1
					ballSocketConstraint.Parent = v.Parent
					v:Destroy()
				end
			end
			local humanoid = self.Model:FindFirstChild("Humanoid") :: Humanoid
			if humanoid then
				humanoid.Health = 0
				for _, v in pairs(self.Model:GetChildren()) do
					if v:IsA("BasePart") then
						local motor6D = v:FindFirstChildWhichIsA("Motor6D")
						if motor6D then
							local ballSocketConstraint = Instance.new("BallSocketConstraint")
							local attachment0 = Instance.new("Attachment")
							local attachment1 = Instance.new("Attachment")
							attachment0.CFrame = motor6D.C0
							attachment1.CFrame = motor6D.C1
							attachment0.Parent = motor6D.Part0
							attachment1.Parent = motor6D.Part1
							ballSocketConstraint.Attachment0 = attachment0
							ballSocketConstraint.Attachment1 = attachment1
							ballSocketConstraint.Parent = motor6D.Parent
							ballSocketConstraint.LimitsEnabled = false
							ballSocketConstraint.TwistLimitsEnabled = false
							motor6D:Destroy()
						end
					end
				end
			end
		end
		if killer then
			-- do stuff regarding the killer
		end
		if not self.Metadata.Respawn then
			return
		end
		task.wait(self.Metadata.Respawn.Time)
		local newModel = self:replaceModel()
		if self.Metadata.Player then
			self.Metadata.Player.Character = newModel
			-- do rigging here
		else
			-- do rigging here
		end
		self.Model.Parent = workspace:WaitForChild("Entities")
		self:spawn()
		return
	end
	entity.regenerateDefense = function(self : Entity, multiplier : number)
		self:setDefense(self.Stats.Actuals.Defense + self.Stats.Components.Defense.Maximum * self.Stats.Actuals.DefenseRegeneration * multiplier)
		return
	end
	entity.regenerateHealth = function(self : Entity, multiplier : number)
		self:setHealth(self.Stats.Actuals.Health + self.Stats.Components.Health.Maximum * self.Stats.Actuals.HealthRegeneration * multiplier)
		return
	end
	entity.regenerateMana = function(self : Entity, multiplier : number)
		self:setMana(self.Stats.Actuals.Mana + self.Stats.Components.Mana.Maximum * self.Stats.Actuals.ManaRegeneration * multiplier)
		return
	end
	entity.regenerateStamina = function(self : Entity, multiplier : number)
		self:setStamina(self.Stats.Actuals.Stamina + self.Stats.Components.Stamina.Maximum * self.Stats.Actuals.StaminaRegeneration * multiplier)
		return
	end
	entity.removeModel = function(self : Entity)
		if not self.Model then
			return
		end
		self.Model:Destroy()
		return
	end
	entity.replaceModel = function(self : Entity)
		if self.Type ~= "Player" then
			self:removeModel()
		end
		self.Model = self.References.Model and self.References.Model:Clone() or self.Init.References.Model and self.Init.References.Model:Clone()
		if not self.Model then
			return
		end
		self:changeAppearance()
		self.Model:SetAttribute("EntityId", self.Id)
		self.Model.Parent = workspace:WaitForChild("Entities")
		return self.Model
	end
	entity.setBlocking = function(self : Entity, value : boolean)
		self.Conditions.Blocking = value
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("SpawnProtected", value)
		return
	end
	entity.setInvulnerable = function(self : Entity, value : boolean)
		self.Conditions.Invulnerable = value
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("SpawnProtected", value)
		return
	end
	entity.setSpawnProtection = function(self : Entity, value : boolean)
		self.Conditions.SpawnProtected = value
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("SpawnProtected", value)
		return
	end
	entity.setDefense = function(self : Entity, value : number)
		self.Stats.Actuals.Defense = math.clamp(value, 0, self.Stats.Components.Defense.Maximum)
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("Defense", self.Stats.Actuals.Defense)
		return
	end
	entity.setExperience = function(self : Entity, value : number)
		self.Stats.Actuals.Experience = math.clamp(value, 0, self.Stats.Components.Experience.Maximum)
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("Experience", self.Stats.Actuals.Experience)
		return
	end
	entity.setHealth = function(self : Entity, value : number, killEnabled : boolean)
		self.Stats.Actuals.Health = math.clamp(value, 0, self.Stats.Components.Health.Maximum)
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("Health", self.Stats.Actuals.Health)
		if value > 0 then
			return
		end
		if not killEnabled then
			self:kill()
		end
		return
	end
	entity.setMana = function(self : Entity, value : number)
		self.Stats.Actuals.Mana = math.clamp(value, 0, self.Stats.Components.Mana.Maximum)
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("Mana", self.Stats.Actuals.Mana)
		return
	end
	entity.setStamina = function(self : Entity, value : number)
		self.Stats.Actuals.Stamina = math.clamp(value, 0, self.Stats.Components.Stamina.Maximum)
		if typeof(self.Model) == "Model" then
			return
		end
		self.Model:SetAttribute("Stamina", self.Stats.Actuals.Stamina)
		if value >= 0 then
			return
		end
		self:setHealth(self.Stats.Actuals.Health + value)
		return
	end
	entity.spawn = function(self : Entity) : CFrame
		if not self.Model then
			return
		end
		local region = _G.Regions[self.History.LastRegion or Settings.Regions.DefaultSpawn]
		if not region then
			return
		end
		local spawns = region.Spawns[string.split(self.Type, ":")[1].." Spawns"]
		if not spawns then
			return
		end
		local spawnPoint = Utilities.Tables.getRandomElement(spawns)
		if not spawnPoint then
			return
		end
		self.Model:SetAttribute("Spawned", true)
		self.Model:PivotTo(spawnPoint.CFrame)
		return
	end
	entity.unequipItem = function(self : Entity, itemName : string)
		if not self.Model or not itemName then
			return
		end
		local humanoid = self.Model:FindFirstChild("Humanoid")
		local primaryPart = self.Model.PrimaryPart
		local wornItems = self.Model:FindFirstChild("Worn Items")
		if humanoid or not primaryPart or not wornItems then
			return
		end
		local itemModels = wornItems:GetChildren()
		for _, itemModel in pairs(itemModels) do
			if itemModel.Name ~= itemName then
				continue
			end
			itemModel:Destroy()
		end
		return
	end
	Threads.bind(entity.Thread, "Regenerate", function(dt : number)
		entity:regenerateDefense(dt)
		entity:regenerateHealth(dt)
		entity:regenerateMana(dt)
		entity:regenerateStamina(dt)
	end)
	return entity
end
module.new = function(entity : Entity, id : Ids.Id) : Entity
	entity = entity or module.getDefault()
	local id = Ids.new("Entity: ", id or entity.Id)
	entity.Id = id
	_G.Entities[id] = entity
	return _G.Entities[id]
end
module.remove = function(entity : Entity)
	if entity.Model then
		entity.Model:Destroy()
	end
	_G.Entities[entity.Id] = nil
	Threads.remove(entity.Thread.Id)
	Ids.remove(entity.Id)
	return
end
return module
--<
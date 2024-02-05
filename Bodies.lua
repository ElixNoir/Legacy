--> Instances
-->> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
--<<
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<
--> Modules
local Ids = require(Modules:WaitForChild("Ids"))
local Partitions = require(Modules:WaitForChild("Partitions"))
local Settings = require(Modules:WaitForChild("Settings"))
local Threads = require(Modules:WaitForChild("Threads"))
local Utilities = require(Modules:WaitForChild("Utilities"))
local World = require(Modules:WaitForChild("World"))
--<
--> Data and Types
_G.Bodies = {}
export type Body = {
	Acceleration : Vector3,
	["CFrame"] : CFrame,
	Designated : {},
	DirectedCFrame : CFrame,
	Id : nil,
	Init : {},
	Material : nil,
	Metadata : {},
	Mesh : nil,
	References : {
		Mesh : nil
	},
	Size : Vector3,
	Thread : Threads.Thread,
	Type : string,
	Status : nil,
	Transparency : number,
	Velocity : Vector3
}
--<
--> Module
local module = {}
module.getDefault = function() : Body
	return {
		Acceleration = Vector3.zero,
		["CFrame"] = CFrame.new(),
		Designated = {},
		DirectedCFrame = CFrame.new(),
		Id = nil,
		Init = {},
		Material = nil,
		Mesh = nil,
		Metadata = {},
		References = {
			Mesh = nil
		},
		Size = Vector3.zero,
		Thread = nil,
		Type = nil,
		Status = nil,
		Transparency = 0,
		Velocity = Vector3.zero
	}
end
module.initialize = function(body : Body)
	if type(body) ~= "table" then
		return
	end
	body.Init = Utilities.Tables.deepCopy(body)
	body.Init.Time = time()
	if type(body.Thread) ~= "table" then
		body.Thread = Threads.new()
	end
	if body.Type == "Blast" then
		body.Thread.Order = {
			"update",
			"clashCheck",
			"move"
		}
		body.applyRadialAoE = function(self : Body)
			for _, part in pairs(workspace:GetPartBoundsInRadius(self.CFrame.Position, self.Metadata.ExplosionSize, self.OverlapParams)) do -- finalize
				local entityId = part.Parent:GetAttribute("EntityId")
				local entity = entityId and _G.Entities[entityId]
				if entity then
					entity:attack(self.OwnerId, self.Static.Power)
					entity:applyStatusEffect()
				end
			end
		end
		body.clash = function(self : Body, bodyIds : Table) -- finalize
			local init = Utilities.Tables.deepCopy(self)
			init = time()
			self.Status = "Exploding"
			self.Velocity = Vector3.new()
			if RunService:IsClient() then
				self.Mesh.Size = init.Size + init.Size * self.Metadata.ExplosionSizeMultiplier
				-- Particle Stuff
				self.Mesh.Size = init.Size
			else
				self:applyRadialAoE()
			end
			Threads.unbind(body.Thread, "clashCheck")
			Threads.unbind(body.Thread, "move")
			Threads.unbind(body.Thread, "update")
			Threads.bind(body.Thread, "sizeUpdate", function()
				local et = (time() - init.Time)
				self.Size = init.Size + init.Size * self.Metadata.ExplosionSizeMultiplier * math.sin(math.min(.5 * math.pi, (10 / (init.Size.Y * self.Metadata.ExplosionSizeMultiplier + 5)) * math.pi * et))
				local calc = .05 * (init.Size.Y * self.Metadata.ExplosionSizeMultiplier + 5)
				if et >= calc then
					self:remove()
				end
				if not RunService:IsClient() then
					return
				end
				self.Mesh.Size = self.Size
				if et < calc then
					self.Mesh.Transparency = init.Mesh.Transparency + (1 - init.Mesh.Transparency) * (et / calc)
				else
					task.spawn(function()
						task.wait(2)
						self.Mesh:Destroy()
					end)
				end
			end)
			return true
		end
		body.collide = function(self : Body)
			local init = Utilities.Tables.deepCopy(self)
			init.Time = time()
			self.Status = "Exploding"
			self.Velocity = Vector3.new()
			if RunService:IsClient() then
				self.Mesh.Size = init.Size + init.Size * self.Metadata.ExplosionSizeMultiplier
				-- Particle Stuff
				self.Mesh.Size = init.Size
			else
				self:applyRadialAoE()
			end
			Threads.unbind(body.Thread, "clashCheck")
			Threads.unbind(body.Thread, "move")
			Threads.unbind(body.Thread, "update")
			Threads.bind(body.Thread, "sizeUpdate", function()
				local et = (time() - init.Time)
				self.Size = init.Size + init.Size * self.Metadata.ExplosionSizeMultiplier * math.sin(math.min(.5 * math.pi, (10 / (init.Size.Y * self.Metadata.ExplosionSizeMultiplier + 5)) * math.pi * et))
				local calc = .05 * (init.Size.Y * self.Metadata.ExplosionSizeMultiplier + 5)
				if et >= calc then
					self:remove()
				end
				if not RunService:IsClient() then
					return
				end
				self.Mesh.Size = self.Size
				if et < calc then
					self.Mesh.Transparency = init.Mesh.Transparency + (1 - init.Mesh.Transparency) * (et / calc)
				else
					task.spawn(function()
						task.wait(2)
						self.Mesh:Destroy()
					end)
				end
			end)
			return true
		end
		Threads.bind(body.Thread, "clashCheck", function()
			local partitionA = Partitions.getBoundingPartitionPosition(body.CFrame.Position - 0.5 * body.Size, Settings.DefaultPartitionSize)
			local partitionB = Partitions.getBoundingPartitionPosition(body.CFrame.Position + 0.5 * body.Size, Settings.DefaultPartitionSize)
			for x = partitionA.X, partitionB.X do
				for y = partitionA.Y, partitionB.Y do
					for z = partitionA.Z, partitionB.Z do
						local partition = _G.Partitions[tostring(Vector3.new(x, y, z))]
						if not partition then 
							continue 
						end
						local bodyIds = {}
						for bodyId2, _ in pairs(partition) do
							local body2 = _G.Bodies[bodyId2]
							if body.Id == bodyId2 or not body2 then
								continue
							end
							if (body2.CFrame.Position - body.CFrame.Position).Magnitude < 0.5 * (body.Size.Y + body2.Size.Y) and (body.OwnerId and body2.OwnerId and (body.OwnerId ~= body2.OwnerId) or (body.OwnerId == nil and body2.OwnerId == nil)) then
								table.insert(bodyIds, bodyId2)
							end
						end
						if #bodyIds > 0 then
							body:clash(bodyIds)
						end
					end
				end
			end
			return
		end)
		Threads.bind(body.Thread, "move", function(dt : number)
			body.Velocity += .5 * dt * body.Acceleration
			if body.Velocity.Magnitude > 0 then
				local raycast = workspace:Raycast(body.CFrame.Position, body.Velocity, body.RaycastParams)
				if raycast and raycast.Position then
					body.CFrame = CFrame.lookAlong(raycast.Position, body.Init.Direction)
					body:collide()
					return
				else
					body.CFrame = CFrame.lookAlong(body.CFrame.Position + body.Velocity, body.Init.Direction)
				end
				if RunService:IsClient() then
					body.Mesh.CFrame = body.CFrame
				end
			end
			body.Velocity += .5 * dt * body.Acceleration
			for _, part in pairs(workspace:GetPartBoundsInRadius(body.CFrame.Position, body.Size.Y, body.OverlapParams)) do
				local entityId = part.Parent:GetAttribute("EntityId")
				if entityId and _G.Entities[entityId] then
					body:collide()
					return
				end
			end
			Partitions.addIdToBoundingPartition(body.Id, body.CFrame.Position, body.Size)
			return
		end)
		Threads.bind(body.Thread, "update", function()
			local et = time() - body.Init.Time
			if et > 10 then
				body:collide()
				return
			end
			body.Size = body.Init.Size + Vector3.new(1, 1, 1) * body.Metadata.Size * math.sin(math.min(.5 * math.pi, (10 / (body.Metadata.Size + 5)) * math.pi * et))
			if not RunService:IsClient() then
				return
			end
			body.Mesh.Size = body.Size
			-- particles? finalize
			return
		end)
	else

	end
	return body
end
module.new = function(body : Body, id : Ids.Id) : Body
	body = body or module.getDefault()
	local id = Ids.new("Body: ", id or body.Id)
	body.Id = id
	_G.Bodies[id] = body
	return _G.Bodies[id]
end
module.remove = function(body : Body)
	Partitions.removeIdFromBoundingPartition(body.Id, body.CFrame.Position, body.Size)
	if body.Mesh then
		body.Mesh:Destroy()
	end
	_G.Bodies[body.Id] = nil
	Threads.remove(body.Id)
	Ids.remove(body.Id)
	return
end
return module
--<
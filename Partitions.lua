--> Instances
-->> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<<
--<
--> Modules
local Ids = require(Modules:WaitForChild("Ids"))
local Settings = require(Modules:WaitForChild("Settings"))
local Threads = require(Modules:WaitForChild("Threads"))
local Utilities = require(Modules:WaitForChild("Utilities"))
--> Data and Types
_G.Partitions = {}
--<
--> Module
local module = {}
module.addIdToBoundingPartition = function(id : Ids.Id, position : Vector3, size : Vector3)
	local partitionA = module.getBoundingPartitionPosition(position - 0.5 * size, Settings.Partitions.DefaultSize)
	local partitionB = module.getBoundingPartitionPosition(position + 0.5 * size, Settings.Partitions.DefaultSize)
	for x = partitionA.X, partitionB.X do
		for y = partitionA.Y, partitionB.Y do
			for z = partitionA.Z, partitionB.Z do
				local partitionId = tostring(Vector3.new(x, y, z))
				if not _G.Partitions[partitionId] then
					_G.Partitions[partitionId] = {}
				end
				_G.Partitions[partitionId][id] = true
			end
		end
	end
end
module.getBoundingPartitionPosition = function(boundedPosition : Vector3) : Vector3
	if not boundedPosition then 
		return nil
	end
	return Vector3.new(math.floor(boundedPosition.X / Settings.Partitions.DefaultSize), math.floor(boundedPosition.Y / Settings.Partitions.DefaultSize), math.floor(boundedPosition.Z / Settings.Partitions.DefaultSize))
end
module.removeIdFromBoundingPartition = function(id : string, position : Vector3, size : Vector3)
	local partitionA = module.Partition.getBoundingPartitionPosition(position - 0.5 * size, Settings.Partitions.DefaultSize)
	local partitionB = module.Partition.getBoundingPartitionPosition(position + 0.5 * size, Settings.Partitions.DefaultSize)
	for x = partitionA.X, partitionB.X do
		for y = partitionA.Y, partitionB.Y do
			for z = partitionA.Z, partitionB.Z do
				local partitionId = tostring(Vector3.new(x, y, z))
				if not module.Partitions[partitionId] then
					continue
				end
				module.Partitions[partitionId][id] = nil
			end
		end
	end
end
return module
--<
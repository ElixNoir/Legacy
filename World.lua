--> Instances
-->> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
--<<
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Regions = workspace:WaitForChild("Regions")
local Scenes = workspace:WaitForChild("Scenes")
--<
--> Modules
local Settings = require(Modules:WaitForChild("Settings"))
local Utilities = require(Modules:WaitForChild("Utilities"))
--<
--> Data and Types
_G.Regions = {}
_G.Scenes = {}
--<
--> Module
local module = {}
module.createPartSubdivisions = function(regionA : Table, regionB : Table, parent : Instance) : Table
	local subdivisions = Utilities.Spaces.subdivide(regionA, regionB)
	if not subdivisions then
		return
	end
	local partSubdivisions = {}
	for i, subdivision in pairs(subdivisions) do
		local part = Instance.new("Part")
		part.Name = "Subpart"
		part.Anchored = true
		part.CFrame = subdivision.CFrame
		part.Size = subdivision.Size
		part.Parent = parent or nil
		partSubdivisions[i] = part
	end
	return partSubdivisions
end
module.prepare = function()
	for _, region in pairs(Regions:GetChildren()) do
		_G.Regions[region.Name] = {
			Spawns = {
				["Boss Spawns"] = {},
				["NPC Spawns"] = {},
				["Player Spawns"] = {},
				["Structure Spawns"] = {}  
			}
		}
		local spawns = region:FindFirstChild("Spawns")
		if spawns then
			for _, spawnType in pairs(spawns:GetChildren()) do
				for _, spawnPart in pairs(spawnType:GetChildren()) do
					if spawnPart:IsA("BasePart") then
						table.insert(_G.Regions[region.Name].Spawns[spawnType.Name], {["CFrame"] = spawnPart.CFrame})
						spawnPart.Transparency = 1
					end
				end
			end
		end
	end
	for _, scene in pairs(Scenes:GetChildren()) do
		local cameraSequences = scene:FindFirstChild("Camera Sequences")
		_G.Scenes[scene.Name] = {
			Camera_Sequences = {}
		}
		for _, cameraSequence in pairs(cameraSequences:GetChildren()) do
			local cameraSequenceNumber = tonumber(cameraSequence.Name)
			local repeatCount = cameraSequence:GetAttribute("Repeat")
			if not cameraSequenceNumber or not repeatCount then
				continue
			end
			_G.Scenes[scene.Name].Camera_Sequences[cameraSequenceNumber] = {
				RepeatCount = repeatCount
			}
			for _, cameraPart in pairs(cameraSequence:GetChildren()) do
				local cameraPointNumber = tonumber(cameraPart.Name)
				local cameraPointType = cameraPart:GetAttribute("Type")
				if not cameraPointNumber or not cameraPointType or not cameraPart:IsA("BasePart") then
					continue
				end
				cameraPart.Transparency = 1
				if cameraPointType == "Face" then
					local objectToFace = cameraPart:FindFirstChild("Object To Face") :: ObjectValue
					if objectToFace and objectToFace.Value then
						_G.Scenes[scene.Name].Camera_Sequences[cameraSequenceNumber][cameraPointNumber] = {["CFrame"] = cameraPart.CFrame, Face = objectToFace.Value, Type = cameraPointType}
						continue
					end
				elseif cameraPointType == "Orbit" then
					_G.Scenes[scene.Name].Camera_Sequences[cameraSequenceNumber][cameraPointNumber] = {["CFrame"] = cameraPart.CFrame, Orbit = nil, Type = cameraPointType}
				end
			end
		end
	end
end
return module
--<
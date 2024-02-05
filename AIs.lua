--> Instances
-->> Services
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
--<<
local Prefabricated = ReplicatedStorage:WaitForChild("Prefabricated")
local Animations = Prefabricated:WaitForChild("Animations")
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<
--> Modules
local Actions = require(Modules:WaitForChild("Actions"))
local Bodies = require(Modules:WaitForChild("Bodies"))
local Ids = require(Modules:WaitForChild("Ids"))
local Entities = require(Modules:WaitForChild("Entities"))
local Utilities = require(Modules:WaitForChild("Utilities"))
local Settings = require(Modules:WaitForChild("Settings"))
local Threads = require(Modules:WaitForChild("Threads"))
--<
--> Data and Types
_G.AIs = {}
export type AI = {
	Active : boolean,
	Entity : Entities.Entity,
	Id : Ids.Id,
	Init : {},
	Metadata : {},
	MoveToPosition : Vector3,
	Path : Path,
	State : string,
	Thread : Threads.Thread
}
--<
--> Module
local module = {}
module.getDefault = function() : AI
	return {
		Active = false,
		Entity = nil,
		Init = {},
		Metadata = {},
		MoveToPosition = Vector3.zero,
		Path = nil,
		State = nil,
		Thread = nil
	}
end
module.initialize = function(ai : AI) : AI
	if type(ai) ~= "table" then
		return
	end
	ai.Init = Utilities.Tables.deepCopy(ai)
	ai.Init.Time = time()
	if type(ai.Entity) ~= "table" then
		ai.Entity = Entities.initialize(Entities.new())
	end
	if type(ai.Thread) ~= "table" then
		ai.Thread = Threads.new()
	end
	ai.Path = PathfindingService:CreatePath({
		AgentRadius = 3,
		AgentHeight = 5,
		AgentCanJump = true,
		WaypointSpacing = 2
	})
	ai.move = function(self : AI)
		local primaryPart = self.Entity.Model.PrimaryPart :: BasePart
		local humanoid = self.Entity.Model:FindFirstChild("Humanoid") :: Humanoid
		if not primaryPart or not humanoid then
			return
		end
		local moveDirection = (ai.MoveToPosition - primaryPart.Position)
		moveDirection -= Vector3.new(0, moveDirection.Y, 0)
		humanoid:MoveTo(ai.MoveToPosition)
		humanoid:SetAttribute("MoveDirection", moveDirection ~= Vector3.zero and moveDirection.Unit or Vector3.zero)
		humanoid.MoveToFinished:Wait(2)
		humanoid:SetAttribute("MoveDirection", Vector3.zero)
		return
	end
	ai.pathfind = function(self : AI)
		local primaryPart = self.Entity.Model.PrimaryPart :: BasePart
		if not primaryPart then
			return
		end
		local raycast = workspace:Raycast(primaryPart.Position, self.MoveToPosition - primaryPart.Position, Utilities.Parameters.newRaycastParams({self.Entity.Model}))
		if not raycast then
			self:move()
			return true
		end
		local s, r = pcall(function()
			self.Path:ComputeAsync(primaryPart.Position, self.MoveToPosition)
		end)
		if self.Path.Status == Enum.PathStatus.NoPath then
			return
		end
		local WayPoints = ai.Path:GetWaypoints()
		for i, WayPoint in ipairs(WayPoints) do
			local humanoid = self.Entity.Model:FindFirstChild("Humanoid") :: Humanoid
			self.MoveToPosition = WayPoint.Position
			self:move()
			if WayPoint.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end
		end
		return true
	end
	ai.wander = function(self : AI)
		local primaryPart = self.Entity.Model.PrimaryPart :: BasePart
		if not primaryPart then
			return
		end
		local result = nil
		repeat
			self.MoveToPosition = primaryPart.Position + Vector3.new(math.random(-32, 32), 0, math.random(-32, 32))
			result = self:pathfind()
			task.wait()
		until result
		return
	end
	ai.start = function(self : AI)
		while self.Active do
			task.wait(5 + math.random(0, 5))
			if not self.Entity or not self.Entity.Model then
				continue
			end
			self:wander()
		end
		return
	end
	--Threads.bind(ai.Thread, "findTarget", function()
	--return
	--end)
	return ai
end
module.new = function(ai : AI, id : Ids.Id) : AI
	ai = ai or module.getDefault()
	local id = Ids.new("AI: ", id or ai.Id)
	ai.Id = id
	_G.AIs[id] = ai
	return _G.AIs[id]
end
module.remove = function(ai : AI)
	_G.AIs[ai.Id] = nil
	Threads.remove(ai.Id)
	Ids.remove(ai.Id)
	return
end
return module
--<
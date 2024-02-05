--> Instances
-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
--<<
--<
--> Module
local module = {
	Animations = {},
	Constraints = {},
	Framework = {},
	Functions = {},
	Input = {},
	Instances = {},
	Log = {},
	NumberSequences = {},
	Parameters = {},
	Replication = {},
	Sounds = {},
	Spaces = {},
	Tables = {},
	["UDim2"] = {},
	["Vector3"] = {}
}
-->> Animations
module.Animations.loadTrack = function(animator : Animator, animationId : string, animationPriority : Enum.AnimationPriority) : AnimationTrack
	if not animationId then
		return
	end
	local animation = Instance.new("Animation")
	animation.AnimationId = animationId
	local animationTrack = animator:LoadAnimation(animation)
	animationTrack.Priority = animationPriority or Enum.AnimationPriority.Action
	return animationTrack
end
--<<
-->> Constraints
module.Constraints.weldBetweenAutomatically = function(part0 : Part, part1 : Part, parent : Instance) : WeldConstraint
	if not part0 or not part0:IsA("BasePart") or not part1 or not part1:IsA("BasePart") then
		return
	end
	local weldConstraint = Instance.new("WeldConstraint")
	weldConstraint.Part0 = part0
	weldConstraint.Part1 = part1
	weldConstraint.Parent = parent or nil
	return weldConstraint
end
module.Constraints.weldBetweenManually = function(part0 : Part, part1 : Part, parent : Instance, C0 : CFrame, C1 : CFrame) : ManualWeld
	if not part0 or not part0:IsA("BasePart") or not part1 or not part1:IsA("BasePart") then
		return
	end
	local weld = Instance.new("Weld")
	weld.Part0 = part0
	weld.Part1 = part1
	weld.C0 = C0 or CFrame.new()
	weld.C1 = C1 or CFrame.new()
	weld.Parent = parent or nil
	return weld
end
--<<
-->> Framework
module.Framework.classify = function(t, class)
	if type(t) ~= "table" or not class then
		return
	end
	setmetatable(t, {
		Class = class
	})
	return t
end
module.Framework.declassify = function(t)
	if type(t) ~= "table" then
		return
	end
	local mt = getmetatable(t)
	return mt and mt.Class or nil
end
--<<
-->> Functions
module.Functions.initWrap = function(func) : (any, any)
	local init = {
		Time = time()
	}
	return init, func()
end
module.Functions.log = function(func) : (any, any)
	local init, result = module.Functions.initWrap(func)
	table.insert(module.Log, {Function = func, Init = init, Return = result})
	return init, result
end
--<<
-->> Input
module.Input.getPressedKeysCodes = function()
	local keysPressed = UserInputService:GetKeysPressed()
	for i, inputObject in pairs(keysPressed) do
		keysPressed[i] = inputObject.KeyCode
	end
	return keysPressed
end
--<<
-->> Instances
module.Instances.getAttributeChangedSignal = function(instance : Instance, attributeName : string, func : "function") : RBXScriptConnection
	if typeof(instance) ~= "Instance" then
		return
	end
	local oldAttribute = instance:GetAttribute(attributeName)
	local event = instance:GetAttributeChangedSignal(attributeName):Connect(function()
		local newAttribute = instance:GetAttribute(attributeName)
		local result = func(oldAttribute, newAttribute)
		oldAttribute = newAttribute
		return result
	end)
	return event
end
module.Instances.getProperty = function(instance : Instance, propertyName : string)
	local s, r = pcall(function()
		return instance[propertyName]
	end)
	return s and r or nil
end
module.Instances.getPropertyChangedSignal = function(instance : Instance, propertyName : string, func : "function") : RBXScriptConnection
	if typeof(instance) ~= "Instance" then
		return
	end
	local oldProperty = module.Instances.getProperty(instance, propertyName)
	local event = instance:GetPropertyChangedSignal(propertyName):Connect(function()
		local newProperty = module.Instances.getProperty(instance, propertyName)
		local result = func(oldProperty, newProperty)
		oldProperty = newProperty
		return result
	end)
	return event
end
module.Instances.modify = function(instance : Instance, attributes : any, properties : any) : Instance
	if not instance then
		return
	end
	if attributes then
		for attributeName, attribute in pairs(attributes) do
			local s, r = pcall(function()
				instance:SetAttribute(attributeName, attribute)
			end)
			if not s then
				warn(r)
			end
		end
	end
	if properties then
		for propertyOrChildName, property in pairs(properties) do
			local s, r = pcall(function()
				instance[propertyOrChildName] = property
			end)
			if not s then
				warn(r)
			end
		end
	end
	return instance
end
--<<
-->> NumberSequences
module.NumberSequences.getKeypointsByFunction = function(timeIncrement : number, value : "function", variance : "function")
	if type(value) ~= "function" or type(timeIncrement) ~= "number" then
		return
	end
	local keypoints = {}
	local i = 0
	table.insert(keypoints, NumberSequenceKeypoint.new(i, value(i), type(variance) ~= "function" and 0 or variance(i)))
	repeat
		i += timeIncrement
		local min = math.min(1, i)
		table.insert(keypoints, NumberSequenceKeypoint.new(min, value(min), type(variance) ~= "function" and 0 or variance(min)))
	until i >= 1
	return NumberSequence.new(keypoints)
end
--<<
-->> Parameters
module.Parameters.newOverlapParams = function(filterDescendantsInstances : any, filterType : Enum.RaycastFilterType) : OverlapParams
	local params = OverlapParams.new()
	params.FilterDescendantsInstances = filterDescendantsInstances or {}
	params.FilterType = filterType or Enum.RaycastFilterType.Exclude
	return params
end
module.Parameters.newRaycastParams = function(filterDescendantsInstances : any, filterType : Enum.RaycastFilterType) : RaycastParams
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = filterDescendantsInstances or {}
	params.FilterType = filterType or Enum.RaycastFilterType.Exclude
	return params
end
--<<
-->> Replication
module.Replication.setNetworkOwnershipOfModel = function(model : Model, networkOwner : Player?)
	for _, descendant in pairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local success, errorReason = descendant:CanSetNetworkOwnership()
			if success then
				descendant:SetNetworkOwner(networkOwner)
			else
				error(errorReason)
			end
		end
	end
	return
end
--<<
-->> Sounds
--<<
-->> Spaces
module.Spaces.subdivide = function(regionA : any, regionB : any) : any
	local regionBRelativeToRegionA = regionA.CFrame:PointToObjectSpace(regionB.CFrame.Position)
	local position_ = {
		Side1 = regionA.CFrame.Position + regionA.Size / 2 + (regionBRelativeToRegionA - regionA.Size / 2 + regionB.Size / 2) / 2,
		Side2 = regionA.CFrame.Position - regionA.Size / 2 + (regionBRelativeToRegionA + regionA.Size / 2 - regionB.Size / 2) / 2
	}
	local size_ = {
		Side1 = -regionBRelativeToRegionA + regionA.Size / 2 - regionB.Size / 2,
		Side2 = regionBRelativeToRegionA + regionA.Size / 2 - regionB.Size / 2
	}
	local overlap = {
		Position = {X = 0, Y = 0, Z = 0},
		Size = {X = 0, Y = 0, Z = 0}
	}
	local subdivision = {}
	local boolConnect = true
	for i2, axis in pairs({"X", "Y", "Z"}) do
		overlap.Position[axis] = (math.max(regionA.CFrame.Position[axis] - regionA.Size[axis] / 2, regionA.CFrame.Position[axis] + regionBRelativeToRegionA[axis] - regionB.Size[axis] / 2) + math.min(regionA.CFrame.Position[axis] + regionA.Size[axis] / 2, regionA.CFrame.Position[axis] + regionBRelativeToRegionA[axis] + regionB.Size[axis] / 2)) / 2
		overlap.Size[axis] = math.max(0, math.min(math.abs(regionA.CFrame.Position[axis]) + regionA.Size[axis] / 2, math.abs(regionA.CFrame.Position[axis]) + math.abs(regionBRelativeToRegionA[axis]) + regionB.Size[axis] / 2) - math.max(0, math.max(math.abs(regionA.CFrame.Position[axis]) - regionA.Size[axis] / 2, math.abs(regionA.CFrame.Position[axis]) + math.abs(regionBRelativeToRegionA[axis]) - regionB.Size[axis] / 2)))
		if regionA.Size[axis] / 2 < regionBRelativeToRegionA[axis] - regionB.Size[axis] / 2 then
			boolConnect = false
		elseif -regionA.Size[axis] / 2 > regionBRelativeToRegionA[axis] + regionB.Size[axis] / 2 then
			boolConnect = false
		end
	end
	if not boolConnect then
		return
	end
	for i = 1, 2 do
		local size = size_["Side"..i]
		local position = position_["Side"..i]
		for i2, axis in pairs({"X", "Y", "Z"}) do
			if size[axis] > 0.001 and size[axis] < regionA.Size[axis] then
				local positionPlaceholder = {X = i2 <= 1 and regionA.Position.X or overlap.Position.X, Y = i2 <= 2 and regionA.Position.Y or overlap.Position.Y, Z = i2 <= 3 and regionA.Position.Z or overlap.Position.Z}
				local sizePlaceholder = {X = i2 <= 1 and regionA.Size.X or overlap.Size.X, Y = i2 <= 2 and regionA.Size.Y or overlap.Size.Y, Z = i2 <= 3 and regionA.Size.Z or overlap.Size.Z}
				positionPlaceholder[axis] = position[axis]
				sizePlaceholder[axis] = size[axis]
				subdivision[axis..i] = {
					["CFrame"] = CFrame.new(regionA.CFrame.Position) * (regionA.CFrame - regionA.CFrame.Position) * CFrame.new(Vector3.new(positionPlaceholder.X, positionPlaceholder.Y, positionPlaceholder.Z) - regionA.CFrame.Position),
					Size = Vector3.new(sizePlaceholder.X, sizePlaceholder.Y, sizePlaceholder.Z)
				}
			end
		end
	end
	return subdivision
end
--<<
-->> Tables
module.Tables.combine = function(recipient : any, t : any, includeMetatable : boolean)
	for i, v in pairs(t) do
		recipient[i] = v
	end
	if includeMetatable then
		setmetatable(recipient, getmetatable(t))
	end
	return
end
module.Tables.count = function(t : any)
	local count = 0
	for _, _ in pairs(t) do
		count += 1
	end
	return count
end
module.Tables.deepCopy = function(t : any)
	local copy = {}
	for i, v in pairs(t) do
		copy[i] = type(v) == "table" and module.Tables.deepCopy(v) or v
	end
	setmetatable(copy, getmetatable(t))
	return copy
end
module.Tables.getDefaultInit = function() : {Time : number}
	return {
		Time = time()
	}
end
module.Tables.getHighestValue = function(t : any) : number
	return math.max(table.unpack(t))
end
module.Tables.getLowestValue = function(t : any) : number
	return math.min(table.unpack(t))
end
module.Tables.getOrderedTable = function(t : any) : any
	local result = {}
	for _, v in pairs(t) do
		table.insert(result, v)
	end
	return result
end
module.Tables.getRandomElement = function(t : any) : any
	local result = {}
	for _, v in pairs(t) do
		table.insert(result, v)
	end
	return result[math.random(1, #result)]
end
module.Tables.getRandomWeighedElement = function(t : any)
	local maximumWeight = 0
	for i, _ in pairs(t) do
		maximumWeight += i
	end
	local rand = math.random(1, maximumWeight)
	for i, v in pairs(t) do
		if i < rand then
			continue
		end
		return v
	end
	return 
end
module.Tables.getRandomWeighedKey = function(t : any)
	local maximumWeight = 0
	for _, v in pairs(t) do
		maximumWeight += v
	end
	local rand = math.random(1, maximumWeight)
	for i, v in pairs(t) do
		if v < rand then
			continue
		end
		return i
	end
	return 
end
module.Tables.listen = function(t : any, mt : any, indexFunction : "function", newindexFunction : "function") : (any, any)
	local mt = mt or {}
	mt.Memory = {}
	if type(indexFunction) == "function" then
		mt.__index = function(t, i)
			indexFunction(mt.Memory, i)
			return rawget(mt.Memory, i)
		end
	else
		mt.__index = function(t, i)
			return rawget(mt.Memory, i)
		end
	end
	if type(newindexFunction) == "function" then
		mt.__newindex = function(t, i, v)
			rawset(mt.Memory, i, v)
			newindexFunction(mt.Memory, i, v)
		end
	else
		mt.__newindex = function(t, i, v)
			rawset(mt.Memory, i, v)
		end
	end
	setmetatable(t, mt)
	return t, mt
end
module.Tables.refer = function(t : any, path : any)
	local result = t
	for _, v in ipairs(path) do
		result = result[v]
	end
	return result
end
module.Tables.shallowCopy = function(t : any, includeMetatable : boolean)
	local copy = {}
	for i, v in pairs(t) do
		copy[i] = v
	end
	if includeMetatable then
		setmetatable(copy, getmetatable(t))
	end
	return copy
end
--<<
-->> UDim2
module.UDim2.add = function(a : UDim2, b : UDim2)
	return UDim2.new(a.X.Scale + b.X.Scale, a.X.Offset + b.X.Offset, a.Y.Scale + b.Y.Scale, a.Y.Offset + b.Y.Offset)
end
--<<
-->> Vector3
module.Vector3.getDistributedWholes2d = function(wholes : {}, center : Vector3, scalar : Vector3 | number) : Vector3
	local t = {}
	if type(wholes) == "number" then
		local a = math.ceil(math.sqrt(wholes))
		for i = 1, wholes do
			local b = math.floor(i / a)
			t[i] = Vector3.new(i - b * a - .5 * a, 0, b * a - .5 * a) * scalar
		end
	elseif type(wholes) == "table" then
		local count = #wholes
		if count == 0 then
			return
		end
		local a = math.ceil(math.sqrt(count))
		for i, v in ipairs(wholes) do
			local b = math.floor(i / a)
			t[i] = Vector3.new(i - b * a - .5 * a, 0, b * a - .5 * a) * scalar
		end
	end
	return t
end
--<<
return module
--<
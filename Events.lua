--> Instances
-->> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<<
--> Modules
local Ids = require(Modules:WaitForChild("Ids"))
local Settings = require(Modules:WaitForChild("Settings"))
local Utilities = require(Modules:WaitForChild("Utilities"))
--<
--> Data and Types
_G.Events = {
	Active = {},
	Inactive = {}
}
export type Event = {
	ConditionFunction : "function",
	ConnectedFunction : "function",
	Id : string,
	Metadata : {
		ConditionMet : false
	}
}
--<
--> Module
local module = {}
module.getDefault = function()
	return {
		Condition_Function = nil,
		Connected_Function = nil,
		Metadata = {
			Condition_Met = false
		},
		Id = nil
	}
end
--module.initialize = function(event : Event)
--return event
--end
module.connect = function(event : Event, func : "function")
	if type(event) ~= "table" or type(func) ~= "function" then
		return
	end
	event.Connected_Function = func
	return
end
module.disconnect = function(event : Event)
	if type(event) ~= "table" then
		return
	end
	event.Connected_Function = nil
	return
end
module.new = function(event : Event, id : Ids.Id) : (Ids.Id, any)
	event = event or module.getDefault()
	local id = Ids.new("Event: ", id or event and event.Id)
	if _G.Events.Active[id] or _G.Events.Inactive[id] then
		Ids.remove(id)
		return nil
	end
	event.Id = id
	_G.Events.Inactive[id] = event
	return id, _G.Events.Inactive[id]
end
module.remove = function(event : Event)
	if type(event) ~= "table" then
		return
	end
	_G.Events.Active[event.Id], _G.Events.Inactive[event.Id] = nil, nil
	Ids.remove(event.Id)
	return
end
module.setState = function(event : Event, active : boolean)
	if active then
		_G.Events.Active[event.Id] = event 
		_G.Events.Inactive[event.Id] = nil
	else
		_G.Events.Active[event.Id].Active = nil
		_G.Events.Inactive[event.Id] = event 
	end
	return
end
--<
--> Events
-->> RunService Events
RunService.Heartbeat:Connect(function(delta_Time : number)
	for id, event in pairs(_G.Events.Active) do
		if type(event.Condition_Function) ~= "function" or type(event.Connected_Function) ~= "function" then
			continue
		end
		local conditionMet = event.Condition_Function() :: boolean?
		if conditionMet then
			event.Connected_Function()
		end
	end
end)
return module
--<<
--<
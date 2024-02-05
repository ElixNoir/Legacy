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
local Settings = require(Modules:WaitForChild("Settings"))
local Utilities = require(Modules:WaitForChild("Utilities"))
--> Data and Types
_G.Threads = {}
export type Thread = {
	Id : string,
	Do : {},
	Order : {}
}
--<
--> Module
local module = {}
module.bind = function(thread : Thread, i : number | string, f : "function")
	if type(thread) ~= "table" or type(f) ~= "function" then
		return
	end
	if type(i) == "string" or type(i) == "number" then
		thread.Do[i] = f
	end
	return
end
module.getDefault = function() : Thread
	return {
		Id = nil,
		Do = {},
		Order = {}
	}
end
module.new = function(id : Ids.Id) : Thread
	local id = Ids.new("Thread: "..(id or ""))
	if _G.Threads[id] then
		return nil
	end
	_G.Threads[id] = module.getDefault()
	_G.Threads[id].Id = id
	return _G.Threads[id]
end
module.remove = function(id : Ids.Id)
	local id = "Thread: "..(id or "")
	Ids.remove(id)
	_G.Threads[id] = nil
	return
end
module.unbind = function(thread : Thread, i : number | string)
	if type(thread) ~= "table" then
		return
	end
	if type(i) == "string" or type(i) == "number" then
		thread.Do[i] = nil
	end
	return
end
return module
--<
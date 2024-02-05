--> Instances
-->> Services
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
local Files = DataStoreService:GetDataStore("Files")
_G.Files = {}
export type qFile = {
	Id : Ids.Id,
	Metadata : {},
	Saved : {},
	Session : {
		Binds : {}
	}
}
--<
--> Module
local module = {}
module.getDefault = function() : any
	return {
		Id = nil,
		Metadata = nil,
		Saved = {},
		Session = {
			Binds = Utilities.Tables.deepCopy(Settings.Binds)
		}
	}
end
module.new = function(file : qFile, id : Ids.Id) : qFile
	file = file or module.getDefault()
	if Settings.Data.Save_Data then
		local s, r = pcall(function()
			file.Saved = Files:GetAsync(id)
		end)
		if not s then
			return
		end
	end
	local id = Ids.new("File: ", id or file.Id)
	file.Id = id
	_G.Files[id] = file
	return _G.Files[id]
end
module.remove = function(file : qFile)
	_G.Files[file.Id] = nil
	Threads.remove(file.Id)
	Ids.remove(file.Id)
	return
end
return module
--<
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
local Ids = require(Modules:WaitForChild("Ids"))
local Settings = require(Modules:WaitForChild("Settings"))
local Utilities = require(Modules:WaitForChild("Utilities"))
--<
--> Data and Types
_G.Structures = {}
export type Structure = {
	Id : Ids.Id
}
--<
--> Module
local module = {}
module.new = function()
	
end
module.remove = function()
	
end
return module
--<
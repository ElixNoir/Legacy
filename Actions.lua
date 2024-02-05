--> Instances
-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
--<<
local Prefabricated = ReplicatedStorage:WaitForChild("Prefabricated")
local Animations = Prefabricated:WaitForChild("Animations")
local Modules = ReplicatedStorage:WaitForChild("Modules")
--<
--> Modules
local Utilities = require(Modules:WaitForChild("Utilities"))
--<
--> Data and Types
--<
--> Module
local module = {
	toggleBlock = {
		execute = function(self, character : Model)
			if not character or character:GetAttribute("Attacking") or not character:GetAttribute("CanBlock") then
				return
			end
			local blocking = character:GetAttribute("Blocking")
			if RunService:IsClient() then
				if blocking then
					
				end
				return
			end
			character:SetAttribute("Blocking", not blocking)
			return
		end
	},
	toggleAttack = {
		execute = function(self, character : Model, animator : Animator)
			if not character or not animator then
				return
			end
			local attacking = character:GetAttribute("Attacking")
			if RunService:IsClient() then
				if attacking then
					local animationTrack = animator:LoadAnimation(Animations.Attacks)
					animationTrack.Priority = Enum.AnimationPriority.Action
					repeat
						animationTrack:Play(.1)
						animationTrack.Stopped:Wait()
					until not character:GetAttribute("Attacking")
					if animationTrack then
						animationTrack:Stop(.1)
						animationTrack:Destroy()
					end
				end
				return
			end
			local canAttack = character:GetAttribute("CanAttack")
			if not canAttack then
				return
			end
			character:SetAttribute("Attacking", true)
			character:SetAttribute("CanAttack", false)
			task.spawn(function()
				task.wait(4)
				character:SetAttribute("Attacking", false)
				character:SetAttribute("CanAttack", true)
			end)
			return
		end
	},
	toggleSheath = {
		execute = function(self, character : Model, animator : Animator)
			if not character or not animator or character:GetAttribute("Attacking") or character:GetAttribute("Blocking") then
				return
			end
			local canAttack = character:GetAttribute("CanAttack")
			if RunService:IsClient() then
				if canAttack then
					local animationTrack = animator:LoadAnimation(Animations.Unsheath)
					animationTrack.Priority = Enum.AnimationPriority.Action
					animationTrack:Play(.1)
					animationTrack.Stopped:Wait()
				else
					local animationTrack = animator:LoadAnimation(Animations.Sheath)
					animationTrack.Priority = Enum.AnimationPriority.Action
					animationTrack:Play(.1)
					animationTrack.Stopped:Wait()
				end
				return
			end
			local rightHand = character:FindFirstChild("RightHand")
			local sword = rightHand:FindFirstChild("Sword")
			if canAttack and sword then
				sword:Destroy()
			elseif not canAttack and not sword then
				local sword = Prefabricated.Meshes.Items.Sword:Clone()
				sword.CanCollide = false
				sword.Massless = true
				sword.Parent = rightHand
				Utilities.Constraints.weld_Between_Manually(rightHand, sword, sword, CFrame.new(0, -.175, -1.925) * CFrame.fromOrientation(math.rad(-90), math.rad(90), 0))
			end
			character:SetAttribute("CanAttack", not canAttack)
			return
		end
	},
	toggleCanSprint = {
		execute = function(self, character : Model)
			if not character then
				return
			end
			local canSprint = character:GetAttribute("CanSprint")
			if RunService:IsClient() then
				return
			end
			character:SetAttribute("CanSprint", not canSprint)
			return
		end
	},
	toggleIdle = {
		execute = function(self, character : Model)
			if not character then
				return
			end
			local idle = character:GetAttribute("Idle")
			if RunService:IsClient() then
				return
			end
			character:SetAttribute("Idle", not idle)
			return
		end
	},
	toggleSprint = {
		execute = function(self, character : Model)
			if not character then
				return
			end
			local sprinting = character:GetAttribute("Sprinting")
			if RunService:IsClient() then
				return
			end
			character:SetAttribute("Sprinting", not sprinting)
			return
		end
	},
	toggleWalk = {
		execute = function(self, character : Model)
			if not character then
				return
			end
			local walking = character:GetAttribute("Walking")
			if RunService:IsClient() then
				return
			end
			character:SetAttribute("Walking", not walking)
			return
		end
	},
	Right = {
		execute = function(self, character : Model, animator : Animator)
			if not character or not animator then
				return
			end
			local attacking = character:GetAttribute("Attacking")
			if RunService:IsClient() then
				if attacking then
					local animationTrack = animator:LoadAnimation(Animations.Attacks)
					animationTrack.Priority = Enum.AnimationPriority.Action
					animationTrack:Play(.1)
					animationTrack.Stopped:Wait()
					animationTrack:Destroy()
				end
				return
			end
			local canAttack = character:GetAttribute("CanAttack")
			if not canAttack then
				return
			end
			character:SetAttribute("Attacking", true)
			character:SetAttribute("CanAttack", false)
			task.spawn(function()
				task.wait(4)
				character:SetAttribute("Attacking", false)
				character:SetAttribute("CanAttack", true)
			end)
			return
		end
	},
	Left = {
		execute = function(self, character : Model, animator : Animator)
			if not character or not animator then
				return
			end
			local attacking = character:GetAttribute("Attacking")
			if RunService:IsClient() then
				if attacking then
					local animationTrack = animator:LoadAnimation(Animations.Attacks)
					animationTrack.Priority = Enum.AnimationPriority.Action
					animationTrack:Play(.1)
					animationTrack.Stopped:Wait()
					animationTrack:Destroy()
				end
				return
			end
			local canAttack = character:GetAttribute("CanAttack")
			if not canAttack then
				return
			end
			character:SetAttribute("Attacking", true)
			character:SetAttribute("CanAttack", false)
			task.spawn(function()
				task.wait(4)
				character:SetAttribute("Attacking", false)
				character:SetAttribute("CanAttack", true)
			end)
			return
		end
	},
	Down = {
		execute = function(self, character : Model, animator : Animator)
			if not character or not animator then
				return
			end
			local attacking = character:GetAttribute("Attacking")
			if RunService:IsClient() then
				if attacking then
					local animationTrack = animator:LoadAnimation(Animations.Attacks)
					animationTrack.Priority = Enum.AnimationPriority.Action
					animationTrack:Play(.1)
					animationTrack.Stopped:Wait()
					animationTrack:Destroy()
				end
				return
			end
			local canAttack = character:GetAttribute("CanAttack")
			if not canAttack then
				return
			end
			character:SetAttribute("Attacking", true)
			character:SetAttribute("CanAttack", false)
			task.spawn(function()
				task.wait(4)
				character:SetAttribute("Attacking", false)
				character:SetAttribute("CanAttack", true)
			end)
			return
		end
	},
	Up = {
		execute = function(self, character : Model, animator : Animator)
			if not character or not animator then
				return
			end
			local attacking = character:GetAttribute("Attacking")
			if RunService:IsClient() then
				if attacking then
					local animationTrack = animator:LoadAnimation(Animations.Attacks)
					animationTrack.Priority = Enum.AnimationPriority.Action
					animationTrack:Play(.1)
					animationTrack.Stopped:Wait()
					animationTrack:Destroy()
				end
				return
			end
			local canAttack = character:GetAttribute("CanAttack")
			if not canAttack then
				return
			end
			character:SetAttribute("Attacking", true)
			character:SetAttribute("CanAttack", false)
			task.spawn(function()
				task.wait(4)
				character:SetAttribute("Attacking", false)
				character:SetAttribute("CanAttack", true)
			end)
			return
		end
	}
}
return module
--<
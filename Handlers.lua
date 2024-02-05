--> Instances
-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
--<<
local Prefabricated = ReplicatedStorage:WaitForChild("Prefabricated")
local Animations = Prefabricated:WaitForChild("Animations")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Animation = Remotes:WaitForChild("Animation")
--<
--> Modules
local Ids = require(Modules:WaitForChild("Ids"))
local Settings = require(Modules:WaitForChild("Settings"))
local Utilities = require(Modules:WaitForChild("Utilities"))
--> Data and Types
_G.Handlers = {}
--<
--> Module
local module = {
	Animations = {},
	Materials = {
		Stone = {
			destroy = function(basePart : BasePart)
				if not basePart then
					return
				end

				basePart:Destroy()
				return
			end
		}
	}
}
module.Animations.Default = function(model : Model)
	if not model then
		return
	end
	local humanoid = model:WaitForChild("Humanoid") :: Humanoid
	humanoid.WalkSpeed = 12
	local animator = humanoid:WaitForChild("Animator") :: Animator
	local movementState = "Idle"
	local moving = false
	local mostRecentAnimationTrack = nil
	local animationTracks = {}
	if RunService:IsClient() then
		animationTracks.Idle = animator:LoadAnimation(Animations.Movement.Idle)
		animationTracks.Idle:Play(.3)
		Utilities.Instances.getAttributeChangedSignal(model, "CanSprint", function(oldAttribute, newAttribute)
			if newAttribute then
				if moving and movementState == "Walking" then
					movementState = "Sprinting"
					local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 32})
					tween:Play()
					for _, animationTrack in pairs(animator:GetPlayingAnimationTracks()) do
						if animationTrack.Animation.Parent.Name == "Movement" then
							animationTrack:Stop(.3)
							animationTrack:Destroy()
						end
					end
					local associatedAnimation = Animations.Movement.Sprint
					animationTracks[associatedAnimation.Name] = animator:LoadAnimation(associatedAnimation)
					mostRecentAnimationTrack = animationTracks[associatedAnimation.Name]
					module.Animations.FootStep(model, mostRecentAnimationTrack)
					animationTracks[associatedAnimation.Name]:Play(.3)
				end
			elseif moving then
				movementState = "Walking"
				local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 12})
				tween:Play()
				for _, animationTrack in pairs(animator:GetPlayingAnimationTracks()) do
					if animationTrack.Animation.Parent.Name == "Movement" then
						animationTrack:Stop(.3)
						animationTrack:Destroy()
					end
				end
				local associatedAnimation = Animations.Movement.Walk
				animationTracks[associatedAnimation.Name] = animator:LoadAnimation(associatedAnimation)
				mostRecentAnimationTrack = animationTracks[associatedAnimation.Name]
				module.Animations.FootStep(model, mostRecentAnimationTrack)
				animationTracks[associatedAnimation.Name]:Play(.3)
			end
		end)
		Utilities.Instances.getPropertyChangedSignal(humanoid, "MoveDirection", function(oldProperty, newProperty)
			if not oldProperty then
				return
			end
			if not oldProperty or oldProperty.Magnitude == 0 and newProperty.Magnitude > 0 then
				moving = true
				if model:GetAttribute("CanSprint") then
					movementState = "Sprinting"
					local tween = TweenService:Create(humanoid, TweenInfo.new(.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 32})
					tween:Play()
					for _, animationTrack in pairs(animator:GetPlayingAnimationTracks()) do
						if animationTrack.Animation.Parent.Name == "Movement" then
							animationTrack:Stop(.3)
							animationTrack:Destroy()
						end
					end
					local associatedAnimation = Animations.Movement.Sprint
					animationTracks[associatedAnimation.Name] = animator:LoadAnimation(associatedAnimation)
					mostRecentAnimationTrack = animationTracks[associatedAnimation.Name]
					module.Animations.FootStep(model, mostRecentAnimationTrack)
					animationTracks[associatedAnimation.Name]:Play(.6)
				else
					movementState = "Walking"
					local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 12})
					tween:Play()
					for _, animationTrack in pairs(animator:GetPlayingAnimationTracks()) do
						if animationTrack.Animation.Parent.Name == "Movement" then
							animationTrack:Stop(.3)
							animationTrack:Destroy()
						end
					end
					local associatedAnimation = Animations.Movement.Walk
					animationTracks[associatedAnimation.Name] = animator:LoadAnimation(associatedAnimation)
					mostRecentAnimationTrack = animationTracks[associatedAnimation.Name]
					module.Animations.FootStep(model, mostRecentAnimationTrack)
					animationTracks[associatedAnimation.Name]:Play(.3)
				end
			elseif oldProperty and oldProperty.Magnitude > 0 and newProperty.Magnitude == 0 then
				moving = false
				movementState = "Idle"
				local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 0})
				tween:Play()
				for _, animationTrack in pairs(animator:GetPlayingAnimationTracks()) do
					if animationTrack.Animation.Parent.Name == "Movement" then
						animationTrack:Stop(.3)
						animationTrack:Destroy()
					end
				end
				local associatedAnimation = Animations.Movement.Idle
				animationTracks[associatedAnimation.Name] = animator:LoadAnimation(associatedAnimation)
				mostRecentAnimationTrack = animationTracks[associatedAnimation.Name]
				module.Animations.FootStep(model, mostRecentAnimationTrack)
				animationTracks[associatedAnimation.Name]:Play(.3)
			end
		end)
		Utilities.Instances.getPropertyChangedSignal(humanoid, "WalkSpeed", function(oldProperty, newProperty)
			if newProperty > 0 and newProperty <= 20 and movementState == "Walking" then
				mostRecentAnimationTrack:AdjustSpeed(.09 * newProperty)
			elseif newProperty > 20 and movementState == "Sprinting" then
				mostRecentAnimationTrack:AdjustSpeed(.06 * newProperty)
			end
		end)
	else
		Animation.RemoteEvent:FireAllClients(animator, Animations.Movement.Idle, .3)
		Utilities.Instances.getAttributeChangedSignal(model, "CanSprint", function(oldAttribute, newAttribute)
			if newAttribute then
				if moving and movementState == "Walking" then
					movementState = "Sprinting"
					local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 32})
					tween:Play()
					local associatedAnimation = Animations.Movement.Sprint
					Animation.RemoteEvent:FireAllClients(animator, associatedAnimation, .3)
				end
			elseif moving then
				movementState = "Walking"
				local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 12})
				tween:Play()
				local associatedAnimation = Animations.Movement.Walk
				Animation.RemoteEvent:FireAllClients(animator, associatedAnimation, .3)
			end
		end)
		Utilities.Instances.getAttributeChangedSignal(humanoid, "MoveDirection", function(oldAttribute, newAttribute)
			if not oldAttribute or oldAttribute.Magnitude == 0 and newAttribute.Magnitude > 0 then
				moving = true
				if model:GetAttribute("CanSprint") then
					movementState = "Sprinting"
					local tween = TweenService:Create(humanoid, TweenInfo.new(.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 32})
					tween:Play()
					local associatedAnimation = Animations.Movement.Sprint
					Animation.RemoteEvent:FireAllClients(animator, associatedAnimation, .6)
				else
					movementState = "Walking"
					local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 12})
					tween:Play()
					local associatedAnimation = Animations.Movement.Walk
					Animation.RemoteEvent:FireAllClients(animator, associatedAnimation, .3)
				end
			elseif oldAttribute and oldAttribute.Magnitude > 0 and newAttribute.Magnitude == 0 then
				moving = false
				movementState = "Idle"
				local tween = TweenService:Create(humanoid, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {WalkSpeed = 0})
				tween:Play()
				local associatedAnimation = Animations.Movement.Idle
				Animation.RemoteEvent:FireAllClients(animator, associatedAnimation, .3)
			end
		end)
		Utilities.Instances.getPropertyChangedSignal(humanoid, "WalkSpeed", function(oldProperty, newProperty)
			if newProperty > 0 and newProperty <= 20 and movementState == "Walking" then
				local associatedAnimation = Animations.Movement.Walk
				Animation.RemoteEvent:FireAllClients(animator, associatedAnimation, .3, .09 * newProperty)
			elseif newProperty > 20 and movementState == "Sprinting" then
				local associatedAnimation = Animations.Movement.Sprint
				Animation.RemoteEvent:FireAllClients(animator, associatedAnimation, .3, .06 * newProperty)
			end
		end)
	end
	return
end
module.Animations.FootStep = function(model : Model, animationTrack : AnimationTrack)
	if not model or not animationTrack then
		return
	end
	animationTrack:GetMarkerReachedSignal("Left Footstep"):Connect(function()
		local foot = model:FindFirstChild("LeftFoot") :: BasePart
		if not foot then
			return
		end
		local raycast = workspace:Raycast(foot.Position + Vector3.new(0, .5 * foot.Size.Y, 0), Vector3.new(0, -.5 - foot.Size.Y, 0), Utilities.Parameters.newRaycastParams({workspace.Regions}, Enum.RaycastFilterType.Include))
		if not raycast then
			return
		end
		local footprint = Instance.new("Part")
		footprint.Anchored = true
		footprint.CanCollide = false
		footprint.CanTouch = false
		footprint.CanQuery = false
		footprint.Size = Vector3.new(foot.Size.Z, 0.01, foot.Size.X)
		footprint.CFrame = CFrame.lookAlong(raycast.Position, raycast.Normal) * CFrame.Angles(math.rad(90), math.rad(-foot.Orientation.Y), 0)
		local materialSound = Prefabricated.Sounds.Materials:FindFirstChild(raycast.Material.Name or "Default")
		local footstep = materialSound and materialSound:FindFirstChild("Footstep")
		if not footstep then
			return
		end
		local sound = Utilities.Tables.getRandomElement(footstep:GetChildren()):Clone()
		sound.Parent = footprint
		footprint.Parent = workspace:FindFirstChild("Debris") or workspace
		sound:Play()
		local tween = TweenService:Create(footprint, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1})
		tween:Play()
		tween.Completed:Wait()
		footprint:Destroy()
	end)
	animationTrack:GetMarkerReachedSignal("Right Footstep"):Connect(function()
		local foot = model:FindFirstChild("RightFoot") :: BasePart
		if not foot then
			return
		end
		local raycast = workspace:Raycast(foot.Position + Vector3.new(0, .5 * foot.Size.Y, 0), Vector3.new(0, -.5 - foot.Size.Y, 0), Utilities.Parameters.newRaycastParams({workspace.Regions}, Enum.RaycastFilterType.Include))
		if not raycast then
			return
		end
		local footprint = Instance.new("Part")
		footprint.Anchored = true
		footprint.CanCollide = false
		footprint.CanTouch = false
		footprint.CanQuery = false
		footprint.Size = Vector3.new(foot.Size.Z, 0.01, foot.Size.X)
		footprint.CFrame = CFrame.lookAlong(raycast.Position, raycast.Normal) * CFrame.Angles(math.rad(90), math.rad(-foot.Orientation.Y), 0)
		local materialSound = Prefabricated.Sounds.Materials:FindFirstChild(raycast.Material.Name or "Default")
		local footstep = materialSound and materialSound:FindFirstChild("Footstep")
		if not footstep then
			return
		end
		local sound = Utilities.Tables.getRandomElement(footstep:GetChildren()):Clone()
		sound.Parent = footprint
		footprint.Parent = workspace:FindFirstChild("Debris") or workspace
		sound:Play()
		local tween = TweenService:Create(footprint, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1})
		tween:Play()
		tween.Completed:Wait()
		footprint:Destroy()
	end)
	return
end
return module
--<
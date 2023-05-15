local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Door = {}

Door.MaxDistance = 5

function Door.TagDoors()
	for i,v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "Door" and v:IsA("Model") then
			CollectionService:AddTag(v, "Door")
		end
	end
end

function Door.getClosestDoor(doorArray, playerCharacter)
	if not doorArray or not playerCharacter then return false end
	local closestDoor, closestMagnitude, testMagnitude

	for Index, Door in pairs(doorArray) do
		if closestDoor and closestMagnitude then
			testMagnitude = (Door.PrimaryPart.Position - playerCharacter.PrimaryPart.Position).Magnitude

			if testMagnitude < closestMagnitude then
				closestDoor = Door
				closestMagnitude = testMagnitude
			end
		else
			closestDoor = Door
			closestMagnitude = (Door.PrimaryPart.Position - playerCharacter.PrimaryPart.Position).Magnitude
		end
	end
	return closestDoor
end

function Door.open(character, door)
	--Get a vector that goes from the door to the character
	local doorToChar = character.HumanoidRootPart.Position - door.PrimaryPart.Position

	--Get the vector where the door itself faces
	local doorLookVect = door.PrimaryPart.CFrame.lookVector

	local Angle = door.Values.Angle
	local isOpen = door.Values.IsOpen
	local isLocked = door.Values.IsLocked
	local hinge = door.Pivot

	local tweenInfo = TweenInfo.new()
	local offset = hinge.CFrame:Inverse() * door.PrimaryPart.CFrame

	local doorOpen = TweenService:Create(Angle, tweenInfo, {Value = 90})
	local doorOpenBehind = TweenService:Create(Angle, tweenInfo, {Value = -90})
	local doorClose = TweenService:Create(Angle, tweenInfo, {Value = 0})
	if isLocked.value then
		return
	else
		if doorToChar:Dot(doorLookVect) > 0 then
			--Character is in front of the door

			if isOpen.Value then
				doorClose:Play()
				isOpen.Value = false
			else
				doorOpen:Play()
				isOpen.Value = true
			end
		else
			--Character is behind the door

			if isOpen.Value then
				doorClose:Play()
				isOpen.Value = false
			else
				doorOpenBehind:Play()
				isOpen.Value = true
			end
		end	

		RunService.Heartbeat:Connect(function(dt)
			door.PrimaryPart.CFrame =  hinge.CFrame * CFrame.Angles(0, math.rad(Angle.Value), 0) * offset
		end)
	end
end

return Door
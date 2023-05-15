local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DoorCollection = require(ReplicatedStorage:WaitForChild("DoorCollection"))

local DoorChangedStateEvent = ReplicatedStorage:WaitForChild("DoorChangedState")

DoorCollection.TagDoors()

local Doors = CollectionService:GetTagged("Door")
local MaxDistance = DoorCollection.MaxDistance

local function OnServerEvent(player, Door)
	local DoorRay = workspace:FindPartOnRay(Ray.new(player.Character.PrimaryPart.Position, 
		(Door.PrimaryPart.Position - player.Character.PrimaryPart.Position) * 10), 
		player.Character)

	local PlayerDistance = (player.Character.PrimaryPart.Position - Door.PrimaryPart.Position).Magnitude
	
	if  PlayerDistance <= MaxDistance 
		and DoorRay and DoorRay == Door.PrimaryPart and DoorCollection.getClosestDoor(Doors, player.Character) == Door then
		DoorCollection.open(player.Character, Door)
	end
end

DoorChangedStateEvent.OnServerEvent:Connect(OnServerEvent)
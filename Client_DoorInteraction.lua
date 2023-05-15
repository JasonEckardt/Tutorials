local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local DoorCollection = require(ReplicatedStorage:WaitForChild("DoorCollection"))

local DoorChangedStateEvent = ReplicatedStorage:WaitForChild("DoorChangedState")

DoorCollection.TagDoors()

local Doors = CollectionService:GetTagged("Door")
local LocalPlayer = Players.LocalPlayer
local MaxDistance = DoorCollection.MaxDistance

local function recieveInput(input, gameProcessedEvent)
	if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.E then
		for i,Door in pairs(Doors) do
			local DoorRay = workspace:FindPartOnRay(Ray.new(LocalPlayer.Character.PrimaryPart.Position, (Door.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position) * 10), LocalPlayer.Character)

			local PlayerDistance = (LocalPlayer.Character.PrimaryPart.Position - Door.PrimaryPart.Position).Magnitude

			if PlayerDistance <= MaxDistance and DoorRay and DoorRay == Door.PrimaryPart and DoorCollection.getClosestDoor(Doors, LocalPlayer.Character) == Door then
				DoorChangedStateEvent:FireServer(Door)
			end
		end
	end
end

UserInputService.InputBegan:Connect(recieveInput)
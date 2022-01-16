local function CheckSeatbelt(character)
	local player = getSpecificPlayer(character);
	print("ALIVE")
end

Events.OnExitVehicle.Add(CheckSeatbelt)
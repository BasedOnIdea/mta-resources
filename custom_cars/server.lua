function CustomVehicleCreate(customID, parentID, x, y, z)
	outputChatBox("Requested parentID: "..parentID, client)
	local veh = createVehicle(parentID, x, y, z)
	setElementData(veh, "customID", customID)
	triggerClientEvent("CustomVehicle:onCreate", source, veh)
end
addEvent("CustomVehicle:create", true)
addEventHandler("CustomVehicle:create", resourceRoot, CustomVehicleCreate)
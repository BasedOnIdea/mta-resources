local allocatedModels = {} -- actually stores allocated models game ID(as i see ID can change at each start so it is like malloc)

local function allocateModel(customID) 
	table.insert(allocatedModels, customID, { model = engineRequestModel("vehicle", Parent[customID]), isLoaded = false})
end

local function freeModel(customID) 
	engineFreeModel(allocatedModels[customID])
	allocatedModels[customID].model = nil
	allocatedModels[customID].isLoaded = nil
end

local function loadModel(customID)
	local name = FileNamePool[customID]

	if customID > 611 then
		if not allocatedModels[customID].isLoaded then
			local newModel = allocatedModels[customID].model
			outputChatBox(customID.." "..name)

			local fileNameTXD = MODELS_PATH .. name .. ".txd"
			local txd = engineLoadTXD(fileNameTXD)
			if txd then	
				engineImportTXD(txd, newModel)
			end
			
			local fileNameDFF = MODELS_PATH .. name .. ".dff"
			local dff = engineLoadDFF(fileNameDFF)
			if dff then
				engineReplaceModel(dff, newModel)
			end
		end
	else
		outputChatBox(customID.." "..name)
		
		local fileNameTXD = MODELS_PATH .. name .. ".txd"
		local txd = engineLoadTXD(fileNameTXD)
		if txd then	
			engineImportTXD(txd, customID)
		end
		
		local fileNameDFF = MODELS_PATH .. name .. ".dff"
		local dff = engineLoadDFF(fileNameDFF)
		if dff then
			engineReplaceModel(dff, customID)
		end
	end
end

local function unloadModel(customID) 
end

local function changeModel(veh, customID)
	if customID > 611 then
		if not allocatedModels[customID] then
			allocateModel(customID)
			loadModel(customID) 
		end
		
		setElementModel(veh, allocatedModels[customID].model)
	else
		loadModel(customID) 
		setElementModel(veh, customID)
	end
end

function onCustomVehicleCreate(veh)
	changeModel(veh, getElementData(veh, "customID"))
end
addEvent("CustomVehicle:onCreate", true)
addEventHandler("CustomVehicle:onCreate", resourceRoot, onCustomVehicleCreate)

function CreateVehicle(modelID, x, y, z)
	local allowedID
    if modelID <= 611 then
        allowedID = modelID
    else
        allowedID = Parent[modelID] or 400
    end
	
	triggerServerEvent("CustomVehicle:create", resourceRoot, modelID, allowedID, x, y, z)
end

function consoleCreateVeh (commandName, id)
	local x,y,z = getElementPosition(localPlayer)
	CreateVehicle(tonumber(id), x, y, z)
end
addCommandHandler ( "createveh", consoleCreateVeh )

-- addEventHandler("onClientElementStreamIn", root, function()
	-- if getElementType(source) == "vehicle" then
		-- local id = getElementData(source, "customID")
		-- if id then
			-- changeModel(source, id)
		-- end
	-- end
-- end)

-- addEventHandler("onClientResourceStart", root, function()
	-- for id, name in pairs(FileNamePool) do
		-- outputChatBox(id.." "..name)
		
		-- if id > 611 then
			-- local allowedID
			-- if id <= 611 then
				-- allowedID = id
			-- else
				-- allowedID = Parent[id] or 400
			-- end
			
			-- local newModel = engineRequestModel("vehicle", allowedID)
			-- local fileName = name
			
			-- local fileNameTXD = MODELS_PATH .. fileName .. ".txd"
			-- local txd = engineLoadTXD(fileNameTXD)
			-- if txd then	
				-- engineImportTXD(txd, newModel)
			-- end
			
			-- local fileNameDFF = MODELS_PATH .. fileName .. ".dff"
			-- local dff = engineLoadDFF(fileNameDFF)
			-- if dff then
				-- engineReplaceModel(dff, newModel)
			-- end
			
			-- table.insert(allocatedModels, id, newModel)
		-- else
			-- local fileNameTXD = MODELS_PATH .. name .. ".txd"
			-- local txd = engineLoadTXD(fileNameTXD)
			-- if txd then	
				-- engineImportTXD(txd, id)
			-- end
			
			-- local fileNameDFF = MODELS_PATH .. name .. ".dff"
			-- local dff = engineLoadDFF(fileNameDFF)
			-- if dff then
				-- engineReplaceModel(dff, id)
			-- end
		-- end
	-- end
-- end)

local function cleanUp() 
	for customID, info in pairs(allocatedModels) do
		if info then
			engineFreeModel(info.model)
			unloadModel(customID)
		end
	end
end
addEventHandler("onClientResourceStop", resourceRoot, cleanUp)
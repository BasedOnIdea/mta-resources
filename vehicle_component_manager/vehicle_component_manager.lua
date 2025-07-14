local saveFileName = "component_stock.json"

local showWindow = false
local onlyEnabled = false
local vehicleComponents = {}
local selectedVehicle = nil

local window, filterCheckbox, saveButton
local gridList = nil
local toJSON, fromJSON = toJSON, fromJSON

function createComponentWindow()
    if window and isElement(window) then destroyElement(window) end

    window = guiCreateWindow(0.3, 0.3, 0.4, 0.5, "Компоненты ТС", true)
    guiWindowSetSizable(window, false)

    gridList = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, window)
    guiGridListAddColumn(gridList, "Компонент", 0.6)
    guiGridListAddColumn(gridList, "Видимость", 0.3)

    filterCheckbox = guiCreateCheckBox(0.05, 0.82, 0.4, 0.08, "Только видимые", onlyEnabled, true, window)
    saveButton = guiCreateButton(0.65, 0.82, 0.3, 0.08, "Сохранить в файл", true, window)
	
    addEventHandler("onClientGUIClick", filterCheckbox, function()
        onlyEnabled = guiCheckBoxGetSelected(filterCheckbox)
        refreshComponentList()
    end, false)
	
	addEventHandler("onClientGUIDoubleClick", gridList, function()
		local row = guiGridListGetSelectedItem(gridList)
		if row == -1 then return end

		local compName = guiGridListGetItemText(gridList, row, 1)
		if not compName or compName == "" then return end

		local newState = not getVehicleComponentVisible(selectedVehicle, compName)
		setVehicleComponentVisible(selectedVehicle, compName, newState)

		vehicleComponents[compName] = newState
		refreshComponentList()
	end, false)

    addEventHandler("onClientGUIClick", saveButton, function()
		saveFileName = tostring(getElementModel(selectedVehicle))..".json"
        saveVisibleComponents()
    end, false)
end

function refreshComponentList()
    if not selectedVehicle or not isElement(selectedVehicle) then return end

	guiGridListClear(gridList)
	
    local components = getVehicleComponents(selectedVehicle)
	
    if components then
        for comp in pairs(components) do
            local visible = getVehicleComponentVisible(selectedVehicle, comp)
            if (onlyEnabled and not visible) then
			else
				local row = guiGridListAddRow(gridList)
				guiGridListSetItemText(gridList, row, 1, comp, false, false)
				guiGridListSetItemText(gridList, row, 2, tostring(visible), false, false)
				vehicleComponents[comp] = visible
			end
        end
    end
end

function saveVisibleComponents()
    if not selectedVehicle or not isElement(selectedVehicle) then return end
    local model = getElementModel(selectedVehicle)
    local visibleComps = {}

    for name, state in pairs(vehicleComponents) do
        if state then
            table.insert(visibleComps, name)
        end
    end

    local fileData = {}
    if fileExists(saveFileName) then
        local f = fileOpen(saveFileName)
        fileData = fromJSON(fileRead(f, fileGetSize(f))) or {}
        fileClose(f)
    end

    fileData[tostring(model)] = visibleComps

    local f = fileCreate(saveFileName)
    fileWrite(f, toJSON(fileData, true))
    fileClose(f)

    outputChatBox("Компоненты сохранены для " .. model, 0, 255, 0)
end

function toggleComponentViewer()
    showWindow = not showWindow

    if showWindow then
        selectedVehicle = getPedOccupiedVehicle(localPlayer)
        if not selectedVehicle then
            outputChatBox("Сядь в машину!", 255, 0, 0)
            showWindow = false
            return
        end
		
        createComponentWindow()
        refreshComponentList()
        showCursor(true)
    else
        if window and isElement(window) then destroyElement(window) end
        showCursor(false)
    end
end

bindKey("F4", "down", toggleComponentViewer)

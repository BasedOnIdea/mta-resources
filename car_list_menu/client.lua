local sX, sY = guiGetScreenSize()
--local px, py = (sX/1920), (sY/1080)
--local x,y = (sX/px), (sY/py)

local vehicles = {}
local numbers  = {}

local bDrawMenu = false

local font_numbers 	= dxCreateFont("fonts/Lato/Lato-Bold.ttf", 14)
local font_number 	= dxCreateFont("fonts/Lato/Lato-Bold.ttf", 14)
local font_title 	= dxCreateFont("fonts/Roboto_Flex/RobotoFlex.ttf", 20, true)
local font_vehicles = dxCreateFont("fonts/Roboto_Flex/RobotoFlex.ttf", 16, true)
local font_button 	= dxCreateFont("fonts/Roboto_Flex/RobotoFlex.ttf", 14)

local font_small 	= dxCreateFont("fonts/Roboto_Flex/RobotoFlex.ttf", 10)

local bg_blur 		= dxCreateTexture("assets/bg_blur.png")
local bg_vehicles 	= dxCreateTexture("assets/bg_vehicles.png")
local hr_vehicles 	= dxCreateTexture("assets/hr_vehicles.png")
local bg_numbers 	= dxCreateTexture("assets/bg_numbers.png")
local hr_numbers 	= dxCreateTexture("assets/hr_numbers.png")

local title 		= dxCreateTexture("assets/title.png")

local btn_numbers 	= dxCreateTexture("assets/btn_numbers.png")
local btn_vehicles	= dxCreateTexture("assets/btn_vehicles.png")

local paddingX = 22
local paddingY = 15
local upperLeftX = (sX-1120)/2
local upperLeftContentX = upperLeftX + 160

local function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing ( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
		return true
	else
		return false
	end
end

function drawVehicleBar(px, py, vehicleName, vehicleNumber, isActive)
	local hover = false
	if isMouseInPosition(px,py,522,40) then		
		hover = true
	end
	
	if isActive then
		if hover then
			dxDrawRectangle(px, py, 522, 40, tocolor(255,59,59,180))
		else
			dxDrawRectangle(px, py, 522, 40, tocolor(255,59,59,255))
		end
		
		dxDrawText(vehicleName, px + 10, py + 5, sX, sY, tocolor(213,213,213,255), 1.0, font_vehicles)
		dxDrawText(vehicleNumber, upperLeftContentX + paddingX + 370, py + 8, sX, sY, tocolor(213,213,213,255), 1.0, font_number)
	else
		if hover then
			dxDrawRectangle(px, py, 522, 40, tocolor(255,59,59,50))
		end
		
		dxDrawText(vehicleName, px + 10, py + 5, sX, sY, tocolor(213,213,213,255), 1.0, font_vehicles)
		dxDrawText(vehicleNumber, upperLeftContentX + paddingX + 370, py + 8, sX, sY, tocolor(213,213,213,255), 1.0, font_number)
	end
end

function drawVehicleNumber(px, py, number, isActive)
	local hover = false
	if isMouseInPosition(px,py,199,34) then		
		hover = true
	end
	
	if isActive then
		if hover then
			dxDrawRectangle(px, py, 199, 34, tocolor(255,59,59,180))
		else
			dxDrawRectangle(px, py, 199, 34, tocolor(255,59,59,255))
		end
		
		dxDrawText(number, px + 10, py + 5, sX, sY, tocolor(213,213,213,255), 1.0, font_numbers)
	else
		if hover then
			dxDrawRectangle(px, py, 199, 34, tocolor(255,59,59,50))
		end
		
		dxDrawText(number, px + 10, py + 5, sX, sY, tocolor(213,213,213,255), 1.0, font_numbers)
	end
end

function drawButton(text, px, py, sx, sy, bgTexture)
	if isMouseInPosition(px,py,sx,sy) then
		dxDrawImage(px,py,sx,sy, bgTexture, 0, 0, 0, tocolor(255,255,255,188))
		
		local szX, szY = dxGetTextSize(text, 0, 1.0,font_button)
		dxDrawText(text, px + sx/2 - szX/2, py + 5, sX, sY, tocolor(213,213,213,255), 1.0, font_button)
	else
		dxDrawImage(px,py,sx,sy, bgTexture)
		
		local szX, szY = dxGetTextSize(text, 0, 1.0,font_button)
		dxDrawText(text, px + sx/2 - szX/2, py + 5, sX, sY, tocolor(213,213,213,255), 1.0, font_button)
	end
end

local click = false
local selectedVehID = -1
local scroll = 0
local vehListLimit = 7
local vehLen = 0

function drawVehMenu()
	dxDrawImage(upperLeftX, 0, 1120, 760, bg_blur)
	
	dxDrawImage(upperLeftX + 160, 110, 566, 550, bg_vehicles)
	dxDrawImage(upperLeftX + 160 + 566 + 8, 110, 226, 550, bg_numbers)
	
	dxDrawImage(upperLeftContentX + paddingX, 110 + paddingY, 522, 45, title)
	dxDrawText("Меню транспорта", upperLeftContentX + paddingX + 160, 110 + paddingY + 2, sX, sY, tocolor(213,213,213,255), 1.0, font_title)
	
	dxDrawText(tostring(tonumber(vehLen)).."/"..tostring(getElementData(localPlayer, "carlimit")), upperLeftContentX + 480, 118 + paddingY, sX, sY, tocolor(213,213,213,255), 1.0, font_vehicles)
	
	dxDrawImage(upperLeftContentX + paddingX, 110 + paddingY + 90, 522, 1, hr_vehicles)
	dxDrawText("Транспорт:", upperLeftContentX + paddingX + 10, 110 + paddingY + 70, sX, sY, tocolor(213,213,213,255), 1.0, font_small)
	dxDrawText("Номер:", upperLeftContentX + paddingX + 370, 110 + paddingY + 70, sX, sY, tocolor(213,213,213,255), 1.0, font_small)
	
	local y = 110 + paddingY + 100
	
	for k,v in ipairs(vehicles) do
		if(k > scroll and k <= (scroll + vehListLimit)) then
			local isActive = false
			if(v[3] == selectedVehID) then isActive = true end
			
			drawVehicleBar(upperLeftContentX + paddingX, y, v[1], v[2], isActive)
			
			if isMouseInPosition(upperLeftContentX + paddingX,y,522,40) then
				if getKeyState("mouse1") and not click then
					selectedVehID = v[3]
				end
			end
			
			y = y + 45
		end
	end
	
	drawButton("Спавн", upperLeftContentX + paddingX, 660 - 95, 254, 40, btn_vehicles)
	if isMouseInPosition(upperLeftContentX + paddingX,660 - 95,254,40) then
		if getKeyState("mouse1") and not click and selectedVehID >= 0 then
			triggerServerEvent( "spawnTheVehicle", localPlayer, selectedVehID )
		end
	end
	
	drawButton("Убрать", upperLeftContentX + paddingX, 660 - 50, 254, 40, btn_vehicles)
	if isMouseInPosition(upperLeftContentX + paddingX, 660 - 50,254,40) then
		if getKeyState("mouse1") and not click and selectedVehID >= 0 then
			triggerServerEvent( "destroyTheVehicle", localPlayer, selectedVehID )
		end
	end
	
	drawButton("Закрыть", upperLeftContentX + paddingX + 254 + 12, 660 - 95, 254, 40, btn_vehicles)
	if isMouseInPosition(upperLeftContentX + paddingX + 254 + 12, 660 - 95,254,40) then
		if getKeyState("mouse1") and not click and selectedVehID >= 0 then
			triggerServerEvent( "blockVehicle", localPlayer, localPlayer, selectedVehID)
		end
	end
	
	drawButton("Снять номера", upperLeftContentX + paddingX + 254 + 12, 660 - 50, 254, 40, btn_vehicles)
	if isMouseInPosition(upperLeftContentX + paddingX + 254 + 12, 660 - 50,254,40) then
		if getKeyState("mouse1") and not click and selectedVehID >= 0 then
			outputChatBox("Снять номера")
		end
	end
	
	dxDrawImage(upperLeftContentX + paddingX + 565, 110 + paddingY + 22.5, 199, 1, hr_numbers)
	dxDrawText("Номера:", upperLeftContentX + paddingX + 575, 110 + paddingY + 5, sX, sY, tocolor(213,213,213,255), 1.0, font_small)

	local y = 110 + paddingY + 30
	drawVehicleNumber(upperLeftContentX + paddingX + 565, y, "A888AA88",false)
	y = y + 37
	drawVehicleNumber(upperLeftContentX + paddingX + 565, y, "A888AA88",true)
	
	drawButton("Поставить", upperLeftContentX + paddingX + 565, 660 - 50, 199, 40, btn_numbers)
	if isMouseInPosition(upperLeftContentX + paddingX + 254 + 12, 660 - 50,254,40) then
		if getKeyState("mouse1") and not click then
			outputChatBox("Поставить")
		end
	end
	
    if getKeyState ("mouse1") then click = true else click = false end
end

addEventHandler("onClientRender", root, function()
	if bDrawMenu then
		drawVehMenu()
	end
end)

bindKey("F3", "down", function() 
	bDrawMenu = not bDrawMenu
	showChat(not bDrawMenu)
	showCursor(bDrawMenu)
	
	if bDrawMenu then
		vehLen = #vehicles
		triggerServerEvent("getPlayerVehiclesInfo", localPlayer)
		--outputChatBox(toJSON(vehicles))
	end
end)

addEventHandler("onClientKey",root,function(key,click)
	if not click then return end
	
    if isMouseInPosition(upperLeftContentX + paddingX, 210 + paddingY, 566 - paddingX * 2, 400) then
	    if key == "mouse_wheel_up" then
	    	if scroll >= 1 then
	    		scroll = scroll - 1
	    	end
	    end
	    if key == "mouse_wheel_down" then
			if (vehLen - scroll) > vehListLimit then
	    		scroll = scroll + 1
	    	end
	    end
    end
end)

function onGetPlayerVehiclesInfo(data)
	vehicles = data
end

addEvent("onGetPlayerVehiclesInfo", true)
addEventHandler("onGetPlayerVehiclesInfo", localPlayer, onGetPlayerVehiclesInfo)
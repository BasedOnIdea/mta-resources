local click = false

function drawPanelLogin ()
	local blockClick = startTick.blockClick

	local x = poses.login + (550*px)*progresses.login

	local y = 165*px

	dxDrawImage (0, 0, sx, sy, textures["fon"])

	dxDrawText ("Sample MTA", 1386*px + 39*px, y, 322*px, 62*px, tocolor(255, 255, 255, 255*0.8), fonts[1], "center", "center")
	y = y + 140*px

	dxDrawText ("Вход в игровой аккаунт", x + 67*px, y, 267*px, 28*px, tocolor(255, 255, 255, 255*0.7), fonts[3], "center", "center")
	y = y + 70*px

	dxDrawText ("Логин от аккаунта", x + 22*px, y, 138*px, 19*px, tocolor(255, 255, 255, 255*0.7), fonts[2], "left", "center")
	y = y + 25*px

	dxDrawButton (x, y, 400*px, 60*px, textures["edit_box"])

	local textLogin = edits["login"]["login"]
	if state["login"]["login"] then
		local w = dxGetTextWidth (textLogin, 1, fonts[5])

		if math.floor(getTickCount()/500) % 2 == 0 then

			dxDrawRectangle (x+25*px + w, y+(33*px-9*px), 2*px, 20*px, tocolor (255, 255, 255, 255*0.7))

		end
	end

	dxDrawText (textLogin, x + 25*px, y, 400*px, 60*px, tocolor(255, 255, 255, 255*0.7), fonts[5], "left", "center")

	dxDrawImage (x + 352, y+17*px, 22*px, 26*px, textures["user"])

	if cursorPosition (x, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then
		state["login"]["login"] = true

		state["login"]["pass"] = false

		state["reg"]["login"] = false

		state["reg"]["pass"] = false

		state["reg"]["refpass"] = false

		state["reg"]["mail"] = false
		
		state["reg"]["nickname"] = false
	end

	y = y + 75

	dxDrawText ("Пароль от аккаунта", x + 22*px, y, 149*px, 19*px, tocolor(255, 255, 255, 255*0.7), fonts[2], "left", "center")
	y = y + 25*px

	dxDrawButton (x, y, 400*px, 60*px, textures["edit_box"])

	local textPass = state["checkbox"]["show"] and edits["login"]["pass"] or string.rep ("*", utf8.len(edits["login"]["pass"]))
	if state["login"]["pass"] then
		local w = dxGetTextWidth (textPass, 1, fonts[5])

		if math.floor(getTickCount()/500) % 2 == 0 then
			dxDrawRectangle (x+25*px + w, y+(33*px-9*px), 2*px, 20*px, tocolor (255, 255, 255, 255*0.7))
		end
	end

	dxDrawText (tostring(textPass), x + 25*px, y, 400*px, 60*px, tocolor(255, 255, 255, 255*0.7), fonts[5], "left", "center")

	if cursorPosition (x, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then
		state["login"]["login"] = false

		state["login"]["pass"] = true

		state["reg"]["login"] = false

		state["reg"]["pass"] = false

		state["reg"]["refpass"] = false

		state["reg"]["mail"] = false
		
		state["reg"]["nickname"] = false
	end

	dxDrawButtonPass (x + 350, y+22*px, 26*px, 18*px, textures["pass"])
	
	if cursorPosition (x + 350, y+22*px, 26*px, 18*px) and getKeyState ("mouse1") and not click and not blockClick then
		state["checkbox"]["show"] = not state["checkbox"]["show"]
	end

	y = y + 85
	
	dxDrawCheckBox ("Запомнить пароль", x + 23*px, y, 84*px, 19*px, tocolor(255, 255, 255, 255*0.7), fonts[2], state["checkbox"]["checkbox1"])

	if cursorPosition (x + 23*px, y, 20*px, 20*px) and getKeyState ("mouse1") and not click then
		local prevState = state["checkbox"]["checkbox1"]

		state["checkbox"]["checkbox1"] = not prevState
	end
	
	y = y + 30

	dxDrawButton (x, y, 400*px, 60*px, textures["button"])
	dxDrawText ("Войти в аккаунт →", x + 120*px, y + 18, 178*px, 23*px, tocolor(255, 255, 255, 255*0.7), fonts[7], "center", "center")

	if cursorPosition (x, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then
		local user = edits["login"]["login"]

		local pass = edits["login"]["pass"]

		triggerServerEvent ("login:login", resourceRoot, localPlayer, user, pass)
	end

	y = y + 65

	if not startTick.moving and not startTick.alpha and not startTick.blockClick then
		if cursorPosition (x + 24*px, y, 200, 22*px) then
			dxDrawText ("Создать новый аккаунт", x + 24*px, y, 179*px, 19*px, tocolor(255, 255, 255, 255*0.5), fonts[2], "left", "center")
			dxDrawRectangle ( x + 24*px, y + 20, 202, 2, tocolor(255,255,255,255*0.5))
		else
			dxDrawText ("Создать новый аккаунт", x + 24*px, y, 179*px, 19*px, tocolor(255, 255, 255, 255*0.7), fonts[2], "left", "center")
			dxDrawRectangle ( x + 24*px, y + 20, 202, 2, tocolor(255,255,255,255*0.7))
		end
	else
		dxDrawText ("Создать новый аккаунт", x + 24*px, y, 179*px, 19*px, tocolor(255, 255, 255, 255*0.7), fonts[2], "left", "center")
		dxDrawRectangle ( x + 24*px, y + 20, 202, 2, tocolor(255,255,255,255*0.7))
	end
	
	if cursorPosition (x + 24*px, y, 200*px, 24*px) and getKeyState ("mouse1") and not click and not blockClick then
		if not isEventHandlerAdded ("onClientRender", root, drawPanelReg) then
			startTick.moving = getTickCount ()

			startTick.stateMoving = true

			addEventHandler ("onClientRender", root, drawPanelReg, true, "low-5")
		end
	end
	
	y = y + 63*px + 25*px

	if startTick.error ~= nil then
		if startTick.dir then
			progresses.err = math.min(getEasingValue ((getTickCount ()-startTick.error)/1000/startTick.errorSpeed, "InQuad"), 1)
		else

			progresses.err = 1 - math.min(getEasingValue ((getTickCount ()-startTick.error)/1000/startTick.errorSpeed, "InQuad"), 1)
		end

		if not startTick.stateError then
			if progresses.err <= 0.01 then
				startTick.error = nil
			end
		end
	end

	-- Ошибка
	dxDrawImage (sx/2 - 143*px, sy - 120*px, 286*px, 100*px, textures["msges"], 0, 0, 0, startTick.errType == "error" and tocolor(255, 0, 0, 255*progresses.err) or tocolor(0, 255, 0, 255*progresses.err))

	dxDrawImage (sx/2 - 143*px, sy - 120*px, 286*px, 100*px, startTick.errType == "error" and textures["err"] or textures["ok"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.err))

	dxDrawText (startTick.errText, sx/2 - 143*px + 60*px, sy - 120*px, 286*px, 100*px, startTick.errType == "ok" and tocolor(0, 255, 0, 255*progresses.err) or tocolor(255, 0, 0, 255*progresses.err), fonts[6], "left", "center")

	if getKeyState ("mouse1") then click = true else click = false end
end
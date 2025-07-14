local click = false
function drawPanelReg ()	if startTick.moving ~= nil then		startTick.blockClick = true
		if startTick.stateMoving then			progresses.login = math.min (getEasingValue ((getTickCount ()-startTick.moving)/speedAnim, "InQuad"), 1)
			-- if progresses.login >= 0.9998 then
			if progresses.login == 1 then				startTick.moving = nil
				startTick.stateAlpha = true
				startTick.alpha = getTickCount ()			end		else			progresses.login = 1 - math.min (getEasingValue ((getTickCount ()-startTick.moving)/speedAnim, "InQuad"), 1)
			-- if progresses.login <= 0.001 then
			if progresses.login == 0 then
				removeEventHandler ("onClientRender", root, drawPanelReg, true, "low-5")
				startTick.moving = nil
				startTick.blockClick = false
				progresses.login = 0
				progresses.alpha = 0
			end		end	end
	if startTick.alpha ~= nil then		startTick.blockClick = true		if startTick.stateAlpha then			progresses.reg = math.min (getEasingValue ((getTickCount ()-startTick.alpha)/speedAnim, "InQuad"), 1)
			-- if progresses.reg >= 0.9998 then
			if progresses.reg == 1 then				startTick.alpha = nil
				startTick.blockClick = false			end		else			progresses.reg = 1 - math.min (getEasingValue ((getTickCount ()-startTick.alpha)/speedAnim, "InQuad"), 1)
			-- if progresses.reg <= 0.001 then
			if progresses.reg == 0 then				startTick.alpha = nil
				startTick.moving = getTickCount ()
				startTick.stateMoving = false			end		end	end
	if progresses.reg < 0.01 then return end
	local blockClick = startTick.blockClick
	local x = poses.reg*px	local y = 305*px	dxDrawText ("Регистрация", x + 67*px, y, 267*px, 28*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[3], "center", "center")	y = y + 70*px	-- Никнейм	dxDrawText ("Никнейм", x+19*px, y, 138*px, 19*px, tocolor(255, 255, 255, 255*progresses.reg), fonts[2], "left", "center")	y = y + 25*px	dxDrawButton (x, y, 400*px, 60*px, textures["edit_box"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))		dxDrawText (edits["reg"]["nickname"], x+25*px, y, 400*px, 60*px, tocolor(255, 255, 255, (255*0.7)*progresses.reg), fonts[5], "left", "center")		dxDrawImage (x + 352*px, y+17*px, 22*px, 26*px, textures["user"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))	if cursorPosition (x + 34*px, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then		state["login"]["login"] = false		state["login"]["pass"] = false		state["reg"]["login"] = false		state["reg"]["pass"] = false		state["reg"]["refpass"] = false		state["reg"]["mail"] = false				state["reg"]["nickname"] = true	end	local textNickname = edits["reg"]["nickname"]	if state["reg"]["nickname"] then		local w = dxGetTextWidth (textNickname, 1, fonts[5])		if math.floor(getTickCount()/500) % 2 == 0 then			dxDrawRectangle (x + 25*px + w, y+(33*px-9*px), 2*px, 20*px, tocolor (255, 255, 255, 255*0.7))		end	end	y = y + 75*px
	-- Логин	dxDrawText ("Логин", x+19*px, y, 138*px, 19*px, tocolor(255, 255, 255, 255*progresses.reg), fonts[2], "left", "center")	y = y + 25*px
	dxDrawButton (x, y, 400*px, 60*px, textures["edit_box"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))		dxDrawText (edits["reg"]["login"], x+25*px, y, 400*px, 60*px, tocolor(255, 255, 255, (255*0.7)*progresses.reg), fonts[5], "left", "center")		dxDrawImage (x + 352*px, y+17*px, 22*px, 26*px, textures["user"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))
	if cursorPosition (x + 34*px, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then		state["login"]["login"] = false
		state["login"]["pass"] = false
		state["reg"]["login"] = true
		state["reg"]["pass"] = false
		state["reg"]["refpass"] = false
		state["reg"]["mail"] = false				state["reg"]["nickname"] = false	end
	local textLogin = edits["reg"]["login"]
	if state["reg"]["login"] then		local w = dxGetTextWidth (textLogin, 1, fonts[5])
		if math.floor(getTickCount()/500) % 2 == 0 then			dxDrawRectangle (x + 25*px + w, y+(33*px-9*px), 2*px, 20*px, tocolor (255, 255, 255, 255*0.7))		end	end	y = y + 75*px
	-- Пароль
	dxDrawText ("Пароль", x+19*px, y, 540*px, 13*px, tocolor(255, 255, 255, 255*progresses.reg), fonts[2], "left", "center")	y = y + 25*px
	dxDrawButton (x, y, 400*px, 60*px, textures["edit_box"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))	
	-- if state["checkbox"]["show"] then
		-- dxDrawText (edits["reg"]["pass"], x+34*px + 20*px, y, 472*px, 66*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[5], "left", "center")
	-- else
		-- dxDrawText (convertPass (edits["reg"].pass), x+34*px + 20*px, y, 472*px, 66*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[5], "left", "center")
	-- end
	local textPass = state["checkbox"]["show"] and edits["reg"]["pass"] or string.rep ("*", utf8.len(edits["reg"]["pass"]))
	if state["reg"]["pass"] then
		local w = dxGetTextWidth (textPass, 1, fonts[5])
		if math.floor(getTickCount()/500) % 2 == 0 then
			dxDrawRectangle (x + 25*px + w, y+(33*px-9*px), 2*px, 20*px, tocolor (255, 255, 255, 255*0.7))
		end
	end
	dxDrawText (tostring(textPass), x + 25*px, y, 400*px, 60*px, tocolor(255, 255, 255, 255*0.7), fonts[5], "left", "center")
	dxDrawButtonPass (x + 352*px, y+20*px, 26*px, 18*px, textures["pass"])
	if cursorPosition (x, y, 410*px, 66*px) and getKeyState ("mouse1") and not click and not blockClick then		state["login"]["login"] = false
		state["login"]["pass"] = false
		state["reg"]["login"] = false
		state["reg"]["pass"] = true
		state["reg"]["refpass"] = false
		state["reg"]["mail"] = false				state["reg"]["nickname"] = false	end
	if cursorPosition (x + 352*px, y+20*px, 26*px, 18*px) and getKeyState ("mouse1") and not click and not blockClick then		state["checkbox"]["show"] = not state["checkbox"]["show"]	end
	y = y + 75*px
	-- Повтор пароля	dxDrawText ("Повторите пароль", x+19*px, y, 540*px, 13*px, tocolor(255, 255, 255, 255*progresses.reg), fonts[2], "left", "center")	y = y + 25*px
	dxDrawButton (x, y, 400*px, 60*px, textures["edit_box"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))
	-- if state["checkbox"]["show"] then		-- dxDrawText (edits["reg"]["refpass"], x+34*px + 20*px, y, 472*px, 66*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[5], "left", "center")	-- else		-- dxDrawText (convertPass (edits["reg"]["refpass"]), x+34*px + 20*px, y, 472*px, 66*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[5], "left", "center")	-- end
	local textPass2 = state["checkbox"]["show"] and edits["reg"]["refpass"] or string.rep ("*", utf8.len(edits["reg"]["refpass"]))
	if state["reg"]["refpass"] then		local w = dxGetTextWidth (textPass2, 1, fonts[5])
		if math.floor(getTickCount()/500) % 2 == 0 then			dxDrawRectangle (x + 25*px + w, y+(33*px-9*px), 2*px, 20*px, tocolor (255, 255, 255, 255*0.7))		end	end
	dxDrawText (tostring(textPass2), x + 25*px, y, 400*px, 60*px, tocolor(255, 255, 255, 255*0.7), fonts[5], "left", "center")
	dxDrawButtonPass (x + 352*px, y+20*px, 26*px, 18*px, textures["pass"])
	if cursorPosition (x, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then		state["login"]["login"] = false
		state["login"]["pass"] = false
		state["reg"]["login"] = false
		state["reg"]["pass"] = false
		state["reg"]["refpass"] = true
		state["reg"]["mail"] = false				state["reg"]["nickname"] = false	end
	if cursorPosition (x + 352*px, y+20*px, 26*px, 18*px) and getKeyState ("mouse1") and not click and not blockClick then		state["checkbox"]["show"] = not state["checkbox"]["show"]	end
	y = y + 75*px
	-- Почта	dxDrawText ("Ваш E-mail", x + 19*px, y, 540*px, 13*px, tocolor(255, 255, 255, 255*progresses.reg), fonts[2], "left", "center")	y = y + 25*px
	dxDrawButton (x, y, 400*px, 60*px, textures["edit_box"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))
	dxDrawText (edits["reg"]["mail"], x + 25*px, y, 400*px, 60*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[5], "left", "center")
	dxDrawImage (x + 348*px, y+17*px, 34*px, 26*px, textures["mail"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))
	if cursorPosition (x, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then		state["login"]["login"] = false
		state["login"]["pass"] = false
		state["reg"]["login"] = false
		state["reg"]["pass"] = false
		state["reg"]["refpass"] = false
		state["reg"]["mail"] = true				state["reg"]["nickname"] = false	end
	y = y + 75*px
		dxDrawButton (x, y, 400*px, 60*px, textures["button"], 0, 0, 0, tocolor(255, 255, 255, 255*progresses.reg))	dxDrawText ("Создать аккаунт", x + 129*px, y + 18, 143*px, 23*px, tocolor(255, 255, 255, 255*progresses.reg), fonts[7], "center", "center")
	if cursorPosition (x, y, 400*px, 60*px) and getKeyState ("mouse1") and not click and not blockClick then		local nickname = edits["reg"]["nickname"]				local login = edits["reg"]["login"]
		local pass = edits["reg"]["pass"]
		local refpass = edits["reg"]["refpass"]
		local mail = edits["reg"]["mail"]
		triggerServerEvent ("login:register", resourceRoot, localPlayer, nickname, login, pass, refpass, mail)		startTick.alpha = getTickCount ()		startTick.stateAlpha = false
	end
	y = y + 65	if not startTick.moving and not startTick.alpha and not startTick.blockClick then		if cursorPosition (x + 24*px, y, 200, 22) then			dxDrawText ("Войти в аккаунт", x + 24*px, y, 179*px, 19*px, tocolor(255, 255, 255, 255*0.5*progresses.reg), fonts[2], "left", "center")			dxDrawRectangle ( x + 24*px, y + 20, 136, 2, tocolor(255,255,255,255*0.5*progresses.reg))		else			dxDrawText ("Войти в аккаунт", x + 24*px, y, 179*px, 19*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[2], "left", "center")			dxDrawRectangle ( x + 24*px, y + 20, 136, 2, tocolor(255,255,255,255*0.7*progresses.reg))		end	else		dxDrawText ("Войти в аккаунт", x + 24*px, y, 179*px, 19*px, tocolor(255, 255, 255, 255*0.7*progresses.reg), fonts[2], "left", "center")		dxDrawRectangle ( x + 24*px, y + 20, 136, 2, tocolor(255,255,255,255*0.7*progresses.reg))	end

	if cursorPosition (x + 24*px, y, 179, 24*px) and getKeyState ("mouse1") and not click and not blockClick then		startTick.alpha = getTickCount ()
		startTick.stateAlpha = false	end		if getKeyState ("mouse1") then click = true else click = false endend
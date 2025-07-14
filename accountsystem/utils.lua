_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, color, font, aX, aY)	_dxDrawText (text, x, y, w + x, h + y, color or tocolor(255, 255, 255), 1, font or "default", aX or "left", aY or "top")end
function dxDrawCheckBox (text, x, y, w, h, color, font, checked, btn)	if checked then		dxDrawRectangle(x, y, 20, 20,tocolor(179,179,179))		dxDrawCircle(x + 10, y + 10, 7.5, tocolor(235,235,235*0.7))		--dxDrawRectangle(x, y, 20, 20,tocolor(255,0,0))	else		dxDrawRectangle(x, y, 20, 20,tocolor(179,179,179))	end
	--dxDrawImage (x, y+h/2-14*px, 28*px, 27*px, checked and textures["checkbox_on"] or textures["checkbox_off"])
	dxDrawText (text, x + 30*px, y, w, h, color, font, "left", "center")end
function dxDrawButton (x, y, w, h, img, a, b, c, color)	if not startTick.moving and not startTick.alpha and not startTick.blockClick then		if cursorPosition (x, y, w, h) then			dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(255, 255, 255, 255)) - tocolor(0, 0, 0, 50))		else			dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(255, 255, 255, 255)))		end	else		dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(255, 255, 255, 255)))	endend
function dxDrawButtonPass (x, y, w, h, img, a, b, c, color)	if not startTick.moving and not startTick.alpha and not startTick.blockClick then		if cursorPosition (x, y, w, h) then			dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(171, 0, 0, 255)))		else			dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(255, 255, 255, 255)))		end	else		dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(255, 255, 255, 255)))	endend
function dxDrawButtonActive (x, y, w, h, img, a, b, c, color)	if not startTick.moving and not startTick.alpha and not startTick.blockClick then		if cursorPosition (x, y, w, h) then			dxDrawButton (x, y, w, h, textures["button_r"])		else			dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(255, 255, 255, 255)))		end	else		dxDrawImage (x, y, w, h, img, 0, 0, 0, (color or tocolor(255, 255, 255, 255)))	endend
local timerBackspace = nil
function removeBackspace ()	if getKeyState ("backspace") then		local win, el = getActiveInput ()
		if not el then killTimer (timerBackspace) return end
		edits[tostring(win)][el] = utf8.sub (edits[tostring(win)][el], 1, utf8.len(edits[tostring(win)][el]) - 1)
		timerBackspace = setTimer (removeBackspace, 50, 1)	else
		if isTimer (timerBackspace) then 			killTimer (timerBackspace)		end	endend
function onKey (key, state)	if key == "backspace" then		if state then			local win, el = getActiveInput ()
			edits[tostring(win)][el] = utf8.sub(edits[tostring(win)][el], 1, utf8.len(edits[tostring(win)][el]) - 1)
			timerBackspace = setTimer (removeBackspace, 500, 1)		else			if isTimer (timerBackspace) then 				killTimer (timerBackspace)			end		end	endend
function onChar (key)	local win, el = getActiveInput ()
	if not el then return end
	edits[win][el] = edits[tostring(win)][el]..keyend
function getActiveInput ()	for win, t in pairs (state) do 		if win ~= "checkbox" then			for el, state in pairs (t) do				if state then					return win, el				end			end		end	endend
function cursorPosition(x, y, w, h)	if (not isCursorShowing()) then		return false	end
	local mx, my = getCursorPosition()
	local fullx, fully = guiGetScreenSize()
	cursorx, cursory = mx*fullx, my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then		return true	else		return false	endend
function isResourceRunning(resName)	local res = getResourceFromName(resName)	return (res) and (getResourceState(res) == "running")end
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then            for i, v in ipairs( aAttachedFunctions ) do                if v == func then                    return true                end            end        end    end
    return falseend
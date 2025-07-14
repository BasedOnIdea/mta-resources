sx, sy = guiGetScreenSize()px = math.min(sx/1920, 1)
poses = {	login = 1386*px,	reg = 1386*px,}
progresses = {	login = 0,	reg = 0,	err = 0,}textures = {	["fon"] = dxCreateTexture ("assets/bg.png", "dxt3"),	["button"] = dxCreateTexture ("assets/button.png", "dxt3"),	["edit_box"] = dxCreateTexture ("assets/edit_box.png", "dxt3"),		["main"] = dxCreateTexture ("assets/main.png", "dxt3"),	["checkbox_off"] = dxCreateTexture ("assets/checkbox_off.png", "dxt3"),	["checkbox_on"] = dxCreateTexture ("assets/checkbox_on.png", "dxt3"),	["user"] = dxCreateTexture ("assets/user.png", "dxt3"),	["pass"] = dxCreateTexture ("assets/pass.png", "dxt3"),	["mail"] = dxCreateTexture ("assets/mail.png", "dxt3"),	["logo"] = dxCreateTexture ("assets/logo.png", "dxt3"),	["msges"] = dxCreateTexture ("assets/msges.png", "dxt3"),	["ok"] = dxCreateTexture ("assets/ok.png", "dxt3"),	["err"] = dxCreateTexture ("assets/err.png", "dxt3"),}
edits = {	["login"] = {		["login"] = "",		["pass"] = "",	},
	["reg"] = {		["nickname"] = "",		["login"] = "",		["pass"] = "",		["refpass"] = "",		["mail"] = "",	},}
state = {	["login"] = {		["login"] = false,		["pass"] = false,	},
	["reg"] = {		["nickname"] = false,		["login"] = false,		["pass"] = false,		["refpass"] = false,		["mail"] = false,	},
	["checkbox"] = {		["checkbox1"] = false,		["checkbox2"] = false,		["show"] = false,	}}
startTick = {	moving = nil,	alpha = nil,	stateAlpha = true,	stateMoving = true,	blockClick = false,	error = nil,	stateError = true,	errText = "",	errorSpeed = "",}
fonts = {	[1] = dxCreateFont ("assets/CrimsonText-Bold.ttf", 48*px),	[2] = dxCreateFont ("assets/Roboto-Regular.ttf", 12*px),	[3] = dxCreateFont ("assets/Roboto-Medium.ttf", 22*px),	[4] = dxCreateFont ("assets/Roboto-Medium.ttf", 10*px), --CheckBox	[5] = dxCreateFont ("assets/Roboto-Medium.ttf", 14*px),	[6] = dxCreateFont ("assets/Roboto-Medium.ttf", 12*px),	[7] = dxCreateFont ("assets/Roboto-Medium.ttf", 16*px),}
serverName = nilfunction createPanel ()	loadSettings ()	if not state["checkbox"]["checkbox2"] then		addEventHandler ("onClientCharacter", root, onChar)		addEventHandler ("onClientKey", root, onKey)		addEventHandler ("onClientRender", root, drawPanelLogin, true, "low-5")		guiSetInputMode ("no_binds")		showCursor (true)		showChat (false)	else		local user = edits["login"]["login"]		local pass = edits["login"]["pass"]		triggerServerEvent ("login:login", resourceRoot, localPlayer, user, pass)	endend
addEventHandler("onClientResourceStart", resourceRoot, function()	if not getElementData(localPlayer, "loged") then		createPanel()	endend)
addEvent ("login:createPanel", true)addEventHandler ("login:createPanel", resourceRoot, createPanel)
function hidePanel ()	saveSettings ()
	removeEventHandler ("onClientCharacter", root, onChar)	removeEventHandler ("onClientKey", root, onKey)	removeEventHandler ("onClientRender", root, drawPanelLogin, true, "low-5")
	guiSetInputMode ("allow_binds")
	showCursor (false)	showChat (true)
	for k, v in pairs (textures) do		if isElement (v) then			destroyElement (v)		end	end
	for k, v in pairs (fonts) do		if isElement (v) then			destroyElement (v)		end	end
	startTick = nil	state = nil	edits = nil	progresses = nil
	collectgarbage ()endaddEvent ("login:hidePanel", true)addEventHandler ("login:hidePanel", resourceRoot, hidePanel)

function errmsg (msg, type)
	startTick.stateError = true
	startTick.error = getTickCount()
	progresses.err = 0
	startTick.errText = msg
	startTick.errType = type or "error"
	startTick.errorSpeed = startTick.errType == "error" and 0.5 or 0.5
	startTick.dir = true
	setTimer (function() startTick.dir = false startTick.error = getTickCount() end, 1000*4, 1)endaddEvent ("login:errmsg", true)addEventHandler ("login:errmsg", resourceRoot, errmsg)
local settingsFile = "@settings.json"
function loadSettings()	local data
	if fileExists(settingsFile) then 		local file = fileOpen(settingsFile, true)
		if (file) then			data = fromJSON(fileRead(file, fileGetSize(file)))
			fileClose(file)		end	end
	if (type(data) ~= "table") then data = {} end
	local user = edits["login"]["login"]
	local pass = edits["login"]["pass"]
	state["checkbox"]["checkbox1"] = data.save or false
	edits["login"]["login"] = data.user or ""
	edits["login"]["pass"] = data.pass or ""
	state["checkbox"]["checkbox2"] = data.login or falseend
local needsSave, saveTimer = false
function saveSettings()	if isTimer(saveTimer) then		needsSave = true	else		needsSave = true		writeSettingsFile()		saveTimer = setTimer(writeSettingsFile, 1000, 1)	endend
function writeSettingsFile()	if (needsSave) then		local data = {}
		data.save = state["checkbox"]["checkbox1"]		data.login = state["checkbox"]["checkbox2"]
		if data.save then			data.user = edits["login"]["login"]			data.pass = edits["login"]["pass"]		end
		local file = fileCreate(settingsFile)
		if (file) then			fileWrite(file, toJSON(data, true))			fileClose(file)		end
		needsSave = false	endend
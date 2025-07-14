local notifications = {}

function callNotify(msg, reason)
    table.insert(notifications, {
        msg = msg,
        reason = reason,
        startTick = getTickCount(),
        duration = 5000
    })
end

addEventHandler("onClientRender", root, function()
    local screenW, screenH = guiGetScreenSize()
    local baseY = screenH - 500
    local padding = 10
    local spacing = 5
    local i = 0

    for k = #notifications, 1, -1 do
        local note = notifications[k]
        local elapsed = getTickCount() - note.startTick

        if elapsed > note.duration then
            table.remove(notifications, k)
        else
            local alpha = 255
            if elapsed > note.duration - 1000 then
                alpha = 255 - ((elapsed - (note.duration - 1000)) / 1000) * 255
            end

            local y = baseY - i * (40 + spacing)

            dxDrawRectangle(screenW - 310, y, 300, 40, tocolor(0, 0, 0, alpha * 0.6))
            dxDrawText(note.msg .. "\n" .. note.reason, screenW - 305, y + 5, screenW - 10, y + 40,
                tocolor(255, 255, 255, alpha), 1, "default-bold", "left", "top", false, false, false, true)

            i = i + 1
        end
    end
end)

addEvent("system_notify:callNotify", true)
addEventHandler("system_notify:callNotify", root, callNotify)
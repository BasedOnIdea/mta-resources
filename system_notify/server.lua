function callNotify(player, msg, reason) 
	triggerClientEvent(player, "system_notify:callNotify", player, msg, reason)
end
--            _           (`-') (`-')  _ _(`-')    (`-')  _      (`-')
--   <-.     (_)         _(OO ) ( OO).-/( (OO ).-> ( OO).-/     _(OO )
--(`-')-----.,-(`-'),--.(_/,-.\(,------. \    .'_ (,------.,--.(_/,-.\
--(OO|(_\---'| ( OO)\   \ / (_/ |  .---' '`'-..__) |  .---'\   \ / (_/
-- / |  '--. |  |  ) \   /   / (|  '--.  |  |  ' |(|  '--.  \   /   / 
-- \_)  .--'(|  |_/ _ \     /_) |  .--'  |  |  / : |  .--' _ \     /_)
--  `|  |_)  |  |'->\-'\   /    |  `---. |  '-'  / |  `---.\-'\   /   
--   `--'    `--'       `-'     `------' `------'  `------'    `-'    

require "resources/[essential]/es_extended/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "user", "password")

local RegisteredCallbacks = {}

local function GenerateUniquePhoneNumber()
	local foundNumber = false
	local phoneNumber = nil
	while not foundNumber do
		phoneNumber = math.random(10000, 99999)
		local executed_query = MySQL:executeQuery("SELECT COUNT(*) as count FROM users WHERE phone_number = '@phoneNumber'", {['@phoneNumber'] = phoneNumber})
		local result         = MySQL:getResults(executed_query, {'count'})
		local count          = tonumber(result[1].count)
		if count == 0 then
			foundNumber = true
		end
	end
	return phoneNumber
end
-- ###########################################################################################################
AddEventHandler('onResourceStart', function(ressource)
	if ressource == 'esx_phone' then
		TriggerEvent('esx_phone:ready')
	end
end)
-- ###########################################################################################################
AddEventHandler('esx:playerLoaded', function(source)
	local _source = source
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@identifier'", {['@identifier'] = xPlayer.identifier})
		local result         = MySQL:getResults(executed_query, {'phone_number'})
		local phoneNumber    = result[1].phone_number
		if phoneNumber == nil then
			phoneNumber = GenerateUniquePhoneNumber()
			MySQL:executeQuery("UPDATE users SET phone_number = '@phone_number' WHERE identifier = '@identifier'", {['@identifier'] = xPlayer.identifier, ['@phone_number'] = phoneNumber})
		end
		xPlayer['phoneNumber'] = phoneNumber
		
		local contacts = {}

		local executed_query2 = MySQL:executeQuery("SELECT * FROM user_contacts WHERE identifier = '@identifier' ORDER BY name ASC", {['@identifier'] = xPlayer.identifier})
		local result2         = MySQL:getResults(executed_query2, {'name', 'number'})
		
		for i=1, #result2, 1 do
			table.insert(contacts, {
				name   = result2[i].name,
				number = result2[i].number,
				online = false
			})
			TriggerEvent('esx:getPlayers', function(xPlayers)
				for k, v in pairs(xPlayers) do
					if v.phoneNumber == contacts[i].number then
							contacts[i].online = true
					end
				end
			end)
		end
		
		xPlayer['contacts'] = contacts
		
		TriggerClientEvent('esx_phone:loaded', _source, phoneNumber, contacts)
	end)
end)

-- ###########################################################################################################
RegisterServerEvent('esx_phone:reload')
AddEventHandler('esx_phone:reload', function(phoneNumber)
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		local contacts = {}

		local executed_query2 = MySQL:executeQuery("SELECT * FROM user_contacts WHERE identifier = '@identifier' ORDER BY name ASC", {['@identifier'] = xPlayer.identifier})
		local result2         = MySQL:getResults(executed_query2, {'name', 'number'})
		for i=1, #result2, 1 do
			table.insert(contacts, {
				name   = result2[i].name,
				number = result2[i].number,
				online = false
			})
			TriggerEvent('esx:getPlayers', function(xPlayers)
				for k, v in pairs(xPlayers) do
					if v.phoneNumber == contacts[i].number then
							contacts[i].online = true
					end
				end
			end)
		end
		
		xPlayer['contacts'] = contacts
		TriggerClientEvent('esx_phone:loaded', source, phoneNumber, contacts)
	end)
end)

-- ###########################################################################################################
RegisterServerEvent('esx_phone:registerCallback')
AddEventHandler('esx_phone:registerCallback', function(cb)
	table.insert(RegisteredCallbacks, cb)
end)

RegisterServerEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(phoneNumber, message, anon)

	for i=1, #RegisteredCallbacks, 1 do
		RegisteredCallbacks[i](source, phoneNumber, message, anon)
	end
end)
-- ###########################################################################################################
RegisterServerEvent('esx_phone:addPlayerContact')
AddEventHandler('esx_phone:addPlayerContact', function(phoneNumber, contactName)
	local _source = source

	TriggerEvent('esx:getPlayers', function(xPlayers)

		local foundNumber = false
		local foundPlayer = nil
		local executed_query3 = MySQL:executeQuery("SELECT phone_number FROM users WHERE phone_number = '@number'", {['@number'] = phoneNumber})
		local result3         = MySQL:getResults(executed_query3, {'phone_number'}, 'id')

		if next(result3) ~= nil then
			foundNumber = true
		end

		if foundNumber then
			TriggerEvent('esx:getPlayerFromId', _source, function(xPlayer)
				
				if phoneNumber == xPlayer.phoneNumber then
					TriggerClientEvent('esx:showNotification', _source, 'Vous ne pouvez pas vous ajouter vous-même')
				else
					local hasAlreadyAdded = false
					for i=1, #xPlayer.contacts, 1 do
						if xPlayer.contacts[i].number == phoneNumber then
							hasAlreadyAdded = true
						end
					end
					if hasAlreadyAdded then
						TriggerClientEvent('esx:showNotification', _source, 'Ce numéro est déja dans votre liste de contacts')
					else -- Sinon on le rajoute !
						table.insert(xPlayer.contacts, {
							name   = contactName,
							number = phoneNumber,
						})
						MySQL:executeQuery("INSERT INTO user_contacts (identifier, name, number) VALUES ('@identifier', '@name', '@number')", {['@identifier'] = xPlayer.identifier, ['@name'] = contactName, ['@number'] = phoneNumber})
						TriggerClientEvent('esx:showNotification', _source, 'Contact ajouté')
						
						local isonline = false
						for k, v in pairs(xPlayers) do
							if v.phoneNumber == phoneNumber then
									isonline = true
							end
						end
						
						TriggerClientEvent('esx_phone:addContact', _source, contactName, phoneNumber, isonline)
					end
				end
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Ce numéro n\'est pas attribué...')
		end
	end)
end)
-- ###########################################################################################################
AddEventHandler('esx_phone:ready', function()
	TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message, anon)
		--TriggerClientEvent('esx_console:consoleLog', source, "#################### COLBAQ")
		TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
			TriggerEvent('esx:getPlayers', function(xPlayers)
				local job = "player"
				for k, v in pairs(xPlayers) do
				
					if phoneNumber == "police" then
						--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez envoyé un message à la police")
						if v.job.name == 'cop' then
							--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez reçu un message destiné à la police")
							job = "ALERTE POLICE"
							TriggerClientEvent('esx_phone:onMessage', v.player.source, xPlayer.phoneNumber, message, xPlayer.player.coords, {reply = 'Répondre'}, anon, job)
						end
					elseif phoneNumber == "ambulance" then
						--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez envoyé un message aux EMS")
						if v.job.name == 'ambulance' then
							--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez reçu un message destiné aux EMS")							
							job = "ALERTE AMBULANCE"
							TriggerClientEvent('esx_phone:onMessage', v.player.source, xPlayer.phoneNumber, message, xPlayer.player.coords, {reply = 'Répondre'}, anon, job)
						end
					elseif phoneNumber == "taxi" then
						--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez envoyé un message aux Taxis")
						if v.job.name == 'taxi' then
							--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez reçu un message destiné  aux Taxis")
							job = "APPEL TAXI"
							TriggerClientEvent('esx_phone:onMessage', v.player.source, xPlayer.phoneNumber, message, xPlayer.player.coords, {reply = 'Répondre'}, anon, job)
						end
					elseif phoneNumber == "depanneur" then
						--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez envoyé un message aux dépanneurs")
						if v.job.name == 'depanneur' then
							--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez reçu un message destiné aux dépanneurs")
							job = "APPEL DÉPANNEUR"
							TriggerClientEvent('esx_phone:onMessage', v.player.source, xPlayer.phoneNumber, message, xPlayer.player.coords, {reply = 'Répondre'}, anon, job)
						end
					elseif tostring(v.phoneNumber) == tostring(phoneNumber) then
						--TriggerClientEvent('esx_console:consoleLog', source, "Vous avez envoyé un sms à un particulier")
						TriggerClientEvent('esx_phone:onMessage', v.player.source, xPlayer.phoneNumber, message, xPlayer.player.coords, {reply = 'Répondre'}, anon, job)
					end
					
				end
				
			end)
			
		end)
		
	end)
end)

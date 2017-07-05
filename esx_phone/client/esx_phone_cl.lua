--            _           (`-') (`-')  _ _(`-')    (`-')  _      (`-')
--   <-.     (_)         _(OO ) ( OO).-/( (OO ).-> ( OO).-/     _(OO )
--(`-')-----.,-(`-'),--.(_/,-.\(,------. \    .'_ (,------.,--.(_/,-.\
--(OO|(_\---'| ( OO)\   \ / (_/ |  .---' '`'-..__) |  .---'\   \ / (_/
-- / |  '--. |  |  ) \   /   / (|  '--.  |  |  ' |(|  '--.  \   /   / 
-- \_)  .--'(|  |_/ _ \     /_) |  .--'  |  |  / : |  .--' _ \     /_)
--  `|  |_)  |  |'->\-'\   /    |  `---. |  '-'  / |  `---.\-'\   /   
--   `--'    `--'       `-'     `------' `------'  `------'    `-'    

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
-- ###########################################################################################################
local GUI                        = {}
GUI.Time                         = 0
GUI.PhoneIsShowed                = false
--GUI.MessageEditorIsShowed        = false
GUI.MessagesIsShowed             = false
GUI.AddContactIsShowed           = false
local PhoneData                  = {phoneNumber = 0, contacts = {}}
local RegisteredMessageCallbacks = {}
local contactJustAdded           = false

local gpsx                       = 0
local gpsy                       = 0

-- ###########################################################################################################
RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	PhoneData.phoneNumber = phoneNumber
	PhoneData.contacts = {}
	for i=1, #contacts, 1 do
		table.insert(PhoneData.contacts, contacts[i])
	end
	SendNUIMessage({
		reloadPhone = true,
		phoneData   = PhoneData
	})
end)
-- ########################################################################################################### cl.loaded - js.reloadPhone - js.renderContacts - cl.addContact - js.contactAdded === true - js.reloadPhone - js.renderContacts - js.hideMessageEditor
RegisterNetEvent('esx_phone:addContact')
AddEventHandler('esx_phone:addContact', function(name, phoneNumber, isonline)
	table.insert(PhoneData.contacts, {
		name   = name,
		number = phoneNumber,
		online = isonline
	})
	-- CALL HERE RELOADCONTACT
	SendNUIMessage({
		contactAdded = true,
		phoneData   = PhoneData
	})
end)

RegisterNUICallback('add_contact', function(data, cb)
	local phoneNumber = tonumber(data.phoneNumber)
    local contactName = tostring(data.contactName)
	if phoneNumber then
		TriggerServerEvent('esx_phone:addPlayerContact', phoneNumber, contactName)
	end
end)

-- ###########################################################################################################
RegisterNetEvent('esx_phone:onMessage')
AddEventHandler('esx_phone:onMessage', function(phoneNumber, message, position, actions, anon, job)
	
	TriggerEvent('esx:showNotification', "~b~Nouveau message")
	
	gpsx = position.x
	gpsy = position.y
	
	SendNUIMessage({
		newMessage  = true,
		phoneNumber = phoneNumber,
		message     = message,
		position    = position,
		actions     = actions,
		anonyme     = anon,
		job         = job
	})
end)
-- ###########################################################################################################
RegisterNUICallback('setGPS', function(data)	
	SetNewWaypoint(gpsx,  gpsy)
	TriggerEvent('esx:showNotification', '~p~Position entrée dans le GPS')
	
end)
-- ###########################################################################################################
RegisterNUICallback('send', function(data)	
	TriggerEvent('esx:showNotification', '~p~Envoi du message...')
	TriggerEvent('esx:showNotification', '~p~... Message envoyé!')
	TriggerServerEvent('esx_phone:send', data.number, data.message, data.anonyme)	
	SendNUIMessage({ showMessageEditor = false })
end)
-- ###########################################################################################################
RegisterNUICallback('escape', function()
    SendNUIMessage({ showPhone = false })
    SetNuiFocus(false)
	GUI.PhoneIsShowed = false
end)
-- Menu Controls #############################################################################################
Citizen.CreateThread(function()
	while true do
        Wait(0)
        if GUI.PhoneIsShowed then -- codes here: https://pastebin.com/guYd0ht4
            DisableControlAction(0, 1,    true) -- LookLeftRight
            DisableControlAction(0, 2,    true) -- LookUpDown
            DisableControlAction(0, 25,   true) -- Input Aim
			DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override
			
            DisableControlAction(0, 24,   true) -- Input Attack
            DisableControlAction(0, 140,  true) -- Melee Attack Alternate
            DisableControlAction(0, 141,  true) -- Melee Attack Alternate
            DisableControlAction(0, 142,  true) -- Melee Attack Alternate
            DisableControlAction(0, 257,  true) -- Input Attack 2
            DisableControlAction(0, 263,  true) -- Input Melee Attack
            DisableControlAction(0, 264,  true) -- Input Melee Attack 2			
			
            DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
            DisableControlAction(0, 14,   true) -- Weapon Wheel Next
            DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
            DisableControlAction(0, 16,   true) -- Select Next Weapon
            DisableControlAction(0, 17,   true) -- Select Prev Weapon
			--[[
            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    click = true
                })
            end]]--
        else
            if IsControlPressed(0, Keys['F9']) then -- and (GetGameTimer() - GUI.Time) > 300 then
                if not GUI.PhoneIsShowed then
					TriggerServerEvent('esx_phone:reload', PhoneData.phoneNumber)
                    SendNUIMessage({
                        showPhone = true,
                        phoneData = PhoneData
                    })
                    SetNuiFocus(true)
                    GUI.PhoneIsShowed = true
                end
                GUI.Time = GetGameTimer()
				--Wait(500)
            end
        end
    end
end)
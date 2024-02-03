-- Resource Name Checking
local resourceName = GetCurrentResourceName()

if resourceName ~= 'pc_crosshair' then 		
	return print('Please change your resource name back to [^9pc_crossshair^7] else it won\'t run!')
end
--

--> Variables
Variables = {    
    Framework = Progressive_Code_Crosshair_Menu_Main_Config.Framework,

    isMenuOpen = false,

    isAiming = false,

    selectedCrosshair = 1
}

--> Framework
if Variables.Framework == 'qb-core' then
	Framework = exports[Progressive_Code_Crosshair_Menu_Main_Config.FrameworkResourceName]:GetCoreObject()
else
	Framework = exports[Progressive_Code_Crosshair_Menu_Main_Config.FrameworkResourceName]:getSharedObject()
end
--

-- Threads
CreateThread(function()
    while true do
        DisplayReticle()
        
        Citizen.Wait(250)
    end
end)
--

--> Open / Close Crosshair Menu
RegisterCommand('crosshair', function(source, args, user)
	SetNuiFocus(true, true)
    
    SetNuiFocusKeepInput(true)
    
    local crosshairConfig = Progressive_Code_Crosshair_Menu_Main_Config.Crosshairs

	SendNUIMessage({ curAction = 'open_menu', crosshairs = crosshairConfig })

    Variables.isMenuOpen = true 
end)

RegisterKeyMapping('crosshair', 'Crosshair', 'keyboard', 'F9')

RegisterNUICallback('quit', function(data, cb)
	SendNUIMessage({ curAction = 'disable' })

	SetNuiFocus(false, false)

    SetNuiFocusKeepInput(false)

    Variables.isMenuOpen = false
end)

RegisterNUICallback('crosshair', function(data, cb)
    SetReticle(data.number)
end)

RegisterNUICallback('loadCrosshair', function(data, cb)
    local savedReticle = GetSavedReticle()

	if savedReticle then
        SendNUIMessage({ curAction = "load_crosshair", crosshair_kvp = savedReticle })

		Notify('loaded_crosshair', 'info')
	end
end)
--

--> Threads
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        
        local letSleep = true

        if Variables.isMenuOpen then
            letSleep = false 

            DisableControlAction(0, 1, true) -- MOUSE RIGHT

            DisableControlAction(0, 2, true) -- MOUSE DOWN

            DisableControlAction(0, 257, true) -- LEFT MOUSE CLICK SHOOTING

            DisableControlAction(0, 44, true) -- Q

            DisableControlAction(0, 16, true) -- SCROLLWHEEL DOWN

            DisableControlAction(0, 17, true) -- SCROLLWHEEL UP

            DisableControlAction(0, 200, true) -- ESCAPE

            DisableControlAction(0, 24, true) -- ATTACK LEFT CLICK

            DisableControlAction(0, 140, true) -- ATTACK R
        end

        if letSleep then Citizen.Wait(1000) end
    end
end)
--

--> Functions

--> Set Crosshair
SetReticle = function(selected)
    if selected == Variables.selectedCrosshair then 
        Notify('already_selected', 'error', 4000, selected)

        return 
    end

	DeleteResourceKvp('pc_crosshair')

	SetResourceKvp('pc_crosshair', selected)

    Notify('selected_crosshair', 'success', 4000, selected)

    LoadReticle(selected)
end
--

--> Load Reticle
LoadReticle = function(selected)
    Variables.selectedCrosshair = selected
end
--

--> Get Saved Reticle
GetSavedReticle = function()
	local handle = StartFindKvp('pc_crosshair')

	if handle ~= -1 then
		local key = FindKvp(handle)

		if key then
			return GetResourceKvpString(key)
		else
			return false
		end
	end
end
--

--> Manage Reticle
DisplayReticle = function()
	if not IsEntityDead(PlayerPedId()) then
        if (IsPlayerFreeAiming(PlayerId())) then
            if not Variables.isAiming then
                SendNUIMessage({ curAction = "display_crosshair", boolean = Variables.selectedCrosshair })
                
                Variables.isAiming = true
            end
        else
            if Variables.isAiming then
                SendNUIMessage({ curAction = "display_crosshair", boolean = false })
                
                Variables.isAiming = false
            end
        end
    end
end
--

--> Notifications
Notify = function (messageKey, notifyType, length, firstInfo, secondInfo, thirdInfo)
    local message = Progressive_Code_Crosshair_Menu_Main_Config.Text[messageKey]

    -- Replace placeholders in the message with actual values
    message = message:gsub("%%d", tostring(firstInfo))
  
    message = message:gsub("%%s", tostring(secondInfo))

    message = message:gsub("%%r", tostring(thirdInfo))

    if Variables.Framework == 'qb-core' then        
        TriggerEvent('QBCore:Notify', message, notifyType, length)
    else
        TriggerEvent('esx:showNotification', message, notifyType, length)
    end
end
--

--

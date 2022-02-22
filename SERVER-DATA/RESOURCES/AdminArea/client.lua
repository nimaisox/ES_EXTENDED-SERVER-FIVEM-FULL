ESX = nil
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
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)
--- Config ---
misTxtDis = "~r~~h~Dar yek mantaghe rp pause ast!" -- Use colors from: https://gist.github.com/leonardosnt/061e691a1c6c0597d633

--- Code ---
local blips = {}
local coordsformarker = {}
function missionTextDisplay(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end
alredypause = true
RegisterNetEvent('Fax:AdminAreaSet')
AddEventHandler("Fax:AdminAreaSet", function(blip, s)
    if s ~= nil then
        src = s
        coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    else
        coords = blip.coords
    end 
    coordsformarker[blip.index] =  coords
    if not blips[blip.index] then
        blips[blip.index] = {}
    end

    if not givenCoords then
        TriggerServerEvent('AdminArea:setCoords', tonumber(blip.index), coords)
    end

    blips[blip.index]["blip"] = AddBlipForCoord(coords.x, coords.y, coords.z)
    blips[blip.index]["radius"] = AddBlipForRadius(coords.x, coords.y, coords.z, blip.radius)
    SetBlipSprite(blips[blip.index].blip, blip.id)
    SetBlipAsShortRange(blips[blip.index].blip, true)
    SetBlipColour(blips[blip.index].blip, blip.color)
    SetBlipScale(blips[blip.index].blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blip.name)
    EndTextCommandSetBlipName(blips[blip.index].blip)
    blips[blip.index]["coords"] = coords
    blips[blip.index]["radius2"] = blip.radius
    SetBlipAlpha(blips[blip.index]["radius"], 80)
    SetBlipColour(blips[blip.index]["radius"], blip.color)

    missionTextDisplay(misTxtDis.. "(" .. blip.pname ..")", 8000)
	blips[blip.index]["active"] = true
	while blips[blip.index]["active"] do
	Wait(0)
	if blips[blip.index] ~= nil then
	local coords = GetEntityCoords(GetPlayerPed(-1))
    local coords2 = blips[blip.index]["coords"]
    local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z,1))
	if distance > blips[blip.index]["radius2"] - 1 then
	DrawMarker(28, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius, blip.radius, blip.radius, 0,0,0, 255, false, true, 2, false, false, false, false)
	else
	DrawMarker(28, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius, blip.radius, blip.radius, 255,255,255, 100, false, true, 2, false, false, false, false)
                DisableControlAction(0, Keys['R'], true)
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Right click
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 263, true) -- Melee Attack 1
	end
	end
	end
end)



RegisterNetEvent('Fax:AdminAreaClear')
AddEventHandler("Fax:AdminAreaClear", function(blipID)
    if blips[blipID] then
	blips[blipID]["active"] = false
        RemoveBlip(blips[blipID].blip)
        RemoveBlip(blips[blipID].radius)
        blips[blipID] = nil
        missionTextDisplay("RP Dar mantaghe ~o~Admin Area(" .. blipID .. ")~r~ unpause ~w~shod!", 5000)
    else
        print("There was a issue with removing blip: " .. tostring(blipID))
    end
end)
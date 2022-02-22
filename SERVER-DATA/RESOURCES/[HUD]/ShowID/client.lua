Citizen.CreateThread(function()
    Wait(50)
    while true do
        miid(0.685, 1.345, 1.0,1.0,0.50, "~y~~H~ ID  :~w~  ".. GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) .. '', 255, 255, 255, 255)
        Citizen.Wait(1)
    end
end)

function miid(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(10)
    SetTextScale(scale, scale)
	SetTextColour( 0,0,0, 250 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2.1 + 0.005)
end
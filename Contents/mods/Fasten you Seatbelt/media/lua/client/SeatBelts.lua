local old_ISVehicleMenu_showRadialMenu = ISVehicleMenu.showRadialMenu
local old_ISVehicleMenu_onExit = ISVehicleMenu.onExit
local old_ISVehicleMenu_onSwitchSeat = ISVehicleMenu.onSwitchSeat

SeatBelted = 0


function ISVehicleMenu.onExit(player)
	if SeatBelted == 1 then	OnDetachingSeatBelt(player) end
	old_ISVehicleMenu_onExit(player)
end

function ISVehicleMenu.onSwitchSeat(player, seatTo)
	if SeatBelted == 1 then	OnDetachingSeatBelt(player) end
	old_ISVehicleMenu_onSwitchSeat(player, seatTo)
end
	
function ISVehicleMenu.showRadialMenu(player)
	
	--Let's run the vanilla function before our code
	old_ISVehicleMenu_showRadialMenu(player)	
	local vehicle = player:getVehicle()

	if vehicle ~= nil then
		local menu = getPlayerRadialMenu(player:getPlayerNum())
		
		--Gamepad stuff
		if menu:isReallyVisible() then
			if menu.joyfocus then
				setJoypadFocus(player:getplayerObjNum(), nil)
			end 
			menu:undisplay()
			return
		end

		--CUSTOM code
		local seat = vehicle:getSeat(player)				
		if SeatBelted == 0 then 
			menu:addSlice(getText('ContextMenu_CloseSeatbelt'), getTexture("media/ui/opened_seatbelt.png"), OnAttachingSeatBelt, player)	
		else 
			menu:addSlice(getText('ContextMenu_OpenSeatbelt'), getTexture("media/ui/closed_seatbelt.png"), OnDetachingSeatBelt, player)	
		end
	end
end

function OnAttachingSeatBelt (player)
ISTimedActionQueue.add(IsAttachingSeatBelt:new (player, 45))
SeatBelted = 1

end

function OnDetachingSeatBelt (player)
ISTimedActionQueue.add(IsDetachingSeatBelt:new (player, 45))
SeatBelted = 0
end
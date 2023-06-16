local old_ISVehicleMenu_showRadialMenu = ISVehicleMenu.showRadialMenu
local old_ISVehicleMenu_onExit = ISVehicleMenu.onExit
local old_ISVehicleMenu_onSwitchSeat = ISVehicleMenu.onSwitchSeat

SeatBelted = 0
SeatBeltCue = nil
LastCuePlayed = getTimestampMs()

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

		--Radial menu test
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
	ISTimedActionQueue.add(IsDetachingSeatBelt:new (player, 45));
	SeatBelted = 0;
end

function TestForSeatBelt()	
	local player = getPlayer()
	local vehicle = player:getVehicle()
	if vehicle == nil then return end	
	if SeatBelted == 1 then return end
	local speed = vehicle:getSpeed2D() 
	
	if speed >= 7 then		
		if (getTimestampMs() - LastCuePlayed >= 1100) then
			SeatBeltCue = getSoundManager():PlayWorldSound("beepbeep",player:getSquare(),0,10,1,true)				
			LastCuePlayed = getTimestampMs()			
		end
	end
end

function AddSeatBeltTest()
	Events.OnTick.Add(TestForSeatBelt)
end

function RemoveSeatBeltTest()
	Events.OnTick.Remove(TestForSeatBelt)
end

Events.OnEnterVehicle.Add(AddSeatBeltTest)
Events.OnExitVehicle.Add(RemoveSeatBeltTest)
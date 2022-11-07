local old_ISVehicleMenu_showRadialMenu = ISVehicleMenu.showRadialMenu
local old_ISVehicleMenu_onExit = ISVehicleMenu.onExit
local old_ISVehicleMenu_onSwitchSeat = ISVehicleMenu.onSwitchSeat

function ISVehicleMenu.onExit(player)
	if player:getModData().SeatBelted == 1 then	OnDetachingSeatBelt(player) end
	old_ISVehicleMenu_onExit(player)
end

function ISVehicleMenu.onSwitchSeat(player, seatTo)
	if player:getModData().SeatBelted == 1 then	OnDetachingSeatBelt(player) end
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
		if player:getModData().SeatBelted == 0 then 
			menu:addSlice(getText('ContextMenu_CloseSeatbelt'), getTexture("media/ui/opened_seatbelt.png"), OnAttachingSeatBelt, player)	
		else 
			menu:addSlice(getText('ContextMenu_OpenSeatbelt'), getTexture("media/ui/closed_seatbelt.png"), OnDetachingSeatBelt, player)	
		end
	end
end

function OnAttachingSeatBelt (player)
ISTimedActionQueue.add(IsAttachingSeatBelt:new (player, 45))
end

function OnDetachingSeatBelt (player)
ISTimedActionQueue.add(IsDetachingSeatBelt:new (player, 45))
end

--Below is the code yoinked from "Driving Skill" to track incoming car damage


function CheckDamages(player)
	if (player:getVehicle() == nil) then
		RemoveVehicleData(player)
		RemovePlayerData(player)
	else
		if(player:getModData().VehicleDamageTable[0] == nil) then
			StoreVehicleDamageData(player, player:getVehicle());
		end
		if(player:getModData().PlayerDamageTable[0] == nil) then
			StorePlayerDamageData(player);
		end
		CheckPartChanges(player, player:getVehicle());
	end
end

function CheckPartChanges(player, vehicle)
	local partCount = vehicle:getPartCount();
	local bodyparts = player:getBodyDamage():getBodyParts()
	local bodypartCount = player:getBodyDamage():getBodyParts():size()
	
	for i=0, partCount-1 do
		local part = vehicle:getPartByIndex(i);
		local knownHP = player:getModData().VehicleDamageTable[i];
		if(not part:getInventoryItem() and part:getTable("install") and knownHP ~= -1 ) then
			player:getModData().VehicleDamageTable[i] = -1;
		else
			local partHP = part:getCondition();	
			if(knownHP ~= partHP and knownHP ~= -1) then
				player:getModData().VehicleDamageTable[i] = partHP;
				--We had a car crash, did we suffer injuries ?
				
				for i=0,bodypartCount-1 do
					local knownbodypartHP = player:getModData().PlayerDamageTable[i]
					local newbodypartHP = player:getBodyDamage():getBodyPartHealth(i)
					if (newbodypartHP < knownbodypartHP) then					
						--HOURA WE DID IT !!!! This is where we know which bodypart has been hurt recently in a car crash !!!!!!
						--Now all we should have to do is test for the seatbelt and "reduce" the damage accordingly
						if (player:getModData().SeatBelted == 1 ) then
							local newHP = (knownbodypartHP -((knownbodypartHP - newbodypartHP)/3))
							bodyparts:get(i):SetHealth(newHP)
							print(bodyparts:get(i):getType())
							print("Previous HP",knownbodypartHP)
							print("Current HP",newbodypartHP)
							print("CorrectedHP : ",newHP)
							knownbodypartHP = newbodypartHP
						end
					end
				end
				return
			end
			 
		end
	end
end

function StoreVehicleDamageData(player, vehicle)
	local partCount = vehicle:getPartCount();
	for i=0, partCount-1 do	
		local part = vehicle:getPartByIndex(i);
		if (not part:getInventoryItem() and part:getTable("install")) then
			player:getModData().VehicleDamageData[i] = -1;
		else
			player:getModData().VehicleDamageTable[i] = part:getCondition();
		end
	end
end

function StorePlayerDamageData(player)
	local bodyParts = player:getBodyDamage():getBodyParts()
	local bodypartCount = bodyParts:size()
	for i=0, bodypartCount-1 do	
		local bodypart = bodyParts[i]
		player:getModData().PlayerDamageTable[i] = player:getBodyDamage():getBodyPartHealth(i)
	end
end

function RemoveVehicleData(player)
	player:getModData().VehicleDamageTable = {};
	
end

function RemovePlayerData(player)
	player:getModData().PlayerDamageTable = {};
end
Events.OnPlayerUpdate.Add(CheckDamages);

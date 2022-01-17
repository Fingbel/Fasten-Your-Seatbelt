--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"

IsDetachingSeatBelt = ISBaseTimedAction:derive('IsDetachingSeatBelt')

function IsDetachingSeatBelt:isValid()
	return true
end

function IsDetachingSeatBelt:start()
	self.character:getEmitter():playSound("seatbelt_UnPlug");
	end

function IsDetachingSeatBelt:stop()

	--StopTimeBasedAction
	ISBaseTimedAction.stop(self);
	
	end

function IsDetachingSeatBelt:perform()

		
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
	
end

function IsDetachingSeatBelt:new (character, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.maxTime = time;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end
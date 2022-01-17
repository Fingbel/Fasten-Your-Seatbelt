--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"

IsAttachingSeatBelt = ISBaseTimedAction:derive('IsAttachingSeatBelt')

function IsAttachingSeatBelt:isValid()
	return true
end

function IsAttachingSeatBelt:start()
	self.character:getEmitter():playSound("seatbelt_PlugIn");
	end

function IsAttachingSeatBelt:stop()

	--StopTimeBasedAction
	ISBaseTimedAction.stop(self);
	
	end

function IsAttachingSeatBelt:perform()

		
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
	
end

function IsAttachingSeatBelt:new (character, time)
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
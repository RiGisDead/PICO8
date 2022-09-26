--alarm library

alarms = {}

--call to make a new alarm
function MakeAlarm(ticks,func)
	local a = {}
	a.ticks = ticks
	a.Action = func
	add(alarms,a)
	return a
end

function UpdateAlarm(alarm)
	if (alarm.ticks > 0) then
		alarm.ticks -= 1 --sub 1 from ticks
	elseif (alarm.ticks == 0) then
		alarm.ticks = -1 -- stop countdown
		alarm.Action()
	end
end

--call from _update()
function UpdateAlarms()
	foreach(alarms, UpdateAlarm)
end

--start/restart an alarm
function StartAlarm(alarm, t)
	if (alarm.ticks == -1) then
		alarm.ticks = t
	end
end
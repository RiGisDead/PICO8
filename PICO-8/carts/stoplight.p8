pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
#include alarms.lua
#include colors.lua

function _init()
	cls(0)
	c = light_green
	alarm0 = make_alarm(90,ChangeColor)
end

function _update()
	update_alarms()
end

function _draw()
	cls(0)
	rect(0,0,32,96,white)
	circ(16,16,16)
	circ(16,48,16)
	circ(16,80,16)
	if (c == red) then 
		circfill(16,16,15,red)
	end
	if (c == yellow) then
		circfill(16,48,15,yellow)
	end
	if (c == light_green) then 
		circfill(16,80,15,light_green)
	end
end

function ChangeColor()
	if (c == red) then
		c = light_green
		start_alarm(alarm0, 150)
	elseif (c == light_green) then
		c = yellow
		start_alarm(alarm0, 60)
	elseif (c == yellow) then
		c = red
		start_alarm(alarm0, 90)
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

#include alarms.lua
#include colors.lua

function _init()

	alarm0 = make_alarm(10,Tick)
	alarm1 = make_alarm(-1,_init)
	list = {}
	top = 2 --the index where you're going to put the biggest number
	
	--Step 1
	--Use a for loop to populate indexes 1 to 128 with
	--the numbers from 1 to 128.
	--
	--for example:  index 1 in the list should contain 1
	--				index 2 in the list should contain 2
	--				index 3 in the list should contain 3...
	
	for i=1,128 do
		list[i] = i
	end
	
	--Step 2
	--Shuffle the list
	--Repeat 1000 times:
	--	generate a random number 1-128
	--	delete that number from the list
	--	add the number back to the list (to move it to the end)
	
	for i=0,1000 do
		x1=flr(rnd(128))+1
		del(list,x1)
		add(list,x1)
	end
end

--Step 3:
--This function performs 1 pass of the sorting algorithm
--to sort "list" into ascending order.
--
--The variable top contains the index to put the highest value in.
--Use a for loop to look at the list entries in indexes 1 to top.
--
--If you find a value at an index that is bigger than the one stored 
--at the top index, exchange the values at those indexes, so the 
--biggest one is at index top.  See the "Shuffling" video.  This is in C#
--but I think you can adapt it to Lua.
--
--After the loop, add 1 to top

function Sort()
	--Complete this using the instructions above
	for i=1,top do
		if list[i]>list[top] then
			temp=list[i]
			list[i]=list[top]
			list[top]=temp
		end	
	end
	top += 1
end

--Don't modify this
function Tick()
	if (top <= 128) then
		Sort()
		start_alarm(alarm0,1)
	else
		start_alarm(alarm1, 60)
	end
end
--Don't alter this
function _update()
	update_alarms()
end

--Don't modify this
function _draw()
	cls(black)
	color(white)
	print("top index: " .. top, 0, 0)
	
	if (#list == 128) then
	
		for i=1,128 do
			color( (i%15)+1 ) -- draw with the 15 non-black colors
			line(i-1,127,i-1,127 - list[i])
		end
	else
		print("your list needs 128 values!")
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

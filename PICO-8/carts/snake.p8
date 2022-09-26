pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
#include alarms.lua
#include colors.lua
#include utils.lua

left=0
right=1
up=2
down=3
button1=4
button2=5
top=8
gridSize=4

function _init()
	snake={x=60,y=60,direction=right,alive=true}
	trail={}
	apple={sprite=1,x=24,y=24}
	maxTrail=16
	score=0
end

function _update()
	if (snake.alive==true) then
		MoveSnake()
		--check for OOB
		if(snake.x < 0 or snake.y < top or snake.x > 124 or snake.y > 124) then
			snake.alive = false
		end
		--new snake segment
		s={x=snake.x,y=snake.y}
		add(trail,s)
		
		if (snake.x%gridSize==0 and snake.y%gridSize==0) then
			--make sure player is in grid
			HandleInput()
			--check for collision with self
			for i=1,#trail-1 do
				--get trail segment at [i] and check for collision
				s = trail[i]
				if (snake.x == s.x and snake.y == s.y) then
					--hit self
					snake.alive = false
				end
			end
			--check for collision with apple
			if(snake.x == apple.x and snake.y == apple.y) then
				--apple collision
				score += 1
				apple.x = flr(rnd(32)) * gridSize
				apple.y = flr(rnd(30)+2) * gridSize
				--add to trail
				maxTrail+=gridSize
			end
		end
		
		--delete last segment if list is too long
		if (#trail > maxTrail) then
			del(trail, trail[1]) --delete first thing from trail={}
		end
		
	else
		if(btn(button1) or btn(button2)) then
			_init()
		end
	end
end

function _draw()
	cls(1)
	rectfill(0,0,127,top-1,black) --top area
	print("score: "..score,0,1,white) --score
	rectfill(snake.x,snake.y,snake.x+gridSize-1,snake.y+gridSize-1,dark_green) --snake head
	spr(apple.sprite,apple.x,apple.y) --apple
	for t in all(trail) do
		rectfill(t.x,t.y,t.x+gridSize-1,t.y+gridSize-1,dark_green)
	end
end

function MoveSnake()
	if (snake.direction==up) then
		snake.y-=1
	elseif (snake.direction==down) then
		snake.y+=1
	elseif (snake.direction==left) then
		snake.x-=1
	elseif (snake.direction==right) then
		snake.x+=1
	end
end

function HandleInput()
	if (btn(up) and snake.direction != down) then
		snake.direction=up
	elseif (btn(down) and snake.direction != up) then
		snake.direction=down
	elseif (btn(left) and snake.direction != right) then
		snake.direction=left
	elseif (btn(right) and snake.direction != left) then
		snake.direction=right
	end
end

__gfx__
00000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

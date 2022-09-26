function _init()
	score=0
	gameOver=false
	player = NewObject(63,63,1,0,0)
	alarm0 = MakeAlarm(30,UpdateScore)
	baddies={}
	for i=1,15 do
		local b = NewObject(flr(rnd(128)),flr(rnd(-128)),2,flr(rnd(2))+1,270)
		add(baddies,b)
	end
end

function _update()
	UpdateAlarms()
	
	if (gameOver==false) then
		for b in all(baddies) do
			MoveObject(b)
			if (b.y>128) then
				b.x=flr(rnd(128))
				b.y=-8
			end
		end
	else
		if (btnp(button1)) then ResetGame() end
		if (btnp(button2)) then ResetGame() end
	end
	--movement code
	Input(player)
	--collision
	for b in all(baddies) do
		if (RectHit(b,player)) then
			b.speed=0
			gameOver=true
			sfx(0)
		end
	end
end

function _draw()
	cls()
	for b in all(baddies) do
		b.Draw(b)
	end
	player.Draw(player)
	print("score: "..score,63,0,7)
	if (gameOver==true) then
		print("GAME OVER",63,63,7)
	end
end

function ResetGame()
	player.x=63
	player.y=63
	for b in all(baddies) do
		b.y-=128
		b.speed=flr(rnd(2))+1
	end
	score=0
	gameOver=false
end

function UpdateScore()
	StartAlarm(alarm0,30)
	if (gameOver==false) then score+=1 end
end

function StopBaddies()
	for b in all(baddies) do
		b.speed=0
	end
end
--main game functions
function _init()
	BossShootAlarm=MakeAlarm(-1,BossShoot)
	--variables
	currentScene=0
	GameOver=false
	damageCount=60
	camx=0
	camy=0
	bulletTiming=30
	bulletDamageTiming=15
	bossTimer=30
	shouldTeleport=false
	run_num=0
	minionsSpawned=false
	canShoot=false
	
	--scene tables
	scene1={}
	scene2={}
	scene3={}
	add(scenes, scene1)
	add(scenes, scene2)
	add(scenes, scene3)
	
	--items
	
	--scene1 objects
	key0=NewObject(-128,-128,17)
	add(scene1,key0)
	
	door0=NewObject(232,72,29)
	add(scene1,door0)
	
	sign0=NewObject(130,130,16)
	add(scene1,sign0)
	
	--scene2 objects
	door1=NewObject(-128,-128,30)
	
	--scene3 objects
	sign1=NewObject(240,352,16)
	
	--player things
	bullets={}
	player=NewObject(110,130,1,1)
	player.health=3
	player.keys=0
	
	--enemies/bosses
	enemies={}
	bosses={}
	minions={}
	bossbullets={}
	
	beachPirate=NewObject(300,150,4,0.2)
	beachPirate.dropkey=function(self)
		if self.destroy==true then
			key0.x=self.x
			key0.y=self.y	
		end
	end
	beachPirate.health=1
	add(enemies,beachPirate)
	
	lizardBoss=NewObject(864,240,64,0)
	lizardBoss.health=15
	lizardBoss.w=16
	lizardBoss.h=16
	lizardBoss.dropkey=function(self)
		if self.destroy==true then
			door1.x=self.x
			door1.y=self.y
		end
	end
	add(bosses,lizardBoss)
	
end

function _update60()
	if currentScene==-1 then
		UpdateGameOver()
	elseif currentScene==0 then
		UpdateTitleScreen()
	else
		Input(player)
		Anim()
		UpdateBullets()
		UpdateEnemies()
		MoveEnemies()
		UpdateKeys()
		OpenDoor()
		GameOverCheck()
		BossBehavior()
	end
	Camera()
	UpdateAlarms()
	--printh()
end

function _draw()
	if currentScene==-1 then
		DrawGameOver()
	elseif currentScene==0 then
		DrawTitleScreen()
	else
		DrawMap()
		DrawItems()
		player:draw(1,1)
		DrawEnemies()
		DrawBullets()
		OverlayDisplay()
	end
end

--title screen/game over functions
function DrawTitleScreen()
	cls()
	spr(1,58,20)
	print("island escape",63-13*2,35,orange)
	print("press z to shoot",63-16*2,50,red)
	print("press x to start",63-16*2,65,white)
	spr(66,55,80,2,2)
	spr(9,78,88,1,1,true)
	spr(9,40,88)
end

function UpdateTitleScreen()
	if (btn(button2)) then
		sfx(3)
		currentScene=1
	end
end

function DrawGameOver()
	cls()
	print("game over!",63-10*2,53,red)
	print("press z to restart",63-18*2,63,white)
end

function UpdateGameOver()
	if btn(button1) then
		sfx(3)
		currentScene=0
		_init()
	end
end

function GameOverCheck()
	if GameOver==true then
		currentScene=-1
	end
end

--world functions
function DrawMap()
	cls()
	map(0,0,0,0,127,45)
end

function Camera()
	camx=player.x-60
	camy=player.y-60
	if currentScene<1 then camx=0 camy=0 end
	camera(camx,camy)
end

function Teleport(newX,newY)
	player.x=newX
	player.y=newY
	shouldTeleport=false
end

--ui
function OverlayDisplay()
	if player.health==3 then
		str="♥♥♥"
	elseif player.health==2 then
		str=" ♥♥"
	elseif player.health==1 then
		str="  ♥"
	else
		str=""
		GameOver=true
	end
	print(str,player.x-#str*2,player.y-59,red)
	if btn(button2) then ShowInv() end
	ReadSigns()
end

function ShowInv()
	invx=camx+40
	invy=camy+20
	rectfill(invx,invy,invx+48,invy+24,black)
	print("items",invx+15,invy+4,white)
	print("keys: "..player.keys,invx+11,invy+14,orange)
end

function ReadSigns()
	if RectHit(player,sign0) then
		print("Kill the pirate and\n enter the dungeon!",camx+5,camy+100,red)
	end
	if RectHit(player,sign1) then
		print("You won!\nGood job :)",camx+5,camy+100,white)
	end
end

--player animation
function Anim()
	local timing=0.06
	player.sprite+=timing
	if player.sprite>2.9 or player.dx==0 and player.dy==0 then player.sprite=1 end
end

--bullets
function Shoot(_dx,_dy)
	sfx(2)
	if(_dx==nil and _dy==nil) then _dx=2 _dy=0 end
	add(bullets,{
		x=player.x+2,
		y=player.y+3,
		w=3,
		h=3,
		dx=_dx,
		dy=_dy,
		life=60,
		draw=function(self)
			spr(0,self.x,self.y)
		end,
		update=function(self)
			self.x+=self.dx
			self.y+=self.dy
			self.life-=1
			if self.life<0 then del(bullets,self) end
		end
	})
end

function UpdateBullets()
	bulletTiming-=1
	if (btnp(button1)) and bulletTiming<=0 then
		if (btn(up)) then bulletx=0 bullety=-2 end
		if (btn(left)) then bulletx=-2 bullety=0 end
		if (btn(down)) then bulletx=0 bullety=2 end
		if (btn(right)) then bulletx=2 bullety=0 end
		if (btn(up) and btn(left)) then bulletx=-2 bullety=-2 end
		if (btn(up) and btn(right)) then bulletx=2 bullety=-2 end
		if (btn(down) and btn(left)) then bulletx=-2 bullety=2 end
		if (btn(down) and btn(right)) then bulletx=2 bullety=2 end
		Shoot(bulletx,bullety)
		bulletTiming=30
	end
	
	for b in all(bullets) do
		b:update()
		
		for e in all(enemies) do
			if RectHit(b,e) then
				e.health-=1
				sfx(4)
				del(bullets,b)
				break
			end
		end
		
		for r in all(bosses) do
			if RectHit(b,r) then
				r.health-=1
				sfx(4)
				del(bullets,b)
				break
			end
		end
		
		for m in all(minions) do
			if RectHit(b,m) then
				m.health-=1
				sfx(4)
				del(bullets,b)
				break
			end
		end	
	
		if Collision(b.x+b.dx,b.y,b.w,b.h)
		or Collision(b.x,b.y+b.dy,b.w,b.h) then del(bullets,b) end
	end
	
	for b in all(bossbullets) do
		b:update()
		if RectHit(b,player) then
			player.health-=1
			sfx(4)
			del(bossbullets,b)
			break
		end
	end
end

function DrawBullets()
	for b in all(bullets) do
		b:draw()
	end
	for b in all(bossbullets) do
		b:draw()
	end
end

--player items logic
function DrawItems()
	if currentScene==1 then
		for i in all(scene1) do
			i:draw(1,1)
		end
	end
	if currentScene==2 then
		for i in all(scene2) do
			i:draw(1,1)
		end
	end
end

function SwapTile(x,y)
	tile=mget(x,y)
	mset(x,y,tile+1)
end

function UpdateKeys()
	if key0.visible then
		if RectHit(player,key0) then
			SwapTile(key0.x,key0.y)
			player.keys+=1
			key0.visible=false
			sfx(0)
		end
	end
end

function OpenDoor()
	if door0.visible==true and currentScene==1 then
		if RectHit(player,door0) and player.keys>0 then
			player.keys-=1
			door0.visible=false
			sfx(0)
		end
		shouldTeleport=true
	elseif shouldTeleport==true then
		currentScene=2
		scene1=nil
		Teleport(1000,35)
	end
end

--enemies
function UpdateEnemies()

	if currentScene==1 then
		beachPirate:dropkey()
	end
	
	if currentScene==2 then
		lizardBoss:dropkey()
	end
	
	if damageCount>0 then
		damageCount-=1
	end
	
	if #enemies>0 then
		for e in all(enemies) do
		if e.health==0 then e.destroy=true end
			--check for overlap with player then cause damage
			if RectHit(e,player) and damageCount==0 then
				player.health-=1
				damageCount=60
				sfx(1)
			end
			--check to remove all destroyed enemies from enemies{}
			if e.destroy==true then
				del(enemies,e)
			end
			--flip enemy sprite based on x position
			if e.x>player.x then
				e.facingLeft=true
			else
				e.facingLeft=false
			end
		end
	end
	
	--bosses logic
	if #bosses>0 then
		for b in all(bosses) do
			if b.health==0 then b.destroy=true end
			--check for overlap with player then cause damage
			if RectHit(b,player) and damageCount==0 then
				player.health-=1
				damageCount=60
				sfx(1)
			end
			--check to remove all destroyed enemies from enemies{}
			if b.destroy==true then
				del(bosses,b)
			end
		end
	end
	
	if #minions>0 then
		for m in all(minions) do
		if m.health==0 then m.destroy=true end

			if RectHit(m,player) and damageCount==0 then
				player.health-=1
				damageCount=60
				sfx(1)
			end

			if m.destroy==true then
				del(minions,m)
			end

			if m.x>player.x then
				m.facingLeft=true
			else
				m.facingLeft=false
			end
		end
	end
	
end

function MoveEnemies()
	--beach pirate code
	if beachPirate.destroy==false then
		beachPirate.sprite+=0.05
		if beachPirate.sprite>5.9 then beachPirate.sprite=4 end
		
		if Collision(beachPirate.x+beachPirate.dx,beachPirate.y,beachPirate.w,beachPirate.h) then
			beachPirate.x-=1
		end
		
		if Collision(beachPirate.x,beachPirate.y+beachPirate.dy,beachPirate.w,beachPirate.h) then 
			beachPirate.y+=1
		end
		
		MoveToward(beachPirate, player.x, player.y, beachPirate.speed)
		MoveObject(beachPirate)
	end
	
	if minionsSpawned==true then
		if #minions>0 then
			for m in all(minions) do
				MoveToward(m, player.x, player.y, rnd(1))
				MoveObject(m)
			end
		end
	end
end

function DrawEnemies()
	for e in all (enemies) do
		e:draw(1,1)
	end
	for b in all(bosses) do
		b:draw(2,2)
	end
	for m in all(minions) do
		m:draw(1,1)
	end
end

function SpawnMinions()
	if run_num>=1 then
		return
	end
	run_num+=1
	for i=1,3 do
		slime=NewObject(lizardBoss.x+rnd(30)-16,lizardBoss.y+rnd(30)-10,rnd({6,7,8}))
		slime.health=1
		add(minions,slime)
	end
	minionsSpawned=true
end

--bosses

function BossBehavior()
	if currentScene==2 then
		if lizardBoss.health<=15 and lizardBoss.health>10 then
			BossMovement(lizardBoss)
		elseif lizardBoss.health==10 then
			lizardBoss.sprite=66
			SpawnEnemiesAlarm=MakeAlarm(60,SpawnMinions)
		end
		
		if (lizardBoss.health < 10 ) and lizardBoss.destroy==false then
			BossMovement(lizardBoss)
			if (BossShootAlarm != -1) then
				StartAlarm(BossShootAlarm,120)
			end
		end

	end
		
end

function BossShoot()
	add(bossbullets,{
		x=lizardBoss.x+4,
		y=lizardBoss.y+8,
		w=4,
		h=4,
		life=300,
		draw=function(self)
			spr(68,self.x,self.y)
		end,
		update=function(self)
			self.life-=1
			MoveToward(self, player.x, player.y, 0.5)
			MoveObject(self)
			if self.life<=0 then del(bossbullets, self) end
		end
	})	
	StartAlarm(BossShootAlarm,120)
end

function BossMovement(o)
	MoveToward(o, player.x, player.y, 1)
	bossTimer-=1
	if bossTimer==0 then
		MoveObject(o)
		bossTimer=30
	end
end
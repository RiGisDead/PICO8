--library for 2d development

--player input function
function Input(o)
	if (o.visible==true) then
		o.dx=0
		o.dy=0
		
		if (btn(up)) then o.dy-=1 end
		if (btn(down)) then o.dy+=1 end
		if (btn(left)) then o.dx-=1 o.facingLeft=true end
		if (btn(right)) then o.dx+=1 o.facingLeft=false end
		
		--collision code
		if Collision(o.x+o.dx,o.y,o.w,o.h) then 
			o.dx=0 
		end
		
		if Collision(o.x,o.y+o.dy,o.w,o.h) then 
			o.dy=0 
		end

		o.x+=o.dx
		o.y+=o.dy
	end
end

--create and return new object
function NewObject(x,y,sprite,speed,direction)
	local o={} --making new object
	o.x=x
	o.y=y
	o.w=8 --pixels wide
	o.h=8 --pixels high
	o.dx=0
	o.dy=0
	o.sprite=sprite
	o.speed=speed
	o.direction=direction
	o.facingLeft=false
	o.destroy=false
	o.visible=true
	o.draw = function(self,w,h)
		if (self.visible==true) then
			spr(self.sprite,self.x,self.y,self.w/8,self.h/8,self.facingLeft)
			rect(self.x, self.y, self.x+self.w, self.y+self.h)
		end
	end
	return o
end

--returns true or false if x,y is or isn't inside object
function PtInRectCentered(x,y,o)
	if (x >= o.x-o.w/2 and x <= o.x+o.w/2) then
		if (y >= o.y-o.h/2 and y <= o.y+o.h/2) then
			return true
		end	
	end
	return false
end

--returns t/f based on weather objects are overlapping or not
function RectHit(o1,o2)

	if PtInRect(o1.x,o1.y, 	o2.x,o2.y,o2.w,o2.h) then return true end
	if PtInRect(o1.x+o1.w,o1.y, 	o2.x,o2.y,o2.w,o2.h) then return true end
	if PtInRect(o1.x+o1.w,o1.y+o1.h, 	o2.x,o2.y,o2.w,o2.h) then return true end
	if PtInRect(o1.x,o1.y+o1.h, 	o2.x,o2.y,o2.w,o2.h) then return true end
	
	if PtInRect(o2.x,o2.y, 	o1.x,o1.y,o1.w,o1.h) then return true end
	if PtInRect(o2.x+o2.w,o2.y, 	o1.x,o1.y,o1.w,o1.h) then return true end
	if PtInRect(o2.x+o2.w,o2.y+o2.h,	 o1.x,o1.y,o1.w,o1.h) then return true end
	if PtInRect(o2.x,o2.y+o2.h, 	o1.x,o1.y,o1.w,o1.h) then return true end
	
	return false
end

function PtInRect(x,y,x1,y1,w,h) 
	if (x > x1 and x <= x1+w) then
		if (y > y1 and y < y1+h) then
			return true
		end
	end
	return false
end


--returns t/f based on weather objects are overlapping or not
function RectHitCentered(o1,o2)
	local dx = abs(o2.x - o1.x)
	local dy = abs(o2.y - o1.y)
	
	if (dx < o1.w/2+o2.w/2) then
		if (dy < o1.h/2+o2.h/2) then
			return true
		end
	end
	return false
end

--map collision
function Collision(x,y,w,h)
	collide=false
	
	for i=x,x+w,w do
		if fget(mget(i/8,y/8),0) or fget(mget(i/8,(y+h)/8),0) then
		collide=true
		end
	end
	return collide
end

--moves an object based on speed and direction
function MoveObject(o)
	o.x = o.x + cos(o.direction/360)*o.speed
	o.y = o.y + sin(o.direction/360)*o.speed
end

--moves an objects toward destX, destY [newSpeed is optional]
function MoveToward(o,destX,destY,newSpeed)
	if (newSpeed != nil) then o.speed=newSpeed end
	o.direction = atan2(destX-o.x, destY-o.y)*360
end

--starts o1 moving towards o2
function MoveTowardObject(o,o2,newSpeed)
	if (newSpeed != nil) then o.speed=newSpeed end
	o.direction = atan2(o2.x-o.x, o2.y-o.y)*360
end

--distance formula
function Distance(o1,o2)
	local dx = o1.x-o2.x
	local dy = o1.y-o2.y
	return sqrt(dx*dx + dy*dy)
end
--distance formula
function dst(o1,o2)
	local dx = o1.x-o2.x
	local dy = o1.y-o2.y
	return sqrt(dx*dx + dy*dy)
end




--returns the closest object in 'list' to o1
function FindClosest(o1, list)
	--assume the 1st object in the list 
	--is the closest
	local closestObj = list[1]
	local distToClosest = Distance(o1,closestObj)
	--look at all the objects in the list
	for o2 in all(list) do
		--get distance to an object
		local thisDist = Distance(o1,o2)
		--is it closer than the closest so far
		if (thisDist < distToClosest) then	
			--now we have a new closest
			--and a new closest distance to it
			distToClosest = thisDist
			closestObj = o2
		end
	end

	return closestObj
end

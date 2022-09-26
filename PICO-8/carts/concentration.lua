--concentration

function _init()
	--don't change any of this stuff
	board = {}
	spriteTable = {}
	card = 0
	cursorX = 0
	cursorY = 0
	firstCard = nil
	secondCard = nil	
	
	--build table
	CARD_BACK = 1
		
	--look up table of card types to sprites
	spriteTable[0]  = 3
	spriteTable[1]  = 5
	spriteTable[2]  = 7
	spriteTable[3]  = 9
	spriteTable[4]  = 11
	spriteTable[5]  = 13
	spriteTable[6]  = 33
	spriteTable[7]  = 35
	
	--create alarms we'll need
	cardAlarm = make_alarm(-1,CheckCards)
	resetAlarm = make_alarm(-1,Reset)
	hideAlarm = make_alarm(-1,HideAll)

	--TODO: use a for-loop to add 8 lists to board
	--starting at index 0 
	for i=0,7 do
		board[i] = {}
	end
	
	--put cards into it
	cardType = 0
	for i=0,7 do
		for j=0,7 do
			board[i][j] = {} --make a new object
			board[i][j].cardType = cardType
			board[i][j].faceDown = true
			board[i][j].hidden = false
			cardType += 1
			if (cardType == 8) cardType = 0
		end
	end

	--TODO: Call the shuffle function
	Shuffle()
	
end


function _update()
	update_alarms()
	--TODO: complete user input handling
	if (btnp(left) and cursorX > 0) then cursorX-=1
	elseif (btnp(right) and cursorX < 7) then cursorX+=1
	elseif (btnp(up) and cursorY > 0) then cursorY-=1
	elseif (btnp(down) and cursorY < 7) then cursorY+=1 end
	if (btnp(button1)) then 
		if (board[cursorX][cursorY].hidden == false) then
			TurnOverCard(board[cursorX][cursorY])
		end
	end 
	if (btnp(button2)) then
		Cheat()
	end
end

function _draw()
	cls(BLACK)
	
	for i=0,7 do
		for j=0,7 do
			
			if (board[i][j].hidden == false) then
				if (board[i][j].faceDown == true) then
					spr(1,i*16,j*16,2,2)		
				elseif (board[i][j].hidden == false) then
					--TODO:  complete the following 3 steps
					
					--1. Get the card type for the card at i,j and store it
					--in a variable called t (for type)
					t = board[i][j].cardType
					
					--2. Use t to look up the sprite for that card type in the spriteTable
					--Store that number in a variable called s  (for sprite)
					s = spriteTable[t]
					
					--3. Draw sprite s at, i*16,j*16 
					-- (You will need to specify it's 2 sprites wide and s sprites tall)
					spr(s,i*16,j*16, 2 , 2)
				end
			end
		end
	end
	
	--draw the cursor
	rect(cursorX*16,cursorY*16,cursorX*16+15,cursorY*16+15,YELLOW)

end

function TurnOverCard(c)
	--TODO: See the instructions in the PDF
	if (firstCard == nil) then
		sfx(0)
		firstCard=c
		--printh("card is ".. c.cardType)
		firstCard.faceDown=false
	elseif (secondCard==nil and firstCard !=c) then
		sfx(0)
		secondCard=c
		secondCard.faceDown=false
		start_alarm(cardAlarm,30)
	end
	--printh("card is ".. c.cardType)
end

function CheckCards()
	--TODO: See the instructions in the PDF
	if (firstCard.cardType == secondCard.cardType) then
		sfx(1)
		firstCard.hidden=true
		secondCard.hidden=true
		if	GameOver() then
			start_alarm(resetAlarm,90)
		end
	else
		sfx(0)
		firstCard.faceDown=true
		secondCard.faceDown=true
	end
	firstCard=nil
	secondCard=nil
end


function Shuffle()
	--TODO: See the instructions
	--Create a loop that repeats 1000 times
	--in the loop exchange the card properties of 
	--two randomly selected cards
	for i=1,1000 do
	i1= flr(rnd(7))
	j1= flr(rnd(7))
	i2= flr(rnd(7))
	j2= flr(rnd(7))
	temp = board[i1][j1].cardType
	board[i1][j1].cardType = board[i2][j2].cardType
	temp = board[i2][j2].cardType
	end
end

--returns true or false 
--returns false if any of the cards' hidden variable
--is false, otherwise the function returns true
function GameOver()
	--TODO: 
	--Examine each object in the board using (using nested loops)....
	--If you find one whose hidden property is false, return false

	for i=0,7 do
		for j=0,7 do
			if (board[i][j].hidden == false) then
			return false;
			end
		end
	end

	--TODO:  Change this to true when you've completed the previous step
	return true
end

function Reset()
	-- TODO: For you to complete
	--1) Set every object's hidden variable to false
	--2) Set every object's faceDown variable to true
	--3) Call the Shuffle function
	for i=0,7 do
		for j=0,7 do
			board[i][j].faceDown = false
			board[i][j].hidden = true
		end
	end
	Shuffle()
end

function HideAll()
	for i=0,7 do
		for j=0,7 do
			board[i][j].faceDown = true
		end
	end
end

function Cheat()
	for i=0,7 do
		for j=0,7 do
			board[i][j].faceDown = false
		end
	end
	start_alarm(hideAlarm,60)
end

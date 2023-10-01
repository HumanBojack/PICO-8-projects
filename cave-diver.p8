pico-8 cartridge // http://www.pico-8.com
version 37
__lua__
-- cave diver
-- by humanbojack, based on dylan bennett
local player
local cave

function _init()
	game_over=false
	cave=make_cave()
	player=make_player(24,60)
end

function _update()
	if (not game_over) then
		cave:update()
		player:update()
	else
		-- restart
		if (btnp(5)) _init()
	end
end

function _draw()
	cls()
	cave:draw()
	player:draw()
	
	if game_over then
		print("game over!",44,44,7)
		print("your score:"..player.score,34,54,7)
		print("press ❎ to play again!",18,72,6)
	else
		print("score:"..player.score,2,2,7)
	end
end
-->8
function make_player(x,y)
	player={
		-- position
		x=x,
		y=y,
		-- speed
		velocity_y=0,
		velocity_x=2,
		-- sprites
		rise=1,
		fall=2,
		dead=3,
		-- other
		score=0,
		htb={x1=1,x2=7,y1=1,y2=5},
		-- functions
		check_for_hit=function(self, other)
			for i=self.x+self.htb.x1,self.x+self.htb.x2 do
				if (other.ceiling[i+1]>self.y+self.htb.y1
					or other.floor[i+1]<self.y+self.htb.y2) then
					game_over=true
					sfx(1)
				end
			end
		end,
		draw=function(self)
			if (game_over) then
				spr(self.dead,self.x,self.y)
			elseif (self.velocity_y<0) then
				spr(self.rise,self.x,self.y)
			else
				spr(self.fall,self.x,self.y)
			end
			
			-- debug
			--pset(self.x,self.y,10)
			--rect(self.x+self.htb.x1,self.y+self.htb.y1,self.x+self.htb.x2,self.y+self.htb.y2, 10)
		end,
		update=function(self)
			gravity=0.2
			self.velocity_y+=gravity
			
			-- jump
			if (btnp(2)) then
				self.velocity_y-=6
				sfx(0)
			end
			
			self.velocity_y=mid(-3,self.velocity_y,5)
			
			-- move the player
			self.y+=self.velocity_y
			
			-- update the score
			self.score+=self.velocity_x
			
			-- check if we touch the cave
			self:check_for_hit(cave)
		end
	}
	return player
end
-->8
function make_cave()
	cave={
		ceiling_min=3,
		ceiling_max=45,
		floor_min=124,
		floor_max=89,
		ceiling={5},
		floor={100},
		-- functions
		update=function(self)
			-- remove the back of the cave
			if (#self.ceiling>player.velocity_x) then
				for i=1,player.velocity_x do
					del(self.ceiling,self.ceiling[1])			
					del(self.floor,self.floor[1])
				end
			end
			
			-- generate the front of the cave
			while (#self.ceiling<128) do
				-- generate rnd between -1 and 1
				local top_change=flr(rnd(3)-1)
				local btm_change=flr(rnd(3)-1)
				
				local top=mid(self.ceiling_min,self.ceiling[#self.ceiling]+top_change,self.ceiling_max)
				local btm=mid(self.floor_min,self.floor[#self.floor]+btm_change,self.floor_max)
				
				add(self.ceiling, top)
				add(self.floor, btm)
			end
		end,
		draw=function(self)
			for i=1, #cave.ceiling do
				line(i-1,0,i-1,self.ceiling[i],5)
				line(i-1,127,i-1,self.floor[i],5)
			end
		end
	}
	return cave
end
__gfx__
00000000000000007007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000cc007000cc000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000000c0c00000c0c00000909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000cccc0000cccc000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000ccccc100ccccc1009999910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000cc110000cc110000991100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
050100000a0500b050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000240502405021050210501c0501c0501c0501c050160001600016000160001c5001c500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

pico-8 cartridge // http://www.pico-8.com
version 37
__lua__
-- draw
-- by humanbojack

local game_objects
local mouse_mode = false
local fast_mode = true
local cursor

function _init()
	game_objects={}

	-- Enable mouse support
	poke(0x5f2d, 1)

	-- Create the cursor
	cursor=make_game_object("cursor",64,64,3,3,{
		color=5,
		update=function(self)
			-- Mouse controls
			if mouse_mode then
				self.x=stat(32)
				self.y=stat(33)
			end

			-- Setup the button check function depending on fast mode
			if fast_mode then
				btn_check = btn
			else
				btn_check = btnp
			end

			-- Keyboard controls
			if not mouse_mode then
				if btn_check(⬅️) then
					self.x-=1
				elseif btn_check(➡️) then
					self.x+=1
				end

				if btn_check(⬆️) then
					self.y-=1
				elseif btn_check(⬇️) then
					self.y+=1
				end
			end

			-- Check collisions with the border
			if self.x < 0 then
				self.x=0
			elseif self.x > 127 then
				self.x=127
			end

			if self.y < 0 then
				self.y=0
			elseif self.y > 127 then
				self.y=127
			end

			-- Create drawings
			if btn(❎) then

				-- check if the pixel (other) is overlapping with our cursor (self) and delete it
				for_each_game_object("pixel",
					function(other)
						if other:check_for_hit(self) then
							del(game_objects, other)
						end
					end
				)
			
				-- Create a new pixel
				local obj
				obj = make_game_object(
					"pixel", self.x, self.y, 1, 1,
					{
						color=self.color,
						draw=function(self)
							pset(self.x, self.y, self.color)
						end,
						check_for_hit=function(self,other)
							return self.x == other.x and self.y == other.y
						end
					}
				)
			end

		end,
		center=function(self)
			return self.x, self.y
		end,
		draw=function(self)
			spr(0, self.x - flr(self.width/2), self.y - flr(self.height/2))
		end,
		check_for_hit=function(self,other)
			local x,y = self:center()

			-- Check if the cursor is overlapping with the other object
			return x >= other.x and x <= other.x + other.width and y >= other.y and y <= other.y + other.height
		end
	})

	-- Create the menu
	mouse_mode_button=make_game_object("button", 3, 119, 8, 8, {
		update=function(self)
			if btnp(🅾️) then
				-- check if the cursor is overlapping with our button
				if cursor:check_for_hit(self) then
					mouse_mode = not mouse_mode
					sfx(0)
				end
			end
		end,
		draw=function(self)
			-- Draw the corresponding icon
			if mouse_mode then
				spr(1, self.x, self.y)
			else
				spr(2, self.x, self.y)
			end
		end
	})

	fast_mode_button=make_game_object("button", 13, 119, 8, 8, {
		update=function(self)
			if btnp(🅾️) then
				-- check if the cursor is overlapping with our button
				if cursor:check_for_hit(self) then
					fast_mode = not fast_mode
					sfx(0)
				end
			end
		end,
		draw=function(self)
			-- Draw the corresponding icon (only if mouse_mode is disabled)
			if not mouse_mode then
				if not fast_mode then
					spr(3, self.x, self.y)
				else
					spr(4, self.x, self.y)
				end
			end
		end
	})

	clear_button=make_game_object("button", 23, 119, 8, 8, {
		update=function(self)
			if btnp(🅾️) then
				-- check if the cursor is overlapping with our button
				if cursor:check_for_hit(self) then
					-- Delete all the pixels
					for_each_game_object("pixel",
						function(other)
							del(game_objects, other)
						end
					)
					sfx(0)
				end
			end
		end,
		draw=function(self)
			spr(5, self.x, self.y)
		end
	})

	color_btn=make_game_object("button", 33, 119, 8, 8, {
		update=function(self)
			if btnp(🅾️) then
				-- check if the cursor is overlapping with our button
				if cursor:check_for_hit(self) then
					-- Change the color of the cursor
					cursor.color = (cursor.color + 1) % 16
					sfx(0)
				end
			end
		end,
		draw=function(self)
			rectfill(self.x, self.y, self.x + self.width-1, self.y + self.height-1, cursor.color)
		end
	})

end

function _update()
	local obj
	for obj in all(game_objects) do
		obj:update()
	end
end

function _draw()
	cls(7)

	-- Draw the menu
	rectfill(0,117,127,127,1)
	print("x: "..tostr(cursor.x)..", y: "..tostr(cursor.y), 1, 1, 1)

	-- Draw the game objects
	for i = #game_objects, 1, -1 do
		local obj = game_objects[i]
		obj:draw()
	end

end

function make_game_object(name,x,y,width,height,props)
	local obj={
		name=name,
		x=x,
		y=y,
		width=width,
		height=height,
		velocity_x=0,
		velocity_y=0,
		center=function(self)
			return self.x+self.width/2, self.y+self.height/2
		end,
		update=function(self)
		end,
		draw=function(self)
		end
	}

	local key,value
	for key,value in pairs(props) do
		obj[key]=value
	end

	add(game_objects, obj)
	return obj
end

function for_each_game_object(name,callback)
	local obj
	for obj in all(game_objects) do
		if obj.name==name then
			callback(obj)
		end
	end
end



__gfx__
08000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80800000007770000777777000770000770077000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000
08000000070707007000000700077000077007700777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070707007707070700007700007700770070070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070007007070707700007700007700770070070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070007007000000700077000077007700070070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007770000777777000770000770077000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
4d0100001774100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

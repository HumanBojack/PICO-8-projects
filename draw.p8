pico-8 cartridge // http://www.pico-8.com
version 37
__lua__

local game_objects
local mouse_mode = true

function _init()
	game_objects={}

	-- Enable mouse support
	poke(0x5f2d, 1)

	-- Create the cursor
	cursor=make_game_object("cursor",0,0,3,3,{
		update=function(self)
			-- Mouse controls
			if mouse_mode then
				self.x=stat(32)
				self.y=stat(33)
			end

			-- Keyboard controls
			if not mouse_mode then
				if btn(⬅️) then
					self.x-=1
				elseif btn(➡️) then
					self.x+=1
				end

				if btn(⬆️) then
					self.y-=1
				elseif btn(⬇️) then
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
						color=5,
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
		end
	})

end

function _update()
	local obj
	for obj in all(game_objects) do
		obj:update()
	end

	if btnp(🅾️) then
		mouse_mode = not mouse_mode
	end
end

function _draw()
	cls(7)

	for i = #game_objects, 1, -1 do
		local obj = game_objects[i]
		obj:draw()
	end

	print("mouse_mode (🅾️): "..tostr(mouse_mode), 1, 1, 1)
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
80800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
__sfx__
__music__

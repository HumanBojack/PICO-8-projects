pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init() menu_init() end

function menu_init()
	_update=menu_update
	_draw=menu_draw

  make_menu()
end

function make_menu()
  menu={
    {label="start", action=game_init},
    {label="quit", action=menu_init}
  }
  selected=1
end

function menu_update()
  if (btnp(⬆️)) selected=selected-1
  if (btnp(⬇️)) selected=selected+1
  selected=flr((selected-1)%#menu)+1

  for i=1,#menu do
    if (btnp(🅾️) and i==selected) menu[i].action()
  end
end

function menu_draw()
  cls()
  for i=1,#menu do
    local color = i==selected and 8 or 7
    print(menu[i].label, 64-#menu[i].label*2, 64+i*8, color)
  end
end
-->8
function game_init()
	_update=game_update
	_draw=game_draw

  animation=0
  anim_length=144
end

function game_update()
	if (btnp(🅾️)) gameover_init()

  animation+=1
  animation%=anim_length
end

function game_draw()
  cls()

  -- display the animation frame
  print(animation, 0, 0, 7)


  -- draw the mountains from the spritesheet
  local mtain_w = 24
  local offset = get_offset(mtain_w, 1)
  for x = 0, 127 + mtain_w, mtain_w do
    spr(1, x - offset, 64, 3, 2)
  end
  
  -- draw the trees
  local tree_w = 16
  local offset = get_offset(tree_w, 2)
  for x = 0, 127 + tree_w, tree_w do
    spr(12, x - offset, 90, 2, 2)
  end

  -- draw the ground
  rectfill(0, 120, 127, 127, 3)

  -- draw the road
  local road_w = 8
  local offset = get_offset(road_w, anim_length / road_w)

  for x = 0, 127 + road_w, road_w do
    spr(5, x - offset, 115)
  end

  -- draw the car
  car_x = 50
  car_y = 100
  bump = (animation % anim_length) <= 5 and 1 or 0
  spr(6, car_x, car_y - bump, 4, 2)

  local wheel_r = flr(animation / 4) % 4
  local flip_y = flr(wheel_r / 2) * 2 - 1 == -1
  local wheel_spr = 10 + (flip_y and 1 - wheel_r % 2 or wheel_r % 2)
  
  spr(wheel_spr, car_x + 8, car_y + 14, 0.5, 0.5, false, flip_y)
  spr(wheel_spr, car_x + 25, car_y + 14, 0.5, 0.5, false, flip_y)
end

function get_offset(item_w, repetitions)
  return flr((animation * repetitions) / (anim_length / item_w)) % item_w
end

-->8
function gameover_init()
	_update=gameover_update
	_draw=gameover_draw
end

function gameover_update()
  if (btnp(🅾️)) menu_init()
end

function gameover_draw()
  cls()
  print("game over!")
end
__gfx__
00000000000000000000000000000000000000005555555500000000000000000000000000000000044000000440000000300000000000000000000000000000
00000000000000050000000000000000000000005577775500000000000000000454400000000000476400004674000003330000000000000000000000000000
00700700000000055000000000000000000000005577775500000000000000000454400000000000466400004664000003330000000000000000000000000000
00077000000000055500000000000000000000005555555500000000004454440454400000000000044000000440000033333000000003000000000000000000
00077000000000055500000000000000000000005555555500000000004454440454400000000000000000000000000033333000000033300000000000000000
00700700000000550550000000000000000000006666666600000000088888888888888000000000000000000000000000400003000033300000000000000000
00000000000000500055000000555000000000006666666600000000888667888866678800000000000000000000000000400033300333330000000000000000
00000000000005000005500005505000000000000000000000000008886666788666667880000000000000000000000000400033300333330000000000000000
00000000000005000000055055005500000000000000000000000008856666688566666680000000000000000000000000000333330004000000000000000000
00000000000050000000005550000500000000000000000000000088855555588855555588000000000000000000000000000333330004000000000000000000
00000000000550000000005500000550000000000000000000000088888888888888888888888800000000000000000000000004000004000000000000000000
00000000000500000000000000000550000000000000000000000888888888888558888888888880000000000000000000000004000000000000000000000000
00000000005000000000000000000550000000000000000000008888888888888888888888888886000000000000000000000004000000000000000000000000
00000000055000000000000000000055000000000000000000006688888888888888888888888886000000000000000000000000000000000000000000000000
00000000050000000000000000000005000000000000000000005688000088888888888880000880000000000000000000000000000000000000000000000000
00000000500000000000000000000005000000000000000000000880000008888888888800000080000000000000000000000000000000000000000000000000
__label__
77007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77707770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000000000000000000050000000000000000000000050000000000000000000000050000000000000000000000050000000000000000000000050000
00055000000000000000000000055000000000000000000000055000000000000000000000055000000000000000000000055000000000000000000000055000
00055500000000000000000000055500000000000000000000055500000000000000000000055500000000000000000000055500000000000000000000055500
00055500000000000000000000055500000000000000000000055500000000000000000000055500000000000000000000055500000000000000000000055500
00550550000000000000000000550550000000000000000000550550000000000000000000550550000000000000000000550550000000000000000000550550
00500055000000555000000000500055000000555000000000500055000000555000000000500055000000555000000000500055000000555000000000500055
05000005500005505000000005000005500005505000000005000005500005505000000005000005500005505000000005000005500005505000000005000005
05000000055055005500000005000000055055005500000005000000055055005500000005000000055055005500000005000000055055005500000005000000
50000000005550000500000050000000005550000500000050000000005550000500000050000000005550000500000050000000005550000500000050000000
50000000005500000550000550000000005500000550000550000000005500000550000550000000005500000550000550000000005500000550000550000000
00000000000000000550000500000000000000000550000500000000000000000550000500000000000000000550000500000000000000000550000500000000
00000000000000000550005000000000000000000550005000000000000000000550005000000000000000000550005000000000000000000550005000000000
00000000000000000055055000000000000000000055055000000000000000000055055000000000000000000055055000000000000000000055055000000000
00000000000000000005050000000000000000000005050000000000000000000005050000000000000000000005050000000000000000000005050000000000
00000000000000000005500000000000000000000005500000000000000000000005500000000000000000000005500000000000000000000005500000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000004544000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000004544000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000044544404544000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000044544404544000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000888888888888880000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000008886678888666788000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000088866667886666678800000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000088566666885666666800000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000888555555888555555880000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000888888888888888888888888000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000008888888888885588888888888800000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000088888888888888888888888888860000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066888888888888888888888888860000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000056880440888888888888804408800000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555555555558854674588888888888546745855555555555555555555555555555555555555555555555
55577775555777755557777555577775555777755557777555577775554664755557777555546645555777755557777555577775555777755557777555577775
55577775555777755557777555577775555777755557777555577775555447755557777555574475555777755557777555577775555777755557777555577775
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333

__gff__
0000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--variables
--chaser of dawn
--by arkanyota
--theobosse
--yolwoocle
--raphael
--and elza 
debugvar=nil 
debugvar1=nil 
debugvar2=nil 
debugvar3=nil 
debugvar4=nil 
function makeplayer(pl,x,y)
	cols={7,10,8,11}
	shadowcols={6,9,2,3}
	cucols={1,9,2,3}
	plspr={1,17}
	return 
	{
	p=pl,
	x=x,
	y=y,
	vx=x,
	vy=y,
	sp=plspr[pl+1],
	rot=2,
	rotx=0,
	roty=0,

	alive=true,
	
	--cursor
	cux=0,
	cuy=0,
	vcux=0,
	vcuy=0,
	
	invopen=false,
	invposcur=0,
	invreq={},
	invselect={},

	targ=0,
	mining=false,
	mineprogr=0,
	minecurx=0,
	minecury=0,
	
	col=cols[pl+1],
	scol=shadowcols[pl+1],
	cucol=cucols[pl+1],

	debug=nil,
	debug1=nil,
	debug2=nil,
	debug3=nil,
	debug4=nil,
	debug5=nil,
	debug6=nil,
	}
end
--players
num_players=0

debug="false"
clock=0

--menus
titlescreen=true
playing=false
playerselect=false
gameover=false

--camera
camx=0
camy=0

--world data
planet=1 --(1+)

--hot cold zone
zone={
	x=-25,
	x2=0,
	w=128,
	spd=0.1,
}

--players
pls={
	makeplayer(0,4*8+4,19*8),
	makeplayer(1,10*8+4,19*8),
	--makeplayer(2,4*8+4,27*8),
	--makeplayer(3,10*8+4,27*8),
}

--tile to place when blk break
tilebrk=67

i={
	wood=1,
	stone=2,
	copper=3,
	coal=4,
	amethyst=5,
}
items={
--t: item type,
--s: source block sprite, 
--n: quantity
	{id=1, t=96, s=80, n=1000, name="WOOD"},
	{id=2, t=97, s=81, n=1000, name="STONE"},
	{id=3, t=98, s=82, n=1000, name="COPPER"},
	{id=4, t=99, s=83, n=1000, name="COAL"},
	{id=5, t=100, s=84, n=1000, name="AMETHYST"},
}

function getitem(id)
	item = items[id]
	return {id=item.id,t=item.t,s=item.s,n=item.n,name=item.name}
end

function getloot(id)
--returns loot that comes from block
	return getitem(id).t
end

inv={}
for i=1,5 do
	add(inv, getitem(i))
end
rec={
	pick=1,
	axe=2,
	rocket=3,
}
recipies = {
	--s: sprite
	{	
		name = "PICKAXES",
		unlocked = 1,
		{
			name = "WOODEN PICKAXE", 
			s = 69,
			req={
				{item = items[i.wood], n = 8},
			}
		},
		{
			name = "STONE PICKAXE", 
			s = 70,
			req={
				{item = items[i.wood], n = 12},
				{item = items[i.stone], n = 8},
			}
		},
		{
			name = "COPPER PICKAXE", 
			s = 71,
			req={
				{item = items[i.wood], n = 18},
				{item = items[i.stone], n = 10},
				{item = items[i.copper], n = 6},
			}
		},
		{
			name = "AMETHYST PICKAXE", 
			s = 72,
			req={
				{item = items[i.wood], n = 20},
				{item = items[i.stone], n = 14},
				{item = items[i.copper], n = 10},
				{item = items[i.amethyst], n = 8},
			}
		},
	},
	{
		name = "AXES",
		unlocked = 1,
		{
			name = "WOODEN AXE", 
			s = 85,
			req={
				{item = items[i.wood], n = 8},
			}
		},
		{
			name = "STONE AXE", 
			s = 86,
			req={
				{item = items[i.wood], n = 8},
			}
		},
		{
			name = "COPPER AXE", 
			s = 87,
			req={
				{item = items[i.wood], n = 8},
			}
		},
		{
			name = "AMETHYST AXE", 
			s = 88,
			req={
				{item = items[i.wood], n = 8},
			}
		},
	},
	{
		name = "ROCKETS",
		unlocked = 1,
		{
			name = "WOODEN ROCKET", 
			s = 101,
			req={
				{item = items[i.wood], n = 20},
			}
		},
		{
			name = "STONE ROCKET", 
			s = 102,
			req={
				{item = items[i.wood], n = 20},
			}
		},
		{
			name = "COPPER ROCKET", 
			s = 103,
			req={
				{item = items[i.wood], n = 20},
			}
		},
		{
			name = "AMETHYST ROCKET", 
			s = 104,
			req={
				{item = items[i.wood], n = 20},
			}
		},
		{
			name = "DIAMS ROCKET", 
			s = 105,
			req={
				{item = items[i.wood], n = 20},
			}
		},
	}
}

tools={
	{s=69, maxi=3,n=1,name="PICKAXE"},
	{s=85, maxi=3,n=1,name="AXE"},
	{s=101,maxi=4,n=1,name="ROCKET"},
}

stars={}

-->8
--init update
function _init()
	--map gen
	for x=0,127 do
		for y=0,15 do
			--mset(x,y, rnd({65,65,65,65,65,65,65,65,65,65,65,65,64,66}))
		end
	end

	--gen stars
	for i=0, 127 do
		add(stars,{x=rnd(127), y=rnd(127)})
	end

	--num players
	num_players = #pls
end
---------------------------------------------------------------
---------------------------------------------------------------------
-- UPDATE
---------------------------------------------------------------------
---------------------------------------------------------------------
function _update60()
	if not playing then
		if titlescreen then
			mainmenu()
			playing=true
		elseif gameover then

		end
	else
	
		for p in all(pls) do
			if true or p.alive then
				--death to zone
				--if(mid(zone.x,p.vx+4,zone.x2) != p.vx+4)p.alive=false

				--crafting menu
				if btnp(❎,p.p) then
					if(not playerselect)p.invopen = not p.invopen
				end
				if not p.invopen then
					--movement
					movement(p)
					--mining
					ismineable = false
					p.mining=false
					for i in all(items) do
						if(i.s==mget(p.cux,p.cuy)) then
							ismineable=true
						end
					end
					if ismineable then
						p.mining=btn(🅾️,p.p)
					end
					if p.mining then
						if p.mineprogr==0 then
							p.minecurx=p.cux
							p.minecury=p.cuy
							p.mineprogr+=1
						else 
							if (p.minecurx==p.cux and p.minecury==p.cuy) then
								p.mineprogr+=1
							else
								p.mineprogr=0
							end
						end
						
					else
						p.mineprogr=0
					end
					if p.mineprogr>=100 then
						p.mineprogr=0
						item=mget(p.cux,p.cuy)
						mset(p.cux,p.cuy,tilebrk)
						inv[item-79].n += 1
					end
				else
					--crafting menu navigation
					invnav(p)
				end
				--clamp x and y
				p.x = p.vx % 1024
				if(not playerselect)p.vy = (p.vy+8) % (128+8) -8
				p.y = p.vy 
				--cursor
				p.vcux=((p.vx+4+p.rotx*8.1)\8)
				p.vcuy=((p.vy+4+p.roty*8.1)\8)
				if(not playerselect)p.cuy%=16
				p.cux=p.vcux%128
				p.cuy=p.vcuy

				
			end
		end

		if playerselect then
			--don't move camera or zone when in 
			--player select
			camy= 128
		else
			--zone
			zone.x += zone.spd
			zone.x2 = zone.x + zone.w
			--camera
			local avr_x=0
			for p in all(pls) do
				avr_x += p.vx
			end
			camx=avr_x/#pls-64+4
			camy=0
		end

		--loop around planet
		if -64>camx then
			camx = camx%1024
			zone.x += 1024
			for p in all(pls)do
				p.vx += 1024
			end
		elseif 1023<camx then
			camx = camx%1024
			zone.x -= 1024
			for p in all(pls)do
				p.vx -= 1024
			end
		end

		--death 
		dead_pls = 0
		for p in all(pls) do
			if(not p.alive) dead_pls += 1
		end
		if(dead_pls >= num_players)gameover = true ; playing = false
	end
	camera(camx,camy)
end
-->8

---------------------------------------------------------------------
-- DRAW -------------------------------------------------------------
---------------------------------------------------------------------

function _draw()
	cls()
	if not playing then
		if titlescreen then 
			drawmainmenu()
		elseif gameover then
			printuio("game over lol")
		end
	else
		map()
		--copy ends of map at the edges of the map
		for x=0,15 do
			for y=0,15 do
				sp=mget(x+112,y)
				spr(sp,(x-16)*8,y*8)
				
				sp=mget(x,y)
				spr(sp,(x+128)*8,y*8)
			end
		end
		
		--hot and cold zone
		--optimize if needed
		--hot
		fillp(░)
		rectfill(-127,0,zone.x+16,127,9)
		fillp()
		rectfill(-127,0,zone.x+8,127,10)
		rectfill(-127,0,zone.x,127,7)
		--cold
		fillp(░)
		rectfill(1152,0,zone.x2-16,127,1)
		fillp()
		rectfill(1152,0,zone.x2-8,127,1)
		rectfill(1152,0,zone.x2,127,0)

		--objects render loop
		for p in all(pls) do
			--player
			pal(7,p.col)
			pal(6,p.scol)
			spr(4,p.vx,p.vy)
			pal()
			--cursor
			pal(7,p.cucol)
			spr(16,p.vcux*8,p.vcuy*8+1)
			sprui(17,40,40)
			pal()
			spr(16,p.vcux*8,p.vcuy*8)
		end


		--ui loop
		for p in all(pls) do
			--crafting menu
			if p.invopen then
				drawcraft(p)
			end
			--mining progress bar
			if p.mining then
				rectfill(
				p.vcux*8-1,
				p.vcuy*8-5,
				p.vcux*8+8,
				p.vcuy*8-2,p.cucol)
				rectfill(
				p.vcux*8,
				p.vcuy*8-4,
				p.vcux*8+p.mineprogr*0.08,
				p.vcuy*8-3,7)
			end
		end

		printuio(pls[1].x,0,0)
		printuio(pls[1].y,0,8)
		printuio(pls[1].vx,0,16)
		printuio(pls[1].vy,0,24)
		printuio(pls[1].alive,0,30)
		drawhotbar(5,20,14)
	end
	printuio(debugvar, 100,100)
	printuio(debugvar1, 100,110)
	printuio(debugvar2, 100,120)
end
---------------------------------------------------------------------
-- DRAW -------------------------------------------------------------
---------------------------------------------------------------------

-->8
--functions
function mainmenu()
	camy = (camy-1)%128
	camera(camx,camy)
	if btnp(4) or btnp(5) then
		playing = true
		titlescreen = false
		playerselect = true
	end 

end

function drawmainmenu()
	cls()
	for s in all(stars) do
		pset(s.x, s.y, 5)
		pset(s.x, s.y+128, 5)
	end
	btnprompt = "press 🅾️ or ❎  "
	printo(btnprompt, 64-#btnprompt*2, 90+camy )
	spr(166, 22, 15+camy, 10, 6)
end

function invnav(p)
	--navigation
	
	if(btnp(⬅️, p.p)) p.invposcur -=1
	if(btnp(➡️, p.p)) p.invposcur +=1
	p.invposcur %= #recipies
	p.invselect = recipies[p.invposcur+1]
	p.invreq = p.invselect[p.invselect.unlocked].req
	--debugvar = p.invposcur
	debugvar1 = tools[p.invposcur+1].maxi+1
	debugvar2 = p.invselect.unlocked
	--crafting
	if btnp(🅾️,p.p) then 
		cancraft = true
		if p.invselect.unlocked==tools[p.invposcur+1].maxi+1 then
			cancraft=false
		else
			for i in all(p.invreq) do
				if(inv[i.item.id].n < i.n) cancraft=false
			end
		end
		if cancraft then
			for i in all(p.invreq) do 
				inv[i.item.id].n -= i.n
			end
			p.invselect.unlocked += 1 
		end
	end
end

function drawcraft(p)
	intmenu = 0
	offsety = 9
	if(p.vy>72) offsety = -45
	recipe = recipies[p.invposcur+1]
	--rectangle
	x1 = p.vx-2
	y1 = p.vy+offsety
	x2 = p.vx+9 
	y2 = p.vy+offsety+11
	line(x1, y2+1, x2, y2+1, p.cucol)
	rectfill(x1, y1, x2, y2, 6)
	rect(x1, y1, x2, y2, p.col)
	--result
	spr(recipe[recipe.unlocked].s, x1+2, y1+2)
	--triangles
	pal(1, p.cucol)
	spr(107, x1+14, y1+3)
	spr(107, x1-10, y1+3, 1,1,1)
	pal()

	--required items
	local i = 1
	local columns = 3
	local x = 0
	local y = 0
	printo("REQUIRED:", x1-10, y2+3, p.cucol)
	for r in all(p.invreq) do
		uy = flr(iy)
		x3 = x2+ (15*x)-23
		y3 = y2+(12*flr(y))+11
		x4 = x3+7
		y4 = y3+7

		local hasallitems = false
		if(inv[r.item.id].n >= r.n) hasallitems = true
		local squarecolor = hasallitems and 3 or p.scol
		rectfill(x3-1, y3-1, x4+1, y4+1, squarecolor)
		spr(r.item.t, x3, y3)
		--check mark
		local textcol = hasallitems and 13 or 7
		printo(r.n, x3+6, y3+5, p.cucol, textcol)
		x=(x+1)%columns
		if(i%columns==0) y+=1
		i+=1
	end
end

function movecam()
	
end

function solid(px,py)	
	--if(px-1<camx or camx+129<=px)return true 
  	px=px\8%128
  	py=py\8
	return fget(mget(px,py))==0x1 or fget(mget(px,py))==0x3
end

function movement(p)
	if btn(⬅️,p.p) then 
 	 	if not (solid(p.x,p.y))	and 
 		not (solid(p.x,p.y+7))	then 
 	 		p.vx-=1
 		end
		p.rot=3
		p.rotx=-1
		p.roty=0
 	end
 	if btn(➡️,p.p) then
		if not (solid(p.x+7,p.y)) and 
 		not (solid(p.x+7,p.y+7)) then
			p.vx+=1
		end
		p.rot=1
		p.rotx=1
		p.roty=0
 	end
 	if btn(⬆️,p.p) then
   		if not (solid(p.x+1,p.y-1))	and 
 		not (solid(p.x+6,p.y-1))	then
   			p.vy-=1
   		end
		p.rot=0
		p.rotx=0
		p.roty=-1
 	end
 	if btn(⬇️,p.p) then
  	 	if not (solid(p.x+1,p.y+8))	and 
 		not (solid(p.x+6,p.y+8))	then
  	 		p.vy+=1
   		end
		p.rot=2
		p.rotx=0
		p.roty=1
 	end
end

function drawhotbar(x,y,space)
	posy = y
	for i in all(inv) do
--		--fill
--		rectfill(camx+x-1,camy+posy-1,
--		camx+x+8,camy+posy+8,7)
--		sprui(i.t,x, posy)
--		--outline
--		rect(camx+x-2,camy+posy-2,
--		camx+x+9,camy+posy+9,1)
		--sprite
		sprui(i.t,x, posy)
		--quantity
		printuio(i.n, x+6,posy+4)

		posy += space
	end
end
-->8
--ui
function printo(txt,x,y,col1,col2)
	if(not col1)col1 = 1
	if(not col2)col2 = 7
	for ix=-1,1 do
		for iy=-1,1 do
			print(txt,ix+x,iy+y,col1)
		end
	end
	print(txt,x,y,col2)
	cursor()
end

function spro(sp,x,y,col)
	col = col or 1
	for i=0,15 do 
		pal(i,col)
	end
	for ix=-1,1 do
		for iy=-1,1 do
			spr(sp,ix+x,iy+y)
		end
	end
	pal()
	spr(sp,x,y)
end

function printuio(txt,x,y,col1,col2)
	x=x or peek(0x5f26)
	y=y or peek(0x5f27)
	printo(txt,x+camx,y+camy,col1,col2)
end

function sprui(sp,x,y)
	spr(sp,x+camx,y+camy)
end
__gfx__
00000000066666600666666006666660077777700777777007777770077777700777777007777770077777700787997000878000000800000000000000000000
00000000677775566777755667777556765555677655556776555567777655557776555555556777555567777685599700898980008080000008890000000000
00700700777775577777755777777557751111577511115775111157776511117765111111115677111156777881199908881988008899000088908000000000
00077000777775777777757777777577717111177171111771711117776171117761711111171677111716777881191908911898089999000089898000000000
00077000677775766777757667777576711111177111111771111117777111117771111111111777111117778881111988881198898aa980089aa98000080000
00700700076666600766666007666660077777700777777007777770077777700777777007777770077777708788979089888798899aa980089aa98000880000
00000000067777606077770606777760067c8760607c8706067c87600677c8606077c806068c7760608c77060888896008999988089aa980089a980000898000
000000000060060000600000000006000060060000000600006000000060060006000060006006000600006000800900008888000088880000898800008a8000
77000077000000000000000000000000000000000000000000000000000000000000000000000000000000000cc777700ccc7cc00cccccc0c1cc771ccccc77cc
7000000700000000000000000000000000000000000000000000000000000000000000000000000000000000ccc55567cccc5567cccc75c71cc77cc1ccc77ccc
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc11115ccccc11ccc117111c1c77ccc1cc77cccc
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000717111ccccc11ccccccc1ccc1cccccc1cccccccc
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000071111ccc7111cccc777ccc777777777777777777
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc777cc0ccccccccccccccccc1cccc1ccccccccc
70000007000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc8760cccccc60ccc7ccccc117711cccc77ccc
770000770000000000000000000000000000000000000000000000000000000000000000000000000000000000c006000ccc06000c7c06c0cc77c1cccc77cccc
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
eeeeeeeeeeeeeeeeeeeeeeeeee88eeeeeeeceeee0044430000555f0000999f0000eeef0000400d10e1eeeee8eeeeeeeee1eeeee8eeeeeeeee1eeeee8eeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeee88e8e8eeeeeeeee0222432001115f1008889f8002228f200442ddd1e11eeee88eeeeeeee11eee898eeeeeeee11eee898eeeeeee
e88eee88eeeeeeeeee8e8eeee8e888eeeeceecce000033330000ffff0000ffff0000ffff44201d11e118ee898eeeeeeee118ee998eeeeeeee118ee998eeeeeee
e888e888eeeeeeeeee8e8e8e8e888e88ecc8e88e00044342000ddf5100055f9800099f8202000110ed88ee898eeeeeeeed18e89aeeeeeeeeed18ee8a98eeeeee
ee88e88eeeeeeeeeeee888eee88e888eee88e8ee0044204200dd5051005510980099808209990010ed89dd9a8eeeeeeeedd9d8999eeeeeeeedd9dd8999eeeeee
eeeeeeeeeeeeeeeeeeee8eee88e888e8e88eeece044200420dd5005105510098099800829a980111dd89ddd9ddd5eeeedd89dd998dd5eeeedd898dd99dd5eeee
eeeeeeeeeeeeeeeeeeeeeeeee8888e8eecceeccc44200020dd500010551000809980002099882210d589dd111dd55eeed5899d111dd55eeed5998d188dd55eee
eeeeeeeeeeeeeeeeeeeeeeeeee88e8eeeceeecee42000000d5000000510000009800000098800220d8898dd11188ddeed89a9dd11185ddeed89a8dd11185ddee
ee3333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000440000005500000099000000ee0000000000589981dd5898d555589a91dd589dd55558aa81dd5dadd555
e333333eeddd1eeeeddd1eeeeedd11eeeddd1eee000444400005555000099990000e8880000000005899812559a855ee55898125589955ee55995125589555ee
e333333edddddd1edd998d1eed110d1eddee281e000034420000f5510000f9980000f882000000005558511558a552225555511559a952225588511558855222
e133331edddddd11d998dd11d110dd11dee2881100033333000fffff000fffff000fffff0000000011555512555222ee1155551259a822ee11555512555222ee
e111111edddd1d11d98d1981d00d1101d228ee210044342200ddf51100ddf9880099f822000000001111222222222eee1111222222222eee1111222222222eee
e111111eddd1dd11ddd19981ddd11101d882ee21044202200dd501100dd508800998022000000000111222222222eeee111222222222eeee111222222222eeee
ee1111eeddddd111dddd9811dddd1011dddd121144200000dd500000dd50000099800000000000001222eeeeeeeeeeee1222eeeeeeeeeeee1222eeeeeeeeeeee
eee42eeee111111ee111111ee111111ee111111e42000000d5000000d50000009800000000000000222eeeeeeeeeeeee222eeeeeeeeeeeee222eeeeeeeeeeeee
00000200000000000099999000011000000e800000044000000dd000000aa0000008800000066000ee2222ee700000007777777715555555d44444d600c77f00
0000444000dd1d0009aa9998001121100eee88000044420000ddd50000aa990000882200006677002211112e77000000666666665000000d422222460ceefff0
000424420ddddd109aa9999801122111eeee888e00424200005ddd0000a9990000882200006777002122212277700000777777775000000d4242424688eee888
00424420ddddd1109a99998811221112eeee88e20342443005dd5d50089999800e2222e00c6777c02111122177100000777777775000000d4242424688ee8888
04444200d1ddd110999999802121112188ee82822234432255d5dd5588a99988ee8822eecc7777cc1222221171000000666666665000000d42424246288eeeef
44242000dd1d11109999880022111211088822802234432255ddd55588999988ee2222eecc6777cc1111111110000000777777775000000dd44444d6222eefff
02420000011111008998800002211110ee8822002024440250dd5d0580999908e022220ec077770c1111111100000000555555555000000d5222225602222ff0
0020000000000000088800000022110002282000200000025000000580000008e000000ec000000ce11111ee00000000555555555dddddd62222222600222700
22222222bbbbbbbb6666666655555555555555556dddddddddddddd60099a8000089a900089a9800000000000022220000000000008888000003b00000cff100
22222222bbbbbbbb666666665dddddd55dddddd5dddddddddddddddd0899a9800899a980089a998000000000028888200777777008888880083bbb000ccfff10
33333333bbbbbbbb666666665d5555d55d5555d5ddccccccccccccdd08899980089998800889a980000000002811118e07777771800008088a8bbb00ddccdddd
bbbbbbbbbbbbbbbb666666665dddddd55dddddd5ddcddddddddddcdd00899880088998800089998000000000281ee18e00077111808008080831b100dddcfdfd
bbbbbbbbbbbbbbbb666666665555555555555555ddcddddddddddcdd008998000088980000898900000000002888888e000771008000808800eebe002ddfffff
bbbbbbbbbbbbbbbb666666665dddddd511111111ddcddccccccddcdd000880000088980000898800000000002822228e0007710080808088003bbb00222fffff
bbbbbbbbbbbbbbbb666666665d5555d511111111ddcddcddddcddcdd000880000008880000088000000000000e8888e00007710008888880044444400222fff0
bbbbbbbbbbbbbbbb666666665dddddd511111111ddcddccccccddcdd0000800000008000000800000000000000eeee0000001100008888000022220000222f00
0000000000000000000000000000000000000000ddcddddddddddcdd000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ddcddddddddddcdd000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ddccccccccccccdd000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000dddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005dddddddddddddd5000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000d55555555555555d000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005555555555555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000005555555555555555000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000001111111100011111100111100011100111111100011111110111111101111111100000
0000000000000000000000000000000000000000000000000000000011cccccccc101cccccc11cccc101ccc11ccccccc101ccccccc1ccccccc1cccccccc10000
00000000000000000000000000000000000000000000000000000001cc9f79999ac1c777777cc7777c1c777cc7777777c1c7777777c7777777c77777777c1000
0000000000000000000000000000000000000000000000000000001ceeeee7aaa9ac7eeeeee7c7ee7c1c7e7c7eeeeeee7c7eeeeeee77eeeeee77eeeeeee7c100
000000000000000000000000000000000000000000000000000001cc22eeee7a999a7ee777ee77ee7c1c7e77eeeeeeee77eeeeeeee77ee7777c7ee7777ee7c10
00000000000000000000000000000000000000000000000000001c2222222eee9999ee7ccc7777ee7c1c7e77ee77777e77eee777ee77ee7cccc7ee7ccc7e7c10
00000000000000000000000000000000000000000000000000001c9aaa77aa9999999e7cccccc7ee7c1c7e77ee7ccc7e77eeeccc77c7ee7cccc7ee7ccc7e7c10
00000000000000000000000000000000000000000000000000001c9aaa77a99999999e7cccccc7ee7ccc7e77ee7ccc7e77eee777ccc7ee777cc7ee7ccc7e7c10
00000000000000000000000000000000000000000000000000001c9aa777a99999999e7cccccc7ee77777e77ee77777e77eeeeee77c7eeeee7c7ee7ccc7e7c10
00000000000000000000000000000000000000000000000000001c9aa777a99999eef77cccccc7eeeeeeee77eeeeeeee7c77eeeeee77ee777cc7ee7777ee7c10
00000000000000000000000000000000000000000000000000001c9aa777a999eeeeee7cccccc78877777877887777787ccc77788877887cccc788888887c100
00000000000000000000000000000000000000000000000000001c9aa777a9922eeeeef7c77777887ccc7877887ccc787777ccc78877887cccc78888887c1000
00666600008888001022220100000000000000000000000000001c9aaa77a92222222eeef78877887c1c7877887ccc787788777888778877777788778887c100
06666660088828801222121100000000000000000000000000001c9aaaaaaa9999999a788887c7887c1c7877887ccc787788888887c788888887887c78887c10
006006600282088001210210000000000000000000000000000001c9aaaaaaa99999acc7777cc7777c1c7777777ccc777c7777777cc777777777777c77777c10
0060066000800880002002200000000000000000000000000000001c9aaaaaaa999ac11cccc11cccc11c77777777ccc77777777cc11cccccccccccc1ccccc100
06666600088888000222220000000000000000000000000000000001c9aaaaaaa9ac10011110011111c7eeeeeeee7cc7eeeeeee7c10111111111111011111000
056500000282000001210000000000000000000000000000000000001c9999999ac10000000000001c7eee77777ee7c7ee77777c100000000000000000000000
0000000000000000000000000000000000000000000000000000000001cccccccc100000000000001c7ee7ccccc7e7c7ee7cccc1000000000000000000000000
000000000000000000000000000000000000000000000000000000000011111111000000000000001c7ee7ccccc7e7c7ee7c1110000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000001c7ee7ccccc7e7c7ee7ccc10000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000001c7ee7ccccc7e7c7ee7777c1000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000001c7ee7ccccc7e7c7eeeeee7c100000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000001c7887ccccc787c7887777c1000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000001c7887ccccc787c7887ccc10000000000001111110000000
000000000000000000000000000000000000000000000000000000000000000000000000000000001c788877777887c7887c110000000000011ce7ccc1100000
0000000000000000000000000000000000000000000000000000000000000000111111111100011111c7888888887cc7887c1111110001111eeeeeeedcc10000
0000000000000000000000000000000000000000000000000000000000000001cccccccccc1001cccccc77777777ccc7777ccccccc101c22eeeeeeee7ddc1000
0000000000000000000000000000000000000000000000000000000000000001c777777777c11c7777777c7777cccccccc77777777c1c722222222eeeeddc100
0000000000000000000000000000000000000000000000000000000000000001c7eeeeeeee7cc7eeeeeee77ee7cc7777cc7ee77ee7c1c7e666666d66d6dddc10
0000000000000000000000000000000000000000000000000000000000000001c7ee77777ee77eeeeeeee77ee7cc7ee7cc7ee77ee7c1c7e6666666dd666d5c10
0000000000000000000000000000000000000000000000000000000000000001c7ee7cccc7e77ee77777e77ee7cc7ee7cc7ee77eee7cc7666dd6666eeeeef7c1
0000000000000000000000000000000000000000000000000000000000000001c7ee7cccc7e77ee7ccc7e77ee7c7eeee7c7ee77eeee7c766d66d6622eeeeef71
0000000000000000000000000000000000000000000000000000000000000001c7ee7cccc7e77ee7ccc7e77ee7c7eeee7c7ee77eeeee7766d66d622222222ee7
0000000000000000000000000000000000000000000000000000000000000001c7ee7cccc7e77ee77777e77eee7eeeeee7eee77eeeeee7666dd66666d665ddc1
0000000000000000000000000000000000000000000000000000000000000001c7ee7cccc7e77eeeeeeee7c7ee7eeeeee7ee7c7ee7eeee6d6666666d666d5dc1
0000000000000000000000000000000000000000000000000000000000000001c788777778877887777787c78888877888887c78877888d6d666666d6ddd5dc1
0000000000000000000000000000000000000000000000000000000000000001c788888888877887ccc787c78888877888887c7887c7888d66666666ddd5dc10
0000000000000000000000000000000000000000000000000000000000000001c788888888877887c1c787c788887cc788887c7887cc7886666dd66dd55ddc10
0000000000000000000000000000000000000000000000000000000000000001c7888888887c7887c1c787cc78887cc78887cc7887c1c788d6d6d5ddddddc100
0000000000000000000000000000000000000000000000000000000000000001c777777777cc7777c1c777cc77777cc77777cc7777c1c7777d5dd5dddddc1000
0000000000000000000000000000000000000000000000000000000000000001cccccccccc11ccccc1cccc11ccccc11ccccc11ccccc1ccccccc55ddddcc10000
0000000000000000000000000000000000000000000000000000000000000000111111111100111110111100111110011111001111101111111ccccccc100000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030303030300000000000000000000000000000000000000000000000100030000000001010000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4341414141414141414141414142414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141404141414141414141414141414141414141414141414142414141414141414141414141414141414141414141414141414141414141414144
4341414041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424141414141414141504144
4341414141414141414141414141504141414140414141414141404141414141414141414140414141414141414141414141414141414141414141414142414141414141414141414141414141414141414141414241414141404141414141414141414141404241414141414141414141414141414141414142414151504144
4341415050505050504141414141414141414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414241414141414141414141414141414141414141414141414241414141414141414141414141504144
4341415041424041404141414141414141414141414141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414241414141414141414141414141414141414141414141414141414141414144
4341415041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414142414141414141414241404141414141424141414141414141414141414141414141414141414141414141414141424141414141414241414141414141414141414141424141415041414144
4341415041414141414141414141404150414141414141414141414141414141414141414141414140404141414141414141414141414141414141414141414141414141414141414241414041414241414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414144
4341415041414141414150414142414141414141414241414141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424141404141414141414141414144
4341414141414141414141414141415041414041504141414141414141414140414141414142414141414141414141414141414141414141414141414242414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141514141424144
4341414141414141414141414141414141414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414241414141414141424141515050414144
4341414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414142414140414141414141414141414141414141414141414141414141414141414141414141414141414141414142414141414144
4341414141414141414141414041414141414141414141414141414141414141414141414141404141414141414241414141414141414141414141414141414141414141414142414141414141414141414141414141414141414142414241414141414141414141414141414141414141414141424141414141414150504244
4341414141414141414141414141414141414141414141414041414141414141414141414141414141414141414241414141414141414141414141414141404141414141414141414141414141414141414241414141414141414141414241414141414141414141414141414141414141414141414141414141414150504144
4341414041414141414141414141414141414141414141424141414141414141414141414141414141414141414141414141404141424141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414041424141414141414241414141414141414141414141524141414144
4341414141414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141404041414142414141414141414141414141414141414141414141414141414141414141414141414142414141414144
4341414141414150505050505041414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414142414141414141414141414141414144
0000000000737272727273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737474746c6c6c6c74747473000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737272727272727272727273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737275767272727275767273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737285867272727285867273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737272727272727272727273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000735072726d6d6d6d72725073000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000735072726d6d6d6d72725073000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000735072726d6d6d6d72725073000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000735072726d6d6d6d72725073000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737272727272727272727273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737275767272727275767273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737285867272727285867273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000737272727250507272727273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000747474747474747474747474000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

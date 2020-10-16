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
	sp=plspr[pl+1],
	rot=2,
	rotx=0,
	roty=0,
	
	cux=0,
	cuy=0,
	
	targ=0,
	mining=false,
	mineprogr=0,
	
	col=cols[pl+1],
	scol=shadowcols[pl+1],
	cucol=cucols[pl+1],
	}
end

debug="false"
clock=0

--menus
playing=true

--camera
camx=0
camy=0

--world data
planet=1 --(1+)

--hot cold zone
zone={
	x=0,
	w=64,
	x2=0,
}

--players
pls={
	makeplayer(0,64,30),
	makeplayer(1,64,64),
--	makeplayer(2,64,94),
--	makeplayer(3,74,64),
}

--tile to place when blk break
tilebrk=67

inv={
//t: item type
//s: source blck, 
//n: quantity
	{t=96, s=80, n=0, name="WOOD"},
	{t=97, s=81, n=0, name="STON"},
	{t=98, s=82, n=0, name="COPP"},
	{t=99, s=83, n=0, name="COAL"},
	{t=100, s=84, n=0, name="AMET"},
}
-->8
--init update
function _init()

end

function _update60()
	if playing then
	
		for p in all(pls) do
			--movement
			movement(p)
			
			--mining
			p.mining=btn(🅾️,p.p)
			if p.mining then		
				p.mineprogr+=1
			else
				p.mineprogr=0
			end
			if p.mineprogr>=100 then
				p.mineprogr=0
				item=mget(p.cux,p.cuy)
				mset(p.cux,p.cuy,tilebrk)
				inv[item-79].n += 1
			end
			
			--cursor
			p.cux=(p.x+4+p.rotx*8.1)\8
			p.cuy=(p.y+4+p.roty*8.1)\8
		end
		--camera
		movecam()
	end
end
-->8
function _draw()
	cls()
	map()
	--loop planet
	for x=0,15 do
		for y=0,15 do
			sp=mget(x+112,y)
			spr(sp,(x-16)*8,y*8)
			
			sp=mget(x,y)
			spr(sp,(x+128)*8,y*8)
		end
	end
	
	for p in all(pls) do
		--player
		pal(7,p.col)
		pal(6,p.scol)
		spr(4,p.x,p.y)
		pal()
		--cursor
		pal(7,p.cucol)
		spr(16,p.cux*8,p.cuy*8+1)
		sprui(17,40,40)
		pal()
		spr(16,p.cux*8,p.cuy*8)
		--mining prograss bar
		if p.mining then
			rectfill(
			p.cux*8-1,
			p.cuy*8-5,
			p.cux*8+8,
			p.cuy*8-2,p.cucol)
			rectfill(
			p.cux*8,
			p.cuy*8-4,
			p.cux*8+p.mineprogr*0.08,
			p.cuy*8-3,7)
		end
	end

	print("")
	printuio(pls[1].cux,0,0)
	printuio(pls[1].cuy,0,8)
	drawhotbar(5,20,14)
end
-->8
--functions
function movecam()
	local avr_x=0
	for p in all(pls) do
		avr_x += p.x
	end
	camx=avr_x/#pls-64+4
	camy=0--change if needed
	camera(camx,camy)
end

function solid(px,py)
  px/=8
  py/=8
	 return fget(mget(px,py))==0x1
	 or fget(mget(px,py))==0x3
end

function movement(p)
	if btn(⬅️,p.p) then 
 	 if not (solid(p.x,p.y))			and 
 			  not (solid(p.x,p.y+7))	then 
 	 p.x-=1
 	 end
 	p.rot=3
 	p.rotx=-1
 	p.roty=0
 end
 if btn(➡️,p.p) then
   if not (solid(p.x+7,p.y))			and 
 			  not (solid(p.x+7,p.y+7))	then
   p.x+=1
   end
 	p.rot=1
 	p.rotx=1
 	p.roty=0
 end
 if btn(⬆️,p.p) then
   if not (solid(p.x+1,p.y-1))	and 
 			  not (solid(p.x+6,p.y-1))	then
   p.y-=1
   end
  p.rot=0
 	p.rotx=0
 	p.roty=-1
 end
 if btn(⬇️,p.p) then
   if not (solid(p.x+1,p.y+8))	and 
 			  not (solid(p.x+6,p.y+8))	then
   p.y+=1
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
	col1 = col1 or 1
	col2 = col2 or 7
	for ix=-1,1 do
		for iy=-1,1 do
			print(txt,ix+x,iy+y,col1)
		end
	end
	print(txt,x,y,col2)
--	cursor(peek(0x5f26),
--								peek(0x5f27)+8)
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
00000200000000000099999000011000000e800000044000000dd000000aa0000008800000066000ee2222ee0000000000000000000000000000000000c77f00
0000444000dd1d0009aa9998001121100eee88000044420000ddd50000aa990000882200006677002211112e000000000000000000000000000000000ceefff0
000424420ddddd109aa9999801122111eeee888e00424200005ddd0000a999000088220000677700212221220000000000000000000000000000000088eee888
00424420ddddd1109a99998811221112eeee88e20342443005dd5d50089999800e2222e00c6777c0211112210000000000000000000000000000000088ee8888
04444200d1ddd110999999802121112188ee82822234432255d5dd5588a99988ee8822eecc7777cc1222221100000000000000000000000000000000288eeeef
44242000dd1d11109999880022111211088822802234432255ddd55588999988ee2222eecc6777cc1111111100000000000000000000000000000000222eefff
02420000011111008998800002211110ee8822002024440250dd5d0580999908e022220ec077770c111111110000000000000000000000000000000002222ff0
0020000000000000088800000022110002282000200000025000000580000008e000000ec000000ce11111ee0000000000000000000000000000000000222700
22222222bbbbbbbb00000000000000000000000000000000000000000099a8000089a900089a9800000000000022220000000000008888000003b00000cff100
22222222bbbbbbbb00000000000000000000000000000000000000000899a9800899a980089a998000000000028888200777777008888880083bbb000ccfff10
33333333bbbbbbbb000000000000000000000000000000000000000008899980089998800889a980000000002811118e07777771800008088a8bbb00ddccdddd
bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000899880088998800089998000000000281ee18e00077111808008080831b100dddcfdfd
bbbbbbbbbbbbbbbb0111011100011001111011110111101110001110008998000088980000898900000000002888888e000771008000808800eebe002ddfffff
bbbbbbbbbbbbbbbb1100011010110101100001100011001101011000000880000088980000898800000000002822228e0007710080808088003bbb00222fffff
bbbbbbbbbbbbbbbb1100011100111101110001100011001101011010000880000008880000088000000000000e8888e00007710008888880044444400222fff0
bbbbbbbbbbbbbbbb01110110101101011000011001111011010011100000800000008000000800000000000000eeee0000001100008888000022220000222f00
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555005500005500550500000888008800008800880800000555005555055550555500000eee00eeee0eeee0eeee0000000000000000000000000000000000000
550505500055050550500000880808800088080880800000550500550055000550000000ee0e00ee00ee000ee000000000000000000000000000000000000000
555005500055550055000000888008800088880088000000550500550055500555000000ee0e00ee00eee00eee00000000000000000000000000000000000000
550005555055050055000000880008888088080088000000555005555055000550000000eee00eeee0ee000ee000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000888888888888888888800000000000000000000000000000eeeeeeeeeeeeeeeeee00000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555505505055550055000000cccc0cc0c0cccc00cc000000555005550000000000000000aaa00aaa000000000000000000000000000000000000000000000000
0550055050055005505000000cc00cc0c00cc00cc0c0000000550550500000000000000000aa0aa0a00000000000000000000000000000000000000000000000
0550055050055005505000000cc00cc0c00cc00cc0c00000550005550000000000000000aa000aaa000000000000cccccccccccccccccccccccccccccccc0000
0550005500055000550000000cc000cc000cc000cc000000555505500000000000000000aaaa0aa0000000000000c77777aaaa9999ee88e8e2221111111c0000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c77777aaaa9999e8e8e8e2221111111c0000
000000000000000000000000ccccccccccccccccccc00000000000000000000000000000aaaaaaaaa00000000000cccccccccccccccccccccccccccccccc0000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55550550505555055050000099990990909999099090000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55000555500550055050000099000999900990099090000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00550555000550050550000000990999000990090990000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55550550505555050550000099990990909999090990000000000000001111111100011111100111100011100111111100011111110111111101111111100000
0000000000000000000000000000000000000000000000000000000011cccccccc101cccccc11cccc101ccc11ccccccc101ccccccc1ccccccc1cccccccc10000
00000000000000000000000099999999999999999990000000000001cc9f79999ac1c777777cc7777c1c777cc7777777c1c7777777c7777777c77777777c1000
0000000000000000000000000000000000000000000000000000001ceeeee7aaa9ac7eeeeee7c7ee7c1c7e7c7eeeeeee7c7eeeeeee77eeeeee77eeeeeee7c100
000000000000000000000000000000000000000000000000000001cc22eeee7a999a7ee777ee77ee7c1c7e77eeeeeeee77eeeeeeee77ee7777c7ee7777ee7c10
555505505055550555500000bbbb0bb0b0bbbb0bbbb0000000001c2222222eee9999ee7ccc7777ee7c1c7e77ee77777e77eee777ee77ee7cccc7ee7ccc7e7c10
0550055050550005505000000bb00bb0b0bb000bb0b0000000001c9aaa77aa9999999e7cccccc7ee7c1c7e77ee7ccc7e77eeeccc77c7ee7cccc7ee7ccc7e7c10
0550050550555005505000000bb00b0bb0bbb00bb0b0000000001c9aaa77a99999999e7cccccc7ee7ccc7e77ee7ccc7e77eee777ccc7ee777cc7ee7ccc7e7c10
555505055055000555500000bbbb0b0bb0bb000bbbb0000000001c9aa777a99999999e7cccccc7ee77777e77ee77777e77eeeeee77c7eeeee7c7ee7ccc7e7c10
00000000000000000000000000000000000000000000000000001c9aa777a99999eef77cccccc7eeeeeeee77eeeeeeee7c77eeeeee77ee777cc7ee7777ee7c10
000000000000000000000000bbbbbbbbbbbbbbbbbbb0000000001c9aa777a999eeeeee7cccccc78877777877887777787ccc77788877887cccc788888887c100
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4341414141414141414141414142414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141404141414141414141414141414141414141414141414142414141414141414141414141414141414141414141414141414141414141414144
4341414041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424141414141414141414144
4341414141414141414141414141504141414140414141414141404141414141414141414140414141414141414141414141414141414141414141414142414141414141414141414141414141414141414141414241414141404141414141414141414141404241414141414141414141414141414141414142414141414144
4341415050505050504141414141414141414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414241414141414141414141414141414141414141414141414241414141414141414141414141414144
4341415041424041404141414141414141414141414141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414241414141414141414141414141414141414141414141414141414141414144
4341415041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414142414141414141414241404141414141424141414141414141414141414141414141414141414141414141414141424141414141414241414141414141414141414141424141414141414144
4341415041414141414141414141404150414141414141414141414141414141414141414141414140404141414141414141414141414141414141414141414141414141414141414241414041414241414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414144
4341415041414141414150414142414141414141414241414141414141414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424141404141414141414141414144
4341414141414141414141414141415041414041504141414141414141414140414141414142414141414141414141414141414141414141414141414242414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424144
4341414141414141414141414141414141414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414241414141414141424141414141414144
4341414141414140414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414142414140414141414141414141414141414141414141414141414141414141414141414141414141414141414142414141414144
4341414141414141414141414041414141414141414141414141414141414141414141414141404141414141414241414141414141414141414141414141414141414141414142414141414141414141414141414141414141414142414241414141414141414141414141414141414141414141424141414141414141414244
4341414141414141414141414141414141414141414141414041414141414141414141414141414141414141414241414141414141414141414141414141404141414141414141414141414141414141414241414141414141414141414241414141414141414141414141414141414141414141414141414141414141414144
4341414041414141414141414141414141414141414141424141414141414141414141414141414141414141414141414141404141424141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414041424141414141414241414141414141414141414141414141414144
4341414141414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141404041414142414141414141414141414141414141414141414141414141414141414141414141414142414141414144
4341414141414141414141414141414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414142414141414141414141414141414144
4341414141414141414141414141414141414141414141414141414141414041414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141414141424141414141414141414241414141414141424141414141414141414141414144

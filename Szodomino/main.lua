--[[
Ami eddig megvan:
	Egy függvény ami megmondja két szóról hogy mennyi a közös tartalmuk, mi az, és hogy milyen sorrendben kell lenniük.
	Egy ciklus ami végig megy az összesszón és az összes szóval (magát leszámítva) meg
]]

io.stdout:setvbuf("no") -- azonnali print a consolba

 --beolvasás: minden sortban egy szót, és azt felbontom kerakterekre.
szavak = {}
for line in io.lines("aaa.txt") do
	szo = {}
	line:gsub(".",function(c) table.insert(szo,c) end) -- karakterekre bontja a szót
	table.insert(szavak,szo) -- a szavakhoz adja a szót
end


--[[ kiíratás
for sz,szo in ipairs(szavak) do
	for c,char in ipairs(szo) do
		print(sz,c,char)
	end
	print()
end]]

local function egyezesS(s1,s2) -- egy oldalról megvizsgálja a ez egyezést

	local max = 1
	local megyezo = ""
	local mpos = {kezdo=0,vegzo=0} --vedelem a szó közepe miatt
		

	local jelenlegi = 1
	local jegyezo = ""

	local c = 1
	while c<=#s1 do --végig iterál az első szón és rápróbálja a második szót az elejétől
		if s1[c]==s2[jelenlegi] then 
			--print(c,s1[c],jelenlegi,s2[jelenlegi],"+")
			jelenlegi=jelenlegi+1
			jegyezo=jegyezo..s1[c]
		else
			--print(c,s1[c],jelenlegi,s2[jelenlegi],"-")
			if jelenlegi>max then  -- maximum mentés
				max=jelenlegi 
				megyezo=jegyezo
				mpos.kezdo=(c-1)-(jelenlegi-2)
				mpos.vegzo=(c-1)
			end
			if jelenlegi>1 then c=c-1 end
			jelenlegi=1
			jegyezo=""
		end
		c=c+1
	end

	if jelenlegi>max then --maximum mentés
		max=jelenlegi 
		megyezo=jegyezo
		mpos.kezdo=#s1-(jelenlegi-2)
		mpos.vegzo=#s1 
	end

	max = max-1

	if max==#s2 and not (mpos.kezdo==1 or mpos.vegzo==#s1) then 
		max = 0 
		megyezo = "" 
	end

	return max, megyezo
end

function egyezes(s1,s2) -- kétoldalról megvizsgálja az egyezést és hogy meg kell-e fordítani (kimenet: EgyezésHossza, EgyezőKarakterek, MegKellEFordítani)
	local m1,m2
	local e1,e2
	m1,e1 = egyezesS(s1,s2)
	m2,e2 = egyezesS(s2,s1)
	if m1>=m2 then return m1,e1,false end -- nem kell megfordítani
	return m2,e2,true -- meg kell fordítani
end

--print(egyezes(szavak[1],szavak[2]))

for i,s1 in ipairs(szavak) do
	for j,s2 in ipairs(szavak) do
		if i~=j then
			print(i,j,"|",egyezes(s1,s2))
		end
	end
end

-- love-ből kilépés (csak a lua kell)
love.event.quit()
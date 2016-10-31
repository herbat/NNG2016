--[[
Ami eddig megvan:
	Egy függvény ami megmondja két szóról hogy mennyi a közös tartalmuk, mi az, és hogy milyen sorrendben kell lenniük.
	Egy ciklus ami végig megy az összes szón és az összes szóval (magát leszámítva) megvizsgálja az egyezést, és kiírja.

Ami kell:
	
	Egy algoritmus a ami fába gyüjti a potenciális sorrend alapján a szavakat.

Ismert hibák:
	Nincs
]]

io.stdout:setvbuf("no") -- azonnali print a consolba

 --beolvasás: minden sortban egy szót, és azt felbontom kerakterekre.
szavak = {}
for line in io.lines("aaa.txt") do
	szo = {}
	line:gsub(".",function(c) table.insert(szo,c) end) -- karakterekre bontja a szót
	table.insert(szavak,{szo=szo,egyezes={}}) -- a szavakhoz adja a szót
end

local function ket_szo_egyezese_seged(s1,s2) -- egy oldalról megvizsgálja a ez egyezést

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

	local elolrol = (mpos.kezdo==1)
	local hatulrol = (mpos.vegzo==#s1)

	if not (elolrol or hatulrol) then 
		max = 0 
		megyezo = "" 
	end

	return max, megyezo, hatulrol
end

local function table2szo(t) -- stringé alakítja a táblában tárolt szót
	local szo = ""
	for i,v in ipairs(t) do
		szo=szo..v
	end
	return szo
end 


function ket_szo_egyezes(s1,s2) -- kétoldalról megvizsgálja az egyezést és hogy meg kell-e fordítani (kimenet: EgyezésHossza, EgyezőKarakterek, MegKellEFordítani)
	local m1,m2,e1,e2,b1,b2
	m1,e1,b1 = ket_szo_egyezese_seged(s1,s2)
	m2,e2,b2 = ket_szo_egyezese_seged(s2,s1)
	--[[if m1>=m2 then return m1,e1, not b1 end 
	return m2,e2,b2]]
	if m1>=m2 then return m1, not b1 end -- egyező karakterek feleslegesek
	return m2,b2
end

function egy_szo_egyezese_a_tobbivel(j)
	for s,t in ipairs(szavak) do
		if j~=s then --ha nem saját maga
			local hossz,fordit = ket_szo_egyezes(szavak[j].szo,t.szo)
			if hossz>0 then
				table.insert(szavak[j].egyezes,{id=s,hossz=hossz,b=fordit})
			end
		end
	end
end


-- kiíratás
for s,t in ipairs(szavak) do
	egy_szo_egyezese_a_tobbivel(s)
	print(s,table2szo(t.szo))
		for e,egy in ipairs(t.egyezes) do
			print("",egy.id,egy.hossz,egy.b)
		end
end


-- love-ből kilépés (csak a lua kell)
love.event.quit()


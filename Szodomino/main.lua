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

FILENAME = "aaa.txt"

--[[
]]

local function ket_szo_egyezese_seged(s1,s2) -- egy oldalról megvizsgálja a ez egyezést

	local max = 1
	local mpos = {kezdo=0,vegzo=0} --vedelem a szó közepe miatt
		
	local jelenlegi = 1

	local c = 1
	while c<=#s1 do --végig iterál az első szón és rápróbálja a második szót az elejétől
		if s1[c]==s2[jelenlegi] then 
			--print(c,s1[c],jelenlegi,s2[jelenlegi],"+")
			jelenlegi=jelenlegi+1
		else
			--print(c,s1[c],jelenlegi,s2[jelenlegi],"-")
			if jelenlegi>max then  -- maximum mentés
				max=jelenlegi 
				mpos.kezdo=(c-1)-(jelenlegi-2)
				mpos.vegzo=(c-1)
			end
			if jelenlegi>1 then c=c-1 end
			jelenlegi=1
		end
		c=c+1
	end

	if jelenlegi>max then --maximum mentés
		max=jelenlegi 
		mpos.kezdo=#s1-(jelenlegi-2)
		mpos.vegzo=#s1 
	end

	max = max-1

	local elolrol = (mpos.kezdo==1)
	local hatulrol = (mpos.vegzo==#s1)

	if not (elolrol or hatulrol) then max = 0 end

	return max, hatulrol
end

local function table2szo(t) -- stringé alakítja a táblában tárolt szót
	local szo = ""
	for i,v in ipairs(t) do
		szo=szo..v
	end
	return szo
end 


function ket_szo_egyezes(s1,s2) -- kétoldalról megvizsgálja az egyezést és hogy meg kell-e fordítani (kimenet: EgyezésHossza)
	local m1,m2,b1,b2
	m1,b1 = ket_szo_egyezese_seged(s1,s2)
	m2,b2 = ket_szo_egyezese_seged(s2,s1)
	if m1>=m2 then
		if b1 then return m1 else return 0 end
	else
		if not b2 then return m2 else return 0 end
	end
end


--[[
]]

file = io.open("ki.txt","w+")

local elso1 = false -- azért van hogy ne írjon vessző az utolsó adatok után

for line1 in io.lines(FILENAME) do -- végig iterál a txt szavain
	local s1 = {}
	line1:gsub(".",function(c) table.insert(s1,c) end) -- karakterekre bontja a szót

	local maxhossz = 0
	local maxszo = ""

	print(line1)
	if elso1 then file:write(",\n") else elso1=true end
	file:write("\""..line1.."\":{\n")
	local elso2 = false -- azért van hogy ne írjon vessző az utolsó adatok után

	for line2 in io.lines(FILENAME) do
		local s2 = {}
		line2:gsub(".",function(c) table.insert(s2,c) end)

		if line1~=line2 then --ha nem saját maga
			local hossz = ket_szo_egyezes(s1,s2)
			if hossz>maxhossz then --maximum keresés
				maxhossz=hossz
				maxszo=line2
			end
			if hossz>0 then -- kiírja ha van egyezés
				if elso2 then file:write(",\n") else elso2=true end
				file:write("	\""..line2.."\":"..hossz)
				print("",line2,hossz)
			end
		end
	end

	file:write("\n}")

	if maxhossz~=0 then
		--file:write("\""..line1.."\":{".."\n	\""..maxszo.."\":"..maxhossz.."\n},\n")
		--print(line1,maxszo,maxhossz)
	end
end

file.close()

-- love-ből kilépés (csak a lua kell)
love.event.quit()
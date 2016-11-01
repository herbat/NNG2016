--[[
Ami eddig megvan:
	Egy függvény ami megmondja két szóról hogy mennyi a közös tartalmuk, mi az, és hogy milyen sorrendben kell lenniük.
	Egy ciklus ami végig megy az összes szón és az összes szóval (magát leszámítva) megvizsgálja az egyezést, és kiírja.

Ami kell:
	A bemeneti file-ból keres szavakat a a kimeneti file szavainak elejéhez, végéhez.
	Szavanként törli a bemeneti file-t és és mozgatja át a file elejére végére.

Ismert hibák:
	Nincs
]]

io.stdout:setvbuf("no") -- azonnali print a consolba


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
		--if b1 then return m1 else return 0 end
		return m1, not b1
	else
		--if not b2 then return m2 else return 0 end
		return m2, b2
	end
end


--[[
]]

-- IDE Jönne a varázslás

-- love-ből kilépés (csak a lua kell)
love.event.quit()
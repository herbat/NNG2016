
io.stdout:setvbuf("no") -- azonnali print a consolba


local function ket_szo_egyezese(s1,s2) -- egy oldalról megvizsgálja a ez egyezést

	local max = 1
	local jelenlegi = 1

	local c = 1
	while c<=#s1 do --végig iterál az első szón és rápróbálja a második szót az elejétől
		if s1[c]==s2[jelenlegi] then 
			--print(c,s1[c],jelenlegi,s2[jelenlegi],#s2,"+")
			jelenlegi=jelenlegi+1 --elmehet egyel tovább mint az s2 tartana, de akkor nem a végén volt. (még jó hogy a lua nil-nek és nem hibának veszi)
		else
			--print(c,s1[c],jelenlegi,s2[jelenlegi],#s2,"-")
			if jelenlegi>1 then c=c-1 end
			jelenlegi=1
		end
		c=c+1
	end

	if jelenlegi>max then --maximum mentés
		max=jelenlegi
	end

	return max-1
end

local function table2szo(t) -- stringé alakítja a táblában tárolt szót
	local szo = ""
	for i,v in ipairs(t) do
		szo=szo..v
	end
	return szo
end 


be = {}
ki = {}

for line in io.lines("aaa.txt") do 
    table.insert(be,line)
end

elso = {}
utolso = {}

lanc=1 --lanc eleje

elso.szo = {}
utolso.szo = {}

be[1]:gsub(".",function(c) table.insert(elso.szo,c) end)
be[1]:gsub(".",function(c) table.insert(utolso.szo,c) end) --megjegyezzük a kiírt szavak első és utolsó szavát

table.insert(ki,be[1]) --első átírása

table.remove(be,1)

while (#be>0) do

	elso.max = -1
	utolso.max = -1

	elso.maxID = -1
	utolso.maxID = -1

	for j,sor in ipairs(be) do --végig iterál az összes szón
		szo = {}
		sor:gsub(".",function(c) table.insert(szo,c) end)

		elso.hossz = ket_szo_egyezese(szo,elso.szo)
		utolso.hossz = ket_szo_egyezese(utolso.szo,szo)

		if elso.max<elso.hossz then --maximum kiválasztás
			elso.max=elso.hossz
			elso.maxID=j
		end

		if utolso.max<utolso.hossz then
			utolso.max=utolso.hossz
			utolso.maxID=j
		end

	end
	print(be[elso.maxID],table2szo(elso.szo),elso.max,be[utolso.maxID],table2szo(utolso.szo),utolso.max)
	--print(#be)

	if elso.max>utolso.max then
		print(be[elso.maxID],"+")
		elso.szo = {}
		be[elso.maxID]:gsub(".",function(c) table.insert(elso.szo,c) end)
		table.insert(ki,lanc,be[elso.maxID])
		table.remove(be,elso.maxID)
	else
		print(be[utolso.maxID],"-")
		utolso.szo = {}
		be[utolso.maxID]:gsub(".",function(c) table.insert(utolso.szo,c) end)
		table.insert(ki,be[utolso.maxID])
		table.remove(be,utolso.maxID)
	end

	if elso.max==0 and utolso.max==0 then --ha véget ér egy lánc
		print("New chain",table2szo(utolso.szo),#ki)
		lanc=#ki
		elso.szo=utolso.szo
	end

end

file = io.open("ki.txt","w+")
for j,sor in ipairs(ki) do
	file:write(sor.."\n")
end
file:close()



-- love-ből kilépés (csak a lua kell)
love.event.quit()
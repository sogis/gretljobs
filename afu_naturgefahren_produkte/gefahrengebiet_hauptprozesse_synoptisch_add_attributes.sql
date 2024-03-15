/*
 * - Spatial join
 * - Höchste Gefahrenstufe pro Splitter berechnen
 * - Aus den Ausgangs-Polygonen der höchsten Stufe die Teilprozess-IDs auf Splitter gruppieren
 */
with 

joined as (
	select 
		s.id,
		gk.*
	from
		gk_poly gk
	join
		splited s on st_within(s.point, gk.geometrie)
)

,splited_maxstufe as (
	select 
		max(prio) as gef_max,
		id
	from
		joined
	group by
		id
)

,splited_attr as (
	select 
		sm.id,
		sm.gef_max,
		(distinct charakterisierung order by charakterisierung)::text as charakterisierung
	from 
		splited_maxstufe sm
	join
		joined j 
		on 
		sm.id = j.id 
		and 
		sm.gef_max = j.prio
	group by 
		sm.id,
		sm.gef_max		
)

update 
	splited
set 
	gef_max = a.gef_max,
	charakterisierung = a.charakterisierung
from 
	splited_attr a
where 
	splited.id = a.id
;
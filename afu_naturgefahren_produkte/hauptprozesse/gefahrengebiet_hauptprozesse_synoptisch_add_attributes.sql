/*
 * - Spatial JOIN
 * - Höchste Gefahrenstufe pro Splitter berechnen
 * - Aus den Ausgangs-Polygonen der höchsten Stufe die Teilprozess-IDs auf Splitter gruppieren
 */
WITH
joined as (
	SELECT 
		s.id,
		gk.*
	FROM
		gk_poly gk
	JOIN
		splited s on st_within(s.point, gk.geometrie)
)

,splited_maxstufe as (
	SELECT 
		max(prio) as gef_max,
		id
	FROM
		joined
	GROUP BY
		id
)

,splited_attr as (
	SELECT 
		sm.id,
		sm.gef_max,
		string_agg(distinct charakterisierung,', ' order by charakterisierung)::text as charakterisierung,
                string_agg(distinct hauptprozess,', ' order by hauptprozess)::text as hauptprozess
	FROM 
		splited_maxstufe sm
	JOIN
		joined j 
		on 
		sm.id = j.id 
		and 
		sm.gef_max = j.prio
	GROUP BY 
		sm.id,
		sm.gef_max		
)

UPDATE
	splited
SET 
	gef_max = a.gef_max,
	charakterisierung = a.charakterisierung,
        hauptprozess = a.hauptprozess
FROM 
	splited_attr a
WHERE 
	splited.id = a.id
;
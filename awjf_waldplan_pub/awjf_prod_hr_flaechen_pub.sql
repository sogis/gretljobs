WITH

SELECT
	*
FROM 
	awjf_waldplan_pub_v2.waldplan_waldnutzung
	
	
produktive_flaechen_berechnet AS (
	SELECT 
		gs.egrid,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) AS flaeche
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	LEFT JOIN awjf_waldplan_pub_v2.waldplan_waldnutzung AS wnz
		ON ST_INTERSECTS(gs.geometrie, wnz.geometrie)
	WHERE
		wnz.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
	GROUP BY 
		g.egrid,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt
),

produktive_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'funktion', funktion_txt,
                'flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.Flaechen_Waldfunktion'
            )
        ) AS waldfunktion_flaechen
    FROM 
        waldfunktion_flaechen_berechnet
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),
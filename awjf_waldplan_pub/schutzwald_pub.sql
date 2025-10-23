SELECT
	sw.schutzwald_nr,
	--forstkreis, --erst möglich wenn entsprechender Layer erstellt wurde...aber braucht es die hier überhaupt?
	--forstkreis_txt,
	--forstrevier,
	sw.sturz,
	CASE 
		WHEN sw.sturz IS TRUE
			THEN 'Sturz modelliert'
		ELSE 'Sturz nicht modelliert'
	END AS sturz_txt,
	sw.rutsch,
	CASE 
		WHEN sw.rutsch IS TRUE
			THEN 'Rutsch modelliert'
		ELSE 'Rutsch nicht modelliert'
	END AS rutsch_txt,
	sw.gerinnerelevante_prozesse,
	CASE 
		WHEN sw.gerinnerelevante_prozesse IS TRUE
			THEN 'Gerinnerelevante Prozesse modelliert'
		ELSE 'Gerinnerelevante Prozesse nicht modelliert'
	END AS gerinnerelevante_prozesse_txt,
	sw.lawine,
	CASE 
		WHEN sw.lawine IS TRUE
			THEN 'Lawine modelliert'
		ELSE 'Lawine nicht modelliert'
	END AS lawine_txt,
	sw.andere_kt,
	CASE 
		WHEN sw.andere_kt IS TRUE
			THEN 'Schadenspotential in anderen Kantonen'
		ELSE 'Kein Schadenspotential in anderen Kantonen'
	END AS andere_kt_txt,
	sw.objektkategorie,
	osw.dispname AS objektkategorie_txt,
	sw.schadenpotential,
	sw.hauptgefahrenpotential,
	th.dispname AS hauptgefahrenpotential_txt,
	sw.intensitaet_geschaetzt,
	tig.dispname AS intensitaet_geschaetzt_txt,
	hgg.gemeindename AS gemeinde,
	ROUND((ST_Area(wf.geometrie)/10000)::numeric,3) AS flaeche,
	sw.bemerkungen,
	 wf.geometrie
FROM 
	awjf_waldplan_v2.waldplan_waldfunktion AS wf
LEFT JOIN awjf_waldplan_v2.waldplan_schutzwald AS sw 
	ON wf.schutzwald_r = sw.t_id
LEFT JOIN awjf_waldplan_v2.objekte_schutzwald AS osw 
	ON sw.objektkategorie = osw.ilicode
LEFT JOIN awjf_waldplan_v2.typ_hauptgefahrenpotential AS th 
	ON sw.hauptgefahrenpotential = th.ilicode
LEFT JOIN awjf_waldplan_v2.typ_intensitaet_geschaetzt tig 
	ON sw.intensitaet_geschaetzt = tig.ilicode
LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS hgg 
	ON wf.t_datasetname = hgg.bfs_gemeindenummer::text
WHERE 
	wf.funktion IN ('Schutzwald','Schutzwald_Biodiversitaet')

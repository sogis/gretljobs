DELETE FROM awjf_waldplan_pub_v2.waldplan_schutzwald;

WITH

grundstuecke AS (
	SELECT
		ww.egrid,
		ww.forstkreis,
		fk.dispname AS forstkreis_txt,
		wfr.aname AS forstrevier,
		mop.geometrie
	FROM
		awjf_waldplan_v2.waldplan_waldeigentum AS ww
	LEFT JOIN agi_mopublic_pub.mopublic_grundstueck AS mop
		ON ww.egrid = mop.egrid
	LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstrevier AS wfr
		ON ww.forstrevier = wfr.t_id
	LEFT JOIN awjf_waldplan_v2.forstkreise AS fk 
		ON ww.forstkreis = fk.ilicode
	WHERE
		ww.t_datasetname::int4 = ${bfsnr_param}
),

schutzwald_flaeche AS (
	SELECT
		schutzwald_r,
		ST_MakeValid(ST_UNION(geometrie)) AS geometrie
	FROM
		awjf_waldplan_v2.waldplan_waldfunktion
	WHERE 
		funktion IN ('Schutzwald','Schutzwald_Biodiversitaet')
	AND 
		t_datasetname::int4 = ${bfsnr_param}
	GROUP BY
		schutzwald_r
),

schutzwald_flaeche_cleaned AS (
	SELECT
		schutzwald_r,
		CASE 
			WHEN ST_GeometryType(geometrie) = 'ST_Polygon' THEN
				ST_MakePolygon(
					ST_ExteriorRing(geometrie), --äussere Begrenzung des Polygons
					ARRAY(
						SELECT ST_ExteriorRing(ring.geom) --Erstelle Array mit inneren Ringen (Löchern)
						FROM (
							SELECT (ST_DumpRings(swf.geometrie)).* --Zerlegung in einzelne ringe
						) AS ring
						WHERE ring.path[1] > 0 -- 0 = äusserer Ring, alles grösser als 0 sind innere Ringe, also Löcher
						AND (4 * 3.14159 * ST_Area(ring.geom)) /  --Polsby-Popper-Test ((4π × Fläche) / (Umfang²)). Je kleiner der Wert, also nahe 0, desto länger ist die Form des Rings, was auf ein Silver-Polygon hindeutet.
							(ST_Perimeter(ring.geom) ^ 2) > 0.005 -- Werte über 0.0005 sollten "gewollte" Ringe sein, unter 0.0005 Silver-Polygone
					)
				)
			ELSE geometrie
		END AS geometrie
	FROM
		schutzwald_flaeche AS swf
),

administrative_forstdaten AS (
	SELECT
		schutzwald_r,
		gs.forstkreis,
		gs.forstkreis_txt,
		STRING_AGG(DISTINCT gs.forstrevier, ', ') AS forstrevier,
		swf.geometrie
	FROM 
		schutzwald_flaeche_cleaned AS swf
	LEFT JOIN grundstuecke AS gs 
		ON ST_INTERSECTS(swf.geometrie, gs.geometrie)
	WHERE
		ST_Area(ST_Intersection(swf.geometrie, gs.geometrie)) > 1
	GROUP BY 
		swf.schutzwald_r,
		gs.forstkreis,
		gs.forstkreis_txt,
		swf.geometrie
),

schutzwald_attribute AS (
	SELECT 
		sw.t_id,
		sw.t_basket,
		sw.t_datasetname,
		sw.schutzwald_nr,
		sw.sturz,
		CASE 
			WHEN sw.sturz IS TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END AS sturz_txt,
		sw.rutsch,
		CASE 
			WHEN sw.rutsch IS TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END AS rutsch_txt,
		sw.gerinnerelevante_prozesse,
		CASE
			WHEN sw.gerinnerelevante_prozesse IS TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END AS gerinnerelevante_prozesse_txt,
		sw.lawine,
		CASE 
			WHEN sw.lawine IS TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END AS lawine_txt,
		sw.andere_kt,
		CASE 
			WHEN sw.andere_kt IS TRUE
				THEN 'Ja'
			ELSE 'Nein'
		END AS andere_kt_txt,
		sw.objektkategorie,
		osw.dispname AS objektkategorie_txt,
		sw.schadenpotential,
		sw.hauptgefahrenpotential,
		ah.dispname AS hauptgefahrenpotential_txt,
		sw.intensitaet_geschaetzt,
		ins.dispname AS intensitaet_geschaetzt_txt,
		hgg.gemeindename AS gemeinde,
		sw.bemerkungen
	FROM
		awjf_waldplan_v2.waldplan_schutzwald AS sw
	LEFT JOIN awjf_waldplan_v2.objekte_schutzwald AS osw 
		ON sw.objektkategorie = osw.ilicode
	LEFT JOIN awjf_waldplan_v2.art_hauptgefahrenpotential AS ah 
		ON sw.hauptgefahrenpotential = ah.ilicode
	LEFT JOIN awjf_waldplan_v2.intensitaetsstufe AS ins 
		ON sw.intensitaet_geschaetzt = ins.ilicode
	LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS hgg 
		ON sw.t_datasetname = hgg.bfs_gemeindenummer::text
	WHERE
		sw.t_datasetname::int4 = ${bfsnr_param}
),

schutzwald_zusammengefasst AS (
	SELECT 
		swa.t_basket,
		swa.t_datasetname,
		swa.schutzwald_nr,
		af.forstkreis,
		af.forstkreis_txt,
		af.forstrevier,
		swa.sturz,
		swa.sturz_txt,
		swa.rutsch,
	 	swa.rutsch_txt,
		swa.gerinnerelevante_prozesse,
		swa.gerinnerelevante_prozesse_txt,
		swa.lawine,
		swa.lawine_txt,
		swa.andere_kt,
		swa.andere_kt_txt,
		swa.objektkategorie,
		swa.objektkategorie_txt,
		swa.schadenpotential,
		swa.hauptgefahrenpotential,
		swa.hauptgefahrenpotential_txt,
		swa.intensitaet_geschaetzt,
		swa.intensitaet_geschaetzt_txt,
		swa.gemeinde,
		ROUND((ST_Area(af.geometrie)/1000)::NUMERIC,3) AS flaeche,
		swa.bemerkungen,
		af.geometrie
	FROM
		schutzwald_attribute AS swa
	LEFT JOIN administrative_forstdaten AS af
		ON swa.t_id = af.schutzwald_r
)


INSERT INTO awjf_waldplan_pub_v2.waldplan_schutzwald (
	t_basket,
	t_datasetname,
	schutzwald_nr,
	forstkreis,
	forstrevier,
	sturz,
	sturz_txt,
	rutsch,
	rutsch_txt,
	gerinnerelevante_prozesse,
	gerinnerelevante_prozesse_txt,
	lawine,
	lawine_txt,
	andere_kt,
	andere_kt_txt,
	objektkategorie,
	objektkategorie_txt,
	schadenpotential,
	hauptgefahrenpotential,
	hauptgefahrenpotential_txt,
	intensitaet_geschaetzt,
	intensitaet_geschaetzt_txt,
	gemeinde,
	flaeche,
	bemerkungen,
	geometrie
)

SELECT
	t_basket,
	t_datasetname,
	schutzwald_nr,
	forstkreis_txt AS forstkreis,
	forstrevier,
	sturz,
	sturz_txt,
	rutsch,
	rutsch_txt,
	gerinnerelevante_prozesse,
	gerinnerelevante_prozesse_txt,
	lawine,
	lawine_txt,
	andere_kt,
	andere_kt_txt,
	objektkategorie,
	objektkategorie_txt,
	schadenpotential,
	hauptgefahrenpotential,
	hauptgefahrenpotential_txt,
	intensitaet_geschaetzt,
	intensitaet_geschaetzt_txt,
	gemeinde,
	flaeche,
	bemerkungen,
	geometrie
FROM 
	schutzwald_zusammengefasst
;
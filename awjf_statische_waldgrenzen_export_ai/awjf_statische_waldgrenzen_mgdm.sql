
WITH activated_municipalities AS 
( 
	SELECT 
		gemeinden.municipality 
	FROM 
		agi_oereb_annex.oerb_xtnx_v1_0annex_municipalitywithplrc AS gemeinden
		LEFT JOIN agi_oereb_annex.oereb_extractannex_v1_0_code_ AS code 
		ON gemeinden.t_id = code.oerb_xtnx_vpltywthplrc_themes 
	WHERE 
		avalue = 'Waldgrenzen'
)	
,
waldgrenzen AS 
(
	SELECT 
		waldgrenze.*,
		gemeindegrenze.bfs_gemeindenummer,
		activated_municipalities.municipality
	FROM 
		awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie AS waldgrenze
		LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
		ON ST_Intersects(ST_LineInterpolatePoint(waldgrenze.geometrie, 0.5), gemeindegrenze.geometrie)
		JOIN activated_municipalities
		ON activated_municipalities.municipality = gemeindegrenze.bfs_gemeindenummer 
	WHERE 
		waldgrenze.rechtsstatus = 'inKraft'
)
,
geobasisdaten_typ AS 
(
	INSERT INTO 
		awjf_statische_waldgrenzen_mgdm.geobasisdaten_typ 
		(
			t_id, 
			acode,
			bezeichnung,
			abkuerzung,
			verbindlichkeit,
			bemerkungen,
			art
		)
	SELECT 
		DISTINCT ON (typ.t_id)
		typ.t_id,
		CASE 
			WHEN typ.art = 'Nutzungsplanung_in_Bauzonen' THEN 'in_Bauzonen'
			ELSE 'ausserhalb_Bauzonen'
		END AS acode,
		typ.bezeichnung,
		typ.abkuerzung,
		CASE 
			WHEN typ.verbindlichkeit = 'orientierend' THEN 'Orientierend'
			ELSE typ.verbindlichkeit 
		END AS verbindlichkeit,
		typ.bemerkungen,
		CASE 
			WHEN typ.art = 'Nutzungsplanung_in_Bauzonen' THEN 'in_Bauzonen'
			ELSE 'ausserhalb_Bauzonen'
		END AS art
		
	FROM 
		waldgrenzen 
		LEFT JOIN awjf_statische_waldgrenze.geobasisdaten_typ AS typ
		ON typ.t_id = waldgrenzen.waldgrenze_typ
	WHERE 
	verbindlichkeit = 'Nutzungsplanfestlegung' OR verbindlichkeit = 'orientierend'
)
INSERT INTO 
	awjf_statische_waldgrenzen_mgdm.geobasisdaten_waldgrenze_linie 
	(
		t_id,
		geometrie,
		rechtsstatus,
		publiziertab,
		bemerkungen,
		wg
	)
	SELECT 
		t_id,
		geometrie,
		rechtsstatus,
		publiziert_ab,
		bemerkungen,
		waldgrenze_typ
	FROM 
		waldgrenzen 
;
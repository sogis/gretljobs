DELETE FROM sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115auswertung_gemeinde;

WITH

objektinfos_aggregiert AS (
	SELECT
		gemeindename,
		bfsnr,
		gruppe AS gruppe_name,
		thema AS thema_name,
		JSON_GROUP_ARRAY(
			JSON_OBJECT (
				'@type', 'SO_ARP_SEin_Konfiguration_20250115.Objektinfo',
				'Information', information,
                'Link', link
			)
		) AS objektinfos
	FROM ( 
		SELECT DISTINCT 
			gemeindename,
			bfsnr,
			gruppe,
			thema,
			information,
			link
		FROM 
			main.sein_sammeltabelle_filtered
	) AS unique_objekte
	GROUP BY
		gemeindename,
		bfsnr,
		gruppe_name,
		thema_name
),

themas_betroffen AS ( 
	SELECT
		objekte.gemeindename,
		objekte.bfsnr,
		objekte.gruppe_name,
		objekte.thema_name,
		thema.gruppe_r,
		JSON_OBJECT ( 
			'@type', 'SO_ARP_SEin_Konfiguration_20250115.Auswertung.Thema',
			'Name', thema.aname,
			'LayerId', thema.layerid,
			'LayerTransparenz', thema.layertransparenz,
            'ist_betroffen', true,
            'Objektinfos', objekte.objektinfos	
		) AS thema
	FROM
		objektinfos_aggregiert AS objekte
	LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_thema AS thema 
		ON objekte.thema_name = thema.aname
),

themas_nicht_betroffen AS ( 
	SELECT
		gemeinde.aname AS gemeindename,
		gemeinde.bfsnr,
		gruppe.aname AS gruppe_name,
		thema.aname AS thema_name,
		thema.gruppe_r,
		JSON_OBJECT ( 
			'@type', 'SO_ARP_SEin_Konfiguration_20250115.Auswertung.Thema',
			'Name', thema.aname,
			'LayerId', thema.layerid,
			'LayerTransparenz', thema.layertransparenz,
            'ist_betroffen', false
		) AS thema
	FROM
		sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde,
		sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_thema AS thema
	LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gruppe AS gruppe
		ON thema.gruppe_r = gruppe.t_id
	WHERE 
		NOT EXISTS (
			SELECT 
				1
			FROM
				sein_sammeltabelle_filtered AS objekte
			WHERE 
				thema.aname = objekte.thema AND gemeinde.aname = objekte.gemeindename
		)
),

alle_themen AS (
	SELECT
		*
	FROM 
		themas_betroffen
	UNION ALL
	SELECT
		*
	FROM 
		themas_nicht_betroffen
),

alle_themen_gruppiert AS (
	SELECT
		gemeindename,
		bfsnr,
		gruppe_name,
		JSON_GROUP_ARRAY(
			thema
		) AS themen
	FROM
		alle_themen
	GROUP BY
		gemeindename,
		bfsnr,
		gruppe_name
)

INSERT INTO
	sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115auswertung_gemeinde (
		aname,
		bfsnr,
		bezirk,
		boundingbox,
		gruppen,
		handlungsraum,
		geometrie
)

SELECT
	atg.gemeindename AS aname,
	gemeinde.bfsnr,
	gemeinde.bezirk,
	'['||ST_XMin(gemeinde.geometrie)||','||ST_YMin(gemeinde.geometrie)||','||ST_XMax(gemeinde.geometrie)||','||ST_YMax(gemeinde.geometrie)||']' AS boundingbox,
	JSON_GROUP_ARRAY (
		JSON_OBJECT(
			'@type', 'SO_ARP_SEin_Konfiguration_20250115.Auswertung.Gruppe',
			'Name', atg.gruppe_name,
           	'Themen', atg.themen
		)
	) AS gruppen,
	gemeinde.handlungsraum,
	gemeinde.geometrie
FROM 
	alle_themen_gruppiert AS atg
LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde 
	ON atg.gemeindename = gemeinde.aname
GROUP BY
	atg.gemeindename,
	gemeinde.bfsnr,
	gemeinde.bezirk,
	boundingbox,
	gemeinde.handlungsraum,
	gemeinde.geometrie
;
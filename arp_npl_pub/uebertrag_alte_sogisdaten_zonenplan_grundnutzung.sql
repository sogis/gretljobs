WITH tmp_result AS (
SELECT 
    --ogc_fid AS t_id, --TODO REPLACE WITH NEW generated_id
    uuid_generate_v4() AS t_ili_tid,
    zcode_text AS typ_bezeichnung,
    NULL AS typ_abkuerzung, --ev. MAPPING?
    'Nutzungsplanfestlegung'::varchar(255) AS typ_verbindlichkeit, --NOT NULL CONSTRAINT IN target table
    NULL AS typ_bemerkungen,
    'N' ||
    CASE
      WHEN zcode = 111 THEN '110_Wohnzone_1_G'
      WHEN zcode = 112 THEN '111_Wohnzone_2_G'
      WHEN zcode = 113 THEN '112_Wohnzone_3_G'
      WHEN zcode = 114 THEN '113_Wohnzone_4_G'
      WHEN zcode = 115 THEN '114_Wohnzone_5_G'
      WHEN zcode = 121 THEN '120_Gewerbezone_ohne_Wohnen'
      WHEN zcode = 123 THEN '121_Industriezone'
      WHEN zcode = 131 THEN '130_Gewerbezone_mit_Wohnen_Mischzone'
      WHEN zcode = 141 THEN '141_Zentrumszone'
      WHEN zcode = 151 THEN '150_Zone_fuer_oeffentliche_Bauten'
      WHEN zcode = 152 THEN '151_Zone_fuer_oeffentliche_Anlagen'
      WHEN zcode = 211 THEN '142_Erhaltungszone'
      WHEN zcode IN (221,223,612,614,811) THEN '160_Gruen_und_Freihaltezone_innerhalb_Bauzone'
      WHEN zcode = 311 THEN '190_Spezialzone'
      WHEN zcode = 315 THEN '162_Landwirtschaftliche_Kernzone'
      WHEN zcode = 322 THEN '181_Verkehrszone_Bahnareal'
      WHEN zcode = 411 THEN '163_Weilerzone'
      WHEN zcode = 721 THEN '439_Reservezone'
      WHEN zcode = 741 THEN '320_Gewaesser'
      WHEN zcode = 742 THEN '161_kommunale_Uferschutzzone_innerhalb_Bauzone'
      WHEN zcode = 911 THEN '170_Zone_fuer_Freizeit_und_Erholung'
      WHEN zcode = 912 THEN '169_weitere_eingeschraenkte_Bauzonen'
    END AS typ_kt,
    (CASE
      WHEN zcode = 111 THEN '110'
      WHEN zcode = 112 THEN '111'
      WHEN zcode = 113 THEN '112'
      WHEN zcode = 114 THEN '113'
      WHEN zcode = 115 THEN '114'
      WHEN zcode = 121 THEN '120'
      WHEN zcode = 123 THEN '121'
      WHEN zcode = 131 THEN '130'
      WHEN zcode = 141 THEN '141'
      WHEN zcode = 151 THEN '150'
      WHEN zcode = 152 THEN '151'
      WHEN zcode = 211 THEN '142'
      WHEN zcode IN (221,223,612,614,811) THEN '160'
      WHEN zcode = 311 THEN '190'
      WHEN zcode = 315 THEN '162'
      WHEN zcode = 322 THEN '181'
      WHEN zcode = 411 THEN '163'
      WHEN zcode = 721 THEN '439'
      WHEN zcode = 741 THEN '320'
      WHEN zcode = 742 THEN '161'
      WHEN zcode = 911 THEN '170'
      WHEN zcode = 912 THEN '169'
    END || '0')::int4 AS typ_code_kommunal, --NOT NULL
    NULL::numeric(3,2) AS typ_nutzungsziffer,
    NULL::varchar(255) AS typ_nutzungsziffer_art,
    NULL::int4 AS typ_geschosszahl,
    (ST_Dump(wkb_geometry)).geom AS geometrie,
    NULL::varchar(20) AS name_nummer,
    'inKraft'::varchar(255) AS rechtsstatus,
    new_date AS publiziert_ab,
    'provisorisch'::varchar(240) AS bemerkungen,
    'unbekannt'::varchar(80) AS erfasser,
    new_date AS datum_erfassung,
    NULL::json AS dokumente,
    gem_bfs AS bfs_nr
FROM digizone.zonenplan
 WHERE
    archive = 0
  AND 
		-- needs to be updated whenever a new municipality is migrated to the new model
    gem_bfs NOT IN (2401,2403,2405,2407,2408,2457,2473,2474,2475,2476,2498,2501,2502,2580,2613,2614,2615)
)
SELECT * FROM tmp_result;

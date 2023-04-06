SELECT
  5 AS t_basket, --Basket für reguläre MJPNL-Daten (ausserhalb von Basisdaten)
  'bla' AS vereinbarungs_nr,--im Postprocessing zu ersetzen
  vbg.vbnr AS vereinbarungs_nr_alt,
  mjpfl.flaecheid AS flaechen_id_alt,
  ST_Multi(vbggeom.wkb_geometry) AS geometrie,
  9999999 AS gelan_pid_gelan, --im Postprocessing zu ersetzen
  '9999999' AS gelan_bewe_id, --im Postprocessing zu ersetzen
  FALSE AS uebersteuerung_bewirtschafter,
  ARRAY[]::integer[] AS bfs_nr, --im Postprocessing zu ersetzen
  ARRAY[]::varchar[] AS gemeinde, --im Postprocessing zu ersetzen
  ARRAY[]::varchar[] AS gb_nr, --im Postprocessing zu ersetzen
  ARRAY[]::varchar[] AS flurname, --im Postprocessing zu ersetzen
  -- die Unterscheidung ob Weide_LN oder Weide_SoeG wird im Post-processing gemacht
  -- Standardmässig werden alle Weiden der Weide_LN zu
  CASE
    WHEN vbartvb.bez = 'Ansaatwiesen' AND flart.bez = 'Ansaatwiese' THEN 'Wiese'
    WHEN vbartvb.bez = 'Ansaatwiesen' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Ansaatwiesen' AND flart.bez = 'Streuefläche' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hecken' AND flart.bez = 'Ansaatwiese'  THEN 'Wiese'
    WHEN vbartvb.bez = 'Hecken' AND flart.bez = 'Hecke' THEN 'Hecke'
    WHEN vbartvb.bez = 'Hecken' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hecken' AND flart.bez = 'Lebhag' THEN 'Lebhag'
    WHEN vbartvb.bez = 'Hecken' AND flart.bez = 'Streuefläche' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hecken' AND flart.bez = 'Weide' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Heumatten' AND flart.bez = 'Ansaatwiese' THEN 'Wiese'
    WHEN vbartvb.bez = 'Heumatten' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Heumatten' AND flart.bez = 'Streuefläche' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Ansaatwiese' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Hostett' THEN 'Hostett'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Obstbaumlandschaft' THEN 'OBL'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Weide' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Waldränder' AND flart.bez = 'Ansaatwiese' THEN 'Wiese'
    WHEN vbartvb.bez = 'Waldränder' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Waldränder' AND flart.bez = 'Weide' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Weiden' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Wiesen am Bach' AND flart.bez = 'Ansaatwiese' THEN 'Wiese'
    WHEN vbartvb.bez = 'Wiesen am Bach' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Wiesen am Bach' AND flart.bez = 'Uferbereich' THEN 'Hecke'
    WHEN vbartvb.bez = 'Wiesen am Bach' AND flart.bez = 'Weide' THEN 'Weide_LN'
    WHEN vbartvb.bez IS NULL AND flart.bez = 'Ansaatwiese' THEN 'Wiese'
    WHEN vbartvb.bez IS NULL AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez IS NULL AND flart.bez = 'Lebhag' THEN 'Lebhag'
    WHEN vbartvb.bez IS NULL AND flart.bez = 'Streuefläche' THEN 'Wiese'
    WHEN vbartvb.bez IS NULL AND flart.bez = 'Weide LN' THEN 'Weide_LN'
    WHEN vbartvb.bez IS NULL AND flart.bez = 'Weide SöG' THEN 'Weide_LN'
  END AS vereinbarungsart,    
  FALSE AS ist_nutzungsvereinbarung,
  Round((ST_Area(vbggeom.wkb_geometry) / 10000)::NUMERIC,2) AS flaeche, --Fläche IN ha, auf 2 Kommastellen gerundet
  rrb.rrbnr AS rrb_nr,
  --Input-Daten haben tw komische RRB-Datum
  CASE
      WHEN rrb.rrbdatum < '1582-01-01'::DATE THEN '1582-01-01'::DATE
      ELSE rrb.rrbdatum
  END AS rrb_publiziert_ab,
  'aktiv' AS status_vereinbarung, --TODO: MAPPING von Status code alt --> neu
  FALSE AS soemmerungsgebiet, --im Postprocessing zu ersetzen
  'MJPNL_2020' AS mjpnl_version,
  4::integer AS kontrollintervall,
  COALESCE(vbg.notiz,'') || E'\n§\n' ||
  '{\n"vbart_vereinbarung_alt":' || COALESCE(vbartvb.bez,'NULL') || ',\n' ||
  '"vbart_flaechenart_alt":' || COALESCE(flart.bez,'NULL') || ',\n' ||
  '"vereinbarungsflaeche_alt":' || COALESCE(mjpfl.flaeche::text,'NULL') || ',\n' ||
  '"bewirtschafter_alt":' || COALESCE(pers.name || COALESCE(' '|| pers.vorname,''),'NULL') ||
  '\n}'  AS bemerkung, --TODO: Zwischenparkieren weiterer alter Attribut-Werte
  18::int8 AS uzl_subregion, -- im Postprocessing zu ersetzen
  'migration' AS dateipfad_oder_url,
  COALESCE(vbg.gueltigab,'1900-01-01'::DATE) AS erstellungsdatum,
  COALESCE(RTRIM(vbg.bearbeiter),'unbekannt (Migration)') AS operator_erstellung
FROM mjpnatur.flaechen mjpfl
   LEFT JOIN mjpnatur.vereinbarung vbg
     ON mjpfl.vereinbarungid = vbg.vereinbarungsid AND vbg.archive = 0
   LEFT JOIN mjpnatur.flaechen_geom_t vbggeom
     ON mjpfl.polyid = vbggeom.polyid AND vbggeom.archive = 0
   LEFT JOIN mjpnatur.rrbeschluss rrb
     ON vbg.rrbbeschlussid = rrb.rrbid AND rrb.archive = 0
   LEFT JOIN mjpnatur.vbart vbartvb
     ON vbg.vbartid = vbartvb.vbartid AND vbartvb.archive = 0
   LEFT JOIN mjpnatur.flaechenart flart
     ON mjpfl.flaechenartid = flart.flaechenartid AND flart.archive = 0
   LEFT JOIN mjpnatur.personen pers
     ON vbg.persid = pers.persid AND pers.archive = 0
WHERE
    mjpfl.archive = 0
    AND vbggeom.wkb_geometry IS NOT NULL
    AND ST_IsValid(vbggeom.wkb_geometry)
    AND Round((ST_Area(vbggeom.wkb_geometry) / 10000)::NUMERIC,2) > 0 --IGNORE small OR emptry geometries
    AND NOT (vbartvb.bez = 'Heumatten' AND flart.bez = 'Feuchtgebiet')
    AND NOT (vbartvb.bez = 'Waldränder' AND flart.bez = 'Waldrand')
    AND NOT (vbartvb.bez = 'Waldreservate' AND flart.bez = 'Waldreservat')
;

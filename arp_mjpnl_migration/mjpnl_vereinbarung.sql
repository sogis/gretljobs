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
  CASE
    WHEN vbartvb.bez = 'Ansaatwiesen' AND vbartfl.bez IS NULL THEN 'Wiese'
    WHEN vbartvb.bez = 'Ansaatwiesen' AND vbartfl.bez = 'Weiden' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Ansaatwiesen' AND vbartfl.bez = 'Waldränder' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hecken' AND vbartfl.bez IS NULL THEN 'Hecke'
    WHEN vbartvb.bez = 'Hecken' AND vbartfl.bez = 'Heumatten' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hecken' AND vbartfl.bez = 'Waldränder' THEN 'Hecke'
    WHEN vbartvb.bez = 'Hecken' AND vbartfl.bez = 'Weiden' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Heumatten' AND vbartfl.bez IS NULL THEN 'Wiese'
    WHEN vbartvb.bez = 'Heumatten' AND vbartfl.bez = 'Hecken' THEN 'Hecke'
    WHEN vbartvb.bez = 'Heumatten' AND vbartfl.bez = 'Waldränder' THEN 'Wiese'
    WHEN vbartvb.bez = 'Heumatten' AND vbartfl.bez = 'Weiden' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Hochstamm' AND vbartfl.bez IS NULL THEN 'OBL'
    WHEN vbartvb.bez = 'Hochstamm' AND vbartfl.bez = 'Waldränder' THEN 'OBL'
    WHEN vbartvb.bez = 'Hochstamm' AND vbartfl.bez = 'Weiden' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Hochstamm' AND vbartfl.bez = 'Wiesen am Bach' THEN 'Wiese'
    WHEN vbartvb.bez = 'Waldränder' AND vbartfl.bez = 'Weiden' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Weiden' AND vbartfl.bez IS NULL THEN 'Weide_LN'
    WHEN vbartvb.bez IS NULL AND vbartfl.bez = 'Weiden' THEN 'Weide_LN'
    WHEN vbartvb.bez = 'Wiesen am Bach' AND vbartfl.bez IS NULL THEN 'WBL_Wiese'
    WHEN vbartvb.bez = 'Wiesen am Bach' AND vbartfl.bez = 'Waldränder' THEN 'WBL_Wiese'
    WHEN vbartvb.bez = 'Wiesen am Bach' AND vbartfl.bez = 'Weiden' THEN 'WBL_Weide'
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
  '{"vbart_vereinbarung_alt":' || COALESCE(vbartvb.bez,'NULL') ||
  ',"vbart_vbflaeche_alt":' || COALESCE(vbartfl.bez,'NULL') ||
  '}'  AS bemerkung, --TODO: Zwischenparkieren weiterer alter Attribut-Werte
  7::int8 AS uzl_subregion, -- im Postprocessing zu ersetzen
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
   LEFT JOIN mjpnatur.vbart vbartfl
     ON mjpfl.flaechenartid = vbartfl.vbartid AND vbartfl.archive = 0
WHERE
    mjpfl.archive = 0
    AND vbggeom.wkb_geometry IS NOT NULL
    AND Round((ST_Area(vbggeom.wkb_geometry) / 10000)::NUMERIC,2) > 0 --IGNORE small OR emptry geometries
    AND NOT (vbartvb.bez = 'Waldränder' AND vbartfl.bez IS NULL)
    AND NOT (vbartvb.bez = 'Waldränder' AND vbartfl.bez = 'Waldränder')
    AND NOT (vbartvb.bez IS NULL AND vbartfl.bez = 'Waldränder')
    AND NOT (vbartvb.bez = 'Waldreservate' AND vbartfl.bez IS NULL)
;

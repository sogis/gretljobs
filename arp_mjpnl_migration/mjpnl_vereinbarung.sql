SELECT
  9999999 AS t_basket, --Dummy-Basket für reguläre MJPNL-Daten (ausserhalb von Basisdaten)
  'bla' AS vereinbarungs_nr,--im Postprocessing zu ersetzen
  vbg.vbnr AS vereinbarungs_nr_alt,
  vbggeom.polyid AS flaechen_id_alt,
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
    WHEN vbartvb.bez = 'Heumatten' AND flart.bez = 'Feuchtgebiet' THEN 'Wiese'
    WHEN vbartvb.bez = 'Heumatten' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Heumatten' AND flart.bez = 'Streuefläche' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Ansaatwiese' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Heumatte' THEN 'Wiese'
    WHEN vbartvb.bez = 'Hochstamm' AND flart.bez = 'Hostett' THEN 'Hostet'
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
  replace(
      COALESCE(vbg.notiz,'') || E'\n§\n' ||
      '{\n"vbart_vereinbarung_alt":"' || COALESCE(vbartvb.bez,'NULL') || '",\n' ||
      '"vbart_flaechenart_alt":"' || COALESCE(flart.bez,'NULL') || '",\n' ||
      '"vereinbarungsflaeche_alt":' || COALESCE(Round(mjpfl.flaeche::NUMERIC,2)::text,'') || ',\n' ||
      '"bewirtschafter_alt":"' || COALESCE(pers.name || COALESCE(' '|| pers.vorname,''),'NULL') || '",\n' ||
      CASE WHEN mjpfl.wiesenkategorie IS NOT NULL AND mjpfl.wiesenkategorie > 0 THEN
        '"wiesenkategorie":"' || COALESCE(wieskat.kurzbez,'-') || '",\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.schnittzeitpunkt IS NOT NULL AND mjpfl.schnittzeitpunkt <> '' THEN
        '"schnittzeitpunkt":"' || mjpfl.schnittzeitpunkt || '",\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.balkenmaeher IS NOT NULL AND mjpfl.balkenmaeher = TRUE THEN
        '"balkenmaeher":' || mjpfl.balkenmaeher || ',\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.herbstweide IS NOT NULL AND mjpfl.herbstweide = TRUE THEN
        '"herbstweide":' || mjpfl.herbstweide || ',\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.emden IS NOT NULL AND mjpfl.emden > 0 THEN
        '"emden":"' || COALESCE(emden.kurzbez,'-') || '",\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.rkzugstreifen  IS NOT NULL AND mjpfl.rkzugstreifen = TRUE THEN
        '"rueckzugstreifen":' || mjpfl.rkzugstreifen || ',\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.oeqv_q_attest IS NOT NULL AND mjpfl.oeqv_q_attest > 0 THEN
        '"oeqv_q_attest":"' || COALESCE(oeqv.kurzbez,'-') || '",\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.datum_oeqv IS NOT NULL AND mjpfl.datum_oeqv != '9999-01-01'::date THEN
        '"oeqv_datum":"' || COALESCE(mjpfl.datum_oeqv::text,'-') || '",\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.laufmeter IS NOT NULL AND mjpfl.laufmeter > 0 THEN
        '"hecken_laufmeter":' || Round(mjpfl.laufmeter) || ',\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.datum_beurt IS NOT NULL AND mjpfl.datum_beurt != '9999-01-01'::date THEN
        '"datum_beurteilung":"' || COALESCE(mjpfl.datum_beurt::text,'-') || '",\n'
        ELSE ''
      END ||
      CASE WHEN mjpfl.letzter_unterhalt IS NOT NULL AND mjpfl.letzter_unterhalt != '9999-01-01'::date THEN
        '"letzter_unterhalt":"' || COALESCE(mjpfl.letzter_unterhalt::text,'-') || '",\n'
        ELSE ''
      END ||
      '\n}',
      ',\n\n}',
      '\n}'
    ) AS bemerkung, --TODO: Zwischenparkieren weiterer alter Attribut-Werte
  9999999 AS uzl_subregion, -- im Postprocessing zu ersetzen
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
   LEFT JOIN mjpnatur.code wieskat
     ON mjpfl.wiesenkategorie > 0 AND mjpfl.wiesenkategorie = wieskat.codeid AND wieskat.codetypid = 'FLK' --Naturschutzkategorie
   LEFT JOIN mjpnatur.code oeqv
     ON mjpfl.oeqv_q_attest > 0 AND mjpfl.oeqv_q_attest = oeqv.codeid AND oeqv.codetypid = 'OEQV' --ÖQV-Q Attest
   LEFT JOIN mjpnatur.code emden
     ON mjpfl.emden > 0 AND mjpfl.emden = emden.codeid AND emden.codetypid = 'EMD' --Emden
WHERE
    mjpfl.archive = 0
    AND vbggeom.wkb_geometry IS NOT NULL
    AND ST_IsValid(vbggeom.wkb_geometry)
    AND Round((ST_Area(vbggeom.wkb_geometry) / 10000)::NUMERIC,2) > 0 --IGNORE small OR emptry geometries
    AND NOT (vbartvb.bez = 'Waldränder' AND flart.bez = 'Waldrand')
    AND NOT (vbartvb.bez = 'Waldreservate' AND flart.bez = 'Waldreservat')
;



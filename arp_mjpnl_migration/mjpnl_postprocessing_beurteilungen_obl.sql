INSERT
   INTO ${DB_Schema_MJPNL}.mjpnl_beurteilung_obl
     (
       --ignored: t_id 
       t_basket,
       --ignored: t_ili_tid
       einstiegskriterium_obl,
       --ignored:zusatzdokument_datum,
       --ignored:zusatzdokument_dateipfad,
       grundbeitrag_baum_anzahl,
       grundbeitrag_baum_total,
       beitrag_baumab40cmdurchmesser_anzahl,
       beitrag_baumab40cmdurchmesser_total,
       beitrag_erntepflicht_anzahl,
       beitrag_erntepflicht_total,
       beitrag_oekoplus_anzahl,
       beitrag_oekoplus_total,
       beitrag_oekomaxi_anzahl,
       beitrag_oekomaxi_total,
       beurteilungsdatum,
       bemerkungen,
       kopie_an_bewirtschafter,
       mit_bewirtschafter_besprochen,
       --ignored: datum_besprechung_bewirtschafter
       --ignored: abgeltung_generisch_text
       --ignored: abgeltung_generisch_betrag
       abgeltung_total,
       --ignored: besondere_abmachungen
       erstellungsdatum,
       operator_erstellung,
       --ignored: aenderungsdatum,
       --ignored: operator_aenderung
       berater,
       vereinbarung
     ) 
WITH tmp AS (
    SELECT
        t_id,
        t_basket,
        vereinbarungs_nr,
        (string_to_array(bemerkung,'§'))[2]::jsonb AS old_attr,
        geometrie
    FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung
        WHERE vereinbarungsart = 'OBL' AND vereinbarungs_nr != '01_DUMMY_00001'
),
-- summe anzahl der bäume auf der 23er leistungen dieser art (Grundbeitrag (Bäume)) lesen
tmp_grundbeitrag_baeume AS (
    SELECT 
      vereinbarung,
      SUM(anzahl_einheiten) AS anzahl_grundbeitrag
    FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
    WHERE leistung_beschrieb = 'Grundbeitrag (Bäume)'
      AND auszahlungsjahr = 2023
    GROUP BY vereinbarung
),
-- summe anzahl der bäume auf der 23er leistungen dieser art (Erschwernis (E-B)) lesen
tmp_erschwernis_baeume AS (
    SELECT 
      vereinbarung,
      SUM(anzahl_einheiten) AS anzahl_erschwernis
    FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
    WHERE leistung_beschrieb = 'Erschwernis (E-B)'
      AND auszahlungsjahr = 2023
    GROUP BY vereinbarung
),
-- summe anzahl der bäume auf der 23er leistungen dieser art (Bes. Strukturvielfalt (S-B)) lesen
tmp_40cm_baeume AS (
    SELECT 
      vereinbarung,
      SUM(anzahl_einheiten) AS anzahl_40cm
    FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
    WHERE leistung_beschrieb = 'Bes. Strukturvielfalt (S-B)'
      AND auszahlungsjahr = 2023
    GROUP BY vereinbarung
),
tmp2 AS ( 
    SELECT * FROM tmp 
    LEFT JOIN tmp_grundbeitrag_baeume ON tmp.t_id = tmp_grundbeitrag_baeume.vereinbarung
    LEFT JOIN tmp_erschwernis_baeume ON tmp.t_id = tmp_erschwernis_baeume.vereinbarung
    LEFT JOIN tmp_40cm_baeume ON tmp.t_id = tmp_40cm_baeume.vereinbarung
)
SELECT
   t_basket,
   TRUE AS einstiegskriterium_obl,
   COALESCE(anzahl_grundbeitrag, anzahl_erschwernis, 0) AS grundbeitrag_baum_anzahl,
   COALESCE(anzahl_grundbeitrag, anzahl_erschwernis, 0)*10 AS grundbeitrag_baum_total,
   COALESCE(anzahl_40cm, 0) AS beitrag_baumab40cmdurchmesser_anzahl, 
   COALESCE(anzahl_40cm, 0)*15 AS beitrag_baumab40cmdurchmesser_total,
   0 AS beitrag_erntepflicht_anzahl,
   0 AS beitrag_erntepflicht_total,
   0 AS beitrag_oekoplus_anzahl,
   0 AS beitrag_oekoplus_total,
   0 AS beitrag_oekomaxi_anzahl,
   0 AS beitrag_oekomaxi_total,
   now()::date AS beurteilungsdatum,
   'Unvollständige Beurteilung aus Migration' AS bemerkungen,
   FALSE AS kopie_an_bewirtschafter,
   FALSE AS mit_bewirtschafter_besprochen,
   -- es wird keine total abgeltung kalkuliert
   0 AS abgeltung_total,
   now()::date AS erstellungsdatum,
   'Migration' AS operator_erstellung,
   (SELECT t_id FROM ${DB_Schema_MJPNL}.mjpnl_berater WHERE aname = 
    (SELECT 
        CASE 
            WHEN b.bezirksname IN ('Dorneck') THEN 'Meier'
            ELSE 'Gschwind-Holzherr'
        END AS ermittelter_berater
    FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze b
    WHERE ST_Intersects(tmp2.geometrie, b.geometrie)
    LIMIT 1
    )
   ) AS berater,
   t_id AS vereinbarung
FROM
  tmp2
;

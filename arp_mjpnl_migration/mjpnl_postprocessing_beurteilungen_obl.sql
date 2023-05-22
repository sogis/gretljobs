INSERT
   INTO ${DB_Schema_MJPNL}.mjpnl_beurteilung_obl
     (
       --ignored: t_id 
       t_basket,
       --ignored: t_ili_tid
       einstiegskriterium_obl,
       --ignored:zusatzdokument_datum,
       --ignored:zusatzdokument_dateipfad,
       grundbeitrag_baum_anzahl, --check: grundbeitrag_baum_anzahl,0 <- evtl. erschwernisbäume / grb-b grundbeitrag
       grundbeitrag_baum_total,
       beitrag_baumab40cmdurchmesser_anzahl, --check: beitrag_baumab40cmdurchmesser_anzahl, <- evtl. auch besondere strukturvielfalt s für bäume
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
        (string_to_array(bemerkung,'§'))[2]::jsonb AS old_attr
    FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung
        WHERE vereinbarungsart = 'OBL' AND vereinbarungs_nr != '01_DUMMY_00001'
)
SELECT
   t_basket,
   TRUE AS einstiegskriterium_obl,
   0 AS grundbeitrag_baum_anzahl, --check: grundbeitrag_baum_anzahl,0 <- evtl. erschwernisbäume / grb-b grundbeitrag
   0 AS grundbeitrag_baum_total,
   0 AS beitrag_baumab40cmdurchmesser_anzahl, --check: beitrag_baumab40cmdurchmesser_anzahl, <- evtl. auch besondere strukturvielfalt s für bäume
   0 AS beitrag_baumab40cmdurchmesser_total,
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
   (SELECT t_id FROM ${DB_Schema_MJPNL}.mjpnl_berater WHERE aname = 'Bruggisser') AS berater,
   t_id AS vereinbarung
FROM
  tmp
;

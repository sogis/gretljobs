INSERT INTO ${DB_Schema_MJPNL}.auswertung_snapshot_wbl_weide
(
    t_basket,
    jahr,
    vereinbarungs_nr,
    anzahl_flora_naehrstoffzeiger,
    anzahl_flora_typ_arten,
    anzahl_flora_bes_typ_arten, 
    anzahl_flora_seltene_arten,
    anzahl_fauna,
    anzahl_artenfoerderungen,
    artenfoerderung_zielarten,
    -- spezifisch für snapshot_wbl_weide
    kategorie
)
WITH beurteilungs_metainfo_wbl_weide AS (
    SELECT vereinbarung, beurteilungsdatum,
    einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    einstufungbeurteilungistzustand_flora_typische_arten,
    einstufungbeurteilungistzustand_flora_bes_typ_arten, 
    einstufungbeurteilungistzustand_flora_seltene_arten,
    einstufungbeurteilungistzustand_anzahl_fauna,
    artenfoerderung_ff_zielart1,
    artenfoerderung_ff_zielart2,
    artenfoerderung_ff_zielart3,
    -- spezifisch für snapshot_wbl_weide
    einstufungbeurteilungistzustand_weidenkategorie
    FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_weide
)
SELECT 
    (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20240606.Auswertung' LIMIT 1) as t_basket,
    ${AUSZAHLUNGSJAHR}::integer as jahr,
    vbg.vereinbarungs_nr as vereinbarungs_nr,
    bw.einstufungbeurteilungistzustand_flora_naehrstoffzeiger as anzahl_flora_naehrstoffzeiger,
    bw.einstufungbeurteilungistzustand_flora_typische_arten as anzahl_flora_typ_arten,
    bw.einstufungbeurteilungistzustand_flora_bes_typ_arten as anzahl_flora_bes_typ_arten, 
    bw.einstufungbeurteilungistzustand_flora_seltene_arten as anzahl_flora_seltene_arten,
    bw.einstufungbeurteilungistzustand_anzahl_fauna as anzahl_fauna,
    (CASE WHEN LENGTH(bw.artenfoerderung_ff_zielart1)>0 THEN 1 ELSE 0 END +
     CASE WHEN LENGTH(bw.artenfoerderung_ff_zielart2)>0 THEN 1 ELSE 0 END +
     CASE WHEN LENGTH(bw.artenfoerderung_ff_zielart3)>0 THEN 1 ELSE 0 END ) as anzahl_artenfoerderungen,
     ARRAY_TO_STRING(ARRAY[
        bw.artenfoerderung_ff_zielart1,
        bw.artenfoerderung_ff_zielart2,
        bw.artenfoerderung_ff_zielart3
     ]::varchar[], ',') as artenfoerderung_zielarten,
    -- spezifisch für snapshot_wbl_weide
    bw.einstufungbeurteilungistzustand_weidenkategorie as kategorie
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
LEFT JOIN beurteilungs_metainfo_wbl_weide bw
    ON vbg.t_id = bw.vereinbarung
    -- berücksichtige nur die neusten (sofern mehrere existieren)
    AND bw.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM beurteilungs_metainfo_wbl_weide be WHERE be.vereinbarung = vbg.t_id)
WHERE vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE AND vbg.ist_nutzungsvereinbarung IS NOT TRUE
AND vbg.vereinbarungsart = 'WBL_Weide'
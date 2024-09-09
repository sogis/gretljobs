INSERT INTO ${DB_Schema_MJPNL}.auswertung_jahresbericht_abgeltungen
(   t_basket,
    jahr,
    vereinbarungsart,
    bezirksnummer,
    bezirk,
    anzahl_vereinbarungen,
    flaeche_total,
    laufmeter_total,
    baeume_total,
	baeume_baumab40cmdurchmesser_total,
	baeume_erntepflicht_total,
	baeume_oekoplus_total,
	baeume_oekomaxi_total,
	betrag_total,
	anzahl_gemeinden
)
WITH beurteilungs_metainfo_baeume AS (
   SELECT vereinbarung, beurteilungsdatum,
   grundbeitrag_baum_anzahl,
   beitrag_baumab40cmdurchmesser_anzahl,
   beitrag_erntepflicht_anzahl,
   beitrag_oekoplus_anzahl,
   beitrag_oekomaxi_anzahl
   FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hostet
	UNION 
   SELECT vereinbarung, beurteilungsdatum, 
   grundbeitrag_baum_anzahl,
   beitrag_baumab40cmdurchmesser_anzahl,
   beitrag_erntepflicht_anzahl,
   beitrag_oekoplus_anzahl,
   beitrag_oekomaxi_anzahl
   FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_obl
),
beurteilungs_metainfo_hecke AS (
   SELECT vereinbarung, beurteilungsdatum,
   bewirtschaftung_lebhag_laufmeter
   FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hecke
)
SELECT 
    (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20240606.Auswertung' LIMIT 1) as t_basket,
    ${AUSZAHLUNGSJAHR}::integer as jahr,
    vbg.vereinbarungsart as vereinbarungsart,
	COALESCE(bezirk.bezirksnummer,0),
	COALESCE(bezirk.bezirksname,'unbekannt'),
	COUNT(DISTINCT vbg.vereinbarungs_nr) anzahl_vereinbarungen,
	SUM(vbg.flaeche) as flaeche_total,
    SUM(COALESCE(hk.bewirtschaftung_lebhag_laufmeter, 0)) as laufmeter,
	SUM(COALESCE(bae.grundbeitrag_baum_anzahl, 0)) as baeume_total,
	SUM(COALESCE(bae.beitrag_baumab40cmdurchmesser_anzahl, 0)) as baeume_baumab40cmdurchmesser_total,
	SUM(COALESCE(bae.beitrag_erntepflicht_anzahl, 0)) as baeume_erntepflicht_total,
	SUM(COALESCE(bae.beitrag_oekoplus_anzahl, 0)) as baeume_oekoplus_total,
	SUM(COALESCE(bae.beitrag_oekomaxi_anzahl, 0)) as baeume_oekomaxi_total,
	SUM(COALESCE(lstg.betrag_total,0)) as betrag_total,
	count(DISTINCT gemeinde.bfs_gemeindenummer) as anzahl_gemeinden
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_gemeinde gemeinde
ON gemeinde.bfs_gemeindenummer = vbg.bfs_nr[1]
LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_bezirk bezirk
ON bezirk.t_id = gemeinde.bezirk
LEFT JOIN beurteilungs_metainfo_baeume bae
ON vbg.t_id = bae.vereinbarung
-- berücksichtige nur die neusten (sofern mehrere existieren)
AND bae.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM beurteilungs_metainfo_baeume be WHERE be.vereinbarung = vbg.t_id)
LEFT JOIN beurteilungs_metainfo_hecke hk
ON vbg.t_id = hk.vereinbarung
-- berücksichtige nur die neusten (sofern mehrere existieren)
AND hk.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM beurteilungs_metainfo_hecke he WHERE he.vereinbarung = vbg.t_id)
-- wir holen den totalbetrag aus den leistungen, da auch einmalige miteinbezogen werden sollen
LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg
ON lstg.vereinbarung = vbg.t_id AND lstg.auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
WHERE vbg.status_vereinbarung = 'aktiv' AND vbg.bewe_id_geprueft IS TRUE AND vbg.ist_nutzungsvereinbarung IS NOT TRUE
GROUP BY bezirk.bezirksnummer, bezirk.bezirksname, vbg.vereinbarungsart
ORDER BY vbg.vereinbarungsart, bezirk.bezirksnummer
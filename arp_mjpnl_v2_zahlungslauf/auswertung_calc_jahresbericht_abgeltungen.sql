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
WITH leistungen_per_vereinbarung AS (
    SELECT vereinbarung, SUM(betrag_total) as betrag_total
    FROM ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung
    WHERE auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer
	AND status_abrechnung != 'in_bearbeitung'
    GROUP BY vereinbarung
),
beurteilungs_metainfo_baeume AS (
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
)
SELECT 
    (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20240606.Auswertung' LIMIT 1) as t_basket,
    ${AUSZAHLUNGSJAHR}::integer as jahr,
    vbg.vereinbarungsart as vereinbarungsart,
	COALESCE(bezirk.bezirksnummer,0),
	COALESCE(bezirk.bezirksname,'unbekannt'),
	COUNT(vbg.vereinbarungs_nr) anzahl_vereinbarungen,
	SUM(vbg.flaeche) as flaeche_total,
    SUM(
    case when (string_to_array(vbg.bemerkung,'***'))[2] is json and json_typeof((string_to_array(vbg.bemerkung,'***'))[2]::json) = 'object' 
    then ((string_to_array(vbg.bemerkung,'***'))[2]::jsonb->>'meter')::integer /
        case when ((string_to_array(vbg.bemerkung,'***'))[2]::jsonb->>'grenze')::boolean is true
        then 2
        else 1
        end
    else 0
    end) as laufmeter,
	SUM(COALESCE(bae.grundbeitrag_baum_anzahl, 0)) as baeume_total,
	SUM(COALESCE(bae.beitrag_baumab40cmdurchmesser_anzahl, 0)) as baeume_baumab40cmdurchmesser_total,
	SUM(COALESCE(bae.beitrag_erntepflicht_anzahl, 0)) as baeume_erntepflicht_total,
	SUM(COALESCE(bae.beitrag_oekoplus_anzahl, 0)) as baeume_oekoplus_total,
	SUM(COALESCE(bae.beitrag_oekomaxi_anzahl, 0)) as baeume_oekomaxi_total,
	SUM(COALESCE(lstg.betrag_total,0)) as betrag_total,
	count(DISTINCT gemeinde.bfs_gemeindenummer) as anzahl_gemeinden
FROM leistungen_per_vereinbarung lstg
INNER JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
ON lstg.vereinbarung = vbg.t_id
LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_gemeinde gemeinde
ON gemeinde.bfs_gemeindenummer = vbg.bfs_nr[1]
LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_bezirk bezirk
ON bezirk.t_id = gemeinde.bezirk
LEFT JOIN beurteilungs_metainfo_baeume bae
ON vbg.t_id = bae.vereinbarung
-- berücksichtige nur die neusten (sofern mehrere existieren)
AND bae.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM beurteilungs_metainfo_baeume be WHERE be.vereinbarung = vbg.t_id)
-- wir holen den totalbetrag aus den leistungen, da auch einmalige miteinbezogen werden sollen
WHERE vbg.ist_nutzungsvereinbarung IS NOT TRUE
GROUP BY bezirk.bezirksnummer, bezirk.bezirksname, vbg.vereinbarungsart
ORDER BY vbg.vereinbarungsart, bezirk.bezirksnummer
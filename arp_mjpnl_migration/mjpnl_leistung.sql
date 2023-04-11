SELECT
    5 AS t_basket,
    lart.kurzbez AS leistung_beschrieb,
    CASE
        WHEN l.ansatz > 0 AND l.mass > 0 THEN 'per_ha'
        ELSE 'pauschal'
    END AS abgeltungsart,
    CASE
        WHEN l.ansatz > 0 AND l.mass > 0 THEN l.ansatz
        ELSE l.betrag
    END AS betrag_per_einheit,
    CASE
        WHEN l.ansatz > 0 AND l.mass > 0 THEN l.mass
        ELSE 1
    END AS anzahl_einheiten,
    l.betrag AS betrag_total,
    extract(YEAR FROM datum_auszahlung) AS auszahlungsjahr,
    CASE
        WHEN stat.kurzbez = 'ausbezahlt' THEN 'ausbezahlt'
        /*WHEN stat.kurzbez = 'übernommen ARP' THEN 'ausbezahlt_vomArpUebernommen'*/
        ELSE 'ausbezahlt'
    END AS status_abrechnung,
    l.datum_auszahlung AS datum_abrechnung,
    COALESCE(l.bemerkung,'') ||
    '\n§\n' ||
    '{' ||
       '\n"leistungid":' || l.leistungid::TEXT || ',' ||
       '\n"polyid":' || l.polyid::TEXT || ',' ||
       '\n"polyidfromflaechen":' || l.polyidfromflaechen::TEXT || ',' ||
       '\n"status_auszahlung_kurz":"' || stat.kurzbez || '"' || ',' ||      
       '\n"status_auszahlung_lang":"' || stat.bezeichnung || '"' || ',' ||      
       '\n"datum_abrechnung":"' || l.datum_auszahlung::date::text || '"' ||     
    '\n}'::TEXT AS bemerkung,
    9999999 AS abrechnungpervereinbarung,
    9999999 AS vereinbarung
FROM mjpnatur.leistung l
   LEFT JOIN mjpnatur.leistungsart lart ON l.leistungartid = lart.leistungsartid AND lart.archive = 0
   LEFT JOIN mjpnatur.status stat ON l.status_auszahlung = stat.statuscd AND statustypid = 'ANZ'
WHERE
   l.datum_auszahlung >= '2020-01-01' AND l.datum_auszahlung != '9999-01-01'
   AND l.betrag > 0 AND l.betrag <= 10000 /* TODO remove upper limit after model update */
;

SELECT
    5 AS t_basket,
    lart.kurzbez AS leistung_beschrieb,
    CASE
        WHEN l.ansatz > 0 AND l.mass > 0 THEN 
            CASE 
                WHEN lart.kurzbez IN ('Erschwernis (E-B)', 'Bes. Strukturvielfalt (S-B)', 'Grundbeitrag (Bäume)') THEN 'pro_Stueck'
                ELSE 'per_ha'
            END
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
        ELSE 'bestaetigt'
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
       '\n"gueltigbis":"' || l.gueltigbis::date::text || '"' ||     
    '\n}'::TEXT AS bemerkung,
    9999999 AS abrechnungpervereinbarung,
    9999999 AS vereinbarung
FROM mjpnatur.leistung l
   LEFT JOIN mjpnatur.leistungsart lart ON l.leistungartid = lart.leistungsartid AND lart.archive = 0
   LEFT JOIN mjpnatur.status stat ON l.status_auszahlung = stat.statuscd AND statustypid = 'ANZ'
   LEFT JOIN mjpnatur.flaechen mjpfl ON l.polyid = mjpfl.flaecheid AND mjpfl.archive = 0
   LEFT JOIN mjpnatur.flaechenart flart ON mjpfl.flaechenartid = flart.flaechenartid AND flart.archive = 0
   LEFT JOIN mjpnatur.flaechen_geom_t vbggeom ON mjpfl.polyid = vbggeom.polyid AND vbggeom.archive = 0
   LEFT JOIN mjpnatur.vereinbarung vbg ON mjpfl.vereinbarungid = vbg.vereinbarungsid AND vbg.archive = 0
   LEFT JOIN mjpnatur.vbart vbartvb ON vbg.vbartid = vbartvb.vbartid AND vbartvb.archive = 0
WHERE
   -- alle ausbezahlten seit 2020 und noch nicht ausbezahlten, die bis 2023 gültig sind
   ( l.datum_auszahlung >= '2020-01-01' AND l.datum_auszahlung != '9999-01-01') OR gueltigbis = '2023-12-31'
   AND vbggeom.wkb_geometry IS NOT NULL
   AND ST_IsValid(vbggeom.wkb_geometry)
   AND Round((ST_Area(vbggeom.wkb_geometry) / 10000)::NUMERIC,2) > 0 --IGNORE small OR emptry geometries
   AND NOT (vbartvb.bez = 'Heumatten' AND flart.bez = 'Feuchtgebiet')
   AND NOT (vbartvb.bez = 'Waldränder' AND flart.bez = 'Waldrand')
   AND NOT (vbartvb.bez = 'Waldreservate' AND flart.bez = 'Waldreservat')
   -- AND l.betrag > 0
;

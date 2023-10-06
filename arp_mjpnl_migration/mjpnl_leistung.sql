SELECT
    9999999 AS t_basket, --Dummy-Basket für reguläre MJPNL-Daten (ausserhalb von Basisdaten)
    lart.kurzbez AS leistung_beschrieb,
    CASE
        WHEN l.ansatz > 0 AND l.mass > 0 THEN 
            CASE 
                WHEN lart.kurzbez IN ('Erschwernis (E-B)', 'Bes. Strukturvielfalt (S-B)', 'Grundbeitrag (Bäume)') THEN 'per_stueck'
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
    CASE
        WHEN l.datum_auszahlung = '9999-01-01' THEN 2023
        ELSE extract(YEAR FROM l.datum_auszahlung) 
    END AS auszahlungsjahr,
    CASE
        WHEN stat.kurzbez = 'freigegeben' THEN 'freigegeben'
        WHEN stat.kurzbez = 'in Bearbeitung' THEN 'in_bearbeitung'
        WHEN stat.kurzbez = 'Intern verrechnet' THEN 'intern_verrechnet'
        WHEN stat.kurzbez IN ('ausbezahlt', 'erledigt LW', 'übernommen ARP') THEN 'ausbezahlt'
        ELSE 'in_bearbeitung'
    END AS status_abrechnung,
    CASE
        WHEN l.datum_auszahlung = '9999-01-01' THEN NULL
        ELSE l.datum_auszahlung 
    END AS datum_abrechnung,
    COALESCE(l.bemerkung,'') ||
    '\n§\n' ||
    '{' ||
       '\n"leistungid":' || l.leistungid::TEXT || ',' ||
       '\n"polyid":' || l.polyid::TEXT || ',' ||
       '\n"polyidfromflaechen":' || l.polyidfromflaechen::TEXT || ',' ||
       '\n"status_auszahlung_kurz":"' || stat.kurzbez || '"' || ',' ||      
       '\n"status_auszahlung_lang":"' || stat.bezeichnung || '"' || ',' ||      
       '\n"datum_abrechnung":"' || l.datum_auszahlung::date::text || '"' || ',' ||  
       '\n"gueltigbis":"' || l.gueltigbis::date::text || '"' ||     
    '\n}'::TEXT AS bemerkung,
    TRUE AS migriert,
    CASE
        WHEN extract(YEAR FROM l.datum_auszahlung) = 2023 -- wenn aus diesem Jahr und bereits ausbezahlt
            OR lart.kurzbez IN ( 'Korrektur Vorjahr', 'Unterhaltsbeitrag', 'Pflanzmaterial', 'Kürzung', 'Saatgut' ) -- oder eines der spezifischen Arten
            OR lart.bez IN ( 'Pauschale einmalig (ha)', 'Pauschale einmalig (p)' ) -- oder eine einmalige Pauschale
        THEN TRUE
        ELSE FALSE
    END AS einmalig,
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
   ( ( l.datum_auszahlung >= '2020-01-01' AND l.datum_auszahlung != '9999-01-01') OR l.gueltigbis = '2023-12-31' )
   AND vbggeom.wkb_geometry IS NOT NULL
   AND ST_IsValid(vbggeom.wkb_geometry)
   AND Round((ST_Area(vbggeom.wkb_geometry) / 10000)::NUMERIC,2) > 0 --IGNORE small OR emptry geometries
   AND flart.bez NOT IN ('Waldrand', 'Waldreservat')
   -- AND l.betrag > 0
;

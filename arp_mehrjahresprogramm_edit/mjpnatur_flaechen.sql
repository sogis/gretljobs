SELECT 
    ST_Multi(fla_geom_t.wkb_geometry) AS geometrie,
    vereinbarung.vbnr AS vereinbarungsnummer,
    vereinbarung.persid AS person_flaeche 
FROM mjpnatur.flaechen_geom_t AS fla_geom_t
    LEFT JOIN mjpnatur.flaechen AS fla_attr
        ON fla_attr.vereinbarungid = fla_geom_t.polyid
    LEFT JOIN mjpnatur.vereinbarung AS vereinbarung
        ON fla_attr.vereinbarungid = vereinbarung.vereinbarungsid

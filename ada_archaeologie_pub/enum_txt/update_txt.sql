WITH 

enum_map AS (
    SELECT 
        ilicode AS enum_val,
        dispname AS enum_display
    FROM
        ada_archaeologie_pub_v1.public_qualitaet_lokalisierung_typ
),

upd_punkt_restr AS (
    UPDATE 
        ada_archaeologie_pub_v1.restricted_punktfundstelle
    SET 
        qualitaet_lokalisierung_txt = enum_display
    FROM
        enum_map m
    WHERE 
        enum_val = qualitaet_lokalisierung
),

upd_punkt_public AS (
    UPDATE 
        ada_archaeologie_pub_v1.public_punktfundstelle_siedlungsgebiet
    SET 
        qualitaet_lokalisierung_txt = enum_display
    FROM
        enum_map m
    WHERE 
        enum_val = qualitaet_lokalisierung
),

upd_flaeche_restr AS (
    UPDATE 
        ada_archaeologie_pub_v1.restricted_flaechenfundstelle
    SET 
        qualitaet_lokalisierung_txt = enum_display
    FROM
        enum_map m
    WHERE 
        enum_val = qualitaet_lokalisierung
)

-- upd_flaeche_public
UPDATE 
    ada_archaeologie_pub_v1.public_flaechenfundstelle_siedlungsgebiet
SET 
    qualitaet_lokalisierung_txt = enum_display
FROM
    enum_map m
WHERE 
    enum_val = qualitaet_lokalisierung
;

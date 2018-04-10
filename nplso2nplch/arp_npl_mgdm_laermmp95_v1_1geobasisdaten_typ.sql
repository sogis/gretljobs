DELETE FROM arp_npl_mgdm.laermmp95_v1_1geobasisdaten_typ
;

INSERT INTO arp_npl_mgdm.laermmp95_v1_1geobasisdaten_typ(
    code,
    bezeichnung,
    abkuerzung,
    empfindlichkeitsstufe,
    aufgestuft,
    verbindlichkeit,
    bemerkungen
)

SELECT
    code_kommunal AS code, 
    replace(substring(typ_kt FROM 6), '_', ' ') AS bezeichnung, 
    substring(typ_kt FROM 1 FOR 4) AS abkuerzung,
    CASE
        WHEN position('aufgestuft' IN typ_kt) != 0
            THEN 
                CASE 
                    WHEN substring(typ_kt FROM 6 FOR (position('aufgestuft' IN typ_kt)-7)) = 'keine_Empfindlichkeitsstufe'
                        THEN 'Keine_ES'
                    WHEN substring(typ_kt FROM 6 FOR (position('aufgestuft' IN typ_kt)-7)) = 'Empfindlichkeitsstufe_I'
                        THEN 'ES_I'
                    WHEN substring(typ_kt FROM 6 FOR (position('aufgestuft' IN typ_kt)-7)) = 'Empfindlichkeitsstufe_II'
                        THEN 'ES_II'
                    WHEN substring(typ_kt FROM 6 FOR (position('aufgestuft' IN typ_kt)-7)) = 'Empfindlichkeitsstufe_III'
                        THEN 'ES_III'
                    WHEN substring(typ_kt FROM 6 FOR (position('aufgestuft' IN typ_kt)-7)) = 'Empfindlichkeitsstufe_IV'
                        THEN 'ES_IV'
            END
        WHEN position('aufgestuft' IN typ_kt) = 0
            THEN 
                CASE 
                    WHEN substring(typ_kt FROM 6) = 'keine_Empfindlichkeitsstufe'
                        THEN 'Keine_ES'
                    WHEN substring(typ_kt FROM 6) = 'Empfindlichkeitsstufe_I'
                        THEN 'ES_I'
                    WHEN substring(typ_kt FROM 6) = 'Empfindlichkeitsstufe_II'
                        THEN 'ES_II'
                    WHEN substring(typ_kt FROM 6) = 'Empfindlichkeitsstufe_III'
                        THEN 'ES_III'
                    WHEN substring(typ_kt FROM 6) = 'Empfindlichkeitsstufe_IV'
                        THEN 'ES_IV'
            END
    END AS empfindlichkeitsstufe,
    CASE 
        WHEN position('aufgestuft' IN typ_kt) != 0
            THEN TRUE
        ELSE
            FALSE
    END as aufgestuft,
    verbindlichkeit,
    bemerkungen
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS ueberlagernd_flaeche
WHERE 
    substring(typ_kt FROM 2 FOR 3)::integer = 680
    OR 
    substring(typ_kt FROM 2 FOR 3)::integer = 681
    OR
    substring(typ_kt FROM 2 FOR 3)::integer = 682
    OR
    substring(typ_kt FROM 2 FOR 3)::integer = 683
    OR 
    substring(typ_kt FROM 2 FOR 3)::integer = 684
    OR
    substring(typ_kt FROM 2 FOR 3)::integer = 685
    OR
    substring(typ_kt FROM 2 FOR 3)::integer = 686
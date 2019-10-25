WITH geobasisdaten_typ AS 
(
    SELECT
        nextval('arp_laermempfindlichkeit_mgdm.t_ili2db_seq'::regclass) AS t_id,
        substring(ilicode FROM 2 FOR 3) || '0' AS code,        
        ilicode AS bezeichnung, /* zum Referenzieren */
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        CASE
            WHEN position('aufgestuft' IN ilicode) != 0
                THEN 
                    CASE 
                        WHEN substring(ilicode FROM 6 FOR (position('aufgestuft' IN ilicode)-7)) = 'keine_Empfindlichkeitsstufe'
                            THEN 'Keine_ES'
                        WHEN substring(ilicode FROM 6 FOR (position('aufgestuft' IN ilicode)-7)) = 'Empfindlichkeitsstufe_I'
                            THEN 'ES_I'
                        WHEN substring(ilicode FROM 6 FOR (position('aufgestuft' IN ilicode)-7)) = 'Empfindlichkeitsstufe_II'
                            THEN 'ES_II'
                        WHEN substring(ilicode FROM 6 FOR (position('aufgestuft' IN ilicode)-7)) = 'Empfindlichkeitsstufe_III'
                            THEN 'ES_III'
                        WHEN substring(ilicode FROM 6 FOR (position('aufgestuft' IN ilicode)-7)) = 'Empfindlichkeitsstufe_IV'
                            THEN 'ES_IV'
                END
            WHEN position('aufgestuft' IN ilicode) = 0
                THEN 
                    CASE 
                        WHEN substring(ilicode FROM 6) = 'keine_Empfindlichkeitsstufe'
                            THEN 'Keine_ES'
                        WHEN substring(ilicode FROM 6) = 'Empfindlichkeitsstufe_I'
                            THEN 'ES_I'
                        WHEN substring(ilicode FROM 6) = 'Empfindlichkeitsstufe_II'
                            THEN 'ES_II'
                        WHEN substring(ilicode FROM 6) = 'Empfindlichkeitsstufe_III'
                            THEN 'ES_III'
                        WHEN substring(ilicode FROM 6) = 'Empfindlichkeitsstufe_IV'
                            THEN 'ES_IV'
                END
        END AS empfindlichkeitsstufe,
        CASE 
            WHEN position('aufgestuft' IN ilicode) != 0
                THEN TRUE
            ELSE
                FALSE
        END as aufgestuft,
        'Nutzungsplanfestlegung' AS verbindlichkeit /* Annahme */
    FROM
        arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche
    WHERE
        ilicode IN 
        (
            'N680_Empfindlichkeitsstufe_I', 
            'N681_Empfindlichkeitsstufe_II', 
            'N682_Empfindlichkeitsstufe_II_aufgestuft', 
            'N683_Empfindlichkeitsstufe_III', 
            'N684_Empfindlichkeitsstufe_III_aufgestuft', 
            'N685_Empfindlichkeitsstufe_IV',
            'N686_keine_Empfindlichkeitsstufe'
        )
)
,
geobasisdaten_typ_insert AS 
(
    INSERT INTO arp_laermempfindlichkeit_mgdm.geobasisdaten_typ 
    (
        t_id,
        code,
        bezeichnung,        
        abkuerzung,
        empfindlichkeitsstufe,
        aufgestuft,
        verbindlichkeit
    )
    SELECT 
        t_id,
        code,        
        bezeichnung,
        abkuerzung,
        empfindlichkeitsstufe,
        aufgestuft,
        verbindlichkeit
    FROM 
        geobasisdaten_typ
   RETURNING *
)
,
zonenflaeche AS 
(
    INSERT INTO arp_laermempfindlichkeit_mgdm.geobasisdaten_laermempfindlichkeit_zonenflaeche
    (
        geometrie,
        rechtsstatus,
        publiziertab,
        bemerkungen,
        es
    )
    SELECT
        flaeche.geometrie, 
        flaeche.rechtsstatus,  
        flaeche.publiziertab,
        flaeche.bemerkungen,
        mgdm_typ.t_id
    FROM
        arp_npl.nutzungsplanung_ueberlagernd_flaeche AS flaeche
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ
        ON flaeche.typ_ueberlagernd_flaeche = typ.t_id
        LEFT JOIN geobasisdaten_typ AS mgdm_typ
        ON mgdm_typ.bezeichnung = typ.typ_kt
    WHERE
        typ.typ_kt IN 
        (
            'N680_Empfindlichkeitsstufe_I', 
            'N681_Empfindlichkeitsstufe_II', 
            'N682_Empfindlichkeitsstufe_II_aufgestuft', 
            'N683_Empfindlichkeitsstufe_III', 
            'N684_Empfindlichkeitsstufe_III_aufgestuft', 
            'N685_Empfindlichkeitsstufe_IV',
            'N686_keine_Empfindlichkeitsstufe'
        )
    AND
        flaeche.rechtsstatus = 'inKraft'
    RETURNING *
)
SELECT 1 AS foo
;
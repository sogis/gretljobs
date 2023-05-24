-- CTE braucht es, damit man anschliessend nur auf Punkttypen
-- joined und nicht auf andere Typen mit dem gleiche Code.

-- Das leere xtf, welches importiert wird um t_basket und t_dataset zu erhalten, hat ein Dataset namens data. Das wird hier zur bfsnr korrigiert. 
UPDATE 
    arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset 
SET 
    datasetname = ${bfsnr_param}
WHERE 
    datasetname = 'data'
;

WITH typ_kt_grundnutzung AS (
    INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ_kt
        (
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        catalogue_ch
        )
    SELECT
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
        ) AS t_datasetname,
        substring(ilicode FROM 2 FOR 3) AS code, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS catalogue_ch
    FROM
        arp_nutzungsplanung_v1.nutzungsplanung_np_typ_kanton_grundnutzung AS grundnutzung
        LEFT JOIN arp_nutzungsplanung_mgdm_v1.catalogue_ch_catalogue_ch AS hauptnutzung
        ON hauptnutzung.acode::text = substring(ilicode FROM 2 FOR 2)
    RETURNING *  
)

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ 
    (
        t_id,
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        nutzungsziffer,
        nutzungsziffer_art,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
    ) AS t_datasetname,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.nutzungsziffer,
    typ.nutzungsziffer_art,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_grundnutzung AS typ
    LEFT JOIN typ_kt_grundnutzung AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
WHERE 
    typ.t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_grundnutzung_zonenflaeche 
    (
        t_id,
        t_basket,
        t_datasetname,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )
SELECT 
    t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
    ) AS t_datasetname,
    geometrie, 
    COALESCE(publiziertab,now()) AS publiziertab,
    rechtsstatus,
    bemerkungen,
    typ_grundnutzung
FROM 
    (
        SELECT 
            t_id,
            t_basket,
            t_datasetname,
            ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(geometrie, 0.001))), 3), 1) AS geometrie,
            publiziertab,
            rechtsstatus,
            bemerkungen,
            typ_grundnutzung
        FROM 
            arp_nutzungsplanung_v1.nutzungsplanung_grundnutzung
    ) AS grundnutzung
WHERE 
    ST_Area(geometrie) > 0
    AND 
    t_datasetname::int4 = ${bfsnr_param}
;

WITH typ_kt_flaeche AS (
    INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ_kt
        (
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        catalogue_ch
        )
    SELECT
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
        ) AS t_datasetname,
        substring(ilicode FROM 2 FOR 3) AS code, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS catalogue_ch
    FROM
        arp_nutzungsplanung_v1.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche AS flaeche
        LEFT JOIN arp_nutzungsplanung_mgdm_v1.catalogue_ch_catalogue_ch AS hauptnutzung
        ON hauptnutzung.acode::text = substring(ilicode FROM 2 FOR 2)
    WHERE 
        substring(ilicode FROM 2 FOR 3) 
        NOT IN 
        (
            '593', 
            '594', 
            '595', 
            '596', 
            '680', 
            '680', 
            '680', 
            '681', 
            '682', 
            '683', 
            '684', 
            '685', 
            '686'
        )
        -- 800er-Werte für Flächen müssen dem MGDM-Wert 69 zugewiesen werden.
        AND 
            substring(ilicode FROM 2 FOR 3)::int < 800
  
        UNION 
  
    SELECT
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
        ) AS t_datasetname,
        substring(ilicode FROM 2 FOR 3) AS code, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS catalogue_ch
        FROM
            arp_nutzungsplanung_v1.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche AS flaeche
            LEFT JOIN 
            (
                SELECT 
                    t_id
                FROM
                    arp_nutzungsplanung_mgdm_v1.catalogue_ch_catalogue_ch
                WHERE
                    acode = 69
            ) AS hauptnutzung
            ON 
                1=1
        WHERE 
            substring(ilicode FROM 2 FOR 3)::int >= 800
    RETURNING *  
)

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ 
    (
        t_id,
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
    ) AS t_datasetname,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_flaeche AS typ 
    JOIN typ_kt_flaeche AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
WHERE 
    typ.t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_ueberlagernde_festlegung
    (
        t_id,
        t_basket,
        t_datasetname,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )

SELECT 
    t_id,
    t_basket,
    t_datasetname,
    geometrie, 
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ_grundnutzung AS typ
FROM 
    (
        SELECT 
            flaeche.t_id,
            (SELECT 
                 t_id 
             FROM 
                 arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
             WHERE 
                 topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
            ) AS t_basket, 
            (SELECT 
                 datasetname 
             FROM 
                 arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
             WHERE 
                 t_id = (SELECT 
                             dataset 
                         FROM 
                             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                         WHERE 
                             topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
            ) AS t_datasetname,
            ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(flaeche.geometrie, 0.001))), 3), 1) AS geometrie,
            COALESCE(flaeche.publiziertab, now()) publiziertab,
            flaeche.rechtsstatus,
            flaeche.bemerkungen,
            typ.t_id AS typ_grundnutzung
        FROM 
            arp_nutzungsplanung_v1.nutzungsplanung_ueberlagernd_flaeche AS flaeche
            JOIN arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ AS typ 
            ON flaeche.typ_ueberlagernd_flaeche = typ.t_id 
    ) AS flaeche
WHERE 
    ST_Area(geometrie) > 0
    AND 
    t_datasetname::int4 = ${bfsnr_param}
;

WITH typ_kt_linie AS (
    INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ_kt
        (
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        catalogue_ch
        )
    SELECT
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
        ) AS t_datasetname,
        substring(ilicode FROM 2 FOR 3) AS code, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS catalogue_ch
    FROM
        arp_nutzungsplanung_kanton_v1.nutzungsplanung_np_typ_kanton_ueberlagernd_linie AS linie
        LEFT JOIN arp_nutzungsplanung_mgdm_v1.catalogue_ch_catalogue_ch AS hauptnutzung
        ON hauptnutzung.acode::text = substring(ilicode FROM 2 FOR 2)
    WHERE 
        substring(ilicode FROM 2 FOR 3) 
        NOT IN 
        (
        '792', 
        '793'
        )
    RETURNING *
)
INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ 
    (
        t_id,
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
    ) AS t_datasetname,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_linie  AS typ 
    JOIN typ_kt_linie AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
WHERE 
    typ.t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_linienbezogene_festlegung  
    (
        t_id,
        t_basket, 
        t_datasetname,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )
SELECT 
    t_id,
    t_basket,
    t_datasetname,
    ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(foo.geometrie, 0.001))), 2), 1) AS geometrie,
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ_ueberlagernd_linie
FROM 
    (
        SELECT 
            linie.t_id,        
            (SELECT 
                 t_id 
             FROM 
                 arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
             WHERE 
                 topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
            ) AS t_basket, 
            (SELECT 
                 datasetname 
             FROM 
                 arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
             WHERE 
                 t_id = (SELECT 
                             dataset 
                         FROM 
                             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                         WHERE 
                             topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
            ) AS t_datasetname,
            ST_GeometryFromText(regexp_replace(regexp_replace(ST_AsText(geometrie),'(NaN NaN)+,*','','g'),',\)$',')'), 2056) AS geometrie,
            linie.publiziertab,
            linie.rechtsstatus,
            linie.bemerkungen,
            typ.t_id AS typ_ueberlagernd_linie 
        FROM 
            arp_nutzungsplanung_v1.nutzungsplanung_ueberlagernd_linie  AS linie
            JOIN arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ AS typ 
            ON linie.typ_ueberlagernd_linie = typ.t_id             
    ) AS foo
WHERE 
    t_datasetname::int4 = ${bfsnr_param}
;

WITH typ_kt_linie_erschliessung AS (
    INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ_kt
        (
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        catalogue_ch
        )
    SELECT
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
        ) AS t_datasetname,
        substring(ilicode FROM 2 FOR 3) AS code, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS catalogue_ch
    FROM
        arp_nutzungsplanung_v1.erschlssngsplnung_ep_typ_kanton_erschliessung_linienobjekt AS linie
        LEFT JOIN arp_nutzungsplanung_mgdm_v1.catalogue_ch_catalogue_ch AS hauptnutzung
        ON hauptnutzung.acode::INTEGER in (71,71,73,74,75,76,77,78) --Ganzer range der Baulinien
    WHERE 
        hauptnutzung.t_ili_tid IS NOT NULL 
    RETURNING *
)

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ 
    (
        t_id,
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
    ) AS t_datasetname,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_linienobjekt AS typ 
    JOIN typ_kt_linie_erschliessung AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
WHERE 
    typ.t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_linienbezogene_festlegung  
    (
        t_id,
        t_basket, 
        t_datasetname,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )
SELECT 
    t_id,
    t_basket, 
    t_datasetname,
    ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(foo.geometrie, 0.001))), 2), 1) AS geometrie,
    COALESCE(publiziertab,now()) AS publiziertab, 
    rechtsstatus,
    bemerkungen,
    typ_erschliessung_linie
FROM 
    (
        SELECT 
            linie.t_id,        
            (SELECT 
                 t_id 
             FROM 
                 arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
             WHERE 
                 topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
            ) AS t_basket, 
            (SELECT 
                 datasetname 
             FROM 
                 arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
             WHERE 
                 t_id = (SELECT 
                             dataset 
                         FROM 
                             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                         WHERE 
                             topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
            ) AS t_datasetname,
            ST_GeometryFromText(regexp_replace(regexp_replace(ST_AsText(geometrie),'(NaN NaN)+,*','','g'),',\)$',')'), 2056) AS geometrie,
            linie.publiziertab,
            linie.rechtsstatus,
            linie.bemerkungen,
            typ.t_id AS typ_erschliessung_linie 
        FROM 
            arp_nutzungsplanung_v1.erschlssngsplnung_erschliessung_linienobjekt  AS linie
            JOIN arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ AS typ 
            ON linie.typ_erschliessung_linienobjekt = typ.t_id             
    ) AS foo
WHERE 
    t_datasetname::int4 = ${bfsnr_param}
;

--HIER 

WITH typ_kt_ueberlagernd_punkt AS (
    INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ_kt
        (
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        catalogue_ch
        )
    SELECT
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
        ) AS t_datasetname,
        substring(ilicode FROM 2 FOR 3) AS acode, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS hauptnutzung_ch
    FROM
        arp_nutzungsplanung_v1.nutzungsplanung_np_typ_kanton_ueberlagernd_punkt AS punkt
        LEFT JOIN arp_nutzungsplanung_mgdm_v1.catalogue_ch_catalogue_ch AS hauptnutzung
        ON hauptnutzung.acode::text = substring(ilicode FROM 2 FOR 2)
    RETURNING *
)

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ 
    (
        t_id,
        t_basket, 
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
    ) AS t_datasetname,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_punkt AS typ 
    JOIN typ_kt_ueberlagernd_punkt AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
WHERE 
    typ.t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_mgdm_v1.geobasisdaten_objektbezogene_festlegung 
    (
        t_id,
        t_basket, 
        t_datasetname,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )
SELECT 
    punkt.t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Geobasisdaten'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Geobasisdaten')
    ) AS t_datasetname,
    punkt.geometrie,
    punkt.publiziertab,
    punkt.rechtsstatus,
    punkt.bemerkungen,
    typ.t_id 
FROM 
    arp_nutzungsplanung_v1.nutzungsplanung_ueberlagernd_punkt AS punkt
    JOIN arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ AS typ 
    ON punkt.typ_ueberlagernd_punkt = typ.t_id 
WHERE 
    punkt.t_datasetname::int4 = ${bfsnr_param}
;


-- DOKUMENTE
INSERT INTO arp_nutzungsplanung_mgdm_v1.rechtsvorschrften_dokument 
    ( 
        t_id,
        t_basket,
        t_datasetname,
        t_ili_tid,
        typ,
        titel,
        abkuerzung, 
        offiziellenr,
        auszugindex,
        rechtsstatus,
        publiziertab,
        publiziertbis 
    )
SELECT
    t_id,
    (SELECT 
         t_id 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
     WHERE 
         topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften'
    ) AS t_basket, 
    (SELECT 
         datasetname 
     FROM 
         arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
     WHERE 
         t_id = (SELECT 
                     dataset 
                 FROM 
                     arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                 WHERE 
                     topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften')
    ) AS t_datasetname,
    t_ili_tid,
    'Rechtsvorschrift' AS typ, 
    titel||', '||offiziellertitel AS titel,
    abkuerzung, 
    offiziellenr,
    CASE WHEN titel = 'Regierungsratsbeschluss' THEN 999 ELSE 998 END AS auszugindex, 
    rechtsstatus,
    publiziertab, 
    publiziertbis 
FROM 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument
WHERE 
    rechtsvorschrift IS TRUE 
    AND 
    t_datasetname::int4 = ${bfsnr_param}
;

WITH multilingualuri AS
(
    INSERT INTO
        arp_nutzungsplanung_mgdm_v1.multilingualuri
        (
            t_id,
            t_basket,
            t_datasetname,
            t_seq,
            rechtsvrschrftn_dkment_textimweb
        )
    SELECT
        nextval('arp_nutzungsplanung_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften')
        ) AS t_datasetname,
        0 AS t_seq,
        rechtsvorschrften_dokument.t_id AS rechtsvrschrftn_dkment_textimweb
    FROM
        arp_nutzungsplanung_mgdm_v1.rechtsvorschrften_dokument AS rechtsvorschrften_dokument
    WHERE 
        t_datasetname::int4 = ${bfsnr_param} 
    RETURNING *
)
,
localiseduri AS 
(
    SELECT 
        nextval('arp_nutzungsplanung_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften')
        ) AS t_datasetname,      
        0 AS t_seq,
        'de' AS alanguage,
        textimweb AS atext,
        multilingualuri.t_id AS multilingualuri_localisedtext
    FROM
        arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS rechtsvorschrften_dokument
        RIGHT JOIN multilingualuri 
        ON multilingualuri.rechtsvrschrftn_dkment_textimweb = rechtsvorschrften_dokument.t_id
    WHERE 
        rechtsvorschrften_dokument.t_datasetname::int4 = ${bfsnr_param}
)
INSERT INTO
    arp_nutzungsplanung_mgdm_v1.localiseduri
    (
        t_id,
        t_basket,
        t_datasetname,
        t_seq,
        alanguage,
        atext,
        multilingualuri_localisedtext
    )
    SELECT 
        t_id,
        t_basket,
        t_datasetname,
        t_seq,
        alanguage,
        coalesce (atext,'https://planregister-data.so.ch/public/kanton/Dokument-nicht-digital-verfuegbar.pdf') AS atext, --Wenn kein Dokument vorhanden, soll auf dieses Dokument verwiesen werden,
        multilingualuri_localisedtext
    FROM 
        localiseduri
;

INSERT INTO 
    arp_nutzungsplanung_mgdm_v1.geobasisdaten_typ_dokument
    (
        t_id,
        t_basket,
        t_datasetname,
        typ, 
        dokument
    )
    SELECT
        t_id, 
        (SELECT 
             t_id 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_nutzungsplanung_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_nutzungsplanung_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Nutzungsplanung_V1_2.Rechtsvorschriften')
        ) AS t_datasetname,   
        typ_grundnutzung AS typ, 
        dokument 
    FROM 
        arp_nutzungsplanung_v1.nutzungsplanung_typ_grundnutzung_dokument 
    WHERE 
        t_datasetname = ${bfsnr_param}::TEXT 
;


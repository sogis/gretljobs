-- CTE braucht es, damit man anschliessend nur auf Punkttypen
-- joined und nicht auf andere Typen mit dem gleiche Code.

WITH typ_kt_grundnutzung AS (
    INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
        (
        acode,
        bezeichnung,
        abkuerzung,
        hauptnutzung_ch
        )
    SELECT
        substring(ilicode FROM 2 FOR 3) AS code, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS hauptnutzung_ch
    FROM
        arp_npl.nutzungsplanung_np_typ_kanton_grundnutzung AS grundnutzung
        LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON hauptnutzung.acode::text = substring(ilicode FROM 2 FOR 2)
    RETURNING *  
)
INSERT INTO arp_npl_mgdm.geobasisdaten_typ 
    (
        t_id,
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
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.nutzungsziffer,
    typ.nutzungsziffer_art,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_npl.nutzungsplanung_typ_grundnutzung AS typ
    LEFT JOIN typ_kt_grundnutzung AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
;

INSERT INTO arp_npl_mgdm.geobasisdaten_grundnutzung_zonenflaeche 
    (
        t_id,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )
SELECT 
    t_id,
    geometrie, 
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ_grundnutzung
FROM 
    (
        SELECT 
            t_id,
            ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(geometrie, 0.001))), 3), 1) AS geometrie,
            publiziertab,
            rechtsstatus,
            bemerkungen,
            typ_grundnutzung
        FROM 
            arp_npl.nutzungsplanung_grundnutzung
        WHERE 
            t_datasetname <> '2403'
    ) AS grundnutzung
WHERE 
    ST_Area(geometrie) > 0
;

WITH typ_kt_flaeche AS (
    INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
        (
            acode,
            bezeichnung,
            abkuerzung,
            hauptnutzung_ch
        )
    SELECT
        substring(ilicode FROM 2 FOR 3) AS acode, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS hauptnutzung_ch
    FROM
        arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche AS flaeche
        LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung 
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
            substring(ilicode FROM 2 FOR 3) AS acode, 
            replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
            substring(ilicode FROM 1 FOR 4) AS abkuerzung,
            hauptnutzung.t_id AS hauptnutzung_ch
        FROM
            arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche AS flaeche
            LEFT JOIN 
            (
                SELECT 
                    t_id
                FROM
                    arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch
                WHERE
                    acode = 69
            ) AS hauptnutzung
            ON 
                1=1
        WHERE 
            substring(ilicode FROM 2 FOR 3)::int >= 800
    RETURNING *  
)

INSERT INTO arp_npl_mgdm.geobasisdaten_typ 
    (
        t_id,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ 
    JOIN typ_kt_flaeche AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
;

INSERT INTO arp_npl_mgdm.geobasisdaten_ueberlagernde_festlegung 
    (
        t_id,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )

SELECT 
    t_id,
    geometrie, 
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ_grundnutzung
FROM 
    (
        SELECT 
            flaeche.t_id,
            ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(flaeche.geometrie, 0.001))), 3), 1) AS geometrie,
            flaeche.publiziertab,
            flaeche.rechtsstatus,
            flaeche.bemerkungen,
            typ.t_id AS typ_grundnutzung
        FROM 
            arp_npl.nutzungsplanung_ueberlagernd_flaeche AS flaeche
            JOIN arp_npl_mgdm.geobasisdaten_typ AS typ 
            ON flaeche.typ_ueberlagernd_flaeche = typ.t_id 
        WHERE 
            flaeche.t_datasetname <> '2403'
    ) AS flaeche
WHERE 
    ST_Area(geometrie) > 0
;
WITH typ_kt_linie AS (
    INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
        (
            acode,
            bezeichnung,
            abkuerzung,
            hauptnutzung_ch
        )
    SELECT
        substring(ilicode FROM 2 FOR 3) AS acode, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS hauptnutzung_ch
    FROM
        arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_linie AS linie
        LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
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
INSERT INTO arp_npl_mgdm.geobasisdaten_typ 
    (
        t_id,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS typ 
    JOIN typ_kt_linie AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
;

INSERT INTO arp_npl_mgdm.geobasisdaten_linienbezogene_festlegung 
    (
        t_id,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )
SELECT 
    t_id,
    ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(foo.geometrie, 0.001))), 2), 1) AS geometrie,
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ_ueberlagernd_linie
FROM 
    (
        SELECT 
            linie.t_id,            
            ST_GeometryFromText(regexp_replace(regexp_replace(ST_AsText(geometrie),'(NaN NaN)+,*','','g'),',\)$',')'), 2056) AS geometrie,
            linie.publiziertab,
            linie.rechtsstatus,
            linie.bemerkungen,
            typ.t_id AS typ_ueberlagernd_linie 
        FROM 
            arp_npl.nutzungsplanung_ueberlagernd_linie AS linie
            JOIN arp_npl_mgdm.geobasisdaten_typ AS typ 
            ON linie.typ_ueberlagernd_linie = typ.t_id             
        WHERE 
            linie.t_datasetname <> '2403'

    ) AS foo
-- SELECT 
--     linie.t_id,
--     ST_GeometryN(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(linie.geometrie, 0.001))), 2), 1) AS geometrie,
--     linie.publiziertab,
--     linie.rechtsstatus,
--     linie.bemerkungen,
--     typ.t_id 
-- FROM 
--     arp_npl.nutzungsplanung_ueberlagernd_linie AS linie
--     JOIN arp_npl_mgdm.geobasisdaten_typ AS typ 
--     ON linie.typ_ueberlagernd_linie = typ.t_id 
;

WITH typ_kt_ueberlagernd_punkt AS (
    INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
        (
            acode,
            bezeichnung,
            abkuerzung,
            hauptnutzung_ch
        )
    SELECT
        substring(ilicode FROM 2 FOR 3) AS acode, 
        replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
        substring(ilicode FROM 1 FOR 4) AS abkuerzung,
        hauptnutzung.t_id AS hauptnutzung_ch
    FROM
        arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_punkt AS punkt
        LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON hauptnutzung.acode::text = substring(ilicode FROM 2 FOR 2)
    RETURNING *
)

INSERT INTO arp_npl_mgdm.geobasisdaten_typ 
    (
        t_id,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit,
        bemerkungen,
        typ_kt 
    )
SELECT 
    typ.t_id,
    typ.code_kommunal AS acode,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id
    
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS typ 
    JOIN typ_kt_ueberlagernd_punkt AS typ_kt
    ON typ_kt.acode = substring(typ.typ_kt FROM 2 FOR 3)
;

INSERT INTO arp_npl_mgdm.geobasisdaten_objektbezogene_festlegung 
    (
        t_id,
        geometrie,
        publiziertab,
        rechtsstatus,
        bemerkungen,
        typ
    )
SELECT 
    punkt.t_id,
    punkt.geometrie,
    punkt.publiziertab,
    punkt.rechtsstatus,
    punkt.bemerkungen,
    typ.t_id 
FROM 
    arp_npl.nutzungsplanung_ueberlagernd_punkt AS punkt
    JOIN arp_npl_mgdm.geobasisdaten_typ AS typ 
    ON punkt.typ_ueberlagernd_punkt = typ.t_id 
WHERE 
    punkt.t_datasetname <> '2403'
;

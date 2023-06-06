/*Das leere xtf, welches importiert wird um t_basket und t_dataset zu erhalten, hat ein Dataset namens data. Das wird hier zur bfsnr korrigiert. */
UPDATE 
    arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_dataset 
SET 
    datasetname = ${bfsnr_param}
WHERE 
    datasetname = 'data'
;

WITH basket AS (     
    SELECT 
    
        t_id 
    FROM 
        arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
    WHERE 
        topic = 'Laermempfindlichkeitsstufen_V1_2.Geobasisdaten'
)

INSERT INTO 
    arp_laermempfindlichkeitsstufen_mgdm_v1.geobasisdaten_typ 
    (
        t_id,
        t_basket,
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        empfindlichkeitsstufe,
        aufgestuft,
        verbindlichkeit 
    )
SELECT
    laermmpfhktsstfen_typ_empfindlichkeitsstufe.t_id,
    basket.t_id AS t_basket, 
    ${bfsnr_param} AS t_datasetname,
    substring(typ_kt FROM 2 FOR 3) || '0' AS acode,        
    bezeichnung AS bezeichnung, 
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
    verbindlichkeit
FROM
    arp_nutzungsplanung_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe, 
    basket
WHERE
    typ_kt IN 
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
        t_datasetname::int4 = ${bfsnr_param}
;

WITH basket AS (     
    SELECT 
        t_id 
    FROM 
        arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
    WHERE 
        topic = 'Laermempfindlichkeitsstufen_V1_2.Geobasisdaten'
)

INSERT INTO arp_laermempfindlichkeitsstufen_mgdm_v1.geobasisdaten_laermempfindlichkeit_zonenflaeche
(
    t_basket,
    t_datasetname,
    geometrie,
    rechtsstatus,
    publiziertab,
    bemerkungen,
    typ
)
SELECT 
    basket.t_id AS t_basket, 
    ${bfsnr_param} AS t_datasetname,
    geometrie,
    rechtsstatus,
    publiziertab,
    bemerkungen,
    typ 
FROM 
(
    SELECT 
	    DISTINCT ON (flaeche.t_id) --Wenn es mehrere Typen mit der gleichen Bezeichnung (typ.bezeichnung) gibt, werden die Geometrien verdoppelt. Vielleicht anders lösen bar als mit DISTINCT.
        flaeche.geometrie AS geometrie,
        flaeche.rechtsstatus,  
        flaeche.publiziertab,
        flaeche.bemerkungen,
        mgdm_typ.t_id AS typ
    FROM
        arp_nutzungsplanung_v1.laermmpfhktsstfen_empfindlichkeitsstufe  AS flaeche
        LEFT JOIN arp_nutzungsplanung_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe typ 
        ON flaeche.typ_empfindlichkeitsstufen = typ.t_id
        LEFT JOIN arp_laermempfindlichkeitsstufen_mgdm_v1.geobasisdaten_typ AS mgdm_typ
        ON mgdm_typ.bezeichnung = typ.bezeichnung
    WHERE
        flaeche.rechtsstatus = 'inKraft'
    AND 
        flaeche.t_datasetname::int4 = ${bfsnr_param}
) as foo,
    basket

;

-- DOKUMENTE

WITH basket AS (     
    SELECT 
        t_id 
    FROM 
        arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
    WHERE 
        topic = 'Laermempfindlichkeitsstufen_V1_2.Rechtsvorschriften'
)

INSERT INTO arp_laermempfindlichkeitsstufen_mgdm_v1.rechtsvorschrften_dokument 
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
    dok.t_id,
    basket.t_id AS t_basket, 
    ${bfsnr_param} AS t_datasetname,
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
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument dok,
    basket    
WHERE 
    rechtsvorschrift IS TRUE 
    AND 
    t_datasetname::int4 = ${bfsnr_param}
    AND 
    rechtsstatus IN (
                     SELECT
                         ilicode 
                     FROM 
                         arp_laermempfindlichkeitsstufen_mgdm_v1.rechtsstatus
                    )
;

WITH multilingualuri AS
(
    INSERT INTO
        arp_laermempfindlichkeitsstufen_mgdm_v1.multilingualuri
        (
            t_id,
            t_basket,
            t_datasetname,
            t_seq,
            rechtsvrschrftn_dkment_textimweb
        )
    SELECT
        nextval('arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        (SELECT 
             t_id 
         FROM 
             arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Laermempfindlichkeitsstufen_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Laermempfindlichkeitsstufen_V1_2.Rechtsvorschriften')
        ) AS t_datasetname,
        0 AS t_seq,
        rechtsvorschrften_dokument.t_id AS rechtsvrschrftn_dkment_textimweb
    FROM
        arp_laermempfindlichkeitsstufen_mgdm_v1.rechtsvorschrften_dokument AS rechtsvorschrften_dokument
    WHERE 
        t_datasetname = ${bfsnr_param}::TEXT 
    RETURNING *
)
,
localiseduri AS 
(
    SELECT 
        nextval('arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        (SELECT 
             t_id 
         FROM 
             arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Laermempfindlichkeitsstufen_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        ${bfsnr_param} AS t_datasetname,      
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
    arp_laermempfindlichkeitsstufen_mgdm_v1.localiseduri
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
        coalesce (atext,'https://planregister-data.so.ch/public/kanton/Dokument-nicht-digital-verfuegbar.pdf') AS atext, --Wenn kein Dokument vorhanden, soll auf dieses Dokument verwiesen werden.
        multilingualuri_localisedtext
    FROM 
        localiseduri
;

INSERT INTO 
    arp_laermempfindlichkeitsstufen_mgdm_v1.geobasisdaten_typ_dokument
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
             arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Laermempfindlichkeitsstufen_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_laermempfindlichkeitsstufen_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Laermempfindlichkeitsstufen_V1_2.Rechtsvorschriften')
        ) AS t_datasetname,   
        typ_empfindlichkeitsstufen AS typ, 
        dokument 
    FROM 
        arp_nutzungsplanung_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe_dokument
    WHERE 
        t_datasetname = ${bfsnr_param}::TEXT 
;

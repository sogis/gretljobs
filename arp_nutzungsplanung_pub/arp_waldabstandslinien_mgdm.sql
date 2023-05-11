/*Das leere xtf, welches importiert wird um t_basket und t_dataset zu erhalten, hat ein Dataset namens data. Das wird hier zur bfsnr korrigiert. */
UPDATE 
    arp_waldabstandslinien_mgdm_v1.t_ili2db_dataset 
SET 
    datasetname = ${bfsnr_param}
WHERE 
    datasetname = 'data'
;

WITH basket AS (     
    SELECT 
    
        t_id 
    FROM 
        arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
    WHERE 
        topic = 'Waldabstandslinien_V1_2.Geobasisdaten'
)

INSERT INTO 
    arp_waldabstandslinien_mgdm_v1.geobasisdaten_typ 
    (
        t_id,
        t_basket,
        t_datasetname,
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit
    ) 
SELECT 
    erschliessung.t_id,
    basket.t_id AS t_basket, 
    ${bfsnr_param} AS t_datasetname,
    substring(typ_kt FROM 2 FOR 3) AS acode, 
    typ_kt AS bezeichnung, 
    substring(typ_kt FROM 1 FOR 4) AS abkuerzung,
    'Nutzungsplanfestlegung' AS verbindlichkeit
FROM 
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_linienobjekt erschliessung, 
    basket
WHERE
    typ_kt = 'E725_Waldabstandslinie'
    AND 
    t_datasetname::int4 = ${bfsnr_param}
;

WITH basket AS (     
    SELECT 
    
        t_id 
    FROM 
        arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
    WHERE 
        topic = 'Waldabstandslinien_V1_2.Geobasisdaten'
)

INSERT INTO
    arp_waldabstandslinien_mgdm_v1.geobasisdaten_waldabstand_linie 
    (
        t_basket,
        t_datasetname,
        geometrie,
        rechtsstatus,
        publiziertab,
        bemerkungen,
        wal
    )
SELECT 
    basket.t_id AS t_basket, 
    ${bfsnr_param} AS t_datasetname,
    linienobjekt.geometrie,
    linienobjekt.rechtsstatus,
    linienobjekt.publiziertab,
    linienobjekt.bemerkungen,
    mgdm_typ.t_id AS wal
FROM 
    basket,
    arp_nutzungsplanung_v1.erschlssngsplnung_erschliessung_linienobjekt  AS linienobjekt
    LEFT JOIN arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_linienobjekt AS typ 
    ON typ.t_id = linienobjekt.typ_erschliessung_linienobjekt 
    LEFT JOIN arp_waldabstandslinien_mgdm_v1.geobasisdaten_typ AS mgdm_typ
    ON typ.typ_kt = mgdm_typ.bezeichnung 
WHERE
    typ.typ_kt = 'E725_Waldabstandslinie'
    AND 
    linienobjekt.t_datasetname::int4 = ${bfsnr_param}
;

-- DOKUMENTE

WITH basket AS (     
    SELECT 
        t_id 
    FROM 
        arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
    WHERE 
        topic = 'Waldabstandslinien_V1_2.Rechtsvorschriften'
)

INSERT INTO arp_waldabstandslinien_mgdm_v1.rechtsvorschrften_dokument 
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
;

WITH multilingualuri AS
(
    INSERT INTO
        arp_waldabstandslinien_mgdm_v1.multilingualuri
        (
            t_id,
            t_basket,
            t_datasetname,
            t_seq,
            rechtsvrschrftn_dkment_textimweb
        )
    SELECT
        nextval('arp_waldabstandslinien_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        (SELECT 
             t_id 
         FROM 
             arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Waldabstandslinien_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_waldabstandslinien_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Waldabstandslinien_V1_2.Rechtsvorschriften')
        ) AS t_datasetname,
        0 AS t_seq,
        rechtsvorschrften_dokument.t_id AS rechtsvrschrftn_dkment_textimweb
    FROM
        arp_waldabstandslinien_mgdm_v1.rechtsvorschrften_dokument AS rechtsvorschrften_dokument
    WHERE 
        t_datasetname = ${bfsnr_param}::TEXT 
    RETURNING *
)
,
localiseduri AS 
(
    SELECT 
        nextval('arp_waldabstandslinien_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        (SELECT 
             t_id 
         FROM 
             arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Waldabstandslinien_V1_2.Rechtsvorschriften'
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
    arp_waldabstandslinien_mgdm_v1.localiseduri
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
        atext,
        multilingualuri_localisedtext
    FROM 
        localiseduri
;

INSERT INTO 
    arp_waldabstandslinien_mgdm_v1.geobasisdaten_typ_dokument
    (
        t_id,
        t_basket,
        t_datasetname,
        typ, 
        vorschrift --WIESO HEISST DAS NICHT "dokument" wie sonst überall? 
    )
    SELECT
        t_id, 
        (SELECT 
             t_id 
         FROM 
             arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
         WHERE 
             topic = 'Waldabstandslinien_V1_2.Rechtsvorschriften'
        ) AS t_basket, 
        (SELECT 
             datasetname 
         FROM 
             arp_waldabstandslinien_mgdm_v1.t_ili2db_dataset tid 
         WHERE 
             t_id = (SELECT 
                         dataset 
                     FROM 
                         arp_waldabstandslinien_mgdm_v1.t_ili2db_basket 
                     WHERE 
                         topic = 'Waldabstandslinien_V1_2.Rechtsvorschriften')
        ) AS t_datasetname,   
        typ_erschliessung_linienobjekt  AS typ, 
        dokument 
    FROM 
        arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument
    WHERE 
        t_datasetname = ${bfsnr_param}::TEXT 
        and 
        typ_erschliessung_linienobjekt in (select t_id from arp_waldabstandslinien_mgdm_v1.geobasisdaten_typ)
;
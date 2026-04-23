INSERT INTO afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_dokument  (
    t_id, 
    typ, 
    titel, 
    titel_de, 
    abkuerzung, 
    offiziellenr, 
    nuringemeinde, 
    auszugindex, 
    rechtsstatus, 
    publiziertab
)

SELECT 
    t_id, 
    art, 
    offiziellertitel, 
    titel,
    abkuerzung, 
    offiziellenr, 
    gemeinde, 
    '0' AS auszugindex,
    rechtsstatus, 
    publiziertab
FROM afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument
;

WITH multilingualuri AS
(
    INSERT INTO
        afu_gewaesserschutz_zonen_areale_mgdm_v1.multilingualuri
        (
            basket.basket_t_id,
            t_seq,
            gwszonen_dokument_textimweb        )
    SELECT
        nextval('afu_gewaesserschutz_zonen_areale_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        0 AS t_seq,
        dokumente_dokument.t_id AS gwszonen_dokument_textimweb
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokumente_dokument,
        (
            SELECT 
                t_id AS basket_t_id
            FROM 
                afu_gewaesserschutz_zonen_areale_v1.t_ili2db_basket 

        ) AS basket
    RETURNING *
),

localiseduri AS 
(
    SELECT 
        nextval('afu_gewaesserschutz_zonen_areale_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        basket.basket_t_id,
        0 AS t_seq,
        'de' AS alanguage,
        CASE
            WHEN rechtsvorschrften_dokument.textimweb IS NULL
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/Zonenplaene_pdf/404.pdf'
            ELSE rechtsvorschrften_dokument.textimweb
        END AS atext,
        multilingualuri.t_id AS multilingualuri_localisedtext
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS rechtsvorschrften_dokument
        RIGHT JOIN multilingualuri 
        ON multilingualuri.gwszonen_dokument_textimweb = rechtsvorschrften_dokument.t_id,
        (
            SELECT 
                t_id AS basket_t_id
            FROM 
                afu_gewaesserschutz_zonen_areale_v1.t_ili2db_basket 
        ) AS basket
    WHERE
        art = 'Rechtsvorschrift'
    AND
        rechtsstatus = 'inKraft'
)

INSERT INTO
    afu_gewaesserschutz_zonen_areale_mgdm_v1.localiseduri
    (
        t_id,
        t_seq,
        alanguage,
        atext,
        multilingualuri_localisedtext
    )
    SELECT 
        t_id,
        t_seq,
        alanguage,
        atext,
        multilingualuri_localisedtext
    FROM 
        localiseduri
;


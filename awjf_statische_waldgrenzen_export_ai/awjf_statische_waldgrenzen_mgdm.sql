WITH waldgrenzen AS 
(
    SELECT 
        waldgrenze.*
    FROM 
        awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie AS waldgrenze
    WHERE 
        waldgrenze.rechtsstatus = 'inKraft'
)
,
basket AS 
(
    select 
        t_id
    from 
        awjf_statische_waldgrenze_mgdm_v1.t_ili2db_basket 
    where 
        topic = 'Waldgrenzen_V1_2.Geobasisdaten'
)
,
geobasisdaten_typ AS 
(
    INSERT INTO 
        awjf_statische_waldgrenze_mgdm_v1.geobasisdaten_typ 
        (
            t_id, 
            t_basket, 
            acode,
            bezeichnung,
            abkuerzung,
            verbindlichkeit,
            bemerkungen,
            art
        )
    SELECT 
        DISTINCT ON (typ.t_id)
        typ.t_id as t_id,
        basket.t_id as t_basket,
        CASE 
            WHEN typ.art = 'Nutzungsplanung_in_Bauzonen' THEN 'in_BZ'
            ELSE 'ausserh_BZ'
        END AS acode,
        typ.bezeichnung,
        typ.abkuerzung,
        CASE 
            WHEN typ.verbindlichkeit = 'orientierend' THEN 'Orientierend'
            ELSE typ.verbindlichkeit 
        END AS verbindlichkeit,
        typ.bemerkungen,
        CASE 
            WHEN typ.art = 'Nutzungsplanung_in_Bauzonen' THEN 'in_Bauzonen'
            ELSE 'ausserhalb_Bauzonen'
        END AS art
        
    FROM 
        waldgrenzen
        LEFT JOIN 
            awjf_statische_waldgrenze.geobasisdaten_typ AS typ
            ON 
            typ.t_id = waldgrenze_typ, 
        basket
    WHERE 
    verbindlichkeit = 'Nutzungsplanfestlegung' OR verbindlichkeit = 'orientierend'
)

INSERT INTO 
    awjf_statische_waldgrenze_mgdm_v1.geobasisdaten_waldgrenze_linie 
    (
        t_id,
        t_basket,
        geometrie,
        rechtsstatus,
        publiziertab,
        bemerkungen,
        wg
    )
    SELECT 
        waldgrenzen.t_id as t_id,
        basket.t_id as t_basket,
        geometrie,
        rechtsstatus,
        publiziert_ab,
        bemerkungen,
        waldgrenze_typ
    FROM 
        waldgrenzen, 
        basket
;

-- DOKUMENTE
with basket AS 
(
    select 
        t_id
    from 
        awjf_statische_waldgrenze_mgdm_v1.t_ili2db_basket 
    where 
        topic = 'Waldgrenzen_V1_2.Rechtsvorschriften'
)

INSERT INTO awjf_statische_waldgrenze_mgdm_v1.rechtsvorschrften_dokument 
    ( 
        t_id,
        t_basket,
        typ,
        titel,
        abkuerzung, 
        offiziellenr,
        auszugindex,
        rechtsstatus,
        publiziertab
    )
SELECT
    dokument.t_id,
    basket.t_id AS t_basket, 
    'Rechtsvorschrift' AS typ, 
    offiziellertitel AS titel,
    abkuerzung, 
    offiziellenr,
    CASE WHEN typ = 'RRB' THEN 999 ELSE 998 END AS auszugindex, 
    rechtsstatus,
    publiziert_ab
FROM 
    awjf_statische_waldgrenze.dokumente_dokument dokument, 
    basket
where 
    rechtsstatus in (
                     select 
                         ilicode 
                     from 
                         awjf_statische_waldgrenze_mgdm_v1.rechtsstatus
                     )
;

with basket AS 
(
    select 
        t_id
    from 
        awjf_statische_waldgrenze_mgdm_v1.t_ili2db_basket 
    where 
        topic = 'Waldgrenzen_V1_2.Rechtsvorschriften'
)
,
multilingualuri AS
(
    INSERT INTO
        awjf_statische_waldgrenze_mgdm_v1.multilingualuri
        (
            t_id,
            t_basket,
            t_seq,
            rechtsvrschrftn_dkment_textimweb
        )
    SELECT
        nextval('awjf_statische_waldgrenze_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        basket.t_id AS t_basket,
        0 AS t_seq,
        rechtsvorschrften_dokument.t_id AS rechtsvrschrftn_dkment_textimweb
    FROM
        awjf_statische_waldgrenze.dokumente_dokument AS rechtsvorschrften_dokument,
        basket 
    where 
        rechtsstatus in (
                         select 
                             ilicode 
                         from 
                             awjf_statische_waldgrenze_mgdm_v1.rechtsstatus
                     )
    RETURNING *
),

localiseduri AS 
(
    SELECT 
        nextval('awjf_statische_waldgrenze_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
        basket.t_id AS t_basket,       
        0 AS t_seq,
        'de' AS alanguage,
        text_im_web AS atext,
        multilingualuri.t_id AS multilingualuri_localisedtext
    FROM
        awjf_statische_waldgrenze.dokumente_dokument AS rechtsvorschrften_dokument
        RIGHT JOIN multilingualuri 
        ON multilingualuri.rechtsvrschrftn_dkment_textimweb = rechtsvorschrften_dokument.t_id,
        basket
)

INSERT INTO
    awjf_statische_waldgrenze_mgdm_v1.localiseduri
    (
        t_id,
        t_basket,
        t_seq,
        alanguage,
        atext,
        multilingualuri_localisedtext
    )
    SELECT 
        t_id,
        t_basket,
        t_seq,
        alanguage,
        atext, 
        multilingualuri_localisedtext
    FROM 
        localiseduri
;

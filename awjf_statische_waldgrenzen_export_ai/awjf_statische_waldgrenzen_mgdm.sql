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
geobasisdaten_typ AS 
(
    INSERT INTO 
        awjf_statische_waldgrenzen_mgdm.geobasisdaten_typ 
        (
            t_id, 
            acode,
            bezeichnung,
            abkuerzung,
            verbindlichkeit,
            bemerkungen,
            art
        )
    SELECT 
        DISTINCT ON (typ.t_id)
        typ.t_id,
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
        LEFT JOIN awjf_statische_waldgrenze.geobasisdaten_typ AS typ
        ON typ.t_id = waldgrenzen.waldgrenze_typ
    WHERE 
    verbindlichkeit = 'Nutzungsplanfestlegung' OR verbindlichkeit = 'orientierend'
)
INSERT INTO 
    awjf_statische_waldgrenzen_mgdm.geobasisdaten_waldgrenze_linie 
    (
        t_id,
        geometrie,
        rechtsstatus,
        publiziertab,
        bemerkungen,
        wg
    )
    SELECT 
        t_id,
        geometrie,
        rechtsstatus,
        publiziert_ab,
        bemerkungen,
        waldgrenze_typ
    FROM 
        waldgrenzen 
;
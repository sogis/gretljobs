/*
* Wenn in 'waldgrenzen' gegenueber den aktivierten Gemeinden getestet wird,
* gibt es 1019 Records, sonst 1020. Da alle 107 Gemeinden freigeschaltet sind,
* kann es wohl nur am Geoprocessing liegen.
*/

WITH activated_municipalities AS 
( 
    SELECT 
        gemeinden.gemeinde 
    FROM 
        agi_konfiguration_oerebv2.konfiguration_gemeindemitoerebk AS gemeinden
        LEFT JOIN agi_konfiguration_oerebv2.themaref AS thema 
        ON thema.konfiguratn_gmndmtrebk_themen = gemeinden.t_id
    WHERE 
        thema = 'ch.StatischeWaldgrenzen'
)   
,
waldgrenzen AS 
(
    SELECT 
        waldgrenze.*
        --gemeindegrenze.bfs_gemeindenummer,
        --activated_municipalities.gemeinde
    FROM 
        awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie AS waldgrenze
        --LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
        --ON ST_Intersects(ST_LineInterpolatePoint(waldgrenze.geometrie, 0.5), gemeindegrenze.geometrie)
        --JOIN activated_municipalities
        --ON activated_municipalities.gemeinde = gemeindegrenze.bfs_gemeindenummer 
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
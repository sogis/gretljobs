WITH dokument_plan_waldgrenze AS(
    SELECT
        wald_typ.t_id AS wald_typ_t_id,
        dokument.t_id,
        CASE dokument.typ
            WHEN 'RRB'
                THEN 'Regierungsratsbeschluss'
            ELSE dokument.typ
        END AS planungsinstrument,
        dokument.offiziellertitel AS bezeichnung,
        'Kanton' AS planungsbehoerde,
        gemeinde.gemeindename  AS gemeinde,
        dokument.publiziert_ab AS rechtskraft_ab,
        CASE dokument.rechtsstatus
            WHEN 'inKraft'
                THEN 'in Kraft'
            WHEN 'laufendeAenderung'
                THEN 'Änderung mit Vorwirkungt'
            ELSE 'aufgehoben'
        END AS rechtsstatus,
        dokument.text_im_web AS dokument_url,
        --Encoding von 'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=[["gemeindename","=","' || gemeinde.gemeindename || '"]]'
        'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=%5B%5B%22bfs_gemeindenumme%22,%22=%22,%22' || dokument.gemeinde || '%22%5D%5D' AS karte_url,
        'Amt für Wald, Jagd und Fischerei' AS zustaendige_amt,
        False AS aktuelle_ortsplanung,
        dokument.offiziellenr AS offiziellenr
    FROM
        awjf_statische_waldgrenze.geobasisdaten_typ AS wald_typ
        LEFT JOIN
        awjf_statische_waldgrenze.geobasisdaten_typ_dokument AS dokument_wald_typ ON wald_typ.t_id=dokument_wald_typ.festlegung
            LEFT JOIN  
                awjf_statische_waldgrenze.dokumente_dokument AS dokument ON dokument.t_id=dokument_wald_typ.dokumente 
            LEFT JOIN
                agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde ON dokument.gemeinde=gemeinde.bfs_gemeindenummer
    WHERE 
        dokument.typ ='Waldfeststellungsplan' 
    ),
    
dokument_rrb AS(
    SELECT
        wald_typ.t_id AS t_id_wald,
        dokument.t_id AS t_id_rrb,
        dokument.publiziert_ab AS rrb_datum,
        dokument.offiziellenr AS rrb_nr,
        dokument.text_im_web AS rrb_url
    FROM
        awjf_statische_waldgrenze.geobasisdaten_typ AS wald_typ
        LEFT JOIN
        awjf_statische_waldgrenze.geobasisdaten_typ_dokument AS dokument_wald_typ ON wald_typ.t_id=dokument_wald_typ.festlegung
        left JOIN  
        awjf_statische_waldgrenze.dokumente_dokument AS dokument ON dokument.t_id=dokument_wald_typ.dokumente 
    WHERE 
        dokument.typ ='RRB'
        AND
        dokument.offiziellenr IS NOT NULL -- es gibt Pläne der Nutzungsplanung die erfasst sind unter dem Typ RRB, welche aber keine Nummer haben. RRB haben immer eine Nummer
    )

SELECT 
    --waldfeststellungsplan.t_id AS t_id, automatisch beim Import
    'statische_waldgrenze' AS t_datasetname,
    waldfeststellungsplan.planungsinstrument,
    waldfeststellungsplan.bezeichnung,
    waldfeststellungsplan.planungsbehoerde,
    waldfeststellungsplan.gemeinde,
    waldfeststellungsplan.rechtskraft_ab,
    waldfeststellungsplan.rechtsstatus,
    waldfeststellungsplan.dokument_url,
    rrb.rrb_datum,
    rrb.rrb_nr,
    rrb.rrb_url,
    NULL AS sonderbauvorschrift_url, --Waldfeststellungsplan hat nie eine Sonderbauvorschrift
    waldfeststellungsplan.karte_url,
    waldfeststellungsplan.zustaendige_amt,
    waldfeststellungsplan.aktuelle_ortsplanung,
    waldfeststellungsplan.offiziellenr
FROM 
    dokument_plan_waldgrenze AS waldfeststellungsplan
    LEFT JOIN
    dokument_rrb AS rrb ON waldfeststellungsplan.wald_typ_t_id = rrb.t_id_wald

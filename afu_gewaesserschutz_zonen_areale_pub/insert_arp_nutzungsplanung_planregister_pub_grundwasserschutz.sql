WITH dokument_schutzzonenplan_gws AS(
    --Zonen
    SELECT
        dokument.t_id as dok_t_id,
        dokument.titel AS planungsinstrument,
        dokument.offiziellertitel AS bezeichnung,
        'Gemeinde' AS planungsbehoerde,
        gemeinde.gemeindename AS gemeinde,
        dokument.publiziertab AS rechtskraft_ab,
        CASE dokument.rechtsstatus
            WHEN 'inKraft'
                THEN 'in Kraft'
            WHEN 'laufendeAenderung'
                THEN 'Änderung mit Vorwirkung'
        END AS rechtsstatus,
        dokument.textimweb AS dokument_url,
        --Encoding von 'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=[["gemeindename","=","' || gemeinde.gemeindename || '"]]'
        'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=%5B%5B%22bfs_gemeindenummer%22,%22=%22,%22' || dokument.gemeinde || '%22%5D%5D' AS karte_url,
        'Amt für Umwelt' AS zustaendige_amt,
        False AS aktuelle_ortsplanung,
        dokument.offiziellenr AS offiziellenr,
        zone_dok.gwszone AS zone_id
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
            LEFT JOIN
                agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde ON dokument.gemeinde=gemeinde.bfs_gemeindenummer
            RIGHT JOIN
                afu_gewaesserschutz_zonen_areale_v1.gwszonen_rechtsvorschriftgwszone AS zone_dok ON dokument.t_id = zone_dok.rechtsvorschrift
    WHERE 
        dokument.titel ='Schutzzonenplan' 
        
    UNION

    --Areale
    SELECT
        dokument.t_id as dok_t_id,
        dokument.titel AS planungsinstrument,
        dokument.offiziellertitel AS bezeichnung,
        'Gemeinde' AS planungsbehoerde,
        gemeinde.gemeindename AS gemeinde,
        dokument.publiziertab AS rechtskraft_ab,
        CASE dokument.rechtsstatus
            WHEN 'inKraft'
                THEN 'in Kraft'
            WHEN 'laufendeAenderung'
                THEN 'Änderung mit Vorwirkungt'
        END AS rechtsstatus,
        dokument.textimweb AS dokument_url,
        --Encoding von 'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=[["gemeindename","=","' || gemeinde.gemeindename || '"]]'
        'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=%5B%5B%22bfs_gemeindenummer%22,%22=%22,%22' || dokument.gemeinde || '%22%5D%5D' AS karte_url,
        'Amt für Umwelt' AS zustaendige_amt,
        False AS aktuelle_ortsplanung,
        dokument.offiziellenr AS offiziellenr,
        areal_dok.gwsareal AS zone_id
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
            LEFT JOIN
                agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde ON dokument.gemeinde=gemeinde.bfs_gemeindenummer
            RIGHT JOIN
                afu_gewaesserschutz_zonen_areale_v1.gwszonen_rechtsvorschriftgwsareal AS areal_dok ON dokument.t_id = areal_dok.rechtsvorschrift
    WHERE 
        dokument.titel ='Schutzzonenplan' 
    ),
    
dokument_rrb AS(
    SELECT
        dokument.t_id as dok_t_id,
        dokument.t_id AS t_id_rrb,
        dokument.publiziertab AS rrb_datum,
        dokument.offiziellenr AS rrb_nr,
        dokument.textimweb AS rrb_url,
        zone_dok.gwszone AS zone_id
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
            LEFT JOIN
                afu_gewaesserschutz_zonen_areale_v1.gwszonen_rechtsvorschriftgwszone AS zone_dok ON dokument.t_id = zone_dok.rechtsvorschrift
    WHERE 
        dokument.titel ='Regierungsratsbeschluss' 
        
    UNION
    
    SELECT
        dokument.t_id as dok_t_id,
        dokument.t_id AS t_id_rrb,
        dokument.publiziertab AS rrb_datum,
        dokument.offiziellenr AS rrb_nr,
        dokument.textimweb AS rrb_url,
        areal_dok.gwsareal AS zone_id
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
            RIGHT JOIN
                afu_gewaesserschutz_zonen_areale_v1.gwszonen_rechtsvorschriftgwsareal AS areal_dok ON dokument.t_id = areal_dok.rechtsvorschrift
    WHERE 
        dokument.titel ='Regierungsratsbeschluss'    
   ),

dokument_sbv AS(
    SELECT
        dokument.t_id as dok_t_id,
        dokument.textimweb AS sonderbauvorschrift_url,
        zone_dok.gwszone AS zone_id
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
            LEFT JOIN
                afu_gewaesserschutz_zonen_areale_v1.gwszonen_rechtsvorschriftgwszone AS zone_dok ON dokument.t_id = zone_dok.rechtsvorschrift
    WHERE 
        dokument.titel ='Schutzzonenreglement'
        
UNION

    SELECT
        dokument.t_id as dok_t_id,
        dokument.textimweb AS sonderbauvorschrift_url,
        areal_dok.gwsareal AS zone_id
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
            RIGHT JOIN
                afu_gewaesserschutz_zonen_areale_v1.gwszonen_rechtsvorschriftgwsareal AS areal_dok ON dokument.t_id = areal_dok.rechtsvorschrift
    WHERE 
        dokument.titel ='Schutzzonenreglement'
   )

SELECT
    --schutzzonenplan.t_id AS t_id, automatisch beim Import
    DISTINCT ON (schutzzonenplan.dok_t_id) --Schutzzonenplan ist für jede Zone erfasst deshlab DISTINCT
    'gewaesserschutz' AS t_datasetname,
    schutzzonenplan.planungsinstrument,
    schutzzonenplan.bezeichnung,
    schutzzonenplan.planungsbehoerde,
    schutzzonenplan.gemeinde,
    schutzzonenplan.rechtskraft_ab,
    schutzzonenplan.rechtsstatus,
    schutzzonenplan.dokument_url,
    rrb.rrb_datum,
    rrb.rrb_nr,
    rrb.rrb_url,
    sbv.sonderbauvorschrift_url,
    schutzzonenplan.karte_url,
    schutzzonenplan.zustaendige_amt,
    schutzzonenplan.aktuelle_ortsplanung,
    schutzzonenplan.offiziellenr
FROM
    dokument_schutzzonenplan_gws AS schutzzonenplan
    LEFT JOIN
    dokument_rrb AS rrb ON rrb.zone_id = schutzzonenplan.zone_id
    LEFT JOIN
    dokument_sbv AS sbv ON sbv.zone_id = schutzzonenplan.zone_id
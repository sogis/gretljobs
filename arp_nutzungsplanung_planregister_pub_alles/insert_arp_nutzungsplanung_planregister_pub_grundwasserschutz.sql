WITH dokument_schutzzonenplan_gws AS(
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
        dokument.offiziellenr AS offiziellenr
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
            LEFT JOIN
                agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde ON dokument.gemeinde=gemeinde.bfs_gemeindenummer
    WHERE 
        dokument.titel ='Schutzzonenplan' 
    ),
    
dokument_rrb AS(
    SELECT
        dokument.t_id as dok_t_id,
        dokument.t_id AS t_id_rrb,
        dokument.publiziertab AS rrb_datum,
        dokument.offiziellenr AS rrb_nr,
        dokument.textimweb AS rrb_url
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
    WHERE 
        dokument.titel ='Regierungsratsbeschluss' 

   ),

dokument_sbv AS(
    SELECT
        dokument.t_id as dok_t_id,
        dokument.textimweb AS sonderbauvorschrift_url
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokument
    WHERE 
        dokument.titel ='Schutzzonenreglement'
 
   )

SELECT
    --schutzzonenplan.t_id AS t_id, automatisch beim Import
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
    dokument_rrb AS rrb ON replace(SPLIT_PART(schutzzonenplan.dokument_url,'/',6),'-P.pdf','-E')=replace(SPLIT_PART(rrb.rrb_url,'/',6),'.pdf','')
    LEFT JOIN
    dokument_sbv AS sbv ON replace(SPLIT_PART(schutzzonenplan.dokument_url,'/',6),'-P.pdf','-S')=replace(SPLIT_PART(sbv.sonderbauvorschrift_url,'/',6),'.pdf','')
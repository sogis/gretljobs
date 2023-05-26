WITH dokument_plan_kommunal AS(
    SELECT
        dokument.t_id AS plan_t_id,
        CASE dokument.rechtsvorschrift
            WHEN TRUE
                THEN dokument.titel
            ELSE 'Grundlage'
        END AS planungsinstrument,
        dokument.offiziellertitel AS bezeichnung,
        'Gemeinde' AS planungsbehoerde,
        gemeinde.gemeindename AS gemeinde,
        dokument.gemeinde AS bfsnr,
        dokument.publiziertab AS rechtskraft_ab,
        CASE dokument.rechtsstatus
            WHEN 'inKraft'
                THEN 'in Kraft'
            WHEN 'AenderungMitVorwirkung'
                THEN 'Änderung mit Vorwirkungt'
            WHEN 'AenderungOhneVorwirkung'
                THEN 'Änderung ohne Vorwirkungt'
            ELSE 'aufgehoben'
        END AS rechtsstatus,
        CASE 
            WHEN dokument.textimweb IS NULL
                THEN 'https://planregister-data.so.ch/public/kanton/Dokument-nicht-digital-verfuegbar.pdf'
            ELSE dokument.textimweb 
        END AS dokument_url,
        --Encoding von 'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=[["gemeindename","=","' || gemeinde.gemeindename || '"]]'
        'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=%5B%5B%22bfs_gemeindenummer%22,%22=%22,%22' || dokument.gemeinde || '%22%5D%5D' AS karte_url,
        dokument.zustaendige_amt,
        dokument.aktuelle_ortsplanung,
        dokument.offiziellenr
     FROM
        arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dokument
        LEFT JOIN 
            agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde ON dokument.gemeinde=gemeinde.bfs_gemeindenummer
    WHERE 
        dokument.titel != 'Regierungsratsbeschluss' 
        AND 
        dokument.titel != 'Sonderbauvorschriften'
        AND
        dokument.titel != 'Eisenbahngesetz' --will man nicht im Planregister auf Typo3 haben
        AND
        dokument.titel != 'Auszug kantonale Bauverordnung' --will man nicht im Planregister auf Typo3 haben
        AND
        dokument.titel != 'Nationalstrassenverordnung' --will man nicht im Planregister auf Typo3 haben
        AND
        dokument.titel != 'Richtplantext' --will man nicht im Planregister auf Typo3 haben
        AND
        dokument.titel != 'Richtplan' --will man nicht im Planregister auf Typo3 haben
        AND
        dokument.titel != 'Schutzverordnung' --will man nicht im Planregister auf Typo3 haben
        AND
        dokument.rechtsstatus != 'AenderungMitVorwirkung' --Stand 21.04.2023 momentan nur die in Kraft und aufgehobenen publizieren
        AND
        dokument.rechtsstatus != 'AenderungOhneVorwirkung' --Stand 21.04.2023 momentan nur die in Kraft aufgehobenen publizieren
    ),
    
    dokument_rrb_kommunal AS(
    SELECT
        zuordnung_rrb.dokument_planregister AS t_id_plan_rrb,
        zuordnung_rrb.entscheide_sbv AS t_id_rrb,
        dokument_rrb.publiziertab AS rrb_datum,
        dokument_rrb.offiziellenr AS rrb_nr,
        dokument_rrb.textimweb  AS rrb_url
    FROM
        arp_nutzungsplanung_v1.rechtsvorschrften_dokument_entscheid_sbv AS zuordnung_rrb
        LEFT JOIN 
            arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dokument_rrb ON dokument_rrb.t_id=zuordnung_rrb.entscheide_sbv
    WHERE 
        dokument_rrb.titel = 'Regierungsratsbeschluss'
    ),
    
    dokument_sbv_kommunal AS(
SELECT
        zuordnung_sbv.dokument_planregister AS t_id_plan_rrb,
        zuordnung_sbv.entscheide_sbv AS t_id_sbv,
        dokument_sbv.textimweb  AS sonderbauvorschrift_url
    FROM
        arp_nutzungsplanung_v1.rechtsvorschrften_dokument_entscheid_sbv AS zuordnung_sbv
        LEFT JOIN 
            arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dokument_sbv ON dokument_sbv.t_id=zuordnung_sbv.entscheide_sbv
    WHERE 
        dokument_sbv.titel = 'Sonderbauvorschriften'

    )

SELECT 
    DISTINCT ON (plan.plan_t_id)
    nextval('arp_nutzungsplanung_planregister_v1.t_ili2db_seq'::regclass) AS t_id,
    'nutzungsplanung_kommunal' || '_' || plan.bfsnr AS t_datasetname,
    plan.planungsinstrument,
    plan.bezeichnung,
    plan.planungsbehoerde,
    plan.gemeinde,
    plan.rechtskraft_ab,
    plan.rechtsstatus,
    plan.dokument_url,
    rrb.rrb_datum,
    rrb.rrb_nr,
    rrb.rrb_url,
    sbv.sonderbauvorschrift_url,
    plan.karte_url,
    plan.zustaendige_amt,
    plan.aktuelle_ortsplanung,
    plan.offiziellenr
FROM 
    dokument_plan_kommunal AS plan
    LEFT JOIN
        dokument_rrb_kommunal AS rrb ON plan.plan_t_id = rrb.t_id_plan_rrb
     LEFT JOIN
        dokument_sbv_kommunal AS sbv ON plan.plan_t_id = sbv.t_id_plan_rrb
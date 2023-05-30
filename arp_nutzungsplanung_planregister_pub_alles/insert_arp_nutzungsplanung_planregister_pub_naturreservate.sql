WITH dokument_plan_naturreservat AS(
    SELECT
        reservat.t_id AS reservat_t_id,
        dokument.t_id,
        CASE dokument.typ
            WHEN 'RRB'
                THEN 'Regierungsratsbeschluss'
            ELSE dokument.typ
        END AS planungsinstrument,
        dokument.bezeichnung AS bezeichnung,
        'Kanton' AS planungsbehoerde,
       --Gemeindenamen von der URL übernehmen https://planregister-data.so.ch/public/Erlinsbach/101-39-P.pdf
        INITCAP(REPLACE(REPLACE(REPLACE(SPLIT_PART(dokument.dateipfad,'/',5),'ue','ü'),'oe','ö'),'ae','ä')) AS gemeinde,
        dokument.publiziertab AS rechtskraft_ab,
        CASE dokument.rechtsstatus
            WHEN 'inKraft'
                THEN 'in Kraft'
            WHEN 'laufendeAenderung'
                THEN 'Änderung mit Vorwirkungt'
        END AS rechtsstatus,
        dokument.dateipfad AS dokument_url,
        --Encoding von 'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=[["gemeindename","=","' || gemeinde.gemeindename || '"]]'
        'https://geo.so.ch/map?t=nutzungsplanung&hp=ch.so.agi.gemeindegrenzen&hf=%5B%5B%22gemeindename%22,%22=%22,%22' || INITCAP(REPLACE(REPLACE(REPLACE(SPLIT_PART(dokument.dateipfad,'/',5),'ue','ü'),'oe','ö'),'ae','ä')) || '%22%5D%5D' AS karte_url,
        'Amt für Raumplanung' AS zustaendige_amt,
        False AS aktuelle_ortsplanung,
        dokument.offiziellenr
FROM
    arp_naturreservate.reservate_reservat AS reservat 
    LEFT JOIN
    arp_naturreservate.reservate_reservat_dokument AS dokument_reservat ON reservat.t_id=dokument_reservat.reservat
    left JOIN  
    arp_naturreservate.reservate_dokument AS dokument ON dokument.t_id=dokument_reservat.dokument 
WHERE 
    reservat.einzelschutz IS false 
        AND 
            dokument.typ ='Gestaltungsplan' 
        AND
            rechtsvorschrift IS TRUE
    ),
    
dokument_rrb AS(
    SELECT
        reservat.t_id AS t_id_reservat,
        dokument.t_id AS t_id_rrb,
        dokument.publiziertab AS rrb_datum,
        dokument.offiziellenr AS rrb_nr,
        dokument.dateipfad AS rrb_url
FROM
    arp_naturreservate.reservate_reservat AS reservat 
    LEFT JOIN
     arp_naturreservate.reservate_reservat_dokument AS dokument_reservat ON reservat.t_id=dokument_reservat.reservat
    left JOIN  
    arp_naturreservate.reservate_dokument AS dokument ON dokument.t_id=dokument_reservat.dokument 
WHERE 
    reservat.einzelschutz IS false 
        AND 
            dokument.typ ='RRB'
    ),    

dokument_sbv AS(
    SELECT
        reservat.t_id AS t_id_reservat,
        dokument.t_id AS t_id_sbv,
        dokument.dateipfad AS sonderbauvorschrift_url
FROM
    arp_naturreservate.reservate_reservat AS reservat 
    LEFT JOIN
     arp_naturreservate.reservate_reservat_dokument AS dokument_reservat ON reservat.t_id=dokument_reservat.reservat
    left JOIN  
    arp_naturreservate.reservate_dokument AS dokument ON dokument.t_id=dokument_reservat.dokument 
WHERE 
    reservat.einzelschutz IS false 
        AND 
            dokument.typ ='Sonderbauvorschriften'
    )

SELECT 
    DISTINCT ON (naturreservat.t_id)
    --naturreservat.t_id AS t_id, automatisch beim Import
    'naturreservat' AS t_datasetname,
    naturreservat.planungsinstrument,
    naturreservat.bezeichnung,
    naturreservat.planungsbehoerde,
    naturreservat.gemeinde,
    naturreservat.rechtskraft_ab,
    naturreservat.rechtsstatus,
    naturreservat.dokument_url,
    rrb.rrb_datum,
    rrb.rrb_nr,
    NULL AS rrb_url, --rrb.rrb_url,   !!!! doppelet RRB müssen bereinigt werden
    sbv.sonderbauvorschrift_url,
    naturreservat.karte_url,
    naturreservat.zustaendige_amt,
    naturreservat.aktuelle_ortsplanung,
    naturreservat.offiziellenr
FROM 
    dokument_plan_naturreservat AS naturreservat
    LEFT JOIN
        dokument_rrb AS rrb ON naturreservat.reservat_t_id = rrb.t_id_reservat
     LEFT JOIN
        dokument_sbv AS sbv ON naturreservat.reservat_t_id = sbv.t_id_reservat
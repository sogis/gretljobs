DELETE FROM arp_laermempfindlichkeit_mgdm.rechtsvorschrften_dokument;

INSERT INTO arp_laermempfindlichkeit_mgdm.rechtsvorschrften_dokument (
    t_type,
    titel,
    offiziellertitel,
    abkuerzung,
    kanton,
    gemeinde,
    publiziertab,
    rechtsstatus,
    bemerkungen
)


WITH empfindlichkeit_dokumente AS (
    SELECT distinct
        dokument_so.t_id
    FROM
        arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche
            ON nutzungsplanung_typ_ueberlagernd_flaeche.t_id = nutzungsplanung_typ_ueberlagernd_flaeche_dokument.typ_ueberlagernd_flaeche
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dokument_so
            ON dokument_so.t_id = nutzungsplanung_typ_ueberlagernd_flaeche_dokument.dokument
    WHERE
        substring(code_kommunal FROM 1 FOR 3)::integer = 680
        OR 
        substring(code_kommunal FROM 1 FOR 3)::integer = 681
        OR
        substring(code_kommunal FROM 1 FOR 3)::integer = 682
        OR
        substring(code_kommunal FROM 1 FOR 3)::integer = 683
        OR 
        substring(code_kommunal FROM 1 FOR 3)::integer = 684
        OR
        substring(code_kommunal FROM 1 FOR 3)::integer = 685
        OR
        substring(code_kommunal FROM 1 FOR 3)::integer = 686
),
all_documents AS (
    SELECT 
        hinweisweiteredokumente_1.hinweis AS hinweis_1,
        hinweisweiteredokumente_1.ursprung AS ursprung_1,
        hinweisweiteredokumente_2.hinweis AS hinweis_2,
        hinweisweiteredokumente_2.ursprung AS ursprung_2
    FROM 
        arp_npl.rechtsvorschrften_hinweisweiteredokumente AS hinweisweiteredokumente_1
        LEFT JOIN arp_npl.rechtsvorschrften_hinweisweiteredokumente AS hinweisweiteredokumente_2
            ON 
                ( 
                    hinweisweiteredokumente_2.ursprung = hinweisweiteredokumente_1.ursprung 
                    AND 
                    hinweisweiteredokumente_2.hinweis != hinweisweiteredokumente_1.hinweis
                ) 
                OR 
                (
                    hinweisweiteredokumente_2.hinweis = hinweisweiteredokumente_1.hinweis 
                    AND 
                    hinweisweiteredokumente_2.ursprung != hinweisweiteredokumente_1.ursprung
                ) 
                OR
                ( 
                    hinweisweiteredokumente_2.ursprung = hinweisweiteredokumente_1.hinweis 
                    AND 
                    hinweisweiteredokumente_2.hinweis != hinweisweiteredokumente_1.ursprung
                ) 
                OR 
                (
                    hinweisweiteredokumente_2.hinweis = hinweisweiteredokumente_1.ursprung 
                    AND 
                    hinweisweiteredokumente_2.ursprung != hinweisweiteredokumente_1.hinweis 
                )
    WHERE 
        hinweisweiteredokumente_1.ursprung IN 
            (
                SELECT 
                    t_id 
                FROM 
                    empfindlichkeit_dokumente
            ) 
        OR 
        hinweisweiteredokumente_1.hinweis IN 
            (
                SELECT 
                    t_id 
                FROM 
                    empfindlichkeit_dokumente
            ) 
        OR 
        hinweisweiteredokumente_2.ursprung IN 
            (
                SELECT 
                    t_id 
                FROM 
                    empfindlichkeit_dokumente
            ) 
        OR 
        hinweisweiteredokumente_2.hinweis IN 
            (
                SELECT 
                    t_id 
                FROM 
                    empfindlichkeit_dokumente
            ) 
),
list_with_documents AS (
    SELECT 
        hinweis_1 AS t_id 
    FROM 
        all_documents
        
    UNION
    
    SELECT 
        hinweis_2 AS t_id  
    FROM 
        all_documents
        
    UNION
    
    SELECT 
        ursprung_1 AS t_id  
    FROM 
        all_documents
    
    UNION
        
    SELECT 
        ursprung_2 AS t_id  
    FROM 
        all_documents
),
        
list_distinct_documents AS (
    SELECT DISTINCT 
        t_id 
    FROM 
        list_with_documents 
    WHERE 
        t_id IS NOT NULL
),
        
list_with_documents_without_origin AS (
    SELECT 
        t_id
    FROM 
        empfindlichkeit_dokumente
    WHERE
        t_id NOT IN 
        (
            SELECT 
                t_id
            FROM
                list_distinct_documents
        )
),

all_used_documents AS (
    SELECT 
        t_id 
    FROM 
        list_distinct_documents 
    UNION
    SELECT
        t_id
    FROM 
        list_with_documents_without_origin
)

    
    
SELECT DISTINCT 
    CASE 
        WHEN rechtsvorschrift IS TRUE 
            THEN 'rechtsvorschrften_rechtsvorschrift'
        ELSE 'rechtsvorschrften_dokument'
    END AS t_type,
    titel,
    offiziellertitel,
    abkuerzung,
    kanton,
    gemeinde,
    publiziertab,
    rechtsstatus,
    bemerkungen
FROM
    all_used_documents
    LEFT JOIN
        arp_npl.rechtsvorschrften_dokument AS dokument_so
        ON dokument_so.t_id = all_used_documents.t_id
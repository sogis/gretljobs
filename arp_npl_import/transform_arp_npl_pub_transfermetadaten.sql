WITH transfermetadaten AS (
    SELECT 
        datenbestand.t_id,
        datenbestand.t_datasetname,
        amt.aname,
        amt.amtimweb,
        datenbestand.stand,
        datenbestand.lieferdatum,
        datenbestand.bemerkungen
    FROM 
        arp_npl.transfermetadaten_datenbestand AS datenbestand 
        LEFT JOIN arp_npl.transfermetadaten_amt AS amt
        ON datenbestand.amt = amt.t_id         
)
SELECT  
    t.t_datasetname::int4 AS bfs_nr,
    t.t_id,
    --t.aname,
    t.amtimweb,
    t.stand,
    t.lieferdatum,
    t.bemerkungen
FROM 
    transfermetadaten AS t;
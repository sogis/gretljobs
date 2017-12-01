WITH gemeinden AS (
    SELECT
        ST_Multi(wkb_geometry) AS geometrie,
        gmde AS gem_bfs,
        name
    FROM
        sogis_ch_gemeinden
    WHERE
        archive = 0
 
    UNION ALL
 
    SELECT
        ST_Multi(wkb_geometry) AS geometrie,
        gem_bfs,
        gmde_name AS name
    FROM
        geo_gemeinden
    WHERE
        archive = 0
)

SELECT
    row_number() OVER() AS t_id,    
    aggloprogramm.aname,
    string_agg(DISTINCT aggloprogramm.generation::text, ', ') AS generation,
    gemeinde.aname AS gemeinde,
    gemeinde.bfs_nr,
    gemeinde.kanton,
    gemeinde.land,
    gemeinden.geometrie
 
FROM
    arp_aggloprogramme.agglomrtnsprgrmme_agglomerationsprogramm AS aggloprogramm
    JOIN arp_aggloprogramme.agglomrtnsprgrmme_massnahme AS massnahme
        ON aggloprogramm.t_id = massnahme.agglo_programm
    JOIN arp_aggloprogramme.agglomrtnsprgrmme_gemeinde_massnahme AS gemeinde_massnahme
        ON massnahme.t_id = gemeinde_massnahme.massnahme
    JOIN arp_aggloprogramme.agglomrtnsprgrmme_gemeinde AS gemeinde
        ON gemeinde_massnahme.gemeinde_name = gemeinde.t_id
    JOIN gemeinden
        ON gemeinde.bfs_nr = gemeinden.gem_bfs

GROUP BY
    aggloprogramm.aname,
    gemeinde.t_id,
    gemeinden.geometrie
;
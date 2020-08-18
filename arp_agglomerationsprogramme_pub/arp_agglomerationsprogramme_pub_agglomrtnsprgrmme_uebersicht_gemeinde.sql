WITH gemeinden_ref AS (
    SELECT
        geometrie,
        bfs_nummer,
        hoheitsgebietsname AS gemeindename
    FROM
        agi_swissboundaries3d_pub.swissboundaries3d_hoheitsgebiet
    WHERE
        kanton = 'Bern' OR kanton = 'Basel-Landschaft' OR kanton = 'Aargau' OR kanton = 'Jura'
 
    UNION ALL
 
    SELECT
        geometrie,
        bfs_gemeindenummer AS bfs_nummer,
        gemeindename
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
)

SELECT
    aggloprogramm.aname AS aggloprogramm,
    aggloprogramm.agglo_nu AS agglomerationsprogramm_nummer,
    gemeinde.aname AS gemeinde,
    gemeinde.bfs_nr,
    gemeinde.kanton,
    gemeinde.land,
    gemeinden_ref.geometrie
 
FROM
    arp_agglomerationsprogramme.agglomrtnsprgrmme_agglomerationsprogramm AS aggloprogramm
    JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_massnahme AS massnahme
        ON aggloprogramm.t_id = massnahme.agglo_programm
    JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_gemeinde_massnahme AS gemeinde_massnahme
        ON massnahme.t_id = gemeinde_massnahme.massnahme
    JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_gemeinde AS gemeinde
        ON gemeinde_massnahme.gemeinde_name = gemeinde.t_id
    JOIN gemeinden_ref
        ON gemeinde.bfs_nr = gemeinden_ref.bfs_nummer

GROUP BY
    aggloprogramm.aname,
    aggloprogramm.agglo_nu,
    gemeinde.t_id,
    gemeinden_ref.geometrie
	
;

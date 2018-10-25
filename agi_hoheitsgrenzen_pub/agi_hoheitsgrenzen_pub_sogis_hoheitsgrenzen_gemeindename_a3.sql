SELECT
    hoheitsgrenzen_gemeinde.bfs_gemeindenummer,
    gemeindegrenzen_gemeinde.name AS gemeindename,
    hoheitsgrenzen_gemeindename_pos.ori,
    hoheitsgrenzen_gemeindename_pos.hali,
    hoheitsgrenzen_gemeindename_pos.vali,
    hoheitsgrenzen_gemeindename_pos.beschriftungstext,
    hoheitsgrenzen_gemeindename_pos.pos
FROM
    agi_hoheitsgrenzen.hoheitsgrenzen_gemeindename_pos
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_gemeinde
        ON hoheitsgrenzen_gemeinde.t_id = hoheitsgrenzen_gemeindename_pos.gemeinde
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemeinde
        ON gemeindegrenzen_gemeinde.gem_bfs = hoheitsgrenzen_gemeinde.bfs_gemeindenummer
WHERE
    hoheitsgrenzen_gemeindename_pos.format = 'A3'
;
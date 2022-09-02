SELECT
    hoheitsgrenzen_gemeinde.bfs_gemeindenummer,
    gemeindegrenzen_gemeinde.aname AS gemeindename,
    hoheitsgrenzen_gemeindename_pos.ori,
    hoheitsgrenzen_gemeindename_pos.hali,
    hoheitsgrenzen_gemeindename_pos.vali,
    hoheitsgrenzen_gemeindename_pos.beschriftungstext,
    hoheitsgrenzen_gemeindename_pos.pos
FROM 
    agi_hoheitsgrenzen_v1.hoheitsgrenzen_gemeindename_pos
    LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_gemeinde
        ON hoheitsgrenzen_gemeinde.t_id = hoheitsgrenzen_gemeindename_pos.gemeinde
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeinde
        ON gemeindegrenzen_gemeinde.bfsnr = hoheitsgrenzen_gemeinde.bfs_gemeindenummer
WHERE
    hoheitsgrenzen_gemeindename_pos.aformat = 'A4'
;

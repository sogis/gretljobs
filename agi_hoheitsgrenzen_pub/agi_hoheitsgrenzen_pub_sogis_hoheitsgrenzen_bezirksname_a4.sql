SELECT
    hoheitsgrenzen_bezirk.bezirksnummer,
    hoheitsgrenzen_bezirk.bezirksname,
    hoheitsgrenzen_bezirksname_pos.ori,
    hoheitsgrenzen_bezirksname_pos.hali,
    hoheitsgrenzen_bezirksname_pos.vali,
    hoheitsgrenzen_bezirksname_pos.beschriftungstext,
    hoheitsgrenzen_bezirksname_pos.pos
FROM
    agi_hoheitsgrenzen.hoheitsgrenzen_bezirksname_pos
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_bezirk
        ON hoheitsgrenzen_bezirk.t_id = hoheitsgrenzen_bezirksname_pos.bezirk
WHERE
    hoheitsgrenzen_bezirksname_pos.format = 'A4'
;
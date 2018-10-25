SELECT
    hoheitsgrenzen_kanton.kantonsnummer,
    hoheitsgrenzen_kanton.kantonsname,
    hoheitsgrenzen_kantonsname_pos.ori,
    hoheitsgrenzen_kantonsname_pos.hali,
    hoheitsgrenzen_kantonsname_pos.vali,
    hoheitsgrenzen_kantonsname_pos.beschriftungstext,
    hoheitsgrenzen_kantonsname_pos.pos
FROM
    agi_hoheitsgrenzen.hoheitsgrenzen_kantonsname_pos
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_kanton
        ON hoheitsgrenzen_kanton.t_id = hoheitsgrenzen_kantonsname_pos.kanton
WHERE
    hoheitsgrenzen_kantonsname_pos.format = 'A4'
;
SELECT
    hoheitsgrenzen_kanton.kantonsnummer,
    hoheitsgrenzen_kanton.kantonsname,
    hoheitsgrenzen_kantonsname_pos.ori,
    hoheitsgrenzen_kantonsname_pos.hali,
    hoheitsgrenzen_kantonsname_pos.vali,
    hoheitsgrenzen_kantonsname_pos.beschriftungstext,
    hoheitsgrenzen_kantonsname_pos.pos
FROM
    agi_hoheitsgrenzen_v1.hoheitsgrenzen_kantonsname_pos
    LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_kanton
        ON hoheitsgrenzen_kanton.t_id = hoheitsgrenzen_kantonsname_pos.kanton
WHERE
    hoheitsgrenzen_kantonsname_pos.aformat = 'A4'
;

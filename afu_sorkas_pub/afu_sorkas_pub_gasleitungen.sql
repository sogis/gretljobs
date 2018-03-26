SELECT
    gid AS t_id,
    pnr,
    code,
    "name",
    medium,
    eigentueme,
    betreiber,
    baujahr,
    durchmesse,
    wanddicke,
    laenge,
    stahlquali,
    konzdatum,
    konzdauer,
    konzdruck,
    mop,
    betridruck,
    bewilldat,
    statusleit,
    betriebszu,
    genauigkei,
    letzteaend,
    quelle,
    bar_cm,
    kb,
    the_geom AS geometrie
FROM
    sorkas.gasleitungen
;
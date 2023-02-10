SELECT
    ST_Force2D(ageometry) AS geometrie,
    field_name AS flurname,
    altitude AS hoehe,
    '000' AS standortnummer
FROM
    arp_wanderwege_v1.hpm_walk_lv95_signalisation AS signalisation
;

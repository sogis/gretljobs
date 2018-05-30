SELECT
    gid AS t_id,
    typ,
    CASE
        WHEN typ = 1
            THEN 'Wohnen, Mischnutzungen, öffentliche Bauten und Anlagen, Reservezone Wohnen'
        WHEN typ = 2
            THEN 'Industrie- und reine Gewerbezone, Arbeitszone, reservezone Arbeiten'
        WHEN typ = 3
            THEN 'Wald'
        WHEN typ = 4
            THEN 'Gewässer'
        WHEN typ = 5
            THEN 'Landwirtschaft'
        WHEN typ = 6
            THEN 'Nationalstrassen'
    END AS typ_txt,
    ST_Multi(geometrie) AS geometrie 
FROM
    arp_richtplan_2017.grundnutzung_version
;
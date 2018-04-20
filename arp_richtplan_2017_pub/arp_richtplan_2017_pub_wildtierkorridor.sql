SELECT
    id AS t_id,
    nummer,
    "name",
    bedeutung,
    CASE
        WHEN bedeutung = 'national'
            THEN 'Wildtierkorridor von nationaler Bedeutung'
        WHEN bedeutung = 'regional'
            THEN 'Wildtierkorridor von regionaler Bedeutung'
    END AS bedeutung_txt,
    abstimmung,
    ST_Multi(geometrie) AS geometrie 
FROM
    arp_richtplan_2017.wildtierkorridor
;
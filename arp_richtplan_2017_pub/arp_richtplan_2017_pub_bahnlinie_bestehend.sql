SELECT
    ogc_fid AS t_id,
    typ,
    herkunft,
    geometrie 
FROM
    arp_richtplan_2017.bahnlinie_bestehend
WHERE
    archive = 0
;
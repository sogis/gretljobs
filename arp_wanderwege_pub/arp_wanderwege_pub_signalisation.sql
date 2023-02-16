SELECT
    ST_Force2D(ageometry) AS geometrie,
    field_name AS standortname,
    altitude AS hoehe,
    NULL AS standortnummer,
    'https://geo.so.ch/docs/ch.so.arp.wanderwege/standorttafeln/'||field_name||'.pdf' AS dokument
FROM
    arp_wanderwege_v1.hpm_walk_lv95_signalisation
;

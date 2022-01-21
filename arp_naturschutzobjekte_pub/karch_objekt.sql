SELECT
    karch_id,
    nummer,
    objektname,
    ianb,
    geometrie
FROM
    arp_naturschutzobjekte_v1.karch_objekt
WHERE
    ianb = 'Nein'
;

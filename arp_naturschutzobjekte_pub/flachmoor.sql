SELECT
    flachmoor_id,
    nummer,
    bezeichnung,
    round(ST_Area(geometrie)::numeric / 10000, 1) AS flaeche,
    geometrie
FROM
    arp_naturschutzobjekte_v1.flachmoor
;

SELECT
    geometrie,
    ST_Perimeter(geometrie) AS perimeter,
    ST_Area(geometrie) AS area,
    quelle_id
FROM
    afu_erdwaermesonden_private_quellen_v1.private_quelle
;

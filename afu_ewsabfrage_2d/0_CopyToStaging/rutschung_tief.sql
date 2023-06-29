SELECT 
    'Rutschgebiet' AS abklaerung,
    ST_Multi(geometrie) AS mpoly
FROM awjf_naturgefahrenhinweiskarte_pub_v1.rutschung_tief;

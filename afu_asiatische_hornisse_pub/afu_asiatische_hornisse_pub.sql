SELECT
    nummer,
    datum_sichtung,
    ort,
    round(st_x(geometrie)),
    round(st_y(geometrie))
FROM afu_asiatische_hornisse_v1.asia_hornisse_ash

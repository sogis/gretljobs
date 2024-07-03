SELECT
    nummer,
    datum_sichtung,
    ort,
    round(st_x(geometrie)) AS x_koordinate,
    round(st_y(geometrie)) AS y_koordinate,
    geometrie,
    kanton,
    massnahmenstatus
FROM afu_asiatische_hornisse_v1.asia_hornisse_ash

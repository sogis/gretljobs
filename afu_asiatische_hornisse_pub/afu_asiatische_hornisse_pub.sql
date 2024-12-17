SELECT
    nummer,
    datum_sichtung,
    ort,
    round(st_x(geometrie)) AS x_koordinate,
    round(st_y(geometrie)) AS y_koordinate,
    st_y(st_transform(geometrie, 4326)) AS koordinate_lat ,
    st_x(st_transform(geometrie, 4326)) AS  koordinate_lon,
    geometrie,
    kanton,
    massnahmenstatus,
    sichtungsdetails
FROM afu_asiatische_hornisse_v1.asia_hornisse_ash

SELECT
    geometrie,
    nummer,
    typ,
    hoehe,
    bemerkung,
    nutzen,
    prioritaet,
    frist,
    nummer_stg,
    gewaesser,
    gemeinde,
    ortsbezeichnung,
    prio,
    planung_20j,
    massnahmen_nr,
    x_alt_oeko,
    y_alt_oeko,
    ST_X(geometrie) AS ort_x,
    ST_Y(geometrie) AS ort_y
FROM
    afu_fischwanderungshindernisse_v1.fischwanderungshindernis
;

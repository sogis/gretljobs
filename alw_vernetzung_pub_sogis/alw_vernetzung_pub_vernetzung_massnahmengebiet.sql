SELECT
    vernetzung_massnahmengebiet.t_ili_tid, 
    vp_id,
    vp_name,
    mg_id,
    mg_name,
    gelan_id,
    erhaltung,
    vernetzung_massnahmengebiet.stand,
    vernetzung_massnahmengebiet.bemerkung,
    ST_Area(vernetzung_massnahmengebiet.geometrie) AS flaeche,
    vernetzung_massnahmengebiet.geometrie
FROM
    alw_vernetzung.vernetzung_massnahmengebiet
    LEFT JOIN alw_vernetzung.vernetzung_vernetzungsperimeter
        ON vernetzung_vernetzungsperimeter.t_id = vernetzung_massnahmengebiet.vp_t_id
;
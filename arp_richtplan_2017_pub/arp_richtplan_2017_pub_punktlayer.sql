SELECT
    gemeinde,
    "name",
    spezifikation,
    bedeutung,
    nummer,
    abstimmungskategorie,
    stand,
    x_koord,
    y_koord,
    o_art,
    geometrie,
    ogc_fid AS t_id 
FROM
    arp_richtplan_2017.punktlayer
;
SELECT 
    gebaeudeadressen_benanntesgebiet.ogc_fid AS t_id,
    flaeche AS geometrie,
    gebaeudeadressen_benanntesgebiet.gem_bfs,
    gebaeudeadressen_benanntesgebiet.los,
    gebaeudeadressen_benanntesgebiet.lieferdatum,
    text AS name_benanntes_gebiet
FROM
    av_avdpool_ng.gebaeudeadressen_benanntesgebiet
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisation
        ON gebaeudeadressen_benanntesgebiet.benanntesgebiet_von = gebaeudeadressen_lokalisation.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsname
        ON gebaeudeadressen_lokalisationsname.benannte = gebaeudeadressen_lokalisation.tid
WHERE 
    art = 0
;
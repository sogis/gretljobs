SELECT
    ogc_fid AS t_id,
    tid,
    benanntesgebiet_von,
    flaeche AS geometrie,
    gem_bfs,
    los,
    lieferdatum
FROM
    av_avdpool_ng.gebaeudeadressen_benanntesgebiet
;
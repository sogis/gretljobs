SELECT
    ogc_fid AS t_id,
    strname,
    hausnummer,
    a_tid,
    b_tid,
    lok_tid,
    gem_bfs,
    the_geom AS geometrie,
    datum
FROM
    av_fileverifikation.geb_shortestline_hausnummerpos
;
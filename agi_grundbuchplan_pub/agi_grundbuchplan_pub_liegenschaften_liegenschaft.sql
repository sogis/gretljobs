SELECT
    ogc_fid AS t_id,
    tid,
    liegenschaft_von,
    nummerteilgrundstueck,
    geometrie,
    flaechenmass,
    gem_bfs,
    los,
    lieferdatum,
    numpos,
    nummer,
    mutation
FROM
    av_pfdgb.t_liegenschaften_liegenschaft
;
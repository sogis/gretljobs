SELECT
    ogc_fid AS t_id,
    bfsnr,
    gueltigkeit,
    punktzeichen,
    geometrie,
    mutation 
FROM 
    av_pfdgb.t_liegenschaften_grenzpunkt
;
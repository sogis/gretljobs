UPDATE 
    agi_av_meldewesen_work_v1.meldungen_meldung 
SET 
    t_ili_tid = '_' || CAST(uuid_generate_v4() AS TEXT)
WHERE 
    t_ili_tid IS NULL
;
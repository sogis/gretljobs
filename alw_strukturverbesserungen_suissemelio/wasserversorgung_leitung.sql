SELECT
    wv.t_id, 
    (ST_Dump(wv.geometrie)).geom AS geometrie,
    wv.bautyp, 
    wv.astatus, 
    wv.status_datum, 
    wv.bauabnahme_datum, 
    wv.werksid, 
    wv.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wv_leitung_wasserversorgung wv
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON wv.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL
;

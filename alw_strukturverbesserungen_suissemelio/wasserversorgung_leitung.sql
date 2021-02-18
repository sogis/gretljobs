SELECT
    wv.t_id, 
    ST_GeometryN(wv.geometrie,1) AS geometrie, --TODO: properly handle MultiPolygon 
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

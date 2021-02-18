SELECT
    wv.t_id, 
    wv.typ,
    wv.bautyp, 
    wv.geometrie,
    wv.astatus, 
    wv.status_datum, 
    wv.bauabnahme_datum, 
    wv.werksid, 
    wv.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wasserversorgung_punkt wv
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON wv.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL
;

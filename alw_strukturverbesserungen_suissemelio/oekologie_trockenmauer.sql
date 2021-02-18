SELECT
    oek.t_id, 
    oek.typ, 
    oek.hoehe,
    oek.bautyp, 
    (ST_Dump(oek.geometrie)).geom AS geometrie,
    oek.astatus, 
    oek.status_datum, 
    oek.bauabnahme_datum, 
    oek.werksid, 
    oek.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_oekologie_trockenmauer oek
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON oek.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL
;

SELECT
    ev.t_id,
    ev.typ,
    ev.bautyp, 
    ev.geometrie,
    ev.astatus, 
    ev.status_datum, 
    ev.bauabnahme_datum, 
    ev.werksid, 
    ev.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_ev_punkt ev
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON ev.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL
;

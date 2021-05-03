SELECT
    ev.t_id,
    ev.typ,
    ev.bautyp, 
    (ST_Dump(ev.geometrie)).geom AS geometrie,
    ev.astatus, 
    ev.status_datum, 
    ev.bauabnahme_datum, 
    ev.werksid, 
    ev.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_ev_linie ev
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON ev.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL

;

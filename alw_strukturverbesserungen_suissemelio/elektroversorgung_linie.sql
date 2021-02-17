SELECT
    ev.t_id,
    ev.typ,
    ev.bautyp, 
    ST_GeometryN(ev.geometrie,1) AS geometrie, --TODO: properly handle MultiLineStrings 
    ev.astatus, 
    ev.status_datum, 
    ev.bauabnahme_datum, 
    ev.werksid, 
    ev.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_ev_linie ev
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON ev.projekt = prj.t_id
;

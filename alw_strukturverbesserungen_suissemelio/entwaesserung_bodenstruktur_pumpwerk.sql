SELECT
    entwbs.t_id, 
    entwbs.geometrie, 
    entwbs.bautyp, 
    entwbs.astatus, 
    entwbs.status_datum, 
    entwbs.bauabnahme_datum, 
    entwbs.werksid, 
    entwbs.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_pumpwerk entwbs
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON entwbs.projekt = prj.t_id
;

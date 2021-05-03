SELECT
    entwbs.t_id, 
    entwbs.typ, 
    entwbs.bautyp, 
    (ST_Dump(entwbs.geometrie)).geom AS geometrie,
    entwbs.astatus, 
    entwbs.status_datum, 
    entwbs.bauabnahme_datum, 
    entwbs.werksid, 
    entwbs.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_linie entwbs
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON entwbs.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL

;

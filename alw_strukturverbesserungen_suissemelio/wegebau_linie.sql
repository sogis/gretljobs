SELECT
    wg.t_id,
    wg.typ,
    wg.bautyp,
    wg.fahrbahnbreite,
    wg.geometrie, 
    wg.astatus, 
    wg.status_datum, 
    wg.bauabnahme_datum, 
    wg.werksid, 
    wg.unterhaltsid, 
    prj.geschaeftsnummer,
    prj.kantonsnummer
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wegebau_linie wg
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON wg.projekt = prj.t_id
;

SELECT
    wg.t_id,
    wg.typ,
    wg.bautyp,
    wg.fahrbahnbreite,
    ST_GeometryN(wg.geometrie,1) AS geometrie, --TODO: properly handle MultiLineStrings 
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

SELECT
    bew.t_id,
    bew.typ,
    bew.bautyp,
    bew.geometrie,
    bew.astatus,
    bew.status_datum,
    bew.bauabnahme_datum,
    bew.werksid,
    bew.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bewaesserung_punkt bew
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON bew.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL
;

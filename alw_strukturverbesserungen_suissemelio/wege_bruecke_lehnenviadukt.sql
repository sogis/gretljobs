SELECT
    br.t_id,
    br.fahrbahnbreite,
    br.laenge,
    br.bautyp,
    br.tonnage,
    br.material,
    br.widerlager,
    br.geometrie,
    br.astatus,
    br.status_datum,
    br.bauabnahme_datum,
    br.werksid,
    br.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wege_bruecke_lehnenviadukt br
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON br.projekt = prj.t_id
;

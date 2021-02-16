SELECT
    bew.t_id,
    bew.typ,
    bew.bautyp,
    ST_GeometryN(bew.geometrie,1) AS geometrie, --TODO: properly handle MultiPolygons 
    bew.astatus,
    bew.status_datum,
    bew.bauabnahme_datum,
    bew.werksid,
    bew.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bew_flaechen_bewaesserung bew
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON bew.projekt = prj.t_id
;

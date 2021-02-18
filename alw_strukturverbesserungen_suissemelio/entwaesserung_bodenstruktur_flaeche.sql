SELECT
    entwbs.typ, 
    entwbs.bautyp, 
    ST_GeometryN(entwbs.geometrie,1) AS geometrie, --TODO: properly handle MultiPolygon 
    entwbs.astatus, 
    entwbs.status_datum, 
    entwbs.bauabnahme_datum, 
    entwbs.werksid, 
    entwbs.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_flaeche entwbs
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON entwbs.projekt = prj.t_id
;

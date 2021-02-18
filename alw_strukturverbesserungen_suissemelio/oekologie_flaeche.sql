SELECT
    oek.t_id, 
    oek.typ, 
    oek.bautyp, 
    ST_GeometryN(oek.geometrie,1) AS geometrie, --TODO: properly handle MultiPolygon 
    oek.astatus, 
    oek.status_datum, 
    oek.bauabnahme_datum, 
    oek.werksid, 
    oek.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_oekologie_flaeche oek
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON oek.projekt = prj.t_id
   WHERE prj.geschaeftsnummer IS NOT NULL
;

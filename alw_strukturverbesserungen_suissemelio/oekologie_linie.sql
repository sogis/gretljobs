SELECT
    oek.t_id, 
    oek.bautyp, 
    oek.typ, 
    (ST_Dump(oek.geometrie)).geom AS geometrie,
    oek.astatus, 
    oek.status_datum, 
    oek.bauabnahme_datum, 
    oek.werksid, 
    oek.unterhaltsid,
    prj.geschaeftsnummer,
    prj.kantonsnummer    
  FROM alw_strukturverbesserungen.raeumlicheelemnte_oekologie_linie oek
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON oek.projekt = prj.t_id
   WHERE
     oek.typ NOT IN ('Waldrandaufwertung','Bach_und_Ufervegetation')
     AND prj.geschaeftsnummer IS NOT NULL
;

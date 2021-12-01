SELECT 
  g.t_ili_tid, -- Mit transferieren, da die Fachapplikation beim WGC-Aufruf die edit-tid übergibt
  bezeichnung, 
  aktennummer, 
  gemeinde_name, 
  gemeinde_bfs, 
  art, stand, 
  rohstoffart, 
  gestaltungsplanvorhanden, 
  richtplannummer, 
  standrichtplan, 
  rrb_nr, 
  rrb_datum, 
  mpoly
FROM 
  afu_abbaustellen_v1.abbaustelle a
JOIN
  afu_abbaustellen_v1.geometrie g ON a.geometrie = g.t_id
;

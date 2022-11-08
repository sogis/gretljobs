SELECT 
  g.t_ili_tid, -- Mit transferieren, da die Fachapplikation beim WGC-Aufruf die edit-tid übergibt
  bezeichnung, 
  aktennummer, 
  gemeinde_name, 
  gemeinde_bfs, 
  CASE 
      WHEN art = 'AusgangslageKiesgrube' 
          THEN 'Ausgangslage Kiesgrube'
      WHEN art = 'AusgangslageSteinbruch' 
          THEN 'Ausgangslage Steinbruch'
      WHEN art = 'AusgangslageTongrube' 
          THEN 'Ausgangslage Tongrube'
      WHEN art = 'FestsetzungKiesgrube' 
          THEN 'Festsetzung Kiesgrube'
      WHEN art = 'VororientierungKiesgrube' 
          THEN 'Vororientierung Kiesgrube'
      WHEN art = 'VororientierungSteinbruch' 
          THEN 'Vororientierung Steinbruch'
      WHEN art = 'ZwischenergebnisKiesgrube' 
          THEN 'Zwischenergebnis Kiesgrube'
      WHEN art = 'ZwischenergebnisSteinbruch' 
          THEN 'Zwischenergebnis Steinbruch'
      ELSE art
  END AS art,
  CASE
      WHEN stand = 'NurAuffuellung'
          THEN 'Nur Auffuellung'
      WHEN stand = 'InAbbau'
          THEN 'In Abbau'
      ELSE stand
  END AS stand, 
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

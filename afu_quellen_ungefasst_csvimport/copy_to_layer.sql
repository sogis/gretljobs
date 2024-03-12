SELECT 
  id_quelle, 
  flurname, 
  quellenname, 
  hoehe, 
  austrittsform, 
  quellgroesse, 
  schuettungsverhalten, 
  quellschuettung, 
  vernetzung,
  austrittsanzahl, 
  bemerkungen, 
  fassung, 
  wasserentnahme, 
  trittschaeden, 
  sommerbeschattung, 
  substrate, 
  revitobjekt, 
  gesamtbewertung,
  punkt,
  datum,
  gemeindename,
  x_koordinate,
  y_koordinate,
  bioerhebung,
  importdatum
FROM 
  ${dbSchema}.csv_import
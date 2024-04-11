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
  gesamtbewertung AS gesamtbewertung_txt,
  x_koordinate, 
  y_koordinate, 
  datum, 
  gemeindename, 
  punkt, 
  bioerhebung, 
  importdatum,
  dok_url
FROM 
  ${dbSchema}.quelle_ungefasst;
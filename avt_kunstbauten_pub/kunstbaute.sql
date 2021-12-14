WITH

kat_translation AS ( -- Codetabelle gemäss AVT
  SELECT 
    * 
  FROM (
    VALUES 
      (1, 'Brücken (Flüsse)'), 
      (2, 'Brücken (sonstige)'), 
      (3, 'Durchlässe'), 
      (4, 'Querungen'),
      (5, 'Bahnüber-/unterführungen'),
      (6, 'Spezialbauwerke'),
      (7, 'SABA'),
      (8, 'Tunnel'),
      (9, 'Tierquerungen'),
      (10, 'Stützmauern')
  ) 
  AS t (kat, trans)
)

SELECT 
  t_ili_tid, 
  apoint, 
  aname, 
  kubaid, 
  bezugspunkt, 
  eigentuemer, 
  gemeinde, 
  typ, 
  erhaltungspflichtiger, 
  baujahr, 
  laenge, 
  breite, 
  kategorie, 
  COALESCE(trans, '-nicht übersetzt-') as kategorie_txt, 
  link
FROM 
  avt_kunstbauten_staging_v1.kunstbaute kuba
LEFT JOIN
  kat_translation trans
    ON kuba.kategorie = trans.kat
;
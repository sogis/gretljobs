/* zuerst alte Flächen löschen */
DELETE FROM 
  ${DB_Schema_QRcat}.qrcat_letalflaeche 
/*WHERE 
  id_szenario = 123*/
;
  
/* dann neue Flächen einfügen */
WITH szen_temp AS (
  SELECT
    s.t_id,
    s.geometrie,
    /* äusserer Radius */
    ST_Buffer(
      s.geometrie, lsz_1, 'quad_segs=90'
    ) AS buffer_geom_lr1,
    /* innerer Radius */
    ST_Buffer(
      s.geometrie, lsz_90, 'quad_segs=90'
    ) AS buffer_geom_lr90,
    s.szenario_art,
    s.wahrscheinlichkeit_szenario,
    s.lsz_90,
    s.lsz_1,
    /* Eintretenswahrscheinlichkeiten berechnen - in Abhängigkeit von Grob- und Detail, sowie ToxRef-Szenario */
    /* Wahrscheinlichkeit für äusseren Radius lr1
       Werte gemäss Tabelle (Konzept / RCAT Dokumentation) oder ToxReferenzSzenario (Gaswolken) */
    CASE WHEN ds.abkuerzung_detailszenario IN ('lb', 'fsb') THEN 0.8 WHEN ds.abkuerzung_detailszenario = 'eg' THEN 0.1 WHEN ds.abkuerzung_detailszenario = 'ef' THEN 0.075 WHEN ds.abkuerzung_detailszenario = 'et' THEN 0.1 WHEN ds.abkuerzung_detailszenario IN ('g-', 'gr-', 'tf-') THEN tr.lw1_letalwert::numeric / 100 END AS lw1, 
    
    /* Wahrscheinlichkeit für inneren Radius lr90
       Werte gemäss Tabelle (Konzept / RCAT Dokumentation) oder ToxReferenzSzenario (Gaswolken) */
    CASE WHEN ds.abkuerzung_detailszenario IN ('g-', 'gr-', 'tf-') THEN tr.lw90_letalwert::numeric / 100 ELSE 1.0 END AS lw90 
  FROM 
    ${DB_Schema_QRcat}.qrcat_szenario s 
    LEFT JOIN ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit ds ON s.id_detailszenarioghk = ds.t_id 
    LEFT JOIN ${DB_Schema_QRcat}.qrcat_toxreferenzszenario tr ON s.id_toxreferenzszenario = tr.t_id 
  /* WHERE 
    s.t_id IN (65,66,67,70,71,72) */
),
/* Verschnitte mit verschiednen Arten des Hektarrasters: Wohn-, Arbeits- und kombinierte Bevölkerung */
szen AS (
  SELECT 
    s.*, 
    
    /* Wohnbevölkerung LR1 */
    (
      SELECT 
        SUM(
          Round(
            (
              ST_Area(
                ST_Intersection(s.buffer_geom_lr1, p.geometrie)
              ) / 10000 * p.population_onlypermantresidents
            ):: numeric, 
            2
          )
        ) 
      FROM 
        arp_statpop_statent_v1.hektarraster_statpopstatent p 
      WHERE 
        ST_Intersects(s.buffer_geom_lr1, p.geometrie)
    ) AS wbev_lr1, 
    
    /* Wohnbevölkerung LR90 */
    (
      SELECT 
        SUM(
          Round(
            (
              ST_Area(
                ST_Intersection(s.buffer_geom_lr90, p.geometrie)
              ) / 10000 * p.population_onlypermantresidents
            ):: numeric, 
            2
          )
        ) 
      FROM 
        arp_statpop_statent_v1.hektarraster_statpopstatent p 
      WHERE 
        ST_Intersects(s.buffer_geom_lr1, p.geometrie)
    ) AS wbev_lr90, 
    
    /* Arbeitsbevölkerung LR1 */
    (
      SELECT 
        SUM(
          Round(
            (
              ST_Area(
                ST_Intersection(s.buffer_geom_lr1, p.geometrie)
              ) / 10000 * p.employees_total
            ):: numeric, 
            2
          )
        ) 
      FROM 
        arp_statpop_statent_v1.hektarraster_statpopstatent p 
      WHERE 
        ST_Intersects(s.buffer_geom_lr1, p.geometrie)
    ) AS abev_lr1, 
    
    /* Arbeitsbevölkerung LR90 */
    (
      SELECT 
        SUM(
          Round(
            (
              ST_Area(
                ST_Intersection(s.buffer_geom_lr90, p.geometrie)
              ) / 10000 * p.employees_total
            ):: numeric, 
            2
          )
        ) 
      FROM 
        arp_statpop_statent_v1.hektarraster_statpopstatent p 
      WHERE 
        ST_Intersects(s.buffer_geom_lr90, p.geometrie)
    ) AS abev_lr90, 
    
    /* Wohn- und Arbeitsbevölkerung, je 50% LR1 */
    (
      SELECT 
        SUM(
          Round(
            (
              ST_Area(
                ST_Intersection(s.buffer_geom_lr1, p.geometrie)
              ) / 10000 * (
                p.employees_total * 0.5 + p.population_onlypermantresidents * 0.5
              )
            ):: numeric, 
            2
          )
        ) 
      FROM 
        arp_statpop_statent_v1.hektarraster_statpopstatent p 
      WHERE 
        ST_Intersects(s.buffer_geom_lr1, p.geometrie)
    ) AS wabev_lr1, 
    
    /* Wohn- und Arbeitsbevölkerung, je 50% LR90 */
    (
      SELECT 
        SUM(
          Round(
            (
              ST_Area(
                ST_Intersection(s.buffer_geom_lr90, p.geometrie)
              ) / 10000 * (
                p.employees_total * 0.5 + p.population_onlypermantresidents * 0.5
              )
            ):: numeric, 
            2
          )
        ) 
      FROM 
        arp_statpop_statent_v1.hektarraster_statpopstatent p 
      WHERE 
        ST_Intersects(s.buffer_geom_lr90, p.geometrie)
    ) AS wabev_lr90 
  FROM 
    szen_temp s
)

--/* the actual insert */
INSERT INTO ${DB_Schema_QRcat}.qrcat_letalflaeche (
  t_ili_tid, geometrie, letalitaetsradius_art, 
  letalitaetsradius, bevoelkerung_typ, 
  bevoelkerung_anzahl, risikozahl, 
  anzahl_tote, id_szenario
)
/* Wohnbevoelkerung LR1, äusserer Radius */
SELECT 
  uuid_generate_v4() AS t_ili_tid, 
  buffer_geom_lr1 AS geometrie, 
  'r_lr_1' AS letalitaetsradius_art, 
  lsz_1 AS letalitaetsradius, 
  'Wohnbevoelkerung' AS bevoelkerung_typ, 
  wbev_lr1 AS bevoelkerung_anzahl,
  /* Risikozahl berechnen */
  (
    lw1 *(wbev_lr1 - wbev_lr90) + lw90 * wbev_lr90
  ) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl,
  /* Anzahl Tote im Szenario berechnen */
  Round(
    (
      lw1 *(wbev_lr1 - wbev_lr90) + lw90 * wbev_lr90
    ), 
    2
  ) AS anzahl_tote, 
  t_id AS id_szenario 
FROM 
  szen 
UNION 
  
  /* Wohnbevoelkerung LR90, innerer Radius */
SELECT 
  uuid_generate_v4() AS t_ili_tid, 
  buffer_geom_lr90 AS geometrie, 
  'r_lr_90' AS letalitaetsradius_art, 
  lsz_90 AS letalitaetsradius, 
  'Wohnbevoelkerung' AS bevoelkerung_typ, 
  wbev_lr90 AS bevoelkerung_anzahl, 
  (lw90 * wbev_lr90) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
  Round(
    (lw90 * wbev_lr90), 
    2
  ) AS anzahl_tote, 
  t_id AS id_szenario 
FROM 
  szen 
UNION 
  
  /* Arbeitsbevoelkerung LR1, äusserer Radius */
SELECT 
  uuid_generate_v4() AS t_ili_tid, 
  buffer_geom_lr1 AS geometrie, 
  'r_lr_1' AS letalitaetsradius_art, 
  lsz_1 AS letalitaetsradius, 
  'Arbeitsbevoelkerung' AS bevoelkerung_typ, 
  abev_lr1 AS bevoelkerung_anzahl, 
  (
    lw1 *(abev_lr1 - abev_lr90) + lw90 * abev_lr90
  ) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
  Round(
    (
      lw1 *(abev_lr1 - abev_lr90) + lw90 * abev_lr90
    ), 
    2
  ) AS anzahl_tote, 
  t_id AS id_szenario 
FROM 
  szen 
UNION 
  
  /* Arbeitsbevoelkerung LR90, innerer Radius */
SELECT 
  uuid_generate_v4() AS t_ili_tid, 
  buffer_geom_lr90 AS geometrie, 
  'r_lr_90' AS letalitaetsradius_art, 
  lsz_90 AS letalitaetsradius, 
  'Arbeitsbevoelkerung' AS bevoelkerung_typ, 
  abev_lr90 AS bevoelkerung_anzahl, 
  (lw90 * abev_lr90) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
  Round(
    (lw90 * abev_lr90), 
    2
  ) AS anzahl_tote, 
  t_id AS id_szenario 
FROM 
  szen 
UNION 
  
  /* Wohn- und Arbeitsbevoelkerung je 50% LR1, äusserer Radius */
SELECT 
  uuid_generate_v4() AS t_ili_tid, 
  buffer_geom_lr1 AS geometrie, 
  'r_lr_1' AS letalitaetsradius_art, 
  lsz_1 AS letalitaetsradius, 
  'WohnUndArbeitsbevoelkerung' AS bevoelkerung_typ, 
  wabev_lr1 AS bevoelkerung_anzahl, 
  (
    lw1 *(wabev_lr1 - wabev_lr90) + lw90 * wabev_lr90
  ) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
  Round(
    (
      lw1 *(wabev_lr1 - wabev_lr90) + lw90 * wabev_lr90
    ), 
    2
  ) AS anzahl_tote, 
  t_id AS id_szenario 
FROM 
  szen 
UNION 
  
  /* Wohn- und Arbeitsbevoelkerung je 50%  LR90, innerer Radius */
SELECT 
  uuid_generate_v4() AS t_ili_tid, 
  buffer_geom_lr90 AS geometrie, 
  'r_lr_90' AS letalitaetsradius_art, 
  lsz_90 AS letalitaetsradius, 
  'WohnUndArbeitsbevoelkerung' AS bevoelkerung_typ, 
  wabev_lr90 AS bevoelkerung_anzahl, 
  (lw90 * wabev_lr90) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
  ceil(lw90 * wabev_lr90) AS anzahl_tote, 
  t_id AS id_szenario 
FROM 
  szen 
ORDER BY
  9 ASC, --id_szenario
  5 ASC, --bevoelkerung_typ
  3 ASC  --letalitaetsradius_art
;

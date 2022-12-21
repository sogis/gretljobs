/* zuerst alte Flächen löschen */
DELETE FROM 
  afu_qrcat_v1.qrcat_letalflaeche 
WHERE 
  id_szenario = 637;
/* dann neue Flächen einfügen */
WITH szen_temp AS (
  SELECT 
    s.t_id, 
    s.geometrie, 
    ST_Buffer(
      s.geometrie, lsz_1, 'quad_segs=10'
    ) AS buffer_geom_lr1, 
    ST_Buffer(
      s.geometrie, lsz_90, 'quad_segs=10'
    ) AS buffer_geom_lr90, 
    s.szenario_art, 
    s.wahrscheinlichkeit_szenario, 
    s.lsz_90, 
    s.lsz_1, 
    
    /* äusserer Radius lr1
       Werte gemäss Tabelle (Konzept / RCAT Dokumentation) oder ToxReferenzSzenario (Gaswolken) */
    CASE WHEN ds.abkuerzung_detailszenario IN ('lb', 'fsb') THEN 0.8 WHEN ds.abkuerzung_detailszenario = 'eg' THEN 0.1 WHEN ds.abkuerzung_detailszenario = 'ef' THEN 0.075 WHEN ds.abkuerzung_detailszenario = 'et' THEN 0.1 WHEN ds.abkuerzung_detailszenario IN ('g-', 'gr-', 'tf-') THEN tr.lw1_letalwert / 100 END AS lw1, 
    
    /* innerer Radius lr90
       Werte gemäss Tabelle (Konzept / RCAT Dokumentation) oder ToxReferenzSzenario (Gaswolken) */
    CASE WHEN ds.abkuerzung_detailszenario IN ('g-', 'gr-', 'tf-') THEN tr.lw90_letalwert / 100 ELSE 1.0 END AS lw90 
  FROM 
    afu_qrcat_v1.qrcat_szenario s 
    LEFT JOIN afu_qrcat_v1.qrcat_detailszenario_grundhaeufigkeit ds ON s.id_detailszenarioghk = ds.t_id 
    LEFT JOIN afu_qrcat_v1.qrcat_toxreferenzszenario tr ON s.id_toxreferenzszenario = tr.t_id 
  WHERE 
    s.t_id = 637
), 
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
) INSERT INTO afu_qrcat_v1.qrcat_letalflaeche (
  t_ili_tid, geometrie, letalitaetsradius_art, 
  letalitaetsradius, bevoelkerung_typ, 
  bevoelkerung_anzahl, risikozahl, 
  anzahl_tote, id_szenario
) 
/* Wohnbevoelkerung LR1 */
SELECT 
  uuid_generate_v4() AS t_id, 
  buffer_geom_lr1 AS geometrie, 
  'r_lr_1' AS letalitaetsradius_art, 
  lsz_1 AS letalitaetsradius, 
  'Wohnbevoelkerung' AS bevoelkerung_typ, 
  wbev_lr1 AS bevoelkerung_anzahl, 
  (
    lw1 *(wbev_lr1 - wbev_lr90) + lw90 * wbev_lr90
  ) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
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
  
  /* Wohnbevoelkerung LR90 */
SELECT 
  uuid_generate_v4() AS t_id, 
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
  
  /* Arbeitsbevoelkerung LR1 */
SELECT 
  uuid_generate_v4() AS t_id, 
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
  
  /* Arbeitsbevoelkerung LR90 */
SELECT 
  uuid_generate_v4() AS t_id, 
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
  
  /* Wohn- und Arbeitsbevoelkerung je 50% LR1 */
SELECT 
  uuid_generate_v4() AS t_id, 
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
  
  /* Wohn- und Arbeitsbevoelkerung je 50%  LR90 */
SELECT 
  uuid_generate_v4() AS t_id, 
  buffer_geom_lr90 AS geometrie, 
  'r_lr_90' AS letalitaetsradius_art, 
  lsz_90 AS letalitaetsradius, 
  'WohnUndArbeitsbevoelkerung' AS bevoelkerung_typ, 
  wabev_lr90 AS bevoelkerung_anzahl, 
  (lw90 * wabev_lr90) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
  Round(
    (lw90 * wabev_lr90), 
    2
  ) AS anzahl_tote, 
  t_id AS id_szenario 
FROM 
  szen 
ORDER BY 
  5 ASC, 
  3 ASC;

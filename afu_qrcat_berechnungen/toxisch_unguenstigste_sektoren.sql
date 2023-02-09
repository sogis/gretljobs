 /* zuerst alte Sektoren löschen */
  DELETE FROM 
    ${DB_Schema_QRcat}.qrcat_toxischunguenstigster_sektor 
  /*WHERE 
    id_szenario IN (55,70,71) */
;

/* Dann neue Sektoren berechnen und einfügen */

  /*  in einem ersten Schritt werden mit generate_series Kreissektoren erstellt, startend bei Nord (0 Grad)
   * und dann alle 60 Grad. Daran werden das Szenario (sz), Detailszenario Grundhäufigkeit (ds)
   * und ToxReferenzszenario (tr) gejoint (CROSS JOIN und LEFT JOIN) */
  WITH szen_temp AS (
    SELECT 
      sz.t_id, 
      sz.wahrscheinlichkeit_szenario, 
      sz.lsz_90, 
      sz.lsz_1, 
      se.angle, 
      
      /* Sektoren erzeugen durch Verschnitt zwischen Kreis und Dreieck */
      ST_Intersection(
        
        /* Kreis */
        ST_Buffer(
          sz.geometrie, sz.lsz_1, 'quad_segs=90'
        ), 
        
        /* Dreieck mit Hilfe von ST_Project
         * ST_Project funktioniert nur mit Geographie-Datentyp -> Braucht Transformation */
        ST_MakePolygon(
          ST_MakeLine(
            array[ sz.geometrie, 
            ST_Transform(
              ST_Project(
                ST_Transform(sz.geometrie, 4326):: geography, 
                sz.lsz_1 * 2, 
                radians(se.angle - 30)
              ):: geometry, 
              2056
            ), 
            ST_Transform(
              ST_Project(
                ST_Transform(sz.geometrie, 4326):: geography, 
                sz.lsz_1 * 2, 
                radians(se.angle + 30)
              ):: geometry, 
              2056
            ), 
            sz.geometrie ]
          )
        )
      ) AS sector_lr1, 
      ST_Intersection(
        
        /* Kreis */
        ST_Buffer(
          sz.geometrie, sz.lsz_90, 'quad_segs=90'
        ), 
        
        /* Dreieck mit Hilfe von ST_Project
         * ST_Project funktioniert nur mit Geographie-Datentyp -> Braucht Transformation */
        ST_MakePolygon(
          ST_MakeLine(
            array[ sz.geometrie, 
            ST_Transform(
              ST_Project(
                ST_Transform(sz.geometrie, 4326):: geography, 
                sz.lsz_90 * 2, 
                radians(se.angle - 30)
              ):: geometry, 
              2056
            ), 
            ST_Transform(
              ST_Project(
                ST_Transform(sz.geometrie, 4326):: geography, 
                sz.lsz_90 * 2, 
                radians(se.angle + 30)
              ):: geometry, 
              2056
            ), 
            sz.geometrie ]
          )
        )
      ) AS sector_lr90, 
      
      /* Berechnung Wahrscheinlichkeit in Abhängigkeit von Detailszenario - äusserer Radius lr1
       * Werte gemäss Tabelle (Konzept / RCAT Dokumentation) oder ToxReferenzSzenario (Gaswolken) */
      CASE WHEN ds.abkuerzung_detailszenario IN ('lb', 'fsb') THEN 0.8 WHEN ds.abkuerzung_detailszenario = 'eg' THEN 0.1 WHEN ds.abkuerzung_detailszenario = 'ef' THEN 0.075 WHEN ds.abkuerzung_detailszenario = 'et' THEN 0.1 WHEN ds.abkuerzung_detailszenario IN ('g-', 'gr-', 'tf-') THEN tr.lw1_letalwert::numeric / 100 END AS lw1, 
      
      /* Berechnung Wahrscheinlichkeit in Abhängigkeit von Detailszenario - innerer Radius lr90
       * Werte gemäss Tabelle (Konzept / RCAT Dokumentation) oder ToxReferenzSzenario (Gaswolken) */
      CASE WHEN ds.abkuerzung_detailszenario IN ('g-', 'gr-', 'tf-') THEN tr.lw90_letalwert::numeric / 100 ELSE 1.0 END AS lw90 
    FROM 
      (
        SELECT 
           /* die eigentliche Serie alle 60 Grad, startend bei 30 Grad (Zentrumswinkel Sektor) */
           generate_series(30, 360, 60) AS angle
      ) se
      CROSS JOIN ${DB_Schema_QRcat}.qrcat_szenario sz 
      LEFT JOIN ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit ds ON sz.id_detailszenarioghk = ds.t_id 
      LEFT JOIN ${DB_Schema_QRcat}.qrcat_toxreferenzszenario tr ON sz.id_toxreferenzszenario = tr.t_id 
    WHERE 
      sz.szenario_art = 'toxische_Wolke'/* AND sz.t_id IN (55,70,71)*/
  ),
  /* Als nächstes werden die oben erstellten Kreissektoren mit dem Hektarraster verschnitten um die Anteilsmässige
   * Bevölkerung zu erhalten, getrennt nach Wohnbevölkerung, Arbeitsbevölkerung und je 50% von beiden
   */
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
                  ST_Intersection(s.sector_lr1, p.geometrie)
                ) / 10000 * p.population_onlypermantresidents
              ):: numeric, 
              2
            )
          ) 
        FROM 
          arp_statpop_statent_v1.hektarraster_statpopstatent p 
        WHERE 
          ST_Intersects(s.sector_lr1, p.geometrie)
      ) AS wbev_lr1, 
      
      /* Arbeitsbevölkerung LR1 */
      (
        SELECT 
          SUM(
            Round(
              (
                ST_Area(
                  ST_Intersection(s.sector_lr1, p.geometrie)
                ) / 10000 * p.employees_total
              ):: numeric, 
              2
            )
          ) 
        FROM 
          arp_statpop_statent_v1.hektarraster_statpopstatent p 
        WHERE 
          ST_Intersects(s.sector_lr1, p.geometrie)
      ) AS abev_lr1, 
      
      /* Wohn- und Arbeitsbevölkerung, je 50% LR1 */
      (
        SELECT 
          SUM(
            Round(
              (
                ST_Area(
                  ST_Intersection(s.sector_lr1, p.geometrie)
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
          ST_Intersects(s.sector_lr1, p.geometrie)
      ) AS wabev_lr1,
      
      /* Wohnbevölkerung LR90 */
      (
        SELECT 
          SUM(
            Round(
              (
                ST_Area(
                  ST_Intersection(s.sector_lr90, p.geometrie)
                ) / 10000 * p.population_onlypermantresidents
              ):: numeric, 
              2
            )
          ) 
        FROM 
          arp_statpop_statent_v1.hektarraster_statpopstatent p 
        WHERE 
          ST_Intersects(s.sector_lr90, p.geometrie)
      ) AS wbev_lr90, 
      
      /* Arbeitsbevölkerung LR90 */
      (
        SELECT 
          SUM(
            Round(
              (
                ST_Area(
                  ST_Intersection(s.sector_lr90, p.geometrie)
                ) / 10000 * p.employees_total
              ):: numeric, 
              2
            )
          ) 
        FROM 
          arp_statpop_statent_v1.hektarraster_statpopstatent p 
        WHERE 
          ST_Intersects(s.sector_lr90, p.geometrie)
      ) AS abev_lr90, 

      /* Wohn- und Arbeitsbevölkerung, je 50% LR90 */
      (
        SELECT 
          SUM(
            Round(
              (
                ST_Area(
                  ST_Intersection(s.sector_lr90, p.geometrie)
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
          ST_Intersects(s.sector_lr90, p.geometrie)
      ) AS wabev_lr90
      
    FROM 
      szen_temp s
  )
  ,
  /* Schliesslich werden hier die Risikozahl und die Letalität berechnet
   * Selektiert wird jeweils der Sektor mit der höchsten Bevölkerungszahl pro id_szenario
   * Zunächst werden nur die äusseren, grösseren Radien LR1 herangezogen
   * damit später die inneren Sektoren den gleichen Winkel verwenden können
   */
  szen_count_lr1 AS (
    /* Wohnbevölkerung LR1 */
    SELECT 
      COUNT(*) AS anzahl_max,
      /* Der Winkel wird temporär benötigt, damit die inneren Sektoren den gleichen Winkel benutzen */
      avg(angle) AS angle,
      ST_Union(sector_lr1) AS geometrie, 
      'r_lr_1' AS letalitaetsradius_art, 
      lsz_1 AS letalitaetsradius, 
      'Wohnbevoelkerung' AS bevoelkerung_typ, 
      wbev_lr1 AS bevoelkerung_anzahl,
      /* Berechnung Risikozahl */
      (
        lw1 *(wbev_lr1 - wbev_lr90) + lw90 * wbev_lr90
      ) ^ 2 * wahrscheinlichkeit_szenario AS risikozahl, 
      /* Berechnung Anzahl Tote */
      Round(
        (
          lw1 *(wbev_lr1 - wbev_lr90) + lw90 * wbev_lr90
        ), 
        2
      ) AS anzahl_tote,
      /* Der Link zum Szenario */
      t_id AS id_szenario 
    FROM 
      szen sz_aussen
    WHERE 
      wbev_lr1 = (
        /* Hier wird sichergestellt, dass nur der Sektor mit der höchsten Bevölkerungszahl gewählt wird */
        SELECT 
          MAX(sz_innen.wbev_lr1) 
        FROM 
          szen sz_innen
            WHERE sz_innen.t_id = sz_aussen.t_id
      ) 
    GROUP BY 
      t_id, 
      wahrscheinlichkeit_szenario, 
      lsz_1, 
      lw1, 
      wbev_lr1, 
      wbev_lr90, 
      lw90
    UNION 
    /* Arbeitsbevölkerung LR1 */
    SELECT 
      COUNT(*) AS anzahl_max, 
      avg(angle) AS angle,
      ST_Union(sector_lr1) AS geometrie, 
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
      szen sz_aussen
    WHERE 
      abev_lr1 = (
        SELECT 
          MAX(sz_innen.abev_lr1) 
        FROM 
          szen sz_innen
            WHERE sz_innen.t_id = sz_aussen.t_id
      ) 
    GROUP BY 
      t_id, 
      wahrscheinlichkeit_szenario, 
      lsz_1, 
      lw1, 
      abev_lr1, 
      abev_lr90, 
      lw90 
    UNION 
    /* Wohn- und Arbeitsbevölkerung LR1 */
    SELECT 
      COUNT(*) AS anzahl_max, 
      avg(angle) AS angle,
      ST_Union(sector_lr1) AS geometrie, 
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
      szen sz_aussen
    WHERE 
      wabev_lr1 = (
        SELECT 
          MAX(sz_innen.wabev_lr1) 
        FROM 
          szen sz_innen
            WHERE sz_innen.t_id = sz_aussen.t_id
      ) 
    GROUP BY 
      t_id, 
      wahrscheinlichkeit_szenario, 
      lsz_1, 
      lw1, 
      wabev_lr1, 
      wabev_lr90, 
      lw90 
  ),
  /* Letztes Zwischenresultat das alle Resultate der äusseren Sektoren enthält
   * wie auch den Winkel des Sektors (angle)
   */
  sectors_lr1 AS (
      SELECT 
        uuid_generate_v4() AS t_ili_tid, 
        geometrie,
        angle,
        letalitaetsradius_art, 
        letalitaetsradius, 
        bevoelkerung_typ, 
        bevoelkerung_anzahl, 
        risikozahl, 
        anzahl_tote, 
        id_szenario 
      FROM 
        szen_count_lr1
      WHERE 
        bevoelkerung_anzahl > 0 
        AND anzahl_max = 1
  )
  /* Das eigentliche INSERT statement */
  INSERT INTO ${DB_Schema_QRcat}.qrcat_toxischunguenstigster_sektor (
    t_ili_tid, geometrie, letalitaetsradius_art, 
    letalitaetsradius, bevoelkerung_typ, 
    bevoelkerung_anzahl, risikozahl, 
    anzahl_tote, id_szenario
  ) 
  
  /* zuerst die 3 Sektoren des äusseren Radius */
  SELECT
    t_ili_tid,
    geometrie,
    letalitaetsradius_art,
    letalitaetsradius,
    bevoelkerung_typ,
    bevoelkerung_anzahl,
    risikozahl,
    anzahl_tote,
    id_szenario
  FROM sectors_lr1
  UNION
  /* LR90 Sektor(en) Wohnbevölkerung - inner Radius */
  SELECT
     uuid_generate_v4() AS t_ili_tid,
     slr90.sector_lr90 AS geometrie,
     'r_lr_90' AS letalitaetsradius_art,
     slr90.lsz_90 AS letalitaetsradius,
     'Wohnbevoelkerung' AS bevoelkerung_typ,
     slr90.wbev_lr90 AS bevoelkerung_anzahl,
     (slr90.lw90 * slr90.wbev_lr90) ^ 2 * slr90.wahrscheinlichkeit_szenario AS risikozahl,
     Round(
        (slr90.lw90 * slr90.wbev_lr90), 
        2
     ) AS anzahl_tote,
     slr1.id_szenario
  FROM sectors_lr1 slr1
    LEFT JOIN szen slr90 ON
      slr1.angle = slr90.angle
      AND slr1.id_szenario = slr90.t_id
  WHERE slr1.bevoelkerung_typ = 'Wohnbevoelkerung'
  UNION
  /* LR90 Sektor(en) Arbeitsbevölkerung - inner Radius */
  SELECT
     uuid_generate_v4() AS t_ili_tid,
     slr90.sector_lr90 AS geometrie,
     'r_lr_90' AS letalitaetsradius_art,
     slr90.lsz_90 AS letalitaetsradius,
     'Arbeitsbevoelkerung' AS bevoelkerung_typ,
     slr90.abev_lr90 AS bevoelkerung_anzahl,
     (slr90.lw90 * slr90.abev_lr90) ^ 2 * slr90.wahrscheinlichkeit_szenario AS risikozahl,
     Round(
        (slr90.lw90 * slr90.abev_lr90), 
        2
     ) AS anzahl_tote,
     slr1.id_szenario
  FROM sectors_lr1 slr1
    LEFT JOIN szen slr90 ON
      slr1.angle = slr90.angle
      AND slr1.id_szenario = slr90.t_id
  WHERE slr1.bevoelkerung_typ = 'Arbeitsbevoelkerung'
  UNION
  /* LR90 Sektor(en) Wohn- und Arbeitsbevölkerung - inner Radius */
  SELECT
     uuid_generate_v4() AS t_ili_tid,
     slr90.sector_lr90 AS geometrie,
     'r_lr_90' AS letalitaetsradius_art,
     slr90.lsz_90 AS letalitaetsradius,
     'WohnUndArbeitsbevoelkerung' AS bevoelkerung_typ,
     slr90.wabev_lr90 AS bevoelkerung_anzahl,
     (slr90.lw90 * slr90.wabev_lr90) ^ 2 * slr90.wahrscheinlichkeit_szenario AS risikozahl,
     Round(
        (slr90.lw90 * slr90.wabev_lr90), 
        2
     ) AS anzahl_tote,
     slr1.id_szenario
  FROM sectors_lr1 slr1
    LEFT JOIN szen slr90 ON
      slr1.angle = slr90.angle
      AND slr1.id_szenario = slr90.t_id
  WHERE slr1.bevoelkerung_typ = 'WohnUndArbeitsbevoelkerung'
  /* Sortierung */
  ORDER BY 
    id_szenario ASC, 
    bevoelkerung_typ DESC, 
    letalitaetsradius_art ASC
  ;

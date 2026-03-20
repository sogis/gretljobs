WITH gebaeude_src AS (
  SELECT
    t_id AS src_t_id,
    geometrie,
    bfs_nr
  FROM agi_mopublic_pub.mopublic_bodenbedeckung
  WHERE art_txt = 'Gebaeude'
    AND bfs_nr IN (2601)
)
SELECT
  b.src_t_id AS t_id,
  b.geometrie,
  -- Bestimmung des Verfahrens nach Priorität
  CASE
    WHEN (
      -- Tabellen 1,2,4,5,6 prüfen: wenn irgendwo ein Treffer -> Baubewilligungsverfahren
      EXISTS (
        SELECT 1
        FROM ada_denkmalschutz_pub_v1.denkmal_polygon p
        WHERE p.schutzstufe_code = 'geschuetzt'
          AND ST_Intersects(b.geometrie, p.mpoly)
          AND NOT ST_Touches(b.geometrie, p.mpoly)
      )
      OR EXISTS (
        SELECT 1
        FROM ada_denkmalschutz_pub_v1.denkmal_punkt p
        WHERE p.schutzstufe_code = 'geschuetzt'
          AND ST_Intersects(b.geometrie, p.mpunkt)  -- Multipoint: genügt, wenn ein Punkt innen/auf Rand ist
      )
      OR EXISTS (
        SELECT 1
        FROM arp_isos_inventar_pub_v2.isos_inventar i
        WHERE i.erhaltungsziel = 'A'
          AND ST_Intersects(b.geometrie, i.geometrie)
          AND NOT ST_Touches(b.geometrie, i.geometrie)
      )
      OR EXISTS (
        SELECT 1
        FROM arp_kulturgueterschutzobjekte_pub_v1.objekte k
        WHERE ST_Intersects(b.geometrie, k.geometrie)
          AND NOT ST_Touches(b.geometrie, k.geometrie)
      )
      OR EXISTS (
        SELECT 1
        FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
        WHERE
          (
            -- Tabelle 6 - Bedingungen für "Baubewilligungsverfahren"
            (b.bfs_nr = 2601 AND n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung = 'Altstadtzone')
            OR (b.bfs_nr = 2581 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Altstadtzone')
            OR (b.bfs_nr = 2422 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Kernzone Erhaltung')
          )
          AND ST_Intersects(b.geometrie, n.geometrie)
          AND NOT ST_Touches(b.geometrie, n.geometrie)
      )
    ) THEN 'Baubewilligungsverfahren'
    WHEN (
      -- Tabellen 7 oder 8 prüfen (nur, wenn keine Treffer in 1-6, wurde vorher geprüft): hier prüfen wir das Vorhandensein in 7/8
      EXISTS (
        SELECT 1
        FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
        WHERE
          (
            (b.bfs_nr = 2601 AND ( (n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N141_Zentrumszone','N142_Erhaltungszone')) ))
            OR (b.bfs_nr = 2581 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
            OR (b.bfs_nr = 2422 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Kernzone Erhaltung') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
          )
          AND ST_Intersects(b.geometrie, n.geometrie)
          AND NOT ST_Touches(b.geometrie, n.geometrie)
      )
      OR EXISTS (
        SELECT 1
        FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche u
        WHERE u.typ_kt = 'N510_ueberlagernde_Ortsbildschutzzone'
          AND ST_Intersects(b.geometrie, u.geometrie)
          AND NOT ST_Touches(b.geometrie, u.geometrie)
      )
    ) THEN 'Baubewilligungsverfahren_auf_kommunaler_Ebene_zu_klaeren'
    ELSE 'Meldeverfahren'
  END AS bewilligungsverfahren,
  -- bewilligungsverfahren_txt Mapping
  CASE
    WHEN
      (
        EXISTS (
          SELECT 1
          FROM ada_denkmalschutz_pub_v1.denkmal_polygon p
          WHERE p.schutzstufe_code = 'geschuetzt'
            AND ST_Intersects(b.geometrie, p.mpoly)
            AND NOT ST_Touches(b.geometrie, p.mpoly)
        )
        OR EXISTS (
          SELECT 1
          FROM ada_denkmalschutz_pub_v1.denkmal_punkt p
          WHERE p.schutzstufe_code = 'geschuetzt'
            AND ST_Intersects(b.geometrie, p.mpunkt)
        )
        OR EXISTS (
          SELECT 1
          FROM arp_isos_inventar_pub_v2.isos_inventar i
          WHERE i.erhaltungsziel = 'A'
            AND ST_Intersects(b.geometrie, i.geometrie)
            AND NOT ST_Touches(b.geometrie, i.geometrie)
        )
        OR EXISTS (
          SELECT 1
          FROM arp_kulturgueterschutzobjekte_pub_v1.objekte k
          WHERE ST_Intersects(b.geometrie, k.geometrie)
            AND NOT ST_Touches(b.geometrie, k.geometrie)
        )
        OR EXISTS (
          SELECT 1
          FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
          WHERE
            (
              (b.bfs_nr = 2601 AND n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung = 'Altstadtzone')
              OR (b.bfs_nr = 2581 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Altstadtzone')
              OR (b.bfs_nr = 2422 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Kernzone Erhaltung')
            )
            AND ST_Intersects(b.geometrie, n.geometrie)
            AND NOT ST_Touches(b.geometrie, n.geometrie)
        )
      )
    THEN 'Baubewilligungsverfahren'
    WHEN
      (
        EXISTS (
          SELECT 1
          FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
          WHERE
            (
              (b.bfs_nr = 2601 AND ( (n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N141_Zentrumszone','N142_Erhaltungszone')) ))
              OR (b.bfs_nr = 2581 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
              OR (b.bfs_nr = 2422 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Kernzone Erhaltung') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
            )
            AND ST_Intersects(b.geometrie, n.geometrie)
            AND NOT ST_Touches(b.geometrie, n.geometrie)
        )
        OR EXISTS (
          SELECT 1
          FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche u
          WHERE u.typ_kt = 'N510_ueberlagernde_Ortsbildschutzzone'
            AND ST_Intersects(b.geometrie, u.geometrie)
            AND NOT ST_Touches(b.geometrie, u.geometrie)
        )
      )
    THEN 'Baubewilligungsverfahren auf kommunaler Ebene zu klären'
    ELSE 'Meldeverfahren'
  END AS bewilligungsverfahren_txt,
  -- objektinformation: Zusammenführen aller Layer-Objektinformationen als jsonb-Array
  (
    COALESCE(denk_poly.json_arr, '[]'::jsonb)
    || COALESCE(denk_punkt.json_arr, '[]'::jsonb)
    || COALESCE(isos.json_arr, '[]'::jsonb)
    || COALESCE(kgs.json_arr, '[]'::jsonb)
    || COALESCE(nutz_6.json_arr, '[]'::jsonb)
    || COALESCE(nutz_7.json_arr, '[]'::jsonb)
    || COALESCE(nutz_8.json_arr, '[]'::jsonb)
  ) AS objektinformation
FROM gebaeude_src b
-- Denkmalschutz Polygon (Tabelle 1)
LEFT JOIN LATERAL (
  SELECT COALESCE(jsonb_agg(obj), '[]'::jsonb) AS json_arr
  FROM (
    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Objektname',
        'Wert', p.objektname
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_polygon p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND ST_Intersects(b.geometrie, p.mpoly)
      AND NOT ST_Touches(b.geometrie, p.mpoly)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Schutzstatus',
        'Wert', p.schutzstufe_text
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_polygon p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND ST_Intersects(b.geometrie, p.mpoly)
      AND NOT ST_Touches(b.geometrie, p.mpoly)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Objektblatt',
        'Wert', p.objektblatt
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_polygon p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND ST_Intersects(b.geometrie, p.mpoly)
      AND NOT ST_Touches(b.geometrie, p.mpoly)

    UNION ALL

    -- Dokumente aus rechtsvorschriften (falls vorhanden) als separates JSON-Objekt pro Feature
    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Dokumente',
        'Dokumente',
          COALESCE(
            (
              SELECT jsonb_agg(jsonb_build_object(
                'Titel', elem->>'Titel',
                'Abkuerzung', NULL,
                'Nummer', elem->>'Nummer',
                'Datum', elem->>'Datum',
                'Link', elem->>'Link',
                'Rechtsstatus', NULL
              ))
              FROM jsonb_array_elements(p.rechtsvorschriften) AS de(elem)
            ),
            '[]'::jsonb
          )
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_polygon p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND p.rechtsvorschriften IS NOT NULL
      AND ST_Intersects(b.geometrie, p.mpoly)
      AND NOT ST_Touches(b.geometrie, p.mpoly)
  ) s
) denk_poly ON true

-- Denkmalschutz Punkt (Tabelle 2)
LEFT JOIN LATERAL (
  SELECT COALESCE(jsonb_agg(obj), '[]'::jsonb) AS json_arr
  FROM (
    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Objektname',
        'Wert', p.objektname
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_punkt p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND ST_Intersects(b.geometrie, p.mpunkt)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Schutzstatus',
        'Wert', p.schutzstufe_text
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_punkt p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND ST_Intersects(b.geometrie, p.mpunkt)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Objektblatt',
        'Wert', p.objektblatt
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_punkt p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND ST_Intersects(b.geometrie, p.mpunkt)

    UNION ALL

    -- Dokumente aus rechtsvorschriften
    SELECT
      jsonb_build_object(
        '@type', 'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema', 'Denkmalschutz',
        'Bezeichnung', 'Dokumente',
        'Dokumente',
          COALESCE(
            (
              SELECT jsonb_agg(jsonb_build_object(
                'Titel', elem->>'Titel',
                'Abkuerzung', NULL,
                'Nummer', elem->>'Nummer',
                'Datum', elem->>'Datum',
                'Link', elem->>'Link',
                'Rechtsstatus', NULL
              ))
              FROM jsonb_array_elements(p.rechtsvorschriften) AS de(elem)
            ),
            '[]'::jsonb
          )
      ) AS obj
    FROM ada_denkmalschutz_pub_v1.denkmal_punkt p
    WHERE p.schutzstufe_code = 'geschuetzt'
      AND p.rechtsvorschriften IS NOT NULL
      AND ST_Intersects(b.geometrie, p.mpunkt)
  ) s
) denk_punkt ON true

-- ISOS-A (Tabelle 4)
LEFT JOIN LATERAL (
  SELECT COALESCE(jsonb_agg(obj), '[]'::jsonb) AS json_arr
  FROM (
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','ISOS-A',
        'Bezeichnung','Objektname',
        'Wert', i.objektname
      ) AS obj
    FROM arp_isos_inventar_pub_v2.isos_inventar i
    WHERE i.erhaltungsziel = 'A'
      AND ST_Intersects(b.geometrie, i.geometrie)
      AND NOT ST_Touches(b.geometrie, i.geometrie)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','ISOS-A',
        'Bezeichnung','Nummer',
        'Wert', i.nummer
      ) AS obj
    FROM arp_isos_inventar_pub_v2.isos_inventar i
    WHERE i.erhaltungsziel = 'A'
      AND ST_Intersects(b.geometrie, i.geometrie)
      AND NOT ST_Touches(b.geometrie, i.geometrie)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','ISOS-A',
        'Bezeichnung','Objektblatt',
        'Wert', i.link_objektblatt
      ) AS obj
    FROM arp_isos_inventar_pub_v2.isos_inventar i
    WHERE i.erhaltungsziel = 'A'
      AND ST_Intersects(b.geometrie, i.geometrie)
      AND NOT ST_Touches(b.geometrie, i.geometrie)
  ) s
) isos ON true

-- KGS-Objekt (Tabelle 5)
LEFT JOIN LATERAL (
  SELECT COALESCE(jsonb_agg(obj), '[]'::jsonb) AS json_arr
  FROM (
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','KGS-Objekt',
        'Bezeichnung','Kategorie',
        'Wert', o.kategorie_txt
      ) AS obj
    FROM arp_kulturgueterschutzobjekte_pub_v1.objekte o
    WHERE ST_Intersects(b.geometrie, o.geometrie)
      AND NOT ST_Touches(b.geometrie, o.geometrie)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','KGS-Objekt',
        'Bezeichnung','Bezeichnung',
        'Wert', o.bezeichnung
      ) AS obj
    FROM arp_kulturgueterschutzobjekte_pub_v1.objekte o
    WHERE ST_Intersects(b.geometrie, o.geometrie)
      AND NOT ST_Touches(b.geometrie, o.geometrie)
  ) s
) kgs ON true

-- Nutzungsplanung (Tabelle 6) - spezielle Bedingung
LEFT JOIN LATERAL (
  SELECT COALESCE(jsonb_agg(obj), '[]'::jsonb) AS json_arr
  FROM (
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Typ',
        'Wert', n.typ_kt
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
    WHERE
      (
        (b.bfs_nr = 2601 AND n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung = 'Altstadtzone')
        OR (b.bfs_nr = 2581 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Altstadtzone')
        OR (b.bfs_nr = 2422 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Kernzone Erhaltung')
      )
      AND ST_Intersects(b.geometrie, n.geometrie)
      AND NOT ST_Touches(b.geometrie, n.geometrie)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Bezeichnung',
        'Wert', n.typ_bezeichnung
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
    WHERE
      (
        (b.bfs_nr = 2601 AND n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung = 'Altstadtzone')
        OR (b.bfs_nr = 2581 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Altstadtzone')
        OR (b.bfs_nr = 2422 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Kernzone Erhaltung')
      )
      AND ST_Intersects(b.geometrie, n.geometrie)
      AND NOT ST_Touches(b.geometrie, n.geometrie)

    UNION ALL

    -- Dokumente aus dokumente jsonb (falls vorhanden)
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Dokumente',
        'Dokumente',
          COALESCE(
            (
              SELECT jsonb_agg(jsonb_build_object(
                'Titel', elem->>'OffiziellerTitel',
                'Abkuerzung', elem->>'Abkuerzung',
                'Nummer', elem->>'OffizielleNr',
                'Datum', elem->>'publiziertAb',
                'Link', elem->>'TextimWeb',
                'Rechtsstatus', elem->>'Rechtsstatus'
              ))
              FROM jsonb_array_elements(n.dokumente) AS de(elem)
            ),
            '[]'::jsonb
          )
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
    WHERE
      (
        (b.bfs_nr = 2601 AND n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung = 'Altstadtzone')
        OR (b.bfs_nr = 2581 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Altstadtzone')
        OR (b.bfs_nr = 2422 AND n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung = 'Kernzone Erhaltung')
      )
      AND n.dokumente IS NOT NULL
      AND ST_Intersects(b.geometrie, n.geometrie)
      AND NOT ST_Touches(b.geometrie, n.geometrie)
  ) s
) nutz_6 ON true

-- Nutzungsplanung (Tabelle 7) - andere Bedingung (kommunale Ebene)
LEFT JOIN LATERAL (
  SELECT COALESCE(jsonb_agg(obj), '[]'::jsonb) AS json_arr
  FROM (
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Typ',
        'Wert', n.typ_kt
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
    WHERE
      (
        (b.bfs_nr = 2601 AND ( (n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N141_Zentrumszone','N142_Erhaltungszone')) ))
        OR (b.bfs_nr = 2581 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
        OR (b.bfs_nr = 2422 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Kernzone Erhaltung') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
      )
      AND ST_Intersects(b.geometrie, n.geometrie)
      AND NOT ST_Touches(b.geometrie, n.geometrie)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Bezeichnung',
        'Wert', n.typ_bezeichnung
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
    WHERE
      (
        (b.bfs_nr = 2601 AND ( (n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N141_Zentrumszone','N142_Erhaltungszone')) ))
        OR (b.bfs_nr = 2581 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
        OR (b.bfs_nr = 2422 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Kernzone Erhaltung') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
      )
      AND ST_Intersects(b.geometrie, n.geometrie)
      AND NOT ST_Touches(b.geometrie, n.geometrie)

    UNION ALL

    -- Dokumente
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Dokumente',
        'Dokumente',
          COALESCE(
            (
              SELECT jsonb_agg(jsonb_build_object(
                'Titel', elem->>'OffiziellerTitel',
                'Abkuerzung', elem->>'Abkuerzung',
                'Nummer', elem->>'OffizielleNr',
                'Datum', elem->>'publiziertAb',
                'Link', elem->>'TextimWeb',
                'Rechtsstatus', elem->>'Rechtsstatus'
              ))
              FROM jsonb_array_elements(n.dokumente) AS de(elem)
            ),
            '[]'::jsonb
          )
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
    WHERE
      (
        (b.bfs_nr = 2601 AND ( (n.typ_kt = 'N140_Kernzone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N141_Zentrumszone','N142_Erhaltungszone')) ))
        OR (b.bfs_nr = 2581 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Altstadtzone') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
        OR (b.bfs_nr = 2422 AND ( (n.typ_kt = 'N142_Erhaltungszone' AND n.typ_bezeichnung <> 'Kernzone Erhaltung') OR (n.typ_kt IN ('N140_Kernzone','N141_Zentrumszone')) ))
      )
      AND n.dokumente IS NOT NULL
      AND ST_Intersects(b.geometrie, n.geometrie)
      AND NOT ST_Touches(b.geometrie, n.geometrie)
  ) s
) nutz_7 ON true

-- Nutzungsplanung ueberlagernd_flaeche (Tabelle 8)
LEFT JOIN LATERAL (
  SELECT COALESCE(jsonb_agg(obj), '[]'::jsonb) AS json_arr
  FROM (
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Typ',
        'Wert', u.typ_kt
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche u
    WHERE u.typ_kt = 'N510_ueberlagernde_Ortsbildschutzzone'
      AND ST_Intersects(b.geometrie, u.geometrie)
      AND NOT ST_Touches(b.geometrie, u.geometrie)

    UNION ALL

    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Bezeichnung',
        'Wert', u.typ_bezeichnung
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche u
    WHERE u.typ_kt = 'N510_ueberlagernde_Ortsbildschutzzone'
      AND ST_Intersects(b.geometrie, u.geometrie)
      AND NOT ST_Touches(b.geometrie, u.geometrie)

    UNION ALL

    -- Dokumente
    SELECT
      jsonb_build_object(
        '@type','SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
        'Thema','Nutzungsplanung',
        'Bezeichnung','Dokumente',
        'Dokumente',
          COALESCE(
            (
              SELECT jsonb_agg(jsonb_build_object(
                'Titel', elem->>'OffiziellerTitel',
                'Abkuerzung', elem->>'Abkuerzung',
                'Nummer', elem->>'OffizielleNr',
                'Datum', elem->>'publiziertAb',
                'Link', elem->>'TextimWeb',
                'Rechtsstatus', elem->>'Rechtsstatus'
              ))
              FROM jsonb_array_elements(u.dokumente) AS de(elem)
            ),
            '[]'::jsonb
          )
      ) AS obj
    FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche u
    WHERE u.typ_kt = 'N510_ueberlagernde_Ortsbildschutzzone'
      AND u.dokumente IS NOT NULL
      AND ST_Intersects(b.geometrie, u.geometrie)
      AND NOT ST_Touches(b.geometrie, u.geometrie)
  ) s
) nutz_8 ON true
;

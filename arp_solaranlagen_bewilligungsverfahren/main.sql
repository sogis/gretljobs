WITH gebaeude_src AS (
    SELECT
        t_id AS src_t_id,
        ST_GeomFromWKB(geometrie) AS geometrie,
        bfs_nr,
        art_txt
    FROM pubdb.agi_mopublic_pub.mopublic_bodenbedeckung
    WHERE art_txt = 'Gebaeude'
      AND bfs_nr = ${bfsnr}

    UNION ALL

    SELECT
        t_id AS src_t_id,
        ST_GeomFromWKB(geometrie) AS geometrie,
        bfs_nr,
        art_txt
    FROM pubdb.agi_mopublic_pub.mopublic_einzelobjekt_flaeche
    WHERE art_txt = 'Unterstand'
      AND bfs_nr = ${bfsnr}
),

hit_denk_poly AS (
    SELECT
        b.src_t_id,
        CAST(p.t_id AS VARCHAR) AS ref_objekt_id,
        p.objektname,
        p.schutzstufe_text,
        p.objektblatt,
        p.rechtsvorschriften
    FROM gebaeude_src b
    JOIN pubdb.ada_denkmalschutz_pub_v1.denkmal_polygon p
      ON p.schutzstufe_code = 'geschuetzt'
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(p.mpoly))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(p.mpoly))
),

hit_denk_punkt AS (
    SELECT
        b.src_t_id,
        CAST(p.t_id AS VARCHAR) AS ref_objekt_id,
        p.objektname,
        p.schutzstufe_text,
        p.objektblatt,
        p.rechtsvorschriften
    FROM gebaeude_src b
    JOIN pubdb.ada_denkmalschutz_pub_v1.denkmal_punkt p
      ON p.schutzstufe_code = 'geschuetzt'
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(p.mpunkt))
),

hit_isos AS (
    SELECT
        b.src_t_id,
        CAST(i.t_id AS VARCHAR) AS ref_objekt_id,
        i.objektname,
        i.nummer,
        i.link_objektblatt
    FROM gebaeude_src b
    JOIN pubdb.arp_isos_inventar_pub_v2.isos_inventar i
      ON i.erhaltungsziel = 'A'
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(i.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(i.geometrie))
),

hit_kgs AS (
    SELECT
        b.src_t_id,
        CAST(o.t_id AS VARCHAR) AS ref_objekt_id,
        o.kategorie_txt,
        o.bezeichnung
    FROM gebaeude_src b
    JOIN pubdb.arp_kulturgueterschutzobjekte_pub_v1.objekte o
      ON o.kategorie_txt IN (
            'A - Kulturgut von nationaler Bedeutung',
            'B - Kulturgut von regionaler Bedeutung'
         )
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(o.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(o.geometrie))
),

hit_nutz_grundnutzung AS (
    SELECT
        b.src_t_id,
        CAST(n.t_id AS VARCHAR) AS ref_objekt_id,
        n.typ_kt,
        n.typ_bezeichnung,
        n.dokumente,
        CASE
            WHEN (
                n.typ_kt = 'N142_Erhaltungszone'
                OR (n.bfs_nr = 2601 AND n.typ_bezeichnung = 'Altstadtzone')
                OR (n.bfs_nr = 2581 AND n.typ_bezeichnung = 'Altstadtzone')
                OR (n.bfs_nr = 2422 AND n.typ_bezeichnung = 'Engere Kernzone')
            )
                THEN 'Baubewilligungsverfahren'
            WHEN n.typ_kt = 'N140_Kernzone'
                THEN 'Bewilligungsverfahren_auf_kommunaler_Ebene_zu_klaeren'
        END AS verfahrensklasse
    FROM gebaeude_src b
    JOIN pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
      ON (
            n.typ_kt IN ('N140_Kernzone', 'N142_Erhaltungszone')
            OR (n.bfs_nr = 2601 AND n.typ_bezeichnung = 'Altstadtzone')
            OR (n.bfs_nr = 2581 AND n.typ_bezeichnung = 'Altstadtzone')
            OR (n.bfs_nr = 2422 AND n.typ_bezeichnung = 'Engere Kernzone')
         )
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(n.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(n.geometrie))
   WHERE n.bfs_nr = ${bfsnr}
),

hit_nutz_ortsbild AS (
    SELECT
        b.src_t_id,
        CAST(u.t_id AS VARCHAR) AS ref_objekt_id,
        u.typ_kt,
        u.typ_bezeichnung,
        u.dokumente
    FROM gebaeude_src b
    JOIN pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche u
      ON u.typ_kt = 'N510_ueberlagernde_Ortsbildschutzzone'
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(u.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(u.geometrie))
   WHERE u.bfs_nr = ${bfsnr}
),

hit_nutz_n141 AS (
    SELECT
        b.src_t_id,
        CAST(n.t_id AS VARCHAR) AS ref_objekt_id,
        n.typ_kt,
        n.typ_bezeichnung,
        n.dokumente
    FROM gebaeude_src b
    JOIN pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
      ON n.typ_kt = 'N141_Zentrumszone'
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(n.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(n.geometrie))
   WHERE n.bfs_nr = ${bfsnr}
),

hit_nutz_821 AS (
    SELECT
        b.src_t_id,
        CAST(u.t_id AS VARCHAR) AS ref_objekt_id,
        u.typ_kt,
        u.typ_bezeichnung,
        u.dokumente
    FROM gebaeude_src b
    JOIN pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche u
      ON u.typ_kt = 'N821_kommunal_geschuetztes_Kulturobjekt'
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(u.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(u.geometrie))
   WHERE u.bfs_nr = ${bfsnr}
),

flags AS (
    SELECT
        b.src_t_id,
        b.geometrie,
        b.art_txt,
        CASE WHEN dp.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_denk_poly,
        CASE WHEN dk.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_denk_punkt,
        CASE WHEN i.src_t_id  IS NOT NULL THEN TRUE ELSE FALSE END AS hit_isos_a,
        CASE WHEN k.src_t_id  IS NOT NULL THEN TRUE ELSE FALSE END AS hit_kgs,
        CASE WHEN nbaub.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_baubewilligung,
        CASE WHEN nkomm.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_kommunal,
        CASE WHEN nort.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_ortsbild,
        CASE WHEN n141.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_n141,
        CASE WHEN n821.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_821
    FROM gebaeude_src b
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_denk_poly)     dp
      ON dp.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_denk_punkt)    dk
      ON dk.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_isos)          i
      ON i.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_kgs)           k
      ON k.src_t_id = b.src_t_id
    LEFT JOIN (
        SELECT DISTINCT src_t_id
        FROM hit_nutz_grundnutzung
        WHERE verfahrensklasse = 'Baubewilligungsverfahren'
    ) nbaub
      ON nbaub.src_t_id = b.src_t_id
    LEFT JOIN (
        SELECT DISTINCT src_t_id
        FROM hit_nutz_grundnutzung
        WHERE verfahrensklasse = 'Bewilligungsverfahren_auf_kommunaler_Ebene_zu_klaeren'
    ) nkomm
      ON nkomm.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_nutz_ortsbild) nort
      ON nort.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_nutz_n141)     n141
      ON n141.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_nutz_821)      n821
      ON n821.src_t_id = b.src_t_id
),

klassifikation AS (
    SELECT
        f.*,
        CASE
            -- Prioritaet 1: Schutzobjekte und Schutzgebiete, die direkt
            -- ein Baubewilligungsverfahren ausloesen.
            WHEN (
                f.hit_denk_poly
                OR f.hit_denk_punkt
                OR f.hit_isos_a
                OR f.hit_kgs
                OR f.hit_nutz_ortsbild
                OR f.hit_nutz_baubewilligung
            )
                THEN 'Baubewilligungsverfahren'

            -- Prioritaet 2: uebrige Kernzonen (N140).
            WHEN f.hit_nutz_kommunal
                THEN 'Bewilligungsverfahren_auf_kommunaler_Ebene_zu_klaeren'

            -- Prioritaet 3: kommunal geschuetztes Kulturobjekt. Eine
            -- Zentrumszone (N141) unterdrueckt dieses Mischverfahren.
            WHEN (
                f.hit_nutz_821
                AND NOT f.hit_nutz_n141
            )
                THEN 'Baubewilligungspflicht_fuer_Indachanlagen__Meldepflicht_fuer_Aufdachanlagen'

            ELSE 'Meldeverfahren'
        END AS bewilligungsverfahren
    FROM flags f
),

objektinfo AS (

    -- Denkmalschutz Polygon
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'Denkmalschutz',
            'Quelle',       'denkmal_polygon',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   h.objektname,
            'Schutzstatus', h.schutzstufe_text,
            'Objektblatt',  h.objektblatt,
            'Nummer',       NULL,
            'Kategorie',    NULL,
            'Typ',          NULL,
            'Bezeichnung',  NULL,
            'Dokumente',
            CASE
                WHEN h.rechtsvorschriften IS NOT NULL
                 AND json_array_length(h.rechtsvorschriften) > 0
                THEN (
                    SELECT json_group_array(
                        json_object(
                            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Dokument',
                            'Titel',        de.Titel,
                            'Abkuerzung',   NULL,
                            'Nummer',       de.Nummer,
                            'Datum',        de.Datum,
                            'Rechtsstatus', NULL,
                            'Link',         de.Link
                        )
                    )
                    FROM (
                        SELECT unnest(
                            from_json(
                                h.rechtsvorschriften,
                                '[{"Titel":"VARCHAR","Nummer":"VARCHAR","Datum":"VARCHAR","Link":"VARCHAR"}]'
                            )
                        ) AS de
                    ) x
                )
                ELSE CAST(NULL AS JSON)
            END
        ) AS obj
    FROM hit_denk_poly h

    UNION ALL

    -- Denkmalschutz Punkt
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'Denkmalschutz',
            'Quelle',       'denkmal_punkt',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   h.objektname,
            'Schutzstatus', h.schutzstufe_text,
            'Objektblatt',  h.objektblatt,
            'Nummer',       NULL,
            'Kategorie',    NULL,
            'Typ',          NULL,
            'Bezeichnung',  NULL,
            'Dokumente',
            CASE
                WHEN h.rechtsvorschriften IS NOT NULL
                 AND json_array_length(h.rechtsvorschriften) > 0
                THEN (
                    SELECT json_group_array(
                        json_object(
                            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Dokument',
                            'Titel',        de.Titel,
                            'Abkuerzung',   NULL,
                            'Nummer',       de.Nummer,
                            'Datum',        de.Datum,
                            'Rechtsstatus', NULL,
                            'Link',         de.Link
                        )
                    )
                    FROM (
                        SELECT unnest(
                            from_json(
                                h.rechtsvorschriften,
                                '[{"Titel":"VARCHAR","Nummer":"VARCHAR","Datum":"VARCHAR","Link":"VARCHAR"}]'
                            )
                        ) AS de
                    ) x
                )
                ELSE CAST(NULL AS JSON)
            END
        ) AS obj
    FROM hit_denk_punkt h

    UNION ALL

    -- ISOS
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'ISOS-A',
            'Quelle',       'isos_inventar',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   h.objektname,
            'Schutzstatus', NULL,
            'Objektblatt',  h.link_objektblatt,
            'Nummer',       h.nummer,
            'Kategorie',    NULL,
            'Typ',          NULL,
            'Bezeichnung',  NULL,
            'Dokumente',    CAST(NULL AS JSON)
        ) AS obj
    FROM hit_isos h

    UNION ALL

    -- KGS
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'KGS-Objekt',
            'Quelle',       'kgs_objekt',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   NULL,
            'Schutzstatus', NULL,
            'Objektblatt',  NULL,
            'Nummer',       NULL,
            'Kategorie',    h.kategorie_txt,
            'Typ',          NULL,
            'Bezeichnung',  h.bezeichnung,
            'Dokumente',    CAST(NULL AS JSON)
        ) AS obj
    FROM hit_kgs h

    UNION ALL

    -- Nutzungsplanung Grundnutzung (N140 / N142 / Spezialgebiete)
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'Nutzungsplanung',
            'Quelle',       'nutzungsplanung_grundnutzung',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   NULL,
            'Schutzstatus', NULL,
            'Objektblatt',  NULL,
            'Nummer',       NULL,
            'Kategorie',    NULL,
            'Typ',          h.typ_kt,
            'Bezeichnung',  h.typ_bezeichnung,
            'Dokumente',
            CASE
                WHEN h.dokumente IS NOT NULL
                 AND json_array_length(h.dokumente) > 0
                THEN (
                    SELECT json_group_array(
                        json_object(
                            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Dokument',
                            'Titel',        de.OffiziellerTitel,
                            'Abkuerzung',   de.Abkuerzung,
                            'Nummer',       de.OffizielleNr,
                            'Datum',        de.publiziertAb,
                            'Rechtsstatus', de.Rechtsstatus,
                            'Link',         de.TextimWeb
                        )
                    )
                    FROM (
                        SELECT unnest(
                            from_json(
                                h.dokumente,
                                '[{"OffiziellerTitel":"VARCHAR","Abkuerzung":"VARCHAR","OffizielleNr":"VARCHAR","publiziertAb":"VARCHAR","TextimWeb":"VARCHAR","Rechtsstatus":"VARCHAR"}]'
                            )
                        ) AS de
                    ) x
                )
                ELSE CAST(NULL AS JSON)
            END
        ) AS obj
    FROM hit_nutz_grundnutzung h

    UNION ALL

    -- Nutzungsplanung Ortsbildschutz (N510)
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'Nutzungsplanung',
            'Quelle',       'nutzungsplanung_ueberlagernd_flaeche',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   NULL,
            'Schutzstatus', NULL,
            'Objektblatt',  NULL,
            'Nummer',       NULL,
            'Kategorie',    NULL,
            'Typ',          h.typ_kt,
            'Bezeichnung',  h.typ_bezeichnung,
            'Dokumente',
            CASE
                WHEN h.dokumente IS NOT NULL
                 AND json_array_length(h.dokumente) > 0
                THEN (
                    SELECT json_group_array(
                        json_object(
                            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Dokument',
                            'Titel',        de.OffiziellerTitel,
                            'Abkuerzung',   de.Abkuerzung,
                            'Nummer',       de.OffizielleNr,
                            'Datum',        de.publiziertAb,
                            'Rechtsstatus', de.Rechtsstatus,
                            'Link',         de.TextimWeb
                        )
                    )
                    FROM (
                        SELECT unnest(
                            from_json(
                                h.dokumente,
                                '[{"OffiziellerTitel":"VARCHAR","Abkuerzung":"VARCHAR","OffizielleNr":"VARCHAR","publiziertAb":"VARCHAR","TextimWeb":"VARCHAR","Rechtsstatus":"VARCHAR"}]'
                            )
                        ) AS de
                    ) x
                )
                ELSE CAST(NULL AS JSON)
            END
        ) AS obj
    FROM hit_nutz_ortsbild h

    UNION ALL

    -- Nutzungsplanung Zentrumszone (N141)
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'Nutzungsplanung',
            'Quelle',       'nutzungsplanung_grundnutzung',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   NULL,
            'Schutzstatus', NULL,
            'Objektblatt',  NULL,
            'Nummer',       NULL,
            'Kategorie',    NULL,
            'Typ',          h.typ_kt,
            'Bezeichnung',  h.typ_bezeichnung,
            'Dokumente',
            CASE
                WHEN h.dokumente IS NOT NULL
                 AND json_array_length(h.dokumente) > 0
                THEN (
                    SELECT json_group_array(
                        json_object(
                            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Dokument',
                            'Titel',        de.OffiziellerTitel,
                            'Abkuerzung',   de.Abkuerzung,
                            'Nummer',       de.OffizielleNr,
                            'Datum',        de.publiziertAb,
                            'Rechtsstatus', de.Rechtsstatus,
                            'Link',         de.TextimWeb
                        )
                    )
                    FROM (
                        SELECT unnest(
                            from_json(
                                h.dokumente,
                                '[{"OffiziellerTitel":"VARCHAR","Abkuerzung":"VARCHAR","OffizielleNr":"VARCHAR","publiziertAb":"VARCHAR","TextimWeb":"VARCHAR","Rechtsstatus":"VARCHAR"}]'
                            )
                        ) AS de
                    ) x
                )
                ELSE CAST(NULL AS JSON)
            END
        ) AS obj
    FROM hit_nutz_n141 h

    UNION ALL

    -- Nutzungsplanung Spezialfall N821
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'Nutzungsplanung',
            'Quelle',       'nutzungsplanung_ueberlagernd_flaeche',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   NULL,
            'Schutzstatus', NULL,
            'Objektblatt',  NULL,
            'Nummer',       NULL,
            'Kategorie',    NULL,
            'Typ',          h.typ_kt,
            'Bezeichnung',  h.typ_bezeichnung,
            'Dokumente',
            CASE
                WHEN h.dokumente IS NOT NULL
                 AND json_array_length(h.dokumente) > 0
                THEN (
                    SELECT json_group_array(
                        json_object(
                            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Dokument',
                            'Titel',        de.OffiziellerTitel,
                            'Abkuerzung',   de.Abkuerzung,
                            'Nummer',       de.OffizielleNr,
                            'Datum',        de.publiziertAb,
                            'Rechtsstatus', de.Rechtsstatus,
                            'Link',         de.TextimWeb
                        )
                    )
                    FROM (
                        SELECT unnest(
                            from_json(
                                h.dokumente,
                                '[{"OffiziellerTitel":"VARCHAR","Abkuerzung":"VARCHAR","OffizielleNr":"VARCHAR","publiziertAb":"VARCHAR","TextimWeb":"VARCHAR","Rechtsstatus":"VARCHAR"}]'
                            )
                        ) AS de
                    ) x
                )
                ELSE CAST(NULL AS JSON)
            END
        ) AS obj
    FROM hit_nutz_821 h
),

objektinfo_agg AS (
    SELECT
        src_t_id,
        json_group_array(obj) AS objektinformation
    FROM objektinfo
    GROUP BY src_t_id
)

INSERT INTO pubdb.arp_solaranlagen_bewilligungsverfahren_pub_v1.bauten_baute
    (
        bfsnr,
        art,
        art_txt,
        geometrie,
        bewilligungsverfahren,
        bewilligungsverfahren_txt,
        objektinformation
    )
SELECT
    ${bfsnr},
    k.art_txt AS art,
    CASE
        WHEN k.art_txt = 'Unterstand' THEN 'Unterstand'
        ELSE 'Gebäude'
    END AS art_txt,
    'SRID=2056;' || ST_AsText(k.geometrie) AS geometrie,

    k.bewilligungsverfahren,

    CASE k.bewilligungsverfahren
        WHEN 'Baubewilligungsverfahren'
            THEN 'Baubewilligungsverfahren'
        WHEN 'Bewilligungsverfahren_auf_kommunaler_Ebene_zu_klaeren'
            THEN 'Bewilligungsverfahren auf kommunaler Ebene zu klären'
        WHEN 'Baubewilligungspflicht_fuer_Indachanlagen__Meldepflicht_fuer_Aufdachanlagen'
            THEN 'Baubewilligungspflicht für Indachanlagen, Meldepflicht für Aufdachanlagen'
        WHEN 'Meldeverfahren'
            THEN 'Meldeverfahren'
    END AS bewilligungsverfahren_txt,

    CASE
        WHEN o.objektinformation IS NULL THEN CAST(NULL AS JSON)
        WHEN json_array_length(o.objektinformation) = 0 THEN CAST(NULL AS JSON)
        ELSE o.objektinformation
    END AS objektinformation

FROM klassifikation k
LEFT JOIN objektinfo_agg o
  ON o.src_t_id = k.src_t_id
;

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
      ON ST_Intersects(b.geometrie, ST_GeomFromWKB(o.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(o.geometrie))
),

hit_bln AS (
    SELECT
        b.src_t_id,
        CAST(bln.nummer AS VARCHAR) AS ref_objekt_id,
        bln.Nummer,
        bln.Objektname,
        bln.Objektblatt,
        bln.geom
    FROM gebaeude_src b
    JOIN bln_swisstopo AS bln
      ON ST_Intersects(b.geometrie, bln.geom)
     AND NOT ST_Touches(b.geometrie, bln.geom)
),

hit_nutz_kommunal AS (
    SELECT
        b.src_t_id,
        CAST(n.t_id AS VARCHAR) AS ref_objekt_id,
        n.typ_kt,
        n.typ_bezeichnung,
        n.dokumente
    FROM gebaeude_src b
    JOIN pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung n
      ON n.typ_kt IN ('N140_Kernzone', 'N142_Erhaltungszone')
     AND ST_Intersects(b.geometrie, ST_GeomFromWKB(n.geometrie))
     AND NOT ST_Touches(b.geometrie, ST_GeomFromWKB(n.geometrie))
   WHERE n.bfs_nr = ${bfsnr}
),

hit_nutz_7 AS (
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

hit_nutz_melde AS (
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
        CASE WHEN bn.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_bln,
        CASE WHEN nkomm.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_kommunal,
        CASE WHEN n7.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_7,
        CASE WHEN nm.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_melde,
        CASE WHEN n821.src_t_id IS NOT NULL THEN TRUE ELSE FALSE END AS hit_nutz_821
    FROM gebaeude_src b
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_denk_poly)     dp    ON dp.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_denk_punkt)    dk    ON dk.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_isos)          i     ON i.src_t_id  = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_kgs)           k     ON k.src_t_id  = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_bln)           bn    ON bn.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_nutz_kommunal) nkomm ON nkomm.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_nutz_7)        n7    ON n7.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_nutz_melde)    nm    ON nm.src_t_id = b.src_t_id
    LEFT JOIN (SELECT DISTINCT src_t_id FROM hit_nutz_821)      n821  ON n821.src_t_id = b.src_t_id
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

    -- BLN
    SELECT
        h.src_t_id,
        json_object(
            '@type',        'SO_ARP_Solaranlagen_Bewilligungsverfahren_20260313.Objektinformation',
            'Thema',        'BLN',
            'Quelle',       'bln',
            'ObjektId',     h.ref_objekt_id,
            'Objektname',   h.objektname,
            'Schutzstatus', NULL,
            'Objektblatt',  h.objektblatt,
            'Nummer',       h.nummer,
            'Kategorie',    NULL,
            'Typ',          NULL,
            'Bezeichnung',  NULL,
            'Dokumente',    CAST(NULL AS JSON)
        ) AS obj
    FROM hit_bln h

    UNION ALL

    -- Nutzungsplanung kommunal zu klären (N140 / N142)
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
    FROM hit_nutz_kommunal h

    UNION ALL

    -- Nutzungsplanung 7
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
    FROM hit_nutz_7 h

    UNION ALL

    -- Nutzungsplanung Meldeverfahren (N141)
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
    FROM hit_nutz_melde h

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
    (bfsnr, art, art_txt, geometrie, bewilligungsverfahren, bewilligungsverfahren_txt, objektinformation)
SELECT
    ${bfsnr},
    f.art_txt AS art,
    CASE
        WHEN f.art_txt = 'Unterstand' THEN 'Unterstand'
        ELSE 'Gebäude'
    END AS art_txt,
    'SRID=2056;' || ST_AsText(f.geometrie) AS geometrie,
    CASE
        WHEN (
            f.hit_denk_poly
            OR f.hit_denk_punkt
            OR f.hit_isos_a
            OR f.hit_kgs
            OR f.hit_bln
            OR f.hit_nutz_7
        )
            THEN 'Baubewilligungsverfahren'
        WHEN (
            f.hit_nutz_kommunal
            AND NOT (
                f.hit_denk_poly
                OR f.hit_denk_punkt
                OR f.hit_isos_a
                OR f.hit_kgs
                OR f.hit_bln
                OR f.hit_nutz_7
            )
        )
            THEN 'Bewilligungsverfahren_auf_kommunaler_Ebene_zu_klaeren'
        WHEN (
            f.hit_nutz_821
            AND NOT (
                f.hit_denk_poly
                OR f.hit_denk_punkt
                OR f.hit_isos_a
                OR f.hit_kgs
                OR f.hit_bln
                OR f.hit_nutz_7
                OR f.hit_nutz_kommunal
                OR f.hit_nutz_melde
            )
        )
            THEN 'Baubewilligungspflicht_fuer_Indachanlagen__Meldepflicht_fuer_Aufdachanlagen'
        ELSE 'Meldeverfahren'
    END AS bewilligungsverfahren,
    CASE
        WHEN (
            f.hit_denk_poly
            OR f.hit_denk_punkt
            OR f.hit_isos_a
            OR f.hit_kgs
            OR f.hit_bln
            OR f.hit_nutz_7
        )
            THEN 'Baubewilligungsverfahren'
        WHEN (
            f.hit_nutz_kommunal
            AND NOT (
                f.hit_denk_poly
                OR f.hit_denk_punkt
                OR f.hit_isos_a
                OR f.hit_kgs
                OR f.hit_bln
                OR f.hit_nutz_7
            )
        )
            THEN 'Bewilligungsverfahren auf kommunaler Ebene zu klären'
        WHEN (
            f.hit_nutz_821
            AND NOT (
                f.hit_denk_poly
                OR f.hit_denk_punkt
                OR f.hit_isos_a
                OR f.hit_kgs
                OR f.hit_bln
                OR f.hit_nutz_7
                OR f.hit_nutz_kommunal
                OR f.hit_nutz_melde
            )
        )
            THEN 'Baubewilligungspflicht für Indachanlagen, Meldepflicht für Aufdachanlagen'
        ELSE 'Meldeverfahren'
    END AS bewilligungsverfahren_txt,
    CASE
        WHEN o.objektinformation IS NULL THEN CAST(NULL AS JSON)
        WHEN json_array_length(o.objektinformation) = 0 THEN CAST(NULL AS JSON)
        ELSE o.objektinformation
    END AS objektinformation
FROM flags f
LEFT JOIN objektinfo_agg o
  ON o.src_t_id = f.src_t_id
;
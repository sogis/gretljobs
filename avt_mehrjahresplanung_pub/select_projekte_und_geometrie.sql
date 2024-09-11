-- Erstelle zuerst eine Zwischentabelle wo gewisse Felder aufgetrennt worden
-- sind
WITH tabelle_projekte AS (
    SELECT
        t_id,
        abteilung,
        kreis,
        projektleiter,
        gemeinde,
        strasse,
        projekt,
        projektnr,
        kreditjahr_p,
        kreditjahr_a,
        astart,
        ende,
        klasse,
        aphase,
        achsnr,
        bpanfang,
        split_part(bpanfang, '+', 1) AS bpanfang_bezeichnung,
        CASE WHEN split_part(bpanfang, '+', 2) ILIKE '' THEN NULL
        ELSE split_part(bpanfang, '+', 2)
        END AS bpanfang_km,
        bpende,
        split_part(bpende, '+', 1) AS bpende_bezeichnung,
        CASE WHEN split_part(bpende, '+', 2) ILIKE '' THEN NULL
        ELSE split_part(bpende, '+', 2)
        END AS bpende_km,
        bemerkungen,
        projektsuffix,
        CASE
            WHEN projektsuffix IS NULL THEN projektnr
            ELSE projektnr || '.' || projektsuffix
        END AS projektidentifikation,
        ranfangsbezugspunkt,
        rendbezugspunkt
    FROM
        avt_mehrjahresplanung_v1.projekte_projekt
),


-- Wähle in höchster Priorität Projekte mit manueller erfasster Geometrie
projekte_mit_manuell_erfasster_geometrie AS (
    SELECT 
        pp.t_id,
        pp.abteilung,
        pp.kreis,
        pp.projektleiter,
        pp.gemeinde,
        pp.strasse,
        pp.projekt,
        pp.projektnr,
        pp.kreditjahr_p,
        pp.kreditjahr_a,
        pp.astart,
        pp.ende,
        pp.klasse,
        pp.aphase,
        pp.achsnr,
        pp.bpanfang,
        pp.bpende,
        pp.bemerkungen,
        pp.projektsuffix,
        pp.projektidentifikation,
        pp.ranfangsbezugspunkt,
        pp.rendbezugspunkt,
        pp2.geometrie,
        'manuell_erfasst' AS fall
    FROM
        tabelle_projekte pp 
    JOIN
        avt_mehrjahresplanung_v1.projekte_projektgeometrie pp2 
    ON
        pp.projektidentifikation = pp2.projektidentifikation
),



-- Wähle in zweiter Priorität Projekte welche an einer Achse (=Linestring) liegen
bppunkte_achsen AS (
    SELECT
        kb.t_id,
        kb.bezeichnung,
        kb.achsenummer,
        kb.geometrie,
        ka.geometrie AS linegeometrie,
        ka.t_id AS achsen_tid
    FROM
      avt_mehrjahresplanung_v1.kantonsstrassen_bezugspunkt kb 
    LEFT JOIN
       avt_mehrjahresplanung_v1.kantonsstrassen_achse ka 
    ON
        st_intersects(st_buffer(kb.geometrie,0.1), ka.geometrie) and kb.achsenummer like ka.achsenummer 
),
projekte_mit_achsen AS (
    select
        pp.t_id,
        pp.abteilung,
        pp.kreis,
        pp.projektleiter,
        pp.gemeinde,
        pp.strasse,
        pp.projekt,
        pp.projektnr,
        pp.kreditjahr_p,
        pp.kreditjahr_a,
        pp.astart,
        pp.ende,
        pp.klasse,
        pp.aphase,
        pp.achsnr,
        pp.bpanfang,
        pp.bpanfang_bezeichnung,
        pp.bpanfang_km,
        bpende,
        pp.bpende_bezeichnung,
        pp.bpende_km,
        pp.bemerkungen,
        pp.projektsuffix,
        pp.projektidentifikation,
        pp.ranfangsbezugspunkt,
        pp.rendbezugspunkt,
        bpa.geometrie AS bpanfang_geometrie,
        bpe.geometrie AS bpende_geometrie,
        bpa.linegeometrie AS achsengeometrie
    from 
        tabelle_projekte pp
    join
        bppunkte_achsen bpa
    on
        pp.ranfangsbezugspunkt = bpa.t_id
    join
        bppunkte_achsen bpe
    on
        pp.rendbezugspunkt = bpe.t_id
    where
        bpa.achsen_tid = bpe.achsen_tid
),
projekte_an_einer_achse AS (
    SELECT
        pma.t_id,
        pma.abteilung,
        pma.kreis,
        pma.projektleiter,
        pma.gemeinde,
        pma.strasse,
        pma.projekt,
        pma.projektnr,
        pma.kreditjahr_p,
        pma.kreditjahr_a,
        pma.astart,
        pma.ende,
        pma.klasse,
        pma.aphase,
        pma.achsnr,
        pma.bpanfang,
        pma.bpende,
        pma.bemerkungen,
        pma.projektsuffix,
        pma.projektidentifikation,
        pma.ranfangsbezugspunkt,
        pma.rendbezugspunkt,
        ST_Multi(ST_LineSubstring(
            pma.achsengeometrie,
            CASE WHEN pma.bpanfang_km IS NOT NULL THEN
                (ST_LineLocatePoint(pma.achsengeometrie, bpanfang_geometrie) + (pma.bpanfang_km::INTEGER / ST_Length(pma.achsengeometrie)))
            ELSE
                ST_LineLocatePoint(pma.achsengeometrie, bpanfang_geometrie)
            END,
            CASE WHEN pma.bpende_km IS NOT NULL THEN
                (ST_LineLocatePoint(pma.achsengeometrie, bpende_geometrie) + (pma.bpende_km::INTEGER / ST_Length(pma.achsengeometrie)))
            ELSE
                ST_LineLocatePoint(pma.achsengeometrie, bpende_geometrie)
            END
        )) AS geometrie,
        'an_einer_achse' AS fall
    FROM 
        projekte_mit_achsen pma
    WHERE
        pma.t_id NOT IN (SELECT t_id FROM projekte_mit_manuell_erfasster_geometrie)
),



-- Wähle in dritter Priorität Projekte welcher an mehreren Achsen liegen, welche
-- aber gemergt werden können
merged_ktstrassen AS (
    SELECT
        achsenummer,
        geometrie
    FROM (
        SELECT
            achsenummer::INTEGER,
            ST_LineMerge(ST_Union(geometrie)) AS geometrie
        FROM
            avt_mehrjahresplanung_v1.kantonsstrASsen_achse ka 
        GROUP BY
            achsenummer
    ) AS t
    WHERE GeometryType(t.geometrie) like 'LINESTRING'
),
projekte_an_mehreren_achsen AS (
    SELECT 
        pp.t_id,
        pp.abteilung,
        pp.kreis,
        pp.projektleiter,
        pp.gemeinde,
        pp.strasse,
        pp.projekt,
        pp.projektnr,
        pp.kreditjahr_p,
        pp.kreditjahr_a,
        pp.astart,
        pp.ende,
        pp.klasse,
        pp.aphase,
        pp.achsnr,
        pp.bpanfang,
        pp.bpende,
        pp.bemerkungen,
        pp.projektsuffix,
        pp.projektidentifikation,
        pp.ranfangsbezugspunkt,
        pp.rendbezugspunkt,
        ST_Multi(ST_LineSubstring(
            ka.geometrie,
            CASE WHEN pp.bpanfang_km IS NOT NULL THEN
                (ST_LineLocatePoint(ka.geometrie, kb.geometrie) + (pp.bpanfang_km::INTEGER / ST_Length(ka.geometrie)))
            ELSE
                ST_LineLocatePoint(ka.geometrie, kb.geometrie)
            END,
            CASE WHEN pp.bpende_km IS NOT NULL THEN
                (ST_LineLocatePoint(ka.geometrie, kc.geometrie) + (pp.bpende_km::INTEGER / ST_Length(ka.geometrie)))
            ELSE
                ST_LineLocatePoint(ka.geometrie, kc.geometrie)
            END
        )) AS geometrie,
        'an_mehreren_achsen' AS fall
    FROM
        tabelle_projekte pp 
    JOIN
        merged_ktstrassen ka
    ON
        pp.achsnr = ka.achsenummer
    JOIN 
        avt_mehrjahresplanung_v1.kantonsstrassen_bezugspunkt kb 
    ON
        pp.ranfangsbezugspunkt = kb.t_id
    JOIN 
        avt_mehrjahresplanung_v1.kantonsstrassen_bezugspunkt kc 
    ON
        pp.rendbezugspunkt = kc.t_id
    WHERE
        pp.t_id NOT IN (SELECT t_id FROM projekte_mit_manuell_erfasster_geometrie)
    AND
        pp.t_id NOT IN (SELECT t_id FROM projekte_an_einer_achse)
),


-- Für die restlichen Projekte zeichne eine gerade Linie vom Anfangsbezugpunkt
-- zum Endbezugspunkt
projekte_mit_direkter_linie AS (
    SELECT 
        pp.t_id,
        pp.abteilung,
        pp.kreis,
        pp.projektleiter,
        pp.gemeinde,
        pp.strasse,
        pp.projekt,
        pp.projektnr,
        pp.kreditjahr_p,
        pp.kreditjahr_a,
        pp.astart,
        pp.ende,
        pp.klasse,
        pp.aphase,
        pp.achsnr,
        pp.bpanfang,
        pp.bpende,
        pp.bemerkungen,
        pp.projektsuffix,
        pp.projektidentifikation,
        pp.ranfangsbezugspunkt,
        pp.rendbezugspunkt,
        ST_Multi(ST_MakeLine(kb.geometrie, kb2.geometrie)) as geometrie,
        'direkte_linie' AS fall
    FROM 
        tabelle_projekte pp 
    JOIN
        avt_mehrjahresplanung_v1.kantonsstrassen_bezugspunkt kb 
    ON
        pp.ranfangsbezugspunkt = kb.t_id
    JOIN
        avt_mehrjahresplanung_v1.kantonsstrassen_bezugspunkt kb2 
    ON
        pp.rendbezugspunkt = kb2.t_id
    WHERE
        pp.t_id NOT IN (SELECT t_id FROM projekte_mit_manuell_erfasster_geometrie)
    AND
        pp.t_id NOT IN (SELECT t_id FROM projekte_an_einer_achse)
    AND
        pp.t_id NOT IN (SELECT t_id FROM projekte_an_mehreren_achsen)
)

SELECT
    t_id,
    abteilung,
    kreis,
    projektleiter,
    gemeinde,
    strasse,
    projekt,
    projektnr,
    kreditjahr_p,
    kreditjahr_a,
    astart,
    ende,
    klasse,
    aphase,
    achsnr,
    bpanfang,
    bpende,
    bemerkungen,
    projektsuffix,
    geometrie
FROM
    projekte_mit_manuell_erfasster_geometrie
UNION
SELECT
    t_id,
    abteilung,
    kreis,
    projektleiter,
    gemeinde,
    strasse,
    projekt,
    projektnr,
    kreditjahr_p,
    kreditjahr_a,
    astart,
    ende,
    klasse,
    aphase,
    achsnr,
    bpanfang,
    bpende,
    bemerkungen,
    projektsuffix,
    geometrie
FROM
    projekte_an_einer_achse
UNION
SELECT
    t_id,
    abteilung,
    kreis,
    projektleiter,
    gemeinde,
    strasse,
    projekt,
    projektnr,
    kreditjahr_p,
    kreditjahr_a,
    astart,
    ende,
    klasse,
    aphase,
    achsnr,
    bpanfang,
    bpende,
    bemerkungen,
    projektsuffix,
    geometrie
FROM
    projekte_an_mehreren_achsen
UNION
SELECT
    t_id,
    abteilung,
    kreis,
    projektleiter,
    gemeinde,
    strasse,
    projekt,
    projektnr,
    kreditjahr_p,
    kreditjahr_a,
    astart,
    ende,
    klasse,
    aphase,
    achsnr,
    bpanfang,
    bpende,
    bemerkungen,
    projektsuffix,
    geometrie
FROM
    projekte_mit_direkter_linie
;
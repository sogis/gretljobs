DELETE FROM awjf_waldplan_pub_v2.waldplan_waldnutzung;

WITH

-- =========================================================
-- 1) Waldnutzung: Input bereinigen (einmal ReducePrecision)
-- =========================================================
waldnutzung_edit_clean AS (
    SELECT
        basket.t_id AS t_basket,
        wnz.t_datasetname,
        wnz.nutzungskategorie,
        wnk.dispname AS nutzungskategorie_txt,
        ST_ReducePrecision(ST_MakeValid(wnz.geometrie), 0.001) AS geometrie,
        wnz.bemerkung
    FROM awjf_waldplan_v2.waldplan_waldnutzung AS wnz
    LEFT JOIN awjf_waldplan_v2.waldnutzungskategorie AS wnk
        ON wnz.nutzungskategorie = wnk.ilicode
    LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
        ON wnz.t_datasetname = dataset.datasetname
    LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
        ON dataset.t_id = basket.dataset
    WHERE
        wnz.t_datasetname::int4 = ${bfsnr_param}
        AND ST_IsValid(wnz.geometrie)
        AND ST_Area(wnz.geometrie) > 1.0
),

-- =========================================================
-- 2) Wald_bestockt roh = Waldfunktion minus Waldnutzung
-- =========================================================
wald_bestockt_roh AS (
    SELECT
        ST_Difference(
            (SELECT ST_Union(geometrie)
             FROM awjf_waldplan_v2.waldplan_waldfunktion
             WHERE t_datasetname::int4 = ${bfsnr_param}),
            (SELECT ST_Union(geometrie)
             FROM waldnutzung_edit_clean)
        ) AS geometrie
),

wald_bestockt_clean AS (
    SELECT
        ST_Difference(
            (SELECT geometrie FROM wald_bestockt_roh),
            (SELECT ST_Union(geometrie)
             FROM waldnutzung_edit_clean)
        ) AS geometrie
),

wald_bestockt_final AS (
    SELECT
        (SELECT t_basket FROM waldnutzung_edit_clean LIMIT 1) AS t_basket,
        (SELECT t_datasetname FROM waldnutzung_edit_clean LIMIT 1) AS t_datasetname,
        'Wald_bestockt' AS nutzungskategorie,
        'Mit Wald bestockt' AS nutzungskategorie_txt,
        (ST_Dump(wbc.geometrie)).geom AS geometrie,
        NULL AS bemerkung
    FROM wald_bestockt_clean AS wbc
    WHERE
        ST_IsValid(wbc.geometrie)
        AND ST_Area(wbc.geometrie) > 1.0
),

-- =========================================================
-- 3) Zusammenführen aller Flächen (wie bei dir)
-- =========================================================
waldnutzung_pub AS (
    SELECT
        t_basket,
        t_datasetname,
        nutzungskategorie,
        nutzungskategorie_txt,
        geometrie,
        bemerkung
    FROM waldnutzung_edit_clean

    UNION ALL

    SELECT
        t_basket,
        t_datasetname,
        nutzungskategorie,
        nutzungskategorie_txt,
        geometrie,
        bemerkung
    FROM wald_bestockt_final
),

-- =========================================================
-- 4) NEU: ALLE FLÄCHEN → LINIEN (Exterior Rings)
-- =========================================================
waldnutzung_lines AS (
    SELECT
        t_basket,
        t_datasetname,
        nutzungskategorie,
        nutzungskategorie_txt,
        ST_ExteriorRing((ST_DumpRings(geometrie)).geom) AS geom,
        bemerkung
    FROM waldnutzung_pub
),

-- =========================================================
-- 5) EIN EINZIGES SAUBERES GRENZNETZ BAUEN
-- =========================================================
waldnutzung_union AS (
    SELECT
        ST_Union(geom, 0.002) AS geom   -- 2mm Toleranz
    FROM waldnutzung_lines
),

-- =========================================================
-- 6) POLYGONE NEU ERZEUGEN (TOPOLOGISCH SAUBER)
-- =========================================================
waldnutzung_polygonized AS (
    SELECT
        (ST_Dump(ST_Polygonize(geom))).geom AS geometrie
    FROM waldnutzung_union
),

-- =========================================================
-- 7) JEDEM NEUEN POLYGON EINEN PUNKT GEBEN
-- =========================================================
waldnutzung_polys_point AS (
    SELECT
        geometrie,
        ST_PointOnSurface(geometrie) AS point
    FROM waldnutzung_polygonized
),

-- =========================================================
-- 8) ATTRIBUTE ZURÜCKSPIELEN (per räumlicher Zuordnung)
-- =========================================================
waldnutzung_polys_attr AS (
    SELECT DISTINCT ON (p.point)
        w.t_basket,
        w.t_datasetname,
        w.nutzungskategorie,
        w.nutzungskategorie_txt,
        p.geometrie,
        w.bemerkung
    FROM waldnutzung_pub AS w
    JOIN waldnutzung_polys_point AS p
      ON ST_Intersects(p.point, w.geometrie)
),

-- =========================================================
-- 9) FINALE SAUBERE PUBLIKATIONSFLÄCHE
-- =========================================================
waldnutzung_pub_clean AS (
    SELECT
        t_basket,
        t_datasetname,
        nutzungskategorie,
        nutzungskategorie_txt,
        ST_RemoveRepeatedPoints(geometrie, 0.001) AS geometrie,
        bemerkung
    FROM waldnutzung_polys_attr
    WHERE
        ST_IsValid(geometrie)
        AND ST_Area(geometrie) > 1.0
)

-- =========================================================
-- 10) Insert in Publikationstabelle
-- =========================================================
INSERT INTO awjf_waldplan_pub_v2.waldplan_waldnutzung(
	t_basket,
	t_datasetname,
	nutzungskategorie,
	nutzungskategorie_txt,
	geometrie,
	bemerkung
)
SELECT
	t_basket,
	t_datasetname,
	nutzungskategorie,
	nutzungskategorie_txt,
	geometrie,
	bemerkung
FROM
	waldnutzung_pub_clean;

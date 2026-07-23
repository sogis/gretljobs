WITH grundstuecke AS (
    SELECT
        egrid,
        bfs_nr,
        gemeinde,
        grundbuch,
        nummer,
        nbident,
        flaechenmass,
        art_txt,
        geometrie
    FROM agi_mopublic_pub.mopublic_grundstueck

    UNION ALL

    SELECT
        egrid,
        bfs_nr,
        gemeinde,
        grundbuch,
        nummer,
        nbident,
        flaechenmass,
        art_txt,
        geometrie
    FROM agi_mopublic_pub.mopublic_grundstueck_proj
),

gewaesser AS (
    SELECT
        g.*,
        SUM(
            ST_Area(
                ST_Intersection(g.geometrie, bb.geometrie)
            )
        ) AS gewaesserflaeche
    FROM grundstuecke g
    JOIN agi_mopublic_pub.mopublic_bodenbedeckung bb
        ON g.geometrie && bb.geometrie
            AND ST_Intersects(g.geometrie, bb.geometrie)
    WHERE bb.art_txt = 'fliessendes Gewaesser'
    GROUP BY
        g.egrid,
        g.bfs_nr,
        g.gemeinde,
        g.grundbuch,
        g.nummer,
        g.nbident,
        g.flaechenmass,
        g.art_txt,
        g.geometrie
    HAVING
        SUM(
            ST_Area(
                ST_Intersection(g.geometrie, bb.geometrie)
            )
        ) >= 5
    AND
        SUM(
            ST_Area(
                ST_Intersection(g.geometrie, bb.geometrie)
            )
        ) / ST_Area(g.geometrie) >= 0.12
),

kantonsstrassen AS (
    SELECT DISTINCT
        g.*
    FROM grundstuecke g
    JOIN avt_kantonsstrassen_pub_v1.achse a
        ON g.geometrie && a.geometrie
            AND ST_Intersects(g.geometrie, a.geometrie)
    WHERE ST_Length(
              ST_Intersection(g.geometrie, a.geometrie)
          ) >= 20
)

SELECT DISTINCT
    egrid,
    bfs_nr,
    gemeinde,
    grundbuch,
    nummer,
    nbident,
    flaechenmass,
    art_txt,
    eigentum_kanton,
    anpassung,
    kontrolliert,
    geometrie
FROM (
    SELECT
        egrid,
        bfs_nr,
        gemeinde,
        grundbuch,
        nummer,
        nbident,
        flaechenmass,
        art_txt,
        TRUE  AS eigentum_kanton,
        FALSE AS anpassung,
        FALSE AS kontrolliert,
        geometrie
    FROM gewaesser

    UNION

    SELECT
        egrid,
        bfs_nr,
        gemeinde,
        grundbuch,
        nummer,
        nbident,
        flaechenmass,
        art_txt,
        TRUE  AS eigentum_kanton,
        FALSE AS anpassung,
        FALSE AS kontrolliert,
        geometrie
    FROM kantonsstrassen
) t
ORDER BY
    bfs_nr,
    grundbuch,
    nummer;
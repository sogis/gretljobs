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
    WHERE nummer::integer >= 90000

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
    WHERE nummer::integer >= 90000
),

gewaesser AS (
    SELECT DISTINCT
        g.egrid
    FROM grundstuecke g
    JOIN agi_mopublic_pub.mopublic_bodenbedeckung bb
      ON ST_Intersects(g.geometrie, bb.geometrie)
    WHERE bb.art_txt = 'fliessendes Gewaesser'
      AND ST_Area(ST_Intersection(g.geometrie, bb.geometrie)) >= 5
),

kantonsstrassen AS (
    SELECT DISTINCT
        g.egrid
    FROM grundstuecke g
    JOIN avt_kantonsstrassen_pub_v1.achse a
      ON g.geometrie && a.geometrie
     AND ST_Intersects(g.geometrie, a.geometrie)
    WHERE ST_Length(
              ST_Intersection(g.geometrie, a.geometrie)
          ) >= 15
      AND ST_Length(
              ST_Intersection(g.geometrie, a.geometrie)
          ) / ST_Perimeter(g.geometrie) >= 0.16
)

SELECT
    g.egrid,
    g.bfs_nr,
    g.gemeinde,
    g.grundbuch,
    g.nummer,
    g.nbident,
    g.flaechenmass,
    g.art_txt,

    (
        EXISTS (
            SELECT 1
            FROM gewaesser gw
            WHERE gw.egrid = g.egrid
        )
        OR
        EXISTS (
            SELECT 1
            FROM kantonsstrassen ks
            WHERE ks.egrid = g.egrid
        )
    ) AS eigentum_kanton,

    FALSE AS anpassung,
    FALSE AS kontrolliert,

    g.geometrie

FROM grundstuecke g
ORDER BY
    g.bfs_nr,
    g.grundbuch,
    g.nummer;

WITH grundnutzung_einzelflaechen AS (
    SELECT
        'Ausgangslage' AS abstimmungskategorie,
        'Reservezone' AS grundnutzungsart,
        'rechtsgueltig' AS planungsstand,
        (ST_Dump(wkb_geometry)).geom AS geometrie,
        NULL AS dokumente
    FROM
        digizone.zonenplan
    WHERE
        "archive" = 0
        AND
        zcode = 721
        AND
            gem_bfs NOT IN (2401,2403,2405,2407,2408,2421,2455,2456,2457,2473,2474,2475,2476,2477,2479,2491,2498,2501,2502,2514,2546,2573,2574,2551,2580,2581,2586,2613,2614,2615,2616,2617)
)
SELECT
    abstimmungskategorie,
    grundnutzungsart,
    planungsstand,
    geometrie,
    dokumente
FROM
    grundnutzung_einzelflaechen
WHERE
    geometrie IS NOT NULL
;

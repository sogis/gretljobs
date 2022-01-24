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
            gem_bfs NOT IN (2401,2403,2405,2407,2408,2421,2424,2425,2426,2429,2430,2445,2455,2456,2457,2461,2464,2472,2473,2474,2475,2476,2477,2478,2479,2480,2481,2491,2492,2498,2501,2502,2514,2516,2518,2523,2541,2542,2545,2546,2548,2549,2550,2551,2573,2574,2575,2580,2581,2582,2584,2585,2586,2611,2613,2614,2615,2616,2617,2618,2619,2620,2621,2622)
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

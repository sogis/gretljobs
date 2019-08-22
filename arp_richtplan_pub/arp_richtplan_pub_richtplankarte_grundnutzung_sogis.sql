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
            gem_bfs NOT IN (2405, 2408, 2457, 2473, 2474, 2476, 2498, 2501, 2502, 2580, 2613, 2614, 2615)       
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

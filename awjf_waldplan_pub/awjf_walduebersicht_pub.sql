WITH

union_geometry AS (
    SELECT
        (ST_Dump(
            ST_Union(
                ST_SnapToGrid(
                    ST_RemoveRepeatedPoints(
                        ST_MakeValid(geometrie),
                        0.0005
                    ),
                    0.0005
                )
            )
        )).geom AS geometrie
    FROM
        awjf_waldplan_v2.waldplan_waldfunktion
),

cleaned_geometry AS (
    SELECT
        CASE 
            WHEN ST_GeometryType(geometrie) = 'ST_Polygon' THEN
                ST_MakePolygon(
                    ST_ExteriorRing(geometrie), --äussere Begrenzung des Polygons
                    ARRAY(
                        SELECT ST_ExteriorRing(ring.geom) --Erstelle Array mit inneren Ringen (Löchern)
                        FROM (
                            SELECT (ST_DumpRings(ug.geometrie)).* --Zerlegung in einzelne ringe
                        ) AS ring
                        WHERE ring.path[1] > 0 -- 0 = äusserer Ring, alles grösser als 0 sind innere Ringe, also Löcher
                        AND (4 * 3.14159 * ST_Area(ring.geom)) /  --Polsby-Popper-Test ((4π × Fläche) / (Umfang²)). Je kleiner der Wert, also nahe 0, desto länger ist die Form des Rings, was auf ein Silver-Polygon hindeutet.
                            (ST_Perimeter(ring.geom) ^ 2) > 0.005 -- Werte über 0.0005 sollten "gewollte" Ringe sein, unter 0.0005 Silver-Polygone
                    )
                )
            ELSE geometrie
        END AS geometrie
    FROM
        union_geometry AS ug
)

SELECT
	ST_Collect(geometrie) AS geometrie 
FROM
	cleaned_geometry
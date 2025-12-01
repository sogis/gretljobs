DELETE FROM awjf_waldplan_pub_v2.waldplan_walduebersicht;

DROP TABLE IF EXISTS 
	walduebersicht_union_geometry,
	walduebersicht_cleaned_geometry
CASCADE
;

CREATE TABLE 
	walduebersicht_union_geometry (
		geometrie GEOMETRY
);

CREATE TABLE 
	walduebersicht_cleaned_geometry (
		geometrie GEOMETRY
);

INSERT INTO walduebersicht_union_geometry
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
;

CREATE INDEX
	ON walduebersicht_union_geometry
	USING gist (geometrie)
;

INSERT INTO walduebersicht_cleaned_geometry
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
        walduebersicht_union_geometry AS ug
;

CREATE INDEX
	ON walduebersicht_cleaned_geometry
	USING gist (geometrie)
;

INSERT INTO awjf_waldplan_pub_v2.waldplan_walduebersicht (
	geometrie
)

SELECT
	ST_Collect(geometrie) AS geometrie 
FROM
	walduebersicht_cleaned_geometry
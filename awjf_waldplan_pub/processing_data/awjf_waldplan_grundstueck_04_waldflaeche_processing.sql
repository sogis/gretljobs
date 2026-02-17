DELETE FROM waldflaeche_grundstueck;
INSERT INTO waldflaeche_grundstueck
SELECT
    gs.egrid,
    (ST_Dump(
        ST_Intersection(
            ST_Snap(wf.geometrie, gs.geometrie, 0.01), --snap auf Grundstueck-Geometrie
            gs.geometrie
        )
    )).geom AS geometrie
FROM
	waldfunktion AS wf
JOIN grundstueck AS gs
	ON ST_Intersects(wf.geometrie, gs.geometrie)
    AND wf.t_datasetname = gs.t_datasetname
WHERE
	ST_Area(ST_Intersection(
        ST_Snap(wf.geometrie, gs.geometrie, 0.01),
        gs.geometrie
    )) > 0.5;

;

CREATE INDEX 
	ON waldflaeche_grundstueck
	USING gist (geometrie)
;

-- Bereinigung der Geometrien --
DELETE FROM waldflaeche_grundstueck_bereinigt;
INSERT INTO waldflaeche_grundstueck_bereinigt
SELECT
	egrid,
    (ST_Dump(
        ST_ReducePrecision(
            (ST_Dump(
                ST_CollectionExtract(
                    ST_MakeValid(geometrie),
                    3
                )
            )).geom,
            0.001  -- 1 mm Präzision
        )
    )).geom AS geometrie
FROM
	waldflaeche_grundstueck
WHERE
	ST_Area(geometrie) > 0.5;

CREATE INDEX 
	ON waldflaeche_grundstueck_bereinigt
	USING gist (geometrie)
;

-- Zweite Bereinigung --
DELETE FROM waldflaeche_grundstueck_final;
INSERT INTO waldflaeche_grundstueck_final
SELECT
    egrid,
    ST_Multi(
        ST_Union(geometrie)
    ) AS geometrie
FROM
	waldflaeche_grundstueck_bereinigt
GROUP BY
	egrid;

CREATE INDEX
	ON waldflaeche_grundstueck_final
	USING gist (geometrie)
;
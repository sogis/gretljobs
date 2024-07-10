WITH
multipoly AS (
    SELECT
        ST_Union(poly) AS mpoly,
        gef_max,
        charakterisierung
    FROM 
        splited
    GROUP BY
        gef_max,
        charakterisierung
)

,singlepoly AS (
    SELECT 
        (ST_Dump(mpoly)).geom AS spoly,
        gef_max,
        charakterisierung
    FROM 
        multipoly
)

,ins_merged AS (
    insert into splited(
        id, 
        poly, 
        point, 
        gef_max, 
        charakterisierung
    )
    SELECT 
        -(row_number() over()) AS new_id,
        spoly,
        st_pointonsurface(spoly),
        gef_max,
        charakterisierung
    FROM 
        singlepoly
)

-- delete old polygons
DELETE FROM 
	splited
WHERE 
	id >= 0
;
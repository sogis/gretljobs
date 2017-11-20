SELECT  DISTINCT 
    abbaumenge.abbau_id AS t_id, 
    centro.wkb_geometry AS geometrie, 
    abbaumenge.schnitt
FROM 
    aww_abbau, 
    (SELECT 
        aww_abbau.abbau_id, 
        ST_Centroid(ST_Collect(aww_abbau.wkb_geometry)) AS wkb_geometry
    FROM 
        aww_abbau
    GROUP BY 
        aww_abbau.abbau_id) AS centro, 
    (SELECT 
        aww_abbau_abbaumenge.abbau_id, 
        to_char(sum(aww_abbau_abbaumenge.menge) / "numeric"(count(aww_abbau_abbaumenge.menge)) / 1000::numeric, '9999999'::text) AS schnitt
    FROM 
        aww_abbau_abbaumenge
    WHERE 
        "numeric"(aww_abbau_abbaumenge.jahr) > 1998::numeric 
        AND 
        "numeric"(aww_abbau_abbaumenge.jahr) <= 2002::numeric
    GROUP BY 
        aww_abbau_abbaumenge.abbau_id) AS abbaumenge
WHERE 
    abbaumenge.abbau_id = aww_abbau.abbau_id 
    AND
    aww_abbau.archive = 0 
    AND 
    aww_abbau.abbau_id = centro.abbau_id
;
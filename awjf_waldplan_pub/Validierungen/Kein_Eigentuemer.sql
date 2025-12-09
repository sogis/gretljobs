-- Gibt die Liegenschaftsflächen an, wo kein Eigentümer erfasst wurde, welche aber von Waldfläche (Waldfunktion) überdeckt werden.
SELECT 
    lg.egris_egrid AS egrid,
    ll.geometrie
FROM 
    agi_dm01avso24.liegenschaften_grundstueck AS lg
LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft AS ll
    ON lg.t_id = ll.liegenschaft_von
LEFT JOIN awjf_waldplan_v2.waldplan_waldeigentum AS wei
    ON lg.egris_egrid = wei.egrid
WHERE 
    wei.eigentuemer IS NULL
    AND EXISTS (
        SELECT
        	1
        FROM
        	awjf_waldplan_v2.waldplan_waldfunktion AS wf
        WHERE
        	ST_Intersects(ll.geometrie, wf.geometrie)
          AND
          	ST_Area(ST_Intersection(ll.geometrie, wf.geometrie)) > 1  -- min. 1 m²
    )
;
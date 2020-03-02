SELECT 
    c.t_id, 
    c.geometrie, 
    c.flaechenmass, 
    c.gem_bfs AS bfs_nr, 
    c.numpos, 
    d.nummer,
    liegen_in_mutation.mutation
FROM 
(
    SELECT 
        a.t_id, 
        a.liegenschaft_von, 
        a.nummerteilgrundstueck, 
        ST_CurveToLine(a.geometrie, 0.002, 1, 1) AS geometrie,
        a.flaechenmass, 
        a.gem_bfs, 
        b.numpos
    FROM 
    ( 
        SELECT 
            t_id, 
            liegenschaft_von, 
            nummerteilgrundstueck, 
            geometrie, 
            flaechenmass, 
            CAST(t_datasetname AS INTEGER) AS gem_bfs
        FROM 
            agi_dm01avso24.liegenschaften_liegenschaft 
    ) AS a, 
    ( 
        SELECT 
            liegenschaften_grundstueckpos.grundstueckpos_von, 
            ST_AsText(ST_Union(ST_Multi(liegenschaften_grundstueckpos.pos))) AS numpos
        FROM 
            agi_dm01avso24.liegenschaften_grundstueckpos 
        GROUP BY 
            liegenschaften_grundstueckpos.grundstueckpos_von
    ) AS b
    WHERE 
        a.liegenschaft_von = b.grundstueckpos_von
) AS c
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck d
    ON d.t_id = c.liegenschaft_von
    LEFT JOIN 
    (
        SELECT 
            DISTINCT ON (liegen.t_id)
            liegen.t_id,
            CAST('TRUE' AS BOOLEAN) AS mutation
        FROM 
            agi_dm01avso24.liegenschaften_liegenschaft as liegen, 
            agi_dm01avso24.liegenschaften_projliegenschaft as proj
        WHERE 
            liegen.geometrie && proj.geometrie
            AND 
            ST_Distance(ST_PointOnSurface(ST_Buffer(liegen.geometrie,0)), proj.geometrie) = 0
        
        UNION ALL
            
        SELECT
            t_id,
            CAST('FALSE' AS BOOLEAN) AS mutation
        FROM
        (
        SELECT
            liegen.t_id
        FROM
            agi_dm01avso24.liegenschaften_liegenschaft AS liegen
        
        EXCEPT
        
        SELECT 
            DISTINCT ON (liegen.t_id)
            liegen.t_id
        FROM 
            agi_dm01avso24.liegenschaften_liegenschaft as liegen, 
            agi_dm01avso24.liegenschaften_projliegenschaft as proj
        WHERE 
            liegen.geometrie && proj.geometrie
            AND 
            ST_Distance(ST_PointOnSurface(ST_Buffer(liegen.geometrie,0)), proj.geometrie) = 0
        ) AS mutation_true
    ) AS liegen_in_mutation
    ON liegen_in_mutation.t_id = c.t_id


SELECT
    pos.t_id,
    pos.hali AS hali_txt,
    pos.vali AS vali_txt,
    pos.groesse AS groesse_txt,
    ST_CurveToLine(pos.hilfslinie, 0.002, 1, 1) AS hilfslinie,
    pos.pos,
    ST_X(pos) AS y,
    ST_Y(pos) AS x,
    CASE
        WHEN pos.ori IS NULL THEN 0::double precision 
        ELSE (100::double precision - pos.ori)*0.9::double precision 
    END AS rot,
    grundstueck.nummer,
    CASE
        WHEN grundstueck.art = 'Liegenschaft' THEN 0
        ELSE 1
    END AS art,
    CAST('false' AS BOOLEAN) AS mutation,
    CAST(pos.t_datasetname AS INTEGER) AS bfs_nr
FROM
    agi_dm01avso24.liegenschaften_grundstueckpos AS pos
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
    ON pos.grundstueckpos_von = grundstueck.t_id  
;
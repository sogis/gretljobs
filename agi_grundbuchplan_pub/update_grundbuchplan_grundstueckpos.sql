UPDATE
    agi_grundbuchplan_pub_v1.grundbuchplan_grundstueckpos
SET
    mutation = TRUE
WHERE
    t_id IN ( 
        SELECT
            bar.t_id
        FROM
            (
                SELECT
                    ST_SnapToGrid((ST_DumpPoints(ST_GeomFromText(numpos, 2056))).geom, 0.001) AS geom,
                    bfs_nr
                FROM
                    agi_grundbuchplan_pub_v1.grundbuchplan_liegenschaft
                WHERE
                    mutation = true
            ) AS foo
            INNER JOIN agi_grundbuchplan_pub_v1.grundbuchplan_grundstueckpos AS bar
            ON (bar.bfs_nr = foo.bfs_nr AND ST_Equals(foo.geom, ST_SnapToGrid(bar.pos, 0.001)))
)
;

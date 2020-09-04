WITH 
    strassen AS (
        SELECT 
            ST_Union(geometrie) as geometrie, 
            strassenstueck_von
        FROM 
            agi_dm01avso24.gebaeudeadressen_strassenstueck
        GROUP BY 
            strassenstueck_von
    ),
    hausnummern AS ( 
        SELECT 
            t_id,
            hausnummerpos_von, 
            pos, 
            CAST(t_datasetname AS INT) AS gem_bfs
        FROM 
            agi_dm01avso24.gebaeudeadressen_hausnummerpos
    )

SELECT 
    gebaeudeadressen_lokalisationsname.atext AS strname,
    gebaeudeadressen_gebaeudeeingang.hausnummer, 
    hausnummern.t_id AS hausnummerpos_tid,
    gebaeudeadressen_gebaeudeeingang.t_id AS gebaeudeeingang_tid,
    gebaeudeadressen_gebaeudeeingang.gebaeudeeingang_von AS lok_tid, 
    ST_ShortestLine(hausnummern.pos, strassen.geometrie) AS geometrie, 
    hausnummern.gem_bfs,
    now() AS datum
FROM 
    hausnummern
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_gebaeudeeingang
        ON gebaeudeadressen_gebaeudeeingang.t_id = hausnummern.hausnummerpos_von
    LEFT JOIN strassen
        ON strassen.strassenstueck_von = gebaeudeadressen_gebaeudeeingang.gebaeudeeingang_von
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsname
        ON gebaeudeadressen_lokalisationsname.benannte = gebaeudeadressen_gebaeudeeingang.gebaeudeeingang_von
;

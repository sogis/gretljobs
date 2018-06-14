WITH 
    strassen AS (
        SELECT 
            ST_Union(geometrie) as geometrie, 
            strassenstueck_von
        FROM 
            av_avdpool_ng.gebaeudeadressen_strassenstueck

        GROUP BY 
            strassenstueck_von
    ),
    hausnummern AS ( 
        SELECT 
            tid, 
            hausnummerpos_von, 
            pos, 
            gem_bfs
        FROM 
            av_avdpool_ng.gebaeudeadressen_hausnummerpos
    )

SELECT 
    gebaeudeadressen_lokalisationsname."text" AS strname, 
    gebaeudeadressen_gebaeudeeingang.hausnummer, 
    hausnummern.tid AS a_tid, 
    gebaeudeadressen_gebaeudeeingang.tid AS b_tid, 
    gebaeudeadressen_gebaeudeeingang.gebaeudeeingang_von AS lok_tid, 
    ST_ShortestLine(hausnummern.pos, strassen.geometrie) AS geometrie, 
    hausnummern.gem_bfs,
    now() AS datum
FROM 
    hausnummern
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebaeudeeingang
        ON gebaeudeadressen_gebaeudeeingang.tid = hausnummern.hausnummerpos_von
    LEFT JOIN strassen
        ON strassen.strassenstueck_von = gebaeudeadressen_gebaeudeeingang.gebaeudeeingang_von
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsname
        ON gebaeudeadressen_lokalisationsname.benannte = gebaeudeadressen_gebaeudeeingang.gebaeudeeingang_von
;

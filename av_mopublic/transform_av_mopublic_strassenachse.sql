SELECT
    n."text" AS strassenname,
    str.ordnung,
    str.gem_bfs AS bfs_nr,
    str.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    str.geometrie
FROM
    av_avdpool_ng.gebaeudeadressen_strassenstueck AS str 
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisation AS l 
    ON str.strassenstueck_von = l.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsname AS n 
    ON n.benannte = l.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebnachfuehrung AS nf 
    ON nf.tid = l.entstehung;
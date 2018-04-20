SELECT
    name."text" AS strassenname,
    strasse.ordnung,
    strasse.gem_bfs AS bfs_nr,
    strasse.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    strasse.geometrie
FROM
    av_avdpool_ng.gebaeudeadressen_strassenstueck AS strasse
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisation AS lokalisation
        ON strasse.strassenstueck_von = lokalisation.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsname AS name
        ON name.benannte = lokalisation.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebnachfuehrung AS nachfuehrung 
        ON nachfuehrung.tid = lokalisation.entstehung
;
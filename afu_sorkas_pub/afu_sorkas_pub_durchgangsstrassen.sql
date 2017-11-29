SELECT
    gid AS t_id,
    achseid,
    achsname,
    achsnummer,
    achstyp,
    achstypnam,
    eigentueme,
    enddistanz,
    laenge,
    modified,
    modifiedby,
    segmentid,
    segmentnr,
    startdista,
    ogc_fid,
    durchg,
    the_geom AS geometrie
FROM
    sorkas.durchgangsstrassen
WHERE
    archive = 0
;
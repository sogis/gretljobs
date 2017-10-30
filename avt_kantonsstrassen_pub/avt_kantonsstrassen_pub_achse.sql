SELECT
    wkb_geometry AS geometrie,
    achseguid,
    achseid,
    achsname,
    achsnummer,
    achssegmen,
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
    ogc_fid AS t_id
FROM
    avt_ktstr.kantonsstrassen_achsen
WHERE
    "archive" = 0;
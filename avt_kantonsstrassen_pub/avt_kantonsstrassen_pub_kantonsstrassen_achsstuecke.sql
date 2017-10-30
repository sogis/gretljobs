SELECT
    id AS t_id,
    geom AS geometrie,
    "name",
    lokalisati,
    strassenst,
    ordnung,
    istachse,
    gem_bfs,
    los,
    plz_ortsch,
    sostrid,
    eid,
    ogc_fid,
    abschnitti,
    achseid,
    achsname,
    achsnummer,
    achstyp,
    achstypnam,
    code
FROM
    strassennetz.kantonsstrassen_def
WHERE
    "archive" = 0;
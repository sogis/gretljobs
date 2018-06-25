SELECT
    max(id) AS t_id,
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
    max(ogc_fid),
    max(abschnitti),
    achseid,
    achsname,
    achsnummer,
    achstyp,
    achstypnam,
    max(code)
FROM
    strassennetz.kantonsstrassen_def
WHERE
    archive = 0
GROUP BY
    geometrie,
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
    achseid,
    achsname,
    achsnummer,
    achstyp,
    achstypnam
;
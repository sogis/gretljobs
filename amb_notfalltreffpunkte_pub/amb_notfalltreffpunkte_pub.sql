SELECT
    a.t_id, 
    a.t_ili_tid, 
    a.bezeichnung,
    a.einzugsgebiet, 
    a.rfs, 
    a.einwohner,
    a.art,
    b.str_name, 
    b.hausnummer, 
    b.plz4 AS plz, 
    b.ortschaft, 
    a.url, 
    a.geometrie
FROM 
    amb_notfalltreffpunkte.notfalltreffpnkte_treffpunkt a 
    LEFT JOIN (
        SELECT DISTINCT ON (gwr_egid_geom) 
            str_name, 
            hausnummer, 
            plz4, 
            ortschaft, 
            gwr_egid_geom 
        FROM adressen.adressen 
        WHERE ARCHIVE = 0
    ) b 
        ON st_dwithin(a.geometrie,b.gwr_egid_geom,0);
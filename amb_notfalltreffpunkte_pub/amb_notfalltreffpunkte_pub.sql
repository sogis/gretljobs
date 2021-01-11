SELECT
    a.t_id, 
    a.t_ili_tid, 
    a.bezeichnung,
    a.einzugsgebiet, 
    a.rfs, 
    a.einwohner,
    a.art,
    coalesce(b.str_name,'unbekannt') AS strasse, 
    coalesce(b.hausnummer,'unbekannt') AS hausnummer, 
    coalesce(b.plz4, 0) AS plz, 
    coalesce(b.ortschaft, 'unbekannt') AS ort, 
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
	    AND 
	       ((plz4 >= '2000') AND (plz4 <= '6000'))
    ) b 
        ON st_dwithin(a.geometrie,b.gwr_egid_geom,0);
